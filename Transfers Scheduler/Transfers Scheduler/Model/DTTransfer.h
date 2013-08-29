//
//  DTTransfer.h
//  Transfers Scheduler
//
//  Created by Diogo Tridapalli on 8/27/13.
//  Copyright (c) 2013 Diogo Tridapalli. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, DTTransferType) {
    DTTransferTypeUndefined = 0,
    DTTransferTypeA,
    DTTransferTypeB,
    DTTransferTypeC,
    DTTransferTypeD
};

@interface DTTransfer : NSObject

@property (nonatomic, strong) NSString *origin;
@property (nonatomic, strong) NSString *destination;
@property (nonatomic, strong) NSDate *creationDate;
@property (nonatomic, strong) NSDate *scheduledDate;
@property (nonatomic, assign) DTTransferType type;
@property (nonatomic, assign) double value;
@property (nonatomic, readonly) double tax;

@end
