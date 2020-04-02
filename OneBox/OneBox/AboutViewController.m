//
//  AboutViewController.m
//  OneBox
//
//  Created by 谢江新 on 15/6/25.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import "AboutViewController.h"

// c文件 —> 系统文件（c文件在前）

// 控制器
#import "BindingEmailViewController.h"
#import "BingingAuthViewController.h"
#import "PersoninfoViewController.h"
#import "BindingViewController.h"
#import "ChangePswViewController.h"
#import "NotificationController.h"
#import "CustomTabbarController.h"
#import "PrivacyViewController.h"

// 自定义视图

// 接口

// 分类

// 自定义类和三方类（ cocoapods类 > model > 工具类 > 其他）

#import <objc/runtime.h>

static void *EOCAlertViewKey = "EOCAlertViewKey";

@interface AboutViewController ()<UIAlertViewDelegate>

@property (nonatomic, strong) UIButton *notBtn;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *upView;
@property (nonatomic, strong) UIButton *cleanBtn;

@end

@implementation AboutViewController

#pragma mark - --------------生命周期--------------
- (void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare];
    [self UIConfig];
    [self RequestData];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [MobClick endLogPageView:@"PrivacyViewController"];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [MobClick beginLogPageView:@"PrivacyViewController"];
    [[CustomTabbarController sharedManager] tabbarHide];
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nonotification) name:@"nonotification" object:nil];
}
- (void)PrepareUI {

    self.view.backgroundColor = _define_backview_color;

    self.navigationItem.titleView = [regular returnNavView:@" 设置" withmaxwidth:230];

    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回箭头"] style:UIBarButtonItemStylePlain target:self action:@selector(popviewAction)];
    self.navigationItem.leftBarButtonItem = backBtn;

    _notBtn = [UIButton getCustomBtn];
    _notBtn.frame = CGRectMake(0, 0, 22, 22);
    [_notBtn addTarget:self action:@selector(pushNotList) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_notBtn];

    [self updateNotBtnState];
}
#pragma mark - --------------UIConfig----------------------
- (void)UIConfig {
    [self createScrollView];
    [self createUpView];
    [self createPrivacyBtn];
    [self createVersionView];
}
-(void)createScrollView
{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight+kTabBarHeight)];
    [self.view addSubview:_scrollView];
    _scrollView.contentSize = CGSizeMake(CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame));
}
-(void)createUpView
{
    NSArray *titleArr = nil;
    CGRect upViewFrame;

    if([regular isAuth])
    {
        upViewFrame = CGRectMake(20*_Scale, 28*_Scale,  CGRectGetWidth(_scrollView.frame)-40*_Scale, 140*_Scale+70*_Scale*2);
        titleArr = @[@"账户资料"
                     ,@"推送通知"];
    }else
    {
        upViewFrame = CGRectMake(20*_Scale, 28*_Scale,  CGRectGetWidth(_scrollView.frame)-40*_Scale, 140*_Scale+70*_Scale*6);
        titleArr = @[@"账户资料"
                     ,@"修改密码"
                     ,@"修改邮箱"
                     ,@"修改手机"
                     ,@"三方绑定"
                     ,@"推送通知"];
    }

    _upView = [[UIView alloc] initWithFrame:upViewFrame];
    [_scrollView addSubview:_upView];
    _upView.backgroundColor = _define_white_color;

    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_upView.frame), 100*_Scale)];
    [_upView addSubview:imageview];
    imageview.image = [UIImage imageNamed:@"user_info_关于底图"];

    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(imageview.frame)-60*_Scale)/2.0f, (CGRectGetHeight(imageview.frame)-56*_Scale)/2.0f, 60*_Scale, 56*_Scale)];
    [imageview addSubview:icon];
    icon.image = [UIImage imageNamed:@"user_info_关于icon"];

    for (int i = 0; i < titleArr.count; i++) {
        UIButton *btn = [UIButton getCustomTitleBtnWithAlignment:0 WithFont:12.0 WithSpacing:0 WithNormalTitle:titleArr[i] WithNormalColor:[UIColor colorWithRed:174.0f/255.0f green:174.0f/255.0f blue:174.0f/255.0f alpha:1] WithSelectedTitle:nil WithSelectedColor:nil];
        [_upView addSubview:btn];
        btn.tag = 100+i;
        btn.frame = CGRectMake((CGRectGetWidth(_upView.frame)-320*_Scale)/2.0f, CGRectGetMaxY(imageview.frame)+ 23*_Scale+70*_Scale*i, 320*_Scale, 70*_Scale);
        [btn.titleLabel setAttributedText:[regular createAttributeString:titleArr[i] andFloat:@(10.0)]];
        [btn addTarget:self action:@selector(main_action:) forControlEvents:UIControlEventTouchUpInside];
    }

    UIButton *logoutBtn = [UIButton getCustomTitleBtnWithAlignment:0 WithFont:13.0f WithSpacing:0 WithNormalTitle:@"注  销" WithNormalColor:_define_white_color WithSelectedTitle:nil WithSelectedColor:nil];
    [_scrollView addSubview:logoutBtn];
    logoutBtn.frame = CGRectMake(20*_Scale, CGRectGetMaxY(_upView.frame)+55*_Scale, CGRectGetWidth(_scrollView.frame)-40*_Scale, 55*_Scale);
    logoutBtn.backgroundColor = [UIColor colorWithRed:242/255.0 green:107/255.0 blue:85/255.0 alpha:1.0];
    [logoutBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];

    _cleanBtn =  [UIButton getCustomTitleBtnWithAlignment:0 WithFont:13.0f WithSpacing:0 WithNormalTitle:@"清  除  缓  存" WithNormalColor:_define_white_color WithSelectedTitle:nil WithSelectedColor:nil];
    [_scrollView addSubview:_cleanBtn];
    _cleanBtn.frame = CGRectMake(20*_Scale, CGRectGetMaxY(logoutBtn.frame)+5, CGRectGetWidth(_scrollView.frame)-40*_Scale, 55*_Scale);
    _cleanBtn.backgroundColor = [UIColor colorWithRed:88.0f/255.0f green:194.0f/255.0f blue:191.0f/255.0f alpha:1];
    [_cleanBtn addTarget:self action:@selector(cleanCache:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)createPrivacyBtn
{
    for (int i = 0; i < 2; i++) {
        UIButton *btn = [UIButton getCustomTitleBtnWithAlignment:0 WithFont:11.0f WithSpacing:0 WithNormalTitle:i==0?@"隐私条款":@"使用声明" WithNormalColor:_define_blue_color WithSelectedTitle:nil WithSelectedColor:nil];
        [_scrollView addSubview:btn];
        btn.frame = CGRectMake((CGRectGetWidth(_scrollView.frame)/2.0f-200*_Scale)+200*_Scale*i, CGRectGetMaxY(_cleanBtn.frame)+50*_Scale, 200*_Scale, 50*_Scale);
        [btn.titleLabel setAttributedText:[regular createAttributeString:i==0?@"隐私条款":@"使用声明" andFloat:@(2.0)]];
        [btn addTarget:self action:@selector(yinsi:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 5000+i;
    }
}
-(void)createVersionView
{
    UIView *backview = [[UIView alloc] initWithFrame:CGRectMake((ScreenWidth-100*_Scale)/2, CGRectGetMaxY(_cleanBtn.frame)+80*_Scale+80*_Scale, 100*_Scale, 100*_Scale)];
    [_scrollView addSubview:backview];
    backview.backgroundColor = [UIColor clearColor];

    UIImageView *banbenimg = [[UIImageView alloc] initWithFrame:CGRectMake(25*_Scale, 0, 60*_Scale, 50*_Scale)];
    [backview addSubview:banbenimg];
    banbenimg.image = [UIImage imageNamed:@"版本_v1.0"];

    _scrollView.contentSize = CGSizeMake(CGRectGetWidth(_scrollView.frame), CGRectGetMaxY(backview.frame)+30*_Scale);
}
#pragma mark - --------------请求数据----------------------
- (void)RequestData {

}

#pragma mark - --------------系统代理----------------------


#pragma mark - --------------自定义代理/block----------------------


#pragma mark - --------------自定义响应----------------------
-(void)nonotification
{
    [self updateNotBtnState];
}
-(void)updateNotBtnState{
    if(_notBtn){
        NSString *imagename = nil;
        if([[NSUserDefaults standardUserDefaults] objectForKey:@"no_read_pm_count"] != nil)
        {
            if([[[NSUserDefaults standardUserDefaults] objectForKey:@"no_read_pm_count"] integerValue] > 0)
            {
                imagename = @"notification_info";

            }else
            {
                imagename = @"notification_noinfo";
            }
        }else
        {
            imagename = @"notification_noinfo";
        }
        [_notBtn setBackgroundImage:[UIImage imageNamed:imagename] forState:UIControlStateNormal];
    }
}
-(void)yinsi:(UIButton *)btn
{
    PrivacyViewController *about = [[PrivacyViewController alloc] init];
    if(btn.tag == 5000)
    {
        about.type = @"privacy";
    }else
    {
        about.type = @"help";
    }
    [self.navigationController pushViewController:about animated:YES];
}
- (void)backBtn:(UIButton *)sender {

    EMError *error = nil;
    NSDictionary *info = [[EaseMob sharedInstance].chatManager logoffWithUnbindDeviceToken:YES error:&error];
    if (!error && info) {
        JXLOG(@"退出成功");
    }
    NSDictionary *parameters = @{@"token":[regular getToken]};
    NSString *url = [[NSString alloc] initWithFormat:@"%@%@",DNS,@"/v1/users/login_out"];
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        JXLOG(@"111");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        JXLOG(@"222");
    }];

    NSNumber *islogin = [[NSNumber alloc] initWithInt:0];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

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

    [self.navigationController popToRootViewControllerAnimated:YES];

}
- (void)cleanCache:(UIButton *)btn {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *path = [paths lastObject];
    ;

    UIAlertView *alertviewclean = [[UIAlertView alloc] initWithTitle:@"提示" message:[[NSString alloc] initWithFormat:@"缓存大小为%.2fM,确定清除缓存吗？",[self folderSizeAtPath:path]] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertviewclean.delegate = self;
    void (^alerViewBlock)(NSInteger) = ^(NSInteger buttonIndex){
        if(buttonIndex == 1)
        {
            [self cleanCacheAction];
        }
    };
    objc_setAssociatedObject(alertviewclean, EOCAlertViewKey, alerViewBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [alertviewclean show];

}
-(void)cleanCacheAction
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
        NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
        JXLOG(@"files :%lu",(unsigned long)[files count]);

        for (NSString *p in files) {
            NSError *error;
            NSString *path = [cachPath stringByAppendingPathComponent:p];
            if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
            }
        }

        [self performSelectorOnMainThread:@selector(clearCacheSuccess) withObject:nil waitUntilDone:YES];
    });

}
-(void)clearCacheSuccess{
    JXLOG(@"清理成功");
}
-(void)main_action:(UIButton *)btn
{
    if([regular isAuth])
    {
        if(btn.tag - 100 == 0)
        {
            //账户资料
            [self.navigationController pushViewController:[PersoninfoViewController new] animated:YES];

        }else if(btn.tag - 100 == 1)
        {
            //推送通知
            UIAlertView *alertviewPush = [[UIAlertView alloc] initWithTitle:@"" message:@"开启或者关闭推送通知，请在iPhone的""设置""-""通知""中进行设置" delegate:self cancelButtonTitle:@"好" otherButtonTitles: nil];
            alertviewPush.delegate = self;
            void (^alertViewBlock)(NSInteger) = ^(NSInteger buttonIndex){
                [regular pushSystem];
            };
            objc_setAssociatedObject(alertviewPush, EOCAlertViewKey, alertViewBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
            [alertviewPush show];
        }
    }else
    {
        if(btn.tag - 100 == 0)
        {
            //账户资料
            [self.navigationController pushViewController:[PersoninfoViewController new] animated:YES];

        }else if(btn.tag - 100 == 1)
        {
            //修改密码
            [self.navigationController pushViewController:[ChangePswViewController new] animated:YES];

        }else if(btn.tag - 100 == 2)
        {
            //修改邮箱
            [self.navigationController pushViewController:[BindingEmailViewController new] animated:YES];

        }else if(btn.tag - 100 == 3)
        {
            //修改手机
            [self.navigationController pushViewController:[[BindingViewController alloc] init] animated:YES];

        }else if(btn.tag - 100 == 4)
        {
            //三方绑定
            [self.navigationController pushViewController:[BingingAuthViewController new] animated:YES];

        }else if(btn.tag - 100 == 5)
        {
            //推送通知
            UIAlertView *alertviewPush = [[UIAlertView alloc] initWithTitle:@"" message:@"开启或者关闭推送通知，请在iPhone的""设置""-""通知""中进行设置" delegate:self cancelButtonTitle:@"好" otherButtonTitles: nil];
            alertviewPush.delegate = self;
            void (^alertViewBlock)(NSInteger) = ^(NSInteger buttonIndex){
                [regular pushSystem];
            };
            objc_setAssociatedObject(alertviewPush, EOCAlertViewKey, alertViewBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
            [alertviewPush show];

        }
    }
}
-(void)pushNotList
{
    NotificationController *not = [[NotificationController alloc] init];
    [self.navigationController pushViewController:not animated:YES];
}
-(void)popviewAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - --------------自定义方法----------------------
- (float)folderSizeAtPath:(NSString *)folderPath {
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]){
        return 0;
    }
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString *fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}
- (long long)fileSizeAtPath:(NSString *)filePath{
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

#pragma mark - --------------other----------------------

@end
