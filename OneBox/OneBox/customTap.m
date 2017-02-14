
#import "customTap.h"

@implementation customTap
-(id)initWithTarget:(id)target action:(SEL)action dictionary:(NSDictionary *)dictionary view:(MKAnnotationView*)v{
    self=[super initWithTarget:target action:action];
    
    if(self){
        _dict=dictionary;
        _v=v;
    }
    return self;
}
@end
