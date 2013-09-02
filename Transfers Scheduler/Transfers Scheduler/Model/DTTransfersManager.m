//
//  DTTransfersManager.m
//  Transfers Scheduler
//
//  Created by Diogo Tridapalli on 9/2/13.
//  Copyright (c) 2013 Diogo Tridapalli. All rights reserved.
//

#import "DTTransfersManager.h"


static NSString *const DTTransfersManagerFile = @"transfer.data";

@interface DTTransfersManager ()

@property (nonatomic, strong) NSString *storagePath;

@end

@implementation DTTransfersManager

#pragma mark - memory management

+ (DTTransfersManager *)sharedManager
{
    static dispatch_once_t onceToken;
    static DTTransfersManager *manager = nil;

    dispatch_once(&onceToken, ^{
        manager = [[DTTransfersManager alloc] init];
    });

    return manager;
}

- (id)init
{
    self = [super init];
    if (self) {
        _storagePath = [[LibraryDirectory stringByAppendingPathComponent:DTTransfersManagerFile] retain];
    }
    return self;
}

- (void)dealloc
{
    [_storagePath release], _storagePath = nil;
    [super dealloc];
}
#pragma mark - public methods

- (NSArray *)loadTransfers
{
    NSArray *transfers = [NSKeyedUnarchiver unarchiveObjectWithFile:self.storagePath];


    if (transfers == nil) {
        transfers = @[];
        DTLog(@"No transfers to load.");
    } else {
        DTLog(@"Loaded %d transfers.", [transfers count]);
    }

    return transfers;
}

- (void)saveTransfers:(NSArray *)transfers
{
    BOOL ok = [NSKeyedArchiver archiveRootObject:transfers toFile:self.storagePath];

    if (!ok) {
        DTLog(@"Error while saving transfers!");
    } else {
        DTLog(@"Transfers saved with success!");
    }
}

- (void)deleteTransfers
{
    NSError *error;
    BOOL success = [[NSFileManager defaultManager] removeItemAtPath:self.storagePath error:&error];
    if (!success) {
        NSLog(@"Error removing document path: %@", error.localizedDescription);
    }
 
}

@end
