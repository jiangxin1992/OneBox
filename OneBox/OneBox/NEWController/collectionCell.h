//
//  collectionCell.h
//  OneBox
//
//  Created by 谢江新 on 15/3/11.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef  void(^bl)(NSInteger rownum);

@interface collectionCell : UITableViewCell<UIAlertViewDelegate>

@property(nonatomic,copy)NSMutableDictionary *dict;
@property (nonatomic,copy)bl block;

@end
