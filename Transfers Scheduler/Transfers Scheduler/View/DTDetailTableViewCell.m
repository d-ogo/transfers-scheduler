//
//  DTDetailTableViewCell.m
//  Transfers Scheduler
//
//  Created by Diogo Tridapalli on 8/29/13.
//  Copyright (c) 2013 Diogo Tridapalli. All rights reserved.
//

#import "DTDetailTableViewCell.h"

@implementation DTDetailTableViewCell

#pragma mark - memory management

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    return [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
}

- (void)dealloc
{
    [_customView release], _customView = nil;

    [super dealloc];
}

#pragma mark - getters and setters

- (void)setCustomView:(UIView *)customView
{
    if (_customView != customView) {

        [_customView removeFromSuperview];
        [_customView autorelease];

        CGFloat dx = 12;
        CGFloat dy = 5;

        CGRect frame = CGRectInset(self.bounds, dx, dy);

        _customView = [customView retain];
        _customView.frame = frame;
        _customView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self addSubview:_customView];
    }
}

@end
