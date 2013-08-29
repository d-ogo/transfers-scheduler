//
//  DTTypePickerView.m
//  Transfers Scheduler
//
//  Created by Diogo Tridapalli on 9/1/13.
//  Copyright (c) 2013 Diogo Tridapalli. All rights reserved.
//

typedef NS_ENUM(NSInteger, DTTypePickerComponent) {
    DTTypePickerComponentType = 0,
    DTTypePickerComponents
};

#import "DTTypePickerView.h"

static const NSInteger DTTypePickerRowIndexShift = 1;

@implementation DTTypePickerView

#pragma mark - memory managemten

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configure];
    }
    return self;
}

- (id)init
{
    return [self initWithFrame:CGRectMake(0, 0, 360, 100)];
}

- (void)configure
{
    self.delegate = self;
    self.showsSelectionIndicator = YES;
}

- (void)dealloc
{
    self.didSelectedRowBlock = nil;
    [super dealloc];
}



#pragma mark - public methods

- (DTTransferType)selectedType
{
    NSInteger selected = [self selectedRowInComponent:DTTypePickerComponentType];    
    DTTransferType type = selected + DTTypePickerRowIndexShift;

    return type;
}

- (void)setType:(DTTransferType)type animated:(BOOL)animated
{
    [self selectRow:type - DTTypePickerRowIndexShift
        inComponent:DTTypePickerComponentType
           animated:animated];
}

+ (NSString *)stringForType:(DTTransferType)type
{
    NSString *title = nil;

    switch (type) {
        case DTTransferTypeA:
            title = NSLocalizedString(@"Type A", nil);
            break;
        case DTTransferTypeB:
            title = NSLocalizedString(@"Type B", nil);
            break;
        case DTTransferTypeC:
            title = NSLocalizedString(@"Type C", nil);
            break;
        case DTTransferTypeD:
            title = NSLocalizedString(@"Type D", nil);
            break;
        case DTTransferTypeUndefined:
        default:
            title = NSLocalizedString(@"Undefined type", nil);
            break;
    }

    return title;
}


#pragma mark - UIPickerViewDataSource methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return DTTypePickerComponents;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return DTTransferTypeD;
}

#pragma mark - UIPickerViewDelegate methods

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    return [DTTypePickerView stringForType:(row + DTTypePickerRowIndexShift)];
}

- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component
{
    if (self.didSelectedRowBlock)
        self.didSelectedRowBlock(row+DTTypePickerRowIndexShift);
}

@end
