//
//  academicRecordModel.h
//  OneBox
//
//  Created by 谢江新 on 15/5/18.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface customTap : UITapGestureRecognizer
@property NSDictionary* dict;
@property MKAnnotationView* v;
-(id)initWithTarget:(id)target action:(SEL)action dictionary:(NSDictionary*)dictionary view:(MKAnnotationView*)v;
@end
