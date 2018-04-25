//
//  shaiXuanViewController.m
//  OneBox
//
//  Created by 谢江新 on 15/6/9.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import "shaiXuanViewController.h"

#import "MJRefresh.h"

#import "SuggestViewController.h"
#import "SchoolDetailViewController.h"
#import "CustomTabbarController.h"

#import "Sousuo_card_Cell.h"
#import "FoundCell.h"

#import "foundModel.h"
#import "ChineseToPinyin.h"
#import "SouSuoHeaderView.h"

#define foundCellHeight 184*_Scale
#define foundCellHeight_card 400*_Scale

@interface shaiXuanViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>

@property (nonatomic, strong) SouSuoHeaderView *headerView;

@end

@implementation shaiXuanViewController
{

    NSInteger _m_row;
    NSInteger _m_section;
    NSInteger _m_row1;
    NSInteger _m_section1;
    BOOL _is_suoyin;//是否点击索引
    //搜索结果数据
    NSMutableArray *_arrayResult;
    NSMutableArray *_arrayData;
    NSMutableDictionary *_dictPinyinAndChinese;
    NSMutableDictionary *_dictPinyinAndChinese1;
    NSMutableArray *_arrayChar;
    NSMutableArray *_arrayChar1;

    NSArray *titleArr;
    BOOL _isfirst_choose;
    NSInteger _page;
    //    data
    NSMutableData *_receiveData;
    //    开始
    NSInteger start;
    //    数量
    NSInteger count;

    UIView *footview;
    UIView *banbenview;
    YYAnimationIndicator *indicator;
    //    tableview
    UITableView *_tableView;
    //搜索栏
    UISearchBar *_searchBar;
    //搜索结果展示控制器 ，经常和UISearchBar配合使用
    UISearchDisplayController *_searchDC;



    UIButton *rightbarbtn;
    BOOL _iscard;
    NSInteger _Record_cell_num;
    CGFloat _min_offset;
    CGFloat _start_y;
    BOOL _Dragging;
    BOOL _appear;
    BOOL _nav_donghua;
    UIButton *_leftBarbtn;
}

- (void)viewDidLoad
{

    [super viewDidLoad];
    self.sousuoBlock=^(NSInteger row ,NSInteger section,NSString *type)
    {

        if([type isEqualToString:@"1"])
        {
            JXLOG(@"%@",_dictPinyinAndChinese);
            JXLOG(@"%@",_arrayChar);
             foundModel *model=[[_dictPinyinAndChinese objectForKey:[_arrayChar objectAtIndex:section]] objectAtIndex:row];
            model.isapp=YES;
        }else if([type isEqualToString:@"2"])
        {
             foundModel *model=[[_dictPinyinAndChinese1 objectForKey:[_arrayChar1 objectAtIndex:section]] objectAtIndex:row];
             model.isapp=YES;

        }

    };
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(navBarReset) name:@"navBarReset" object:nil];
    [self prepareData];
    //    创建tableview
    [self createTableView];
    [self setupRefresh];
    //    创建搜索栏
    [self createSearchBar];
    //    创建搜索结果显示器
    [self createSearchDisplayCtrl];
}

#pragma mark#pragma mark-----------------Refresh----------------
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
- (void)footerRereshing
{
    start+=100;
    _page++;
    [self requestData];
}
- (void)headerRereshing
{
    _page=1;
    [_arrayData removeAllObjects];
    [self requestData];
}


#pragma mark-----------------SomePrepare----------------
-(void)prepareData
{
    _m_row=0;
    _m_section=0;
    _m_row1=0;
    _m_section1=0;
    _is_suoyin=NO;
    self.view.backgroundColor=_define_backview_color;
    self.navigationItem.titleView=[regular returnNavView:@"筛选结果" withmaxwidth:230];
    
    _leftBarbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [_leftBarbtn setImage:[UIImage imageNamed:@"返回箭头"] forState:UIControlStateNormal];
    _leftBarbtn.frame=CGRectMake(0, 0, 22, 22);
    [_leftBarbtn addTarget:self action:@selector(popviewAction) forControlEvents:UIControlEventTouchUpInside];
    [_leftBarbtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    UIBarButtonItem *_btn=[[UIBarButtonItem alloc] initWithCustomView:_leftBarbtn];
    self.navigationItem.leftBarButtonItem=_btn;

    rightbarbtn =[UIButton buttonWithType:UIButtonTypeCustom];
    rightbarbtn.frame=CGRectMake(0, 0, 20, 20);
    [rightbarbtn setBackgroundImage:[UIImage imageNamed:@"found_qiehuan_card"] forState:UIControlStateSelected];
    [rightbarbtn setBackgroundImage:[UIImage imageNamed:@"found_qiehuan_list"] forState:UIControlStateNormal];
    [rightbarbtn addTarget:self action:@selector(card_qiehuan:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btn=[[UIBarButtonItem alloc] initWithCustomView:rightbarbtn];
    self.navigationItem.rightBarButtonItem=btn;

    rightbarbtn.selected=YES;

    _nav_donghua=NO;
    _appear=YES;
    _Dragging=NO;
    _start_y=0;
    _Record_cell_num=0;
    _iscard=YES;

    _arrayChar1=[[NSMutableArray alloc] init];
    _arrayData=[[NSMutableArray alloc] init];
    _page=1;
    _isfirst_choose=YES;
    _receiveData=[[NSMutableData alloc] init];
    _arrayData=[[NSMutableArray alloc] init];
    _arrayResult = [[NSMutableArray alloc] init];
}
#pragma mark-----------------Action----------------
#pragma mark-导航栏重置
-(void)navBarReset
{
    _Dragging=NO;
    self.navigationController.navigationBar.frame=CGRectMake(0, kStatusBarHeight, [[UIScreen mainScreen] bounds].size.width, kNavigationBarHeight);
    self.navigationItem.titleView.alpha=1;
    _nav_donghua=NO;
    _leftBarbtn.alpha=1;
    rightbarbtn.alpha=1;
}
-(void)card_qiehuan:(UIButton *)btn
{
    if(btn.selected)
    {
        btn.selected=NO;
        _iscard=NO;
    }else
    {
        btn.selected=YES;
        _iscard=YES;
    }
    if(_tableView!=nil)
    {

        [_tableView reloadData];
    }
}
#pragma mark-----------------视图创建----------------

- (void)createSearchDisplayCtrl
{
    //创建搜索结果显示控制器
    //参数 1: 将控制器与参数1指定的搜索栏相关联
    //参数 2 : 指定控制器的显示位置，（当前控制器显示在哪个视图控制器上）
    //当用户点击到_searchBar时，searchDC就会显示，同时searchDC将_searchBar移到searchDC，再将_searchBar的取消按钮设为可见
//    UISearchController
    _searchDC = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
    //设置控制器的tableview的搜索结果数据源代理
    _searchDC.searchResultsDataSource = self;
    //设置控制器的tableview的代理
    _searchDC.searchResultsDelegate = self;

}

-(void)createTableView
{
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight+kTabBarHeight) style:UITableViewStylePlain];

    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.showsVerticalScrollIndicator=YES;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    _tableView.sectionIndexColor = [UIColor colorWithRed:204.0f/255.0f green:204.0f/255.0f blue:204.0f/255.0f alpha:1];
    _tableView.backgroundColor=_define_backview_color;
    [self.view addSubview:_tableView];
    footview=[[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_tableView.frame), 100)];
    _tableView.tableFooterView=footview;
     _min_offset=_tableView.contentOffset.y;
    [self banben_view];

}
-(void)banben_view
{
    banbenview=[[UIView alloc] initWithFrame:CGRectMake((CGRectGetWidth(_tableView.frame)-100*_Scale)/2.0f,50*_Scale, 100*_Scale, 100*_Scale)];
    banbenview.backgroundColor=[UIColor clearColor];
    [footview addSubview:banbenview];
    UIImageView *banbenimg=[[UIImageView alloc] initWithFrame:CGRectMake(25*_Scale, 0, 50*_Scale, 50*_Scale)];
    banbenimg.image=[UIImage imageNamed:@"版本_v1.0"];
    [banbenview addSubview:banbenimg];

    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(banbenimg.frame), CGRectGetWidth(banbenview.frame), CGRectGetHeight(banbenview.frame)-CGRectGetMaxY(banbenimg.frame))];
    label.textAlignment=1;

//    label.text=@"V 1.4";
    label.textColor=[UIColor colorWithRed:193.0f/255.0f green:193.0f/255.0f blue:193.0f/255.0f alpha:1];
    label.font=[regular get_en_Font:11.0f];
    [banbenview addSubview:label];

    //    banbenview.backgroundColor=[UIColor redColor];
    banbenview.hidden=YES;
    
}
- (void)createSearchBar
{

    _searchBar = [[UISearchBar alloc] init];
    _searchBar.backgroundColor=[UIColor clearColor];
    _searchBar.frame = CGRectMake(0, 0, ScreenWidth, 44);
    _searchBar.delegate=self;

    //    _searchBar.searc
    [_searchBar setSearchFieldBackgroundImage:[UIImage imageNamed:@"found_school_所在州所在城市筛选框"] forState:UIControlStateNormal];
    _searchBar.backgroundImage=[UIImage imageNamed:@"found_card_titleview"];
//    _searchBar.backgroundColor=[UIColor whiteColor];

    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"found_school_2_选中底图.png"]];
    imageView.frame=_searchBar.frame;
    _searchBar.placeholder=@"输入城市或者学校名字 试试吧";
    UITextField *searchField = [_searchBar valueForKey:@"_searchField"];

    searchField.font=(kIOSVersions>=9.0? [UIFont systemFontOfSize:11.0f]:[UIFont fontWithName:@"Helvetica Neue" size:11.0f]);
    searchField.leftView.alpha=0.5;

    [searchField setValue:[UIColor colorWithRed:220.0f/255.0f green:220.0f/255.0f blue:220.0f/255.0f alpha:1] forKeyPath:@"_placeholderLabel.textColor"];

    [_searchBar insertSubview:imageView atIndex:1];

    //    _searchBar.delegate = self;
    _searchBar.searchBarStyle=UISearchBarStyleDefault;
    //设置搜索栏取消按钮是否显示
    //        _searchBar.showsCancelButton = YES;
    //将搜索栏添加到视图控制器的主视图上
    //效果是,搜索栏不会随着表视图的滚动而滚动
    //    [self.view addSubview:_searchBar];
    //将搜索栏添加到表视图的表头视图上
    //效果是,搜索栏会随着表视图的滚动而滚动
    _tableView.tableHeaderView = _searchBar;
}
#pragma mark-----------------AnalyseData----------------

-(void)setData_dict:(NSDictionary *)data_dict
{
    if(_data_dict!=data_dict)
    {
        _data_dict=[data_dict mutableCopy];
        _page=1;
//        [self requestData];
    }
}

#pragma mark*请求数据
-(void)requestData
{
    if(!indicator){
        indicator = [[YYAnimationIndicator alloc]initWithFrame:CGRectZero];
        [self.view addSubview:indicator];
        [indicator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.view);
            make.width.height.mas_equalTo(40*_Scale*2);
        }];
        [indicator setLoadText:@"loading..."];
    }
    [indicator startAnimation];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    JXLOG(@"%@",_data_dict);
    [_data_dict setValue:[[NSString alloc] initWithFormat:@"%ld",(long)_page] forKey:@"page"];

    [manager GET:[[NSString alloc] initWithFormat:@"%@%@",DNS,@"/v1/schools"] parameters:_data_dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        结束刷新

        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        NSString *html = operation.responseString;
        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];

//        [_arrayData removeAllObjects];
        [self setdata:dict];
        if(!_arrayData.count)
        {
            //没有要找的学校，换一个筛选条件吧
            [self addHeadViewWhenNoData];

        }
        if([[dict objectForKey:@"data"] count]<100)
        {
            banbenview.hidden=NO;
        }else
        {
            banbenview.hidden=YES;
        }

        [indicator stopAnimationWithLoadText:@"loading..." withType:YES];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [indicator stopAnimationWithLoadText:@"loading..." withType:YES];
       [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
    }];

}
-(void)addHeadViewWhenNoData{
    if(!_headerView){
        WeakSelf(ws);
        _headerView = [[SouSuoHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 300)];
        [_headerView setSouSuoCitiesViewBlock:^(NSString *type) {
            if([type isEqualToString:@"saysomething_to_us"]){
                [ws saysomething_to_us];
            }
        }];
    }

    _tableView.tableHeaderView = _headerView;
}
#pragma mark*Analyse
-(void)setdata:(NSDictionary *)_dict
{


    //        if()
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


        NSArray *_result_arr=[[_dict objectForKey:@"data"] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [[obj1 objectForKey:@"en_name"] compare:[obj2 objectForKey:@"en_name"] options:NSNumericSearch];
        }];


        [_arrayData addObjectsFromArray:[foundModel parsingData:@{@"data":_result_arr}]];
//        banbenview.hidden=NO;
        footview.backgroundColor=_define_backview_color;

        _dictPinyinAndChinese = [[NSMutableDictionary alloc] init];

        //name = “关羽”
        for (foundModel *model in _arrayData) {
            //‘GUANYU’
            NSString *pinyin = [ChineseToPinyin pinyinFromChiniseString:model.en_name];

            //“G”
            NSString *charFirst = [pinyin substringToIndex:1];
            //从字典中招关于G的键值对
            NSMutableArray *charArray  = [_dictPinyinAndChinese objectForKey:charFirst];
            //没有找到
            if (charArray == nil) {
                NSMutableArray *subArray = [[NSMutableArray alloc] init];
                //“关羽”
                [subArray addObject:model];
                // dict   key = "G"  value = subArray -> "关羽"
                [_dictPinyinAndChinese setValue:subArray forKey:charFirst];
            }
            else
            {
                [charArray addObject:model];
            }

        }

            _arrayChar = [[NSMutableArray alloc] init];


        for (int i = 0; i < 26; i++) {
            NSString *str = [NSString stringWithFormat:@"%c", 'A' + i];
            for (NSString *key in [_dictPinyinAndChinese allKeys]) {
                if ([str isEqualToString:key]) {
                    [_arrayChar addObject:str];
                }
            }
        }
//        _dictPinyinAndChinese
//        _arrayChar
        _m_row=0;
        _m_section=0;
        NSInteger _count=0;
        for (int i=0; i<_arrayChar.count; i++) {
            for (int j=0; j<[[_dictPinyinAndChinese objectForKey:[_arrayChar objectAtIndex:i]] count]; j++) {
                _count++;
                if(_count<=2)
                {
                    _m_row=j;
                    _m_section=i;
                }
                if(_count==2)
                {
                    break;
                }
            }
        }
        JXLOG(@"%ld %d",(long)_m_row,_m_section);


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
        
        
    }else
    {
        
    }
}
#pragma mark-----------------SomeDelegate----------------
#pragma mark---SearchBarDelegate---
#pragma mark*内容发生变化的时候，对国家数据进行搜索

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{

    if(![_searchBar.text isEqualToString:@""])
    {

         NSArray *data_Result_arr=[[self get_contain_word_arr:_searchBar.text] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [((foundModel *)obj1).en_name compare:((foundModel *)obj2).en_name options:NSNumericSearch];
        }];
//  @{@"data":_result_arr}
        //获得搜索数据
        JXLOG(@"111");
        _dictPinyinAndChinese1=[self get_country_dict:data_Result_arr];
        _arrayChar1=[self get_country_arr:_dictPinyinAndChinese1];
        _m_row1=0;
        _m_section1=0;
        NSInteger _count=0;
        for (int i=0; i<_arrayChar1.count; i++) {
            for (int j=0; j<[[_dictPinyinAndChinese1 objectForKey:[_arrayChar1 objectAtIndex:i]] count]; j++) {
                _count++;
                if(_count<=2)
                {
                    _m_row1=j;
                    _m_section1=i;
                }
                if(_count==2)
                {
                    break;
                }
            }
        }

    }else
    {
        _dictPinyinAndChinese1=[[NSMutableDictionary alloc] init];
        _arrayChar1=[[NSMutableArray alloc] init];
    }
}
#pragma mark*进行解析数据，得到排序后的索引数组
-(NSMutableArray *)get_country_arr:(NSMutableDictionary *)dict
{
    NSMutableArray *arr=[[NSMutableArray alloc] init];
    for (int i = 0; i < 26; i++) {
        NSString *str = [NSString stringWithFormat:@"%c", 'A' + i];
        for (NSString *key in [dict allKeys]) {
            if ([str isEqualToString:key]) {
                [arr addObject:str];
            }
        }
    }
    return arr;
}
#pragma mark*进行解析数据，得到分类后的城市字典
-(NSMutableDictionary *)get_country_dict:(NSArray *)arr
{

    NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
    for (int i=0; i<arr.count; i++) {
        foundModel *model=arr[i];
        if(model.en_name!=nil)
        {

            NSString *en_name=[ChineseToPinyin pinyinFromChiniseString:model.en_name];
            NSString *charFirst = [en_name substringToIndex:1];

            if([[dict allKeys] indexOfObject:charFirst] == NSNotFound)
            {
                NSMutableArray *son_arr=[[NSMutableArray alloc] init];
                [son_arr addObject:arr[i]];
                //                没找到
                [dict setObject:son_arr forKey:charFirst];

            }else
            {
                //                找到了
                [((NSMutableArray *)[dict objectForKey:charFirst]) addObject:arr[i]];
            }
            
        }
    }
    return dict;
}
#pragma mark*搜索出包含该字符的数据(中英文搜索)
-(NSMutableArray *)get_contain_word_arr:(NSString *)title
{
    NSMutableArray *arr=[[NSMutableArray alloc] init];

    for (foundModel *model in _arrayData) {
        if(![title isEqualToString:@""])
        {
//            __string(en_name);
//            __string(cn_name);
//            __string(city);
            NSRange range1 = [[ChineseToPinyin pinyinFromChiniseString:model.cn_name] rangeOfString:[ChineseToPinyin pinyinFromChiniseString:title]];
            NSRange range2 = [[ChineseToPinyin pinyinFromChiniseString:model.en_name] rangeOfString:[ChineseToPinyin pinyinFromChiniseString:title]];

            NSRange range3 = [[ChineseToPinyin pinyinFromChiniseString:model.en_name] rangeOfString:[ChineseToPinyin pinyinFromChiniseString:title]];

            NSRange range4 = [[ChineseToPinyin pinyinFromChiniseString:model.city] rangeOfString:[ChineseToPinyin pinyinFromChiniseString:title]];

            NSRange range5 = [[ChineseToPinyin pinyinFromChiniseString:model.state] rangeOfString:[ChineseToPinyin pinyinFromChiniseString:title]];

            if(((range1.location != NSNotFound)||(range2.location!=NSNotFound))&&(![model.en_name isEqualToString:@""])&&(![model.cn_name isEqualToString:@""]))
            {
                [arr addObject:model];
            }else if(![model.cn_name isEqualToString:@""])
            {
                if(range3.location!=NSNotFound||range4.location!=NSNotFound||range5.location!=NSNotFound)
                {
                    [arr addObject:model];
                }
            }
        }
    }
    return arr;

}
#pragma mark---TableViewDelegate---

#pragma mark*索引
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{


    if(tableView==_tableView)
    {
        return _arrayChar;
    }
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor=_define_backview_color;

    return _arrayChar1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(tableView==_tableView)
    {
        return _arrayChar.count;
    }else
    {
        //因为在searchDC上的_searchBar就是创建searchDC时，由第一个参数指定的_searchBar
        if(![_searchBar.text isEqualToString:@""])
        {
            tableView.sectionIndexBackgroundColor = [UIColor clearColor];
            tableView.sectionIndexColor = [UIColor colorWithRed:204.0f/255.0f green:204.0f/255.0f blue:204.0f/255.0f alpha:1];

            return _arrayChar1.count;
        }else
        {
            return 1;
        }
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if(tableView==_tableView)
    {
        if(_arrayChar.count==section)
        {
            return 0;
        }
        NSString *strKey = [_arrayChar objectAtIndex:section];
        NSInteger _count=[[_dictPinyinAndChinese objectForKey:strKey] count];
        return _count;

    }else
    {
        if(![_searchBar.text isEqualToString:@""])
        {
            NSString *strKey = [_arrayChar1 objectAtIndex:section];
            NSInteger _count=[[_dictPinyinAndChinese1 objectForKey:strKey] count];
            return _count;

        }
        return 1;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SchoolDetailViewController *schoolView=[[SchoolDetailViewController alloc] init];

    foundModel *model=nil;

    if(tableView==_tableView)
    {
        model=[[_dictPinyinAndChinese objectForKey:[_arrayChar objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    }else
    {
        model=[[_dictPinyinAndChinese1 objectForKey:[_arrayChar1 objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    }

    schoolView.data_dict=[[NSDictionary alloc] initWithObjectsAndKeys:model.cn_name,@"schoolName",model.sid,@"schoolID",[NSNumber numberWithInteger:model.is_order_school],@"is_order_school",nil];

    [self.navigationController pushViewController:schoolView animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_arrayData.count==indexPath.section)
    {
        if(_iscard)
        {
            return foundCellHeight_card;
        }
        return foundCellHeight;
    }else
    {
        if(_iscard)
        {
            return foundCellHeight_card;
        }
        return foundCellHeight;
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


    if(_iscard)
    {
        static NSString *cellid=@"cell_card";
        Sousuo_card_Cell *cell_card=[tableView dequeueReusableCellWithIdentifier:cellid ];
        if(!cell_card)
        {
            cell_card=[[Sousuo_card_Cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];

        }
        cell_card.selectionStyle=UITableViewCellSelectionStyleNone;
        if(tableView==_tableView)
        {
//            _m_row
//            _m_section

            cell_card.block=self.sousuoBlock;
            JXLOG(@"%@",_dictPinyinAndChinese);
            NSDictionary *_dict=[[NSDictionary alloc] initWithObjectsAndKeys:[[_dictPinyinAndChinese objectForKey:[_arrayChar objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row],@"model",[NSNumber numberWithInteger:indexPath.row],@"row",[NSNumber numberWithInteger:indexPath.section],@"section",@"1",@"type",[_arrayChar objectAtIndex:indexPath.section],@"char",[NSNumber numberWithBool:_is_suoyin],@"suoyin",[NSNumber numberWithInteger:_m_row],@"m_row",[NSNumber numberWithInteger:_m_section],@"m_section",nil];

            cell_card.dict=_dict;
        }else
        {
            tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
            if(![_searchBar.text isEqualToString:@""])
            {
                NSDictionary *_dict=[[NSDictionary alloc] initWithObjectsAndKeys:[[_dictPinyinAndChinese1 objectForKey:[_arrayChar1 objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row],@"model",[NSNumber numberWithInteger:indexPath.row],@"row",[NSNumber numberWithInteger:indexPath.section],@"section",@"2",@"type",[_arrayChar1 objectAtIndex:indexPath.section],@"char",[NSNumber numberWithBool:_is_suoyin],@"suoyin",[NSNumber numberWithInteger:_m_row1],@"m_row",[NSNumber numberWithInteger:_m_section1],@"m_section",nil];
                cell_card.block=self.sousuoBlock;
                cell_card.dict=_dict;

            }else
            {
            }
        }

        return cell_card;

    }else
    {
        static NSString *cellid=@"cell";
        FoundCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid ];
        if(!cell)
        {
            cell=[[FoundCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        if(tableView==_tableView)
        {
            cell.model =[[_dictPinyinAndChinese objectForKey:[_arrayChar objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
        }else
        {

            if(![_searchBar.text isEqualToString:@""])
            {
                cell.model = [[_dictPinyinAndChinese1 objectForKey:[_arrayChar1 objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
            }else
            {
            }
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
        
    }

}
#pragma mark-检测当前偏移量

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    _Dragging=NO;
    self.navigationController.navigationBar.frame=CGRectMake(0, kStatusBarHeight, [[UIScreen mainScreen] bounds].size.width, kNavigationBarHeight);
    self.navigationItem.titleView.alpha=1;
    _nav_donghua=NO;
    _leftBarbtn.alpha=1;
    rightbarbtn.alpha=1;

    // Do your action here
    return YES;
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{



    if(scrollView==_tableView&&_appear)
    {
        _start_y=scrollView.contentOffset.y;
        JXLOG(@"滚动视图即将开始拖动=%f",scrollView.contentOffset.y);
        _Dragging=YES;
    }


}
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    NSInteger count = 0;

//    JXLOG(@"%@-%d",title,index);

    _is_suoyin=YES;
    for(NSString *character in _arrayChar)
    {
        if([character isEqualToString:title])
        {
            return count;
        }
        count ++;
    }
    return 0;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    if(_iscard)
    {
        CGFloat _height=0;
        if(scrollView==_tableView)
        {
            _height=scrollView.contentOffset.y+CGRectGetHeight(_tableView.frame)-_min_offset-kTabBarHeight-CGRectGetHeight(_searchBar.frame);
        }else
        {
            _height=scrollView.contentOffset.y+CGRectGetHeight(_tableView.frame)-_min_offset-kTabBarHeight;

        }

        NSInteger now_cell=0;
        if(_isPad)
        {
            now_cell=(NSInteger)(_height/((NSInteger)400*_Scale));

        }else
        {
            now_cell=(NSInteger)(_height/200);
            
        }

        if(now_cell!=_Record_cell_num)
        {
            _Record_cell_num=now_cell;
            NSDictionary *pushnum=0;
            if(scrollView==_tableView)
            {
                pushnum=[self getnumWithChar:_arrayChar WithPinyin:_dictPinyinAndChinese];

            }else
            {
                pushnum=[self getnumWithChar:_arrayChar1 WithPinyin:_dictPinyinAndChinese1];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SousuoAnimation" object:pushnum];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SousuoAnimation1" object:nil];
    }
    if(_Dragging)
    {
        if(scrollView==_tableView&&_appear)
        {

            JXLOG(@"滚动视图正在滚动=%f",scrollView.contentOffset.y);
            if(_start_y<20&&scrollView.contentOffset.y>20)
            {

                if(!_nav_donghua)
                {
                    [UIView beginAnimations:@"anmationAppear" context:nil];
                    [UIView setAnimationDuration:0.2];
                    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
                    [UIView setAnimationDelegate:self];
                    self.navigationController.navigationBar.frame=CGRectMake(0, kStatusBarHeight - kStatusBarAndNavigationBarHeight, [[UIScreen mainScreen] bounds].size.width, kNavigationBarHeight);
                    self.navigationItem.titleView.alpha=0;
                    //        _leftBarbtn
                    _leftBarbtn.alpha=0;
                    rightbarbtn.alpha=0;
                    [UIView commitAnimations];
                    _nav_donghua=YES;

                }

            }else
            {
                if(scrollView.contentOffset.y<20)
                {

                    if(_nav_donghua)
                    {
                        [UIView beginAnimations:@"anmationAppear" context:nil];
                        [UIView setAnimationDuration:0.2];
                        [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
                        [UIView setAnimationDelegate:self];
                        self.navigationController.navigationBar.frame=CGRectMake(0, kStatusBarHeight, [[UIScreen mainScreen] bounds].size.width, kNavigationBarHeight);
                        self.navigationItem.titleView.alpha=1;
                        _leftBarbtn.alpha=1;
                        rightbarbtn.alpha=1;
                        [UIView commitAnimations];
                        _nav_donghua=NO;
                    }
                }else
                {
                    if(((scrollView.contentOffset.y-_start_y)>(ScreenHeight/4.0f)))
                    {
                        if(!_nav_donghua)
                        {
                            
                            [UIView beginAnimations:@"anmationAppear" context:nil];
                            [UIView setAnimationDuration:0.2];
                            [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
                            [UIView setAnimationDelegate:self];
                            self.navigationController.navigationBar.frame=CGRectMake(0, kStatusBarHeight - kStatusBarAndNavigationBarHeight, [[UIScreen mainScreen] bounds].size.width, kNavigationBarHeight);
                            self.navigationItem.titleView.alpha=0;
                            _leftBarbtn.alpha=0;
                            rightbarbtn.alpha=0;
                            [UIView commitAnimations];

                            _nav_donghua=YES;

                        }
                    }else if(((_start_y-scrollView.contentOffset.y)>(ScreenHeight/4.0f)))
                    {

                        if(_nav_donghua)
                        {
                            [UIView beginAnimations:@"anmationAppear" context:nil];
                            [UIView setAnimationDuration:0.2];
                            [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
                            [UIView setAnimationDelegate:self];
                            self.navigationController.navigationBar.frame=CGRectMake(0, kStatusBarHeight, [[UIScreen mainScreen] bounds].size.width, kNavigationBarHeight);
                            self.navigationItem.titleView.alpha=1;
                            _leftBarbtn.alpha=1;
                            rightbarbtn.alpha=1;
                            [UIView commitAnimations];
                            _nav_donghua=NO;

                        }
                    }
                }
            }
        }
        
    }
}
-(NSDictionary *)getnumWithChar:(NSArray *)arrayChar WithPinyin:(NSDictionary *)dictPinyinAndChinese
{
    NSDictionary *_returndata=0;
    NSInteger _count=0;
    for (NSInteger i=0; i<[arrayChar count]; i++) {
        for (NSInteger j=0; j<[[dictPinyinAndChinese objectForKey:[arrayChar objectAtIndex:i]] count]; j++) {

            _count++;
            if(_count==_Record_cell_num)
            {
                _returndata=[[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInteger:j+1],@"num",[arrayChar objectAtIndex:i],@"key",[NSNumber numberWithBool:_is_suoyin],@"suoyin",nil];
                break;
            }
        }
    }
    return _returndata;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(scrollView==_tableView&&_appear)
    {
        _Dragging=NO;
    }
    _is_suoyin=NO;
}
#pragma mark-----------------Others----------------
-(void)saysomething_to_us
{
    [self.navigationController pushViewController:[SuggestViewController new] animated:YES];
}
-(void)popviewAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _appear=NO;
    _Dragging=NO;
    self.navigationController.navigationBar.frame=CGRectMake(0, kStatusBarHeight, [[UIScreen mainScreen] bounds].size.width, kNavigationBarHeight);
    self.navigationItem.titleView.alpha=1;
    _leftBarbtn.alpha=1;
    _nav_donghua=NO;
    rightbarbtn.alpha=1;
    [MobClick endLogPageView:@"shaiXuanViewController"];
}
-(void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];
    _appear=YES;
    [MobClick beginLogPageView:@"shaiXuanViewController"];
    [[CustomTabbarController sharedManager] tabbarHide];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
