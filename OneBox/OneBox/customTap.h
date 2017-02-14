
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@interface customTap : UITapGestureRecognizer
@property NSDictionary* dict;
@property MKAnnotationView* v;
-(id)initWithTarget:(id)target action:(SEL)action dictionary:(NSDictionary*)dictionary view:(MKAnnotationView*)v;
@end
