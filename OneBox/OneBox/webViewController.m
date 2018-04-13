//
//  webViewController.m
//  OneBox
//
//  Created by 谢江新 on 15/7/7.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import "webViewController.h"

@interface webViewController ()<UIWebViewDelegate>

@end

@implementation webViewController
{

    UIWebView *web;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
}



-(void)loadData
{

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    [manager GET:[[NSString alloc] initWithFormat:@"%@%@%@",DNS,@"/v1/app_settings/",[_dict objectForKey:@"type"]] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSString *html = operation.responseString;
        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
        NSString *str2=nil;
        if([[dict objectForKey:@"data"] objectForKey:@"html_url"]==[NSNull null])
        {
            str2=@"";
        }else
        {
            str2=[[dict objectForKey:@"data"] objectForKey:@"html_url"];
        }
        web.backgroundColor = [UIColor clearColor];
        web.delegate=self;

        if(![str2 isEqualToString:@""])
        {
            NSURL *url =[NSURL URLWithString:str2];
            NSURLRequest *request =[NSURLRequest requestWithURL:url];
            [web loadRequest:request];

        }
        web.opaque = NO;
        web.dataDetectorTypes = UIDataDetectorTypeNone;


    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错蓝色" Withtype:2]];
    }];
    
}
-(void)setDict:(NSDictionary *)dict
{
    if(_dict!=dict)
    {
        _dict=[dict copy];

        self.view.backgroundColor= _define_backview_color;

        UIImageView *daohang=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, kStatusBarAndNavigationBarHeight)];
        [self.view addSubview:daohang];
        daohang.image=[UIImage imageNamed:@"导航底图"];
        daohang.userInteractionEnabled=YES;

        UILabel *label_title=[[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth-250)/2.0f, kStatusBarHeight, 250, kNavigationBarHeight)];
        label_title.font=[regular getFont:16.0f];

        [label_title setAttributedText:[regular createAttributeString:[_dict objectForKey:@"title"] andFloat:@(9.0/3.0)]];
        label_title.textColor=[UIColor whiteColor];
        label_title.textAlignment=1;
        [daohang addSubview:label_title];

        UIButton *backbtn=[UIButton getCustomImgBtnWithImageStr:@"返回箭头" WithSelectedImageStr:nil];
        backbtn.frame=CGRectMake(0, kStatusBarHeight, kNavigationBarHeight, kNavigationBarHeight);
        [backbtn addTarget:self action:@selector(popviewAction) forControlEvents:UIControlEventTouchUpInside];
        [daohang addSubview:backbtn];


        web=[[UIWebView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(daohang.frame), ScreenWidth, ScreenHeight-kStatusBarAndNavigationBarHeight)];
        [self.view addSubview:web];
        if (@available(iOS 11.0, *)) {
            web.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [self loadData];

    }
}

-(void)popviewAction
{
    self.block();
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"webViewController"];

    [self.navigationController setNavigationBarHidden:YES animated:NO];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"webViewController"];
//      [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}


@end
