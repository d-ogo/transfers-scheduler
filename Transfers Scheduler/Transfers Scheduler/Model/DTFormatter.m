//
//  DTFormatter.m
//  Transfers Scheduler
//
//  Created by Diogo Tridapalli on 9/1/13.
//  Copyright (c) 2013 Diogo Tridapalli. All rights reserved.
//

#import "DTFormatter.h"

@implementation DTFormatter

+ (NSDateFormatter *)dateFormatter
{
    static dispatch_once_t onceToken;
    static NSDateFormatter *dateFormatter = nil;

    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        [dateFormatter setDateStyle:NSDateFormatterLongStyle];
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    });

    return dateFormatter;
}

+ (NSNumberFormatter *)numberFormatter
{
    static dispatch_once_t onceToken;
    static NSNumberFormatter *numberFormatter = nil;

    dispatch_once(&onceToken, ^{
        numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        //    [self.numberFormatter setMaximumFractionDigits:2];
    });

    return numberFormatter;
}


@end
