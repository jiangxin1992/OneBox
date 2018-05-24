//
//  ChatMainViewController.m
//  OneBox
//
//  Created by 谢江新 on 15/8/13.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import "ChatMainViewController.h"

#import "EMCDDeviceManager.h"
#import <AVFoundation/AVFoundation.h>

#import "LoginViewController.h"
#import "FollowingViewController.h"
#import "FollowerViewController.h"
#import "ChatListViewController.h"
#import "ChatViewController.h"
#import "CallViewController.h"
#import "UserListViewController.h"
#import "CustomTabbarController.h"

#import "usermodel.h"
#import "RobotManager.h"

//两次提示的默认间隔
//static const CGFloat kDefaultPlaySoundInterval = 3.0;
//static NSString *kMessageType = @"MessageType";
//static NSString *kConversationChatter = @"ConversationChatter";
//static NSString *kGroupName = @"GroupName";
@interface ChatMainViewController ()
//<IChatManagerDelegate,EMCallManagerDelegate,ChatViewControllerDelegate>
//@property (strong, nonatomic) NSDate *lastPlaySoundDate;

@end

@implementation ChatMainViewController
{
    ChatListViewController *_chatListVC;
    UIPageViewController *_pageVc;
    NSMutableArray *btnarr;
    NSInteger currentPage;
    UserListViewController *left;
    ChatListViewController *right;
    CGRect _rect_left;
    CGRect _rect_right;
    UIView *dibu;
}

//- (void)dealloc
//{
//    [self unregisterNotifications];
//}
-(void)pushChatView1:(NSNotification *)not
{
    usermodel *model=(usermodel *)not.object;
    ChatViewController *chatVC = [[ChatViewController alloc] initWithChatter:model.ease_mob_username isGroup:NO];

    chatVC.userinfo=@{@"cell":model.cell,@"is_server":[NSNumber numberWithBool:model.is_server],@"uid":model.user_id};
    chatVC.uid=model.user_id;
    [chatVC setH_title:model.username];
    chatVC.friend_head=model.avatar;
    chatVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatVC animated:YES];
}
//    following
//    follower"
-(void)following:(NSNotification *)not
{
    NSString *_token=not.object;
    FollowingViewController *foll=[[FollowingViewController alloc] init];
    foll.token=_token;
    [self.navigationController pushViewController:foll animated:YES];


}
-(void)follower:(NSNotification *)not
{
    NSString *_token=not.object;
    FollowerViewController *foll=[[FollowerViewController alloc] init];
    foll.token=_token;
    [self.navigationController pushViewController:foll animated:YES];
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

-(void)refreshList
{

    [self dismissModalViewControllerAnimated:YES];

}
-(void)qiehuan
{
    [self qiehuan:((UIButton *)[self.view viewWithTag:101])];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    JXLOG(@"沙盒路径：%@",NSHomeDirectory());
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(qiehuan) name:@"qiehuan" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(xiaoshi:) name:@"xiaoshi" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshList) name:@"refreshList" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshList1) name:@"refreshList1" object:nil];
    btnarr=[[NSMutableArray alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginout) name:@"loginout" object:nil];


    _rect_left=CGRectMake(0, 39, 100, 3);
    _rect_right=CGRectMake(500*_Scale-100, 39, 100, 3);

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushChatView:) name:@"pushChatView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushChatView1:) name:@"pushChatView1" object:nil];
//    following
//    follower"
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(following:) name:@"following" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(follower:) name:@"follower" object:nil];



    if ([UIDevice currentDevice].systemVersion.floatValue >= 7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.title = NSLocalizedString(@"title.conversation", @"Conversations");

//    [self registerNotifications];

    self.navigationController.navigationBar.barTintColor =[UIColor colorWithRed:70.0f/255.0f green:195.0f/255.0f blue:247.0f/255.0f alpha:1];

    UIView *navview=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 500*_Scale, 44)];
    for (int i=0; i<2; i++) {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake((CGRectGetWidth(navview.frame)-100)*i, 0, 100, CGRectGetHeight(navview.frame));
        [navview addSubview:btn];
        [btn addTarget:self action:@selector(qiehuan:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag=100+i;
        btn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
        NSString *str=i==0?@"好友":@"消息";
        btn.titleLabel.font=(kIOSVersions>=9.0? [UIFont systemFontOfSize:16.0f]:[UIFont fontWithName:@"Helvetica Neue" size:16.0f]);
        [btn setTitle:str forState:UIControlStateNormal];
        [btn.titleLabel setAttributedText:[regular createAttributeString:str andFloat:@(3.0)]];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor colorWithRed:127.0f/255.0f green:215.0f/255.0f blue:255.0f/255.0f alpha:1] forState:UIControlStateNormal];
        if(i==0)
        {
            btn.selected=YES;

        }
        [btnarr addObject:btn];

    }

    self.navigationItem.titleView=navview;
    dibu=[[UIView alloc] initWithFrame:_rect_left];
    dibu.backgroundColor=[UIColor whiteColor];
    [navview addSubview:dibu];

    _pageVc = [[UIPageViewController alloc]initWithTransitionStyle:1 navigationOrientation:0 options:nil];
    _pageVc.view.frame = CGRectMake(0, 0, 1000 , 1000 );
//    _pageVc.view.backgroundColor = [UIColor yellowColor];
//    _pageVc.view.backgroundColor=[UIColor colorWithRed:230.0f/255.0f green:230.0f/255.0f blue:230.0f/255.0f alpha:1];
    _pageVc.view.backgroundColor=[UIColor whiteColor];

    if(left==nil)
    {
        left=[[UserListViewController alloc] init];

    }
    [_pageVc setViewControllers:@[left] direction:0 animated:YES completion:nil];
    currentPage=0;


    [self.view addSubview:_pageVc.view];
}
-(void)pushChatView:(NSNotification *)not
{
        NSDictionary *dic=not.object;
        usermodel *model=[dic objectForKey:@"title"];
        EMConversation *conversation=[dic objectForKey:@"con"];
        NSString *title = conversation.chatter;
        if (conversation.conversationType != eConversationTypeChat) {
            if ([[conversation.ext objectForKey:@"groupSubject"] length])
            {
                title = [conversation.ext objectForKey:@"groupSubject"];
            }
            else
            {
                NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
                for (EMGroup *group in groupArray) {
                    if ([group.groupId isEqualToString:conversation.chatter]) {
                        title = group.groupSubject;
                        break;
                    }
                }
            }
        }

    JXLOG(@"title=%@",title);

    NSString *chatter = conversation.chatter;
    ChatViewController *chatController = [[ChatViewController alloc] initWithChatter:chatter conversationType:conversation.conversationType];
    chatController.delelgate = self;

    NSString *cell=nil;
    if(![model.cell isEqualToString:@""])
    {
        cell =model.cell;
    }else
    {
        cell=@"";
    }


    BOOL _isser=model.is_server;


    chatController.userinfo=@{@"cell":cell,@"is_server":[NSNumber numberWithBool:_isser],@"uid":model.user_id};

    chatController.h_title = model.username;
    chatController.friend_head=model.avatar;
    chatController.uid=model.user_id;
    if ([[RobotManager sharedInstance] getRobotNickWithUsername:chatter]) {
        chatController.title = [[RobotManager sharedInstance] getRobotNickWithUsername:chatter];
    }


    chatController.hidesBottomBarWhenPushed = YES;

    [self.navigationController pushViewController:chatController animated:YES];

}
-(void)loginout
{

    if(currentPage>0)
    {
        if(left==nil)
        {
            left=[[UserListViewController alloc] init];

        }
        [_pageVc setViewControllers:@[left] direction:0 animated:YES completion:nil];
        [UIView beginAnimations:@"anmationName1" context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDelegate:self];
        dibu.frame=_rect_left;
        [UIView commitAnimations];

    }

    for (UIButton *_btn in btnarr) {
        _btn.selected=NO;
        if(_btn.tag==100)
        {
            _btn.selected=YES;
            currentPage=_btn.tag-100;
        }
    }


}
-(void)qiehuan:(UIButton *)btn
{

    if(btn.tag-100==0)
    {
        if(currentPage>0)
        {
            if(left==nil)
            {
                left=[[UserListViewController alloc] init];

            }
            [_pageVc setViewControllers:@[left] direction:0 animated:YES completion:nil];
            [UIView beginAnimations:@"anmationName1" context:nil];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
            [UIView setAnimationDelegate:self];
            dibu.frame=_rect_left;
            [UIView commitAnimations];

        }

        for (UIButton *_btn in btnarr) {
            _btn.selected=NO;
            if(_btn.tag==btn.tag)
            {
                _btn.selected=YES;
                currentPage=_btn.tag-100;
            }
        }


    }else if(btn.tag-100==1)
    {
        if(![regular isLogin])
        {
            [[ToolManager sharedManager] alertTitle_Simple:@"请先登录"];

        }else
        {

            if(right==nil)
            {

                right =[[ChatListViewController alloc] init];
                [right networkChanged:_connectionState];
                //            [self.navigationController pushViewController:right animated:YES];

            }
            if(currentPage<1)
            {
                [_pageVc setViewControllers:@[right] direction:1 animated:YES completion:nil];

            }
            [UIView beginAnimations:@"anmationName2" context:nil];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
            [UIView setAnimationDelegate:self];
            dibu.frame=_rect_right;
            [UIView commitAnimations];
            for (UIButton *_btn in btnarr) {
                _btn.selected=NO;
                if(_btn.tag==btn.tag)
                {
                    _btn.selected=YES;
                    currentPage=_btn.tag-100;
                }
            }
        }

    }


    
}
//-(void)registerNotifications
//{
//    [self unregisterNotifications];
//    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
//    [[EaseMob sharedInstance].callManager addDelegate:self delegateQueue:nil];
//}
//-(void)unregisterNotifications
//{
//    [[EaseMob sharedInstance].chatManager removeDelegate:self];
//    [[EaseMob sharedInstance].callManager removeDelegate:self];
//}

//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if(alertView.tag==100)
//    {
//        
//        NSNumber *islogin=[[NSNumber alloc]initWithInt:0];
//        NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
//
//        [defaults setObject:nil forKey:@"ease_mob_username"];
//        [defaults setObject:nil forKey:@"ease_mob_password"];
//        [defaults setObject:islogin forKey:@"islogin"];
//        [defaults setObject:nil forKey:@"username"];
//        [defaults setObject:nil forKey:@"password"];
//        [defaults setObject:islogin forKey:@"islogin"];
//        [defaults setObject:nil forKey:@"uid"];
//        [defaults setObject:nil forKey:@"userImage"];
//        [defaults setObject:nil forKey:@"token"];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"loginout" object:nil];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"reload" object:nil];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"backloginout" object:nil];
//
//    }
//
//
//}
//- (void)didRemovedFromServer
//{
//    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:NO completion:^(NSDictionary *info, EMError *error) {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"loginUserRemoveFromServer", @"your account has been removed from the server side") delegate:self cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
//        alertView.tag = 101;
//        [alertView show];
//    } onQueue:nil];
//}
#pragma mark - call

//- (BOOL)canRecord
//{
//    __block BOOL bCanRecord = YES;
//    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
//    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)
//    {
//        if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
//            [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
//                bCanRecord = granted;
//            }];
//        }
//    }
//
//    if (!bCanRecord) {
//        UIAlertView * alt = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"setting.microphoneNoAuthority", @"No microphone permissions") message:NSLocalizedString(@"setting.microphoneAuthority", @"Please open in \"Setting\"-\"Privacy\"-\"Microphone\".") delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"ok", @"OK"), nil];
//        [alt show];
//    }
//
//    return bCanRecord;
//}

//- (void)callOutWithChatter:(NSNotification *)notification
//{
//    id object = notification.object;
//    if ([object isKindOfClass:[NSDictionary class]]) {
//        if (![self canRecord]) {
//            return;
//        }
//
//        EMError *error = nil;
//        NSString *chatter = [object objectForKey:@"chatter"];
//        EMCallSessionType type = [[object objectForKey:@"type"] intValue];
//        EMCallSession *callSession = nil;
//        if (type == eCallSessionTypeAudio) {
//            callSession = [[EaseMob sharedInstance].callManager asyncMakeVoiceCall:chatter timeout:50 error:&error];
//        }
//        else if (type == eCallSessionTypeVideo){
//            if (![CallViewController canVideo]) {
//                return;
//            }
//            callSession = [[EaseMob sharedInstance].callManager asyncMakeVideoCall:chatter timeout:50 error:&error];
//        }
//
//        if (callSession && !error) {
//            [[EaseMob sharedInstance].callManager removeDelegate:self];
//
//            CallViewController *callController = [[CallViewController alloc] initWithSession:callSession isIncoming:NO];
//            callController.modalPresentationStyle = UIModalPresentationOverFullScreen;
//            [self presentViewController:callController animated:NO completion:nil];
//        }
//
//        if (error) {
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error", @"error") message:error.description delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
//            [alertView show];
//        }
//    }
//}

//- (void)callControllerClose:(NSNotification *)notification
//{
//    //    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
//    //    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
//    //    [audioSession setActive:YES error:nil];
//
//    [[EaseMob sharedInstance].callManager addDelegate:self delegateQueue:nil];
//}


#pragma mark - ICallManagerDelegate

//- (void)callSessionStatusChanged:(EMCallSession *)callSession changeReason:(EMCallStatusChangedReason)reason error:(EMError *)error
//{
//    if (callSession.status == eCallSessionStatusConnected)
//    {
//        EMError *error = nil;
//        do {
//            BOOL isShowPicker = [[[NSUserDefaults standardUserDefaults] objectForKey:@"isShowPicker"] boolValue];
//            if (isShowPicker) {
//                error = [EMError errorWithCode:EMErrorInitFailure andDescription:NSLocalizedString(@"call.initFailed", @"Establish call failure")];
//                break;
//            }
//
//            if (![self canRecord]) {
//                error = [EMError errorWithCode:EMErrorInitFailure andDescription:NSLocalizedString(@"call.initFailed", @"Establish call failure")];
//                break;
//            }
//
//#warning 在后台不能进行视频通话
//            if(callSession.type == eCallSessionTypeVideo && ([[UIApplication sharedApplication] applicationState] != UIApplicationStateActive || ![CallViewController canVideo])){
//                error = [EMError errorWithCode:EMErrorInitFailure andDescription:NSLocalizedString(@"call.initFailed", @"Establish call failure")];
//                break;
//            }
//
//            if (!isShowPicker){
//                [[EaseMob sharedInstance].callManager removeDelegate:self];
//                CallViewController *callController = [[CallViewController alloc] initWithSession:callSession isIncoming:YES];
//                callController.modalPresentationStyle = UIModalPresentationOverFullScreen;
//                [self presentViewController:callController animated:NO completion:nil];
//                if ([self.navigationController.topViewController isKindOfClass:[ChatViewController class]])
//                {
//                    ChatViewController *chatVc = (ChatViewController *)self.navigationController.topViewController;
//                    chatVc.isInvisible = YES;
//                }
//            }
//        } while (0);
//
//        if (error) {
//            [[EaseMob sharedInstance].callManager asyncEndCall:callSession.sessionId reason:eCallReasonHangup];
//            return;
//        }
//    }
//}



//- (void)networkChanged:(EMConnectionState)connectionState
//{
//    _connectionState = connectionState;
//    [_chatListVC networkChanged:connectionState];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"ChatMainViewController"];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"ChatMainViewController"];
    NSUInteger _unreadnum=[[EaseMob sharedInstance].chatManager loadTotalUnreadMessagesCountFromDatabase];
    if(_unreadnum)
    {
        [self qiehuan:((UIButton *)[self.view viewWithTag:101])];
    }

    self.tabBarController.tabBar.hidden=YES;
    [[CustomTabbarController sharedManager] tabbarAppear];

    if(![regular isLogin])
    {
        LoginViewController*login=[[LoginViewController alloc] init];
        login.type=@"chat";
        [self presentModalViewController:login animated:YES];
    }
    self.navigationController.navigationBar.subviews[0].subviews[0].hidden = YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
//-(void)setupUnreadMessageCount
//{
//    NSArray *conversations = [[[EaseMob sharedInstance] chatManager] conversations];
//    NSInteger unreadCount = 0;
//    for (EMConversation *conversation in conversations) {
//        unreadCount += conversation.unreadMessagesCount;
//    }
//    if (_chatListVC) {
//        if (unreadCount > 0) {
//            _chatListVC.tabBarItem.badgeValue = [NSString stringWithFormat:@"%i",(int)unreadCount];
//        }else{
//            _chatListVC.tabBarItem.badgeValue = nil;
//        }
//    }
//
//    UIApplication *application = [UIApplication sharedApplication];
//    [application setApplicationIconBadgeNumber:unreadCount];
////    [[NSNotificationCenter defaultCenter] postNotificationName:@"unreadmessage" object:[NSNumber numberWithInteger:unreadCount]];
//}
#pragma mark - ChatViewControllerDelegate

// 根据环信id得到要显示头像路径，如果返回nil，则显示默认头像
//- (NSString *)avatarWithChatter:(NSString *)chatter{
//    //    return @"http://img0.bdstatic.com/img/image/shouye/jianbihua0525.jpg";
//    return nil;
//}
//
//// 根据环信id得到要显示用户名，如果返回nil，则默认显示环信id
//- (NSString *)nickNameWithChatter:(NSString *)chatter{
//    return chatter;
//}
#pragma mark - IChatManagerDelegate 消息变化
// 未读消息数量变化回调
//-(void)didUnreadMessagesCountChanged
//{
//    [self setupUnreadMessageCount];
//}
//- (void)didFinishedReceiveOfflineMessages
//{
//    [self setupUnreadMessageCount];
//}
//- (BOOL)needShowNotification:(NSString *)fromChatter
//{
//    BOOL ret = YES;
//    NSArray *igGroupIds = [[EaseMob sharedInstance].chatManager ignoredGroupIds];
//    for (NSString *str in igGroupIds) {
//        if ([str isEqualToString:fromChatter]) {
//            ret = NO;
//            break;
//        }
//    }
//
//    return ret;
//}

// 收到消息回调
//-(void)didReceiveMessage:(EMMessage *)message
//{
//    BOOL needShowNotification = (message.messageType != eMessageTypeChat) ? [self needShowNotification:message.conversationChatter] : YES;
//    if (needShowNotification) {
//#if !TARGET_IPHONE_SIMULATOR
//
//        BOOL isAppActivity = [[UIApplication sharedApplication] applicationState] == UIApplicationStateActive;
//        if (!isAppActivity) {
//            [self showNotificationWithMessage:message];
//        }else {
//            [self playSoundAndVibration];
//        }
//#endif
//    }
//}
//- (void)showNotificationWithMessage:(EMMessage *)message
//{
//    EMPushNotificationOptions *options = [[EaseMob sharedInstance].chatManager pushNotificationOptions];
//    //发送本地推送
//    UILocalNotification *notification = [[UILocalNotification alloc] init];
//    notification.fireDate = [NSDate date]; //触发通知的时间
//
//    if (options.displayStyle == ePushNotificationDisplayStyle_messageSummary) {
//        id<IEMMessageBody> messageBody = [message.messageBodies firstObject];
//        NSString *messageStr = nil;
//        switch (messageBody.messageBodyType) {
//            case eMessageBodyType_Text:
//            {
//                messageStr = ((EMTextMessageBody *)messageBody).text;
//            }
//                break;
//            case eMessageBodyType_Image:
//            {
//                messageStr = NSLocalizedString(@"message.image", @"Image");
//            }
//                break;
//            case eMessageBodyType_Location:
//            {
//                messageStr = NSLocalizedString(@"message.location", @"Location");
//            }
//                break;
//            case eMessageBodyType_Voice:
//            {
//                messageStr = NSLocalizedString(@"message.voice", @"Voice");
//            }
//                break;
//            case eMessageBodyType_Video:{
//                messageStr = NSLocalizedString(@"message.video", @"Video");
//            }
//                break;
//            default:
//                break;
//        }
//
//        NSString *title = message.from;
//        if (message.messageType == eMessageTypeGroupChat) {
//            NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
//            for (EMGroup *group in groupArray) {
//                if ([group.groupId isEqualToString:message.conversationChatter]) {
//                    title = [NSString stringWithFormat:@"%@(%@)", message.groupSenderName, group.groupSubject];
//                    break;
//                }
//            }
//        }
//        else if (message.messageType == eMessageTypeChatRoom)
//        {
//            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//            NSString *key = [NSString stringWithFormat:@"OnceJoinedChatrooms_%@", [[[EaseMob sharedInstance].chatManager loginInfo] objectForKey:@"username" ]];
//            NSMutableDictionary *chatrooms = [NSMutableDictionary dictionaryWithDictionary:[ud objectForKey:key]];
//            NSString *chatroomName = [chatrooms objectForKey:message.conversationChatter];
//            if (chatroomName)
//            {
//                title = [NSString stringWithFormat:@"%@(%@)", message.groupSenderName, chatroomName];
//            }
//        }
//
////        notification.alertBody = @"您有一条新消息1";
//    }
//    else{
////        notification.alertBody = @"您有一条新消息2";
//    }
//
//#warning 去掉注释会显示[本地]开头, 方便在开发中区分是否为本地推送
//    //notification.alertBody = [[NSString alloc] initWithFormat:@"[本地]%@", notification.alertBody];
//
//    notification.alertAction = NSLocalizedString(@"open", @"Open");
//    notification.timeZone = [NSTimeZone defaultTimeZone];
//    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:self.lastPlaySoundDate];
//    if (timeInterval < kDefaultPlaySoundInterval) {
//        JXLOG(@"skip ringing & vibration %@, %@", [NSDate date], self.lastPlaySoundDate);
//    } else {
//        notification.soundName = UILocalNotificationDefaultSoundName;
//        self.lastPlaySoundDate = [NSDate date];
//    }
//
//    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
//    [userInfo setObject:[NSNumber numberWithInt:message.messageType] forKey:kMessageType];
//
//    NSString *username=nil;
//    NSMutableArray *userarr=[[NSUserDefaults standardUserDefaults] objectForKey:@"users"];
//    for (NSDictionary *dict in userarr) {
//
//        if([[dict objectForKey:@"ease_mob_username"]isEqualToString:message.conversationChatter])
//        {
//
//            username=[dict objectForKey:@"username"];
//        }
//    }
//    if(username==nil)
//    {
//        username=message.conversationChatter;
//    }
//
//    [userInfo setObject:username forKey:kConversationChatter];
//    notification.userInfo = userInfo;
//
//    //发送通知
//    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
//
//}

//- (void)playSoundAndVibration{
//    NSTimeInterval timeInterval = [[NSDate date]
//                                   timeIntervalSinceDate:self.lastPlaySoundDate];
//    if (timeInterval < kDefaultPlaySoundInterval) {
//        //如果距离上次响铃和震动时间太短, 则跳过响铃
//        JXLOG(@"skip ringing & vibration %@, %@", [NSDate date], self.lastPlaySoundDate);
//        return;
//    }
//
//    //保存最后一次响铃时间
//    self.lastPlaySoundDate = [NSDate date];
//
//    // 收到消息时，播放音频
//    [[EMCDDeviceManager sharedInstance] playNewMessageSound];
//    // 收到消息时，震动
//    [[EMCDDeviceManager sharedInstance] playVibration];
//}


@end
