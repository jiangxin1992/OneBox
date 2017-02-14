//
//  FriendsViewController.h
//  OneBox
//
//  Created by 谢江新 on 15/8/13.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendsViewController : UIViewController
{
    void(^changeBlock)(NSNumber *rownum);
}


@end
