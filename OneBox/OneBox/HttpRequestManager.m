//
//  HttpRequestManager.m
//  爱限免
//
//  Created by huangdl on 14-10-8.
//  Copyright (c) 2014年 1000phone. All rights reserved.
//

#import "HttpRequestManager.h"
@implementation HttpRequest
{
    NSMutableData *_data;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        _data = [[NSMutableData alloc]init];
    }
    return self;
}
-(void)startRequest
{
    
    [NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]] delegate:self];
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [_data setLength:0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_data appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //列表页,如果返回数据存在,将下载的数据,加到缓存数据后面
       _completecb(_data);
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    _failedcb();
}


@end

@interface HttpRequestManager ()

+(id)sharedManager;

@end


@implementation HttpRequestManager

+(id)sharedManager
{
    static HttpRequestManager *_m = nil;
    if (!_m) {
        _m = [[HttpRequestManager alloc]init];
    }
    return _m;
}

-(void)getUrl:(NSString *)url complete:(void (^)(NSData *))completeCB failed:(void (^)())failedCB
{
    
    HttpRequest *req = [[HttpRequest alloc]init];
    req.url = url;
    req.completecb = completeCB;
    req.failedcb = failedCB;
    [req startRequest];
}

+ (void)GET:(NSString *)url complete:(void (^)(NSData *))completeCB failed:(void (^)())failedCB
{
    [[self sharedManager] getUrl:url complete:completeCB failed:failedCB];
}




@end





