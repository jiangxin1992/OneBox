//
//  cardView.h
//  map!!!
//
//  Created by 谢江新 on 15/3/4.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

typedef  void(^bl)();

#import <UIKit/UIKit.h>

@class surveyModel;

@interface cardView : UIView
+(id)sharedManager;
-(void)removeView:(BOOL)isHide;
-(void)setdata:(surveyModel *)model;
@property (nonatomic,copy)bl block;
@property(nonatomic,copy)UIView *card;

@end
