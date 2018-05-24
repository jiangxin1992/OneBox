//
//  ChooseRegisterViewController.h
//  OneBox
//
//  Created by 谢江新 on 15/11/20.
//  Copyright © 2015年 谢江新. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef  void(^bl)(void);

@interface ChooseRegisterViewController: UIViewController
{
    void(^disblock)(void);
    void(^resetpasswordBlock)(void);
    void(^resetpasswordBlock2)(void);
}

__string(type);
@property (nonatomic,copy)bl block;

@end
