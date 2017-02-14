//
//  BoxViewController_new.h
//  OneBox
//
//  Created by 谢江新 on 15/11/25.
//  Copyright © 2015年 谢江新. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BoxViewController_new : UIViewController
{
    void(^shareBlock)(NSString *type);
}
@end
