

#import "ADMapPointAnnotation.h"

@implementation ADMapPointAnnotation

- (id)initWithAnnotation:(id<MKAnnotation>)annotation {
    self = [super init];
    if (self) {
        _mapPoint = MKMapPointForCoordinate(annotation.coordinate);
        _annotation = annotation;
    }
    return self;
}

@end
