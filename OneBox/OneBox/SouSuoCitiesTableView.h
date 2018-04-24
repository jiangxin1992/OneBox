//
//  SouSuoCitiesTableView.h
//  OneBox
//
//  Created by yyj on 2018/4/23.
//  Copyright © 2018年 谢江新. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TableViewSliderParameterModel;

@interface SouSuoCitiesTableView : UITableView

@property (nonatomic, strong) TableViewSliderParameterModel *parameterModel;

@property (nonatomic, strong) NSMutableArray *arrayData;//存放页面的数据

@property (nonatomic, strong) NSDictionary *dictPinyinAndChinese;

@property (nonatomic, strong) NSMutableArray *arrayChar;

@property (nonatomic, copy) void (^souSuoCitiesTableViewBlock)(NSString *type,NSIndexPath *indexPath);


@end
