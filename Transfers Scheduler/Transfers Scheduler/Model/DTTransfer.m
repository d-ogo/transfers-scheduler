//
//  DTTransfer.m
//  Transfers Scheduler
//
//  Created by Diogo Tridapalli on 8/27/13.
//  Copyright (c) 2013 Diogo Tridapalli. All rights reserved.
//

#import "DTTransfer_private.h"

@implementation DTTransfer

#pragma mark - memory management

- (void)dealloc
{
    [_origin release], _origin = nil;
    [_destination release], _destination = nil;
    [_creationDate release], _creationDate = nil;
    [_scheduledDate release], _scheduledDate = nil;
    [super dealloc];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@" Origin: %@\n Destination %@\n Creation %@\n Scheduled %@\n Type %i\n value %f\n tax %f",
            self.origin,
            self.destination,
            self.creationDate,
            self.scheduledDate,
            self.type,
            self.value,
            self.tax];
}

#pragma mark - tax calculations

- (double)tax
{
    double taxValue = 0.0;
    switch (self.type) {
        case DTTransferTypeA:
            taxValue = [self taxTypeA];
            break;
        case DTTransferTypeB:
            taxValue = [self taxTypeB];
            break;
        case DTTransferTypeC:
            taxValue = [self taxTypeC];
            break;
        case DTTransferTypeD:
            taxValue = [self taxTypeD];
            break;
        case DTTransferTypeUndefined:
        default:
            taxValue = 0.0;
            break;
    }
    return taxValue;
}

- (double)taxTypeA
{
    NSInteger days = [self daysToScheduledDate:self.scheduledDate
                              fromCreationDate:self.creationDate];

    if (days == NSNotFound || days < 0)
        return 0.0;

    return [self taxTypeA:self.value];
}

- (double)taxTypeA:(double)value
{
    static const double fix = 2.0;
    static const double variable = 0.03;

    double tax = 0.0;

    if (value > 0.0)
        tax = fix + value * variable;

    return tax;
}

- (double)taxTypeB
{
    NSInteger days = [self daysToScheduledDate:self.scheduledDate
                              fromCreationDate:self.creationDate];
    return [self taxTypeB:self.value daysToExecution:days];
}

- (double)taxTypeB:(double)value daysToExecution:(NSInteger)days
{
    static const NSInteger limitDay = 30;
    static const NSInteger minimumDays = 0;
    static const double minimumValue = 0.0;
    static const double tax1 = 10.0;
    static const double tax2 = 8.0;

    double taxValue = 0.0;

    if (days == NSNotFound)
        return taxValue;

    if ( value > minimumValue && days >= minimumDays )
        taxValue = days > limitDay ? tax2 : tax1;

    return taxValue;
}

- (double)taxTypeC
{
    NSInteger days = [self daysToScheduledDate:self.scheduledDate
                              fromCreationDate:self.creationDate];
    return [self taxTypeC:self.value daysToExecution:days];
}

- (double)taxTypeC:(double)value daysToExecution:(NSInteger)days
{
    static const double minimumValue = 0.0;
    static const NSUInteger N = 7;
    static NSInteger dayLimits[] = {  30,  25,  20,  15,  10,  05,  -1};
    static double tax[]          = {.012,.021,.043,.054,.067,.074,.083};

    double taxValue = 0.0;

    if (days == NSNotFound)
        return taxValue;

    value = value > minimumValue ? value : minimumValue;

    for (NSInteger i = 0; i<N; ++i) {
        if (days > dayLimits[i]){
            taxValue = tax[i]*value;
            break;
        }
    }
    
    return taxValue;
}

- (double)taxTypeD
{
    NSInteger days = [self daysToScheduledDate:self.scheduledDate
                              fromCreationDate:self.creationDate];
    return [self taxTypeD:self.value daysToExecution:days];
}

- (double)taxTypeD:(double)value daysToExecution:(NSInteger)days
{
    DTTransferType type = [self typeForTransferDofValue:value];
    double taxValue = 0.0;

    switch (type) {
        case DTTransferTypeA:
            taxValue = [self taxTypeA:value];
            break;
        case DTTransferTypeB:
            taxValue = [self taxTypeB:value daysToExecution:days];
            break;
        case DTTransferTypeC:
            taxValue = [self taxTypeC:value daysToExecution:days];
            break;
        case DTTransferTypeD:
        case DTTransferTypeUndefined:
        default:
            taxValue = 0.0;
    }
    return taxValue;
}

- (DTTransferType)typeForTransferDofValue:(double)value
{
    static const NSUInteger N = 3;
    static double valueLimits[] = { 120000., 25000., 0 };
    static DTTransferType types[] = {DTTransferTypeC, DTTransferTypeB, DTTransferTypeA};

    DTTransferType type = DTTransferTypeUndefined;

    for (NSUInteger i = 0; i<N; ++i) {
        if (value > valueLimits[i]) {
            type = types[i];
            break;
        }
    }

    return type;
}


#pragma mark - helpers

- (NSInteger)daysToScheduledDate:(NSDate *)scheduledDate
                fromCreationDate:(NSDate *)creationDate
{    
    if (scheduledDate == nil || creationDate == nil)
        return NSNotFound;

    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];

    NSInteger startDay = [calendar ordinalityOfUnit:NSDayCalendarUnit
                                             inUnit:NSEraCalendarUnit
                                            forDate:creationDate];

    NSInteger endDay = [calendar ordinalityOfUnit:NSDayCalendarUnit
                                           inUnit:NSEraCalendarUnit
                                          forDate:scheduledDate];
    [calendar release];

    if (startDay == NSNotFound)
        return startDay;

    if (endDay == NSNotFound)
        return endDay;


    return endDay - startDay;
}

@end
