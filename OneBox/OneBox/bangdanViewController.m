//
//  bangdanViewController.m
//  OneBox
//
//  Created by 谢江新 on 15/6/9.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import "bangdanViewController.h"

#import "SchoolDetailViewController.h"
#import "CustomTabbarController.h"

#import "bangdanCell.h"

#import "FoundModel.h"
#import "ChineseToPinyin.h"

#define foundCellHeight 200*_Scale

@interface bangdanViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation bangdanViewController
{
    UIView *banbenview;
    UIView *footview;
    NSArray *titleArr;
    NSDictionary *_dictPinyinAndChinese;
    NSDictionary *_dictPinyinAndChinese1;
    NSMutableArray *_arrayChar;
     NSMutableArray *_arrayChar1;

    //    tableview
    UITableView *_tableView;
    //    开始
    NSInteger start;
    //    数量
    NSInteger count;
    //    data
    NSMutableData *_receiveData;
    //搜索栏
    UISearchBar *_searchBar;
    //搜索结果展示控制器 ，经常和UISearchBar配合使用
    UISearchDisplayController *_searchDC;

    //搜索结果数据
    NSMutableArray *_arrayResult;
    NSMutableArray *_arrayData;
    NSInteger _page;
    BOOL _isfirst_choose;

    void (^blockFailure)(NSError *error);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=_define_backview_color;
}
-(void)prepareData
{

    _arrayChar1=[[NSMutableArray alloc] init];
    UIBarButtonItem *_btn=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回箭头"] style:UIBarButtonItemStylePlain target:self action:@selector(popviewAction)];
    self.navigationItem.leftBarButtonItem=_btn;

    _arrayData=[[NSMutableArray alloc] init];
    _page=1;
    _isfirst_choose=YES;
    _receiveData=[[NSMutableData alloc] init];
    _arrayData=[[NSMutableArray alloc] init];
    _arrayResult = [[NSMutableArray alloc] init];
}
-(void)popviewAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createSearchDisplayCtrl
{
    //创建搜索结果显示控制器
    //参数 1: 将控制器与参数1指定的搜索栏相关联
    //参数 2 : 指定控制器的显示位置，（当前控制器显示在哪个视图控制器上）
    //当用户点击到_searchBar时，searchDC就会显示，同时searchDC将_searchBar移到searchDC，再将_searchBar的取消按钮设为可见
    _searchDC = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];

    //设置控制器的tableview的搜索结果数据源代理
    _searchDC.searchResultsDataSource = self;
    //设置控制器的tableview的代理
    _searchDC.searchResultsDelegate = self;
    
}

-(void)createTableView
{
    CGRect _rect;
    if(_type>4)
    {
        _rect=CGRectMake(0, 0, ScreenWidth, ScreenHeight-100*_Scale-64);
    }else
    {
        _rect=CGRectMake(0, 0, ScreenWidth, ScreenHeight+49);

    }
    _tableView=[[UITableView alloc] initWithFrame:_rect style:UITableViewStylePlain];



    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.showsVerticalScrollIndicator=YES;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    _tableView.sectionIndexColor = [UIColor colorWithRed:204.0f/255.0f green:204.0f/255.0f blue:204.0f/255.0f alpha:1];
    [self.view addSubview:_tableView];
    footview=[[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_tableView.frame), 100)];
    _tableView.tableFooterView=footview;
    [self createVersionView];
    _tableView.backgroundColor=[UIColor clearColor];


}
-(void)createVersionView
{
    banbenview=[[UIView alloc] initWithFrame:CGRectMake((CGRectGetWidth(_tableView.frame)-100*_Scale)/2.0f,50*_Scale, 100*_Scale, 100*_Scale)];
    banbenview.backgroundColor=[UIColor clearColor];
    [footview addSubview:banbenview];
    UIImageView *banbenimg=[[UIImageView alloc] initWithFrame:CGRectMake(25*_Scale, 0, 50*_Scale, 50*_Scale)];
    banbenimg.image=[UIImage imageNamed:@"版本_v1.0"];
    [banbenview addSubview:banbenimg];

    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(banbenimg.frame), CGRectGetWidth(banbenview.frame), CGRectGetHeight(banbenview.frame)-CGRectGetMaxY(banbenimg.frame))];
    label.textAlignment=1;
    label.textColor=[UIColor colorWithRed:193.0f/255.0f green:193.0f/255.0f blue:193.0f/255.0f alpha:1];
    label.font=[regular get_en_Font:11.0f];
    [banbenview addSubview:label];
    banbenview.hidden=YES;
    
}

- (void)createSearchBar
{

    _searchBar = [[UISearchBar alloc] init];
    _searchBar.backgroundColor=[UIColor clearColor];
    _searchBar.frame = CGRectMake(0, 0, ScreenWidth, 44);
    [_searchBar setSearchFieldBackgroundImage:[UIImage imageNamed:@"found_school_所在州所在城市筛选框"] forState:UIControlStateNormal];
    _searchBar.backgroundImage=[UIImage imageNamed:@"hehehehe"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"found_school_2_选中底图.png"]];
    imageView.frame=_searchBar.frame;
    _searchBar.placeholder=@"输入城市或者学校名字 试试吧";
    if (@available(iOS 13.0, *)) {
        UITextField *searchField = _searchBar.searchTextField;

        searchField.font=(kIOSVersions>=9.0? [UIFont systemFontOfSize:11.0f]:[UIFont fontWithName:@"Helvetica Neue" size:11.0f]);
        searchField.leftView.alpha=0.5;
    } else {
        // Fallback on earlier versions
    }

    [_searchBar insertSubview:imageView atIndex:1];
    _searchBar.searchBarStyle=UISearchBarStyleDefault;
    _tableView.tableHeaderView = _searchBar;
}
-(void)setType:(NSInteger)type
{

    titleArr=@[@"Niche 榜",@"Business Insider 榜",@"Prep Review 榜",@"蓝带学校榜"];
    _type=type;

    [self prepareData];
    //    创建tableview
    [self createTableView];
    //    创建搜索栏
    [self createSearchBar];
    //    创建搜索结果显示器
    [self createSearchDisplayCtrl];

    if(_type<=4)
    {
        CGFloat _Default_font=16.0;
        CGFloat _Default_Spacing=3.0f;
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 230, 40)];

        UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(view.frame), CGRectGetHeight(view.frame))];
        titleLabel.font=[UIFont fontWithName:@"Skia" size:_Default_font];

        titleLabel.textColor=[UIColor whiteColor];
        titleLabel.textAlignment=NSTextAlignmentCenter;
        [titleLabel setAttributedText:[regular createAttributeString:titleArr[_type-1] andFloat:@(_Default_Spacing)]];
        [view addSubview:titleLabel];
        [titleLabel sizeToFit];
        BOOL _isfit;
        if(CGRectGetWidth(titleLabel.frame)<=230)
        {
            _isfit=NO;
        }else
        {
            for (int i=_Default_font*2;i>0;i--) {


                if(_Default_Spacing<=0)
                {
                    _Default_font-=0.5f;

                }else
                {
                    _Default_Spacing-=0.5f;
                }

                titleLabel.font=[UIFont fontWithName:@"Skia" size:_Default_font];

                [titleLabel setAttributedText:[ToolManager createAttributeString:titleArr[_type-1] andFloat:@(_Default_Spacing)]];
                [titleLabel sizeToFit];
                if(CGRectGetWidth(titleLabel.frame)<=230||_Default_font<=13.0f)
                {
                    break;
                }
            }
        }
        JXLOG(@"Spacing=%f  font=%f",_Default_Spacing,_Default_font);
        if(CGRectGetWidth(titleLabel.frame)>230&&_Default_font==13.0f)
        {
            titleLabel.frame=CGRectMake(0, 0, CGRectGetWidth(view.frame), CGRectGetHeight(view.frame));
        }else
        {
            titleLabel.frame=CGRectMake((CGRectGetWidth(view.frame)-CGRectGetWidth(titleLabel.frame))/2.0f, (CGRectGetHeight(view.frame)-CGRectGetHeight(titleLabel.frame))/2.0f, CGRectGetWidth(titleLabel.frame), CGRectGetHeight(titleLabel.frame));
        }
        self.navigationItem.titleView=view;
    }

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *_parameters=nil;
    if (_type==1) {
        _parameters=@{@"mark":@"niche"};
    } else if(_type==2) {
        _parameters=@{@"mark":@"insider"};
    } else if(_type==5) {
        _parameters=@{@"mark":@"day"};
    } else if(_type==6) {
        _parameters=@{@"mark":@"boarding"};
    } else if(_type==4) {
        _parameters=@{@"mark":@"blue_ribbon"};
    }
    [manager GET:[[NSString alloc] initWithFormat:@"%@%@",DNS,@"/v1/rank_schools"] parameters:_parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSString *html = operation.responseString;
        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
        [self setdata:dict];
        [_tableView reloadData];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
    }];

    
}
-(void)setdata:(NSDictionary *)_dict
{
    if(((NSArray *)[_dict objectForKey:@"data"]).count==0)
    {

        if(_page>1)
        {
            [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"没有更多了" WithImg:@"Prompt_提交成功" Withtype:1]];
        }else
        {
            [_arrayChar removeAllObjects];

            [_tableView reloadData];
        }

    }else
    {
        [_arrayData removeAllObjects];
        [_arrayData addObjectsFromArray:[FoundModel parsingData:_dict]];
        banbenview.hidden=NO;
        footview.backgroundColor=_define_backview_color;
        JXLOG(@"%@",_arrayData);
        [_tableView reloadData];
    }

    if(start==0)
    {
        if(_dict[@"count"]!=[NSNull null])
        {
            NSString *countStr=(NSString *)_dict[@"count"];
            count=[countStr intValue];
        }else
        {
            count=0;
            [_arrayData removeAllObjects];
            [_arrayChar removeAllObjects];
            [_arrayResult removeAllObjects];
        }
    }
}
#pragma mark-tableview

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_arrayData.count==indexPath.section)
    {
        return foundCellHeight;
    }
    return foundCellHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSInteger num=indexPath.row;
    FoundModel *model=_arrayData[num];
    NSDictionary *pushdict=[[NSDictionary alloc] initWithObjectsAndKeys:model.cn_name,@"schoolName",model.sid,@"schoolID",[NSNumber numberWithInteger:model.is_order_school],@"is_order_school",nil];

    if(_type==5||_type==6)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"bangdanpush_detail" object:pushdict];

    }else
    {
        SchoolDetailViewController *schoolView=[[SchoolDetailViewController alloc] init];

        schoolView.data_dict=pushdict;
        [self.navigationController pushViewController:schoolView animated:YES];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
        return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView==_tableView)
    {
        if(_arrayData.count==section)
        {
            return 0;
        }
        return _arrayData.count;
    }else{
        return _arrayResult.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_arrayData.count==indexPath.section)
    {
        static NSString *cellid=@"cellid";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
        if(!cell)
        {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }

    static NSString *cellid=@"cell";
    bangdanCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid ];
    if (!cell) {
        cell=[[bangdanCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (tableView==_tableView) {
        JXLOG(@"%@",_arrayChar);
        NSInteger num=indexPath.row;
        FoundModel *model=_arrayData[num];
        cell.model =model;
    } else {
        cell.model = [_arrayResult objectAtIndex:indexPath.row];
    }
    return cell;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"bangdanViewController"];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"bangdanViewController"];

    [[CustomTabbarController sharedManager] tabbarHide];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
