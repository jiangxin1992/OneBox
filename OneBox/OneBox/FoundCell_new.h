//
//  FoundCell.h
//  OneBox
//
//  Created by 谢江新 on 15/2/6.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//
#import "foundModel_new.h"
#import <UIKit/UIKit.h>
typedef  void(^blo)(NSInteger row);
@interface FoundCell_new : UITableViewCell
@property (nonatomic,copy)blo block;
@property(nonatomic,copy)NSDictionary *dict;

@end
