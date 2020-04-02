//
//  WebViewController.h
//  OneBox
//
//  Created by 谢江新 on 15/7/7.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

typedef  void(^bl)(void);
#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController

@property (nonatomic,copy)bl block;
@property(nonatomic,copy)NSDictionary *dict;

@end
