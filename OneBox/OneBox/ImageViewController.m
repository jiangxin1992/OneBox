//
//  ImageViewController.m
//  AdminMeetimeApp
//
//  Created by 谢江新 on 14-12-5.
//  Copyright (c) 2014年 谢江新. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController ()<UIWebViewDelegate>
{
    DBImageView *_imgv;
    UIWebView *_webView;
}
@end

@implementation ImageViewController
-(void)loadView
{
    self.view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth*9/16)];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    //        http://player.youku.com/embed/XMTMwNzcyOTQ0OA
    [self.view addSubview: _webView];
    if (@available(iOS 11.0, *)) {
        _webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    _webView.delegate=self;
    _webView.hidden=YES;


    _imgv = [[DBImageView alloc]initWithFrame:self.view.bounds];
    _imgv.placeHolder=[UIImage imageNamed:@"found_newsearch_back_360"];
    _imgv.contentMode=UIViewContentModeScaleAspectFill;
    _imgv.userInteractionEnabled=YES;
    [self.view addSubview:_imgv];
    _imgv.hidden=YES;

}


-(void)setCurrentPage:(NSInteger)currentPage
{
    if (currentPage<0) {
        currentPage = _maxPage;
    }
    if (currentPage > _maxPage) {
        currentPage = 0;
    }
    _currentPage = currentPage;
    _imgv.hidden=NO;
    _webView.hidden=YES;
    if([[_array[currentPage] objectForKey:@"type"] isEqualToString:@"image"])
    {

        NSString *str=[_array[currentPage] objectForKey:@"url"];
        NSString *imageStr=nil;
        if(kIPhone4s)
        {
            imageStr=[NSString stringWithFormat:@"%@?imageView2/1/w/480/h/320",str];
        }else if(kIPhone5s||kIPhone6)
        {
            imageStr=[NSString stringWithFormat:@"%@?imageView2/1/w/720/h/480",str];
        }else
        {
            imageStr=[NSString stringWithFormat:@"%@?imageView2/1/w/960/h/640",str];
        }
        
        [_imgv setImageWithPath:imageStr];

    }else if([[_array[currentPage] objectForKey:@"type"] isEqualToString:@"video"])
    {
        [_imgv setImage:[UIImage imageNamed:@"found_newsearch_back_360"]];

        NSString *str=[_array[currentPage] objectForKey:@"url"];
        NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:str]];
        [_webView loadRequest:request];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    webView.hidden=NO;
    _imgv.hidden=YES;
    webView.backgroundColor = [UIColor blackColor];
    [(UIScrollView *)[[webView subviews] objectAtIndex:0] setBounces:NO];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
