//
//  CollectionSchoolViewController.h
//  OneBox
//
//  Created by 谢江新 on 15/3/11.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionSchoolViewController : UIViewController{
    void(^changeBlock)(NSInteger rownum);
}
@property (nonatomic,copy)NSDictionary *dict;

@end
