//
//  NSDate+Formatter.h
//  SystemXinDai
//
//  Created by LvJianfeng on 16/3/26.
//  Copyright © 2016年 LvJianfeng. All rights reserved.
//

#import "NSDate+Formatter.h"

@implementation NSDate (Formatter)
+(long )nowTime
{
    return [[self nowDate] timeIntervalSince1970];
}
+(NSDate *)nowDate
{
    NSDate *date = [NSDate date];
    
//    NSTimeInterval  timeZoneOffset=[[NSTimeZone systemTimeZone] secondsFromGMT];
//    
//    date = [date dateByAddingTimeInterval:timeZoneOffset];
    return date;
}
+ (NSDate *)yesterday{
    return  [NSDate dateWithTimeIntervalSinceNow:-(24*60*60)];
}

+(NSDateFormatter *)formatter {
    
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDoesRelativeDateFormatting:YES];
    });
    
    return formatter;
}

+(NSDateFormatter *)formatterWithoutTime {
    
    static NSDateFormatter *formatterWithoutTime = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        formatterWithoutTime = [[NSDate formatter] copy];
        [formatterWithoutTime setTimeStyle:NSDateFormatterNoStyle];
    });
    
    return formatterWithoutTime;
}

+(NSDateFormatter *)formatterWithoutDate {
    
    static NSDateFormatter *formatterWithoutDate = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        formatterWithoutDate = [[NSDate formatter] copy];
        [formatterWithoutDate setDateStyle:NSDateFormatterNoStyle];
    });
    
    return formatterWithoutDate;
}

#pragma mark -
#pragma mark Formatter with date & time
-(NSString *)formatWithUTCTimeZone {
    return [self formatWithTimeZoneOffset:0];
}

-(NSString *)formatWithLocalTimeZone {
    return [self formatWithTimeZone:[NSTimeZone localTimeZone]];
}

-(NSString *)formatWithTimeZoneOffset:(NSTimeInterval)offset {
    return [self formatWithTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:offset]];
}

-(NSString *)formatWithTimeZone:(NSTimeZone *)timezone {
    NSDateFormatter *formatter = [NSDate formatter];
    [formatter setTimeZone:timezone];
    return [formatter stringFromDate:self];
}

#pragma mark -
#pragma mark Formatter without time
-(NSString *)formatWithUTCTimeZoneWithoutTime {
    return [self formatWithTimeZoneOffsetWithoutTime:0];
}

-(NSString *)formatWithLocalTimeZoneWithoutTime {
    return [self formatWithTimeZoneWithoutTime:[NSTimeZone localTimeZone]];
}

-(NSString *)formatWithTimeZoneOffsetWithoutTime:(NSTimeInterval)offset {
    return [self formatWithTimeZoneWithoutTime:[NSTimeZone timeZoneForSecondsFromGMT:offset]];
}

-(NSString *)formatWithTimeZoneWithoutTime:(NSTimeZone *)timezone {
    NSDateFormatter *formatter = [NSDate formatterWithoutTime];
    [formatter setTimeZone:timezone];
    return [formatter stringFromDate:self];
}

#pragma mark -
#pragma mark Formatter without date
-(NSString *)formatWithUTCWithoutDate {
    return [self formatTimeWithTimeZone:0];
}
-(NSString *)formatWithLocalTimeWithoutDate {
    return [self formatTimeWithTimeZone:[NSTimeZone localTimeZone]];
}

-(NSString *)formatWithTimeZoneOffsetWithoutDate:(NSTimeInterval)offset {
    return [self formatTimeWithTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:offset]];
}

-(NSString *)formatTimeWithTimeZone:(NSTimeZone *)timezone {
    NSDateFormatter *formatter = [NSDate formatterWithoutDate];
    [formatter setTimeZone:timezone];
    return [formatter stringFromDate:self];
}
#pragma mark -
#pragma mark Formatter  date
+ (NSString *)currentDateStringWithFormat:(NSString *)format
{
    NSDate *chosenDate = [NSDate nowDate];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    NSString *date = [formatter stringFromDate:chosenDate];
    return date;
}
+ (NSDate *)dateWithSecondsFromNow:(NSInteger)seconds {
    NSDate *date = [NSDate nowDate];
    NSDateComponents *components = [NSDateComponents new];
    [components setSecond:seconds];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *dateSecondsAgo = [calendar dateByAddingComponents:components toDate:date options:0];
    return dateSecondsAgo;
}

+ (NSDate *)dateWithYear:(NSInteger)year month:(NSUInteger)month day:(NSUInteger)day {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:year];
    [components setMonth:month];
    [components setDay:day];
    return [calendar dateFromComponents:components];
}
- (NSString *)dateWithFormat:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    NSString *date = [formatter stringFromDate:self];
    return date;
}
- (NSString *)yyyyMMByLineWithDate{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"yyyy-MM"];
    [formatter setDateFormat:@"MM月"];
    return [formatter stringFromDate:self];
}

- (NSString *)getLastMonthWithDate{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM"];
    
    NSInteger nowMonth=[[formatter stringFromDate:self] integerValue];
    NSInteger lastMonth =0;
    if(nowMonth>1)
    {
        lastMonth=nowMonth-1;
    }else
    {
        lastMonth=12;
    }
    return [[NSString alloc] initWithFormat:@"%ld月",lastMonth];
}
- (NSString *)getNextMonthWithDate{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM"];
    
    NSInteger nowMonth=[[formatter stringFromDate:self] integerValue];
    NSInteger nextMonth =0;
    if(nowMonth>11)
    {
        nextMonth=1;
        
    }else
    {
        nextMonth=nowMonth+1;
    }
    return [[NSString alloc] initWithFormat:@"%ld月",nextMonth];
}

- (NSString *)mmddByLineWithDate{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd"];
    return [formatter stringFromDate:self];
}

- (NSString *)mmddChineseWithDate{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM月dd日"];
    return [formatter stringFromDate:self];
}

- (NSString *)hhmmssWithDate{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    [formatter setDateFormat:@"HH:mm:ss"];
    return [formatter stringFromDate:self];
}

- (NSString *)yyyyMMddByLineWithDate{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    return [formatter stringFromDate:self];
}

- (NSString *)morningOrAfterWithHH{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH"];
    NSString *status = [formatter stringFromDate:self];
    if (status.intValue > 0 && status.intValue < 12) {
        return @"上午好";
    }else{
        return @"下午好";
    }
    return @"";
}

@end
