//
//  FoundViewController.h
//  OneBox
//
//  Created by 谢江新 on 15/12/7.
//  Copyright © 2015年 谢江新. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ArticleModel;

@interface ArticleColViewController : UIViewController
{
    void(^changeBlock)(NSInteger row);
    void(^alterBlock)(ArticleModel *model,BOOL _isdelete);
}
@end
