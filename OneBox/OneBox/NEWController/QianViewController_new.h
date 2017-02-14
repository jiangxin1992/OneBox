//
//  QianViewController_new.h
//  OneBox
//
//  Created by 谢江新 on 15/7/7.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QianViewController_new : UIViewController
@property (nonatomic,copy) void(^block)(NSString*,BOOL);
@property (nonatomic,assign)NSInteger step;
@end
