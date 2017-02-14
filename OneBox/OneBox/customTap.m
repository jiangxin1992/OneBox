//
//  academicRecordModel.h
//  OneBox
//
//  Created by 谢江新 on 15/5/18.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import "customTap.h"

@implementation customTap
-(id)initWithTarget:(id)target action:(SEL)action dictionary:(NSDictionary *)dictionary view:(MKAnnotationView*)v{
    self=[super initWithTarget:target action:action];
    
    if(self){
        _dict=dictionary;
        _v=v;
    }
    return self;
}
@end
