//
//  academicRecordModel.h
//  OneBox
//
//  Created by 谢江新 on 15/5/18.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import "ADClusterableAnnotation.h"

@interface ADClusterableAnnotation ()

@end

@implementation ADClusterableAnnotation

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        _name = [[NSString alloc] initWithFormat:@"%d",[[dictionary objectForKey:@"id"] integerValue]];
        _dict=dictionary;
        self.coordinate = CLLocationCoordinate2DMake([[dictionary objectForKey:@"latitude"] doubleValue], [[dictionary objectForKey:@"longtitude"] doubleValue]);
    }
    return self;
}

- (NSString *)title {
    return self.description;
}

- (NSString *)description {
    return _name;
}
@end
