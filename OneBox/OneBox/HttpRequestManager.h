//
//  HttpRequestManager.h
//  爱限免
//
//  Created by huangdl on 14-10-8.
//  Copyright (c) 2014年 1000phone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpRequest : NSObject<NSURLConnectionDataDelegate>

@property (nonatomic,copy) NSString *url;
@property (nonatomic,copy) void(^completecb)(NSData *);
@property (nonatomic,copy) void(^failedcb)(void);


-(void)startRequest;

@end


@interface HttpRequestManager : NSObject

+(void)GET:(NSString *)url complete:(void(^)(NSData *))completeCB failed:(void(^)(void))failedCB;

@end












