//
//  userInfoViewController.h
//  OneBox
//
//  Created by 谢江新 on 15-2-4.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface userInfoViewController : UIViewController
{
        void(^updataInfo)(NSDictionary *dict);
}
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UIImageView *headimg;

@end
