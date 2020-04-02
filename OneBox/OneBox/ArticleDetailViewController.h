//
//  ArticleDetailViewController.h
//  OneBox
//
//  Created by 谢江新 on 15/12/24.
//  Copyright © 2015年 谢江新. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ArticleModel,ArticleDetailModel;

typedef  void(^blchange)(ArticleModel *model,BOOL _isdelete);

@interface ArticleDetailViewController : UIViewController

__string(ArticleID);

@property (nonatomic,strong)ArticleModel *model;
@property (nonatomic,strong)blchange block;
@property (nonatomic, strong) UISwipeGestureRecognizer *leftSwipeGestureRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer *rightSwipeGestureRecognizer;

@end
