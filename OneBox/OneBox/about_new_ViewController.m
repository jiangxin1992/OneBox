//
//  about_new_ViewController.m
//  OneBox
//
//  Created by 谢江新 on 15/6/25.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BindingEmailViewController.h"
#import "BingingAuthViewController.h"
#import "personinfoViewController.h"
#import "BindingViewController.h"
#import "ChangePswViewController.h"
#import "NotificationController.h"

#import "AboutViewController.h"
#import "about_new_ViewController.h"

@interface about_new_ViewController ()<UIAlertViewDelegate>

@end

@implementation about_new_ViewController
{
    UIAlertView *alertviewPush;
    UIAlertView *alertviewclean;
    UIButton *notbtn;
    UISwitch *_switch;
    UITextView *sugession_content;
    NSInteger is_push_on;
    UIScrollView *_scrollView;
    UIView *upView;
    UIButton *clean_btn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareData];
    [self UIConfig];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nonotification) name:@"nonotification" object:nil];
}
#pragma mark-设定是否有未读消息
-(void)nonotification
{
    NSString *imagename=nil;
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"no_read_pm_count"]!=nil)
    {
        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"no_read_pm_count"] integerValue]>0)
        {
            imagename=@"notification_info";

        }else
        {
            imagename=@"notification_noinfo";
        }
    }else
    {
       imagename=@"notification_noinfo";
    }
    [notbtn setBackgroundImage:[UIImage imageNamed:imagename] forState:UIControlStateNormal];

}
-(void)UIConfig
{
    [self createScrollView];
    [self crateUpView];



    UIButton *loginout_btn=[UIButton buttonWithType:UIButtonTypeCustom];
    loginout_btn.frame=CGRectMake(20*_Scale, CGRectGetMaxY(upView.frame)+55*_Scale, CGRectGetWidth(_scrollView.frame)-40*_Scale, 55*_Scale);
    loginout_btn.backgroundColor=[UIColor colorWithRed:242/255.0 green:107/255.0 blue:85/255.0 alpha:1.0];
    [loginout_btn setTitle:@"注  销" forState:UIControlStateNormal];
    [loginout_btn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    loginout_btn.titleLabel.font =[regular getFont:13.0f];


    [_scrollView addSubview:loginout_btn];

    clean_btn=[UIButton buttonWithType:UIButtonTypeCustom];
    clean_btn.frame=CGRectMake(20*_Scale, CGRectGetMaxY(loginout_btn.frame)+5, CGRectGetWidth(_scrollView.frame)-40*_Scale, 55*_Scale);

    [clean_btn setBackgroundColor:[UIColor colorWithRed:88.0f/255.0f green:194.0f/255.0f blue:191.0f/255.0f alpha:1]];
    [clean_btn setTitle:@"清  除  缓  存" forState:UIControlStateNormal];
    [clean_btn addTarget:self action:@selector(cleanCache:) forControlEvents:UIControlEventTouchUpInside];
    clean_btn.titleLabel.font =[regular getFont:13.0f];


    [_scrollView addSubview:clean_btn];

    [self createyinsiBtn];

    [self banben_view];
}
-(void)createyinsiBtn
{
    for (int i=0; i<2; i++) {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        [_scrollView addSubview:btn];
        btn.frame=CGRectMake((CGRectGetWidth(_scrollView.frame)/2.0f-200*_Scale)+200*_Scale*i, CGRectGetMaxY(clean_btn.frame)+50*_Scale, 200*_Scale, 50*_Scale);

        [btn setTitle:i==0?@"隐私条款":@"使用声明" forState:UIControlStateNormal];
        [btn setTitleColor:_define_blue_color forState:UIControlStateNormal];
        [btn.titleLabel setAttributedText:[regular createAttributeString:i==0?@"隐私条款":@"使用声明" andFloat:@(2.0)]];
        btn.titleLabel.font=[regular getFont:11.0f];

        [btn addTarget:self action:@selector(yinsi:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag=5000+i;

    }

}
-(void)yinsi:(UIButton *)btn
{

    if(btn.tag==5000)
    {
        AboutViewController *about=[[AboutViewController alloc] init];
        about.type=@"privacy";
        [self.navigationController pushViewController:about animated:YES];

    }else
    {
        AboutViewController *about=[[AboutViewController alloc] init];
        about.type=@"help";
        [self.navigationController pushViewController:about animated:YES];

    }
}

-(void)switchAction:(UISwitch *)__switch
{

    NSString *not=nil;
    if(__switch.on)
    {
//        _switch.on=NO;
        not=@"1";
    }else
    {
//        _switch.on=YES;
        not=@"0";
    }

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    NSString *url=[[NSString alloc] initWithFormat:@"%@/v1/user_boxes/is_push?is_push_on=%@&token=%@",DNS,not,[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]];
    [manager PUT:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)  {
        NSString *html = operation.responseString;
        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];

        if([[dict objectForKey:@"code"] integerValue]==1)
        {

        }else
        {

            [[ToolManager sharedManager] alertTitle_Simple:[dict objectForKey:@"message"]];


        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
    }];


}
- (BOOL)isAllowedNotification {
    //iOS8 check if user allow notification
    double version = [[UIDevice currentDevice].systemVersion doubleValue];//判定系统版本。

    if (version>=8.0f) {// system is iOS8
        #if version<8

        UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if (UIUserNotificationTypeNone != setting.types) {
            return YES;
        }
        #endif
    } else {//iOS7
        UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        if(UIRemoteNotificationTypeNone != type)
            return YES;
    }

    return NO;
}
-(void)banben_view
{
    UIView *backview=[[UIView alloc] initWithFrame:CGRectMake((ScreenWidth-100*_Scale)/2, CGRectGetMaxY(clean_btn.frame)+80*_Scale+80*_Scale, 100*_Scale, 100*_Scale)];
    backview.backgroundColor=[UIColor clearColor];
    [_scrollView addSubview:backview];
    UIImageView *banbenimg=[[UIImageView alloc] initWithFrame:CGRectMake(25*_Scale, 0, 60*_Scale, 50*_Scale)];
    banbenimg.image=[UIImage imageNamed:@"版本_v1.0"];
    [backview addSubview:banbenimg];

    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(banbenimg.frame), CGRectGetWidth(backview.frame), CGRectGetHeight(backview.frame)-CGRectGetMaxY(banbenimg.frame))];
    label.textAlignment=1;

//    label.text=@"V 1.4";
    label.textColor=[UIColor colorWithRed:193.0f/255.0f green:193.0f/255.0f blue:193.0f/255.0f alpha:1];

    label.font=[regular get_en_Font:11.0f];;
    [backview addSubview:label];
    _scrollView.contentSize=CGSizeMake(CGRectGetWidth(_scrollView.frame), CGRectGetMaxY(backview.frame)+30*_Scale);
    
}
- (void)backBtn:(UIButton *)sender {

    EMError *error = nil;
    NSDictionary *info = [[EaseMob sharedInstance].chatManager logoffWithUnbindDeviceToken:YES error:&error];
    if (!error && info) {
        NSLog(@"退出成功");
    }
    NSDictionary *parameters=@{@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]};
    NSString *url=[[NSString alloc] initWithFormat:@"%@%@",DNS,@"/v1/users/login_out"];
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSLog(@"111");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"222");
    }];


    NSNumber *islogin=[[NSNumber alloc]initWithInt:0];
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];

    [defaults setObject:[NSNumber numberWithInteger:0] forKey:@"no_read_pm_count"];
    [defaults setObject:nil forKey:@"ease_mob_username"];
    [defaults setObject:nil forKey:@"ease_mob_password"];
    [defaults setObject:islogin forKey:@"islogin"];
    [defaults setObject:nil forKey:@"username"];
    [defaults setObject:nil forKey:@"password"];
    [defaults setObject:nil forKey:@"uid"];
    [defaults setObject:nil forKey:@"userImage"];
    [defaults setObject:nil forKey:@"token"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"loginout" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reload" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"backloginout" object:nil];
     [[NSNotificationCenter defaultCenter]postNotificationName:@"nonotification" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"getmessage" object:nil];

    [regular removeProgress];

    [self.navigationController popToRootViewControllerAnimated:YES];

}
- (void)cleanCache:(UIButton *)btn {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *path = [paths lastObject];
    ;



    alertviewclean=[[UIAlertView alloc] initWithTitle:@"提示" message:[[NSString alloc] initWithFormat:@"缓存大小为%.2fM,确定清除缓存吗？",[self folderSizeAtPath:path]] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertviewclean.delegate=self;
    [alertviewclean show];

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView==alertviewclean)
    {
        if(buttonIndex==1)
        {
            [self cleanCacheAction];
        }
    }else if(alertView==alertviewPush)
    {

        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]])
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
    }


}
-(void)cleanCacheAction
{

    dispatch_async(

                   dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                   , ^{

                       NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];



                       NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];

                       NSLog(@"files :%lu",(unsigned long)[files count]);

                       for (NSString *p in files) {

                           NSError *error;

                           NSString *path = [cachPath stringByAppendingPathComponent:p];

                           if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {

                               [[NSFileManager defaultManager] removeItemAtPath:path error:&error];

                           }
                           
                       }
                       
                       [self performSelectorOnMainThread:@selector(clearCacheSuccess) withObject:nil waitUntilDone:YES];});
    
}
-(void)clearCacheSuccess

{
    
    NSLog(@"清理成功");
    
}


-(float)folderSizeAtPath:(NSString*)folderPath
    {
        NSFileManager* manager = [NSFileManager defaultManager];
        if (![manager fileExistsAtPath:folderPath]) return 0;
        NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
        NSString* fileName;
        long long folderSize = 0;
        while ((fileName = [childFilesEnumerator nextObject]) != nil){
            NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
            folderSize += [self fileSizeAtPath:fileAbsolutePath];
        }
        return folderSize/(1024.0*1024.0);
    }
- (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}
-(void)crateUpView
{

    upView =[[UIView alloc] init];
//@[@"账户资料",@"修改密码",@"手机绑定",@"推送通知"]
    NSArray *titleArr=nil;
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"is_auth"] integerValue]==1)
    {
        upView.frame=CGRectMake(20*_Scale, 28*_Scale,  CGRectGetWidth(_scrollView.frame)-40*_Scale, 140*_Scale+70*_Scale*2);
        titleArr=@[@"账户资料",@"推送通知"];
    }else
    {
        upView.frame=CGRectMake(20*_Scale, 28*_Scale,  CGRectGetWidth(_scrollView.frame)-40*_Scale, 140*_Scale+70*_Scale*6);
        titleArr=@[@"账户资料",@"修改密码",@"修改邮箱",@"修改手机",@"三方绑定",@"推送通知"];
    }

    upView.backgroundColor=[UIColor whiteColor];
    [_scrollView addSubview:upView];
    UIImageView *imageview=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(upView.frame), 100*_Scale)];
    imageview.image=[UIImage imageNamed:@"user_info_关于底图"];
    imageview.backgroundColor=[UIColor redColor];
    [upView addSubview:imageview];
//    h 28 h 46   54 42
    UIImageView *icon=[[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(imageview.frame)-60*_Scale)/2.0f, (CGRectGetHeight(imageview.frame)-56*_Scale)/2.0f, 60*_Scale, 56*_Scale)];
    icon.image=[UIImage imageNamed:@"user_info_关于icon"];
    [imageview addSubview:icon];


//    i 23 h 62 w 320
    for (int i=0; i<titleArr.count; i++) {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake((CGRectGetWidth(upView.frame)-320*_Scale)/2.0f, CGRectGetMaxY(imageview.frame)+ 23*_Scale+70*_Scale*i, 320*_Scale, 70*_Scale);
        [upView addSubview:btn];

        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        [btn.titleLabel setAttributedText:[regular createAttributeString:titleArr[i] andFloat:@(10.0)]];
        [btn setTitleColor:[UIColor colorWithRed:174.0f/255.0f green:174.0f/255.0f blue:174.0f/255.0f alpha:1] forState:UIControlStateNormal];
        btn.titleLabel.font=[regular getFont:12.0];


        btn.tag=100+i;

        [btn addTarget:self action:@selector(main_action:) forControlEvents:UIControlEventTouchUpInside];

    }

}
//-(void)tuisong
//{
//
//
//
//        [[ToolManager sharedManager] alertTitle_Simple:@"开启或者关闭推送通知，请在iPhone的""设置""-""通知""中进行设置"];
//
//
//}
-(void)dismiss_back:(UIGestureRecognizer *)ges
{
    [[self.view viewWithTag:200] removeFromSuperview];
}

#pragma mark-提交建议按钮
-(void)submitAction:(UIGestureRecognizer *)ges
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *Url = [NSString stringWithFormat:@"%@/v1/reports?token=%@",DNS,[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]];
    NSDictionary *dict = @{@"content":sugession_content.text};
    [manager POST:Url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [[self.view viewWithTag:200] removeFromSuperview];
        sugession_content.text = @"";
        [[ToolManager sharedManager] alertTitle_Simple:@"提交成功"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
    }];

}

-(void)main_action:(UIButton *)btn
{
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"is_auth"] integerValue]==1)
    {
        if(btn.tag-100==0)
        {
#pragma mark-账户资料
            //        AboutViewController *about=[[AboutViewController alloc] init];
            //        about.type=@"about_us";
            //        [self.navigationController pushViewController:about animated:YES];
            [self.navigationController pushViewController:[personinfoViewController new] animated:YES];
            
            
        }else if(btn.tag-100==1)
        {
#pragma mark-推送通知
            alertviewPush=[[UIAlertView alloc] initWithTitle:@"" message:@"开启或者关闭推送通知，请在iPhone的""设置""-""通知""中进行设置" delegate:self cancelButtonTitle:@"好" otherButtonTitles: nil];
            alertviewPush.delegate=self;
            [alertviewPush show];
            //        [self.navigationController pushViewController:[pushViewController new] animated:YES];
            
        }

    }else
    {
        if(btn.tag-100==0)
        {
#pragma mark-账户资料
            //        AboutViewController *about=[[AboutViewController alloc] init];
            //        about.type=@"about_us";
            //        [self.navigationController pushViewController:about animated:YES];
            [self.navigationController pushViewController:[personinfoViewController new] animated:YES];
            
            
        }else if(btn.tag-100==1)
        {
#pragma mark-修改密码

            //        AboutViewController *about=[[AboutViewController alloc] init];
            //        about.type=@"privacy";
            //        [self.navigationController pushViewController:about animated:YES];
            [self.navigationController pushViewController:[ChangePswViewController new] animated:YES];
        }else if(btn.tag-100==2)
        {
#pragma mark-修改邮箱
            [self.navigationController pushViewController:[BindingEmailViewController new] animated:YES];

        }else if(btn.tag-100==3)
        {
#pragma mark-修改手机
            [self.navigationController pushViewController:[[BindingViewController alloc] init] animated:YES];

        }else if(btn.tag-100==4)
        {
#pragma mark-三方绑定
            [self.navigationController pushViewController:[BingingAuthViewController new] animated:YES];

        }else if(btn.tag-100==5)
        {
#pragma mark-推送通知

            alertviewPush=[[UIAlertView alloc] initWithTitle:@"" message:@"开启或者关闭推送通知，请在iPhone的""设置""-""通知""中进行设置" delegate:self cancelButtonTitle:@"好" otherButtonTitles: nil];
            alertviewPush.delegate=self;
            [alertviewPush show];

        }

    }

}
-(void)createScrollView
{
    _scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight+kTabBarHeight)];
    _scrollView.contentSize=CGSizeMake(CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame));
    [self.view addSubview:_scrollView];
}
-(void)prepareData
{
    is_push_on=0;
    UIBarButtonItem *_btn=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回箭头"] style:UIBarButtonItemStylePlain target:self action:@selector(popviewAction)];
    self.navigationItem.leftBarButtonItem=_btn;
    self.navigationItem.titleView=[regular returnNavView:@" 设置" withmaxwidth:230];
    self.view.backgroundColor=_define_backview_color;
    NSString *imagename=nil;
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"no_read_pm_count"]!=nil)
    {
        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"no_read_pm_count"] integerValue]>0)
        {
            imagename=@"notification_info";

        }else
        {
            imagename=@"notification_noinfo";
        }
    }else
    {
        imagename=@"notification_noinfo";
    }
    notbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    notbtn.frame=CGRectMake(0, 0, 22, 22);
    [notbtn setBackgroundImage:[UIImage imageNamed:imagename] forState:UIControlStateNormal];
    [notbtn addTarget:self action:@selector(pushNotList) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *_right_btn=[[UIBarButtonItem alloc] initWithCustomView:notbtn];
    self.navigationItem.rightBarButtonItem=_right_btn;
    
}
-(void)pushNotList
{
    NotificationController *not=[[NotificationController alloc] init];
    [self.navigationController pushViewController:not animated:YES];
}
-(void)popviewAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"aboutViewController"];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"aboutViewController"];

    [[CustomTabbarController sharedManager] tabbarHide];
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
