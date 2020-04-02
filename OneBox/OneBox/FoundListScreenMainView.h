//
//  FoundListScreenMainView.h
//  OneBox
//
//  Created by yyj on 2018/4/9.
//  Copyright © 2018年 谢江新. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FoundListScreenMainView : UIView

@property (nonatomic, strong) NSNumber *total_students_min;//记录学生数的最小值
@property (nonatomic, strong) NSNumber *ap_count_max;//记录ap课程数量的最大值
@property (nonatomic, strong) NSNumber *total_students_max;//记录学生数的最大值
@property (nonatomic, strong) NSNumber *ap_count_min;//记录ap课程数量的最小值

@property (nonatomic, strong) NSMutableString *state;//当前州名
@property (nonatomic, strong) NSMutableString *city;//当前城市名
@property (nonatomic, strong) NSMutableString *state_id;//当前州ID
@property (nonatomic, strong) NSMutableString *city_id;//当前城市ID

@property (nonatomic, copy) void (^screenMainViewBlock)(NSString *type);

-(void)updateUI;

-(void)initializeUI;

-(NSMutableDictionary *)getParameters;

@end
