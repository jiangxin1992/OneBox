
#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface ADMapPointAnnotation : NSObject
@property (nonatomic, readonly) MKMapPoint mapPoint;
@property (nonatomic, readonly) id<MKAnnotation> annotation;
- (id)initWithAnnotation:(id<MKAnnotation>)annotation;
@end
