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

- (instancetype)initWithFrame:(CGRect)frame
                        style:(UITableViewStyle)style
               parameterModel:(TableViewSliderParameterModel *)parameterModel
                    arrayData:(NSMutableArray *)arrayData
         dictPinyinAndChinese:(NSMutableDictionary *)dictPinyinAndChinese
                    arrayChar:(NSMutableArray *)arrayChar
        dictPinyinAndChinese1:(NSMutableDictionary *)dictPinyinAndChinese1
                   arrayChar1:(NSMutableArray *)arrayChar1
               isFirstRequest:(NSNumber *)isFirstRequest
                   controller:(ScreenViewController *)controller
          sreenTableViewBlock:(void (^)(NSString *type,NSIndexPath *indexPath))sreenTableViewBlock;

- (void)createSearchController;

- (void)createHeaderViewWhenNoData;

- (void)removeSearchController;

- (void)animationNotification;

//pulib属性，允许外界访问
@property (nonatomic, strong) UIView *footerView;

@property (nonatomic, strong) UIView *banbenView;

@end
