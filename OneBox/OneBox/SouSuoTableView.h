//
//  SouSuoTableView.h
//  OneBox
//
//  Created by yyj on 2018/4/23.
//  Copyright © 2018年 谢江新. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TableViewSliderParameterModel;

@interface SouSuoTableView : UITableView

- (instancetype)initWithFrame:(CGRect)frame
                        style:(UITableViewStyle)style
               parameterModel:(TableViewSliderParameterModel *)parameterModel
                    arrayData:(NSMutableArray *)arrayData
         dictPinyinAndChinese:(NSDictionary *)dictPinyinAndChinese
                    arrayChar:(NSMutableArray *)arrayChar
               isFirstRequest:(NSNumber *)isFirstRequest
         souSuoTableViewBlock:(void (^)(NSString *type,NSIndexPath *indexPath))souSuoTableViewBlock;

- (void)createHeaderViewWhenNoData;

- (void)animationNotification;

//pulib属性，允许外界访问
@property (nonatomic, strong) UIView *footerView;

@property (nonatomic, strong) UIView *banbenView;

@end
