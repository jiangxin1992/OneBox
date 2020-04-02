//
//  NSDate+Custom.h
//  YCO SPACE
//
//  Created by yyj on 16/8/25.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Custom)

/**
 * 当前月的天数
 */
- (NSUInteger)numberOfDaysInMonth;

/**
 * 当前月的第一天
 */
- (NSDate *)firstDateOfMonth;

/**
 * 当前月的最后一天
 */
-(NSDate *)lastDateOfMonth;

/**
 * 当前月的第一天是周几
 */
- (NSUInteger)startDayOfWeek;

/**
 * 上个月
 */
- (NSDate *)getLastMonth;

/**
 * 下个月
 */
- (NSDate *)getNextMonth;

/**
 * 获取当前day的第一刻
 */
-(NSDate *)getFirstTime;

/**
 * 获取时间戳
 */
-(long)getTime;

@end
