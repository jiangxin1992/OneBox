//
//  CountryCodeViewController.h
//  OneBox
//
//  Created by 谢江新 on 15/11/6.
//  Copyright © 2015年 谢江新. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef  void(^bl)(NSString *code);

@interface CountryCodeViewController : UIViewController

@property (nonatomic,copy)bl block;

@end
