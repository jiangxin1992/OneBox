//
//  academicRecordModel.h
//  OneBox
//
//  Created by 谢江新 on 15/5/18.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class ADMapPointAnnotation;

@interface ADMapCluster : NSObject
@property (nonatomic) CLLocationCoordinate2D clusterCoordinate;
@property (weak, nonatomic, readonly) NSString * title;
@property (weak, nonatomic, readonly) NSString * subtitle;
@property (nonatomic, strong) ADMapPointAnnotation * annotation;
@property (weak, nonatomic, readonly) NSMutableArray * originalAnnotations;
@property (nonatomic, readonly) NSInteger depth;
@property (nonatomic, assign) BOOL showSubtitle;
- (id)initWithAnnotations:(NSArray *)annotations atDepth:(NSInteger)depth inMapRect:(MKMapRect)mapRect gamma:(double)gamma clusterTitle:(NSString *)clusterTitle showSubtitle:(BOOL)showSubtitle;
+ (ADMapCluster *)rootClusterForAnnotations:(NSArray *)annotations gamma:(double)gamma clusterTitle:(NSString *)clusterTitle showSubtitle:(BOOL)showSubtitle;
- (NSArray *)find:(NSInteger)N childrenInMapRect:(MKMapRect)mapRect;
- (NSArray *)children;
- (BOOL)isAncestorOf:(ADMapCluster *)mapCluster;
- (BOOL)isRootClusterForAnnotation:(id<MKAnnotation>)annotation;
- (NSInteger)numberOfChildren;
- (NSArray *)namesOfChildren;
@end
