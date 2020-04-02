//
//  ResetPwdViewController.h
//  OneBox
//
//  Created by 谢江新 on 15/5/5.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef  void(^bl)(void);

@interface ResetPwdEmialViewController : UIViewController

@property (nonatomic,copy) NSDictionary *dict;
@property (nonatomic,copy)bl block;
@property (nonatomic,copy)bl block2;
@property (nonatomic,copy)NSString *type;

@end
