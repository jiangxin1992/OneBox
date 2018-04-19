//
//  souSuoViewController.h
//  OneBox
//
//  Created by 谢江新 on 15/6/9.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef  void(^bl)(NSInteger row,NSInteger section,NSString *type);

@interface SouSuoCitiesViewController : UIViewController

@property (nonatomic,copy)bl sousuoBlock;
@property (nonatomic,copy)NSDictionary *cityNameDict;

@end
