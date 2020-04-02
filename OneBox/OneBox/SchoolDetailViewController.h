//
//  SchoolDetailViewController.h
//  OneBox
//
//  Created by 谢江新 on 15/6/23.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SchoolDetailViewController : UIViewController

@property (nonatomic, strong) UISwipeGestureRecognizer *leftSwipeGestureRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer *rightSwipeGestureRecognizer;
@property (nonatomic,copy)NSDictionary *data_dict;
@property (nonatomic,assign)BOOL islogin;
__string(sid);

@end
