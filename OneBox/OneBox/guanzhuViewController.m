//
//  guanzhuViewController.m
//  OneBox
//
//  Created by 谢江新 on 15/8/31.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import "guanzhuViewController.h"

#import "HttpRequestManager.h"
#import "MJRefresh.h"

#import "followerViewController.h"
#import "followingViewController.h"
#import "ChatViewController.h"

#import "UserCell.h"

#import "usermodel.h"

@interface guanzhuViewController ()<UITableViewDataSource,UITableViewDelegate, SWTableViewCellDelegate>

@end

@implementation guanzhuViewController
{
    BOOL _iswillapp;
    UIView *nofollow;
    BOOL _isguanzhu;
    BOOL _isfirstload;
    NSMutableArray *ArrayData;
    UITableView *_tableView;

    NSInteger _page;
    
    NSMutableString *friend_token;
    NSMutableArray *btnarr;
    UIImageView *imageGray;
    NSInteger _rownum;
}
- (void)caseBtn:(UIButton *)btn
{
    JXLOG(@"%@",btnarr);

    usermodel *model=ArrayData[_rownum];
    if (btn.tag == 10000) {

        NSArray *arrLabel =nil;
        if(!_isguanzhu)
        {
            for (UIView *view in btn.subviews) {
                if([view isKindOfClass:[UIImageView class]])
                {

                    ((UIImageView *)view).image=[UIImage imageNamed:@"found_school_2_关闭icon"];
                }
                if([view isKindOfClass:[UILabel class]])
                {
                    [(UILabel *)view setAttributedText:[regular createAttributeString:@"取消关注" andFloat:@(1.0)]];
                }
            }

            UIButton *btn_1=(UIButton *)btnarr[1];
            for (UIView *view in btn_1.subviews) {
                if([view isKindOfClass:[UIImageView class]])
                {

                    ((UIImageView *)view).image=[UIImage imageNamed:@"message_normal"];
                }
            }

            NSString *str=[NSString stringWithFormat:@"%@/v1/follows?token=%@",DNS,[regular getToken]];

            NSDictionary *para = @{@"followable_id":[NSString stringWithFormat:@"%@",model.user_id],@"followable_type":@"user"};
            AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];

            [manager POST:str parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
                //                JXLOG(@"%@",responseObject);
                [regular removeProgress];
                id res = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                JXLOG(@"%@",res);
                if ([res[@"code"] integerValue] == 1) {

                    _isguanzhu=YES;
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

                 [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
            }];



        }else
        {
            [ArrayData removeObjectAtIndex:_rownum];
            [_tableView reloadData];
            [self xiaoshi];
            arrLabel = @[@"取消关注",@"Message"];
            for (UIView *view in btn.subviews) {
                if([view isKindOfClass:[UIImageView class]])
                {

                    ((UIImageView *)view).image=[UIImage imageNamed:@"box_choose_添加1"];
                }
                if([view isKindOfClass:[UILabel class]])
                {
                    [(UILabel *)view setAttributedText:[regular createAttributeString:@"关注" andFloat:@(1.0)]];
                }
            }

            UIButton *btn_1=(UIButton *)btnarr[1];
            for (UIView *view in btn_1.subviews) {
                if([view isKindOfClass:[UIImageView class]])
                {

                    ((UIImageView *)view).image=[UIImage imageNamed:@"message_select"];
                }
            }

            NSString *str=[NSString stringWithFormat:@"%@/v1/follows/cancel?token=%@",DNS,[regular getToken]];

            NSDictionary *para = @{@"followable_id":[NSString stringWithFormat:@"%@",model.user_id],@"followable_type":@"user"};
            AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];

            [manager POST:str parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
                //                JXLOG(@"%@",responseObject);
                [regular removeProgress];
                id res = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                JXLOG(@"%@",res);
                if ([res[@"code"] integerValue] == 1) {
                    _isguanzhu=NO;

                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

                 [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
            }];
        }
    }
    else
    {
        if(_isguanzhu)
        {

            [[self.view.window viewWithTag:1000] removeFromSuperview];
             [[NSNotificationCenter defaultCenter ] postNotificationName:@"pushChatView1" object:(usermodel *)ArrayData[_rownum]];
            
        }else
        {
            [[ToolManager sharedManager] alertTitle_Simple:@"关注之后才能聊天哦～"];
        }
        
        
    }
    
}
-(void)xiaoshi
{
    [[self.view.window viewWithTag:1000] removeFromSuperview];
}
-(void)backaction:(UIGestureRecognizer *)ges
{

}
-(void)friend_list:(UIGestureRecognizer *)ges
{
    if(ges.view.tag==6000)
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"following" object:friend_token];

        [self xiaoshi];


    }else
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"follower" object:friend_token];

        [self xiaoshi];
        
    }
}
-(void)CreateNofollowerView
{
    nofollow=[[UIView alloc] initWithFrame:CGRectMake(0,(ScreenHeight-330*_Scale)/2.0f-kTabBarHeight-80*_Scale, ScreenWidth, 330*_Scale)];
    [self.view addSubview:nofollow];

    UIImageView *imageview=[[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(nofollow.frame)-200*_Scale)/2.0f, 0, 200*_Scale, 233*_Scale)];
    imageview.image=[UIImage imageNamed:@"NoUser"];
    [nofollow addSubview:imageview];

    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageview.frame), CGRectGetWidth(nofollow.frame), CGRectGetHeight(nofollow.frame)-CGRectGetMaxY(imageview.frame))];
    [nofollow addSubview:label];
    label.font=[regular getFont:13.0f];
    label.textAlignment=1;
    label.textColor=[UIColor colorWithRed:150.0f/255.0f green:150.0f/255.0f  blue:150.0f/255.0f  alpha:1];
    nofollow.hidden=YES;
}

-(void)refreshList
{
    [self headerRereshing];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _iswillapp=NO;

    _isfirstload=YES;

    [self PrepareData];
    [self CreateTableview];
    [self CreateNofollowerView];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backloginout) name:@"backloginout" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshList) name:@"RefreshChatList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshList) name:@"selectmap" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateImg) name:@"updateImg" object:nil];
}
-(void)updateImg
{
    [ArrayData removeAllObjects];
    [_tableView.mj_header beginRefreshing];
}
-(void)backloginout
{
    _page=1;
    [ArrayData removeAllObjects];
    [_tableView reloadData];

}
-(void)CreateTableview
{

    _tableView=[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.top.mas_equalTo(0);
        make.width.mas_equalTo(ScreenWidth);
    }];
    _tableView.userInteractionEnabled=YES;
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    _tableView.sectionIndexColor = self.view.backgroundColor;
    _tableView.backgroundColor=_define_backview_color;
    _tableView.showsVerticalScrollIndicator=NO;
    [self setupRefresh];

}
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    WeakSelf(ws);
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [ws headerRereshing];
    }];
    _tableView.mj_header = header;
    _tableView.mj_header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;

    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [ws footerRereshing];
    }];

    [_tableView.mj_header beginRefreshing];
}
#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    nofollow.hidden=YES;
    _page=1;
    [ArrayData removeAllObjects];
    [self RequestData];
}
- (void)footerRereshing
{
    _page++;
    [self RequestData];
}

#pragma mark-tablebview代理方法
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)] ;
    [headerView setBackgroundColor:self.view.backgroundColor];
    return headerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 2*_Scale;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(ArrayData.count){

    return ArrayData.count;
    }
    return 0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    usermodel *modle =(usermodel *)ArrayData[indexPath.section];
    if(modle.is_block2==1)
    {
        [[NSNotificationCenter defaultCenter ] postNotificationName:@"pushChatView1" object:(usermodel *)ArrayData[indexPath.section]];
    }else
    {

        [[ToolManager sharedManager] alertTitle_Simple:@"您已被对方拉黑"];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160*_Scale;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(ArrayData.count){
    static NSString *cellid=@"cell";
    NSMutableArray *leftUtilityButtons = [NSMutableArray new];
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];

    NSString *_blocktitle=nil;
    NSInteger _is_block1=((usermodel *)ArrayData[indexPath.section]).is_block1;
    if(_is_block1==1)
    {
        _blocktitle=@"拉黑";
    }else
    {
        _blocktitle=@"取消拉黑";
    }
    [rightUtilityButtons addUtilityButtonWithColor:
     [UIColor colorWithRed:95.0f/255.0f green:213.0f/255.0f blue:174.0f/255.0f alpha:1.0]
                                             title:_blocktitle];
    [rightUtilityButtons addUtilityButtonWithColor:
     [UIColor colorWithRed:242.0f/255.0f green:107.0f/255.0f blue:85.0f/255.0f alpha:1.0f]
                                             title:@"取消关注"];

    UserCell *cell = [[UserCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                           reuseIdentifier:cellid
                       containingTableView:_tableView // Used for row height and selection
                        leftUtilityButtons:leftUtilityButtons
                       rightUtilityButtons:rightUtilityButtons];
    cell.delegate = self;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.dict=[[NSDictionary alloc] initWithObjectsAndKeys:ArrayData[indexPath.section],@"data",[NSNumber numberWithInteger:indexPath.section ],@"num",nil];
    return cell;
    }
    static NSString *cellid=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid ];

    if(!cell)
    {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];

    }
    cell.backgroundColor=self.view.backgroundColor;
    return cell;

}
- (void)swippableTableViewCell:(UserCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
//    1正常 0拉黑
    switch (index) {
        case 0:
        {

            NSIndexPath *indexPathAll = [_tableView indexPathForCell:cell];
            usermodel *model=ArrayData[indexPathAll.section];


             AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            NSDictionary *parameters=[[NSDictionary alloc] initWithObjectsAndKeys:[regular getToken],@"token",model.user_id,@"user_id",@"user",@"followable_type",@"following",@"block_type",nil];
            [manager POST:[[NSString alloc] initWithFormat:@"%@/v1/follows/change_block",DNS] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSString *html = operation.responseString;
                NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
                if([[dict objectForKey:@"code"] intValue]==1)
                {
                    [[EaseMob sharedInstance].chatManager removeConversationByChatter:model.ease_mob_username deleteMessages:YES append2Chat:YES];
                    if(model.is_block1==1)
                    {
                        model.is_block1=0;
                    }else
                    {
                        model.is_block1=1;
                    }
                    JXLOG(@"%@",ArrayData);
                    [_tableView reloadData];

                    JXLOG(@"1111");
                }else
                {
                     [[ToolManager sharedManager] alertTitle_Simple:[dict objectForKey:@"message"]];
                }

            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
            }];
            break;
        }
        case 1:
        {


            NSIndexPath *indexPathAll = [_tableView indexPathForCell:cell];
            usermodel *model=ArrayData[indexPathAll.section];
            [ArrayData removeObjectAtIndex:indexPathAll.section];
            [_tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPathAll.section]  withRowAnimation:UITableViewRowAnimationFade];
            if(!ArrayData.count)
            {
                nofollow.hidden=NO;
            }else
            {
                nofollow.hidden=YES;
            }

            NSString *str=[NSString stringWithFormat:@"%@/v1/follows/cancel?token=%@",DNS,[regular getToken]];
    
            NSDictionary *para = @{@"followable_id":[NSString stringWithFormat:@"%@",model.user_id],@"followable_type":@"user"};
            AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
            [manager POST:str parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
                //                JXLOG(@"%@",responseObject);
                [regular removeProgress];
                id res = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                JXLOG(@"%@",res);
                if ([res[@"code"] integerValue] == 1) {

                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

                [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
            }];


            break;
        }
        default:
            break;
    }
}

-(void)PrepareData
{
    friend_token=[[NSMutableString alloc] init];
    btnarr=[[NSMutableArray alloc] init];
    _page=1;
self.view.backgroundColor=_define_backview_color;
    ArrayData=[[NSMutableArray alloc] init];
}

-(void)RequestData
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters=[[NSDictionary alloc] initWithObjectsAndKeys:[regular getToken],@"token",[[NSString alloc] initWithFormat:@"%ld",(long)_page],@"page",nil];
    [manager GET:[[NSString alloc] initWithFormat:@"%@/v1/chats/followings",DNS] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *html = operation.responseString;
        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];

        if([[dict objectForKey:@"code"] integerValue]==1)
        {
            NSInteger _oldcount=ArrayData.count;
            BOOL _isshuaxin;

            if(_page==1)
            {
                [ArrayData removeAllObjects];
            }
            NSArray *getarr=[usermodel parsingData:dict];
            if(getarr.count>0)
            {
                if(ArrayData.count>0&&_page==1)
                {

                }else
                {
                    [ArrayData addObjectsFromArray:getarr];
                    nofollow.hidden=YES;

                }
            }else
            {

            }

            if(ArrayData.count==0)
            {
                nofollow.hidden=NO;
            }

            if(_oldcount==ArrayData.count)
            {
                _isshuaxin=NO;
            }else
            {
                _isshuaxin=YES;
            }

            if(_iswillapp&&(!_isshuaxin)&&(ArrayData.count>0))
            {

                NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
                [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];

            }else
            {
                [_tableView reloadData];
            }

            for (int i=0; i<ArrayData.count; i++) {

                usermodel *model=(usermodel *)ArrayData[i];
                if(!model.is_block1||!model.is_block2)
                {
                    [[EaseMob sharedInstance].chatManager removeConversationByChatter:model.ease_mob_username deleteMessages:YES append2Chat:YES];
                }
            }
            
            
        }else
        {
//            [[ToolManager sharedManager] alertTitle_Simple:[dict objectForKey:@"message"]];
        }

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_tableView.mj_header endRefreshing];
            [_tableView.mj_footer endRefreshing];
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"guanzhuViewController"];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"guanzhuViewController"];
    nofollow.hidden=YES;
    
    _page=1;
    if(_isfirstload)
    {
        _isfirstload=NO;
    }else
    {
        _iswillapp=YES;
        [self RequestData];
    }
}

@end
