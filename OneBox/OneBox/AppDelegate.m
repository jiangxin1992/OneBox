//
//  AppDelegate.m
//  OneBox
//
//  Created by 谢江新 on 15-2-2.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//
//
//                            _ooOoo_
//                           o8888888o
//                           88" . "88
//                           (| -_- |)
//                            O\ = /O
//                        ____/`---'\____
//                      .   ' \\| |// `.
//                       / \\||| : |||// \
//                     / _||||| -:- |||||- \
//                       | | \\\ - /// | |
//                     | \_| ''\---/'' | |
//                      \ .-\__ `-` ___/-. /
//                   ___`. .' /--.--\ `. . __
//                ."" '< `.___\_<|>_/___.' >'"".
//               | | : `- \`.;`\ _ /`;.`/ - ` : | |
//                 \ \ `-. \_ __\ /__ _/ .-` / /
//         ======`-.____`-.___\_____/___.-`____.-'======
//                            `=---='
//
//         .............................................
//                  佛祖镇楼                  BUG辟易
//          佛曰:
//                  写字楼里写字间，写字间里程序员；
//                  程序人员写程序，又拿程序换酒钱。
//                  酒醒只在网上坐，酒醉还来网下眠；
//                  酒醉酒醒日复日，网上网下年复年。
//                  但愿老死电脑间，不愿鞠躬老板前；
//                  奔驰宝马贵者趣，公交自行程序员。
//                  别人笑我忒疯癫，我笑自己命太贱；
//                  不见满街漂亮妹，哪个归得程序员？

#import "AppDelegate.h"

#import <UserNotifications/UserNotifications.h>

#import <AlipaySDK/AlipaySDK.h>

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

//微信SDK头文件
#import "WXApi.h"

//新浪微博SDK头文件
#import "WeiboSDK.h"
//新浪微博SDK需要在项目Build Settings中的Other Linker Flags添加"-ObjC"

#import "EaseMob.h"
#import "CustomTabbarController.h"

#import "MYIntroductionPanel.h"
#import "MYIntroductionView.h"

#define kGtAppId           @"aLuGPVna2MAoAVtfbB66a3"
#define kGtAppKey          @"6yfaRLwDyZ8PDrfpkFULe"
#define kGtAppSecret       @"HpDuxiSFdmA4GJfHwq3u74"

#define NotifyActionKey "NotifyAction"
NSString* const NotificationCategoryIdent  = @"ACTIONABLE";
NSString* const NotificationActionOneIdent = @"ACTION_ONE";
NSString* const NotificationActionTwoIdent = @"ACTION_TWO";

@interface AppDelegate ()<UIScrollViewDelegate,MYIntroductionDelegate,UNUserNotificationCenterDelegate>

@property (strong, nonatomic) CustomTabbarController *viewController;

@property (retain, nonatomic) NSString *appKey;
@property (retain, nonatomic) NSString *appSecret;
@property (retain, nonatomic) NSString *appID;
@property (retain, nonatomic) NSString *clientId;

@property (assign, nonatomic) int lastPayloadIndex;
@property (retain, nonatomic) NSString *payloadId;

@end

@implementation AppDelegate
{
    BOOL isOut;
    NSString *_deviceToken;
}
#pragma mark - 生命周期
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [UITableView appearance].estimatedRowHeight = 0;
    [UITableView appearance].estimatedSectionHeaderHeight = 0;
    [UITableView appearance].estimatedSectionFooterHeight = 0;
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];

    // 友盟统计,在环信sdk中被引用
    [MobClick startWithAppkey:@"56245bf667e58e115b002eb0" reportPolicy:BATCH channelId:@""];

    // 通过个推平台分配的appId、 appKey 、appSecret 启动SDK，注：该方法需要在主线程中调用
    [GeTuiSdk startSdkWithAppId:kGtAppId appKey:kGtAppKey appSecret:kGtAppSecret delegate:self];
    // 注册 APNs
    [self registerRemoteNotification];

    // 启动环信sdk
    [[EaseMob sharedInstance] registerSDKWithAppKey:@"onebox2015#abroadboxios" apnsCertName:@"onebox_push"];
    [[EaseMob sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];

    //先判断是否开启自动登录，如果没有开启，则调用登录方法，并在登录成功后开启自动登录的开关

    //    自动登录在以下几种情况下会被取消

    //   1. 用户调用了SDK的登出动作;
    //   2. 用户在别的设备上更改了密码, 导致此设备上自动登陆失败;
    //   3. 用户的账号被从服务器端删除;
    //   4. 用户从另一个设备登录，把当前设备上登陆的用户踢出.

    //@"ease_mob_username"] password:[[dict objectForKey:@"data"] objectForKey:@"ease_mob_password"
    
    if((![NSString isNilOrEmpty:[regular getEaseMobUsername]])&&(![NSString isNilOrEmpty:[regular getEaseMobPassword]]))
    {
        BOOL isAutoLogin = [[EaseMob sharedInstance].chatManager isAutoLoginEnabled];
        if (!isAutoLogin) {
            
            [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:[regular getEaseMobUsername] password:[regular getEaseMobPassword]
                                                              completion:^(NSDictionary *loginInfo, EMError *error) {
                                                                  if (!error) {
                                                                      // 设置自动登录
                                                                      [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
                                                                  }


                                                              }onQueue:nil];
        }else
        {
            [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:[regular getEaseMobUsername] password:[regular getEaseMobPassword]
                                                              completion:^(NSDictionary *loginInfo, EMError *error) {
                                                                  if (!error) {
                                                                      // 设置自动登录
                                                                      [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
                                                                  }
                                                                  
                                                                  
                                                              }onQueue:nil];
        }
    }
    

    EMPushNotificationOptions* options = [[EaseMob sharedInstance].chatManager pushNotificationOptions];
    options.displayStyle =ePushNotificationDisplayStyle_messageSummary;
    [[EaseMob sharedInstance].chatManager asyncUpdatePushOptions:options];

    double version = [[UIDevice currentDevice].systemVersion doubleValue];//判定系统版本。

    if (version>=8.0f)
    {
        #if version<8
        //注册本地推送
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
        #endif
    }
//    [RCIM initWithAppKey:@"c9kqb3rdk7iej" deviceToken:nil];
        // 设置好友信息提供者。

    /**初始化ShareSDK应用

     @param activePlatforms
     使用的分享平台集合
     @param importHandler (onImport)
     导入回调处理，当某个平台的功能需要依赖原平台提供的SDK支持时，需要在此方法中对原平台SDK进行导入操作
     @param configurationHandler (onConfiguration)
     配置回调处理，在此方法中根据设置的platformType来填充应用配置信息
     */

    [ShareSDK registerActivePlatforms:@[
                                        @(SSDKPlatformTypeSinaWeibo),
                                        @(SSDKPlatformTypeMail),
                                        @(SSDKPlatformTypeSMS),
                                        @(SSDKPlatformTypeCopy),
                                        @(SSDKPlatformTypeWechat),
                                        @(SSDKPlatformTypeQQ)
                                        ]
                             onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             case SSDKPlatformTypeSinaWeibo:
                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                 break;
             default:
                 break;
         }
     }
                      onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {

         switch (platformType)
         {
             case SSDKPlatformTypeSinaWeibo:
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 [appInfo SSDKSetupSinaWeiboByAppKey:@"2499413824"
                                           appSecret:@"d1b605989940c009b49b185969dc831a"
                                         redirectUri:@"http://www.abroadbox.cn/"
                                            authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wx29c4d78d616f85a2"
                                       appSecret:@"52317ee66e15b142c9abbbbf2de02586"];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:@"1104475463"
                                      appKey:@"G6Xzv9zwTK87Pw3w"
                                    authType:SSDKAuthTypeBoth];
                 break;
             default:
                 break;
         }
     }];

    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);

    self.window.backgroundColor = [UIColor whiteColor];
    [application setStatusBarHidden:NO];
    [application setStatusBarStyle:UIStatusBarStyleLightContent];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] ;

    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];


    [self.window makeKeyAndVisible];

    self.window.rootViewController = [CustomTabbarController sharedManager] ;
    if([userDefaults objectForKey:@"FirstLoad"] == nil) {
        [userDefaults setBool:NO forKey:@"FirstLoad"];
        //显示引导页
        [self makeLaunchView];
    }

    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;

    return YES;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[EaseMob sharedInstance] applicationDidEnterBackground:application];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    //    app进入后台时候 让导航栏恢复原样
    [[NSNotificationCenter defaultCenter] postNotificationName:@"navBarReset" object:self];
    [[EaseMob sharedInstance] applicationWillEnterForeground:application];
    NSUInteger _unreadnum=[[EaseMob sharedInstance].chatManager loadTotalUnreadMessagesCountFromDatabase];
    if(_unreadnum)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"qiehuan" object:self];
    }
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {

    [GeTuiSdk resetBadge]; //重置角标计数
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0]; // APP 清空角标

    // [EXT] 重新上线
    [GeTuiSdk startSdkWithAppId:kGtAppId appKey:kGtAppKey appSecret:kGtAppSecret delegate:self];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[EaseMob sharedInstance] applicationWillTerminate:application];
}
#pragma mark - 用户通知(推送) _自定义方法

/** 注册 APNs */
- (void)registerRemoteNotification {
    /*
     警告：Xcode8 需要手动开启"TARGETS -> Capabilities -> Push Notifications"
     */

    /*
     警告：该方法需要开发者自定义，以下代码根据 APP 支持的 iOS 系统不同，代码可以对应修改。
     以下为演示代码，注意根据实际需要修改，注意测试支持的 iOS 系统都能获取到 DeviceToken
     */
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0 // Xcode 8编译会调用
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionCarPlay) completionHandler:^(BOOL granted, NSError *_Nullable error) {
            if (!error) {
                JXLOG(@"request authorization succeeded!");
            }
        }];

        [[UIApplication sharedApplication] registerForRemoteNotifications];
#else // Xcode 7编译会调用
        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
#endif
    } else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    } else {
        UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert |
                                                                       UIRemoteNotificationTypeSound |
                                                                       UIRemoteNotificationTypeBadge);
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
    }
}
#pragma mark - 用户通知(推送)回调 _IOS 8.0以上使用

/** 已登记用户通知 */
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    // 注册远程通知（推送）
    [application registerForRemoteNotifications];
}
- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    /// Background Fetch 恢复SDK 运行
    [GeTuiSdk resume];
    completionHandler(UIBackgroundFetchResultNewData);
}

#pragma mark - APP运行中接收到通知(推送)处理

/** APP已经接收到“远程”通知(推送) - (App运行在后台/App运行在前台) */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    application.applicationIconBadgeNumber = 0; // 标签

    JXLOG(@"\n>>>[Receive RemoteNotification]:%@\n\n", userInfo);
}

/** APP已经接收到“远程”通知(推送) - 透传推送消息  */
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"getnotification" object:nil];
    // 将收到的APNs信息传给个推统计
    [GeTuiSdk handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0

//  iOS 10: App在前台获取到通知
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {

    JXLOG(@"willPresentNotification：%@", notification.request.content.userInfo);

    // 根据APP需要，判断是否要提示用户Badge、Sound、Alert
    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
}

//  iOS 10: 点击通知进入App时触发，在该方法内统计有效用户点击数
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {

    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"getnotification" object:nil];
    // [ GTSdk ]：将收到的APNs信息传给个推统计
    [GeTuiSdk handleRemoteNotification:response.notification.request.content.userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

#endif

#pragma mark - 远程通知(推送)回调

/** 远程通知注册成功委托 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    [[EaseMob sharedInstance] application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];

    // 获得token并存入
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    _deviceToken = [token stringByReplacingOccurrencesOfString:@" " withString:@""] ;
    [[NSUserDefaults standardUserDefaults] setObject:_deviceToken forKey:@"deviceToken"];

    // [3]:向个推服务器注册deviceToken
    [GeTuiSdk registerDeviceToken:_deviceToken];
    
    [regular registerGeTui];
}
/** 远程通知注册失败委托 */
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    JXLOG(@"\n>>>[DeviceToken Error]:%@\n\n", error.description);
}
#pragma mark - GeTuiSdkDelegate
/** SDK启动成功返回cid */
- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId {

    // [4-EXT-1]: 个推SDK已注册，返回clientId
    JXLOG(@"\n>>>[GeTuiSdk RegisterClient]:%@\n\n", clientId);
}

/** SDK遇到错误回调 */
- (void)GeTuiSdkDidOccurError:(NSError *)error {
    // [EXT]:个推错误报告，集成步骤发生的任何错误都在这里通知，如果集成后，无法正常收到消息，查看这里的通知。
    JXLOG(@"\n>>>[GexinSdk error]:%@\n\n", [error localizedDescription]);
}

/** SDK收到透传消息回调 */
- (void)GeTuiSdkDidReceivePayloadData:(NSData *)payloadData andTaskId:(NSString *)taskId andMsgId:(NSString *)msgId andOffLine:(BOOL)offLine fromGtAppId:(NSString *)appId {
    //收到个推消息
    NSString *payloadMsg = nil;
    if (payloadData) {
        payloadMsg = [[NSString alloc] initWithBytes:payloadData.bytes length:payloadData.length encoding:NSUTF8StringEncoding];
    }

    NSString *msg = [NSString stringWithFormat:@"taskId=%@,messageId:%@,payloadMsg:%@%@",taskId,msgId, payloadMsg,offLine ? @"<离线消息>" : @""];
    JXLOG(@"\n>>>[GexinSdk ReceivePayload]:%@\n\n", msg);
}
/** SDK收到sendMessage消息回调 */
- (void)GeTuiSdkDidSendMessage:(NSString *)messageId result:(int)result {
    // [4-EXT]:发送上行消息结果反馈
    NSString *msg = [NSString stringWithFormat:@"sendmessage=%@,result=%d", messageId, result];
    JXLOG(@"\n>>>[GexinSdk DidSendMessage]:%@\n\n", msg);
}

/** SDK运行状态通知 */
- (void)GeTuiSDkDidNotifySdkState:(SdkStatus)aStatus {
    // [EXT]:通知SDK运行状态
    JXLOG(@"\n>>>[GexinSdk SdkState]:%u\n\n", aStatus);
}

/** SDK设置推送模式回调 */
- (void)GeTuiSdkDidSetPushMode:(BOOL)isModeOff error:(NSError *)error {
    if (error) {
        JXLOG(@"\n>>>[GexinSdk SetModeOff Error]:%@\n\n", [error localizedDescription]);
        return;
    }

    JXLOG(@"\n>>>[GexinSdk SetModeOff]:%@\n\n", isModeOff ? @"开启" : @"关闭");
}
#pragma mark - 支付宝回调
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            JXLOG(@"result = %@",resultDic);
        }];
    }
    return YES;
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options{
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            JXLOG(@"result = %@",resultDic);
        }];
    }
    return YES;
}

#pragma mark - SomeAction
static void uncaughtExceptionHandler(NSException *exception) {
    JXLOG(@"CRASH: %@", exception);
    JXLOG(@"Stack Trace: %@", [exception callStackSymbols]);
}
-(NSString*) formateTime:(NSDate*) date {
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"HH:mm:ss"];
    NSString* dateTime = [formatter stringFromDate:date];
    return dateTime;
}
//假引导页面
-(void)makeLaunchView{


    MYIntroductionPanel *_panel = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"box_聊天1"] title:@"" description:@""];

    MYIntroductionPanel *panel = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"box_引导页1"] title:@"" description:@""];

    MYIntroductionPanel *panel3 = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"box_引导页3"] title:@"" description:@""];
    MYIntroductionPanel *panel4 = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"box_引导页4"] description:@""];

    MYIntroductionView *introductionView = [[MYIntroductionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) headerText:@"" panels:@[_panel,panel,panel3,panel4] languageDirection:MYLanguageDirectionLeftToRight];
    [introductionView setBackgroundImage:[UIImage imageNamed:@"box_聊天"]];



    //Set delegate to self for callbacks (optional)
    introductionView.delegate = self;

    //STEP 3: Show introduction view
    [introductionView showInView:self.window];

    //    NSArray *arr=[NSArray arrayWithObjects:@"引导页2",@"引导页3",@"引导页4",@"引导页1", nil];//数组内存放的是我要显示的假引导页面图片
    //    //通过scrollView 将这些图片添加在上面，从而达到滚动这些图片
    //    UIScrollView *scr=[[UIScrollView alloc] initWithFrame:self.window.bounds];
    //    scr.showsHorizontalScrollIndicator=NO;
    //    scr.contentSize=CGSizeMake(320*arr.count, self.window.frame.size.height);
    //    scr.pagingEnabled=YES;
    //    scr.tag=7000;
    //    scr.delegate=self;
    //    [self.window addSubview:scr];
    //    for (int i=0; i<arr.count; i++) {
    //        UIImageView *img=[[UIImageView alloc] initWithFrame:CGRectMake(i*320, 0, 320, self.window.frame.size.height)];
    //        img.image=[UIImage imageNamed:arr[i]];
    //        [scr addSubview:img];
    //
    //    }
}
#pragma mark - Sample Delegate Methods

-(void)introductionDidFinishWithType:(MYFinishType)finishType{
    if (finishType == MYFinishTypeSkipButton) {
        JXLOG(@"Did Finish Introduction By Skipping It");
    }
    else if (finishType == MYFinishTypeSwipeOut){
        JXLOG(@"Did Finish Introduction By Swiping Out");
    }
}
-(void)introductionDidChangeToPanel:(MYIntroductionPanel *)panel withIndex:(NSInteger)panelIndex{
    JXLOG(@"%@ \nPanelIndex: %ld", panel.Description, (long)panelIndex);
}

#pragma mark - scrollView的代理
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //这里是在滚动的时候判断 我滚动到哪张图片了，如果滚动到了最后一张图片，那么
    //如果在往下面滑动的话就该进入到主界面了，我这里利用的是偏移量来判断的，当
    //一共五张图片，所以当图片全部滑完后 又像后多滑了30 的时候就做下一个动作
    if (scrollView.contentOffset.x>3*320+30) {
        isOut=YES;//这是我声明的一个全局变量Bool 类型的，初始值为no，当达到我需求的条件时将值改为yes
    }
}
//停止滑动
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //判断isout为真 就要进入主界面了
    if (isOut) {
        //这里添加了一个动画，（可根据个人喜好）
        [UIView animateWithDuration:1.5 animations:^{
            scrollView.alpha=0;//让scrollview 渐变消失

        }completion:^(BOOL finished) {
            [scrollView  removeFromSuperview];//将scrollView移除
            //            [self gotoMain];//进入主界面
        } ];
    }
}

@end
