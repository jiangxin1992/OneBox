//
//  collectionSchool.h
//  OneBox
//
//  Created by 谢江新 on 15/3/11.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "surveyModel.h"

@interface collectionSchool : UIViewController
{
    void(^changeBlock)(NSInteger rownum);
}
@property (nonatomic,copy)NSDictionary *dict;
//__string(type);
@end
