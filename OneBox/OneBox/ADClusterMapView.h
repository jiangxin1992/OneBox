//
//  academicRecordModel.h
//  OneBox
//
//  Created by 谢江新 on 15/5/18.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class ADClusterMapView;
@class ADClusterAnnotation;
@protocol ADClusterMapViewDelegate <MKMapViewDelegate>
@optional
- (NSInteger)numberOfClustersInMapView:(ADClusterMapView *)mapView; // default: 32
- (MKAnnotationView *)mapView:(ADClusterMapView *)mapView viewForClusterAnnotation:(id <MKAnnotation>)annotation; // default: same as returned by mapView:viewForAnnotation:
- (BOOL)shouldShowSubtitleForClusterAnnotationsInMapView:(ADClusterMapView *)mapView; // default: YES
- (double)clusterDiscriminationPowerForMapView:(ADClusterMapView *)mapView; // This parameter emphasize the discrimination of annotations which are far away from the center of mass. default: 1.0 (no discrimination applied)
- (NSString *)clusterTitleForMapView:(ADClusterMapView *)mapView; // default : @"%d elements"
- (void)clusterAnimationDidStopForMapView:(ADClusterMapView *)mapView;
- (void)mapViewDidFinishClustering:(ADClusterMapView *)mapView;
@end

@interface ADClusterMapView : MKMapView <MKMapViewDelegate>
- (ADClusterAnnotation *)clusterAnnotationForOriginalAnnotation:(id<MKAnnotation>)annotation; // returns the ADClusterAnnotation instance containing the annotation originally added.
- (void)selectClusterAnnotation:(ADClusterAnnotation *)annotation animated:(BOOL)animated;
- (void)setAnnotations:(NSArray *)annotations; // entry point for the annotations that you want to cluster
- (void)addNonClusteredAnnotations:(NSArray *)annotations;
- (void)addNonClusteredAnnotation:(id<MKAnnotation>)annotation;
- (void)removeNonClusteredAnnotations:(NSArray *)annotations;
- (void)removeNonClusteredAnnotation:(id<MKAnnotation>)annotation;
@property (weak, nonatomic, readonly) NSArray * displayedAnnotations;
@end
