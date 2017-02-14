//
//  statechooseViewController.h
//  OneBox
//
//  Created by 谢江新 on 15/10/30.
//  Copyright © 2015年 谢江新. All rights reserved.
//

#import <UIKit/UIKit.h>

@class personinfoViewController;

@interface statechooseViewController : UIViewController

@property (nonatomic,strong)personinfoViewController *person;
@property (nonatomic,copy)NSDictionary *dict;

@end
