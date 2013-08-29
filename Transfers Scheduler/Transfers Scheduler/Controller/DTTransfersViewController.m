//
//  DTTransfersViewController.m
//  Transfers Scheduler
//
//  Created by Diogo Tridapalli on 8/29/13.
//  Copyright (c) 2013 Diogo Tridapalli. All rights reserved.
//

#import "DTTransfersViewController.h"
#import "DTTransferDetailViewController.h"
#import "DTTransfer.h"

@interface DTTransfersViewController ()

@property (nonatomic, strong) NSMutableArray *transfers;

@end

@implementation DTTransfersViewController

#pragma mark - memory management

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {

    }
    return self;
}

- (void)dealloc
{
    [_transfers release], _transfers = nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - view management

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"Transfers";

    _transfers = [[NSMutableArray alloc] initWithCapacity:10];

    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                       target:self
                                                       action:@selector(addTransfer)];

    self.navigationItem.rightBarButtonItem = addButton;
}

#pragma mark - 

- (void)addTransfer
{
#warning TODO custom add
    DTTransfer *tranfer = [[DTTransfer alloc] init];
    tranfer.origin = @"12345-6";
    tranfer.destination = @"23456-7";
    tranfer.creationDate = [NSDate date];
    tranfer.scheduledDate = [NSDate date];
    tranfer.type = DTTransferTypeA;
    tranfer.value = 15;

    [self.transfers addObject:tranfer];

    [tranfer release];

    [self.tableView reloadData];
}

- (void)removeTransferAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;

    [self.transfers removeObjectAtIndex:row];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.transfers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }

    DTTransfer *transfer = self.transfers[indexPath.row];

#warning TODO custom cell
    cell.textLabel.text = [transfer.scheduledDate description];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"$ %.2f", transfer.value];
    return cell;
}



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self removeTransferAtIndexPath:indexPath];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DTTransferDetailViewController *controller = [[DTTransferDetailViewController alloc] initWithNibName:@"DTTransferDetailViewController" bundle:nil];
    controller.transfer = self.transfers[indexPath.row];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

@end
