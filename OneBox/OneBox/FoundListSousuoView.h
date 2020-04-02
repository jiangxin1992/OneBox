//
//  FoundListSousuoView.h
//  OneBox
//
//  Created by yyj on 2018/4/8.
//  Copyright © 2018年 谢江新. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FoundListSousuoView : UIView

@property (nonatomic, copy) void (^sousuoViewBlock)(NSString *type ,NSString *textFieldStr);

@end
