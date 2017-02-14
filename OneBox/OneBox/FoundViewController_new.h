//
//  FoundViewController_new.h
//  OneBox
//
//  Created by 谢江新 on 15/12/7.
//  Copyright © 2015年 谢江新. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FoundViewController_new : UIViewController
{
    void(^changeBlock)(NSInteger row);
}
@property NSMutableString* ismixed;//是否是混校
@property NSMutableString* ismale;//是否是男校
@property NSMutableString* isfemale;//是否是女校
@property NSMutableString* isday;//是否是走读学校
@property NSMutableString* isboardind;//是否是寄宿学校
@property NSMutableString* isjunior;//是否是初中
@property NSMutableString* issenior;//是否是高中
@property NSMutableString* isESL;//是否ESL
@property NSMutableString* state;//当前州名
@property NSMutableString* city;//当前城市名
@end
