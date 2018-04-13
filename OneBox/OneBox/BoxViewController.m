//
//  BoxViewController.m
//  OneBox
//
//  Created by 谢江新 on 15/11/25.
//  Copyright © 2015年 谢江新. All rights reserved.
//

#import "BoxViewController.h"

#import "GifView.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import <CoreLocation/CoreLocation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import "HttpRequestManager.h"

#import "Boxlistviewcontroller.h"
#import "LoginViewController.h"
#import "FlyUsaViewController.h"
#import "chooseSchoolController.h"
#import "submitSchoolController.h"
#import "CustomTabbarController.h"
#import "BoxHelpViewController.h"

#import "MyInfo.h"
#import "Order.h"

#define _blueColor [UIColor colorWithRed:79.0f/255.0f green:194.0f/255.0f blue:248.0f/255.0f alpha:1]
#define _yellowColor [UIColor colorWithRed:245.0f/255.0f green:186.0f/255.0f blue:0 alpha:1]
#define _grayColor [UIColor colorWithRed:224.0f/255.0f green:224.0f/255.0f blue:224.0f/255.0f alpha:1]

@interface BoxViewController ()<MFMailComposeViewControllerDelegate>
{
    NSInteger _step;
    NSMutableArray *arrayRCUser;
    UIView *coverView;
    id res;
    UIImageView *imageGray;
    BOOL app1;
    BOOL app2;
    NSInteger sharetype;
}

@end

@implementation BoxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self create_notifications];
    [self prepareData];
    [self UIConfig];
    [self requsetData];

    shareBlock=^(NSString *type)
    {
        [self createMengban];
        [self createShareview:type];
    };
}
-(void)UIConfig
{
    UIButton *_btn=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_btn];
    [_btn setTitle:@"点击支付" forState:UIControlStateNormal];
    [_btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    _btn.frame=CGRectMake(0, 100, 90, 90);
    [_btn addTarget:self action:@selector(pay:) forControlEvents:UIControlEventTouchUpInside];
    _btn.hidden = YES;

    [self CreateView];

    UIButton *userHelpButton = [UIButton getCustomImgBtnWithImageStr:@"使用说明" WithSelectedImageStr:nil];
    [self.view addSubview:userHelpButton];
    [userHelpButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(35);
        make.right.mas_equalTo(-47);
        make.bottom.mas_equalTo(-30-kTabBarHeight);
    }];
    [userHelpButton addTarget:self action:@selector(userHelpAction) forControlEvents:UIControlEventTouchUpInside];
    userHelpButton.hidden = YES;
}
-(void)userHelpAction{
    [self.navigationController pushViewController:[BoxHelpViewController new] animated:YES];
}
-(void)CreateView
{
    CGFloat _labelheight=[self getLabelHeight];
    NSArray *titlearr=@[@"定学校",@"申请去",@"签证啦",@"飞赴美利坚"];
    NSArray *image_normal_arr=@[@"mainbox_定校灰色",@"mainbox_申请灰色",@"mainbox_签证灰色",@"mainbox_赴美灰色"];
    NSArray *image_select_arr=@[@"mainbox_定校",@"mainbox_申请",@"mainbox_去签证",@"mainbox_赴美"];
    /*********************视图的创建*********************/
    CGFloat _diameter=0;
    if(_isPad)
    {
        _diameter=90*_Scale;

    }else
    {
        if(kIPhone4s)
        {
            _diameter=110*_Scale;
        }else
        {
            _diameter=130*_Scale;
            
        }
    }

    CGFloat _jiange=(ScreenHeight-_diameter*4-kTabBarHeight-64-_labelheight*4)/7.0f;
    CGFloat _y_p=2*_jiange+64;
    for (int i=0; i<titlearr.count; i++) {
        NSData *localData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"box_main_gif@2x" ofType:@"gif"]];

        GifView *dataView = [[GifView alloc] initWithFrame:CGRectMake((ScreenWidth-_diameter)/2.0f-7, _y_p-7, _diameter+14, _diameter+14) data:localData];
        [self.view addSubview:dataView];
        dataView.tag=300+i;
        dataView.hidden=YES;


        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake((ScreenWidth-_diameter)/2.0f, _y_p, _diameter, _diameter);
        btn.tag=100+i;
        [btn setImage:[UIImage imageNamed:image_normal_arr[i]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:image_select_arr[i]] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(go_step_action:) forControlEvents:UIControlEventTouchUpInside];
        btn.selected=NO;
        [self.view addSubview:btn];
        UILabel *label=[[UILabel alloc] init];
        [self.view addSubview:label];
        label.tag=200+i;
        label.textAlignment=1;
        [label setAttributedText:[regular createAttributeString:titlearr[i] andFloat:@(2.0)]];
        //        label.backgroundColor=[UIColor redColor];
        label.font=[regular getFont:15.0f];
        label.textColor=_grayColor;
        [label sizeToFit];
        if(_jiange>0)
        {
            label.frame=CGRectMake((ScreenWidth-CGRectGetWidth(label.frame))/2.0f,CGRectGetMaxY(btn.frame)+_jiange/2.0f, CGRectGetWidth(label.frame), CGRectGetHeight(label.frame));
        }else
        {
            label.frame=CGRectMake((ScreenWidth-CGRectGetWidth(label.frame))/2.0f, CGRectGetMaxY(btn.frame)+5*_Scale, CGRectGetWidth(label.frame), CGRectGetHeight(label.frame));

        }

        _y_p+=_jiange+_diameter+_labelheight;
    }
}
-(void)go_step_action:(UIButton*)btn
{
    /*********************跳转视图*********************/

    if ([regular isLogin])
    {
        NSInteger _tag=btn.tag-100;
        if(_tag==0)
        {
            chooseSchoolController *flyVC = [[chooseSchoolController alloc] init];
            flyVC.step=_step;
            flyVC.block=shareBlock;

            [self.navigationController pushViewController:flyVC animated:YES];
        }else if(_tag==1)
        {
            Boxlistviewcontroller *Boxlistview = [[Boxlistviewcontroller alloc] init];
            Boxlistview.block=shareBlock;
            Boxlistview.info=@{@"titlename":@"申请啦！",@"step":[NSNumber numberWithInteger:_step],@"nowstep":[NSNumber numberWithInteger:1]};

            [self.navigationController pushViewController:Boxlistview animated:YES];


        }else if(_tag==2)
        {
            Boxlistviewcontroller *Boxlistview = [[Boxlistviewcontroller alloc] init];
            Boxlistview.block=shareBlock;
            Boxlistview.info=@{@"titlename":@"签证去！",@"step":[NSNumber numberWithInteger:_step],@"nowstep":[NSNumber numberWithInteger:2]};
            [self.navigationController pushViewController:Boxlistview animated:YES];

        }else if(_tag==3)
        {
            FlyUsaViewController *flyVC = [[FlyUsaViewController alloc] init];
            flyVC.step=_step;
            flyVC.block=shareBlock;
            [self.navigationController pushViewController:flyVC animated:YES];
        }

    }else
    {
        [self login_action];
    }
    /*********************跳转视图*********************/
}

-(void)nullaction{}
-(void)createShareview:(NSString *)type
{
    UIImageView *imageview=[[UIImageView alloc] initWithFrame:CGRectMake(0, (ScreenHeight-ScreenWidth)/2.0f,ScreenWidth , ScreenWidth)];
    imageview.userInteractionEnabled=YES;
//    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nullaction)];
//    [imageview addGestureRecognizer:tap];
    NSString *imagename=nil;
//    NSInteger _tag=0;
    if([type isEqualToString:@"fly"])
    {
        imagename=@"box_share_飞赴美国";
//        _tag=3;
        sharetype=3;

    }else if([type isEqualToString:@"qian"])
    {
        imagename=@"box_share_去签证";
//        _tag=2;
        sharetype=2;

    }else if([type isEqualToString:@"submit"])
    {

        imagename=@"box_share_申请啦";
//        _tag=1;
        sharetype=1;

    }else if([type isEqualToString:@"choose"])
    {
        imagename=@"box_share_定学校";
//        _tag=0;
        sharetype=0;
    }

    imageview.image=[UIImage imageNamed:imagename];
    [imageGray addSubview:imageview];

    UIButton *sharebtn=[UIButton buttonWithType:UIButtonTypeCustom];
    sharebtn.frame=CGRectMake((CGRectGetWidth(imageview.frame)-270*_Scale)/2.0f, CGRectGetHeight(imageview.frame)-110*_Scale, 270*_Scale, 70*_Scale);
    sharebtn.layer.masksToBounds=YES;
    sharebtn.layer.cornerRadius=2;
//    sharebtn.tag=300+_tag;
    [imageview addSubview:sharebtn];
    [sharebtn addTarget:self action:@selector(shareBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    [sharebtn setBackgroundColor:[UIColor colorWithRed:14.0f/255.0f green:195.0f/255.0f blue:162.0f/255.0f alpha:1]];

//    20 28 28 20
    UIImageView *share=[[UIImageView alloc] initWithFrame:CGRectMake(20*_Scale, (CGRectGetHeight(sharebtn.frame)-28*_Scale)/2.0f, 28*_Scale, 28*_Scale)];
    [sharebtn addSubview:share];
    share.image=[UIImage imageNamed:@"box_share_icon_分享"];

    UILabel *_share_content=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(share.frame)+20*_Scale, 0, CGRectGetWidth(sharebtn.frame)-CGRectGetMaxX(share.frame), CGRectGetHeight(sharebtn.frame))];
    [sharebtn addSubview:_share_content];
    _share_content.textAlignment=0;
    _share_content.text=@"分享给朋友吧";
    _share_content.font=[regular getFont:13.0f];
    _share_content.textColor=[UIColor whiteColor];
    if(_isPad)
    {
        share.frame=CGRectMake(30*_Scale, (CGRectGetHeight(sharebtn.frame)-28*_Scale)/2.0f, 28*_Scale, 28*_Scale);
        _share_content.frame=CGRectMake(CGRectGetMaxX(share.frame)+20*_Scale, 0, CGRectGetWidth(sharebtn.frame)-CGRectGetMaxX(share.frame), CGRectGetHeight(sharebtn.frame));
    }
}

- (void)shareBtnPress:(UIButton *)btn
{

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
    for (int i = 0; i < imageName.count; i ++) {
        UIButton *btn = [regular createBtnWithRect:CGRectMake(40*2*_Scale + (kScreenWidth- 40*2*_Scale)/3 * (i%3),15*2*_Scale+ 10*2*_Scale + 78*2*_Scale * (i/3), 50*2*_Scale, 50*2*_Scale) WithTitle:@"" WithNormalStr:imageName[i] WithSelectStr:nil];
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
- (void)sharePressBtn:(UIButton *)btn
{
    [self disapp];

    NSString *sharecontent=nil;
    NSString *imagename=nil;

    if(sharetype==0)
    {
        //        选学校
        sharecontent=@"决定了！我已经在留美盒子上定下了目标学校～ 要开始申请啦 —分享自［留美盒子］点击下载app \nhttps://appsto.re/cn/HYZ77.i";
        imagename=@"box_share_定学校";


    }else if(sharetype==1)
    {
        //        申请
        sharecontent=@"漂洋过海去留学！我已经成功拿到offer啦，快来恭喜我吧 —分享自［留美盒子］点击下载app \nhttps://appsto.re/cn/HYZ77.i";
        imagename=@"box_share_申请啦";


    }else if(sharetype==2)
    {
        //        签证
        sharecontent=@"签证到手留美在望！在留美盒子的帮助下我已经完成签证啦，抓紧时间和我约约约吧 —分享自［留美盒子］点击下载app \nhttps://appsto.re/cn/HYZ77.i";
        imagename=@"box_share_去签证";


    }else if(sharetype==3)
    {
        //        飞赴美国
        sharecontent=@"留学深造道阻且长！我已经飞赴美利坚啦，小伙伴们来日再聚 —分享自［留美盒子］点击下载app \nhttps://appsto.re/cn/HYZ77.i";
        imagename=@"box_share_飞赴美国";
    }

    
    
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
    JXLOG(@"ssss%ld",(long)[arrayName[btn.tag - 2000] integerValue]);
    
    //1、创建分享参数（必要）
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:sharecontent images:[UIImage imageNamed:imagename] url:[NSURL URLWithString:@"https://appsto.re/cn/HYZ77.i"] title:@"‘留美盒子’  美国高中都在这！" type:SSDKContentTypeAuto];
    
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
-(void)createMengban
{
    imageGray = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"蒙板"]];
    imageGray.userInteractionEnabled = YES;
    imageGray.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    imageGray.tag=878;
    [[UIApplication sharedApplication].keyWindow addSubview:imageGray];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disapp)];
    [imageGray addGestureRecognizer:tap];
}
-(void)disapp
{
    [[self.view.window viewWithTag:878] removeFromSuperview];
}
- (void)requsetData
{
    if([regular isLogin])
    {
        /****************获取当前进行状态******************/

        NSString *url = [NSString stringWithFormat:@"%@/v1/user_boxes?token=%@",DNS,[regular getToken]];
        [HttpRequestManager GET:url complete:^(NSData *data) {
            res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            if([[res objectForKey:@"code"] integerValue]==1)
            {
                if ([res[@"data"][@"go_us"] integerValue] == 1)
                {
                    _step=4;

                }else if([res[@"data"][@"go_visa"] integerValue] == 1)
                {
                    _step=3;

                }else if ([res[@"data"][@"apply_school"] integerValue] == 1)
                {
                    _step=2;
                }else  if ([res[@"data"][@"order_school"] integerValue] == 1)
                {
                    _step=1;
                }else
                {

                    if([res[@"data"][@"first_done"] integerValue]>0)
                    {
                        _step=0;
                    }
                    _step=0;
                }
                [self setStatus];


            }}failed:^{
                [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
            }];
    }
}
-(void)setStatus
{
    for (int i=0; i<4; i++) {
        UIButton *btn=(UIButton *)[self.view viewWithTag:100+i];
        UILabel *label=(UILabel *)[self.view viewWithTag:200+i];
        if(_step==0)
        {
            btn.selected=NO;
            label.textColor=_grayColor;
             [self setgif_hideWithTag:0];
        }else
        {
            if(_step+1>i)
            {
                btn.selected=YES;
                if(_step==i)
                {
                    label.textColor=_yellowColor;
                    [self setgif_hideWithTag:i];
                }else
                {
                    label.textColor=_blueColor;
                    [self setgif_hideWithTag:6];
                }

            }else
            {
                btn.selected=NO;
                label.textColor=_grayColor;
//                [self setgif_hideWithTag:6];

            }
        }
    }
}
-(void)setgif_hideWithTag:(NSInteger )tag
{
    for (int j=0; j<5; j++) {
        if(j==tag)
        {
            ((UIView *)[self.view viewWithTag:300+j]).hidden=NO;
        }else
        {
            ((UIView *)[self.view viewWithTag:300+j]).hidden=YES;
        }
    }

}

- (void)pay:(UIButton *)btn
{
    //    NSArray *tradeNO = @[@"100",@"1000",@"10000"];
    //    NSArray *price = @[@(0.1),@(0.2),@(0.3)];
    Order *order = [[Order alloc] init];
    order.partner = PARTNER;
    order.seller = SELLER;
    long y = (arc4random() % 1001) + 1000000;
    order.tradeNO = [[NSString alloc] initWithFormat:@"%ld",y]; //订单ID(由商家□自□行制定)
    order.productName = @"DDAY"; //商品标题
    order.productDescription = @"DDAY_Test"; //商品描述
    order.amount = @"0.01";
//    order.notifyURL = @"http://120.26.192.105:5000/v1/alipay/notify"; //回调URL
    order.notifyURL = @"http://121.40.57.9:8050/dday-web/service/user/alipayResult.do";
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    NSString *appScheme = @"OneBox";
    NSString *orderSpec = [order description];
    JXLOG(@"orderSpec = %@",orderSpec);
    id<DataSigner> signer = CreateRSADataSigner(PRIVATEKEY);
    NSString *signedString = [signer signString:orderSpec];
    NSString *orderString = nil;
        if (signedString != nil) {
            orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                           orderSpec, signedString, @"RSA"];
            JXLOG(@"%@",orderString);
            [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                JXLOG(@"reslut = %@",resultDic);
            }];}

}
-(CGFloat )getLabelHeight
{

    UILabel *label=[[UILabel alloc] init];
    [self.view addSubview:label];
    label.textAlignment=1;
    [label setAttributedText:[regular createAttributeString:@"定学校" andFloat:@(2.0)]];
    label.font=[regular getFont:15.0f];
    [label sizeToFit];
    return CGRectGetHeight(label.frame);
}

-(void)login_action
{
    LoginViewController*login=[[LoginViewController alloc] init];
    login.type=@"other";
    [self presentModalViewController:login animated:YES];
}
-(void)prepareData
{
    sharetype=0;
    _step=0;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:70.0f/255.0f green:195.0f/255.0f blue:247.0f/255.0f alpha:1];
    self.view.backgroundColor=_define_backview_color;
    self.navigationItem.titleView=[regular returnNavView:@"四步赴美" withmaxwidth:230];
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
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

}
-(void)create_notifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload) name:@"reload" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(xiaoshi:) name:@"xiaoshi" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(other) name:@"other" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginout) name:@"loginout" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toprepareData) name:@"updataBox" object:nil];
}
-(void)reload
{
    [self requsetData];
}
-(void)xiaoshi:(NSNotification *)not
{
    if([not.object isEqualToString:@"other"])
    {
        [self dismissModalViewControllerAnimated:YES];
    }
}
-(void)other
{
    [self dismissModalViewControllerAnimated:YES];
}
-(void)loginout
{
    _step=0;
    [self setStatus];
}
-(void)toprepareData
{
    [self requsetData];

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"BoxViewController"];
    [[CustomTabbarController sharedManager] tabbarAppear];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"BoxViewController"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
