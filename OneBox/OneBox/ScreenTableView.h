//
//  ScreenTableView.h
//  OneBox
//
//  Created by yyj on 2018/5/14.
//  Copyright © 2018年 谢江新. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TableViewSliderParameterModel,ScreenViewController;

@interface ScreenTableView : UITableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style controller:(ScreenViewController *)controller;

- (void)createSearchBar;

@property (nonatomic, strong) TableViewSliderParameterModel *parameterModel;

@property (nonatomic, strong) NSMutableArray *arrayData;//存放页面的数据

@property (nonatomic, strong) NSDictionary *dictPinyinAndChinese;

@property (nonatomic, strong) NSMutableArray *arrayChar;

@property (nonatomic, strong) NSMutableDictionary *dictPinyinAndChinese1;

@property (nonatomic, strong) NSMutableArray *arrayChar1;

@property (nonatomic, strong) ScreenViewController *controller;

@property (nonatomic, copy) void (^SreenTableViewBlock)(NSString *type,NSIndexPath *indexPath);

@end
