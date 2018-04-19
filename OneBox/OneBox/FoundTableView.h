//
//  FoundTableView.h
//  OneBox
//
//  Created by yyj on 2018/4/18.
//  Copyright © 2018年 谢江新. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FoundTableViewParameterModel;

@interface FoundTableView : UITableView

@property (nonatomic, strong) NSMutableArray *arrayData;//存放页面的数据

@property (nonatomic, strong) FoundTableViewParameterModel *parameterModel;

@property (nonatomic, copy) void (^foundTableViewBlock)(NSString *type,NSIndexPath *indexPath);

@end
