//
//  CollectionSchoolDeleteViewController.m
//  OneBox
//
//  Created by 谢江新 on 15/12/1.
//  Copyright © 2015年 谢江新. All rights reserved.
//

#import "CollectionSchoolDeleteViewController.h"


// c文件 —> 系统文件（c文件在前）

// 控制器
#import "SchoolDetailViewController.h"
#import "CustomTabbarController.h"

// 自定义视图
#import "collectionDelCell.h"

// 接口

// 分类

// 自定义类和三方类（ cocoapods类 > model > 工具类 > 其他）
#import "MJRefresh.h"

#import "FoundModel.h"

#define CellHeight 200*_Scale

@interface CollectionSchoolDeleteViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation CollectionSchoolDeleteViewController
{
    NSMutableArray *dataArray;
    UITableView *_tableView;
    NSInteger _page;
}
#pragma mark - --------------生命周期--------------
- (void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare];
    [self UIConfig];
//    [self RequestData];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"CollectionSchoolDeleteViewController"];

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[CustomTabbarController sharedManager] tabbarHide];

    [MobClick beginLogPageView:@"CollectionSchoolDeleteViewController"];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - --------------SomePrepare--------------
- (void)SomePrepare
{
    [self PrepareData];
    [self PrepareUI];
}
- (void)PrepareData{
    _page=1;
    self.view.backgroundColor=_define_backview_color;
    dataArray=[[NSMutableArray alloc] init];


    UIBarButtonItem *_btn=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回箭头"] style:UIBarButtonItemStylePlain target:self action:@selector(popviewAction)];
    self.navigationItem.leftBarButtonItem=_btn;
}
- (void)PrepareUI{
    self.navigationItem.titleView=[[ToolManager sharedManager] returnNavView:@"心愿单" withmaxwidth:230];
}

#pragma mark - --------------UIConfig----------------------
-(void)UIConfig{
    [self createTableView];
}

-(void)createTableView
{
    _tableView=[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    _tableView.showsVerticalScrollIndicator=YES;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=_define_backview_color;

    [self setupRefresh];
}

#pragma mark 开始进入刷新状态
/**
 *  集成刷新控件
 */
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
- (void)headerRereshing
{
    _page=1;
    [dataArray removeAllObjects];

    [self loadData];
}

- (void)footerRereshing
{
    _page++;
    [self loadData];
}
#pragma mark - --------------请求数据----------------------
//-(void)RequestData{}
-(void)loadData
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    NSString *url=@"/v1/follows";
    NSDictionary *parameters = @{@"token":[regular getToken],@"followable_type":@"school",@"page":[[NSString alloc] initWithFormat:@"%ld",(long)_page]};

    [manager GET:[[NSString alloc] initWithFormat:@"%@%@",DNS,url] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSString *html = operation.responseString;
        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
        if([[dict objectForKey:@"code"] integerValue]==1)
        {

            NSArray *_array=[FoundModel parsingData:dict];
            if(_page==1&&_array.count==0)
            {

                UIView *headview=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 70)];

                UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, 30, ScreenWidth, 30)];

                [label setAttributedText:[regular createAttributeString:@" 你的心愿单是空的，到学校页面点击添加心愿吧。" andFloat:@(2.0)]];
                label.textColor=[UIColor lightGrayColor];
                label.textAlignment=1;
                label.font=[regular getFont:12.0f];
                [headview addSubview:label];
                _tableView.tableHeaderView=headview;

            }else
            {
                _tableView.tableHeaderView=[UIView new];
                [dataArray addObjectsFromArray:_array];
                JXLOG(@"111");
            }


            [_tableView.mj_header endRefreshing];
            [_tableView.mj_footer endRefreshing];
            [_tableView reloadData];


        }else
        {

            [_tableView.mj_header endRefreshing];
            [_tableView.mj_footer endRefreshing];
            [[ToolManager sharedManager] alertTitle_Simple:[dict objectForKey:@"message"]];

        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        JXLOG(@"Error: %@", error);
    }];

}

#pragma mark - --------------系统代理----------------------
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CellHeight;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

        FoundModel *model=dataArray[indexPath.section-1];
        NSDictionary *parameters=@{@"followable_id":model.sid,@"followable_type":@"school",@"token":[regular getToken]};
        [manager POST:[[NSString alloc] initWithFormat:@"%@%@",DNS,@"/v1/follows/cancel"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {

            NSString *html = operation.responseString;
            NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
            if([[dict objectForKey:@"code"] intValue]==1)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"change_num" object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"delete_col" object:[NSNumber numberWithInteger:indexPath.section-1]];
                [dataArray removeObjectAtIndex:indexPath.section-1];

                [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section]withRowAnimation:UITableViewRowAnimationLeft];

                [[NSNotificationCenter defaultCenter] postNotificationName:@"changeCllNum" object:nil];

                if(dataArray.count==0)
                {
                    UIView *headview=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 70)];
                    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, 30, ScreenWidth, 30)];
                    [label setAttributedText:[regular createAttributeString:@" 你的心愿单是空的，到学校页面点击添加心愿吧。" andFloat:@(2.0)]];
                    label.textColor=[UIColor lightGrayColor];
                    label.textAlignment=1;
                    label.font=[regular getFont:12.0f];
                    [headview addSubview:label];
                    _tableView.tableHeaderView=headview;
                }

            }else
            {
                [[ToolManager sharedManager] alertTitle_Simple:[dict objectForKey:@"message"]];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
        }];
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 2*_Scale;
}
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)] ;
    [headerView setBackgroundColor:self.view.backgroundColor];
    return headerView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(dataArray.count==0||(dataArray.count&&section==0))
    {
        return 0;
    }
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(dataArray.count==0)
    {
        return 1;
    }
    return dataArray.count+1;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SchoolDetailViewController *school=[[SchoolDetailViewController alloc] init];
    FoundModel *model=dataArray[indexPath.section-1];
    school.data_dict=[[NSDictionary alloc] initWithObjectsAndKeys:model.cn_name,@"schoolName",model.sid,@"schoolID",[NSNumber numberWithInteger:1],@"is_order_school",nil];
    [self.navigationController pushViewController:school animated:YES];


}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(dataArray.count==0)
    {
        static NSString *cellid=@"cell";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];

        if(!cell)
        {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];

        }
        return cell;
    }
    static NSString *cellid=@"cell";
    collectionDelCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
    if(!cell)
    {
        cell=[[collectionDelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }

    cell.backgroundColor=_define_backview_color;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;

    NSMutableDictionary *__dict=[[NSMutableDictionary alloc] initWithObjectsAndKeys:dataArray[indexPath.section-1],@"model",[NSNumber numberWithInteger:indexPath.section-1],@"rownum",nil];

    cell.dict=__dict;
    //    cell.block=changeBlock;
    return cell;
}

#pragma mark - --------------自定义代理/block----------------------


#pragma mark - --------------自定义响应----------------------
-(void)popviewAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - --------------自定义方法----------------------


#pragma mark - --------------other----------------------

@end
