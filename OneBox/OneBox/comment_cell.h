//
//  comment_cell.h
//  OneBox
//
//  Created by 谢江新 on 15/2/25.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef  void(^bl)(NSNumber *rownum,NSInteger type);
@interface comment_cell : UITableViewCell
@property (nonatomic,copy)bl block;
@property (nonatomic,copy)NSDictionary *dict;

@end
