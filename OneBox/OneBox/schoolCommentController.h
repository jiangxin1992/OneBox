//
//  schoolCommentController.h
//  OneBox
//
//  Created by 谢江新 on 15-2-2.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface schoolCommentController : UIViewController{
    void(^changeBlock)(NSNumber *rownum,NSInteger type);
}

@property (nonatomic,assign)BOOL islogin;
@property (nonatomic,copy)UITableView *tableView;
@property (nonatomic,copy) void(^block)(NSString *title);
@property (nonatomic, strong) UISwipeGestureRecognizer *rightSwipeGestureRecognizer;
__string(sid);

@end
