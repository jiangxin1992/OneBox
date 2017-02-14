//
//  NOTContentViewController.m
//  OneBox
//
//  Created by 谢江新 on 15/8/27.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import "NOTContentViewController.h"

#import "notificationModel.h"

@interface NOTContentViewController ()

@end

@implementation NOTContentViewController
{
    UIScrollView *_scrollview;
    DBImageView *icon;
//    BOOL _isopen;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    _isopen=NO;
    UIBarButtonItem *_btn=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回箭头"] style:UIBarButtonItemStylePlain target:self action:@selector(popviewAction)];
    self.navigationItem.leftBarButtonItem=_btn;
    self.view.backgroundColor= _define_backview_color;
    self.navigationItem.titleView=[regular returnNavView:@"通知详情" withmaxwidth:230];

}
-(void)createScrollView
{
    _scrollview=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight+kTabBarHeight)];
    [self.view addSubview:_scrollview];
    _scrollview.contentSize=CGSizeMake(CGRectGetWidth(_scrollview.frame), 1000);


}
-(void)setModel:(notificationModel *)model
{

    if (_model!= model) {

        _model = model;
        [self createScrollView];
        [self UIConfig];
        if(!model.is_readed)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"isopen" object:model.NOT_ID];
            [self requestData];
        }

    }

}
-(void)requestData
{

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters=[[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],@"token",nil];
    [manager PUT:[[NSString alloc] initWithFormat:@"%@/v1/push_messages/%@",DNS,_model.NOT_ID] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *html = operation.responseString;
        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
        if([[dict objectForKey:@"code"] integerValue]==1)
        {
            if([[dict objectForKey:@"data"] objectForKey:@"no_read_pm_count"]!=[NSNull null])
            {
                if([[[dict objectForKey:@"data"] objectForKey:@"no_read_pm_count"] integerValue]>=0)
                {
                    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:[[[dict objectForKey:@"data"] objectForKey:@"no_read_pm_count"] integerValue]] forKey:@"no_read_pm_count"];
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"nonotification" object:nil];
                }


            }

        }else
        {

            [[ToolManager sharedManager] alertTitle_Simple:[dict objectForKey:@"message"]];

        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
    }];
    
}
-(void)UIConfig
{
    icon=[[DBImageView alloc] initWithFrame:CGRectMake(40*_Scale, 25*_Scale, 76*_Scale , 76*_Scale)];
    icon.placeHolder=[UIImage imageNamed:@"headImg_login1"];
    icon.layer.masksToBounds=YES;
    icon.layer.cornerRadius=CGRectGetWidth(icon.frame)/2.0f;
    [icon setImageWithPath:_model.send_avatar];
    [_scrollview addSubview:icon];


    UILabel *titlelabel=[[UILabel alloc] initWithFrame:CGRectMake(140*_Scale, 25*_Scale, CGRectGetWidth(_scrollview.frame)-170*_Scale, 40*_Scale)];
    [_scrollview addSubview:titlelabel];
    titlelabel.textAlignment=0;
    titlelabel.font=[regular get_en_Font:14.0f];
    titlelabel.textColor=_define_blue_color;

    if([_model.extra_info objectForKey:@"title" ]==nil)
    {
        [titlelabel setAttributedText:[regular createAttributeString:@"" andFloat:@(1.0)]];
    }else
    {
        [titlelabel setAttributedText:[regular createAttributeString:[_model.extra_info objectForKey:@"title" ] andFloat:@(1.0)]];
    }



    UILabel *contentlabel=[[UILabel alloc] initWithFrame:CGRectMake(140*_Scale, CGRectGetMaxY(titlelabel.frame)+30*_Scale, CGRectGetWidth(_scrollview.frame)-170*_Scale, 9999)];
    contentlabel.textAlignment=0;
    contentlabel.font=[regular get_en_Font:13.0f];
    contentlabel.textColor=[UIColor colorWithRed:200.0f/255.0f green:200.0f/255.0f blue:200.0f/255.0f alpha:1];
    contentlabel.numberOfLines=0;
    [contentlabel setAttributedText:[regular createAttributeString:_model.body andFloat:@(1.0)]];
    [contentlabel sizeToFit];

    [_scrollview addSubview:contentlabel];


    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(140*_Scale, CGRectGetMaxY(contentlabel.frame)+30*_Scale, CGRectGetWidth(_scrollview.frame)-170*_Scale, 55*_Scale)];
    UIColor *_color=[UIColor colorWithRed:200.0f/255.0f green:200.0f/255.0f blue:200.0f/255.0f alpha:1];
    label.textColor=_color;
    label.font=[regular get_en_Font:11.0f];
    label.textAlignment=0;
    NSString *str=_model.detail_TIME;
    [label setAttributedText:[regular createAttributeString:str andFloat:@(1.0)]];
    [_scrollview addSubview:label];


    UIView *backview=[[UIView alloc] initWithFrame:CGRectMake((ScreenWidth-100*_Scale)/2,CGRectGetMaxY(label.frame)+100*_Scale, 100*_Scale, 100*_Scale)];
    backview.backgroundColor=[UIColor clearColor];
    [_scrollview addSubview:backview];
    UIImageView *banbenimg=[[UIImageView alloc] initWithFrame:CGRectMake(25*_Scale, 0, 50*_Scale, 50*_Scale)];
    banbenimg.image=[UIImage imageNamed:@"版本_v1.0"];
    [backview addSubview:banbenimg];

    _scrollview.contentSize=CGSizeMake(CGRectGetWidth(_scrollview.frame), CGRectGetMaxY(backview.frame)+30*_Scale);

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
