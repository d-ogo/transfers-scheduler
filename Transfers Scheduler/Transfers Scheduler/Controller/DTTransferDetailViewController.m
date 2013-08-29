//
//  DTTransferDetailViewController.m
//  Transfers Scheduler
//
//  Created by Diogo Tridapalli on 8/29/13.
//  Copyright (c) 2013 Diogo Tridapalli. All rights reserved.
//

#import "DTTransferDetailViewController.h"
#import "DTDetailTableViewCell.h"
#import "DTTypePickerView.h"
#import "DTTransfer.h"

typedef NS_ENUM(NSInteger, DTTransferDetailSection) {
    DTTransferDetailSectionOrigin = 0,
    DTTransferDetailSectionDestination,
    DTTransferDetailSectionScheduled,
    DTTransferDetailSectionCreated,
    DTTransferDetailSectionType,
    DTTransferDetailSectionValue,
    DTTransferDetailSectionTax,
    DTTransferDetailSections
};

static NSString *const DTTransferCellIdentifierCellIdentifierAccount = @"Account";
static NSString *const DTTransferCellIdentifierCellIdentifierDate = @"Date";
static NSString *const DTTransferCellIdentifierCellIdentifierType = @"Type";
static NSString *const DTTransferCellIdentifierCellIdentifierValue = @"Value";
static NSString *const DTTransferCellIdentifierCellIdentifierNone = @"None";

@interface DTTransferDetailViewController ()

@property (nonatomic, copy) void(^completionBlock)(DTTransfer *transfer);
@property (nonatomic, assign) BOOL editable;

@property (atomic, assign) UITextField *textFieldOrigin;
@property (atomic, assign) UITextField *textFieldDestination;
@property (atomic, assign) UITextField *textFieldCreationDate;
@property (atomic, assign) UITextField *textFieldScheduledDate;
@property (atomic, assign) UITextField *textFieldType;
@property (atomic, assign) UITextField *textFieldValue;
@property (atomic, assign) UITextField *textFieldTax;

@property (nonatomic, strong) NSNumberFormatter *numberFormatter;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;


@end

@implementation DTTransferDetailViewController

#pragma mark - memory management

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

+ (instancetype)viewControllerWithTransfer:(DTTransfer *)tranfer
{
    DTTransferDetailViewController *controller =  [[[self class] alloc] initWithNibName:@"DTTransferDetailViewController" bundle:nil];
    controller.transfer = tranfer;
    controller.editable = NO;
    return [controller autorelease];
}

+ (instancetype)editableViewControllerWithCompletionBlock:(void (^)(DTTransfer *))block
{
    DTTransferDetailViewController *controller =  [[[self class] alloc] initWithNibName:@"DTTransferDetailViewController" bundle:nil];
    controller.editable = YES;

    DTTransfer *transfer = [[DTTransfer alloc] init];
    transfer.creationDate = [NSDate date];
    transfer.scheduledDate = [NSDate date];
    controller.transfer = transfer;
    [transfer release];

    controller.completionBlock = block;

    return [controller autorelease];
}

- (void)dealloc
{
    self.completionBlock = nil;
    [_transfer release], _transfer = nil;
    [_dateFormatter release], _dateFormatter = nil;
    [_numberFormatter release], _numberFormatter = nil;
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.numberFormatter = [[[NSNumberFormatter alloc] init] autorelease];
    [self.numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
//    [self.numberFormatter setMaximumFractionDigits:2];

    self.dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [self.dateFormatter setLocale:[NSLocale currentLocale]];
    [self.dateFormatter setDateStyle:NSDateFormatterLongStyle];
    [self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self action:@selector(tapOnTableView:)];
    [self.view addGestureRecognizer:tap];
    [tap release];


    if (self.editable) {
        UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                       target:self
                                       action:@selector(saveAndPop)];
        self.navigationItem.rightBarButtonItem = saveButton;
        [saveButton release];
    }
}


- (void)saveAndPop
{
    [self tapOnTableView:nil];

    if ([self transferIsValid] == NO){
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:NSLocalizedString(@"Warning", nil)
                              message:NSLocalizedString(@"Incomplete transfer data", nil)
                              delegate:nil
                              cancelButtonTitle:NSLocalizedString(@"OK", nil)
                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }

    if (self.completionBlock)
        self.completionBlock(self.transfer);

    self.completionBlock = nil;

    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)transferIsValid
{
    BOOL isValid = NO;

    isValid = [self originIsValid];
    isValid = isValid && [self destinationIsValid];
    isValid = isValid && [self typeIsValid];
    isValid = isValid && [self valueIsValid];
    return isValid;
}

- (BOOL)originIsValid
{
    return [self accountIsValid:self.transfer.origin];
}

- (BOOL)destinationIsValid
{
    return [self accountIsValid:self.transfer.destination];
}

- (BOOL)accountIsValid:(NSString *)account
{
    if (!account || ([account length] == 0) )
        return NO;

    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:@"\\d{5}-\\d"
                                  options:NSRegularExpressionAnchorsMatchLines
                                  error:nil];
    NSUInteger matches = [regex numberOfMatchesInString:account
                                                options:0
                                                  range:NSMakeRange(0, [account length])];

    return (matches == 1);
}

- (BOOL)typeIsValid
{
    return (self.transfer.type != DTTransferTypeUndefined);
}

- (BOOL)valueIsValid
{
    return (self.transfer.value > 0.0);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];


}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return DTTransferDetailSections;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = nil;

    switch (section) {
        case DTTransferDetailSectionOrigin:
            title = NSLocalizedString(@"Origin account", nil);
            break;
        case DTTransferDetailSectionDestination:
            title = NSLocalizedString(@"Destination account", nil);
            break;
        case DTTransferDetailSectionScheduled:
            title = NSLocalizedString(@"Scheduled date", nil);
            break;
        case DTTransferDetailSectionCreated:
            title = NSLocalizedString(@"Created date", nil);
            break;
        case DTTransferDetailSectionType:
            title = NSLocalizedString(@"Transfer type", nil);
            break;
        case DTTransferDetailSectionValue:
            title = NSLocalizedString(@"Value", nil);
            break;
        case DTTransferDetailSectionTax:
            title = NSLocalizedString(@"Tax", nil);
            break;
        default:
            title = nil;
            break;
    }

    return title;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 0;

    switch (section) {
        case DTTransferDetailSectionOrigin:
        case DTTransferDetailSectionDestination:
        case DTTransferDetailSectionScheduled:
        case DTTransferDetailSectionCreated:
        case DTTransferDetailSectionType:
        case DTTransferDetailSectionValue:
        case DTTransferDetailSectionTax:
            rows = 1;
            break;
        default:
            rows = 0;
            break;
    }

    return rows;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = [self cellIdentifierForSectionAtIndexPath:indexPath];

    DTDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if (cell == nil)
        cell = [self cellForSectionAtIndexPath:indexPath WithCellIdentifier:cellIdentifier];


    NSString *text = nil;

    //TODO: it's necessary to set the other textFields to nil in orther to prevent bugs
    switch (indexPath.section) {
        case DTTransferDetailSectionOrigin: {
            text = self.transfer.origin;
            self.textFieldOrigin = (UITextField *)cell.customView;
            break;
        }
        case DTTransferDetailSectionDestination: {
            text = self.transfer.destination;
            self.textFieldDestination = (UITextField *)cell.customView;
            break;
        }
        case DTTransferDetailSectionScheduled: {
            text =  [self.dateFormatter stringFromDate:self.transfer.scheduledDate];
            self.textFieldScheduledDate = (UITextField *)cell.customView;
            break;
        }
        case DTTransferDetailSectionCreated: {
            text = [self.dateFormatter stringFromDate:self.transfer.creationDate];
            self.textFieldCreationDate = (UITextField *)cell.customView;
            break;
        }
        case DTTransferDetailSectionType:
            text = [DTTypePickerView stringForType:self.transfer.type];
            self.textFieldType = (UITextField *)cell.customView;
            break;
        case DTTransferDetailSectionValue:
            text = [self stringWithCurrencyFromDouble:self.transfer.value];
            self.textFieldValue = (UITextField *)cell.customView;
            break;
        case DTTransferDetailSectionTax:
            text = [self stringWithCurrencyFromDouble:self.transfer.tax];
            self.textFieldTax = (UITextField *)cell.customView;
            break;
        default:
            text = nil;
            break;
    }

    ((UITextField*)cell.customView).text = text;

    return cell;
}

- (DTDetailTableViewCell *)cellForSectionAtIndexPath:(NSIndexPath *)indexPath
                            WithCellIdentifier:(NSString *)cellIdentifier
{
    DTDetailTableViewCell *cell = [[DTDetailTableViewCell alloc] initWithReuseIdentifier:cellIdentifier];

    switch (indexPath.section) {
        case DTTransferDetailSectionOrigin:
        case DTTransferDetailSectionDestination: {
            UITextField *textField = [[UITextField alloc] initWithFrame:cell.bounds];
            textField.autocorrectionType = UITextAutocorrectionTypeNo;
            textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            textField.textAlignment = NSTextAlignmentCenter;
            textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            textField.keyboardType = UIKeyboardTypeNumberPad;
            textField.returnKeyType = UIReturnKeyDone;
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            textField.placeholder = @"XXXXX-X";
            textField.delegate = self;
            cell.customView = textField;
            [textField release];
            break;
        }
        case DTTransferDetailSectionCreated:
        case DTTransferDetailSectionScheduled: {
            UITextField *textField = [[UITextField alloc] initWithFrame:cell.bounds];
            textField.autocorrectionType = UITextAutocorrectionTypeNo;
            textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            textField.textAlignment = NSTextAlignmentCenter;
            textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            textField.delegate = self;
            UIDatePicker *picker = [[UIDatePicker alloc] init];
            picker.locale = [NSLocale currentLocale];
            picker.calendar = [NSCalendar currentCalendar];
            picker.timeZone = [NSTimeZone localTimeZone];
            picker.datePickerMode = UIDatePickerModeDate;
            picker.minimumDate = [NSDate date];
            [picker addTarget:self
                       action:@selector(dateChoosed:)
             forControlEvents:UIControlEventValueChanged];
            textField.inputView = picker;
            cell.customView = textField;
            [picker release];
            [textField release];
            break;
        }
        case DTTransferDetailSectionType: {
            UITextField *textField = [[UITextField alloc] initWithFrame:cell.bounds];
            textField.autocorrectionType = UITextAutocorrectionTypeNo;
            textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            textField.textAlignment = NSTextAlignmentCenter;
            textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            textField.delegate = self;
            DTTypePickerView *picker = [[DTTypePickerView alloc] init];
            __block DTTransferDetailViewController *weakSelf = self;
            picker.didSelectedRowBlock = ^(DTTransferType type){
                [weakSelf typeChoosed:type];
            };
            textField.inputView = picker;
            cell.customView = textField;
            [picker release];
            [textField release];
            break;
        }
        case DTTransferDetailSectionValue:
        case DTTransferDetailSectionTax: {
            UITextField *textField = [[UITextField alloc] initWithFrame:cell.bounds];
            textField.autocorrectionType = UITextAutocorrectionTypeNo;
            textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            textField.textAlignment = NSTextAlignmentCenter;
            textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            textField.keyboardType = UIKeyboardTypeDecimalPad;
            textField.returnKeyType = UIReturnKeyDone;
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            textField.delegate = self;
            cell.customView = textField;
            [textField release];
            break;
        }
        default:
            break;
    }

    return [cell autorelease];
}

- (NSString *)cellIdentifierForSectionAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = nil;

    switch (indexPath.section) {
        case DTTransferDetailSectionOrigin:
        case DTTransferDetailSectionDestination:
            cellIdentifier = DTTransferCellIdentifierCellIdentifierAccount;
            break;
        case DTTransferDetailSectionCreated:
        case DTTransferDetailSectionScheduled:
            cellIdentifier = DTTransferCellIdentifierCellIdentifierDate;
            break;
        case DTTransferDetailSectionType:
            cellIdentifier = DTTransferCellIdentifierCellIdentifierType;
            break;
        case DTTransferDetailSectionValue:
        case DTTransferDetailSectionTax:
            cellIdentifier = DTTransferCellIdentifierCellIdentifierValue;
            break;
        default:
            cellIdentifier = DTTransferCellIdentifierCellIdentifierNone;
            break;
    }
    return [[cellIdentifier retain] autorelease];
}

#pragma mark - Table view delegate

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

#pragma mark - UITextFieldDelegate delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (self.editable == NO)
        return NO;

    if (textField == self.textFieldTax){
        [self tapOnTableView:nil];
        return NO;
    }
    if (textField == self.textFieldCreationDate){
        [self tapOnTableView:nil];
        return NO;
    }

    if (textField == self.textFieldType) {
        DTTypePickerView *picker = (DTTypePickerView *)textField.inputView;
        if (self.transfer.type == DTTransferTypeUndefined)
            [self typeChoosed:DTTransferTypeA];
        [picker setType:self.transfer.type animated:NO];
    }

    if (textField == self.textFieldScheduledDate) {
        UIDatePicker *picker = (UIDatePicker *)textField.inputView;
        picker.date = self.transfer.scheduledDate;
    }


    return YES;
}

- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string
{
    if (textField == self.textFieldDestination) {
        return [self accountTextField:textField
        shouldChangeCharactersInRange:range
                    replacementString:string];
    } else if (textField == self.textFieldOrigin) {
        return [self accountTextField:textField
        shouldChangeCharactersInRange:range
                    replacementString:string];
    } else if (textField == self.textFieldValue) {
        return [self valueTextField:textField
      shouldChangeCharactersInRange:range
                  replacementString:string];
    }
    return NO;
}

- (BOOL)valueTextField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
     replacementString:(NSString *)string
{
    BOOL isValid = NO;

    NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSNumber *number = [self.numberFormatter numberFromString:text];

    if (number)
        isValid = YES;

    if ([text isEqualToString:[self.numberFormatter currencySymbol]])
        isValid = YES;

    if (isValid)
        [self updateValue:number];


    return isValid;
}

- (BOOL)accountTextField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
       replacementString:(NSString *)string
{
    NSScanner *scanner = [NSScanner scannerWithString:string];
    BOOL isDigit = ([scanner scanInteger:NULL] && [scanner isAtEnd]);

    if ([string isEqualToString:@""] == NO && !isDigit)
        return NO;


    BOOL isValid = YES;

    NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];

    if ([text length] > 7)
        isValid = NO;

    if ([text length] == 5 && ![string isEqualToString:@""]) {
        textField.text = [text stringByAppendingString:@"-"];
        isValid = NO;
    }

    if ([text length] == 6 && ![string isEqualToString:@""]) {
        textField.text = [text stringByReplacingCharactersInRange:NSMakeRange(5, 0) withString:@"-"];
        isValid = NO;
    }

    if ([text length] == 6 && [string isEqualToString:@""]) {
        textField.text = [text stringByReplacingCharactersInRange:NSMakeRange(5, 1)
                                                       withString:@""];
        isValid = NO;
    }
    return isValid;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    if (textField == self.textFieldValue) {
        textField.text = [self.numberFormatter currencySymbol];
        [self updateValue:nil];
        return NO;
    }

    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.textFieldOrigin) {
        self.transfer.origin = textField.text;
    } else if (textField == self.textFieldDestination) {
        self.transfer.destination = textField.text;
    }
}

#pragma mark - value changed

- (void)dateChoosed:(UIControl *)control
{
    if (self.textFieldScheduledDate.inputView == control) {
        UIDatePicker *picker = (UIDatePicker *)control;
        self.textFieldScheduledDate.text = [self.dateFormatter stringFromDate:picker.date];
        self.transfer.scheduledDate = picker.date;
        [self updateTax];
    } else if (self.textFieldCreationDate.inputView == control) {
        UIDatePicker *picker = (UIDatePicker *)control;
        self.textFieldCreationDate.text = [self.dateFormatter stringFromDate:picker.date];
    }
}

- (void)typeChoosed:(DTTransferType)type
{
    self.textFieldType.text = [DTTypePickerView stringForType:type];
    self.transfer.type = type;
    [self updateTax];
}

- (void)updateValue:(NSNumber *)value
{
    self.transfer.value = [value doubleValue];
    [self updateTax];
}

- (void)updateTax
{
    NSIndexPath *taxIndexPath = [NSIndexPath indexPathForRow:0
                                                  inSection:DTTransferDetailSectionTax];
    [self.tableView reloadRowsAtIndexPaths:@[taxIndexPath]
                          withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - auxiliary methods

- (void)tapOnTableView:(UIGestureRecognizer *)gesture
{
    [self.view endEditing:YES];
}

- (NSString *)stringWithCurrencyFromDouble:(double)number
{
    NSString *numberAsString = [self.numberFormatter stringFromNumber:[NSNumber numberWithDouble:number]];
    return numberAsString;
}


@end
