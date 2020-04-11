

//
//  UserInfoViewController.m
//  OneBox
//
//  Created by 谢江新 on 15-2-4.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import "UserInfoViewController.h"

#import "HttpRequestManager.h"
#import "QiniuSDK.h"
#import "UIImageView+AFNetworking.h"

#import <CoreLocation/CoreLocation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

#import "CustomTabbarController.h"
#import "SuggestViewController.h"
#import "AboutViewController.h"
#import "GoalViewController.h"
#import "CollectionSchoolDeleteViewController.h"
#import "LoginViewController.h"

#import "regular.h"
#import "MyMD5.h"
#import "MyInfo.h"

#import <objc/runtime.h>

static void *EOCAlertViewKey = "EOCAlertViewKey";

@interface UserInfoViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,NSURLConnectionDelegate,UITextFieldDelegate,UICollectionViewDelegate,UIAlertViewDelegate,MFMailComposeViewControllerDelegate,UIActionSheetDelegate>
{
    UIButton *setBtn;

    BOOL _isfirstlogin;
    BOOL app1;
    BOOL app2;
    MyInfo *info;
    UIButton *shareBtn;
    BOOL _click;
    UIView *view;
    UIImageView *icon;
    UIButton *submitBtn;

    UITextField *NickText;
    UITextField *MailText ;
    UITextField *FieldText;
    UITextField *SignText;
    BOOL count;
    int keyboardhight;
    UIView *iconImage;
    UIButton *aboutBtn;
    UIImageView* imageGray;
    NSMutableArray *whiteViewArr;
    NSString *upToken;
    UILabel *area;
    UITextField *currentFeild;
    UIScrollView *_scrollView;
}
@property(strong,nonatomic)NSMutableData *datas;
@end

@implementation UserInfoViewController

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    void (^alertViewBlock)(NSInteger) = objc_getAssociatedObject(alertView, EOCAlertViewKey);
    alertViewBlock(buttonIndex);
}



-(void)xiaoshi:(NSNotification *)not
{

    if([not.object isEqualToString:@"chat"])
    {
        [self dismissModalViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"selectmap" object:nil];


        //        回到地图页面
    }else if([not.object isEqualToString:@"userinfo"])
    {
        [self dismissModalViewControllerAnimated:YES];

        
    }
}
-(void)backloginout
{
    for (UIView *__view in _scrollView.subviews) {

        [__view removeFromSuperview];
    }
    _scrollView.contentSize=CGSizeMake(CGRectGetWidth(_scrollView.frame), 0);

    self.navigationItem.rightBarButtonItem=nil;

    [self unloginui];
}
-(void)backlogin
{
    [self dismissModalViewControllerAnimated:YES];
    for (UIView *__view in _scrollView.subviews) {

        [__view removeFromSuperview];
    }
    _scrollView.contentSize=CGSizeMake(CGRectGetWidth(_scrollView.frame), 0);

    [self loginui];
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];

    _isfirstlogin=YES;
    self.navigationController.navigationBar.barTintColor =[UIColor colorWithRed:70.0f/255.0f green:195.0f/255.0f blue:247.0f/255.0f alpha:1];
    self.view.backgroundColor=_define_backview_color;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backloginout) name:@"backloginout" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(xiaoshi:) name:@"xiaoshi" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backlogin) name:@"backlogin" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(delete_col:) name:@"delete_col" object:nil];

    [self createScrollView];
    if([regular isLogin])
    {
        //        登录了
        [self loginui];
    }else
    {
        [self unloginui];
    }
    [self block];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nonotification) name:@"nonotification" object:nil];
}
#pragma mark-设定是否有未读消息
-(void)nonotification
{

    if([[NSUserDefaults standardUserDefaults] objectForKey:@"no_read_pm_count"]!=nil)
    {
        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"no_read_pm_count"] integerValue]>0)
        {
            [setBtn setImage:[UIImage imageNamed:@"设置_not"] forState:UIControlStateNormal];

        }else
        {
            [setBtn setImage:[UIImage imageNamed:@"设置"] forState:UIControlStateNormal];
        }
    }else
    {
        [setBtn setImage:[UIImage imageNamed:@"设置"] forState:UIControlStateNormal];
    }
    
}
#pragma mark-刷新个人信息
-(void)block
{
    WeakSelf(ws);
    updataInfo=^(NSDictionary *dict)
    {

        [(UILabel *)[ws.view viewWithTag:3000] setAttributedText:[regular createAttributeString:[dict objectForKey:@"username"] andFloat:@(2.0)]];
        NSString *_citystr=nil;
        if([dict objectForKey:@"city"]==nil||[[dict objectForKey:@"city"] isEqualToString:@""])
        {
            _citystr=@"反正不是火星";
        }else
        {
            _citystr=[dict objectForKey:@"city"];
        }
        [(UILabel *)[ws.view viewWithTag:3001] setAttributedText:[regular createAttributeString:_citystr andFloat:@(2.0)]];
        [(UILabel *)[ws.view viewWithTag:3002] setAttributedText:[regular createAttributeString:[dict objectForKey:@"mark"] andFloat:@(2.0)]];
    };
}
-(void)login_Action
{

    if(![regular isLogin])
    {
        LoginViewController*login=[[LoginViewController alloc] init];
        login.type=@"userinfo";
        [self presentModalViewController:login animated:YES];
    }
}
-(void)unloginui
{
    _isfirstlogin=YES;
    //        未登录
    self.navigationItem.titleView=[regular returnNavView:@"登录" withmaxwidth:230];

    UIImageView *imageview=[[UIImageView alloc] initWithFrame:CGRectMake(50*_Scale, 80*_Scale, ScreenWidth-100*_Scale, 470*_Scale)];
    [_scrollView addSubview:imageview];
    imageview.userInteractionEnabled=YES;
    imageview.backgroundColor=[UIColor clearColor];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(login_Action)];
    [imageview addGestureRecognizer:tap];

    UIImageView *upview=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(imageview.frame), 400*_Scale)];

    upview.backgroundColor=[UIColor whiteColor];
    //    upview.layer.masksToBounds=YES;
    //    upview.layer.borderWidth=1;
    //    upview.layer.borderColor=[[UIColor  colorWithRed:77/255.0 green:190/255.0 blue:217/255.0 alpha:1.0]CGColor] ;

    [imageview addSubview:upview];

    //225 60
    UIImageView *head=[[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(upview.frame)-225*_Scale)/2.0f, 60*_Scale, 225*_Scale, 225*_Scale)];
    head.userInteractionEnabled=YES;
    head.image=[UIImage imageNamed:@"head_未登陆"];
    [upview addSubview:head];

    


    UIButton *downview=[UIButton buttonWithType:UIButtonTypeCustom];
    downview.frame=CGRectMake(0, CGRectGetMaxY(upview.frame)+5, CGRectGetWidth(imageview.frame), CGRectGetHeight(imageview.frame)-CGRectGetMaxY(upview.frame)-5);
    [downview setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [downview setTitle:@"登  录" forState:UIControlStateNormal];
    [imageview addSubview:downview];
    [downview.titleLabel setAttributedText:[regular createAttributeString:@"登  录" andFloat:@(2.0)]];
    downview.backgroundColor=[UIColor  colorWithRed:77/255.0 green:190/255.0 blue:217/255.0 alpha:1.0];
    downview.titleLabel.font=[regular getFont:14.0f];
    [downview addTarget:self action:@selector(login_Action) forControlEvents:UIControlEventTouchUpInside];

    //        downview.userInteractionEnabled=YES;
}
-(void)loginui
{
    _isfirstlogin=YES;
    [self prepareData];
    [self UIConfig];
    [self getData];
    [self prepareToken];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateImg:) name:@"updateImg" object:nil];

}

-(void)updateImg:(NSNotification *)not
{

    if(not.object!=nil)
    {
        NSUserDefaults *dict=[NSUserDefaults standardUserDefaults];
        [icon setImage:[UIImage imageWithData:[dict objectForKey:@"userImage"]]];
        for (int i=0;i<3;i++) {
            UILabel *label=(UILabel *)[self.view viewWithTag:3000+i];
            //        CGFloat _font=i==0?15.0f:i==1?9.0f:11.0f;
//            CGFloat _x=i==1?2.5f:5.0f;

            NSString *title=i==0?[not.object objectForKey:@"name"]:i==1?[not.object objectForKey:@"loc"]:[not.object objectForKey:@"sign"];

            [label setAttributedText:[regular createAttributeString:title andFloat:@(2.0)]];
            
        }


    }
    //    [[[icon setImage:[UIImage imageWithData:[dict objectForKey:@"userImage"]] forState:UIControlStateNormal] ] ];

}
-(void)delete_col:(NSNotification *)not
{
    NSInteger col_num=[((UILabel*)[self.view viewWithTag:3050]).text integerValue ];
    col_num--;
    ((UILabel*)[self.view viewWithTag:3050]).text=[[NSString alloc] initWithFormat:@"%ld",(long)col_num];

}
-(void)prepareData
{
    whiteViewArr = [[NSMutableArray alloc] init];

    setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    setBtn.frame = CGRectMake(0, 0, 22, 22);
    NSString *imagename=nil;
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"no_read_pm_count"]!=nil)
    {

        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"no_read_pm_count"] integerValue]>0)
        {
            imagename=@"设置_not";

        }else
        {
            imagename=@"设置";
        }

    }else
    {
        imagename=@"设置";
    }
    [setBtn setImage:[UIImage imageNamed:imagename] forState:UIControlStateNormal];
    [setBtn addTarget:self action:@selector(setBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:setBtn];
}
- (void)prepareToken
{
    NSString *achieveToken = [NSString stringWithFormat:@"%@/v1/uptoken",DNS];
    [HttpRequestManager GET:achieveToken complete:^(NSData *data) {
        id res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        upToken = res[@"uptoken"];
        
    } failed:^{
        JXLOG(@"失败");
    }];
    
}
-(void)popviewAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark-获取粉丝数
-(void)getData
{
    NSString *url = [NSString stringWithFormat:@"%@/v1/users/%@?token=%@",DNS,[regular getUID],[regular getToken]];
    [HttpRequestManager GET:url complete:^(NSData *data) {
        id res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *_dict=(NSDictionary*)res;

        if([[_dict objectForKey:@"code"] integerValue]==1)
        {
            info = [MyInfo parsingWithJsonDataForModel:data];

            [(UILabel *)[self.view viewWithTag:3000] setAttributedText:[regular createAttributeString:info.username andFloat:@(2.0)]];

            NSString *_citystr=nil;
            if(info.city==nil||[info.city isEqualToString:@""])
            {
                _citystr=@"反正不是火星";
            }else
            {
                _citystr=info.city;
            }

            [(UILabel *)[self.view viewWithTag:3001] setAttributedText:[regular createAttributeString:_citystr andFloat:@(2.0)]];
            [(UILabel *)[self.view viewWithTag:3002] setAttributedText:[regular createAttributeString:info.mark andFloat:@(2.0)]];


            NickText.text = info.username;
            NickText.userInteractionEnabled=NO;
            MailText.text = info.email;
            MailText.userInteractionEnabled=NO;

            FieldText.text = info.city;
            FieldText.userInteractionEnabled=NO;

            area.text = info.username;
            area.userInteractionEnabled=NO;

            SignText.text = info.mark;
            SignText.userInteractionEnabled=NO;

            NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
            NSData *imageData1 = UIImageJPEGRepresentation(icon.image, 1.0);
            [defaults setObject:imageData1 forKey:@"userImage"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateImg" object:nil];
            [(UILabel *)[self.view viewWithTag:3050] setAttributedText:[regular createAttributeString:[[NSString alloc] initWithFormat:@"%ld",(long)info.follow_schools_count] andFloat:@(0)]];
            [(UILabel *)[self.view viewWithTag:3051] setAttributedText:[regular createAttributeString:[[NSString alloc] initWithFormat:@"%ld",(long)info.order_schools_count] andFloat:@(0)]];
            [(UILabel *)[self.view viewWithTag:3052] setAttributedText:[regular createAttributeString:[[NSString alloc] initWithFormat:@"%ld",(long)info.enroll_order_schools_count] andFloat:@(0)]];

        }else
        {
             [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:[_dict objectForKey:@"message"] WithImg:@"Prompt_网络出错白色" Withtype:1]];
        }
        




    } failed:^{
        JXLOG(@"失败");
    }];
}
-(void)tapAction:(UIGestureRecognizer *)sender
{
    
    NSInteger _index= sender.view.tag-500;
    if(_index==0)
    {
        //       我的粉丝
    }else if(_index==1)
    {
        //        我的关注
        
    }else if(_index==2)
    {
        //        收藏学校
        CollectionSchoolDeleteViewController *col=[[CollectionSchoolDeleteViewController alloc] init];
//        col.dict=[[NSDictionary alloc] initWithObjectsAndKeys:@"add",@"type",[NSDictionary new],@"dict",nil];

        [self.navigationController pushViewController:col animated:YES];
        
    }else if(_index==3)
    {
        //        参与活动
        
    }
    
}

#pragma mark --点击方法
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            //相机:先判断是否支持相机,然后询问用户是否同意使用
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                //打开相机
                [self loadImageWithType:UIImagePickerControllerSourceTypeCamera];
            }
            else
            {
                JXLOG(@"不能打开相机");
            }

        }
            break;
        case 1:
        {
            //相册
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                [self loadImageWithType:UIImagePickerControllerSourceTypePhotoLibrary];
            }
            else
            {
                JXLOG(@"无法打开相册");
            }


        }
            break;

        default:
            break;
    }
}
-(void)detailView:(UIGestureRecognizer *)sender
{

    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册选择", nil];

    [sheet showInView:self.view];


}

-(void)createScrollView
{
    
    _scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight, ScreenWidth, ScreenHeight-64-kTabBarHeight)];
    _scrollView.contentSize=CGSizeMake(ScreenWidth, ScreenHeight-kStatusBarAndNavigationBarHeight-kTabBarHeight);
    [self.view addSubview:_scrollView];
}
-(void)mubiao_action:(UIGestureRecognizer *)ges
{
    if(ges.view.tag==3600)
    {
#pragma mark- 收藏
//        [self aboutBtnPress];
        CollectionSchoolDeleteViewController *col=[[CollectionSchoolDeleteViewController alloc] init];
        //        col.block=changeBlock;
//        col.dict=[[NSDictionary alloc] initWithObjectsAndKeys:@"delete",@"type",[NSDictionary new],@"dict",nil];

        [self.navigationController pushViewController:col animated:YES];
    }else if(ges.view.tag==3601)
    {
#pragma mark- 目标
        GoalViewController *goal=[[GoalViewController alloc] init];
        goal.type=@"goal";
        [self.navigationController pushViewController:goal animated:YES];

    }else if(ges.view.tag==3602)
    {
#pragma mark- 录取
        GoalViewController *goal=[[GoalViewController alloc] init];
        goal.type=@"admit";
        [self.navigationController pushViewController:goal animated:YES];
    }
}
-(void)UIConfig
{
    UIView *navView = [regular returnNavView:@" 我的" withmaxwidth:230];
    self.navigationItem.titleView=navView;
    iconImage = [[UIView alloc] init];
    iconImage.frame = CGRectMake(10,20*_Scale, ScreenWidth-20, 590*_Scale);
    UIImageView *upview=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(iconImage.frame), 362*_Scale)];
    upview.image=[UIImage imageNamed:@""];
    upview.backgroundColor=[UIColor whiteColor];
    [iconImage addSubview:upview];
    UIView *jiange=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(upview.frame)-1*_Scale, CGRectGetWidth(upview.frame), 1*_Scale)];
    jiange.backgroundColor=self.view.backgroundColor;
    [upview addSubview:jiange];

    UIView *downview=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(upview.frame), CGRectGetWidth(iconImage.frame), CGRectGetHeight(iconImage.frame)-CGRectGetMaxY(upview.frame))];
    downview.backgroundColor=[UIColor whiteColor];
    [iconImage addSubview:downview];

// i 44 w 62 28
    CGFloat _radius=(CGRectGetWidth(iconImage.frame)-44*2*_Scale-62*_Scale*2)/3.0f;
    for (int i=0; i<3; i++) {
        UIImageView *imageview=[[UIImageView alloc] initWithFrame:CGRectMake(62*_Scale+(_radius+44*_Scale)*i, 28*_Scale+CGRectGetMaxY(upview.frame), _radius, _radius)];

        imageview.layer.masksToBounds=YES;
        imageview.layer.cornerRadius=CGRectGetWidth(imageview.frame)/2.0f;
        imageview.layer.borderColor=[[UIColor colorWithRed:210.0f/255.0f green:210.0f/255.0f blue:210.0f/255.0f alpha:1] CGColor];
        imageview.layer.borderWidth=1*_Scale;
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mubiao_action:)];
        imageview.tag=3600+i;
        [imageview addGestureRecognizer:tap];
        imageview.userInteractionEnabled=YES;
        [iconImage addSubview:imageview];
        UILabel *contentlabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(imageview.frame), CGRectGetHeight(imageview.frame))];


        contentlabel.textColor=_define_blue_color;
        contentlabel.tag=3050+i;
        contentlabel.textAlignment=1;
        contentlabel.font=[regular get_en_Font:25.0f];
        [imageview addSubview:contentlabel];


        UILabel *titlelabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(imageview.frame)+2, CGRectGetMaxY(imageview.frame), _radius, CGRectGetHeight(iconImage.frame)-CGRectGetMaxY(imageview.frame)-20*_Scale)];
        titlelabel.textAlignment=1;
        titlelabel.textColor=[UIColor colorWithRed:204.0f/255.0f green:204.0f/255.0f blue:204.0f/255.0f alpha:1];
        titlelabel.font=[regular getFont:12.0f];
        NSString *__title=i==0?@"心愿":i==1?@"目标":@"录取";
        [titlelabel setAttributedText:[regular createAttributeString:__title andFloat:@(4.0)]];


        [iconImage addSubview:titlelabel];
    }

    [_scrollView addSubview:iconImage];

    /**************信息简述*******************/
    
    /*********************************/


    NSData *headImg_data=[[NSUserDefaults standardUserDefaults] objectForKey:@"userImage"];
//    h 44 r 154
    icon = [[UIImageView alloc] initWithImage:[UIImage imageWithData:headImg_data]];
    icon.frame=CGRectMake((CGRectGetWidth(iconImage.frame)-154*_Scale)/2.0f, 44*_Scale, 154*_Scale, 154*_Scale);
    icon.userInteractionEnabled = YES;

    icon.layer.masksToBounds = YES;
    icon.layer.cornerRadius = icon.frame.size.width/2.0;
    [iconImage addSubview:icon];
    UIView *zhegai=[[UIView alloc] initWithFrame:CGRectMake(-1,-1 , CGRectGetWidth(icon.frame)+2, CGRectGetWidth(icon.frame)+2)];
    zhegai.backgroundColor=[UIColor clearColor];
    zhegai.layer.masksToBounds=YES;
    zhegai.layer.cornerRadius=CGRectGetWidth(zhegai.frame)/2.0f;
    zhegai.layer.borderColor = [_define_head_color CGColor];
    zhegai.layer.borderWidth = 4.0f;
    [icon addSubview:zhegai];

    
    UIButton *updateIcon = [UIButton buttonWithType:UIButtonTypeCustom];
    [updateIcon setBackgroundImage:[UIImage imageNamed:@"修改头像"] forState:UIControlStateNormal];
    if(_isPad)
    {
        updateIcon.frame = CGRectMake(CGRectGetMaxX(icon.frame)-38, 70,20, 20 );

    }else
    {
        updateIcon.frame = CGRectMake(105 + 70 * __Scale+4, 35, 20, 20);
    }

    [updateIcon addTarget:self action:@selector(detailView:) forControlEvents:UIControlEventTouchUpInside];
    [iconImage addSubview:updateIcon];

    UITapGestureRecognizer *tap1=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(detailView:)];
//    iconImage.userInteractionEnabled=YES;
    [icon addGestureRecognizer:tap1];

    CGFloat _label_height=(CGRectGetMaxY(upview.frame)-CGRectGetMaxY(icon.frame)-35*_Scale)/3.0f;
    for (int i=0;i<3;i++) {
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(icon.frame)+10*_Scale+i*_label_height, CGRectGetWidth(iconImage.frame), _label_height)];
        CGFloat _font=i==0?15.0f:i==1?9.0f:11.0f;
        label.font=[regular getFont:_font];
        label.textAlignment=1;
        label.textColor=_define_blue_color;
        label.tag=3000+i;
        [iconImage addSubview:label];
    }


    
    shareBtn = [regular createBtnWithRect:CGRectMake((CGRectGetWidth(_scrollView.frame)-133*_Scale-88*_Scale*2)/2.0f, CGRectGetMaxY(iconImage.frame) +50*_Scale, 88*_Scale, 88*_Scale)  WithTitle:@"" WithNormalColor:[UIColor whiteColor] WithSelectColor:nil WithTitleFont:[regular getFont:15.0f]];
    [shareBtn addTarget:self action:@selector(shareBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    [shareBtn setBackgroundImage:[UIImage imageNamed:@"setting_分享"] forState:UIControlStateNormal];
    [_scrollView addSubview:shareBtn];
    UILabel *labelshare=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(shareBtn.frame)-20, CGRectGetMaxY(shareBtn.frame), CGRectGetWidth(shareBtn.frame)+40, 40*_Scale)];
    [_scrollView addSubview:labelshare];
    labelshare.textAlignment=1;
    labelshare.font=[regular getFont:10.0f];
    labelshare.textColor=_define_blue_color;
    labelshare.text=@"分 享";


    aboutBtn = [regular createBtnWithRect:CGRectMake(88*_Scale+133*_Scale+((CGRectGetWidth(_scrollView.frame)-133*_Scale-88*_Scale*2)/2.0f), CGRectGetMaxY(iconImage.frame) +50*_Scale, 88*_Scale, 88*_Scale) WithTitle:@"" WithNormalColor:[UIColor whiteColor] WithSelectColor:nil WithTitleFont:[regular getFont:15.0f]];
//    aboutBtn.titleLabel.font =[regular getFont:13.0f];
    [aboutBtn addTarget:self action:@selector(aboutBtnPress) forControlEvents:UIControlEventTouchUpInside];
    [aboutBtn setBackgroundImage:[UIImage imageNamed:@"setting_意见"] forState:UIControlStateNormal];
    [_scrollView addSubview:aboutBtn];
    UILabel *labelabout=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(aboutBtn.frame)-20, CGRectGetMaxY(aboutBtn.frame), CGRectGetWidth(aboutBtn.frame)+40, 40*_Scale)];
    [_scrollView addSubview:labelabout];
    labelabout.textAlignment=1;
    labelabout.font=[regular getFont:10.0f];
    labelabout.textColor=_define_blue_color;
    labelabout.text=@"你 好";
    [self createVersionView];



}
-(void)createVersionView
{
    UIView *backview=[[UIView alloc] initWithFrame:CGRectMake((ScreenWidth-100*_Scale)/2, CGRectGetMaxY(aboutBtn.frame)+70*_Scale, 100*_Scale, 50*_Scale)];
    backview.backgroundColor=[UIColor clearColor];
    [_scrollView addSubview:backview];
    UIImageView *banbenimg=[[UIImageView alloc] initWithFrame:CGRectMake(25*_Scale, 0, 50*_Scale, 50*_Scale)];
    banbenimg.image=[UIImage imageNamed:@"版本_v1.0"];
    [backview addSubview:banbenimg];

    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(banbenimg.frame), CGRectGetWidth(backview.frame), CGRectGetHeight(backview.frame)-CGRectGetMaxY(banbenimg.frame))];
    label.textAlignment=1;

//    label.text=@"V 1.4";
    label.textColor=[UIColor colorWithRed:193.0f/255.0f green:193.0f/255.0f blue:193.0f/255.0f alpha:1];
    label.font=[regular get_en_Font:11.0f];
    [backview addSubview:label];
    _scrollView.contentSize=CGSizeMake(CGRectGetWidth(_scrollView.frame), CGRectGetMaxY(backview.frame)+10*_Scale);
}

-(void)disapp
{
[[self.view.window viewWithTag:878] removeFromSuperview];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"UserInfoViewController"];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"UserInfoViewController"];
    [[CustomTabbarController sharedManager] tabbarAppear];
    if([regular isLogin])
    {
        if(_isfirstlogin)
        {
            _isfirstlogin=NO;
        }else
        {
            [self getData];
        }
    }
    self.navigationController.navigationBar.subviews[0].subviews[0].hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)click:(UIButton *)btn
{
    if(!_click)
    {
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1];
        shareBtn.frame = CGRectMake(CGRectGetMinX(shareBtn.frame), CGRectGetMinY(shareBtn.frame) + 30*__Scale, CGRectGetWidth(shareBtn.frame), CGRectGetHeight(shareBtn.frame));
        submitBtn.frame = CGRectMake(CGRectGetMinX(submitBtn.frame), CGRectGetMinY(submitBtn.frame) + 30*__Scale, CGRectGetWidth(submitBtn.frame), CGRectGetHeight(submitBtn.frame));
        aboutBtn.frame = CGRectMake(CGRectGetMinX(submitBtn.frame),  CGRectGetMinY(aboutBtn.frame) + 30 *__Scale,  CGRectGetWidth(submitBtn.frame), CGRectGetHeight(aboutBtn.frame));
        [UIView commitAnimations];
        _click = !_click;
        FieldText.userInteractionEnabled = YES;
        SignText.userInteractionEnabled = YES;
    }
    else
    {
        //        view.hidden = YES;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1];
        shareBtn.frame=CGRectMake(CGRectGetMinX(shareBtn.frame), CGRectGetMinY(shareBtn.frame) - 30*__Scale, CGRectGetWidth(shareBtn.frame), CGRectGetHeight(shareBtn.frame));
        submitBtn.frame = CGRectMake(CGRectGetMinX(submitBtn.frame), CGRectGetMinY(submitBtn.frame) - 30*__Scale, CGRectGetWidth(submitBtn.frame), CGRectGetHeight(submitBtn.frame));
        aboutBtn.frame = CGRectMake(CGRectGetMinX(submitBtn.frame),  CGRectGetMinY(aboutBtn.frame) - 30 *__Scale,  CGRectGetWidth(submitBtn.frame), CGRectGetHeight(aboutBtn.frame));
        [UIView commitAnimations];
        _click = !_click;
        FieldText.userInteractionEnabled = NO;
        SignText.userInteractionEnabled = NO;
        
    }
}
#pragma mark --点击方法
- (void)btnPress:(UIButton *)btn
{
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机",@"从相册选取", nil];
    [sheet showInView:self.view];
    
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

    app1 = [ShareSDK isClientInstalled:SSDKPlatformTypeWechat];
    app2 = [ShareSDK isClientInstalled:SSDKPlatformSubTypeQQFriend];

    UIView *fatherView=nil;
    if((app1==NO)&&(app2==NO))
    {
        fatherView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight-110*2*_Scale, ScreenWidth, 110*2*_Scale)];

    }else
    {
        fatherView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight-200*2*_Scale, ScreenWidth, 200*2*_Scale)];

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
//    r 50  bianju 40
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
- (void)sharePressBtn:(UIButton *)btn
{
    [self disapp];
    
    NSArray *arrayName =nil;
    //    id<ISSWeChatApp> app1 =(id<ISSWeChatApp>)[ShareSDK getClientWithType:ShareTypeWeixiTimeline];
    //    id<ISSQQApp> app2 =(id<ISSQQApp>)[ShareSDK getClientWithType:ShareTypeQQSpace];
    
    //  @[@(22),@(23),@(1),@(24),@(6),@(18)];
    //    @[@"微信Share",@"朋友圈Share",@"微博Share",@"qqShare",@"qq空间Share",];
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
    [shareParams SSDKSetupShareParamsByText:@"［留美盒子］美国高中都在这 .\n\n＊美校大数据\n多维度信息,全方位评价,深度定义全貌,作出最好留学决策\n\n＊校方直达\n直达官网,直拨电话,直发邮件,接触校方和招生官,全面互动无障碍\n\n＊四步留美\n智慧美盒,选校 申请 签证 飞赴美利坚,带你完成申校赴美之旅\n\n点击下载 \nhttps://appsto.re/cn/HYZ77.i" images:nil url:[NSURL URLWithString:@"https://appsto.re/cn/HYZ77.i"] title:@"‘留美盒子’  美国高中都在这！" type:SSDKContentTypeAuto];
    
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

- (NSString *)getInfo:(NSInteger)i
{
    UITextField *textField = whiteViewArr[i];
    return textField.text;
}

//email格式验证函数
- (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];

    return [emailTest evaluateWithObject:candidate];
}



- (void)caseBtn:(UIButton *)btn
{
    [imageGray removeFromSuperview];
}
- (void)aboutBtnPress
{
#pragma mark-意见建议
    SuggestViewController *suggest=[[SuggestViewController alloc] init];
    [self.navigationController pushViewController:suggest animated:YES];

}
- (void)setBtnPress:(UIButton *)btn
{
    AboutViewController *UserSet = [[AboutViewController alloc] init];
    [self.navigationController pushViewController:UserSet animated:YES];
}


-(void)loadImageWithType:(UIImagePickerControllerSourceType)type
{
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];

    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];

    if (author == kCLAuthorizationStatusRestricted || author ==kCLAuthorizationStatusDenied){

        UIAlertView *alertviewCamera=[[UIAlertView alloc] initWithTitle:@"" message:@"请在iPhone的 设置－隐私－相机 选项中，允许留美盒子访问你的相册。" delegate:self cancelButtonTitle:@"好的" otherButtonTitles: nil];
        alertviewCamera.delegate=self;
        void (^alertViewBlock)(NSInteger) = ^(NSInteger buttonIndex){
            [regular pushSystem];
        };
        objc_setAssociatedObject(alertviewCamera, EOCAlertViewKey, alertViewBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
        [alertviewCamera show];

    }else if(authStatus == ALAuthorizationStatusRestricted || authStatus == ALAuthorizationStatusDenied)
    {
        UIAlertView *alertviewalbum=[[UIAlertView alloc] initWithTitle:@"" message:@"请在iPhone的 设置－隐私－相机 选项中，允许留美盒子访问你的相机。" delegate:self cancelButtonTitle:@"好的" otherButtonTitles: nil];
        alertviewalbum.delegate=self;
        void (^alertViewBlock)(NSInteger) = ^(NSInteger buttonIndex){
            [regular pushSystem];
        };
        objc_setAssociatedObject(alertviewalbum, EOCAlertViewKey, alertViewBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
        [alertviewalbum show];

    }else
    {
        //创建图片选取器
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        //设置选取器类型
        picker.sourceType = type;
        //编辑
        picker.allowsEditing = YES;
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
        UIColor * color = [UIColor whiteColor];

        //    2    //这里我们设置的是颜色，还可以设置shadow等，具体可以参见api

        NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:UITextAttributeTextColor];

        //    3    //大功告成

        picker.navigationBar.titleTextAttributes = dict;


        //弹出
        [self presentViewController:picker animated:YES completion:nil];
        
    }
    
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    JXLOG(@"%@",info);
    //找出图片
    UIImage *originImage = info[UIImagePickerControllerEditedImage];

    icon.image = originImage;
    [picker dismissViewControllerAnimated:YES completion:nil];

    NSData *data = UIImageJPEGRepresentation(originImage, 1.0f);

    QNUploadManager *upManager = [[QNUploadManager alloc] init];

    [upManager putData:data key:nil token:upToken
              complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                  [self uploadImage:resp[@"key"]];
              } option:nil];

    
}
- (void)uploadImage:(NSString *)key
{
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSString *Url = [NSString stringWithFormat:@"%@/v1/users/%@?token=%@",DNS,[regular getUID],[regular getToken]];
    NSDictionary *dict = @{@"avatar":key};
        [manager PUT:Url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {

            NSString *html = operation.responseString;
            NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
            if([[dict objectForKey:@"code"] integerValue]==1)
            {
//                [[ToolManager sharedManager] alertTitle_Simple:@"上传成功"];
                
                NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
                //将islogin存入defaults中
//                NSDictionary *_dict=[dict objectForKey:@"data"];
                NSString *imageurl=nil;
                if([defaults objectForKey:@"avatar"]==[NSNull null])
                {
                    imageurl=@"0";
                }else
                {
                    imageurl=[[NSString alloc] initWithFormat:@"http://7ximo7.com1.z0.glb.clouddn.com/%@",key];
                }
                NSString *_image_type=nil;
                NSString *_image_url=nil;
                if([imageurl isEqualToString:@"0"])
                {
                    //当用户还未上传头像时
                    //将系统默认的头像（成功登录并未上传头像）,转换成nsdata类型的对象，并将该对象保存defaults中
                    NSData *imageData1 =UIImagePNGRepresentation([UIImage imageNamed:@"headImg_login1"]);
                    //        UIImagePNGRepresentation[UIImage imageNamed:@"headImg_login1"];
                    [defaults setObject:imageData1 forKey:@"userImage"];
                    _image_type=@"0";
                    _image_url=@"headImg_login1";
                    

                }
                else
                {
                    //当用户有上传头像时
                    //创建头像的完整路径
                    //        NSString *myURL=[NSString stringWithFormat:@"http://121.40.153.17/api/Public/User/%@",imageurl];
                    //根据图片路径，下载图片，并保存defaults中（nsdata类型）
                    [defaults setObject:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageurl]]forKey:@"userImage"];
                    _image_type=@"1";
                    _image_url=imageurl;
                }
                [defaults setObject:[[NSDictionary alloc] initWithObjectsAndKeys:_image_type,@"type",_image_url,@"image",nil] forKey:@"userImageurl"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"updateImg" object:nil];

            }else
            {
                [[ToolManager sharedManager] alertTitle_Simple:[dict objectForKey:@"message"]];
            }

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
            JXLOG(@"失败");
        }];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picke
{
    [picke dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark --connectionDelegate
-(void)connection:(NSURLConnection*)connection didReceiveData:(NSData *)data{
    //NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    //self.ret.text=str;
    [_datas appendData:data];
    //[self.retstr appendString:str];
}
//数据传完之后调用此方法

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSDictionary *dict;
    NSString *str;
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:@"连接超时" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    dict=[NSJSONSerialization JSONObjectWithData:_datas options:NSJSONReadingAllowFragments error:nil];
    str=[dict objectForKey:@"state"];
    if([str isEqualToString:@"1"])
    {
        JXLOG(@"++++");
        NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
        if([regular isLogin])
        {
            LoginViewController *loginVC = [[LoginViewController alloc] init];
            UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:nil message:@"网络故障，请重新登录"  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertview show];
            NSNumber *islogin=[[NSNumber alloc]initWithInt:0];
            [defaults setObject:islogin forKey:@"islogin"];
            [defaults setObject:nil forKey:@"username"];
            [defaults setObject:nil forKey:@"password"];
            [defaults setObject:nil forKey:@"uid"];
            NSData *imageData1 = UIImageJPEGRepresentation([UIImage imageNamed:@"user_default.png"], 1.0);
            [defaults setObject:imageData1 forKey:@"userImage"];
            loginVC.type=@"userinfo";
            [self presentModalViewController:loginVC animated:YES];
        }
        else
        {
            UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:nil message:@"未登录" delegate:nil cancelButtonTitle:@"OK"  otherButtonTitles:nil];
            [alertview show];
        }
    }
    else if([str isEqualToString:@"2"])
    {
        alertView.message=@"图片过大";
        [alertView show];
    }
    else if([str isEqualToString:@"0"])
    {
        NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
        NSData *imageData1 = UIImageJPEGRepresentation(icon.image, 1.0);
        [defaults setObject:imageData1 forKey:@"userImage"];
        
        alertView.message=@"成功";
        [alertView show];

    }
}
//网络请求过程中，出现任何错误（断网，连接超时等）会进入此方法

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:@"连接超时" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}
#pragma mark --textfieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if(textField.tag-1000<3)
    {
        UITextField *text=(UITextField *)[self.view viewWithTag:(textField.tag+1)];
        [text becomeFirstResponder];

    }else if(textField.tag-1000==3)
    {
        [textField resignFirstResponder];
    }

    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    currentFeild = textField;
    return YES;
}



@end
