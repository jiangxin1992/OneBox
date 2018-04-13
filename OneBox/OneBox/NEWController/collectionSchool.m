//
//  collectionSchool.m
//  OneBox
//
//  Created by 谢江新 on 15/3/11.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//
#import "SchoolDetailViewController.h"

#import "MJRefresh.h"

#import "CustomTabbarController.h"

#import "collectionCell.h"

#import "collectionSchool.h"
#import "surveyModel.h"
#import "foundModel.h"

#define CellHeight 200*_Scale

@interface collectionSchool ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation collectionSchool
{

    NSMutableArray *dataArray;
    UITableView *_tableView;
    NSInteger _page;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];



    changeBlock=^(NSInteger rownum)
    {
//        surveyModel *model= dataArray[rownum];

        if([[_dict objectForKey:@"type"] isEqualToString:@"delete"])
        {
                AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            
                foundModel *model=dataArray[rownum];
                NSDictionary *parameters=@{@"followable_id":model.sid,@"followable_type":@"school",@"token":[regular getToken]};
                [manager POST:[[NSString alloc] initWithFormat:@"%@%@",DNS,@"/v1/follows/cancel"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {

                    NSString *html = operation.responseString;
                    NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
                    NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
                    if([[dict objectForKey:@"code"] intValue]==1)
                    {
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"change_num" object:nil];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"delete_col" object:[NSNumber numberWithInteger:rownum]];
                        [dataArray removeObjectAtIndex:rownum];

                        NSArray *_tempIndexPathArr = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:rownum inSection:0]];
        
                        [_tableView deleteRowsAtIndexPaths:_tempIndexPathArr withRowAnimation:UITableViewRowAnimationAutomatic];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeCllNum" object:nil];

                        if(dataArray.count==0)
                        {
                            UIView *headview=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 70)];

                            UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, 30, ScreenWidth, 30)];
                            JXLOG(@"%@",_dict);
                            if([[_dict objectForKey:@"type"] isEqualToString:@"add"])
                            {
                                [label setAttributedText:[regular createAttributeString:@" 你的心愿单是空的，到学校页面点击添加心愿吧。" andFloat:@(2.0)]];

                            }else if([[_dict objectForKey:@"type"] isEqualToString:@"recommend"])
                            {
                                [label setAttributedText:[regular createAttributeString:@" 目前没有合适的学校推荐哈，请更换条件试试吧。" andFloat:@(2.0)]];

                            }

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


        }else if([[_dict objectForKey:@"type"] isEqualToString:@"add"])
        {
            
        }
        
    };
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

    [_tableView.mj_header beginRefreshing];

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
-(void)loadData
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *url=nil;
    NSDictionary *parameters=nil;

    JXLOG(@"%@",[_dict objectForKey:@"type"]);
    if([[_dict objectForKey:@"type"] isEqualToString:@"recommend"])
    {
//        [[NSString alloc] initWithFormat:@"%@%@",DNS,@"/v1/schools"]
        url=@"/v1/schools";
         parameters = [[NSDictionary alloc] initWithDictionary:[_dict objectForKey:@"dict"]];
    }else
    {
        url=@"/v1/follows";
         parameters = @{@"token":[regular getToken],@"followable_type":@"school",@"page":[[NSString alloc] initWithFormat:@"%ld",(long)_page]};
    }

    [manager GET:[[NSString alloc] initWithFormat:@"%@%@",DNS,url] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSString *html = operation.responseString;
        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
        if([[dict objectForKey:@"code"] integerValue]==1)
        {

            NSArray *_array=[foundModel parsingData:dict];
            if(_page==1&&_array.count==0)
            {

                    UIView *headview=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 70)];

                    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, 30, ScreenWidth, 30)];
                    JXLOG(@"%@",_dict);
                    if([[_dict objectForKey:@"type"] isEqualToString:@"add"]||[[_dict objectForKey:@"type"] isEqualToString:@"delete"])
                    {
                        [label setAttributedText:[regular createAttributeString:@" 你的心愿单是空的，到学校页面点击添加心愿吧。" andFloat:@(2.0)]];

                    }else if([[_dict objectForKey:@"type"] isEqualToString:@"recommend"])
                    {
                        [label setAttributedText:[regular createAttributeString:@" 目前没有合适的学校推荐哈，请更换条件试试吧。" andFloat:@(2.0)]];

                    }

                    label.textColor=[UIColor lightGrayColor];
                    label.textAlignment=1;
                    label.font=[regular getFont:12.0f];
                    [headview addSubview:label];
                    _tableView.tableHeaderView=headview;
                
            }else
            {
                _tableView.tableHeaderView=[UIView new];
                 [dataArray addObjectsFromArray:_array];
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
-(void)setDict:(NSDictionary *)dict
{
    if(_dict!=dict)
    {
        _dict=[dict copy];
        NSString *__title=nil;
        if([[_dict objectForKey:@"type"] isEqualToString:@"recommend"])
        {
            __title=@"推荐学校";
            

        }else
        {
            __title=@"心愿单";
        }
        self.navigationItem.titleView=[[ToolManager sharedManager] returnNavView:__title withmaxwidth:230];
        [self prepareData];
        [self createTableView];
        [self setupRefresh];
    }


}

-(void)prepareData
{
    _page=1;
    self.view.backgroundColor=_define_backview_color;
    dataArray=[[NSMutableArray alloc] init];


    UIBarButtonItem *_btn=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回箭头"] style:UIBarButtonItemStylePlain target:self action:@selector(popviewAction)];
    self.navigationItem.leftBarButtonItem=_btn;
}
-(void)popviewAction
{

    [self.navigationController popViewControllerAnimated:YES];
}


-(void)createTableView
{
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight+kTabBarHeight)  style:UITableViewStylePlain];

    _tableView.showsVerticalScrollIndicator=YES;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=_define_backview_color;
    [self.view addSubview:_tableView];

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CellHeight;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(dataArray.count==section)
    {
        return 0;
    }
    return dataArray.count;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SchoolDetailViewController *school=[[SchoolDetailViewController alloc] init];
    foundModel *model=dataArray[indexPath.row];
    school.data_dict=[[NSDictionary alloc] initWithObjectsAndKeys:model.cn_name,@"schoolName",model.sid,@"schoolID",[NSNumber numberWithInteger:1],@"is_order_school",nil];
    [self.navigationController pushViewController:school animated:YES];
    
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(dataArray.count==indexPath.section)
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
    collectionCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
    if(!cell)
    {
        cell=[[collectionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    
    cell.block=changeBlock;
    cell.backgroundColor=_define_backview_color;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;

    NSMutableDictionary *__dict=[[NSMutableDictionary alloc] initWithObjectsAndKeys:dataArray[indexPath.row],@"model",[NSNumber numberWithInteger:indexPath.row],@"rownum",[_dict objectForKey:@"type"],@"type",nil];

    cell.dict=__dict;
    cell.block=changeBlock;
    return cell;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"collectionSchool"];
    if([[_dict objectForKey:@"type"] isEqualToString:@"recommend"])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadGoal" object:nil];
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[CustomTabbarController sharedManager] tabbarHide];

    [MobClick beginLogPageView:@"collectionSchool"];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
