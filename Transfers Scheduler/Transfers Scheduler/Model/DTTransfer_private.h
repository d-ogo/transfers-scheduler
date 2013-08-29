//
//  DTTransfer_private.h
//  Transfers Scheduler
//
//  Created by Diogo Tridapalli on 8/27/13.
//  Copyright (c) 2013 Diogo Tridapalli. All rights reserved.
//

#import "DTTransfer.h"

@interface DTTransfer ()

- (NSInteger)daysToScheduledDate:(NSDate *)scheduledDate
                fromCreationDate:(NSDate *)creationDate;

- (double)taxTypeA:(double)value;
- (double)taxTypeB:(double)value daysToExecution:(NSInteger)days;
- (double)taxTypeC:(double)value daysToExecution:(NSInteger)days;
- (double)taxTypeD:(double)value daysToExecution:(NSInteger)days;

- (DTTransferType)typeForTransferDofValue:(double)value;

@end
