//
//  FoundListBangdanView.h
//  OneBox
//
//  Created by yyj on 2018/4/9.
//  Copyright © 2018年 谢江新. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FoundListBangdanView : UIView

@property (nonatomic, copy) void (^bangdanViewBlock)(NSString *type);

@end
