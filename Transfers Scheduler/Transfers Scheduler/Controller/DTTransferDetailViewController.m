//
//  DTTransferDetailViewController.m
//  Transfers Scheduler
//
//  Created by Diogo Tridapalli on 8/29/13.
//  Copyright (c) 2013 Diogo Tridapalli. All rights reserved.
//

#import "DTTransferDetailViewController.h"
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

@interface DTTransferDetailViewController ()

@end

@implementation DTTransferDetailViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

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
#warning TODO custom cells
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }

    NSString *text = nil;
    
    switch (indexPath.section) {
        case DTTransferDetailSectionOrigin:
            text = self.transfer.origin;
            break;
        case DTTransferDetailSectionDestination:
            text = self.transfer.destination;
            break;
        case DTTransferDetailSectionScheduled:
            text = [self.transfer.scheduledDate description];
            break;
        case DTTransferDetailSectionCreated:
            text = [self.transfer.creationDate description];
            break;
        case DTTransferDetailSectionType:
            text = [NSString stringWithFormat:@"%d", self.transfer.type];
            break;
        case DTTransferDetailSectionValue:
            text = [NSString stringWithFormat:@"$ %.2f", self.transfer.value];
            break;
        case DTTransferDetailSectionTax:
            text = [NSString stringWithFormat:@"$ %.2f", self.transfer.tax];
            break;
        default:
            text = nil;
            break;
    }

    cell.textLabel.text = text;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
#warning TODO enable selection and edition
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

@end
