//
//  FoundListTableHeaderView.h
//  OneBox
//
//  Created by yyj on 2018/4/8.
//  Copyright © 2018年 谢江新. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FoundListTableHeaderView : UIView

@property (nonatomic, copy) NSString *backViewImagePath;
@property (nonatomic, copy) void (^headViewBlock)(NSString *type ,NSString *textFieldStr);

-(void)updateUI;

@end
