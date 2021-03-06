//
//  DTTransferDetailViewController.h
//  Transfers Scheduler
//
//  Created by Diogo Tridapalli on 8/29/13.
//  Copyright (c) 2013 Diogo Tridapalli. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DTTransfer;

@interface DTTransferDetailViewController : UITableViewController <UITextFieldDelegate>

@property (nonatomic, strong) DTTransfer *transfer;

+ (instancetype)viewControllerWithTransfer:(DTTransfer *)tranfer;
+ (instancetype)editableViewControllerWithCompletionBlock:(void (^)(DTTransfer *transfer))block;

@end
