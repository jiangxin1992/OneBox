//
//  AboutViewController.m
//  OneBox
//
//  Created by 谢江新 on 15/6/26.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()<UIWebViewDelegate>

@end

@implementation AboutViewController

{
    UIWebView *web;
}

- (void)viewDidLoad {
    [super viewDidLoad];

}

-(void)loadData
{

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    [manager GET:[[NSString alloc] initWithFormat:@"%@%@%@",DNS,@"/v1/app_settings/",_type] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {

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
        [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
        [[ToolManager sharedManager] removeProgress];
    }];

}


-(void)setType:(NSString *)type
{
    if(_type!=type)
    {
        _type=[type copy];
        [self prapareData];
        [self loadData];
    }
}
-(void)prapareData
{
    self.view.backgroundColor= _define_backview_color;
    UIBarButtonItem *_btn=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回箭头"] style:UIBarButtonItemStylePlain target:self action:@selector(popviewAction)];
    self.navigationItem.leftBarButtonItem=_btn;
    NSString *title=nil;
    if([_type isEqualToString:@"about_us"])
    {
        title=@"关于";

    }else if([_type isEqualToString:@"help"])
    {
        title=@"声明";

    }else if([_type isEqualToString:@"privacy"])
    {
        title=@"隐私";
    }
    self.navigationItem.titleView=[regular returnNavView:title withmaxwidth:230];
    web=[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight+kTabBarHeight)];
    [self.view addSubview:web];
}
-(void)popviewAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation

 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
