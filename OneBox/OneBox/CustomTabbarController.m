//
//  CustomTabbarController.m
//  OneBox
//
//  Created by 谢江新 on 15-2-2.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//
#import "EMCDDeviceManager.h"
#import "ChatViewController.h"
#import "ChatMainViewController.h"
#import "UserInfoViewController.h"
#import "CustomTabbarController.h"
#import "ArticleViewController.h"
#import "FoundViewController.h"
#import "BoxViewController.h"
#import "TabbarItem.h"

//两次提示的默认间隔
static const CGFloat kDefaultPlaySoundInterval = 3.0;
static NSString *kMessageType = @"MessageType";
static NSString *kConversationChatter = @"ConversationChatter";
static NSString *kGroupName = @"GroupName";


@interface CustomTabbarController ()<UITabBarControllerDelegate,IChatManagerDelegate>
{
//    自定义的标签栏
    UIImageView *_tabbar;
    NSMutableArray *btnarr;
    UIImageView *_unreadview;
    UIImageView *_unreadview1;
}
@property (strong, nonatomic) NSDate *lastPlaySoundDate;
@end

@implementation CustomTabbarController

static CustomTabbarController *tabbarController = nil;
- (void)updateStatusView:(AppDelegate *)delegate
{
//    [mAppKeyView setText:delegate.appKey];
//    [mAppSecretView setText:delegate.appSecret];
//    [mAppIDView setText:delegate.appID];
//    [mClientIDView setText:delegate.clientId];
//
//    [mStatusView setText:delegate.sdkStatus == SdkStatusStarted ? @"已启动" : delegate.sdkStatus == SdkStatusStarting ? @"正在启动" : @"已停止"];
//
//    if (delegate.sdkStatus == SdkStatusStoped) {
//        [mStartupView setTitle:@"启动" forState:UIControlStateNormal];
//    } else {
//        [mStartupView setTitle:@"停止" forState:UIControlStateNormal];
//    }
}
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    JXLOG(@"%lu",(unsigned long)self.selectedIndex);


    //    遍历标签栏子视图，使他们为normal状态
    for (UIButton *b in _tabbar.subviews) {

        b.selected = NO;
    }
    //    将点击的item变为select状态
    JXLOG(@"%lu",(unsigned long)self.selectedIndex);
    ((TabbarItem*)btnarr[self.selectedIndex]).selected=YES;
    
}
- (void)logMsg:(NSString *)aMsg
{
//    CGPoint p = [mResponseView contentOffset];
//
//    NSString *response = [NSString stringWithFormat:@"%@\n%@", mResponseView.text, aMsg];
//    [mResponseView setText:response];
//
//
//    [mResponseView setContentOffset:p animated:NO];
//    [mResponseView scrollRangeToVisible:NSMakeRange([mResponseView.text length], 0)];
}
- (void)didLoginFromOtherDevice
{
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:NO completion:^(NSDictionary *info, EMError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"loginAtOtherDevice", @"your login account has been in other places") delegate:self cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
        alertView.tag = 100;
        //        alertView.delegate=self;
        [alertView show];

        NSNumber *islogin=[[NSNumber alloc]initWithInt:0];
        NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];

        [defaults setObject:[NSNumber numberWithInteger:0] forKey:@"no_read_pm_count"];

        [defaults setObject:nil forKey:@"ease_mob_username"];
        [defaults setObject:nil forKey:@"ease_mob_password"];
        [defaults setObject:islogin forKey:@"islogin"];
        [defaults setObject:nil forKey:@"username"];
        [defaults setObject:nil forKey:@"password"];
        [defaults setObject:islogin forKey:@"islogin"];
        [defaults setObject:nil forKey:@"uid"];
        [defaults setObject:nil forKey:@"userImage"];
        [defaults setObject:nil forKey:@"token"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"loginout" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reload" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"backloginout" object:nil];
         [[NSNotificationCenter defaultCenter]postNotificationName:@"nonotification" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getmessage) name:@"getmessage" object:nil];

    } onQueue:nil];
}

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
- (void)didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    if (userInfo)
    {
        if ([self.navigationController.topViewController isKindOfClass:[ChatViewController class]]) {
            ChatViewController *chatController = (ChatViewController *)self.navigationController.topViewController;
            [chatController hideImagePicker];
        }

        NSArray *viewControllers = self.navigationController.viewControllers;
        [viewControllers enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop){
            if (obj != self)
            {
                if (![obj isKindOfClass:[ChatViewController class]])
                {
                    [self.navigationController popViewControllerAnimated:NO];
                }
                else
                {
                    NSString *conversationChatter = userInfo[kConversationChatter];
                    ChatViewController *chatViewController = (ChatViewController *)obj;
                    if (![chatViewController.chatter isEqualToString:conversationChatter])
                    {
                        [self.navigationController popViewControllerAnimated:NO];
                        EMMessageType messageType = [userInfo[kMessageType] intValue];
                        chatViewController = [[ChatViewController alloc] initWithChatter:conversationChatter conversationType:[self conversationTypeFromMessageType:messageType]];
                        switch (messageType) {
                            case eMessageTypeGroupChat:
                            {
                                NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
                                for (EMGroup *group in groupArray) {
                                    if ([group.groupId isEqualToString:conversationChatter]) {
                                        chatViewController.title = group.groupSubject;
                                        break;
                                    }
                                }
                            }
                                break;
                            default:
                                chatViewController.title = conversationChatter;
                                break;
                        }
                        [self.navigationController pushViewController:chatViewController animated:NO];
                    }
                    *stop= YES;
                }
            }
            else
            {
                ChatViewController *chatViewController = (ChatViewController *)obj;
                NSString *conversationChatter = userInfo[kConversationChatter];
                EMMessageType messageType = [userInfo[kMessageType] intValue];
                chatViewController = [[ChatViewController alloc] initWithChatter:conversationChatter conversationType:[self conversationTypeFromMessageType:messageType]];
                switch (messageType) {
                    case eMessageTypeGroupChat:
                    {
                        NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
                        for (EMGroup *group in groupArray) {
                            if ([group.groupId isEqualToString:conversationChatter]) {
                                chatViewController.title = group.groupSubject;
                                break;
                            }
                        }
                    }
                        break;
                    default:
                        chatViewController.title = conversationChatter;
                        break;
                }
                [self.navigationController pushViewController:chatViewController animated:NO];
            }
        }];
    }
    //    else if (_chatListVC)
    //    {
    //        [self.navigationController popToViewController:self animated:NO];
    //        [self setSelectedViewController:_chatListVC];
    //    }
}
- (EMConversationType)conversationTypeFromMessageType:(EMMessageType)type
{
    EMConversationType conversatinType = eConversationTypeChat;
    switch (type) {
        case eMessageTypeChat:
            conversatinType = eConversationTypeChat;
            break;
        case eMessageTypeGroupChat:
            conversatinType = eConversationTypeGroupChat;
            break;
        case eMessageTypeChatRoom:
            conversatinType = eConversationTypeChatRoom;
            break;
        default:
            break;
    }
    return conversatinType;
}
- (BOOL)needShowNotification:(NSString *)fromChatter
{
    BOOL ret = YES;
    NSArray *igGroupIds = [[EaseMob sharedInstance].chatManager ignoredGroupIds];
    for (NSString *str in igGroupIds) {
        if ([str isEqualToString:fromChatter]) {
            ret = NO;
            break;
        }
    }

    return ret;
}
- (void)playSoundAndVibration{
    NSTimeInterval timeInterval = [[NSDate date]
                                   timeIntervalSinceDate:self.lastPlaySoundDate];
    if (timeInterval < kDefaultPlaySoundInterval) {
        //如果距离上次响铃和震动时间太短, 则跳过响铃
        JXLOG(@"skip ringing & vibration %@, %@", [NSDate date], self.lastPlaySoundDate);
        return;
    }

    //保存最后一次响铃时间
    self.lastPlaySoundDate = [NSDate date];

    // 收到消息时，播放音频
    [[EMCDDeviceManager sharedInstance] playNewMessageSound];
    // 收到消息时，震动
    [[EMCDDeviceManager sharedInstance] playVibration];
}
#pragma mark-刷新消息内容
// 收到消息回调
-(void)didReceiveMessage:(EMMessage *)message
{
//    [[ToolManager sharedManager] alertTitle_Simple:@"收到3"];
//    [[ToolManager sharedManager] alertTitle_Simple:@"getmessage"];
//    UIAlertView *alertview=[[UIAlertView alloc] initWithTitle:nil message:@"getmessage" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
//    [alertview show];

    BOOL needShowNotification = (message.messageType != eMessageTypeChat) ? [self needShowNotification:message.conversationChatter] : YES;
    if (needShowNotification) {
#if !TARGET_IPHONE_SIMULATOR

        BOOL isAppActivity = [[UIApplication sharedApplication] applicationState] == UIApplicationStateActive;
        if (!isAppActivity) {
            [self showNotificationWithMessage:message];
        }else {
            [self playSoundAndVibration];
        }
#endif
    }
}
- (void)showNotificationWithMessage:(EMMessage *)message
{
//    [[ToolManager sharedManager] alertTitle_Simple:@"收到4"];
    EMPushNotificationOptions *options = [[EaseMob sharedInstance].chatManager pushNotificationOptions];
    //发送本地推送
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = [NSDate date]; //触发通知的时间

    if (options.displayStyle == ePushNotificationDisplayStyle_messageSummary) {
        id<IEMMessageBody> messageBody = [message.messageBodies firstObject];
        NSString *messageStr = nil;
        switch (messageBody.messageBodyType) {
            case eMessageBodyType_Text:
            {
                messageStr = ((EMTextMessageBody *)messageBody).text;
            }
                break;
            case eMessageBodyType_Image:
            {
                messageStr = NSLocalizedString(@"message.image", @"Image");
            }
                break;
            case eMessageBodyType_Location:
            {
                messageStr = NSLocalizedString(@"message.location", @"Location");
            }
                break;
            case eMessageBodyType_Voice:
            {
                messageStr = NSLocalizedString(@"message.voice", @"Voice");
            }
                break;
            case eMessageBodyType_Video:{
                messageStr = NSLocalizedString(@"message.video", @"Video");
            }
                break;
            default:
                break;
        }

        NSString *title = message.from;
        if (message.messageType == eMessageTypeGroupChat) {
            NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
            for (EMGroup *group in groupArray) {
                if ([group.groupId isEqualToString:message.conversationChatter]) {
                    title = [NSString stringWithFormat:@"%@(%@)", message.groupSenderName, group.groupSubject];
                    break;
                }
            }
        }
        else if (message.messageType == eMessageTypeChatRoom)
        {
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            NSString *key = [NSString stringWithFormat:@"OnceJoinedChatrooms_%@", [[[EaseMob sharedInstance].chatManager loginInfo] objectForKey:@"username" ]];
            NSMutableDictionary *chatrooms = [NSMutableDictionary dictionaryWithDictionary:[ud objectForKey:key]];
            NSString *chatroomName = [chatrooms objectForKey:message.conversationChatter];
            if (chatroomName)
            {
                title = [NSString stringWithFormat:@"%@(%@)", message.groupSenderName, chatroomName];
            }
        }

        notification.alertBody = @"您有一条新消息";
    }
    else{
//        notification.alertBody = @"您有一条新消息4";

    }

#warning 去掉注释会显示[本地]开头, 方便在开发中区分是否为本地推送
    //notification.alertBody = [[NSString alloc] initWithFormat:@"[本地]%@", notification.alertBody];

    notification.alertAction = NSLocalizedString(@"open", @"Open");
    notification.timeZone = [NSTimeZone defaultTimeZone];
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:self.lastPlaySoundDate];
    if (timeInterval < kDefaultPlaySoundInterval) {
        JXLOG(@"skip ringing & vibration %@, %@", [NSDate date], self.lastPlaySoundDate);
    } else {
        notification.soundName = UILocalNotificationDefaultSoundName;
        self.lastPlaySoundDate = [NSDate date];
    }

    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:[NSNumber numberWithInt:message.messageType] forKey:kMessageType];
    [userInfo setObject:message.conversationChatter forKey:kConversationChatter];
    notification.userInfo = userInfo;

    //发送通知
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    //    UIApplication *application = [UIApplication sharedApplication];
    //    application.applicationIconBadgeNumber += 1;
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
-(void)unreadmessage:(NSNotification *)not
{
    
    if([not.object integerValue]>0)
    {
        _unreadview.hidden=NO;
    }else
    {
        _unreadview.hidden=YES;

    }
}
- (void)viewDidLoad {

    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unreadmessage:) name:@"unreadmessage" object:nil];
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

    [self registerNotifications];


    NSUInteger _unreadnum=[[EaseMob sharedInstance].chatManager loadTotalUnreadMessagesCountFromDatabase];

    if(_unreadnum)
    {
        _unreadview.hidden=NO;
    }else
    {
        _unreadview.hidden=YES;
    }


    [self getunreadnum];


    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getnotification) name:@"getnotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nonotification) name:@"nonotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getmessage) name:@"getmessage" object:nil];
}
-(void)getmessage
{
    NSUInteger _unreadnum=[[EaseMob sharedInstance].chatManager loadTotalUnreadMessagesCountFromDatabase];

    if(_unreadnum)
    {
        _unreadview.hidden=NO;
    }else
    {
        _unreadview.hidden=YES;
    }
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
-(void)registerNotifications
{
    [self unregisterNotifications];
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
}
-(void)unregisterNotifications
{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}

-(void)setupUnreadMessageCount
{
    NSArray *conversations = [[[EaseMob sharedInstance] chatManager] conversations];
    NSInteger unreadCount = 0;
    for (EMConversation *conversation in conversations) {
        unreadCount += conversation.unreadMessagesCount;
    }

    UIApplication *application = [UIApplication sharedApplication];
    [application setApplicationIconBadgeNumber:unreadCount];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"unreadmessage" object:[NSNumber numberWithInteger:unreadCount]];
}
#pragma mark - IChatManagerDelegate 消息变化
// 未读消息数量变化回调
-(void)didUnreadMessagesCountChanged
{
    [self setupUnreadMessageCount];
}
- (void)didFinishedReceiveOfflineMessages
{
    [self setupUnreadMessageCount];
}

-(void)createViewControllers
{
    //     创建数组并初始化
    NSMutableArray *vcs = [[NSMutableArray alloc]init];
    for (int i = 0; i<5; i++) {
        //        三目运算创建视图
        UIViewController *vc =i==0?[[ChatMainViewController alloc]init]:i==1?[[ArticleViewController alloc] init]:i==2?[[BoxViewController alloc] init]:i==3?[[FoundViewController alloc]init]:[[UserInfoViewController alloc] init];
        //        将创建视图加入到navi中

        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:vc];
        [vcs addObject:navi];
        
    }
    //    将数组中的视图添加到当前的tabbarController中去
    self.viewControllers = vcs;
    self.selectedIndex=3;
    
}
-(void)createTabbarItem
{
    //    创建存放视图标题的数组
    //    NSArray *titleArr = @[@"地 图",@"",@"发 现"];
    //    创建tabbarItem  normal情况下的显示图片

    NSArray *imageArr = @[
                          @"found_activity_coment_select1"
                          ,@"found_activity_文章_select1"
                          ,@"found_activity_盒子_select1"
                          ,@"found_activity_发现_select1"
                          ,@"found_activity_user_select1"
                          ];
    //    创建tabbarItem  select情况下的显示图片
    NSArray *imageSelectArr = @[
                                @"found_activity_coment_normal1"
                                ,@"found_activity_文章_normal1"
                                ,@"found_activity_盒子_normal1"
                                ,@"found_activity_发现_normal1"
                                ,@"found_activity_user_normal1"
                                ];
    //计算当前屏幕尺寸下tabbarItem的宽度
    CGFloat buttonWidth =ScreenWidth/5;
    for (int i = 0; i<imageArr.count; i++) {
        TabbarItem *item = [TabbarItem buttonWithType:UIButtonTypeCustom];
        if(i==2)
        {
            //            当当前TabbarItem为中间的box时，设置type为1（为了区分box和其他TabbarItem，进行不同的定制）
            item.type=1;
        }else if(i==1)
        {
            item.type=0;
        }else if(i==3)
        {
            item.type=5;
        }else if(i==0)
        {
            _unreadview=[[UIImageView alloc] initWithFrame:CGRectMake(buttonWidth-26, 13, 7, 7)];
            [item addSubview:_unreadview];
            _unreadview.layer.masksToBounds=YES;
            _unreadview.layer.cornerRadius=CGRectGetWidth(_unreadview.frame)/2.0f;

            _unreadview.backgroundColor=[UIColor redColor];
            _unreadview.hidden=YES;
            item.type=11;
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
-(void)updateMsgCount:(int)count {
//    NSString* countStr = [NSString stringWithFormat:@"%d", count];
//    [mMsgCount setText:countStr];
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
-(void)tabbarHideWithanimated
{
//    动画消失
    [UIView beginAnimations:@"anmationHide" context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDelegate:self];

     _tabbar.frame=CGRectMake(0, [[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width, kTabBarHeight);

    [UIView commitAnimations];

}

-(void)tabbarAppearWithanimated
{
//    动画显示
    [UIView beginAnimations:@"anmationAppear" context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDelegate:self];
    _tabbar.frame=CGRectMake(0, [[UIScreen mainScreen] bounds].size.height - kTabBarHeight, [[UIScreen mainScreen] bounds].size.width, kTabBarHeight);
    [UIView commitAnimations];


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
