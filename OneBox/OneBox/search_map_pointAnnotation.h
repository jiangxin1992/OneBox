
#import <MapKit/MapKit.h>
#import <MapKit/MapKit.h>
#import "ADMapCluster.h"
@interface search_map_pointAnnotation :MKPointAnnotation

@property NSDictionary* dict;
@property (nonatomic) CLLocationCoordinate2D coordinate;
- (id)initWithDictionary:(NSDictionary *)dictionary;
@end
