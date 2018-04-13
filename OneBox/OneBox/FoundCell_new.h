//
//  FoundCell.h
//  OneBox
//
//  Created by 谢江新 on 15/2/6.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FoundCell_new : UITableViewCell

@property (nonatomic,copy) void(^block)(NSInteger row);
@property (nonatomic,copy) NSDictionary *dict;

@end
