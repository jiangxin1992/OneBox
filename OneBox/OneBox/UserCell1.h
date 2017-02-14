//
//  UserCell.h
//  OneBox
//
//  Created by 谢江新 on 15/9/2.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef  void(^bl)(NSNumber *rownum);

@interface UserCell1 : UITableViewCell

@property (nonatomic,copy) NSDictionary *dict;
@property (nonatomic,copy)bl block;

@end
