//
//  graduationModel.h
//  OneBox
//
//  Created by 谢江新 on 15/2/22.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import "baseModelJX.h"

@interface graduationModel : baseModelJX

+(NSMutableArray *)parsingWithJsonArr:(NSArray *)arr;

__string(rank);
__string(cn_name);
__string(en_name);
__string(en_city);
__string(short_name);

@end
