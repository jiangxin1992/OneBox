//
//  NotificationController.m
//  OneBox
//
//  Created by 谢江新 on 15/8/25.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import "NotificationController.h"

#import "MJRefresh.h"

#import "NOTContentViewController.h"

#import "NotificationCell.h"

#import "notificationModel.h"

@interface NotificationController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation NotificationController
{
    UITableView *_tableView;
    NSMutableArray *dataArr;
    NSInteger _page;
    UIView *nofollow;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _page=1;
    dataArr=[[NSMutableArray alloc] init];
    UIBarButtonItem *_btn=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回箭头"] style:UIBarButtonItemStylePlain target:self action:@selector(popviewAction)];
    self.navigationItem.leftBarButtonItem=_btn;
    self.view.backgroundColor= _define_backview_color;
    self.navigationItem.titleView=[regular returnNavView:@"通 知" withmaxwidth:230];
    [self CreateTableview];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(isopen:) name:@"isopen" object:nil];

}
-(void)isopen:(NSNotification *)not
{
    JXLOG(@"%@",not.object);
    for (notificationModel *model in dataArr) {
        if([model.NOT_ID isEqualToString:not.object])
        {
            if(!model.is_readed)
            {
                model.is_readed=YES;
                [_tableView reloadData];
            }
        }
    }

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120*_Scale;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

    if (editingStyle == UITableViewCellEditingStyleDelete) {



         AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

        [manager DELETE:[[NSString alloc] initWithFormat:@"%@/v1/push_messages/%@",DNS,((notificationModel *)dataArr[indexPath.section]).NOT_ID] parameters:@{@"token":[regular getToken]} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *html = operation.responseString;
            NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            if([[dict objectForKey:@"code"] integerValue]==1)
            {

                [dataArr removeObjectAtIndex:indexPath.section];
                [_tableView reloadData];


            }else
            {
                 [[ToolManager sharedManager] alertTitle_Simple:[dict objectForKey:@"message"]];
            }

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
        }];

    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(dataArr.count==0){
        return 0;
    }else
    {
        return dataArr.count;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(dataArr.count==section){
        return 0;
    }else
    {
        return 1;
    }

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(dataArr.count){
    static NSString *cellid=@"cell";
    NotificationCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid ];
    if(!cell)
    {
        cell=[[NotificationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    NSInteger num=indexPath.section;
    notificationModel *model=dataArr[num];
    cell.model =model;

    return cell;
    }

    static NSString *cellid=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid ];
    if(!cell)
    {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 2*_Scale;
}
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.bounds.size.width, 2*_Scale)] ;
    headerView.backgroundColor=_define_backview_color;
    return headerView;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    push subview
    NOTContentViewController *not=[[NOTContentViewController alloc] init];
    not.model=dataArr[indexPath.section];
    [self.navigationController pushViewController:not animated:YES];
}

-(void)CreateTableview
{
    _tableView=[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_margin);
        make.right.mas_equalTo(-_margin);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(self.mas_bottomLayoutGuideTop).with.offset(0);
    }];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=self.view.backgroundColor;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    _tableView.sectionIndexColor = self.view.backgroundColor;

    [self setupRefresh];
    [self CreateNofollowerView];
}
-(void)CreateNofollowerView
{
    nofollow=[[UIView alloc] initWithFrame:CGRectMake(0,(ScreenHeight-330*_Scale)/2.0f+64-kTabBarHeight, ScreenWidth, 330*_Scale)];
    [self.view addSubview:nofollow];
//        nofollow.backgroundColor=[UIColor redColor];

    UIImageView *imageview=[[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(nofollow.frame)-230*_Scale)/2.0f, 0, 230*_Scale, 200*_Scale)];
//        imageview.backgroundColor=[UIColor whiteColor];
    imageview.image=[UIImage imageNamed:@"NoMessage"];
    [nofollow addSubview:imageview];

    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageview.frame), CGRectGetWidth(nofollow.frame), CGRectGetHeight(nofollow.frame)-CGRectGetMaxY(imageview.frame))];
    [nofollow addSubview:label];
    //    label.backgroundColor=[UIColor yellowColor];
    label.font=[regular getFont:13.0f];
//    [label setAttributedText:[regular createAttributeString:@"还没有通知哦～" andFloat:@(2.0)]];
    label.textAlignment=1;
    label.textColor=[UIColor colorWithRed:150.0f/255.0f green:150.0f/255.0f  blue:150.0f/255.0f  alpha:1];
    nofollow.hidden=YES;
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
    [dataArr removeAllObjects];
    [self requestData];
}
- (void)footerRereshing
{
    _page++;
    [self requestData];
}

-(void)requestData
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameter=[[NSDictionary alloc] initWithObjectsAndKeys:[[NSString alloc] initWithFormat:@"%ld",(long)_page],@"page",nil];
    [manager GET:[[NSString alloc] initWithFormat:@"%@%@%@",DNS,@"/v1/push_messages?token=",[regular getToken]] parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *html = operation.responseString;
        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
//        NSDictionary *datadict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSArray *arr=[notificationModel parsingWithArrForModel:data];
        if(arr.count==0)
        {

            if(_page==1)
            {
                nofollow.hidden=NO;
            }

//            [[ToolManager sharedManager] alertTitle_Simple:@"No more schools."];
        }else
        {
            nofollow.hidden=YES;
            [dataArr addObjectsFromArray:arr];
            [_tableView reloadData];

        }

        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
    }];
}
-(void)popviewAction
{
    [self.navigationController popViewControllerAnimated:YES];
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
