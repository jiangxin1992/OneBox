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

}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self SomePrepare];
    NSLog(@"1111");
}
#pragma mark - SomePrepare
-(void)SomePrepare
{
    [self PrepareData];
    [self PrepareUI];
}

-(void)PrepareData{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCommentNum_Action:) name:@"changenum" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(other) name:@"other" object:nil];
}
-(void)PrepareUI{
    self.view.backgroundColor =  _define_backview_color;
    self.leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    self.rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    self.leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    self.rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:self.leftSwipeGestureRecognizer];
    [self.view addGestureRecognizer:self.rightSwipeGestureRecognizer];
}
#pragma mark - Setter
-(void)setArticleID:(NSString *)ArticleID
{
    _ArticleID = ArticleID;
    [self initializeData];
    [self startLoadingAnimation];
    [self requestDataisFrist:YES];
}
-(void)initializeData
{
    shareBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    comment_num_label=[[UILabel alloc] init];
    _num_c=[[UILabel alloc] init];
    _num_p=[[UILabel alloc] init];
    praise_Num=0;
    coll_Num=0;
    _isjunp_login=NO;
}
#pragma mark - UIConfig
-(void)UIConfig
{
    [self createtabbar];
    [self createWebview];
}
-(void)createWebview
{
    web=[[UIWebView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:web];
    [web mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.bottom.mas_equalTo(_tabbar.mas_top).with.offset(0);
    }];
    web.backgroundColor = [UIColor clearColor];
    web.delegate=self;
    [web loadHTMLString:[NSString stringWithFormat:@"<style></style><div>%@<div>",_detailModel.app_html_url] baseURL:nil];
    [web loadRequest:[[NSURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:_detailModel.app_html_url]]];
    if (@available(iOS 11.0, *)) {
        web.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    web.opaque = NO;
    web.dataDetectorTypes = UIDataDetectorTypeNone;
    
    [web sizeToFit];
    [indicator stopAnimationWithLoadText:@"loading..." withType:YES];
    
}

-(void)createtabbar
{
    
    _tabbar=[[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_tabbar];
    [_tabbar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(kTabBarHeight);
    }];
    _tabbar.backgroundColor = _define_white_color;

    CGFloat _button_width=ScreenWidth/5.0f;
    UIView *lastView = nil;
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
        btn.frame=CGRectMake(_button_width*i, 0, _button_width, kInteractionHeight);
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
                UIView *xian=[[UIView alloc] initWithFrame:CGRectMake((_button_width-1*_Scale)*j, -5*_Scale+((kInteractionHeight-46*_Scale)/2.0f), 1*_Scale, 56*_Scale)];
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
        lastView = btn;
    }
    UIView *qufen=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 2*_Scale)];
    qufen.backgroundColor=[UIColor colorWithRed:250.0f/255.0f green:250.0f/255.0f blue:250.0f/255.0f alpha:1];
    [_tabbar addSubview:qufen];
    
}
#pragma mark - SomeAction
//左右滑动
- (void)handleSwipes:(UISwipeGestureRecognizer *)sender
{
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        if(_detailModel!=nil)
        {
            ArticleCommentController *comment=[[ArticleCommentController alloc] init];
            comment.sid=_detailModel.m_id;
            [self.navigationController pushViewController:comment animated:YES];
        }
    }else if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
//评论数改变(通知)
-(void)changeCommentNum_Action:(NSNotification *)not
{
    comment_num_label.text=[[NSString alloc] initWithFormat:@"%ld",(long)[not.object integerValue]];
}
-(void)other
{
    _isjunp_login=YES;
    [self dismissModalViewControllerAnimated:YES];
    [self requestDataisFrist:NO];
}
-(void)backxiaoshi
{
    [[self.view.window viewWithTag:1000] removeFromSuperview];
}
-(void)NullAction:(UIGestureRecognizer *)ges{}

-(void)closeBtn:(UIButton *)btn
{
    [imageGray removeFromSuperview];
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
-(void)disapp
{
    [[self.view.window viewWithTag:878] removeFromSuperview];
}
-(void)commentAction
{
    ArticleCommentController *comment=[[ArticleCommentController alloc] init];
    comment.sid=_detailModel.m_id;
    [self.navigationController pushViewController:comment animated:YES];
    
}
-(void)collection_action:(UIButton *)btn
{
    
    if([regular isLogin])
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
        
        NSDictionary *parameters=@{@"followable_type":@"Post",@"followable_id":_detailModel.m_id,@"token":[regular getToken]};
        
        
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
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
        }];
        
        
    }else
    {
        [self login_action];
        
    }
}
-(void)login_action
{
    _isjunp_login=YES;
    
    LoginViewController*login=[[LoginViewController alloc] init];
    login.type=@"other";
    [self.navigationController pushViewController:login animated:YES];
}
-(void)praise_action:(UIButton *)btn
{
    if([regular isLogin])
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
        
        NSDictionary *parameters=@{@"voteable_type":@"Post",@"voteable_id":_detailModel.m_id,@"token":[regular getToken]};
        
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
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
        }];
    }else
    {
        [self login_action];  
    }
    
    
}

-(void)startLoadingAnimation
{
    //        加载动画
    if(!indicator){
        indicator = [[YYAnimationIndicator alloc] initWithFrame:CGRectZero];
//        [[UIApplication sharedApplication].keyWindow addSubview:indicator];
        [self.view addSubview:indicator];
        [indicator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.view);
            make.width.height.mas_equalTo(40*_Scale*2);
        }];
        [indicator setLoadText:@"loading..."];
    }
    [indicator startAnimation];
}


-(void)requestDataisFrist:(BOOL )isfirst
{

    NSDictionary *_parameters = @{@"token":[regular getToken]};

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

#pragma mark - 发送邮件
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

#pragma mark - 分享
- (void)shareBtnPress:(UIButton *)btn
{
    imageGray = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"蒙板"]];
    imageGray.userInteractionEnabled = YES;
    imageGray.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    imageGray.tag=878;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disapp)];
    [imageGray addGestureRecognizer:tap];
    [self.view.window addSubview:imageGray];
    
    app1 = [ShareSDK isClientInstalled:SSDKPlatformTypeWechat];
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
        imageName = @[@"微博Share",@"qq空间Share",];
        imageTitleName= @[@"微博",@"QQ空间",];
        
    }else if((app1==YES)&&(app2==NO))
    {
        imageName = @[@"微信Share",@"朋友圈Share",@"微博Share",@"qq空间Share",];
        imageTitleName= @[@"微信",@"朋友圈",@"微博",@"QQ空间",];
    }else if((app1==NO)&&(app2==YES))
    {
        imageName = @[@"微博Share",@"qqShare",@"qq空间Share",];
        imageTitleName= @[@"微博",@"QQ",@"QQ空间",];
    }else
    {
        imageName = @[@"微信Share",@"朋友圈Share",@"微博Share",@"qqShare",@"qq空间Share",];
        imageTitleName= @[@"微信",@"朋友圈",@"微博",@"QQ",@"QQ空间",];
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
- (void)sharePressBtn:(UIButton *)btn
{
    [self disapp];
    _isjunp_login=YES;

    NSArray *arrayName =nil;
    
    if((app1==NO)&&(app2==NO))
    {
        
        arrayName = @[@(1),@(6),@(18)];
        
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
    JXLOG(@"ssss%ld",(long)[arrayName[btn.tag - 2000] integerValue]);
    
    //1、创建分享参数（必要）
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:[[NSString alloc] initWithFormat:@"我分享了［%@］的文章［%@］，快来看看吧 %@",[_detailModel.user objectForKey:@"username"],_detailModel.title,_detailModel.share_link] images:nil url:[NSURL URLWithString:@"https://appsto.re/cn/HYZ77.i"] title:@"‘留美盒子’  美国高中都在这！" type:SSDKContentTypeAuto];
    
    [shareParams SSDKEnableUseClientShare];
    NSInteger platformType = [arrayName[btn.tag - 2000] integerValue];
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
                break;
            }
            case SSDKResponseStateFail:
            {
                if(![NSString isNilOrEmpty:[[error.userInfo objectForKey:@"user_data"] objectForKey:@"error"]])
                {
                    [[ToolManager sharedManager] alertTitle_Simple:[[error.userInfo objectForKey:@"user_data"] objectForKey:@"error"]];
                }else if(![NSString isNilOrEmpty:[error.userInfo objectForKey:@"error_message"]])
                {
                    [[ToolManager sharedManager] alertTitle_Simple:[error.userInfo objectForKey:@"error_message"]];
                }
//                if(platformType==18)
//                {
//                    [[ToolManager sharedManager] alertTitle_Simple:@"请设置邮件账户"];
//                }else if (platformType==24)
//                {
//                    [[ToolManager sharedManager] alertTitle_Simple:@"请安装QQ客户端"];
//                    
//                }else if(platformType==6)
//                {
//                    [[ToolManager sharedManager] alertTitle_Simple:@"请安装QQ空间客户端"];
//                }else if (platformType==1)
//                {
//                    JXLOG(@"error.code=%ld",(long)error.code);
//                    if(error.code==20019)
//                    {
//                        [[ToolManager sharedManager] alertTitle_Simple:@"请不要分享重复的内容"];
//                    }
//                }
                break;
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
#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSURL * _url = [request URL];
    NSString *_query=[_url query];
    
    if(_query!=nil)
    {
        if ( [_query rangeOfString:@"author_info"].location !=NSNotFound) {
            JXLOG(@"111");
            return NO;
        }
    }
    return YES;
}
#pragma mark - Other
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
