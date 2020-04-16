//
//  CustomTabbarController.m
//  OneBox
//
//  Created by 谢江新 on 15-2-2.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//
#import "CustomTabbarController.h"

#import "UserInfoViewController.h"
#import "ArticleViewController.h"
#import "FoundViewController.h"
#import "BoxViewController.h"
#import "MapViewController.h"
#import "TabbarItem.h"

@interface CustomTabbarController ()<UITabBarControllerDelegate>
{
//    自定义的标签栏
    UIImageView *_tabbar;
    NSMutableArray *btnarr;
    UIImageView *_unreadview1;
}
@end

@implementation CustomTabbarController

static CustomTabbarController *tabbarController = nil;
+(id)sharedManager
{
//    创建CustomTabbarController的单例，并通过此方法调用
//    互斥锁，确保单例只能被创建一次
    @synchronized(self)
        {

            if (!tabbarController) {
                tabbarController = [[CustomTabbarController alloc]init];
            }
    }
    return tabbarController;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    //    遍历标签栏子视图，使他们为normal状态
    for (UIButton *b in _tabbar.subviews) {

        b.selected = NO;
    }
    //    将点击的item变为select状态
    JXLOG(@"%lu",(unsigned long)self.selectedIndex);
    ((TabbarItem*)btnarr[self.selectedIndex]).selected=YES;
    
}
-(void)selectItem1
{
    //    遍历标签栏子视图，使他们为normal状态
    for (UIButton *b in _tabbar.subviews) {

        b.selected = NO;
    }

    TabbarItem *btn1=(TabbarItem *)[_tabbar viewWithTag:101];
    //    将点击的item变为select状态
    //    btn1.selected = YES;
    btn1.selected = YES;
    //    切换到点击item相对应的视图
    self.selectedIndex = 1;
}
- (void)viewDidLoad {

    [super viewDidLoad];
    btnarr=[[NSMutableArray alloc] init];
    self.delegate=self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectItem1) name:@"selectmap" object:nil];
    if([regular isLogin])
    {
        NSString *isnot=nil;
        if ([self isAllowedNotification]) {

            isnot=@"1";
        }else
        {
            isnot=@"0";

        }
        NSString *url=[[NSString alloc] initWithFormat:@"%@/v1/user_boxes/is_push?is_push_on=%@&token=%@",DNS,isnot,[regular getToken]];

        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager PUT:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)  {
            NSString *html = operation.responseString;
            NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];

            if([[dict objectForKey:@"code"] integerValue]==1)
            {

            }else
            {
                //            [[ToolManager sharedManager] alertTitle_Simple:[dict objectForKey:@"message"]];
            }

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

            [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
        }];
    }

    //1.隐藏系统自带的标签栏
    self.tabBar.hidden = YES;

    //2.添加一个自定义的view
    [self createTabbar];
    
    //3.添加按钮(标签)
    [self createTabbarItem];
    
    //4.设置视图控制器数组
    [self createViewControllers];

    [self getunreadnum];


    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getnotification) name:@"getnotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nonotification) name:@"nonotification" object:nil];
}
-(void)getnotification
{
    [self getunreadnum];
}
#pragma mark-设定是否有未读消息
-(void)nonotification
{
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"no_read_pm_count"]!=nil)
    {
        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"no_read_pm_count"] integerValue]>0)
        {
            _unreadview1.hidden=NO;

        }else
        {
            _unreadview1.hidden=YES;
        }
    }else
    {
        _unreadview1.hidden=YES;
    }
}
-(void)getunreadnum
{
    if([regular isLogin])
    {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSDictionary *parameters=[[NSDictionary alloc] initWithObjectsAndKeys:[regular getToken],@"token",nil];
        [manager GET:[[NSString alloc] initWithFormat:@"%@/v1/push_messages/no_read_pm_count",DNS] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *html = operation.responseString;
            NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
            if([[dict objectForKey:@"code"] integerValue]==1)
            {

                if([[[dict objectForKey:@"data"] objectForKey:@"no_read_pm_count"] integerValue]>0)
                {

                    NSNumber *num=[NSNumber numberWithInteger:[[[dict objectForKey:@"data"] objectForKey:@"no_read_pm_count"] integerValue]];
                    [[NSUserDefaults standardUserDefaults] setObject:num forKey:@"no_read_pm_count"];

                }else
                {
                    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:0] forKey:@"no_read_pm_count"];
                }
                [[NSNotificationCenter defaultCenter]postNotificationName:@"nonotification" object:nil];
            }else
            {
                
                 [[ToolManager sharedManager] alertTitle_Simple:[dict objectForKey:@"message"]];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
        }];
    }

}

-(void)createViewControllers
{
    //     创建数组并初始化
    NSMutableArray *vcs = [[NSMutableArray alloc]init];
    for (int i = 0; i<5; i++) {
        //        三目运算创建视图
        UIViewController *vc =i==0?[[ArticleViewController alloc] init]:i==1?[[MapViewController alloc] init]:i==2?[[BoxViewController alloc] init]:i==3?[[FoundViewController alloc]init]:[[UserInfoViewController alloc] init];
        //        将创建视图加入到navi中

        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:vc];
        [vcs addObject:navi];
        
    }
    //    将数组中的视图添加到当前的tabbarController中去
    self.viewControllers = vcs;
    self.selectedIndex=2;
    
}
-(void)createTabbarItem
{
    //    创建存放视图标题的数组
    //    NSArray *titleArr = @[@"地 图",@"",@"发 现"];
    //    创建tabbarItem  normal情况下的显示图片

    NSArray *imageArr = @[
                          @"found_activity_文章_select1"
                          ,@"found_activity_map_select1"
                          ,@"found_activity_盒子_select1"
                          ,@"found_activity_发现_select1"
                          ,@"found_activity_user_select1"
                          ];
    //    创建tabbarItem  select情况下的显示图片
    NSArray *imageSelectArr = @[
                                @"found_activity_文章_normal1"
                                ,@"found_activity_map_normal1"
                                ,@"found_activity_盒子_normal1"
                                ,@"found_activity_发现_normal1"
                                ,@"found_activity_user_normal1"
                                ];
    //计算当前屏幕尺寸下tabbarItem的宽度
    CGFloat buttonWidth =ScreenWidth/5;
    for (int i = 0; i<imageArr.count; i++) {
        TabbarItem *item = [TabbarItem buttonWithType:UIButtonTypeCustom];
        if(i==1)
        {
            item.type=15;
        }else if(i==2)
        {
            //            当当前TabbarItem为中间的box时，设置type为1（为了区分box和其他TabbarItem，进行不同的定制）
            item.type=1;
        }else if(i==0)
        {
            item.type=0;
        }else if(i==3)
        {
            item.type=5;
        }else if(i==4)
        {
            _unreadview1=[[UIImageView alloc] initWithFrame:CGRectMake(buttonWidth-26, 13, 7, 7)];
            [item addSubview:_unreadview1];
            _unreadview1.layer.masksToBounds=YES;
            _unreadview1.layer.cornerRadius=CGRectGetWidth(_unreadview1.frame)/2.0f;

            _unreadview1.backgroundColor=[UIColor redColor];
            if([[NSUserDefaults standardUserDefaults] objectForKey:@"no_read_pm_count"]!=nil)
            {
                if([[[NSUserDefaults standardUserDefaults] objectForKey:@"no_read_pm_count"] integerValue]>0)
                {
                    _unreadview1.hidden=NO;

                }else
                {
                    _unreadview1.hidden=YES;
                }
            }else
            {
                _unreadview1.hidden=YES;
            }
            item.type=12;
        }
        item.frame = CGRectMake(buttonWidth*i, 0, buttonWidth, kInteractionHeight);
        //item.backgroundColor=[UIColor redColor];
        //        设置item的frame，标题，normal和select的图片


        //        [item setTitle:titleArr[i] forState:UIControlStateNormal];
        [item setImage:[UIImage imageNamed:imageArr[i]] forState:UIControlStateNormal];
        [item setImage:[UIImage imageNamed:imageSelectArr[i]] forState:UIControlStateSelected];
        //        item.titleLabel.font=[regular get_en_Font:9.5f];

        //锁定第一个视图为默认出现页面
        if (i == 3) {
            item.selected = YES;
        }
        //        添加标签
        item.tag = 100 + i;
        //        添加select响应事件
        [item addTarget:self action:@selector(selectItem:) forControlEvents:UIControlEventTouchUpInside];
        //        再自定义标签栏中加入item
        [_tabbar addSubview:item];
        if(btnarr!=nil)
        {
            [btnarr addObject:item];
        }
    }
    
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
-(void)selectItem:(UIButton *)btn
{
//    遍历标签栏子视图，使他们为normal状态
    for (UIButton *b in _tabbar.subviews) {
        
        b.selected = NO;
    }
//    将点击的item变为select状态
    btn.selected = YES;
//    切换到点击item相对应的视图
    self.selectedIndex = btn.tag - 100;
}

-(void)createTabbar
{
//     对_tabbar进行初始化，并进行ui布局
    _tabbar = [[UIImageView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:_tabbar];
    _tabbar.image = [UIImage imageNamed:@"found_activity_菜单栏"];
    _tabbar.userInteractionEnabled = YES;
    [_tabbar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.view).with.offset(0);
        make.height.mas_equalTo(IsPhone6_gt?(kTabBarHeight+16):kTabBarHeight);
    }];
}
-(void)tabbarAppear
{
    _tabbar.hidden=NO;
}
-(void)tabbarHide
{
    _tabbar.hidden=YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}


@end
