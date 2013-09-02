//
//  DTTransfersManager.h
//  Transfers Scheduler
//
//  Created by Diogo Tridapalli on 9/2/13.
//  Copyright (c) 2013 Diogo Tridapalli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DTTransfersManager : NSObject

+ (DTTransfersManager *)sharedManager;
- (NSArray *)loadTransfers;
- (void)saveTransfers:(NSArray *)transfers;
- (void)deleteTransfers;

@end
