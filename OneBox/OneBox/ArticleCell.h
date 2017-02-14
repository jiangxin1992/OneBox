//
//  FoundCell.h
//  OneBox
//
//  Created by 谢江新 on 15/2/6.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//
#import "ArticleModel.h"
#import <UIKit/UIKit.h>
typedef  void(^bl)(NSInteger row);
@interface ArticleCell : UITableViewCell

@property (nonatomic,copy)bl block;
@property(nonatomic,copy)NSDictionary *dict;


@end
