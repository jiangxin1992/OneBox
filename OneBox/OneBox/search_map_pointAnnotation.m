//
//  academicRecordModel.h
//  OneBox
//
//  Created by 谢江新 on 15/5/18.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

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
