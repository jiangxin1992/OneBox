//
//  FlyUsaViewController_new.h
//  OneBox
//
//  Created by 谢江新 on 15/7/8.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlyUsaViewController_new : UIViewController

@property (nonatomic,copy) void(^block)(NSString*);
@property (nonatomic,assign)NSInteger step;

@end
