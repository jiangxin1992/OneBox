//
//  academicRecordModel.h
//  OneBox
//
//  Created by 谢江新 on 15/5/18.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface ADMapPointAnnotation : NSObject
@property (nonatomic, readonly) MKMapPoint mapPoint;
@property (nonatomic, readonly) id<MKAnnotation> annotation;
- (id)initWithAnnotation:(id<MKAnnotation>)annotation;
@end
