//
//  BingingAuthViewController.m
//  OneBox
//
//  Created by 谢江新 on 15/11/5.
//  Copyright © 2015年 谢江新. All rights reserved.
//
#import "MyInfo.h"
#import "HttpRequestManager.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import "BingingAuthViewController.h"

@interface BingingAuthViewController ()<UIAlertViewDelegate>

@end

@implementation BingingAuthViewController
{
    MyInfo *info;
    UIAlertView *alertview_wechat;
    UIAlertView *alertview_qq;
    UIAlertView *alertview_sina;
    UIAlertView *alertview_wechat_cancel;
    UIAlertView *alertview_qq_cancel;
    UIAlertView *alertview_sina_cancel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepare];
    [self bangdingUIConfig];
    [self getData];
    // Do any additional setup after loading the view from its nib.
}
-(void)getData
{
    NSString *url = [NSString stringWithFormat:@"%@/v1/users/%@?token=%@",DNS,[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]];
    [HttpRequestManager GET:url complete:^(NSData *data) {
        id res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *_dict=(NSDictionary*)res;
        if([[_dict objectForKey:@"code"] integerValue]==1)
        {
            info = [MyInfo parsingWithJsonDataForModel:data];
            for (int i=0; i<3; i++) {

                BOOL _b=i==0?info.weixin:i==1?info.qq_connect:info.weibo;
                ((UIButton *)[self.view viewWithTag:300+i]).selected=_b;
                if(_b)
                {
                    UILabel *label=(UILabel *)[self.view viewWithTag:400+i];
                    [label setAttributedText:[regular createAttributeString:@"解除绑定" andFloat:@(2.0)]];
                    //                    label.text=@"解 除 绑 定";
                    label.textColor=[UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1];

                }else
                {
                    UILabel *label=(UILabel *)[self.view viewWithTag:400+i];
                     label.text=@"绑   定";
                    label.textColor=_define_blue_color;
                }

            }

        }else
        {
            [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:[_dict objectForKey:@"message"] WithImg:@"Prompt_网络出错白色" Withtype:1]];
        }
        
    } failed:^{
        [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
    }];
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(alertView==alertview_wechat)
    {
        if(buttonIndex==1)
        {
            [self reloadStateWithType:SSDKPlatformTypeWechat];
        }
    }else if(alertView==alertview_qq)
    {
        if(buttonIndex==1)
        {
            [self reloadStateWithType:SSDKPlatformSubTypeQZone];
        }
    }else if(alertView==alertview_sina)
    {

        if(buttonIndex==1)
        {
            [self reloadStateWithType:SSDKPlatformTypeSinaWeibo];
        }
        
    }else if(alertView==alertview_wechat_cancel)
    {
        if(buttonIndex==1)
        {
            [self bangding_cancel:@"weixin"];
        }

    }else if(alertView==alertview_qq_cancel)
    {
        if(buttonIndex==1)
        {

            [self bangding_cancel:@"qq_connect"];

        }

    }else if(alertView==alertview_sina_cancel)
    {
        if(buttonIndex==1)
        {
            [self bangding_cancel:@"weibo"];
        }

    }
    
}
-(void)bangding_cancel:(NSString *)provider
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    [manager POST:[[NSString alloc] initWithFormat:@"%@/v1/users/cancel_auth_bind",DNS] parameters:@{@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],@"provider":provider} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *html = operation.responseString;
        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];

        if([[dict objectForKey:@"code"] integerValue]==1)
        {
//            @"qq_connect"
//            @"weibo";
//            @"weixin";
            if([provider isEqualToString:@"qq_connect"])
            {
                ((UIButton *)[self.view viewWithTag:301]).selected=NO;
                ((UILabel *)[self.view viewWithTag:401]).text= @"绑   定";
                ((UILabel *)[self.view viewWithTag:401]).textColor=_define_blue_color;

//                label.text=@"绑   定";
            }else if([provider isEqualToString:@"weibo"])
            {
                ((UIButton *)[self.view viewWithTag:302]).selected=NO;
                ((UILabel *)[self.view viewWithTag:402]).text= @"绑   定";
                ((UILabel *)[self.view viewWithTag:402]).textColor=_define_blue_color;

            }else if([provider isEqualToString:@"weixin"])
            {

                ((UIButton *)[self.view viewWithTag:300]).selected=NO;
                ((UILabel *)[self.view viewWithTag:400]).text= @"绑   定";
                ((UILabel *)[self.view viewWithTag:400]).textColor=_define_blue_color;
            }

        }else
        {
           [[ToolManager sharedManager] alertTitle_Simple:[dict objectForKey:@"message"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
    }];
}
-(void)bangdingUIConfig
{
//140

    NSArray *app_arr_normal=@[@"微信Share_select",@"qqShare_select",@"微博Share_select"];
    NSArray *app_arr_select=@[@"微信Share",@"qqShare",@"微博Share"];

    //    134 90
    CGFloat _width=90*_Scale;
//    CGFloat _jiange=(ScreenWidth-100*_Scale*2-3*_width)/2.0f;
    CGFloat _jiange=(ScreenHeight+64-140*3*_Scale)/6.0f;

    CGFloat _y_p=2*_jiange;
    for (int i=0; i<app_arr_select.count; i++) {

        UIButton *btn_app=[UIButton buttonWithType:UIButtonTypeCustom];
        btn_app.frame=CGRectMake((ScreenWidth-_width)/2.0f, _y_p, _width, _width);
        btn_app.tag=300+i;
        [btn_app addTarget:self action:@selector(bangding:) forControlEvents:UIControlEventTouchUpInside];

        [self.view addSubview:btn_app];

        [btn_app setBackgroundImage:[UIImage imageNamed:app_arr_normal[i]] forState:UIControlStateNormal];
        [btn_app setBackgroundImage:[UIImage imageNamed:app_arr_select[i]] forState:UIControlStateSelected];
        btn_app.selected=NO;
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(btn_app.frame)-50*_Scale, CGRectGetMaxY(btn_app.frame)+10*_Scale, CGRectGetWidth(btn_app.frame)+100*_Scale, 50*_Scale)];
//        label.backgroundColor=[UIColor redColor];
        [self.view  addSubview:label];
        label.tag=400+i;
        label.textAlignment=1;
        label.text=@"绑   定";
        label.font=[regular getFont:12.0f];
        label.textColor=_define_blue_color;
        _y_p+=_jiange+_width;
    }
}
-(void)bangding:(UIButton *)btn
{
    BOOL _isinstall=[ShareSDK isClientInstalled:SSDKPlatformSubTypeWechatSession];

    if(btn.tag-300==0)
    {
        //wechat
        if(btn.selected)
        {

            alertview_wechat_cancel=[[UIAlertView alloc] initWithTitle:@"" message:@"是否确定要解除绑定呢？ " delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"是", nil];
            alertview_wechat_cancel.delegate=self;
            [alertview_wechat_cancel show];

        }else
        {
            if(_isinstall)
            {
                alertview_wechat=[[UIAlertView alloc] initWithTitle:@"" message:@"您正在绑定第三方账号，如果此账号已存在，相关数据会丢失，确定绑定吗？ " delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"是", nil];
                alertview_wechat.delegate=self;
                [alertview_wechat show];

            }else
            {
                //            未安装
                [[ToolManager sharedManager] alertTitle_Simple:@"请先下载微信客户端。"];
            }


        }

    }else if(btn.tag-300==1)
    {
        //        qq
        if(btn.selected)
        {

            alertview_qq_cancel=[[UIAlertView alloc] initWithTitle:@"" message:@"是否确定要解除绑定呢？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"是", nil];
            alertview_qq_cancel.delegate=self;
            [alertview_qq_cancel show];
        }else
        {
            alertview_qq=[[UIAlertView alloc] initWithTitle:@"" message:@"您正在绑定第三方账号，如果此账号已存在，相关数据会丢失，确定绑定吗？ " delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"是", nil];
            alertview_qq.delegate=self;
            [alertview_qq show];
        }


    }else
    {
        //        sina
        if(btn.selected)
        {

            alertview_sina_cancel=[[UIAlertView alloc] initWithTitle:@"" message:@"是否确定要解除绑定呢？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"是", nil];
            alertview_sina_cancel.delegate=self;
            [alertview_sina_cancel show];
        }else
        {
            alertview_sina=[[UIAlertView alloc] initWithTitle:@"" message:@"您正在绑定第三方账号，如果此账号已存在，相关数据会丢失，确定绑定吗？ " delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"是", nil];
            alertview_sina.delegate=self;
            [alertview_sina show];

        }
    }

}
- (void)reloadStateWithType:(SSDKPlatformType )type{
    [ShareSDK cancelAuthorize:type];
    [ShareSDK getUserInfo:type onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
        if (state == SSDKResponseStateSuccess)
        {
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            NSString *provide=nil;
            NSDictionary *parameters=nil;
            
            if(type==SSDKPlatformSubTypeQZone)
            {
                provide=@"qq_connect";
                
                
            }else if(type==SSDKPlatformTypeSinaWeibo)
            {
                provide=@"weibo";
                
            }if(type==SSDKPlatformTypeWechat)
            {
                provide=@"weixin";
                
            }
            
            parameters=@{@"userinfo":user.rawData,@"uid": user.uid,@"provider":provide,@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]};
            
            [manager POST:[[NSString alloc] initWithFormat:@"%@/v1/users/auth_bind",DNS] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)  {
                [[ToolManager sharedManager] removeProgress];
                
                NSString *html = operation.responseString;
                NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
                
                if([[dict objectForKey:@"code"] integerValue]==1)
                {
#pragma mark-点亮
                    if(type==SSDKPlatformSubTypeQZone)
                    {
                        //                         provide=@"qq_connect";
                        ((UIButton *)[self.view viewWithTag:301]).selected=YES;
                        UILabel *label=(UILabel *)[self.view viewWithTag:401];
                        [label setAttributedText:[regular createAttributeString:@"解除绑定" andFloat:@(2.0)]];
                        //                         label.text=@"解 除 绑 定";
                        label.textColor=[UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1];
                        
                    }else if(type==SSDKPlatformTypeSinaWeibo)
                    {
                        //                         provide=@"weibo";
                        ((UIButton *)[self.view viewWithTag:302]).selected=YES;
                        UILabel *label=(UILabel *)[self.view viewWithTag:402];
                        [label setAttributedText:[regular createAttributeString:@"解除绑定" andFloat:@(2.0)]];
                        //                         label.text=@"解 除 绑 定";
                        label.textColor=[UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1];
                        
                    }if(type==SSDKPlatformTypeWechat)
                    {
                        //                         provide=@"weixin";
                        ((UIButton *)[self.view viewWithTag:300]).selected=YES;
                        UILabel *label=(UILabel *)[self.view viewWithTag:400];
                        [label setAttributedText:[regular createAttributeString:@"解除绑定" andFloat:@(2.0)]];
                        //                         label.text=@"解 除 绑 定";
                        label.textColor=[UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1];
                        
                    }
                }else
                {
                    [[ToolManager sharedManager] alertTitle_Simple:[dict objectForKey:@"message"]];
                    [[ToolManager sharedManager] removeProgress];
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                //                [[ToolManager sharedManager] removeProgress];
                [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
            }];
        }
        else
        {
            if(error)
            {
                //                                   [self presentViewController:[regular alertTitle_Simple:NSLocalizedString(error.description, @"")] animated:YES completion:nil];
                //                 NSLog(@"分享失败,错误码:%ld,错误描述:%@", (long)[error errorCode], [error errorDescription]);
            }
        }
    }];
    
}
-(void)prepare
{
    UIBarButtonItem *_btn=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回箭头"] style:UIBarButtonItemStylePlain target:self action:@selector(popviewAction)];
    self.navigationItem.leftBarButtonItem=_btn;
//    self.navigationItem.titleView=[regular returnNavView:@"三方绑定" withmaxwidth:230];
    self.view.backgroundColor=_define_backview_color;
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
