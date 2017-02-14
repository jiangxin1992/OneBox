//
//  statechooseViewController.h
//  OneBox
//
//  Created by 谢江新 on 15/10/30.
//  Copyright © 2015年 谢江新. All rights reserved.
//
#import "personinfoViewController.h"
#import <UIKit/UIKit.h>

@interface statechooseViewController : UIViewController
@property (nonatomic,strong)personinfoViewController *person;
@property (nonatomic,copy)NSDictionary *dict;
@end
