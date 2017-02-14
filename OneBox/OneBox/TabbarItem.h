//
//  TabbarItem.h
//  爱限免
//
//  Created by huangdl on 14-9-28.
//  Copyright (c) 2014年 1000phone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabbarItem : UIButton
//type属性为了区分不同情况下item的不同定制
@property (nonatomic,assign) NSInteger type;
@end
