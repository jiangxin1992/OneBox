//
//  NSDate+Custom.m
//  YCO SPACE
//
//  Created by yyj on 16/8/25.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "NSDate+Custom.h"

@implementation NSDate (Custom)

- (NSUInteger)numberOfDaysInMonth{
    NSCalendar *greCalendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [greCalendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    return [greCalendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self].length;
    
}

- (NSDate *)firstDateOfMonth{
    double interval = 0;
    NSDate *beginDate = nil;
    NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [calendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    
    BOOL ok = [calendar rangeOfUnit:NSCalendarUnitMonth startDate:&beginDate interval:&interval forDate:self];
    //分别修改为 NSDayCalendarUnit NSWeekCalendarUnit NSYearCalendarUnit
    if (ok) {
        return beginDate;
    }else {
        return nil;
    }
}
-(NSDate *)getFirstTime
{
    double interval = 0;
    NSDate *beginDate = nil;
    NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [calendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    BOOL ok = [calendar rangeOfUnit:NSCalendarUnitDay startDate:&beginDate interval:&interval forDate:self];
    //分别修改为 NSDayCalendarUnit NSWeekCalendarUnit NSYearCalendarUnit
    if (ok) {
        return beginDate;
    }else {
        return nil;
    }
}

-(NSDate *)lastDateOfMonth
{
    double interval = 0;
    NSDate *beginDate = nil;
    NSDate *endDate = nil;
    NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [calendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    BOOL ok = [calendar rangeOfUnit:NSCalendarUnitMonth startDate:&beginDate interval:&interval forDate:self];
    //分别修改为 NSDayCalendarUnit NSWeekCalendarUnit NSYearCalendarUnit
    if (ok) {
        endDate = [beginDate dateByAddingTimeInterval:interval-1];
        return endDate;
    }else {
        return nil;
    }
}

- (NSUInteger)startDayOfWeek
{
    NSCalendar *greCalendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [greCalendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];//Asia/Shanghai
    NSDateComponents *comps = [greCalendar
                               components:NSCalendarUnitYear | NSCalendarUnitMonth |NSCalendarUnitWeekday | NSCalendarUnitDay
                               fromDate:[self firstDateOfMonth]];
    return comps.weekday;
}

- (NSDate *)getLastMonth{
//    NSCalendar *greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
//    [greCalendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
//    NSDateComponents *comps = [greCalendar
//                               components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
//                               fromDate:self];
//    comps.month -= 1;
//    return [greCalendar dateFromComponents:comps];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *comps = nil;
    
    comps = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self];
    
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    
    [adcomps setYear:0];
    
    [adcomps setMonth:-1];
    
    [adcomps setDay:0];
    
    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:self options:0];
    return newdate;
}

- (NSDate *)getNextMonth{
//    NSCalendar *greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
//    [greCalendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
//    NSDateComponents *comps = [greCalendar
//                               components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
//                               fromDate:self];
//    comps.month += 1;
//    JXLOG(@"date=%@",self);
//    JXLOG(@"month=%@",[greCalendar dateFromComponents:comps]);
//    return [greCalendar dateFromComponents:comps];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *comps = nil;
    
    comps = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self];
    
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    
    [adcomps setYear:0];
    
    [adcomps setMonth:+1];
    
    [adcomps setDay:0];
    
    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:self options:0];
    return newdate;
}
-(long)getTime
{
    return [self timeIntervalSince1970];
}



@end
