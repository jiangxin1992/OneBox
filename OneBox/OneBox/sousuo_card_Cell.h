//

//  OneBox
//
//  Created by 谢江新 on 15/12/18.
//  Copyright © 2015年 谢江新. All rights reserved.
//

#import <UIKit/UIKit.h>

@class foundModel;

typedef  void(^bl)(NSInteger row,NSInteger section,NSString *type);
@interface sousuo_card_Cell : UITableViewCell

@property (nonatomic,copy)bl block;
@property(nonatomic,copy)NSDictionary *dict;

@end
