//
//  Boxlistviewcontroller.h
//  OneBox
//
//  Created by 谢江新 on 15/11/16.
//  Copyright © 2015年 谢江新. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Boxlistviewcontroller : UIViewController
{
    void(^backBlock)(NSString *type,BOOL iscom);
}

@property (nonatomic,copy) void(^block)(NSString*);
@property (nonatomic,copy)NSDictionary *info;
__string(titlename);
@property(nonatomic,assign)NSInteger step;
@property(nonatomic,assign)NSInteger nowstep;

@end
