//
//  MapViewController.h
//  OneBox
//
//  Created by 谢江新 on 15-2-2.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController<MKMapViewDelegate>
@property NSInteger choice;


//- (IBAction)userimageclc:(id)sender;


@property MKAnnotationView* selected_MKAnnotationView;


//- (IBAction)shoucangclc:(id)sender;


@property BOOL showcard;
@property NSMutableArray* annoations;
@property NSArray* annoations1;


@end
