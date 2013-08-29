//
//  DTTransfer.m
//  Transfers Scheduler
//
//  Created by Diogo Tridapalli on 8/27/13.
//  Copyright (c) 2013 Diogo Tridapalli. All rights reserved.
//

#import "DTTransferTests.h"
#import "DTTransfer_private.h"

@interface DTTransferTests ()

@property (nonatomic, strong) DTTransfer *transfer;

@end

@implementation DTTransferTests

#pragma mark - setup and teardown

- (void)setUp
{
    [super setUp];

    self.transfer = [[[DTTransfer alloc] init] autorelease];
}

- (void)tearDown
{
    self.transfer = nil;

    [super tearDown];
}

#pragma mark - tests -

- (void)testClass
{
    STAssertTrue([self.transfer isKindOfClass:[DTTransfer class]],
                 @"DTTransfer class should be DTTransfer");
}

- (void)testNewObject
{
    STAssertNil(self.transfer.origin, @"origin string should be nil");
    STAssertNil(self.transfer.destination, @"destination string should be nil");
    STAssertNil(self.transfer.creationDate, @"creationDate should be nil");
    STAssertNil(self.transfer.scheduledDate, @"scheduledDate should be nil");
    STAssertEquals(self.transfer.type, DTTransferTypeUndefined, @"type should be undefined");
    STAssertEquals(self.transfer.value, (double)0.0, @"value should be zero");
    STAssertEquals(self.transfer.tax, (double)0.0, @"tax should be zero");
}

#pragma mark - properties

- (void)testOriginProperty
{
    self.transfer.origin = @"12345-6";
    STAssertEqualObjects(self.transfer.origin, @"12345-6", nil);
}

- (void)testDestinationProperty
{
    self.transfer.destination = @"12345-6";
    STAssertEqualObjects(self.transfer.destination, @"12345-6", nil);
}

- (void)testCreationDateProperty
{
    self.transfer.creationDate = [NSDate dateWithTimeIntervalSince1970:0];
    STAssertEqualObjects(self.transfer.creationDate,
                         [NSDate dateWithTimeIntervalSince1970:0],
                         nil);
}

- (void)testScheduledDateProperty
{
    self.transfer.scheduledDate = [NSDate dateWithTimeIntervalSince1970:0];
    STAssertEqualObjects(self.transfer.scheduledDate,
                         [NSDate dateWithTimeIntervalSince1970:0],
                         nil);
}

- (void)testSetTypeToA
{
    self.transfer.type = DTTransferTypeA;
    STAssertEquals(self.transfer.type, DTTransferTypeA, @"type should be A");
}

- (void)testSetTypeToB
{
    self.transfer.type = DTTransferTypeB;
    STAssertEquals(self.transfer.type, DTTransferTypeB, @"type should be B");
}

- (void)testSetTypeToC
{
    self.transfer.type = DTTransferTypeC;
    STAssertEquals(self.transfer.type, DTTransferTypeC, @"type should be C");
}

- (void)testSetTypeToD
{
    self.transfer.type = DTTransferTypeD;
    STAssertEquals(self.transfer.type, DTTransferTypeD, @"type should be D");
}

- (void)testValueProperty
{
    self.transfer.value = 3050.2;
    STAssertEquals(self.transfer.value, (double)3050.2, nil);
}

#pragma mark - test tax

- (void)testTaxPropertyTypeA
{
    self.transfer.creationDate = [self dateFromString:@"2013-01-01 00:00:00" timezone:nil];
    self.transfer.scheduledDate = [self dateFromString:@"2013-01-10 00:00:00" timezone:nil];
    self.transfer.type = DTTransferTypeA;
    self.transfer.value = 1;
    double estimated = self.transfer.tax;
    double tax = 2.03;
    STAssertEquals(estimated, tax, nil);
}

- (void)testTaxPropertyTypeB
{
    self.transfer.creationDate = [self dateFromString:@"2013-01-01 00:00:00" timezone:nil];
    self.transfer.scheduledDate = [self dateFromString:@"2013-01-10 00:00:00" timezone:nil];
    self.transfer.type = DTTransferTypeB;
    self.transfer.value = 1;
    double estimated = self.transfer.tax;
    double tax = 10;
    STAssertEquals(estimated, tax, nil);
}

- (void)testTaxPropertyTypeC
{
    self.transfer.creationDate = [self dateFromString:@"2013-01-01 00:00:00" timezone:nil];
    self.transfer.scheduledDate = [self dateFromString:@"2013-01-10 00:00:00" timezone:nil];
    self.transfer.type = DTTransferTypeC;
    self.transfer.value = 1;
    double estimated = self.transfer.tax;
    double tax = 0.074;
    STAssertEquals(estimated, tax, nil);
}

- (void)testTaxPropertyTypeD
{
    self.transfer.creationDate = [self dateFromString:@"2013-01-01 00:00:00" timezone:nil];
    self.transfer.scheduledDate = [self dateFromString:@"2013-03-01 00:00:00" timezone:nil];
    self.transfer.type = DTTransferTypeD;
    self.transfer.value = 25000.1;
    double estimated = self.transfer.tax;
    double tax = 8.0;
    STAssertEquals(estimated, tax, nil);
}

- (void)testTaxPropertyTypeUndefined
{
    self.transfer.creationDate = [self dateFromString:@"2013-01-01 00:00:00" timezone:nil];
    self.transfer.scheduledDate = [self dateFromString:@"2013-03-01 00:00:00" timezone:nil];
    self.transfer.value = 25000.1;
    double estimated = self.transfer.tax;
    double tax = 0.0;
    STAssertEquals(estimated, tax, nil);
}

- (void)testTaxPropertyValueUndefined
{
    self.transfer.creationDate = [self dateFromString:@"2013-01-01 00:00:00" timezone:nil];
    self.transfer.scheduledDate = [self dateFromString:@"2013-01-10 00:00:00" timezone:nil];
    self.transfer.type = DTTransferTypeA;
    double estimated = self.transfer.tax;
    double tax = 0.0;
    STAssertEquals(estimated, tax, nil);
}

- (void)testTaxPropertyCreationDateUndefined
{
    self.transfer.scheduledDate = [self dateFromString:@"2013-01-10 00:00:00" timezone:nil];
    self.transfer.type = DTTransferTypeA;
    self.transfer.value = 1;
    double estimated = self.transfer.tax;
    double tax = 0.0;
    STAssertEquals(estimated, tax, nil);
}

- (void)testTaxPropertyScheduledDateUndefined
{
    self.transfer.creationDate = [self dateFromString:@"2013-01-10 00:00:00" timezone:nil];
    self.transfer.type = DTTransferTypeA;
    self.transfer.value = 1;
    double estimated = self.transfer.tax;
    double tax = 0.0;
    STAssertEquals(estimated, tax, nil);
}

- (void)testTaxPropertyScheduledDateBeforeCreated
{
    self.transfer.creationDate = [self dateFromString:@"2013-01-10 00:00:00" timezone:nil];
    self.transfer.scheduledDate = [self dateFromString:@"2013-01-09 00:00:00" timezone:nil];
    self.transfer.type = DTTransferTypeA;
    self.transfer.value = 1;
    double estimated = self.transfer.tax;
    double tax = 0.0;
    STAssertEquals(estimated, tax, nil);
}


#pragma mark - daysToScheduledDate:fromCreationDate:

- (void)testSameDay
{
    NSDate *day1 = [self dateFromString:@"2011-01-01 00:00:00" timezone:nil];
    NSDate *day2 = [self dateFromString:@"2011-01-01 00:00:00" timezone:nil];

    NSInteger days = [self.transfer daysToScheduledDate:day2
                                       fromCreationDate:day1];
    STAssertEquals(days, (NSInteger)0, @"Should be zero days");
}

- (void)testSameDayTwoHours
{
    NSDate *day1 = [self dateFromString:@"2011-01-01 00:00:00" timezone:nil];
    NSDate *day2 = [self dateFromString:@"2011-01-01 02:00:00" timezone:nil];

    NSInteger days = [self.transfer daysToScheduledDate:day2
                                       fromCreationDate:day1];
    STAssertEquals(days, (NSInteger)0, @"Should be zero days");
}

- (void)testSameDayTwoMinutes
{
    NSDate *day1 = [self dateFromString:@"2011-01-01 00:00:00" timezone:nil];
    NSDate *day2 = [self dateFromString:@"2011-01-01 00:02:00" timezone:nil];

    NSInteger days = [self.transfer daysToScheduledDate:day2
                                       fromCreationDate:day1];
    STAssertEquals(days, (NSInteger)0, @"Should be zero days");
}

- (void)testNextDay
{
    NSDate *day1 = [self dateFromString:@"2011-01-01 00:00:00" timezone:nil];
    NSDate *day2 = [self dateFromString:@"2011-01-02 00:00:00" timezone:nil];

    NSInteger days = [self.transfer daysToScheduledDate:day2
                                       fromCreationDate:day1];
    STAssertEquals(days, (NSInteger)1, @"Should be 1 day");
}

- (void)testTwoHoursNextDay
{
    NSDate *day1 = [self dateFromString:@"2011-01-01 23:00:00" timezone:nil];
    NSDate *day2 = [self dateFromString:@"2011-01-02 01:00:00" timezone:nil];

    NSInteger days = [self.transfer daysToScheduledDate:day2
                                       fromCreationDate:day1];
    STAssertEquals(days, (NSInteger)1, @"Should be 1 day");
}

- (void)testTwoMinutesNextDay
{
    NSDate *day1 = [self dateFromString:@"2011-01-01 23:59:00" timezone:nil];
    NSDate *day2 = [self dateFromString:@"2011-01-02 00:01:00" timezone:nil];

    NSInteger days = [self.transfer daysToScheduledDate:day2
                                       fromCreationDate:day1];
    STAssertEquals(days, (NSInteger)1, @"Should be 1 day");
}

- (void)testTwoMinutesPreviousDay
{
    NSDate *day1 = [self dateFromString:@"2011-01-02 00:01:00" timezone:nil];
    NSDate *day2 = [self dateFromString:@"2011-01-01 23:59:00" timezone:nil];

    NSInteger days = [self.transfer daysToScheduledDate:day2
                                       fromCreationDate:day1];
    STAssertEquals(days, (NSInteger)-1, @"Should be -1 day");
}

- (void)testNilScheduledDate
{
    NSDate *day = [self dateFromString:@"2011-01-01 00:00:00" timezone:nil];

    NSInteger days = [self.transfer daysToScheduledDate:nil
                                       fromCreationDate:day];
    STAssertEquals(days, NSNotFound, @"Days should be NSNotFound");
}

- (void)testNilCreationDate
{
    NSDate *day = [self dateFromString:@"2011-01-01 00:00:00" timezone:nil];

    NSInteger days = [self.transfer daysToScheduledDate:day
                                       fromCreationDate:nil];
    STAssertEquals(days, NSNotFound, @"Days should be NSNotFound");
}

#pragma mark - taxTypeA
// test values -1, 0, 1, 12345.123 and 123456789012345

- (void)testAvalue0
{
    double value = 0.0;
    double tax = 0.0;
    double estimated = [self.transfer taxTypeA:value];
    STAssertEquals(estimated, tax, nil);
}

- (void)testAvalue1
{
    double value = 1.0;
    double tax = 2.03;
    double estimated = [self.transfer taxTypeA:value];
    STAssertEquals(estimated, tax, nil);
}

- (void)testAvalue12345_123
{
    double value = 12345.123;
    double tax = 372.35369;
    double estimated = [self.transfer taxTypeA:value];
    STAssertEquals(estimated, tax, nil);
}

- (void)testAvalue12345678901234
{
    double value = 123456789012345;
    double tax = 3703703670372.35;
    double estimated = [self.transfer taxTypeA:value];
    STAssertEquals(estimated, tax, nil);
}

- (void)testAvalueMinus1
{
    double value = -1.0;
    double tax = 0.0;
    double estimated = [self.transfer taxTypeA:value];
    STAssertEquals(estimated, tax, nil);
}

#pragma mark - taxTypeB
// test values -1, 0, 1, 12345.123, 123456789012345
// test days -1, 0, 1, 17, 30, 31, 1500, NSNotFound


- (void)testBvalue0days0
{
    double value = 0.0;
    double tax = 0.0;
    NSInteger days = 0;
    double estimated = [self.transfer taxTypeB:value daysToExecution:days];
    STAssertEquals(estimated, tax, nil);
}

- (void)testBvalue0daysMinus1
{
    double value = 0.0;
    double tax = 0.0;
    NSInteger days = -1;
    double estimated = [self.transfer taxTypeB:value daysToExecution:days];
    STAssertEquals(estimated, tax, nil);
}

- (void)testBvalue0days1
{
    double value = 0.0;
    double tax = 0.0;
    NSInteger days = 1;
    double estimated = [self.transfer taxTypeB:value daysToExecution:days];
    STAssertEquals(estimated, tax, nil);
}

- (void)testBvalue0days17
{
    double value = 0.0;
    double tax = 0.0;
    NSInteger days = 17;
    double estimated = [self.transfer taxTypeB:value daysToExecution:days];
    STAssertEquals(estimated, tax, nil);
}

- (void)testBvalue0days30
{
    double value = 0.0;
    double tax = 0.0;
    NSUInteger days = 30;
    double estimated = [self.transfer taxTypeB:value daysToExecution:days];
    STAssertEquals(estimated, tax, nil);
}

- (void)testBvalue0days31
{
    double value = 0.0;
    double tax = 0.0;
    NSInteger days = 31;
    double estimated = [self.transfer taxTypeB:value daysToExecution:days];
    STAssertEquals(estimated, tax, nil);
}

- (void)testBvalue0days1500
{
    double value = 0.0;
    double tax = 0.0;
    NSInteger days = 1500;
    double estimated = [self.transfer taxTypeB:value daysToExecution:days];
    STAssertEquals(estimated, tax, nil);
}

- (void)testBvalueMinus1days0
{
    double value = -1.0;
    double tax = 0.0;
    NSInteger days = 0;
    double estimated = [self.transfer taxTypeB:value daysToExecution:days];
    STAssertEquals(estimated, tax, nil);
}

- (void)testBvalueMinus1daysMinus1
{
    double value = -1.0;
    double tax = 0.0;
    NSInteger days = -1;
    double estimated = [self.transfer taxTypeB:value daysToExecution:days];
    STAssertEquals(estimated, tax, nil);
}

- (void)testBvalueMinus1days1
{
    double value = -1.0;
    double tax = 0.0;
    NSInteger days = 1;
    double estimated = [self.transfer taxTypeB:value daysToExecution:days];
    STAssertEquals(estimated, tax, nil);
}

- (void)testBvalueMinus1days17
{
    double value = -1.0;
    double tax = 0.0;
    NSInteger days = 17;
    double estimated = [self.transfer taxTypeB:value daysToExecution:days];
    STAssertEquals(estimated, tax, nil);
}

- (void)testBvalueMinus1days30
{
    double value = -1.0;
    double tax = 0.0;
    NSInteger days = 30;
    double estimated = [self.transfer taxTypeB:value daysToExecution:days];
    STAssertEquals(estimated, tax, nil);
}

- (void)testBvalueMinus1days31
{
    double value = -1.0;
    double tax = 0.0;
    NSInteger days = 31;
    double estimated = [self.transfer taxTypeB:value daysToExecution:days];
    STAssertEquals(estimated, tax, nil);
}

- (void)testBvalueMinus1days150
{
    double value = -1.0;
    double tax = 0.0;
    NSInteger days = 150;
    double estimated = [self.transfer taxTypeB:value daysToExecution:days];
    STAssertEquals(estimated, tax, nil);
}

- (void)testBvalue1daysNSNotFound
{
    double value = 1.0;
    double tax = 0.0;
    NSInteger days = NSNotFound;
    double estimated = [self.transfer taxTypeB:value daysToExecution:days];
    STAssertEquals(estimated, tax, nil);
}

- (void)testBvalue1days0
{
    double value = 1.0;
    double tax = 10.0;
    NSInteger days = 0;
    double estimated = [self.transfer taxTypeB:value daysToExecution:days];
    STAssertEquals(estimated, tax, nil);
}

- (void)testBvalue1daysMinus1
{
    double value = 1.0;
    double tax = 0.0;
    NSInteger days = -1;
    double estimated = [self.transfer taxTypeB:value daysToExecution:days];
    STAssertEquals(estimated, tax, nil);
}

- (void)testBvalue1days1
{
    double value = 1.0;
    double tax = 10.0;
    NSInteger days = 1;
    double estimated = [self.transfer taxTypeB:value daysToExecution:days];
    STAssertEquals(estimated, tax, nil);
}

- (void)testBvalue1days17
{
    double value = 1.0;
    double tax = 10.0;
    NSInteger days = 17;
    double estimated = [self.transfer taxTypeB:value daysToExecution:days];
    STAssertEquals(estimated, tax, nil);
}

- (void)testBvalue1days30
{
    double value = 1.0;
    double tax = 10.0;
    NSInteger days = 30;
    double estimated = [self.transfer taxTypeB:value daysToExecution:days];
    STAssertEquals(estimated, tax, nil);
}

- (void)testBvalue1days31
{
    double value = 1.0;
    double tax = 8.0;
    NSInteger days = 31;
    double estimated = [self.transfer taxTypeB:value daysToExecution:days];
    STAssertEquals(estimated, tax, nil);
}

- (void)testBvalue1days1500
{
    double value = 1.0;
    double tax = 8.0;
    NSInteger days = 1500;
    double estimated = [self.transfer taxTypeB:value daysToExecution:days];
    STAssertEquals(estimated, tax, nil);
}

- (void)testBvalue12345_123days0
{
    double value = 12345.123;
    double tax = 10.0;
    NSInteger days = 0;
    double estimated = [self.transfer taxTypeB:value daysToExecution:days];
    STAssertEquals(estimated, tax, nil);
}

- (void)testBvalue12345_123daysMinus1
{
    double value = 12345.123;
    double tax = 0.0;
    NSInteger days = -1;
    double estimated = [self.transfer taxTypeB:value daysToExecution:days];
    STAssertEquals(estimated, tax, nil);
}

- (void)testBvalue12345_123days1
{
    double value = 12345.123;
    double tax = 10.0;
    NSInteger days = 1;
    double estimated = [self.transfer taxTypeB:value daysToExecution:days];
    STAssertEquals(estimated, tax, nil);
}

- (void)testBvalue12345_123days17
{
    double value = 12345.123;
    double tax = 10.0;
    NSInteger days = 17;
    double estimated = [self.transfer taxTypeB:value daysToExecution:days];
    STAssertEquals(estimated, tax, nil);
}

- (void)testBvalue12345_123days30
{
    double value = 12345.123;
    double tax = 10.0;
    NSInteger days = 30;
    double estimated = [self.transfer taxTypeB:value daysToExecution:days];
    STAssertEquals(estimated, tax, nil);
}

- (void)testBvalue12345_123days31
{
    double value = 12345.123;
    double tax = 8.0;
    NSInteger days = 31;
    double estimated = [self.transfer taxTypeB:value daysToExecution:days];
    STAssertEquals(estimated, tax, nil);
}

- (void)testBvalue12345_123days1500
{
    double value = 12345.123;
    double tax = 8.0;
    NSInteger days = 1500;
    double estimated = [self.transfer taxTypeB:value daysToExecution:days];
    STAssertEquals(estimated, tax, nil);
}

- (void)testBvalue123456789012345daysMinus1
{
    double value = 123456789012345;
    double tax = 0.0;
    NSInteger days = -1;
    double estimated = [self.transfer taxTypeB:value daysToExecution:days];
    STAssertEquals(estimated, tax, nil);
}

- (void)testBvalue123456789012345days0
{
    double value = 123456789012345;
    double tax = 10.0;
    NSInteger days = 0;
    double estimated = [self.transfer taxTypeB:value daysToExecution:days];
    STAssertEquals(estimated, tax, nil);
}

- (void)testBvalue123456789012345days1
{
    double value = 123456789012345;
    double tax = 10.0;
    NSInteger days = 1;
    double estimated = [self.transfer taxTypeB:value daysToExecution:days];
    STAssertEquals(estimated, tax, nil);
}

- (void)testBvalue123456789012345days17
{
    double value = 123456789012345;
    double tax = 10.0;
    NSInteger days = 17;
    double estimated = [self.transfer taxTypeB:value daysToExecution:days];
    STAssertEquals(estimated, tax, nil);
}

- (void)testBvalue123456789012345days30
{
    double value = 123456789012345;
    double tax = 10.0;
    NSInteger days = 30;
    double estimated = [self.transfer taxTypeB:value daysToExecution:days];
    STAssertEquals(estimated, tax, nil);
}

- (void)testBvalue123456789012345days31
{
    double value = 123456789012345;
    double tax = 8.0;
    NSInteger days = 31;
    double estimated = [self.transfer taxTypeB:value daysToExecution:days];
    STAssertEquals(estimated, tax, nil);
}

- (void)testBvalue123456789012345days1500
{
    double value = 123456789012345;
    double tax = 8.0;
    NSInteger days = 1500;
    double estimated = [self.transfer taxTypeB:value daysToExecution:days];
    STAssertEquals(estimated, tax, nil);
}

#pragma mark - taxTypeC
// test values -1, 0, 1, 123456789012345
// test days -1, 0, 1, 5, 6, 10, 11, 15, 16, 20, 21, 25, 26, 30, 31, 1500

- (void)testCvalueMinus1daysMinus1
{
    double value = -1.0;
    double tax = 0.0;
    NSInteger days = -1;
    double estimated = [self.transfer taxTypeC:value daysToExecution:days];
    STAssertEquals(estimated, tax, nil);
}

- (void)testCvalueMinus1days0
{
    double value = -1.0;
    double tax = 0.0;
    NSInteger days = 0;
    double estimated = [self.transfer taxTypeC:value daysToExecution:days];
    STAssertEquals(estimated, tax, nil);
}

- (void)testCvalueMinus1days1
{
    double value = -1.0;
    double tax = 0.0;
    NSInteger days = 1;
    double estimated = [self.transfer taxTypeC:value daysToExecution:days];
    STAssertEquals(estimated, tax, nil);
}

- (void)testCvalueMinus1days5
{
    double value = -1.0;
    double tax = 0.0;
    NSInteger days = 5;
    double estimated = [self.transfer taxTypeC:value daysToExecution:days];
    STAssertEquals(estimated, tax, nil);
}

- (void)testCvalueMinus1days6
{
    double value = -1.0;
    double tax = 0.0;
    NSInteger days = 6;
    double estimated = [self.transfer taxTypeC:value daysToExecution:days];
    STAssertEquals(estimated, tax, nil);
}

- (void)testCvalueMinus1days10
{
    double value = -1.0;
    double tax = 0.0;
    NSInteger days = 10;
    double estimated = [self.transfer taxTypeC:value daysToExecution:days];
    STAssertEquals(estimated, tax, nil);
}

- (void)testCvalueMinus1days11
{
    double value = -1.0;
    double tax = 0.0;
    NSInteger days = 11;
    double estimated = [self.transfer taxTypeC:value daysToExecution:days];
    STAssertEquals(estimated, tax, nil);
}

- (void)testCvalueMinus1days15
{
    double value = -1.0;
    double tax = 0.0;
    NSInteger days = 15;
    double estimated = [self.transfer taxTypeC:value daysToExecution:days];
    STAssertEquals(estimated, tax, nil);
}

- (void)testCvalueMinus1days16
{
    double value = -1.0;
    double tax = 0.0;
    NSInteger days = 16;
    double estimated = [self.transfer taxTypeC:value daysToExecution:days];
    STAssertEquals(estimated, tax, nil);
}

- (void)testCvalueMinus1days20
{
    double value = -1.0;
    double tax = 0.0;
    NSInteger days = 20;
    double estimated = [self.transfer taxTypeC:value daysToExecution:days];
    STAssertEquals(estimated, tax, nil);
}

- (void)testCvalueMinus1days21
{
    double value = -1.0;
    double tax = 0.0;
    NSInteger days = 21;
    double estimated = [self.transfer taxTypeC:value daysToExecution:days];
    STAssertEquals(estimated, tax, nil);
}

- (void)testCvalueMinus1days25
{
    double value = -1.0;
    double tax = 0.0;
    NSInteger days = 25;
    double estimated = [self.transfer taxTypeC:value daysToExecution:days];
    STAssertEquals(estimated, tax, nil);
}

- (void)testCvalueMinus1days26
{
    double value = -1.0;
    double tax = 0.0;
    NSInteger days = 26;
    double estimated = [self.transfer taxTypeC:value daysToExecution:days];
    STAssertEquals(estimated, tax, nil);
}

- (void)testCvalueMinus1days30
{
    double value = -1.0;
    double tax = 0.0;
    NSInteger days = 30;
    double estimated = [self.transfer taxTypeC:value daysToExecution:days];
    STAssertEquals(estimated, tax, nil);
}

- (void)testCvalueMinus1days31
{
    double value = -1.0;
    double tax = 0.0;
    NSInteger days = 31;
    double estimated = [self.transfer taxTypeC:value daysToExecution:days];
    STAssertEquals(estimated, tax, nil);
}

- (void)testCvalueMinus1days1500
{
    double value = -1.0;
    double tax = 0.0;
    NSInteger days = 1500;
    double estimated = [self.transfer taxTypeC:value daysToExecution:days];
    STAssertEquals(estimated, tax, nil);
}

- (void)testCvalue0daysMinus1
{
    double value = 0.0;
    double tax = 0.0;
    NSInteger days = -1;
    double estimated = [self.transfer taxTypeC:value daysToExecution:days];
    STAssertEquals(estimated, tax, nil);
}

- (void)testCvalue0days0
{
    double value = 0.0;
    double tax = 0.0;
    NSInteger days = 0;
    double estimated = [self.transfer taxTypeC:value daysToExecution:days];
    STAssertEquals(estimated, tax, nil);
}

- (void)testCvalue0days1
{
    double value = 0.0;
    double tax = 0.0;
    NSInteger days = 1;
    double estimated = [self.transfer taxTypeC:value daysToExecution:days];
    STAssertEquals(estimated, tax, nil);
}

- (void)testCvalue0days5
{
    double value = 0.0;
    double tax = 0.0;
    NSInteger days = 5;
    double estimated = [self.transfer taxTypeC:value daysToExecution:days];
    STAssertEquals(estimated, tax, nil);
}

- (void)testCvalue0days6
{
    double value = 0.0;
    double tax = 0.0;
    NSInteger days = 6;
    double estimated = [self.transfer taxTypeC:value daysToExecution:days];
    STAssertEquals(estimated, tax, nil);
}

- (void)testCvalue0days10
{
    double value = 0.0;
    double tax = 0.0;
    NSInteger days = 10;
    double estimated = [self.transfer taxTypeC:value daysToExecution:days];
    STAssertEquals(estimated, tax, nil);
}

- (void)testCvalue0days11
{
    double value = 0.0;
    double tax = 0.0;
    NSInteger days = 11;
    double estimated = [self.transfer taxTypeC:value daysToExecution:days];
    STAssertEquals(estimated, tax, nil);
}

- (void)testCvalue0days15
{
    double value = 0.0;
    double tax = 0.0;
    NSInteger days = 15;
    double estimated = [self.transfer taxTypeC:value daysToExecution:days];
    STAssertEquals(estimated, tax, nil);
}

- (void)testCvalue0days16
{
    double value = 0.0;
    double tax = 0.0;
    NSInteger days = 16;
    double estimated = [self.transfer taxTypeC:value daysToExecution:days];
    STAssertEquals(estimated, tax, nil);
}

- (void)testCvalue0days20
{
    double value = 0.0;
    double tax = 0.0;
    NSInteger days = 20;
    double estimated = [self.transfer taxTypeC:value daysToExecution:days];
    STAssertEquals(estimated, tax, nil);
}

- (void)testCvalue0days21
{
    double value = 0.0;
    double tax = 0.0;
    NSInteger days = 21;
    double estimated = [self.transfer taxTypeC:value daysToExecution:days];
    STAssertEquals(estimated, tax, nil);
}

- (void)testCvalue0days25
{
    double value = 0.0;
    double tax = 0.0;
    NSInteger days = 25;
    double estimated = [self.transfer taxTypeC:value daysToExecution:days];
    STAssertEquals(estimated, tax, nil);
}

- (void)testCvalue0days26
{
    double value = 0.0;
    double tax = 0.0;
    NSInteger days = 26;
    double estimated = [self.transfer taxTypeC:value daysToExecution:days];
    STAssertEquals(estimated, tax, nil);
}

- (void)testCvalue0days30
{
    double value = 0.0;
    double tax = 0.0;
    NSInteger days = 30;
    double estimated = [self.transfer taxTypeC:value daysToExecution:days];
    STAssertEquals(estimated, tax, nil);
}

- (void)testCvalue0days31
{
    double value = 0.0;
    double tax = 0.0;
    NSInteger days = 31;
    double estimated = [self.transfer taxTypeC:value daysToExecution:days];
    STAssertEquals(estimated, tax, nil);
}

- (void)testCvalue0days1500
{
    double value = 0.0;
    double tax = 0.0;
    NSInteger days = 1500;
    double estimated = [self.transfer taxTypeC:value daysToExecution:days];
    STAssertEquals(estimated, tax, nil);
}


- (void)testCvalue1daysMinus1
{
    double value = 1.0;
    double tax = 0.0;
    NSInteger days = -1;
    double estimated = [self.transfer taxTypeC:value daysToExecution:days];
    STAssertEquals(estimated, tax, nil);
}

- (void)testCvalue1daysNSNotFound
{
    double value = 1.0;
    double tax = 0.0;
    NSInteger days = NSNotFound;
    double estimated = [self.transfer taxTypeC:value daysToExecution:days];
    STAssertEquals(estimated, tax, nil);
}

- (void)testCvalue1days0
{
    double value = 1.0;
    double tax = 0.083;
    NSInteger days = 0;
    double estimated = [self.transfer taxTypeC:value daysToExecution:days];
    STAssertEquals(estimated, tax, nil);
}

- (void)testCvalue1days1
{
    double value = 1.0;
    double tax = 0.083;
    NSInteger days = 1;
    double estimated = [self.transfer taxTypeC:value daysToExecution:days];
    STAssertEquals(estimated, tax, nil);
}

- (void)testCvalue1days5
{
    double value = 1.0;
    double tax = 0.083;
    NSInteger days = 5;
    double estimated = [self.transfer taxTypeC:value daysToExecution:days];
    STAssertEquals(estimated, tax, nil);
}

- (void)testCvalue1days6
{
    double value = 1.0;
    double tax = 0.074;
    NSInteger days = 6;
    double estimated = [self.transfer taxTypeC:value daysToExecution:days];
    STAssertEquals(estimated, tax, nil);
}

- (void)testCvalue1days10
{
    double value = 1.0;
    double tax = 0.074;
    NSInteger days = 10;
    double estimated = [self.transfer taxTypeC:value daysToExecution:days];
    STAssertEquals(estimated, tax, nil);
}

- (void)testCvalue1days11
{
    double value = 1.0;
    double tax = 0.067;
    NSInteger days = 11;
    double estimated = [self.transfer taxTypeC:value daysToExecution:days];
    STAssertEquals(estimated, tax, nil);
}

- (void)testCvalue1days15
{
    double value = 1.0;
    double tax = 0.067;
    NSInteger days = 15;
    double estimated = [self.transfer taxTypeC:value daysToExecution:days];
    STAssertEquals(estimated, tax, nil);
}

- (void)testCvalue1days16
{
    double value = 1.0;
    double tax = 0.054;
    NSInteger days = 16;
    double estimated = [self.transfer taxTypeC:value daysToExecution:days];
    STAssertEquals(estimated, tax, nil);
}

- (void)testCvalue1days20
{
    double value = 1.0;
    double tax = 0.054;
    NSInteger days = 20;
    double estimated = [self.transfer taxTypeC:value daysToExecution:days];
    STAssertEquals(estimated, tax, nil);
}

- (void)testCvalue1days21
{
    double value = 1.0;
    double tax = 0.043;
    NSInteger days = 21;
    double estimated = [self.transfer taxTypeC:value daysToExecution:days];
    STAssertEquals(estimated, tax, nil);
}

- (void)testCvalue1days25
{
    double value = 1.0;
    double tax = 0.043;
    NSInteger days = 25;
    double estimated = [self.transfer taxTypeC:value daysToExecution:days];
    STAssertEquals(estimated, tax, nil);
}

- (void)testCvalue1days26
{
    double value = 1.0;
    double tax = 0.021;
    NSInteger days = 26;
    double estimated = [self.transfer taxTypeC:value daysToExecution:days];
    STAssertEquals(estimated, tax, nil);
}

- (void)testCvalue1days30
{
    double value = 1.0;
    double tax = 0.021;
    NSInteger days = 30;
    double estimated = [self.transfer taxTypeC:value daysToExecution:days];
    STAssertEquals(estimated, tax, nil);
}

- (void)testCvalue1days31
{
    double value = 1.0;
    double tax = 0.012;
    NSInteger days = 31;
    double estimated = [self.transfer taxTypeC:value daysToExecution:days];
    STAssertEquals(estimated, tax, nil);
}

- (void)testCvalue1days1500
{
    double value = 1.0;
    double tax = 0.012;
    NSInteger days = 1500;
    double estimated = [self.transfer taxTypeC:value daysToExecution:days];
    STAssertEquals(estimated, tax, nil);
}

- (void)testCvalue123456789012345daysMinus1
{
    double value = 123456789012345.0;
    double tax = 0.0;
    NSInteger days = -1;
    double estimated = [self.transfer taxTypeC:value daysToExecution:days];
    STAssertEquals(estimated, tax, nil);
}

- (void)testCvalue123456789012345days0
{
    double value = 123456789012345.0;
    double tax = 10246913488024.60;
    NSInteger days = 0;
    double estimated = [self.transfer taxTypeC:value daysToExecution:days];
    STAssertEqualsWithAccuracy(estimated, tax, 0.1, nil);
}

- (void)testCvalue123456789012345days1
{
    double value = 123456789012345.0;
    double tax = 10246913488024.60;
    NSInteger days = 1;
    double estimated = [self.transfer taxTypeC:value daysToExecution:days];
    STAssertEqualsWithAccuracy(estimated, tax, 0.1, nil);
}

- (void)testCvalue123456789012345days5
{
    double value = 123456789012345.0;
    double tax = 10246913488024.60;
    NSInteger days = 5;
    double estimated = [self.transfer taxTypeC:value daysToExecution:days];
    STAssertEqualsWithAccuracy(estimated, tax, 0.1, nil);
}

- (void)testCvalue123456789012345days6
{
    double value = 123456789012345.0;
    double tax = 9135802386913.53;
    NSInteger days = 6;
    double estimated = [self.transfer taxTypeC:value daysToExecution:days];
    STAssertEqualsWithAccuracy(estimated, tax, 0.1, nil);
}

- (void)testCvalue123456789012345days10
{
    double value = 123456789012345.0;
    double tax = 9135802386913.53;
    NSInteger days = 10;
    double estimated = [self.transfer taxTypeC:value daysToExecution:days];
    STAssertEqualsWithAccuracy(estimated, tax, 0.1, nil);
}

- (void)testCvalue123456789012345days11
{
    double value = 123456789012345.0;
    double tax = 8271604863827.12;
    NSInteger days = 11;
    double estimated = [self.transfer taxTypeC:value daysToExecution:days];
    STAssertEqualsWithAccuracy(estimated, tax, 0.1, nil);
}

- (void)testCvalue123456789012345days15
{
    double value = 123456789012345.0;
    double tax = 8271604863827.12;
    NSInteger days = 15;
    double estimated = [self.transfer taxTypeC:value daysToExecution:days];
    STAssertEqualsWithAccuracy(estimated, tax, 0.1, nil);
}

- (void)testCvalue123456789012345days16
{
    double value = 123456789012345.0;
    double tax = 6666666606666.63;
    NSInteger days = 16;
    double estimated = [self.transfer taxTypeC:value daysToExecution:days];
    STAssertEqualsWithAccuracy(estimated, tax, 0.1, nil);
}

- (void)testCvalue123456789012345days20
{
    double value = 123456789012345.0;
    double tax = 6666666606666.63;
    NSInteger days = 20;
    double estimated = [self.transfer taxTypeC:value daysToExecution:days];
    STAssertEqualsWithAccuracy(estimated, tax, 0.1, nil);
}

- (void)testCvalue123456789012345days21
{
    double value = 123456789012345.0;
    double tax = 5308641927530.83;
    NSInteger days = 21;
    double estimated = [self.transfer taxTypeC:value daysToExecution:days];
    STAssertEqualsWithAccuracy(estimated, tax, 0.1, nil);
}

- (void)testCvalue123456789012345days25
{
    double value = 123456789012345.0;
    double tax = 5308641927530.83;
    NSInteger days = 25;
    double estimated = [self.transfer taxTypeC:value daysToExecution:days];
    STAssertEqualsWithAccuracy(estimated, tax, 0.1, nil);
}

- (void)testCvalue123456789012345days26
{
    double value = 123456789012345.0;
    double tax = 2592592569259.25;
    NSInteger days = 26;
    double estimated = [self.transfer taxTypeC:value daysToExecution:days];
    STAssertEqualsWithAccuracy(estimated, tax, 0.1, nil);
}

- (void)testCvalue123456789012345days30
{
    double value = 123456789012345.0;
    double tax = 2592592569259.25;
    NSInteger days = 30;
    double estimated = [self.transfer taxTypeC:value daysToExecution:days];
    STAssertEqualsWithAccuracy(estimated, tax, 0.1, nil);
}

- (void)testCvalue123456789012345days31
{
    double value = 123456789012345.0;
    double tax = 1481481468148.14;
    NSInteger days = 31;
    double estimated = [self.transfer taxTypeC:value daysToExecution:days];
    STAssertEqualsWithAccuracy(estimated, tax, 0.1, nil);
}

- (void)testCvalue123456789012345days1500
{
    double value = 123456789012345.0;
    double tax = 1481481468148.14;
    NSInteger days = 1500;
    double estimated = [self.transfer taxTypeC:value daysToExecution:days];
    STAssertEqualsWithAccuracy(estimated, tax, 0.1, nil);
}

#pragma mark - taxTypeD
// test values -1, 0, 1, 25000, 25001, 120000, 120000.01, 123456789012345

- (void)testDvalueMinus1{
    double value = -1.0;
    DTTransferType type = DTTransferTypeUndefined;
    DTTransferType estimated = [self.transfer typeForTransferDofValue:value];
    STAssertEquals(estimated, type, @"Type should be undefined");
}

- (void)testDvalue0{
    double value = 0.0;
    DTTransferType type = DTTransferTypeUndefined;
    DTTransferType estimated = [self.transfer typeForTransferDofValue:value];
    STAssertEquals(estimated, type, @"Type should be undefined");
}

- (void)testDvalue1{
    double value = 1.0;
    DTTransferType type = DTTransferTypeA;
    DTTransferType estimated = [self.transfer typeForTransferDofValue:value];
    STAssertEquals(estimated, type, @"Type should be undefined");
}

- (void)testDvalue25000{
    double value = 25000.0;
    DTTransferType type = DTTransferTypeA;
    DTTransferType estimated = [self.transfer typeForTransferDofValue:value];
    STAssertEquals(estimated, type, @"Type should be undefined");
}

- (void)testDvalue25001{
    double value = 25001.0;
    DTTransferType type = DTTransferTypeB;
    DTTransferType estimated = [self.transfer typeForTransferDofValue:value];
    STAssertEquals(estimated, type, @"Type should be undefined");
}

- (void)testDvalue120000{
    double value = 120000.0;
    DTTransferType type = DTTransferTypeB;
    DTTransferType estimated = [self.transfer typeForTransferDofValue:value];
    STAssertEquals(estimated, type, @"Type should be undefined");
}

- (void)testDvalue120000_01{
    double value = 120000.01;
    DTTransferType type = DTTransferTypeC;
    DTTransferType estimated = [self.transfer typeForTransferDofValue:value];
    STAssertEquals(estimated, type, @"Type should be undefined");
}

- (void)testDvalue123456789012345{
    double value = 123456789012345.0;
    DTTransferType type = DTTransferTypeC;
    DTTransferType estimated = [self.transfer typeForTransferDofValue:value];
    STAssertEquals(estimated, type, @"Type should be undefined");
}



#pragma mark - helpers

- (NSDate *)dateFromString:(NSString *)dateString timezone:(NSTimeZone *)timezone {
    static NSDateFormatter *dateFormatter;
    static dispatch_once_t stringFromDateOnceToken;
    dispatch_once(&stringFromDateOnceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        dateFormatter.locale = [[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] autorelease];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    });

    return [dateFormatter dateFromString:dateString];
}

@end
