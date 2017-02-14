//
//  ArticleDetailViewController.m
//  OneBox
//
//  Created by 谢江新 on 15/12/24.
//  Copyright © 2015年 谢江新. All rights reserved.
//

#import "ArticleDetailViewController.h"

#import "HttpRequestManager.h"
#import <CoreLocation/CoreLocation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

#import "ChatViewController.h"
#import "followerViewController.h"
#import "followingViewController.h"
#import "CustomTabbarController.h"
#import "ArticleCommentController.h"
#import "LoginViewController.h"

#import "ArticleModel.h"
#import "ArticleDetailModel.h"
#import "ArticleDetailModel.h"


@interface ArticleDetailViewController ()<UIWebViewDelegate,MFMailComposeViewControllerDelegate>

@end

@implementation ArticleDetailViewController
{
    YYAnimationIndicator *indicator;
    ArticleDetailModel *_detailModel;

//    工具栏
    UIView *_tabbar;
    UIWebView *web;
    UIButton *shareBtn;
    UILabel *comment_num_label;
    UILabel *_num_p;
    //    收藏数量
    UILabel *_num_c;
     NSInteger praise_Num;//点赞数
    NSInteger coll_Num;//收藏数
    BOOL _isjunp_login;

    UIImageView *imageGray;
    BOOL app1;
    BOOL app2;
    BOOL _isguanzhu;
    NSMutableString *friend_token;
    NSMutableArray *btnarr;

}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    self.rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    self.leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    self.rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:self.leftSwipeGestureRecognizer];
    [self.view addGestureRecognizer:self.rightSwipeGestureRecognizer];

     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCommentNum_Action:) name:@"changenum" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(other) name:@"other" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(xiaoshi:) name:@"xiaoshi" object:nil];
}
- (void)handleSwipes:(UISwipeGestureRecognizer *)sender
{
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        if(_detailModel!=nil)
        {
            ArticleCommentController *comment=[[ArticleCommentController alloc] init];
            comment.sid=_detailModel.m_id;
            [self.navigationController pushViewController:comment animated:YES];
        }
    }
    if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)xiaoshi:(NSNotification *)not
{
    if([not.object isEqualToString:@"other"])
    {
        [self dismissModalViewControllerAnimated:YES];
    }
}
-(void)changeCommentNum_Action:(NSNotification *)not
{
    comment_num_label.text=[[NSString alloc] initWithFormat:@"%ld",(long)[not.object integerValue]];
}
-(void)setArticleID:(NSString *)ArticleID
{
    if(_ArticleID!=ArticleID)
    {
        _ArticleID=[ArticleID copy];
        [self prepareData];
        [self startLoadingAnimation];
        [self requestDataisFrist:YES];
    }
}
-(void)other
{
    _isjunp_login=YES;
    [self dismissModalViewControllerAnimated:YES];
    [self requestDataisFrist:NO];
}
-(void)prepareData
{
    btnarr=[[NSMutableArray alloc] init];
    friend_token=[[NSMutableString alloc] init];
    _isguanzhu=NO;
    shareBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    comment_num_label=[[UILabel alloc] init];
    _num_c=[[UILabel alloc] init];
    _num_p=[[UILabel alloc] init];
    praise_Num=0;
    coll_Num=0;
    _isjunp_login=NO;

}
-(void)requestDataisFrist:(BOOL )isfirst
{
    NSDictionary *_parameters=nil;
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"token"]!=nil)
    {
        _parameters=[[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],@"token", nil];
    }

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    [manager GET:[[NSString alloc] initWithFormat:@"%@/v1/posts/%@",DNS,_ArticleID] parameters:_parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *html = operation.responseString;
        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
        if([[dict objectForKey:@"code"] intValue]==1)
        {
            _detailModel=[ArticleDetailModel parsingWithJsonDataForModel:dict];
            praise_Num=_detailModel.votes_count;
            coll_Num=_detailModel.follows_count;
            NSInteger comment_count=[[[[dict objectForKey:@"data"] objectForKey:@"school_ratings"] objectForKey:@"comment_count"]integerValue];
            comment_num_label.text=[[NSString alloc] initWithFormat:@"%lu",(unsigned long)comment_count];
            if(isfirst)
            {
                //            请求成功
                [self UIConfig];

            }else
            {
                UIButton *btn=(UIButton *)[self.view viewWithTag:7001];
                if(_detailModel.had_voted==YES)
                {
                    btn.selected=YES;
                }else
                {
                    btn.selected=NO;
                }
                UIButton *btn1=(UIButton *)[self.view viewWithTag:7003];
                if(_detailModel.had_followed==YES)
                {
                    btn1.selected=YES;
                }else
                {
                    btn1.selected=NO;
                }
            }
        }else
        {
            [indicator stopAnimationWithLoadText:@"loading..." withType:YES];
            [[ToolManager sharedManager] alertTitle_Simple:[dict objectForKey:@"message"]];
            [self createtabbar];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self createtabbar];
        [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
        [indicator stopAnimationWithLoadText:@"loading..." withType:YES];
    }];
}
-(void)UIConfig
{
    [self createWebview];
    [self createtabbar];
}
-(void)createWebview
{
    web=[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-80*_Scale+kTabBarHeight)];
    web.backgroundColor = [UIColor clearColor];
    web.delegate=self;
//    [web windowScriptObject];
//    [web loadHTMLString:[NSString stringWithFormat:@"<style>body{word-wrap:break-word;margin:0;background-color:transparent;font:14px/20px Custom-Font-Name;align:justify;color:#999999}</style><div align='justify'>%@<div>",_detailModel.app_html_url] baseURL:nil];
    [web loadHTMLString:[NSString stringWithFormat:@"<style></style><div>%@<div>",_detailModel.app_html_url] baseURL:nil];
    [web loadRequest:[[NSURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:_detailModel.app_html_url]]];
    [self.view addSubview:web];

    web.opaque = NO;
    web.dataDetectorTypes = UIDataDetectorTypeNone;

    [web sizeToFit];
    [indicator stopAnimationWithLoadText:@"loading..." withType:YES];

}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSURL * _url = [request URL];
    NSString *_query=[_url query];

    if(_query!=nil)
    {
        if ( [_query rangeOfString:@"author_info"].location !=NSNotFound) {
            JXLOG(@"111");
            [self iconClick];
            return NO;
        }
    }
    return YES;
}
-(void)backxiaoshi
{
    [[self.view.window viewWithTag:1000] removeFromSuperview];
}
-(void)backaction:(UIGestureRecognizer *)ges{}

-(void)friend_list:(UIGestureRecognizer *)ges
{
    //    friend_list
    if(ges.view.tag==6000)
    {
        followerViewController *foll=[[followerViewController alloc] init];
        foll.token=friend_token;
        [self.navigationController pushViewController:foll animated:YES];
        [self backxiaoshi];

    }else
    {
        followingViewController *foll=[[followingViewController alloc] init];
        foll.token=friend_token;
        [self.navigationController pushViewController:foll animated:YES];
        [self backxiaoshi];

    }
}
- (void)iconClick
{
    _isguanzhu=NO;
    imageGray = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"蒙板"]];
    imageGray.tag=1000;
    imageGray.userInteractionEnabled = YES;
    imageGray.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backxiaoshi)];
    [imageGray addGestureRecognizer:tap];
    [self.view.window addSubview:imageGray];

    //    360 400
    UIImageView *backview=[[UIImageView alloc] init];
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] longValue]==[[_detailModel.user objectForKey:@"id"] longLongValue])
    {
        backview.frame=CGRectMake((CGRectGetWidth(imageGray.frame)-360*_Scale)/2.0f, (CGRectGetHeight(imageGray.frame)-312*_Scale)/2.0f, 360*_Scale,302*_Scale);

    }else
    {
        backview.frame=CGRectMake((CGRectGetWidth(imageGray.frame)-360*_Scale)/2.0f, (CGRectGetHeight(imageGray.frame)-600*_Scale)/2.0f, 360*_Scale,426*_Scale);

    }
    backview.backgroundColor=[UIColor whiteColor];
    [imageGray addSubview:backview];
    backview.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap1=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backaction:)];
    [backview addGestureRecognizer:tap1];



    UIView *upview=[[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(backview.frame), 196*_Scale)];
    [backview addSubview:upview];
    upview.backgroundColor=[UIColor whiteColor];

    UIView *middle=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(upview.frame), CGRectGetWidth(backview.frame), 106*_Scale)];
//    middle.backgroundColor=[UIColor yellowColor];


    [backview addSubview:middle];

    UIView *downview=[[UIView alloc] init];

    UIView *view=[[UIView alloc] init];

    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] longValue]==[[_detailModel.user objectForKey:@"id"] longLongValue])
    {
        downview.frame=CGRectMake(0, CGRectGetMaxY(middle.frame), CGRectGetWidth(backview.frame), 0);
        view.frame=CGRectMake(20*_Scale, CGRectGetMaxY(middle.frame), CGRectGetWidth(middle.frame)-40*_Scale, 0);

    }else
    {
        view.frame=CGRectMake(40*_Scale, CGRectGetMaxY(middle.frame), CGRectGetWidth(backview.frame)-80*_Scale, 1*_Scale);
        view.backgroundColor=[UIColor colorWithRed:220.0f/255.0f green:220.0f/255.0f blue:220.0f/255.0f alpha:1];

        downview.frame=CGRectMake(0, CGRectGetMaxY(view.frame), CGRectGetWidth(backview.frame), CGRectGetHeight(backview.frame)-CGRectGetMaxY(view.frame));

        downview.backgroundColor=[UIColor whiteColor];
//        downview.backgroundColor=[UIColor redColor];


        [backview addSubview:downview];
        [backview addSubview:view];
    }


    NSString *url = [NSString stringWithFormat:@"%@/v1/users/%lld?token=%@",DNS,[[_detailModel.user objectForKey:@"id"] longLongValue],[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]];
    [HttpRequestManager GET:url complete:^(NSData *data) {

        NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];

        if([[[dict objectForKey:@"data"] objectForKey:@"had_followed"] integerValue]==0)
        {
            _isguanzhu=NO;
        }else
        {
            _isguanzhu=YES;
        }

        [friend_token setString:[[dict objectForKey:@"data"] objectForKey:@"token"]];

        CGFloat ___jiange=(CGRectGetWidth(middle.frame)-160*_Scale)/3.0f;
        for (int i=0; i<2; i++) {

            UIImageView *_imagev=[[UIImageView alloc] initWithFrame:CGRectMake(___jiange+(80*_Scale+___jiange)*i, -10*_Scale, 80*_Scale, 80*_Scale)];

            [middle addSubview:_imagev];

            UITapGestureRecognizer *friend_list=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(friend_list:)];
            _imagev.tag=6000+i;
            [_imagev addGestureRecognizer:friend_list];
            _imagev.userInteractionEnabled=YES;

            UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_imagev.frame), CGRectGetHeight(_imagev.frame))];
            [_imagev addSubview:label];
            label.textAlignment=1;
            label.textColor=[UIColor colorWithRed:79.0f/255.0f green:190.0f/255.0f blue:221.0f/255.0f alpha:0.8];
            label.font=[regular get_en_Font:20.0f];
            label.text=i==0?[[NSString alloc] initWithFormat:@"%ld",(long)[[[dict objectForKey:@"data"] objectForKey:@"follows_count"] integerValue]]:[[NSString alloc] initWithFormat:@"%ld",(long)[[[dict objectForKey:@"data"] objectForKey:@"following_count"] integerValue]];

            UILabel *label1=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_imagev.frame)-30*_Scale,CGRectGetMaxY(_imagev.frame)-20*_Scale,CGRectGetWidth(_imagev.frame)+60*_Scale,CGRectGetHeight(middle.frame)-CGRectGetMaxY(_imagev.frame))];
            [middle addSubview:label1];
            label1.textAlignment=1;
            label1.font=[regular getFont:10.0f];
            [label1 setAttributedText:[regular createAttributeString:i==0?@"粉丝":@"关注" andFloat:@(1.0)]];
            label1.textColor=[UIColor colorWithRed:200.0f/255.0f green:200.0f/255.0f blue:200.0f/255.0f alpha:1];

        }


        DBImageView * iconImage1 = [[DBImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(upview.frame)-140*_Scale)/2.0f, -70*_Scale, 140*_Scale, 140*_Scale)];
        [upview addSubview:iconImage1];
        iconImage1.userInteractionEnabled = YES;
        iconImage1.layer.masksToBounds = YES;
        iconImage1.layer.cornerRadius = iconImage1.frame.size.width/2.0;
        UIView *zhegai=[[UIView alloc] initWithFrame:CGRectMake(-2*_Scale,-2*_Scale , CGRectGetWidth(iconImage1.frame)+4*_Scale, CGRectGetWidth(iconImage1.frame)+4*_Scale)];
        zhegai.backgroundColor=[UIColor clearColor];
        zhegai.layer.masksToBounds=YES;
        zhegai.layer.cornerRadius=CGRectGetWidth(zhegai.frame)/2.0f;
        zhegai.layer.borderColor = [_define_head_color CGColor];
        zhegai.layer.borderWidth = 4.0f;
        [iconImage1 addSubview:zhegai];

        if(([[dict objectForKey:@"data"] objectForKey:@"avatar"]!=[NSNull null])&&([[dict objectForKey:@"data"] objectForKey:@"avatar"]!=nil))
        {
            NSString *__url=[[dict objectForKey:@"data"] objectForKey:@"avatar"];
            [iconImage1 setImageWithPath:__url];
            iconImage1.placeHolder=[UIImage imageNamed:@"headImg_login1"];
        }else
        {
            iconImage1.image=[UIImage imageNamed:@"headImg_login1"];
        }

        NSArray *arrtitle=@[@"username",@"city",@"mark"];
        NSDictionary *__dict=[dict objectForKey:@"data"];
        CGFloat __y_p=CGRectGetMaxY(iconImage1.frame)+15*_Scale;
        CGFloat __height=(CGRectGetHeight(upview.frame)-CGRectGetMaxY(iconImage1.frame)-15*_Scale)/3.0f;

        for (int i=0; i<3; i++) {
            UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, __y_p, CGRectGetWidth(upview.frame), __height)];

            [upview addSubview:label];
            label.textColor=i==0?_define_blue_color:[UIColor colorWithRed:200.0f/255.0f green:200.0f/255.0f blue:200.0f/255.0f alpha:1];


            label.textAlignment=1;
            CGFloat __font=i==0?13.0f:i==2?11.0f:11.0f;
            label.font=[regular getFont:__font];
            if(([__dict objectForKey:arrtitle[i]]!=[NSNull null])&&([__dict objectForKey:arrtitle[i]]!=nil))
            {

                NSString *citystr=nil;
                if(i==1)
                {

                    if([[__dict objectForKey:arrtitle[i]]isEqualToString:@""])
                    {
                        citystr=@"反正不是火星";
                    }else
                    {
                        citystr=[__dict objectForKey:arrtitle[i]];
                    }
                }else
                {
                    citystr=[__dict objectForKey:arrtitle[i]];
                }
                [label setAttributedText:[regular createAttributeString:citystr andFloat:@(1.0)]];

            }else
            {
                if(i==1)
                {
                    [label setAttributedText:[regular createAttributeString:@"反正不是火星" andFloat:@(1.0)]];
                }else
                {
                    [label setAttributedText:[regular createAttributeString:@"" andFloat:@(1.0)]];
                }
            }
            __y_p+=__height;
        }
        NSArray *arrCase = nil;

        NSArray *arrLabel =nil;

        if(_isguanzhu)
        {
            //            found_school_2_关闭icon
            arrCase = @[@"follow_select",@"message_normal"];
            arrLabel = @[@"取消关注",@"消息"];

        }else
        {
            //            box_choose_添加1
            arrCase = @[@"follow_normal",@"message_select"];
            arrLabel = @[@"关注",@"消息"];
        }
        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] longValue]==[[_detailModel.user objectForKey:@"id"] longLongValue])
        {


        }else
        {
            if([[[dict objectForKey:@"data"] objectForKey:@"is_server"] boolValue])
            {
                _isguanzhu=YES;
                UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame=CGRectMake((CGRectGetWidth(downview.frame)-90*_Scale)/2.0f, (CGRectGetHeight(downview.frame)-84*_Scale)/2.0f, 90*_Scale, 84*_Scale);

                btn.tag=101;
                [btn addTarget:self action:@selector(caseBtn:) forControlEvents:UIControlEventTouchUpInside];
                [downview addSubview:btn];
                //            btn.backgroundColor=[UIColor redColor];
                UIImageView *__image=[[UIImageView alloc] initWithFrame:CGRectMake(((CGRectGetWidth(btn.frame)-50*_Scale)/2.0f), 0, 50*_Scale, 50*_Scale)];
                __image.image=[UIImage imageNamed:@"message_normal"];
                //            __image.backgroundColor=[UIColor yellowColor];
                [btn addSubview:__image];
                UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(-20*_Scale, CGRectGetMaxY(__image.frame)+6*_Scale, CGRectGetWidth(btn.frame)+40*_Scale, CGRectGetHeight(btn.frame)-CGRectGetMaxY(__image.frame))];
                [btn addSubview:label];
                label.textColor=[UIColor colorWithRed:200.0f/255.0f green:200.0f/255.0f blue:200.0f/255.0f alpha:1];
                label.textAlignment=1;
                //            label.backgroundColor=[UIColor greenColor];
                label.font=[regular getFont:10.0f];
                [label setAttributedText:[regular createAttributeString:@"消息" andFloat:@(1.0)]];
                [btnarr addObject:btn];
            }else
            {
                //90 84
                for (int i = 0 ; i < 2; i ++) {
                    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
                    btn.frame=CGRectMake((65.0f/2.0f)*_Scale*2+(CGRectGetWidth(downview.frame)-45*2*2*_Scale-65*2*_Scale+45*2*_Scale)*i, (CGRectGetHeight(downview.frame)-42*2*_Scale)/2.0f, 45*2*_Scale, 42*2*_Scale);

                    btn.tag=100+i;
                    [btn addTarget:self action:@selector(caseBtn:) forControlEvents:UIControlEventTouchUpInside];
                    [downview addSubview:btn];
                    //            btn.backgroundColor=[UIColor redColor];
                    UIImageView *__image=[[UIImageView alloc] initWithFrame:CGRectMake(((CGRectGetWidth(btn.frame)-25*2*_Scale)/2.0f), 0, 25*2*_Scale, 25*2*_Scale)];
                    __image.image=[UIImage imageNamed:arrCase[i]];
                    //            __image.backgroundColor=[UIColor yellowColor];
                    [btn addSubview:__image];
                    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(-10*2*_Scale, CGRectGetMaxY(__image.frame)+3*2*_Scale, CGRectGetWidth(btn.frame)+20*2*_Scale, CGRectGetHeight(btn.frame)-CGRectGetMaxY(__image.frame))];
                    [btn addSubview:label];
                    label.textColor=[UIColor colorWithRed:200.0f/255.0f green:200.0f/255.0f blue:200.0f/255.0f alpha:1];
                    label.textAlignment=1;

                    label.font=[regular getFont:10.0f];
                    [label setAttributedText:[regular createAttributeString:arrLabel[i] andFloat:@(1.0)]];
                    [btnarr addObject:btn];
                    
                }
            }
        }

    } failed:^{
        JXLOG(@"失败");
    }];



}
- (void)caseBtn:(UIButton *)btn
{

    if (btn.tag == 100) {
        //        NSArray *arrCase = nil;

        NSArray *arrLabel =nil;
        if(!_isguanzhu)
        {
            for (UIView *view in btn.subviews) {
                if([view isKindOfClass:[UIImageView class]])
                {

                    ((UIImageView *)view).image=[UIImage imageNamed:@"follow_select"];
                }
                if([view isKindOfClass:[UILabel class]])
                {
                    [(UILabel *)view setAttributedText:[regular createAttributeString:@"取消关注" andFloat:@(1.0)]];
                }
            }

            UIButton *btn_1=(UIButton *)btnarr[1];
            for (UIView *view in btn_1.subviews) {
                if([view isKindOfClass:[UIImageView class]])
                {

                    ((UIImageView *)view).image=[UIImage imageNamed:@"message_normal"];
                }
            }

            NSString *str=[NSString stringWithFormat:@"%@/v1/follows?token=%@",DNS,[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]];

            NSDictionary *para = @{@"followable_id":[NSString stringWithFormat:@"%lld",[[_detailModel.user objectForKey:@"id"] longLongValue]],@"followable_type":@"user"};
            AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];

            [manager POST:str parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
                //                JXLOG(@"%@",responseObject);
                [regular removeProgress];
                id res = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                JXLOG(@"%@",res);
                if ([res[@"code"] integerValue] == 1) {

                    [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshChatList" object:nil];
                    _isguanzhu=YES;
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

                [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
                JXLOG(@"失败");
            }];

        }else
        {
            //            arrCase = @[@"box_choose_添加1",@"message_select"];
            //            arrLabel = @[@"Add",@"Message"];
            arrLabel = @[@"取消关注",@"消息"];
            for (UIView *view in btn.subviews) {
                if([view isKindOfClass:[UIImageView class]])
                {

                    ((UIImageView *)view).image=[UIImage imageNamed:@"follow_normal"];
                }
                if([view isKindOfClass:[UILabel class]])
                {
                    [(UILabel *)view setAttributedText:[regular createAttributeString:@"关注" andFloat:@(1.0)]];
                }
            }

            UIButton *btn_1=(UIButton *)btnarr[1];
            for (UIView *view in btn_1.subviews) {
                if([view isKindOfClass:[UIImageView class]])
                {

                    ((UIImageView *)view).image=[UIImage imageNamed:@"message_select"];
                }
            }

            NSString *str=[NSString stringWithFormat:@"%@/v1/follows/cancel?token=%@",DNS,[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]];

            NSDictionary *para = @{@"followable_id":[NSString stringWithFormat:@"%lld",[[_detailModel.user objectForKey:@"id"] longLongValue]],@"followable_type":@"user"};
            AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];

            [manager POST:str parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
                //                JXLOG(@"%@",responseObject);
                [regular removeProgress];
                id res = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                JXLOG(@"%@",res);
                if ([res[@"code"] integerValue] == 1) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshChatList" object:nil];
                    _isguanzhu=NO;

                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

                [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
                JXLOG(@"失败");
            }];
            
            
        }
    }
    else
    {
        if(_isguanzhu)
        {
            
            [[self.view.window viewWithTag:1000] removeFromSuperview];
            
            ChatViewController *chatVC = [[ChatViewController alloc] initWithChatter:[_detailModel.user objectForKey:@"ease_mob_username"]  isGroup:NO];
            NSString *cell=nil;
            NSNumber *is_server=nil;
            if([_detailModel.user objectForKey:@"cell"]!=[NSNull null])
            {
                if([_detailModel.user objectForKey:@"cell"]!=nil&&![[_detailModel.user objectForKey:@"cell"] isEqualToString:@""])
                {
                    cell=[_detailModel.user objectForKey:@"cell"];
                }else
                {
                    cell=@"";
                }
            }else
            {
                cell=@"";
            }

            if([_detailModel.user objectForKey:@"is_server"]!=[NSNull null])
            {
                if([_detailModel.user objectForKey:@"is_server"]!=nil)
                {
                    is_server=[_detailModel.user objectForKey:@"is_server"];
                }
            }

            chatVC.userinfo=@{@"cell":cell,@"is_server":is_server,@"uid":[[NSString alloc] initWithFormat:@"%ld",[[_detailModel.user objectForKey:@"id"] longValue]]};
            chatVC.uid=[_detailModel.user objectForKey:@"id"];
            [chatVC setH_title:[_detailModel.user objectForKey:@"username"]];
            chatVC.friend_head=[_detailModel.user objectForKey:@"avatar"];
            chatVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:chatVC animated:YES];
            
        }else
        {
            [[ToolManager sharedManager] alertTitle_Simple:@"关注之后才能聊天哦～"];
        }
        
        
    }
    
}

-(void)closeBtn:(UIButton *)btn
{
    [imageGray removeFromSuperview];
}

-(void)createtabbar
{

    _tabbar=[[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight-80*_Scale, ScreenWidth, 80*_Scale)];
    [self.view addSubview:_tabbar];

    CGFloat _button_width=CGRectGetWidth(_tabbar.frame)/5.0f;

    for (int i=0; i<5; i++) {
        UIButton *btn=nil;
        if(i==2)
        {
            btn=shareBtn;
        }else
        {
            btn=[UIButton buttonWithType:UIButtonTypeCustom];
        }

        btn.backgroundColor=[UIColor whiteColor];
        btn.frame=CGRectMake(_button_width*i, 0, _button_width, CGRectGetHeight(_tabbar.frame));
        btn.tag=7000+i;
        NSString *normalImgName=i==0?@"article_tabbar_撤销":i==1?@"school_tabbar_赞":i==2?@"article_tabbar_分享":i==3?@"school_tabbar_喜欢":@"school_tabbar_评论";
        NSString *selectImgName=i==0?@"article_tabbar_撤销":i==1?@"school_tabbar_赞select":i==2?@"article_tabbar_分享":i==3?@"school_tabbar_喜欢select":@"school_tabbar_评论select";


        [btn setImage:[UIImage imageNamed:selectImgName] forState:UIControlStateSelected];

        [btn setImage:[UIImage imageNamed:normalImgName] forState:UIControlStateNormal];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(5*_Scale, 0, 5*_Scale, 0)];
        [_tabbar addSubview:btn];
        //        加线条
        if(i==1||i==3)
        {
            for (int j=0; j<2; j++) {
                UIView *xian=[[UIView alloc] initWithFrame:CGRectMake((_button_width-1*_Scale)*j, -5*_Scale+((CGRectGetHeight(_tabbar.frame)-46*_Scale)/2.0f), 1*_Scale, 56*_Scale)];
                xian.backgroundColor=self.view.backgroundColor;
                [btn addSubview:xian];
            }
        }
        if(i==2)
        {


        }else if(i==0)
        {

        }else if(i==1)
        {
            if(_detailModel.had_voted==YES)
            {
                btn.selected=YES;
            }else
            {
                btn.selected=NO;
            }
        }else if(i==3)
        {
            if(_detailModel.had_followed==YES)
            {
                btn.selected=YES;
            }else
            {
                btn.selected=NO;
            }
        }


        [btn addTarget:self action:@selector(tabbarAction:) forControlEvents:UIControlEventTouchUpInside];
        if(i!=2)
        {

            UILabel *label=nil;
            if(i==0)
            {
                label=[[UILabel alloc] init];
            }else if(i==1)
            {
                label=_num_p;
            }else if(i==3)
            {
                label=_num_c;
            }else if(i==4)
            {
                label=comment_num_label;
            }
            else
            {
                label=[[UILabel alloc] init];
            }
            label.frame=CGRectMake(84*_Scale, 25*_Scale, CGRectGetWidth(btn.frame)-84*_Scale, 24*_Scale);
            [btn addSubview:label];
            label.font=[regular get_en_Font:9.0f];
            label.textAlignment=0;
            label.textColor=[UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1];
            if(i==1)
            {

                label.text=[[NSString alloc] initWithFormat:@"%ld",(long)_detailModel.votes_count];
            }else if(i==3)
            {

                label.text=[[NSString alloc] initWithFormat:@"%ld",(long)_detailModel.follows_count];
            }

        }
    }
    UIView *qufen=[[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_tabbar.frame), 2*_Scale)];
    qufen.backgroundColor=[UIColor colorWithRed:250.0f/255.0f green:250.0f/255.0f blue:250.0f/255.0f alpha:1];
    [_tabbar addSubview:qufen];

}
-(void)tabbarAction:(UIButton *)btn
{

    NSInteger tag=btn.tag-7000;
    if(tag==0)
    {
        //       返回
        [self.navigationController popViewControllerAnimated:YES];


    }else if(tag==1)
    {
        //        点赞
        [self praise_action:btn];

    }else if(tag==2)
    {
        //        添加到学校列表
//        [self goalBtnAction:btn];
        [self shareBtnPress:btn];

    }else if(tag==3)
    {
        //        收藏
        [self collection_action:btn];

    }else if(tag==4)
    {
        //        评论
        [self commentAction];
//        ArticleCommentController
    }
}
- (void)shareBtnPress:(UIButton *)btn
{
    imageGray = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"蒙板"]];
    imageGray.userInteractionEnabled = YES;
    imageGray.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    imageGray.tag=878;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disapp)];
    [imageGray addGestureRecognizer:tap];
    [self.view.window addSubview:imageGray];

    app1 = [ShareSDK isClientInstalled:SSDKPlatformSubTypeWechatSession];
    app2 = [ShareSDK isClientInstalled:SSDKPlatformSubTypeQQFriend];

    UIView *fatherView=nil;
    if((app1==NO)&&(app2==NO))
    {
        fatherView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight-110*2*_Scale, kScreenWidth, 110*2*_Scale)];

    }else
    {
        fatherView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight-200*2*_Scale, kScreenWidth, 200*2*_Scale)];

    }

    fatherView.backgroundColor = [UIColor whiteColor];
    [imageGray addSubview:fatherView];

    NSArray *imageName = nil;
    NSArray *imageTitleName=nil;

    if((app1==NO)&&(app2==NO))
    {
        imageName = @[@"微博Share",@"qq空间Share",@"emailShare"];
        imageTitleName= @[@"微博",@"QQ空间",@"邮件"];

    }else if((app1==YES)&&(app2==NO))
    {
        imageName = @[@"微信Share",@"朋友圈Share",@"微博Share",@"qq空间Share",@"emailShare"];
        imageTitleName= @[@"微信",@"朋友圈",@"微博",@"QQ空间",@"邮件"];
    }else if((app1==NO)&&(app2==YES))
    {
        imageName = @[@"微博Share",@"qqShare",@"qq空间Share",@"emailShare"];
        imageTitleName= @[@"微博",@"QQ",@"QQ空间",@"邮件"];
    }else
    {
        imageName = @[@"微信Share",@"朋友圈Share",@"微博Share",@"qqShare",@"qq空间Share",@"emailShare"];
        imageTitleName= @[@"微信",@"朋友圈",@"微博",@"QQ",@"QQ空间",@"邮件"];
    }

    CGFloat _width=50*2*_Scale;
    CGFloat _jiange=(ScreenWidth-50*3*2*_Scale)/4.0f;
    for (int i = 0; i < imageName.count; i ++) {
        UIButton *btn = [regular createBtnWithRect:CGRectMake(_jiange + (_width+_jiange) * (i%3),15*2*_Scale+ 10*2*_Scale + 78*2*_Scale * (i/3), _width, _width) WithTitle:@"" WithNormalStr:imageName[i] WithSelectStr:nil];
        btn.tag = 2000 + i;
        [btn addTarget:self action:@selector(sharePressBtn:) forControlEvents:UIControlEventTouchUpInside];
        [fatherView addSubview:btn];

        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(btn.frame)-10*2*_Scale, CGRectGetMaxY(btn.frame), CGRectGetWidth(btn.frame)+20*2*_Scale, 30*2*_Scale)];
        //        label.backgroundColor=[UIColor redColor];
        [fatherView addSubview:label];
        label.textAlignment=1;
        label.textColor=[UIColor colorWithRed:150.0f/255.0f green:150.0f/255.0f  blue:150.0f/255.0f  alpha:1];
        label.font=[regular getFont:12.0f];
        [label setAttributedText:[regular createAttributeString:imageTitleName[i] andFloat:@(3.0)]];
    }
}
#pragma mark-发送邮件
-(void)displayComposerSheet:(NSString *)str
{

    BOOL _b=[MFMailComposeViewController canSendMail];
    if(_b==YES)
    {

        [self.navigationController setNavigationBarHidden:NO animated:NO];

        MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
        picker.mailComposeDelegate = self;
        //  picker.navigationBar.tintColor = [UIColor blueColor];
        [picker setSubject:@"‘留美盒子’  美国高中都在这！"];



        [picker setMessageBody:str isHTML:YES];
        // Set up recipients
        NSArray *toRecipients = [NSArray arrayWithObject:str];


        [picker setToRecipients:toRecipients];
        if ([picker.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
            NSArray *list=self.navigationController.navigationBar.subviews;
            for (id obj in list) {
                if ([obj isKindOfClass:[UIImageView class]]) {
                    UIImageView *imageView=(UIImageView *)obj;
                    NSArray *list2=imageView.subviews;
                    for (id obj2 in list2) {
                        if ([obj2 isKindOfClass:[UIImageView class]]) {
                            UIImageView *imageView2=(UIImageView *)obj2;
                            imageView2.hidden=YES;
                        }
                    }
                }
            }
        }

        picker.navigationBar.barTintColor =[UIColor colorWithRed:70.0f/255.0f green:195.0f/255.0f blue:247.0f/255.0f alpha:1];

        [self presentViewController:picker animated:NO completion:nil];


    }else
    {
        [[ToolManager sharedManager] alertTitle_Simple:@"请先设置邮箱帐号"];

    }

}
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{

    switch (result)
    {
        case MFMailComposeResultCancelled: // 用户取消编辑
            JXLOG(@"Mail send canceled...");
            break;
        case MFMailComposeResultSaved: // 用户保存邮件
            JXLOG(@"Mail saved...");
            break;
        case MFMailComposeResultSent: // 用户点击发送
            JXLOG(@"Mail sent...");
            break;
        case MFMailComposeResultFailed: // 用户尝试保存或发送邮件失败
            JXLOG(@"Mail send errored: %@...", [error localizedDescription]);
            break;
    }
    // 关闭邮件发送视图
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)disapp
{
    [[self.view.window viewWithTag:878] removeFromSuperview];
}
- (void)sharePressBtn:(UIButton *)btn
{
    [self disapp];
    _isjunp_login=YES;

    NSArray *arrayName =nil;
    //    id<ISSWeChatApp> app1 =(id<ISSWeChatApp>)[ShareSDK getClientWithType:ShareTypeWeixiTimeline];
    //    id<ISSQQApp> app2 =(id<ISSQQApp>)[ShareSDK getClientWithType:ShareTypeQQSpace];
    
    //  @[@(22),@(23),@(1),@(24),@(6),@(18)];
    //    @[@"微信Share",@"朋友圈Share",@"微博Share",@"qqShare",@"qq空间Share",@"emailShare"];
    if((app1==NO)&&(app2==NO))
    {
        
        arrayName =  @[@(1),@(6),@(18)];
        
    }else if((app1==YES)&&(app2==NO))
    {
        
        arrayName =@[@(22),@(23),@(1),@(6),@(18)];
        
        
    }else if((app1==NO)&&(app2==YES))
    {
        arrayName = @[@(1),@(24),@(6),@(18)];
        
    }else
    {
        arrayName = @[@(22),@(23),@(1),@(24),@(6),@(18)];
    }
    JXLOG(@"ssss%ld",(long)[arrayName[btn.tag - 9000] integerValue]);
    
    //1、创建分享参数（必要）
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:[[NSString alloc] initWithFormat:@"我分享了［%@］的文章［%@］，快来看看吧 %@",[_detailModel.user objectForKey:@"username"],_detailModel.title,_detailModel.share_link] images:nil url:[NSURL URLWithString:@"https://appsto.re/cn/HYZ77.i"] title:@"‘留美盒子’  美国高中都在这！" type:SSDKContentTypeAuto];
    
    [shareParams SSDKEnableUseClientShare];
    NSInteger platformType = [arrayName[btn.tag - 9000] integerValue];
    //2、分享
    [ShareSDK share:(long)platformType parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        switch (state) {
                
            case SSDKResponseStateBegin:
            {
                break;
            }
            case SSDKResponseStateSuccess:
            {
                [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"分享成功" WithImg:@"Prompt_提交成功" Withtype:1]];
            }
            case SSDKResponseStateFail:
            {
                if(platformType==18)
                {
                    [[ToolManager sharedManager] alertTitle_Simple:@"请设置邮件账户"];
                }else if (platformType==24)
                {
                    [[ToolManager sharedManager] alertTitle_Simple:@"请安装QQ客户端"];
                    
                }else if(platformType==6)
                {
                    [[ToolManager sharedManager] alertTitle_Simple:@"请安装QQ空间客户端"];
                }else if (platformType==1)
                {
                    if(error.code==20019)
                    {
                        [[ToolManager sharedManager] alertTitle_Simple:@"请不要分享重复的内容"];
                    }
                }
            }
            case SSDKResponseStateCancel:
            {
                if(platformType!=SSDKPlatformSubTypeWechatSession&&platformType!=SSDKPlatformSubTypeQQFriend)
                {
                    [[ToolManager sharedManager] alertTitle_Simple:@"分享已取消"];
                }
                break;
            }
            default:
                break;
        }
    }];
}

-(void)commentAction
{

    //    schoolCommentController
    ArticleCommentController *comment=[[ArticleCommentController alloc] init];
    comment.sid=_detailModel.m_id;
    [self.navigationController pushViewController:comment animated:YES];
    
}
-(void)collection_action:(UIButton *)btn
{

    NSUserDefaults *dict=[NSUserDefaults standardUserDefaults];
    if([[dict objectForKey:@"islogin"] integerValue])
    {
        NSString *showtitle=nil;
        NSString *showimg=nil;
        if (btn.selected) {
            coll_Num--;
            btn.selected=NO;
            _num_c.text=[NSString stringWithFormat:@"%ld",(long)coll_Num];
            showimg=@"Prompt_移除心愿单";
            showtitle=@"已取消收藏";


        }else
        {
            coll_Num++;
            btn.selected=YES;
            _num_c.text=[NSString stringWithFormat:@"%ld",(long)coll_Num];
            showimg=@"Prompt_加入心愿单";
            showtitle=@"收藏成功";

        }

        [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:showtitle WithImg:showimg Withtype:1]];
        NSString *url=nil;
        if(_detailModel.had_followed)
        {
            url=@"/v1/follows/cancel";
        }else
        {
            url=@"/v1/follows";
        }

        NSString *_token=nil;
        if([dict objectForKey:@"token"]==nil)
        {
            _token=@"";
        }else
        {
            _token=[dict objectForKey:@"token"];
        }


        NSDictionary *parameters=@{@"followable_type":@"Post",@"followable_id":_detailModel.m_id,@"token":_token};


        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:[[NSString alloc] initWithFormat:@"%@%@",DNS,url] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *html = operation.responseString;
            NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
            if([[dict objectForKey:@"code"] integerValue]==1)
            {
                if(_detailModel.had_followed)
                {
                    _detailModel.had_followed=NO;
                    if(_model!=nil)
                    {
                        self.block(_model,YES);
                    }

                }else
                {
                    _detailModel.had_followed=YES;
                    if(_model!=nil)
                    {
                         self.block(_model,NO);
                    }

                }
            }else
            {
                [[ToolManager sharedManager] alertTitle_Simple:[dict objectForKey:@"message"]];
            }

            [[ToolManager sharedManager] removeProgress];

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
            [[ToolManager sharedManager] removeProgress];
        }];


    }else
    {
        //        UIAlertView *alertview=[[ToolManager sharedManager] alertTitle_Simple:@"用户还未登录，请先登录"];
        //        alertview.delegate=self;
        [self login_action];
        
    }
}
-(void)login_action
{
    _isjunp_login=YES;

    LoginViewController*login=[[LoginViewController alloc] init];
    login.type=@"other";
    [self presentModalViewController:login animated:YES];
}
-(void)praise_action:(UIButton *)btn
{
    NSUserDefaults *dict=[NSUserDefaults standardUserDefaults];
    if([[dict objectForKey:@"islogin"] integerValue])
    {
        NSString *showtitle=nil;
        NSString *showimg=nil;
        if (btn.selected) {
            praise_Num--;
            btn.selected=NO;
            _num_p.text=[NSString stringWithFormat:@"%ld",(long)praise_Num];
            showtitle=@"已取消点赞";
            showimg=@"Prompt_已取消点赞";
        }else
        {
            praise_Num++;
            btn.selected=YES;
            _num_p.text=[NSString stringWithFormat:@"%ld",(long)praise_Num];
            showtitle=@"已点赞";
            showimg=@"Prompt_已点赞";
        }

        [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:showtitle WithImg:showimg Withtype:1]];


        NSString *url=nil;
        if(_detailModel.had_voted)
        {
            url=@"/v1/votes/cancel";
        }else
        {
            url=@"/v1/votes";
        }
        NSString *_token=nil;
        if([dict objectForKey:@"token"]==nil)
        {
            _token=@"";
        }else
        {
            _token=[dict objectForKey:@"token"];
        }

        NSDictionary *parameters=@{@"voteable_type":@"Post",@"voteable_id":_detailModel.m_id,@"token":_token};

        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:[[NSString alloc] initWithFormat:@"%@%@",DNS,url] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *html = operation.responseString;
            NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
            if([[dict objectForKey:@"code"] integerValue]==1)
            {

                if(_detailModel.had_voted)
                {
                    _detailModel.had_voted=NO;
                }else
                {
                    _detailModel.had_voted=YES;
                }
            }else
            {
                [[ToolManager sharedManager] alertTitle_Simple:[dict objectForKey:@"message"]];
            }
            [[ToolManager sharedManager] removeProgress];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
            [[ToolManager sharedManager] removeProgress];
        }];
    }else
    {
        //        UIAlertView *alertview=[[ToolManager sharedManager] alertTitle_Simple:@"用户还未登录，请先登录"];
        //        alertview.delegate=self;
        [self login_action];
        
    }
    
    
}

-(void)startLoadingAnimation
{
    //        加载动画
    indicator = [[YYAnimationIndicator alloc]initWithFrame:CGRectMake(ScreenWidth/2-20*_Scale*2, ScreenHeight/2-20*_Scale*2, 40*_Scale*2, 40*_Scale*2)];
    [indicator setLoadText:@"loading..."];
//    [self.view addSubview:indicator];
    [[UIApplication sharedApplication].keyWindow addSubview:indicator];
    [indicator startAnimation];
        //        加载结束
    //         [indicator stopAnimationWithLoadText:@"loading..." withType:YES];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [indicator stopAnimationWithLoadText:@"loading..." withType:YES];
    if(!_isjunp_login)
    {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [self.navigationController setNavigationBarHidden:NO animated:TRUE];
    }

    [MobClick endLogPageView:@"ArticleDetailViewController"];

}
-(void)viewWillAppear:(BOOL)animated
{
    if(_isjunp_login)
    {
        _isjunp_login=NO;
    }
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self.navigationController setNavigationBarHidden:YES animated:TRUE];
    [[CustomTabbarController sharedManager] tabbarHide];
    self.tabBarController.tabBar.hidden=YES;
    [MobClick beginLogPageView:@"ArticleDetailViewController"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
