//
//  AdmissionViewController.h
//  OneBox
//
//  Created by 谢江新 on 15/11/4.
//  Copyright © 2015年 谢江新. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef  void(^bl)(NSDictionary *dict,NSInteger num);

@interface AdmissionViewController : UIViewController
@property (nonatomic,copy)bl block;
@property (nonatomic,assign) NSInteger currentPage;
@property (nonatomic,assign) NSInteger maxPage;
@property (nonatomic,copy) NSArray *array;

@end
