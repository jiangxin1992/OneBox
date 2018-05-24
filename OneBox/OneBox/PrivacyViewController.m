//
//  PrivacyViewController.m
//  OneBox
//
//  Created by 谢江新 on 15/6/26.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import "PrivacyViewController.h"

@interface PrivacyViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation PrivacyViewController
#pragma mark - --------------生命周期--------------
- (void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare];
    [self UIConfig];
    [self RequestData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - --------------SomePrepare--------------
- (void)SomePrepare {
    [self PrepareData];
    [self PrepareUI];
}
- (void)PrepareData {

    NSString *title = nil;
    if([_type isEqualToString:@"about_us"])
    {
        title = @"关于";

    }else if([_type isEqualToString:@"help"])
    {
        title = @"声明";

    }else if([_type isEqualToString:@"privacy"])
    {
        title = @"隐私";
    }
    self.navigationItem.titleView = [regular returnNavView:title withmaxwidth:230];

    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回箭头"] style:UIBarButtonItemStylePlain target:self action:@selector(popviewAction)];
    self.navigationItem.leftBarButtonItem = backBtn;

}
- (void)PrepareUI {
    self.view.backgroundColor = _define_backview_color;
}

#pragma mark - --------------UIConfig----------------------
- (void)UIConfig {
    [self createWebView];
}
- (void)createWebView{
    _webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_webView];
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.top.mas_equalTo(0);
    }];
    if (@available(iOS 11.0, *)) {
        _webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    _webView.backgroundColor = _define_white_color;
}

#pragma mark - --------------请求数据----------------------
- (void)RequestData {

    WeakSelf(ws);

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    [manager GET:[[NSString alloc] initWithFormat:@"%@%@%@",DNS,@"/v1/app_settings/",_type] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSString *html = operation.responseString;
        NSData *data = [html dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict = [NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];

        ws.webView.delegate = self;
        ws.webView.backgroundColor = [UIColor clearColor];
        ws.webView.opaque = NO;
        ws.webView.dataDetectorTypes = UIDataDetectorTypeNone;

        if(![NSString isNilOrEmpty:[[dict objectForKey:@"data"] objectForKey:@"html_url"]])
        {
            NSString *html_url = [[dict objectForKey:@"data"] objectForKey:@"html_url"];
            NSURL *url = [NSURL URLWithString:html_url];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            [ws.webView loadRequest:request];
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
    }];
}

#pragma mark - --------------系统代理----------------------


#pragma mark - --------------自定义代理/block----------------------


#pragma mark - --------------自定义响应----------------------
-(void)popviewAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - --------------自定义方法----------------------


#pragma mark - --------------other----------------------


@end
