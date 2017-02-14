//
//  RetrievePasswordController.h
//  OneBox
//
//  Created by 谢江新 on 15-2-5.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef  void(^bl)();

@interface RetrievePasswordController : UIViewController
{
    void(^registerBlock)();
    void(^registerBlock2)();
}

__string(type1);
__string(type);
@property (nonatomic,copy)bl block2;
@property (nonatomic,copy)bl block;

@end
