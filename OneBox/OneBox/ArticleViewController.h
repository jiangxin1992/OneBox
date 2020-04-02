//
//  FoundViewController.h
//  OneBox
//
//  Created by 谢江新 on 15/12/7.
//  Copyright © 2015年 谢江新. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArticleViewController : UIViewController
{
    void(^changeBlock)(NSInteger row);
}
@end
