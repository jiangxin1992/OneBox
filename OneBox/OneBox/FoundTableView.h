//
//  FoundTableView.h
//  OneBox
//
//  Created by yyj on 2018/4/18.
//  Copyright © 2018年 谢江新. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FoundTableView : UITableView

@property (nonatomic, strong) NSMutableArray *arrayData;//存放页面的数据

@property (nonatomic, strong) NSNumber *nav_donghua;//记录导航栏是否滑动上去（是否消失）BOOL
@property (nonatomic, strong) NSNumber *isdragging;//表示tableview开始拖动，记录拖动的开始 BOOL
@property (nonatomic, strong) NSNumber *isappear;//BOOL

@property (nonatomic, assign) NSNumber * bKeyBoardHide;//判断键盘显示状态

@property (nonatomic, copy) void (^foundTableViewBlock)(NSString *type,NSIndexPath *indexPath);

@end
