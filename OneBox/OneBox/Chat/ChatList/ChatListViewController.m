/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import "ChatListViewController.h"

#import "NSDate+Category.h"
#import "RealtimeSearchUtil.h"
#import "ConvertToCommonEmoticonsHelper.h"
#import "RobotManager.h"

#import "ChatViewController.h"
#import "EMSearchDisplayController.h"

#import "SRRefreshView.h"
#import "ChatListCell.h"
#import "EMSearchBar.h"

#import "usermodel.h"

@interface ChatListViewController ()<UITableViewDelegate,UITableViewDataSource, UISearchDisplayDelegate,SRRefreshDelegate, UISearchBarDelegate, IChatManagerDelegate,ChatViewControllerDelegate>

@property (strong, nonatomic) NSMutableArray        *dataSource;

@property (strong, nonatomic) UITableView           *tableView;
@property (nonatomic, strong) EMSearchBar           *searchBar;
@property (nonatomic, strong) SRRefreshView         *slimeView;
@property (nonatomic, strong) UIView                *networkStateView;

@property (strong, nonatomic) EMSearchDisplayController *searchController;

@end

@implementation ChatListViewController
{
    NSMutableArray *turearr;
    UIView *nofollow;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _dataSource = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=_define_backview_color;
    turearr=[[NSMutableArray alloc] init];
    [[EaseMob sharedInstance].chatManager loadAllConversationsFromDatabaseWithAppend2Chat:NO];
    [self removeEmptyConversationsFromDB];

    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.tableView];
    [self.tableView addSubview:self.slimeView];
    [self networkStateView];

//    [self searchController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];

    [self refreshDataSource];
    [self registerNotifications];
    [MobClick beginLogPageView:@"ChatListViewController"];

}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self unregisterNotifications];
    [MobClick endLogPageView:@"ChatListViewController"];
}

- (void)removeEmptyConversationsFromDB
{
    NSArray *conversations = [[EaseMob sharedInstance].chatManager conversations];
    NSMutableArray *needRemoveConversations;
    for (EMConversation *conversation in conversations) {
        if (!conversation.latestMessage || (conversation.conversationType == eConversationTypeChatRoom)) {
            if (!needRemoveConversations) {
                needRemoveConversations = [[NSMutableArray alloc] initWithCapacity:0];
            }
            
            [needRemoveConversations addObject:conversation.chatter];
        }
    }
    
    if (needRemoveConversations && needRemoveConversations.count > 0) {
        [[EaseMob sharedInstance].chatManager removeConversationsByChatters:needRemoveConversations
                                                             deleteMessages:YES
                                                                append2Chat:NO];
    }
}

- (void)removeChatroomConversationsFromDB
{
    NSArray *conversations = [[EaseMob sharedInstance].chatManager conversations];
    NSMutableArray *needRemoveConversations;
    for (EMConversation *conversation in conversations) {
        if (conversation.conversationType == eConversationTypeChatRoom) {
            if (!needRemoveConversations) {
                needRemoveConversations = [[NSMutableArray alloc] initWithCapacity:0];
            }
            
            [needRemoveConversations addObject:conversation.chatter];
        }
    }
    
    if (needRemoveConversations && needRemoveConversations.count > 0) {
        [[EaseMob sharedInstance].chatManager removeConversationsByChatters:needRemoveConversations
                                                             deleteMessages:YES
                                                                append2Chat:NO];
    }
}

#pragma mark - getter

- (SRRefreshView *)slimeView
{
    if (!_slimeView) {
        _slimeView = [[SRRefreshView alloc] init];
        _slimeView.delegate = self;
        _slimeView.upInset = 0;
        _slimeView.slimeMissWhenGoingBack = YES;
        _slimeView.slime.bodyColor = [UIColor grayColor];
        _slimeView.slime.skinColor = [UIColor grayColor];
        _slimeView.slime.lineWith = 1;
        _slimeView.slime.shadowBlur = 4;
        _slimeView.slime.shadowColor = [UIColor grayColor];
        _slimeView.backgroundColor = [UIColor whiteColor];
    }
    
    return _slimeView;
}

- (UISearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[EMSearchBar alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, 44)];
        _searchBar.delegate = self;
        _searchBar.placeholder = NSLocalizedString(@"search", @"Search");
        _searchBar.backgroundColor = [UIColor colorWithRed:0.747 green:0.756 blue:0.751 alpha:1.000];
    }
    
    return _searchBar;
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-400 ) style:UITableViewStylePlain];
        _tableView.backgroundColor = _define_backview_color;
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[ChatListCell class] forCellReuseIdentifier:@"chatListCell"];
        _tableView.backgroundColor=self.view.backgroundColor;
        [self CreateNofollowerView];
    }
    return _tableView;
}


-(void)CreateNofollowerView
{
    nofollow=[[UIView alloc] initWithFrame:CGRectMake(0,(ScreenHeight-330*_Scale)/2.0f-kTabBarHeight, ScreenWidth, 330*_Scale)];
    [_tableView addSubview:nofollow];
//    nofollow.backgroundColor=[UIColor redColor];

    UIImageView *imageview=[[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(nofollow.frame)-230*_Scale)/2.0f, 0, 230*_Scale, 200*_Scale)];
//    imageview.backgroundColor=[UIColor whiteColor];
    imageview.image=[UIImage imageNamed:@"NoMessage"];
    [nofollow addSubview:imageview];

    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageview.frame), CGRectGetWidth(nofollow.frame), CGRectGetHeight(nofollow.frame)-CGRectGetMaxY(imageview.frame))];
    [nofollow addSubview:label];
//    label.backgroundColor=[UIColor yellowColor];
    label.font=[regular getFont:13.0f];
//    [label setAttributedText:[regular createAttributeString:@"没有消息" andFloat:@(2.0)]];
    label.textAlignment=1;
    label.textColor=[UIColor colorWithRed:150.0f/255.0f green:150.0f/255.0f  blue:150.0f/255.0f  alpha:1];
    nofollow.hidden=YES;
}
//- (EMSearchDisplayController *)searchController
//{
//    if (_searchController == nil) {
//        _searchController = [[EMSearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
//        _searchController.delegate = self;
//        _searchController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        
//        __weak ChatListViewController *weakSelf = self;
//        [_searchController setCellForRowAtIndexPathCompletion:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
//            static NSString *CellIdentifier = @"ChatListCell";
//            ChatListCell *cell = (ChatListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//            
//            // Configure the cell...
//            if (cell == nil) {
//                cell = [[ChatListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//            }
//            
//            EMConversation *conversation = [weakSelf.searchController.resultsSource objectAtIndex:indexPath.row];
//            cell.name = conversation.chatter;
//            if (conversation.conversationType == eConversationTypeChat) {
//                if ([[RobotManager sharedInstance] isRobotWithUsername:conversation.chatter]) {
//                    cell.name = [[RobotManager sharedInstance] getRobotNickWithUsername:conversation.chatter];
//                }
//                cell.placeholderImage = [UIImage imageNamed:@"chatListCellHead.png"];
//            }
//            else{
//                NSString *imageName = @"groupPublicHeader";
//                NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
//                for (EMGroup *group in groupArray) {
//                    if ([group.groupId isEqualToString:conversation.chatter]) {
//                        cell.name = group.groupSubject;
//                        imageName = group.isPublic ? @"groupPublicHeader" : @"groupPrivateHeader";
//                        break;
//                    }
//                }
//                cell.placeholderImage = [UIImage imageNamed:imageName];
//            }
//            cell.detailMsg = [weakSelf subTitleMessageByConversation:conversation];
//            cell.time = [weakSelf lastMessageTimeByConversation:conversation];
//            cell.unreadCount = [weakSelf unreadMessageCountByConversation:conversation];
//            if (indexPath.row % 2 == 1) {
//                cell.contentView.backgroundColor = RGBACOLOR(246, 246, 246, 1);
//            }else{
//                cell.contentView.backgroundColor = [UIColor whiteColor];
//            }
//            return cell;
//        }];
//        
//        [_searchController setHeightForRowAtIndexPathCompletion:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
//            return [ChatListCell tableView:tableView heightForRowAtIndexPath:indexPath];
//        }];
//        
//        [_searchController setDidSelectRowAtIndexPathCompletion:^(UITableView *tableView, NSIndexPath *indexPath) {
//            [tableView deselectRowAtIndexPath:indexPath animated:YES];
//            [weakSelf.searchController.searchBar endEditing:YES];
//            
//            EMConversation *conversation = [weakSelf.searchController.resultsSource objectAtIndex:indexPath.row];
//            ChatViewController *chatVC = [[ChatViewController alloc] initWithChatter:conversation.chatter conversationType:conversation.conversationType];
//            chatVC.title = conversation.chatter;
//            [weakSelf.navigationController pushViewController:chatVC animated:YES];
//        }];
//    }
//    
//    return _searchController;
//}

- (UIView *)networkStateView
{
    if (_networkStateView == nil) {
        _networkStateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 44)];
        _networkStateView.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:199 / 255.0 blue:199 / 255.0 alpha:0.5];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, (_networkStateView.frame.size.height - 20) / 2, 20, 20)];
        imageView.image = [UIImage imageNamed:@"messageSendFail"];
        [_networkStateView addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 5, 0, _networkStateView.frame.size.width - (CGRectGetMaxX(imageView.frame) + 15), _networkStateView.frame.size.height)];
        label.font = [regular get_en_Font:15.0f];
        label.textColor = [UIColor grayColor];
        label.backgroundColor = [UIColor clearColor];
        label.text = NSLocalizedString(@"network.disconnection", @"Network disconnection");
        [_networkStateView addSubview:label];
    }
    
    return _networkStateView;
}

#pragma mark - private

- (NSMutableArray *)loadDataSource
{
    NSMutableArray *ret = nil;
    NSArray *conversations = [[EaseMob sharedInstance].chatManager conversations];

    NSArray* sorte = [conversations sortedArrayUsingComparator:
           ^(EMConversation *obj1, EMConversation* obj2){
               EMMessage *message1 = [obj1 latestMessage];
               EMMessage *message2 = [obj2 latestMessage];
               if(message1.timestamp > message2.timestamp) {
                   return(NSComparisonResult)NSOrderedAscending;
               }else {
                   return(NSComparisonResult)NSOrderedDescending;
               }
           }];
    ret = [[NSMutableArray alloc] initWithArray:sorte];

    return ret;
}

// 得到最后消息时间
-(NSString *)lastMessageTimeByConversation:(EMConversation *)conversation
{
    NSString *ret = @"";
    EMMessage *lastMessage = [conversation latestMessage];;
    if (lastMessage) {
        ret = [NSDate formattedTimeFromTimeInterval:lastMessage.timestamp];
    }
    
    return ret;
}

// 得到未读消息条数
- (NSInteger)unreadMessageCountByConversation:(EMConversation *)conversation
{
    NSInteger ret = 0;
    ret = conversation.unreadMessagesCount;
    
    return  ret;
}

// 得到最后消息文字或者类型
-(NSString *)subTitleMessageByConversation:(EMConversation *)conversation
{
    NSString *ret = @"";
    EMMessage *lastMessage = [conversation latestMessage];
    if (lastMessage) {
        id<IEMMessageBody> messageBody = lastMessage.messageBodies.lastObject;
        switch (messageBody.messageBodyType) {
            case eMessageBodyType_Image:{
                ret = NSLocalizedString(@"message.image1", @"[image]");
            } break;
            case eMessageBodyType_Text:{
                // 表情映射。
                NSString *didReceiveText = [ConvertToCommonEmoticonsHelper
                                            convertToSystemEmoticons:((EMTextMessageBody *)messageBody).text];
                if ([[RobotManager sharedInstance] isRobotMenuMessage:lastMessage]) {
                    ret = [[RobotManager sharedInstance] getRobotMenuMessageDigest:lastMessage];
                } else {
                    ret = didReceiveText;
                }
            } break;
            case eMessageBodyType_Voice:{
                ret = NSLocalizedString(@"message.voice1", @"[voice]");
            } break;
            case eMessageBodyType_Location: {
                ret = NSLocalizedString(@"message.location1", @"[location]");
            } break;
            case eMessageBodyType_Video: {
                ret = NSLocalizedString(@"message.video1", @"[video]");
            } break;
            default: {
            } break;
        }
    }
    
    return ret;
}

#pragma mark - TableViewDelegate & TableViewDatasource

-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identify = @"chatListCell";
    ChatListCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    if (!cell) {
        cell = [[ChatListCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identify];
    }
    EMConversation *conversation = [self.dataSource objectAtIndex:indexPath.row] ;
//    cell.name = conversation.chatter;
    if (conversation.conversationType == eConversationTypeChat) {
        if ([[RobotManager sharedInstance] isRobotWithUsername:conversation.chatter]) {
            cell.name = [[RobotManager sharedInstance] getRobotNickWithUsername:conversation.chatter];
        }
        cell.placeholderImage = [UIImage imageNamed:@"headImg_login1"];
    }
    else{
        NSString *imageName = @"groupPublicHeader";
        if (![conversation.ext objectForKey:@"groupSubject"] || ![conversation.ext objectForKey:@"isPublic"])
        {
            NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
            for (EMGroup *group in groupArray) {
                if ([group.groupId isEqualToString:conversation.chatter]) {
                    cell.name = group.groupSubject;
                    imageName = group.isPublic ? @"groupPublicHeader" : @"groupPrivateHeader";

                    NSMutableDictionary *ext = [NSMutableDictionary dictionaryWithDictionary:conversation.ext];
                    [ext setObject:group.groupSubject forKey:@"groupSubject"];
                    [ext setObject:[NSNumber numberWithBool:group.isPublic] forKey:@"isPublic"];
                    conversation.ext = ext;
                    break;
                }
            }
        }
        else
        {

            cell.name = [conversation.ext objectForKey:@"groupSubject"];
            imageName = [[conversation.ext objectForKey:@"isPublic"] boolValue] ? @"groupPublicHeader" : @"groupPrivateHeader";
        }
        cell.placeholderImage = [UIImage imageNamed:imageName];
    }

//conversation



    for (usermodel *model in turearr) {

        NSString *_sss=nil;
        NSString *chatname=[[NSUserDefaults standardUserDefaults] objectForKey:@"chatname"];
        if([conversation.latestMessage.from isEqualToString:chatname])
        {
            _sss=conversation.latestMessage.to;
        }else
        {
            _sss=conversation.latestMessage.from;
        }

        if([model.ease_mob_username isEqualToString:_sss])
        {
            cell.name = model.username;
            cell.imagename=model.avatar;
            break;
        }

    }


    JXLOG(@"%@   %@",[self subTitleMessageByConversation:conversation],[self lastMessageTimeByConversation:conversation]);
    cell.detailMsg = [self subTitleMessageByConversation:conversation];
    cell.time = [self lastMessageTimeByConversation:conversation];
    cell.unreadCount = [self unreadMessageCountByConversation:conversation];

    cell.contentView.backgroundColor = [UIColor whiteColor];

    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.dataSource.count==0)
    {

        nofollow.hidden=NO;

    }else
    {

        nofollow.hidden=YES;

    }
    return  self.dataSource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [ChatListCell tableView:tableView heightForRowAtIndexPath:indexPath];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 2*_Scale;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section;
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 2*_Scale)] ;
    headerView.backgroundColor=_define_backview_color;
    return headerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0*_Scale;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    JXLOG(@"%@",turearr);
    JXLOG(@" %d",indexPath.row);
    if(turearr.count)
    {
        NSDictionary *__ddd=[[NSDictionary alloc] initWithObjectsAndKeys:(EMConversation *)[self.dataSource objectAtIndex:indexPath.row],@"con",[turearr objectAtIndex:indexPath.row],@"title",nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"pushChatView" object:__ddd];

    }

}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        EMConversation *converation = [self.dataSource objectAtIndex:indexPath.row] ;
        [[EaseMob sharedInstance].chatManager removeConversationByChatter:converation.chatter deleteMessages:YES append2Chat:YES];
        [self.dataSource removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        if([self.dataSource count]==0)
        {
//            self.view.backgroundColor=[UIColor darkGrayColor];
            nofollow.hidden=NO;
        }else
        {
//            self.view.backgroundColor=[UIColor whiteColor];
            nofollow.hidden=YES;
        }

    }

}


#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
    
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    __weak typeof(self) weakSelf = self;
    [[RealtimeSearchUtil currentUtil] realtimeSearchWithSource:self.dataSource searchText:(NSString *)searchText collationStringSelector:@selector(chatter) resultBlock:^(NSArray *results) {
        if (results) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.searchController.resultsSource removeAllObjects];
                [weakSelf.searchController.resultsSource addObjectsFromArray:results];
                [weakSelf.searchController.searchResultsTableView reloadData];
            });
        }
    }];
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    [[RealtimeSearchUtil currentUtil] realtimeSearchStop];
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}

#pragma mark - scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_slimeView scrollViewDidScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_slimeView scrollViewDidEndDraging];
}

#pragma mark - slimeRefresh delegate
//刷新消息列表
- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    [self refreshDataSource];
    [_slimeView endRefresh];
}

#pragma mark - IChatMangerDelegate

-(void)didUnreadMessagesCountChanged
{
    [self refreshDataSource];
}

- (void)didUpdateGroupList:(NSArray *)allGroups error:(EMError *)error
{
    [self refreshDataSource];
}

#pragma mark - registerNotifications
-(void)registerNotifications{
    [self unregisterNotifications];
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
}

-(void)unregisterNotifications{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}

- (void)dealloc{
    [self unregisterNotifications];
}

#pragma mark - public

-(void)refreshDataSource
{
    NSMutableArray *muarr=[self loadDataSource];
    [self.dataSource removeAllObjects];
    self.dataSource =muarr;

     AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];


    NSMutableString *_uuids=[[NSMutableString alloc] init];
    for (int i=0; i<muarr.count; i++) {

        EMConversation *_con=muarr[i];

//_con.chatter

        NSString *_sss=nil;
        NSString *chatname=[[NSUserDefaults standardUserDefaults] objectForKey:@"chatname"];
        if([_con.latestMessage.from isEqualToString:chatname])
        {
            _sss=_con.latestMessage.to;
        }else
        {
            _sss=_con.latestMessage.from;
        }

        if(i!=(muarr.count-1))
        {
            [_uuids appendFormat:[[NSString alloc] initWithFormat:@"%@,",_sss]];
        }else
        {
            [_uuids appendString:_sss];
        }

    }

    [manager POST:[[NSString alloc] initWithFormat:@"%@/v1/users/user_info_for_ease",DNS] parameters:@{@"uuids":_uuids,@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *html = operation.responseString;
        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];


        if([[dict objectForKey:@"code"] intValue]==1)
        {

            [turearr removeAllObjects];
            for (int i=0;i<muarr.count; i++) {
                EMConversation *con=muarr[i];
                usermodel *model=nil;

                for (NSDictionary *__dict in (NSArray *)[dict objectForKey:@"data"]) {

                    NSString *_sss=nil;
                    NSString *chatname=[[NSUserDefaults standardUserDefaults] objectForKey:@"chatname"];
                    if([con.latestMessage.from isEqualToString:chatname])
                    {
                        _sss=con.latestMessage.to;
                    }else
                    {
                        _sss=con.latestMessage.from;
                    }

                    if([[__dict objectForKey:@"ease_mob_username"] isEqualToString:_sss])
                    {
                        model=[usermodel parsingData_single:__dict];

//                        [mutabledict setObject:[__dict objectForKey:@"avatar"] forKey:@"avatar"];
//                        [mutabledict setObject:[__dict objectForKey:@"username"] forKey:@"username"];
//                        [mutabledict setObject:[__dict objectForKey:@"ease_mob_username"] forKey:@"ease_mob_username"];
//                        [mutabledict setObject:[[NSString alloc] initWithFormat:@"%ld",[[__dict objectForKey:@"id"] longValue]] forKey:@"uid"];
//                        cell
//                        is_server

                    }

                }

                [turearr addObject:model];

            }
            [_tableView reloadData];
        }else
        {
             [[ToolManager sharedManager] alertTitle_Simple:[dict objectForKey:@"message"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
        JXLOG(@"失败");

    }];

    [self hideHud];
}

- (void)isConnect:(BOOL)isConnect{
    if (!isConnect) {
        _tableView.tableHeaderView = _networkStateView;
    }
    else{
        _tableView.tableHeaderView = nil;
    }

}

- (void)networkChanged:(EMConnectionState)connectionState
{
    if (connectionState == eEMConnectionDisconnected) {
        _tableView.tableHeaderView = _networkStateView;
    }
    else{
        _tableView.tableHeaderView = nil;
    }
}

- (void)willReceiveOfflineMessages{
    JXLOG(NSLocalizedString(@"message.beginReceiveOffine", @"Begin to receive offline messages"));
}
#pragma mark-收到消息的时候调用
- (void)didReceiveOfflineMessages:(NSArray *)offlineMessages
{
    [self refreshDataSource];
}

- (void)didFinishedReceiveOfflineMessages{
    JXLOG(NSLocalizedString(@"message.endReceiveOffine", @"End to receive offline messages"));
}

#pragma mark - ChatViewControllerDelegate

// 根据环信id得到要显示头像路径，如果返回nil，则显示默认头像
- (NSString *)avatarWithChatter:(NSString *)chatter{
//    return @"http://img0.bdstatic.com/img/image/shouye/jianbihua0525.jpg";
    return nil;
}

// 根据环信id得到要显示用户名，如果返回nil，则默认显示环信id
- (NSString *)nickNameWithChatter:(NSString *)chatter{
    return chatter;
}

@end
