//
//  AppDelegate.m
//  OneBox
//
//  Created by 谢江新 on 15-2-2.
//  Copyright (c) 2015年 谢江新. All rights reserved.

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
#import "AppDelegate.h"
#import "CustomTabbarController.h"


#define kAppId           @"aLuGPVna2MAoAVtfbB66a3"
#define kAppKey          @"6yfaRLwDyZ8PDrfpkFULe"
#define kAppSecret       @"HpDuxiSFdmA4GJfHwq3u74"
#define NotifyActionKey "NotifyAction"
NSString* const NotificationCategoryIdent  = @"ACTIONABLE";
NSString* const NotificationActionOneIdent = @"ACTION_ONE";
NSString* const NotificationActionTwoIdent = @"ACTION_TWO";
@interface AppDelegate ()
@end

@implementation AppDelegate
{
    BOOL isOut;
}
@synthesize window = _window;
@synthesize viewController = _viewController;

@synthesize gexinPusher = _gexinPusher;
@synthesize appKey = _appKey;
@synthesize appSecret = _appSecret;
@synthesize appID = _appID;
@synthesize clientId = _clientId;
@synthesize sdkStatus = _sdkStatus;
@synthesize lastPayloadIndex = _lastPaylodIndex;
@synthesize payloadId = _payloadId;


- (void)registerRemoteNotification {

#ifdef __IPHONE_8_0
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        //IOS8 新的通知机制category注册
        UIMutableUserNotificationAction *action1;
        action1 = [[UIMutableUserNotificationAction alloc] init];
        [action1 setActivationMode:UIUserNotificationActivationModeBackground];
        [action1 setTitle:@"取消"];
        [action1 setIdentifier:NotificationActionOneIdent];
        [action1 setDestructive:NO];
        [action1 setAuthenticationRequired:NO];

        UIMutableUserNotificationAction *action2;
        action2 = [[UIMutableUserNotificationAction alloc] init];
        [action2 setActivationMode:UIUserNotificationActivationModeBackground];
        [action2 setTitle:@"回复"];
        [action2 setIdentifier:NotificationActionTwoIdent];
        [action2 setDestructive:NO];
        [action2 setAuthenticationRequired:NO];

        UIMutableUserNotificationCategory *actionCategory;
        actionCategory = [[UIMutableUserNotificationCategory alloc] init];
        [actionCategory setIdentifier:NotificationCategoryIdent];
        [actionCategory setActions:@[action1, action2]
                        forContext:UIUserNotificationActionContextDefault];

        NSSet *categories = [NSSet setWithObject:actionCategory];
        UIUserNotificationType types = (UIUserNotificationTypeAlert|
                                        UIUserNotificationTypeSound|
                                        UIUserNotificationTypeBadge);

        UIUserNotificationSettings *settings;
        settings = [UIUserNotificationSettings settingsForTypes:types categories:categories];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];



    } else {
        UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert|
                                                                       UIRemoteNotificationTypeSound|
                                                                       UIRemoteNotificationTypeBadge);
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
    }
#else
    UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert|
                                                                   UIRemoteNotificationTypeSound|
                                                                   UIRemoteNotificationTypeBadge);
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
#endif
    
}
- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    return UIInterfaceOrientationMaskPortrait;
}


//接收本地推送
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{

    NSDictionary *userInfo = notification.userInfo;
    //    [[ToolManager sharedManager] alertTitle_Simple:[[NSString alloc] initWithFormat:@"收到1=%@",userInfo]];

    if (_viewController) {
        //        [[ToolManager sharedManager] alertTitle_Simple:[[NSString alloc] initWithFormat:@"收到2=%@",userInfo]];
        [_viewController didReceiveLocalNotification:notification];
    }
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {


    [MobClick startWithAppkey:@"56245bf667e58e115b002eb0" reportPolicy:BATCH   channelId:@""];



    //     [1]:使用APPID/APPKEY/APPSECRENT创建个推实例
    [self startSdkWith:kAppId appKey:kAppKey appSecret:kAppSecret];

    // [2]:注册APNS
    [self registerRemoteNotification];

    // [2-EXT]: 获取启动时收到的APN数据
    NSDictionary*message=[launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];

    if (message) {

//        NSString*payloadMsg = [message objectForKey:@"payload"];
//
//        NSString*record = [NSString stringWithFormat:@"[APN]%@,%@",[NSDate date],payloadMsg];
//
//        [_viewController logMsg:record];

    }

    [[EaseMob sharedInstance] registerSDKWithAppKey:@"onebox2015#abroadboxios" apnsCertName:@"onebox_push"];
    [[EaseMob sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];

    //先判断是否开启自动登录，如果没有开启，则调用登录方法，并在登录成功后开启自动登录的开关

    //    自动登录在以下几种情况下会被取消

    //   1. 用户调用了SDK的登出动作;
    //   2. 用户在别的设备上更改了密码, 导致此设备上自动登陆失败;
    //   3. 用户的账号被从服务器端删除;
    //   4. 用户从另一个设备登录，把当前设备上登陆的用户踢出.

    //@"ease_mob_username"] password:[[dict objectForKey:@"data"] objectForKey:@"ease_mob_password"
    if(([[NSUserDefaults standardUserDefaults] objectForKey:@"ease_mob_username"]!=nil)&&([[NSUserDefaults standardUserDefaults] objectForKey:@"ease_mob_password"]!=nil))
    {
        BOOL isAutoLogin = [[EaseMob sharedInstance].chatManager isAutoLoginEnabled];
        if (!isAutoLogin) {
            [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:[[NSUserDefaults standardUserDefaults] objectForKey:@"ease_mob_username"] password:[[NSUserDefaults standardUserDefaults] objectForKey:@"ease_mob_password"]
                                                              completion:^(NSDictionary *loginInfo, EMError *error) {
                                                                  if (!error) {
                                                                      // 设置自动登录
                                                                      [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
                                                                  }


                                                              }onQueue:nil];
        }else
        {
            [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:[[NSUserDefaults standardUserDefaults] objectForKey:@"ease_mob_username"] password:[[NSUserDefaults standardUserDefaults] objectForKey:@"ease_mob_password"]
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
    /**
     *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App，请移步到http://mob.com/login 登录后台进行应用注册
     *  在将生成的AppKey传入到此方法中。
     *  方法中的第二个第三个参数为需要连接社交平台SDK时触发，
     *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
     *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
     */
    [ShareSDK registerApp:@"697b959f44b4"
     
          activePlatforms:@[
                            @(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformTypeMail),
                            @(SSDKPlatformTypeSMS),
                            @(SSDKPlatformTypeCopy),
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ)]
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

    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];

    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;

    return YES;
}

static void uncaughtExceptionHandler(NSException *exception) {
    JXLOG(@"CRASH: %@", exception);
    JXLOG(@"Stack Trace: %@", [exception callStackSymbols]);
}
//去主页
//-(void)gotoMain{
//    //如果第一次进入没有文件，我们就创建这个文件
//    NSFileManager *manager=[NSFileManager defaultManager];
//    //判断 我是否创建了文件，如果没创建 就创建这个文件（这种情况就运行一次，也就是第一次启动程序的时候）
//    if (![manager fileExistsAtPath:[NSHomeDirectory() stringByAppendingString:@"aa.txt"]]) {
//        [manager createFileAtPath:[NSHomeDirectory() stringByAppendingString:@"aa.txt"] contents:nil attributes:nil];
//    }
//
//}
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
    JXLOG(@"%@ \nPanelIndex: %d", panel.Description, panelIndex);
}

#pragma mark scrollView的代理
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
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {

    [self stopSdk];
    // [EXT] APP进入后台时，通知个推SDK进入后台
    [GeTuiSdk enterBackground];
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
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//    [self startSdkWith:_appID appKey:_appKey appSecret:_appSecret];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];

    // [EXT] 重新上线
    [self startSdkWith:_appID appKey:_appKey appSecret:_appSecret];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[EaseMob sharedInstance] applicationWillTerminate:application];
}



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



#pragma mark-个推
#pragma mark-登记
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    [[EaseMob sharedInstance] application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    //    [_deviceToken release];
    _deviceToken = [token stringByReplacingOccurrencesOfString:@" " withString:@""] ;
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"]==nil)
    {
        [[NSUserDefaults standardUserDefaults] setObject:_deviceToken forKey:@"deviceToken"];
    }

    // [3]:向个推服务器注册deviceToken
    [GeTuiSdk registerDeviceToken:_deviceToken];

    NSUserDefaults *dict=[NSUserDefaults standardUserDefaults];


     NSString *clientId = [GeTuiSdk clientId];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];


    NSString *_token=nil;
    if([dict objectForKey:@"islogin"]!=[NSNull null])
    {

        if([[dict objectForKey:@"islogin"] integerValue]!=0)
        {
            if([dict objectForKey:@"token"]==nil)
            {

                _token=@"";
            }else
            {
                _token=[dict objectForKey:@"token"];
            }

        }else
        {
            _token=@"";
        }

    }else
    {
        _token=@"";
    }
//    NSString *_token=[dict objectForKey:@"token"];
    if(clientId!=nil)
    {
        NSDictionary *parameters=@{@"token":_token,@"uuid":clientId,@"device_type":@"1"};
        [manager POST:[[NSString alloc] initWithFormat:@"%@%@",DNS,@"/v1/users/getui_uuid"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {

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
            [self.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
        }];

    }


}
#pragma mark-登记失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    // [3-EXT]:如果APNS注册失败，通知个推服务器
    [GeTuiSdk registerDeviceToken:@""];

//    [_viewController logMsg:[NSString stringWithFormat:@"didFailToRegisterForRemoteNotificationsWithError:%@", [error localizedDescription]]];
}




- (void)stopSdk
{
//    [GeTuiSdk enterBackground];
    [GeTuiSdk enterBackground];
}

- (BOOL)checkSdkInstance
{
    if (!_gexinPusher) {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误" message:@"SDK未启动" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//        [alertView show];

        return NO;
    }
    return YES;
}






//- (void)testSendMessage
//{
//    UIViewController *sendMessageView = [[SendMessageController alloc] initWithNibName:@"SendMessageController" bundle:nil];
//    [_naviController pushViewController:sendMessageView animated:YES];
//    [sendMessageView release];
//}



#pragma mark - GexinSdkDelegate
- (void)GexinSdkDidRegisterClient:(NSString *)clientId
{
    // [4-EXT-1]: 个推SDK已注册
    _sdkStatus = SdkStatusStarted;


    [_viewController updateStatusView:self];

    //    [self stopSdk];
}
#pragma mark-收到个推消息
- (void)GexinSdkDidReceivePayload:(NSString *)payloadId fromApplication:(NSString *)appId
{
    // [4]: 收到个推消息



//    NSData *payload = [_gexinPusher retrivePayloadById:payloadId];
//    NSString *payloadMsg = nil;
//    if (payload) {
//        payloadMsg = [[NSString alloc] initWithBytes:payload.bytes
//                                              length:payload.length
//                                            encoding:NSUTF8StringEncoding];
//    }





}

- (void)GexinSdkDidSendMessage:(NSString *)messageId result:(int)result {
    // [4-EXT]:发送上行消息结果反馈
//    NSString *record = [NSString stringWithFormat:@"Received sendmessage:%@ result:%d", messageId, result];
//    [_viewController logMsg:record];
}

- (void)GexinSdkDidOccurError:(NSError *)error
{
    // [EXT]:个推错误报告，集成步骤发生的任何错误都在这里通知，如果集成后，无法正常收到消息，查看这里的通知。
//    [_viewController logMsg:[NSString stringWithFormat:@">>>[GexinSdk error]:%@", [error localizedDescription]]];
}
#pragma mark - background fetch  唤醒
- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {

    //[5] Background Fetch 恢复SDK 运行
    [GeTuiSdk resume];
    completionHandler(UIBackgroundFetchResultNewData);
}



- (NSString*)dictionaryToJson:(NSDictionary *)dic

{

    NSError *parseError = nil;

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];

    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}


#pragma mark-收到透传消息
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"getnotification" object:nil];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)startSdkWith:(NSString *)appID appKey:(NSString *)appKey appSecret:(NSString *)appSecret
{

    //    _appID = [appID retain];
    //    _appKey = [appKey retain];
    //    _appSecret = [appSecret retain];

    NSError *err = nil;

    //[1-1]:通过 AppId、 appKey 、appSecret 启动SDK
    [GeTuiSdk startSdkWithAppId:appID appKey:appKey appSecret:appSecret delegate:self error:&err];

    //[1-2]:设置是否后台运行开关
    [GeTuiSdk runBackgroundEnable:YES];
    //[1-3]:设置电子围栏功能，开启LBS定位服务 和 是否允许SDK 弹出用户定位请求
    [GeTuiSdk lbsLocationEnable:YES andUserVerify:YES];

    if (err) {
//        [_viewController logMsg:[NSString stringWithFormat:@"%@", [err localizedDescription]]];
    }
    
}

- (void)setDeviceToken:(NSString *)aToken
{

    [GeTuiSdk registerDeviceToken:aToken];
}

- (BOOL)setTags:(NSArray *)aTags error:(NSError **)error
{
    return [GeTuiSdk setTags:aTags];
}

- (NSString *)sendMessage:(NSData *)body error:(NSError **)error {

    return [GeTuiSdk sendMessage:body error:error];
}

- (void)bindAlias:(NSString *)aAlias {
    [GeTuiSdk bindAlias:aAlias];
}

- (void)unbindAlias:(NSString *)aAlias {

    [GeTuiSdk unbindAlias:aAlias];
}

- (void)testSdkFunction
{
//    UIViewController *funcsView = [[TestFunctionController alloc] initWithNibName:@"TestFunctionController" bundle:nil];
//    [_naviController pushViewController:funcsView animated:YES];
//    [funcsView release];
}

- (void)testGetClientId {
    NSString *clientId = [GeTuiSdk clientId];

//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"当前的CID" message:clientId delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//    [alertView show];
//    [alertView release];
}

#pragma mark - GexinSdkDelegate
- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId
{
    // [4-EXT-1]: 个推SDK已注册，返回clientId
//    [_clientId release];
//    _clientId = [clientId retain];

    if (_deviceToken) {
        [GeTuiSdk registerDeviceToken:_deviceToken];
    }
}
#pragma mark-收到个推消息
- (void)GeTuiSdkDidReceivePayload:(NSString *)payloadId andTaskId:(NSString *)taskId andMessageId:(NSString *)aMsgId fromApplication:(NSString *)appId
{
    
    // [4]: 收到个推消息
//    [_payloadId release];
//    _payloadId = [payloadId retain];


    NSData* payload = [GeTuiSdk retrivePayloadById:payloadId];

    NSString *payloadMsg = nil;
    if (payload) {
        payloadMsg = [[NSString alloc] initWithBytes:payload.bytes
                                              length:payload.length
                                            encoding:NSUTF8StringEncoding];
    }

    NSString *record = [NSString stringWithFormat:@"%d, %@, %@", ++_lastPaylodIndex, [self formateTime:[NSDate date]], payloadMsg];

//    [[ToolManager sharedManager] alertTitle_Simple:[NSString stringWithFormat:@"%d, %@, %@", ++_lastPaylodIndex, [self formateTime:[NSDate date]], payloadMsg]];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"getnotification" object:nil];
    [_viewController logMsg:record];
    [_viewController updateMsgCount:_lastPaylodIndex];
//    [[ToolManager sharedManager] alertTitle_Simple:[[NSString alloc] initWithFormat:@"task id : %@, messageId:%@", taskId, aMsgId]];



}

- (void)GeTuiSdkDidSendMessage:(NSString *)messageId result:(int)result {
    // [4-EXT]:发送上行消息结果反馈
//    NSString *record = [NSString stringWithFormat:@"Received sendmessage:%@ result:%d", messageId, result];
//    [_viewController logMsg:record];
}

- (void)GeTuiSdkDidOccurError:(NSError *)error
{
    // [EXT]:个推错误报告，集成步骤发生的任何错误都在这里通知，如果集成后，无法正常收到消息，查看这里的通知。
//    [_viewController logMsg:[NSString stringWithFormat:@">>>[GexinSdk error]:%@", [error localizedDescription]]];
}

- (void)GeTuiSDkDidNotifySdkState:(SdkStatus)aStatus {
    // [EXT]:通知SDK运行状态
    _sdkStatus = aStatus;
    [_viewController updateStatusView:self];
}

-(NSString*) formateTime:(NSDate*) date {
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"HH:mm:ss"];
    NSString* dateTime = [formatter stringFromDate:date];
    return dateTime;
}

@end
