

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "ADMapCluster.h"

@interface ADClusterableAnnotation : NSObject <MKAnnotation>
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property NSDictionary* dict;
@property NSString* name;
- (id)initWithDictionary:(NSDictionary *)dictionary;
@end
