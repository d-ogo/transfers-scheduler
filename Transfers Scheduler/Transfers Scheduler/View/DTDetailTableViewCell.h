//
//  DTDetailTableViewCell.h
//  Transfers Scheduler
//
//  Created by Diogo Tridapalli on 8/29/13.
//  Copyright (c) 2013 Diogo Tridapalli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DTDetailTableViewCell : UITableViewCell

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier;

@property (nonatomic, strong) UIView *customView;

@end
