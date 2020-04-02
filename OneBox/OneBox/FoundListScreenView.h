//
//  FoundListScreenView.h
//  OneBox
//
//  Created by yyj on 2018/4/9.
//  Copyright © 2018年 谢江新. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FoundListScreenView : UIView

@property (nonatomic, strong) NSNumber *total_students_min;//记录学生数的最小值
@property (nonatomic, strong) NSNumber *ap_count_max;//记录ap课程数量的最大值
@property (nonatomic, strong) NSNumber *total_students_max;//记录学生数的最大值
@property (nonatomic, strong) NSNumber *ap_count_min;//记录ap课程数量的最小值

@property (nonatomic, copy) void (^screenViewBlock)(NSString *type);

-(void)updateUI;

-(void)initializeUI;

-(NSMutableDictionary *)getParameters;

@end
