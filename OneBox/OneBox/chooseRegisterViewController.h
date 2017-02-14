//
//  chooseRegisterViewController.h
//  OneBox
//
//  Created by 谢江新 on 15/11/20.
//  Copyright © 2015年 谢江新. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef  void(^bl)();
@interface chooseRegisterViewController : UIViewController
{
    void(^disblock)();
    void(^resetpasswordBlock)();
    void(^resetpasswordBlock2)();
}
__string(type);
@property (nonatomic,copy)bl block;
@end
