
#import "search_map_pointAnnotation.h"

@implementation search_map_pointAnnotation
- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        _dict=dictionary;
        
    }
    return self;
}

- (NSString *)title {
    return [self.dict objectForKey:@"EName"];
}

- (NSString *)description {
    return @"";
}
@end
