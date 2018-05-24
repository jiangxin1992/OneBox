//
//  citychooseViewController.h
//  OneBox
//
//  Created by 谢江新 on 15/10/30.
//  Copyright © 2015年 谢江新. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PersoninfoViewController;

@interface citychooseViewController : UIViewController

@property (nonatomic,strong)PersoninfoViewController *person;
@property(nonatomic,copy)NSDictionary *dict;

@end
