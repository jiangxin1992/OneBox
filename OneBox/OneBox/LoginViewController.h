//
//  LoginViewController.h
//  OneBox
//
//  Created by 谢江新 on 15-2-4.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
{
    void(^resetpasswordBlock)(void);
    void(^registerBlock)(void);
}

@property (nonatomic,copy)NSString *type;

@end
