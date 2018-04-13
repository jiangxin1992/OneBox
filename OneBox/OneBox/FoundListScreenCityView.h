//
//  FoundListScreenCityView.h
//  OneBox
//
//  Created by yyj on 2018/4/12.
//  Copyright © 2018年 谢江新. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FoundListScreenCityView : UIView

@property (nonatomic, copy) void (^screenCityViewBlock)(NSString *type);

@property (nonatomic, strong) NSMutableString *state;//当前州名
@property (nonatomic, strong) NSMutableString *city;//当前城市名
@property (nonatomic, strong) NSMutableString *state_id;//当前州ID
@property (nonatomic, strong) NSMutableString *city_id;//当前城市ID

-(void)updateUI;

@end
