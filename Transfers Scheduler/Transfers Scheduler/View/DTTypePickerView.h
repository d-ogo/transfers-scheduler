//
//  DTTypePickerView.h
//  Transfers Scheduler
//
//  Created by Diogo Tridapalli on 9/1/13.
//  Copyright (c) 2013 Diogo Tridapalli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTTransfer.h"

@interface DTTypePickerView : UIPickerView <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) void(^didSelectedRowBlock)(DTTransferType type);

- (DTTransferType)selectedType;
- (void)setType:(DTTransferType)type animated:(BOOL)animated;
+ (NSString *)stringForType:(DTTransferType)type;

@end
