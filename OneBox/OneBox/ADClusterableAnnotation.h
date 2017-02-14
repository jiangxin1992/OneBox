//
//  academicRecordModel.h
//  OneBox
//
//  Created by 谢江新 on 15/5/18.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface ADClusterableAnnotation : NSObject <MKAnnotation>

- (id)initWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property NSDictionary* dict;
@property NSString* name;

@end
