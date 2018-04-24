//
//  souSuoViewController.m
//  OneBox
//
//  Created by 谢江新 on 15/6/9.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import "souSuoViewController.h"

#import "MJRefresh.h"

#import "SuggestViewController.h"
#import "SchoolDetailViewController.h"
#import "CustomTabbarController.h"

#import "sousuo_card_Cell.h"
#import "FoundCell.h"

#import "foundModel.h"
#import "ChineseToPinyin.h"
#import "NSString+Valid.h"

#define foundCellHeight 184*_Scale
#define foundCellHeight_card 400*_Scale

@interface souSuoViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>

@end

@implementation souSuoViewController
{
    NSInteger _m_row;
    NSInteger _m_section;
    YYAnimationIndicator *indicator;
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
    NSMutableArray *_arrayData1;
    NSInteger _page;

    BOOL _isfirst_choose;

    UIButton *rightbarbtn;
    BOOL _iscard;
    NSInteger _Record_cell_num;
    CGFloat _min_offset;
    CGFloat _start_y;
    BOOL _Dragging;
    BOOL _appear;
    BOOL _nav_donghua;
    UIButton *_leftBarbtn;
    BOOL _is_suoyin;
    
}

- (void)viewDidLoad {

    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(navBarReset) name:@"navBarReset" object:nil];
    self.view.backgroundColor=_define_backview_color;
    self.navigationItem.titleView=[regular returnNavView:@"搜索结果" withmaxwidth:230];
    rightbarbtn =[UIButton buttonWithType:UIButtonTypeCustom];
    rightbarbtn.frame=CGRectMake(0, 0, 20, 20);
    [rightbarbtn setBackgroundImage:[UIImage imageNamed:@"found_qiehuan_card"] forState:UIControlStateSelected];
    [rightbarbtn setBackgroundImage:[UIImage imageNamed:@"found_qiehuan_list"] forState:UIControlStateNormal];
    [rightbarbtn addTarget:self action:@selector(card_qiehuan:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btn=[[UIBarButtonItem alloc] initWithCustomView:rightbarbtn];
    rightbarbtn.selected=YES;
    self.navigationItem.rightBarButtonItem=btn;

    self.sousuoBlock=^(NSInteger row ,NSInteger section,NSString *type)
    {
        if([type isEqualToString:@"1"])
        {


            //
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
    [self prepareData];
    //    创建tableview
    [self createTableView];
    [self setupRefresh];
    //    创建搜索栏
    [self createSearchBar];
    //    创建搜索结果显示器
    [self createSearchDisplayCtrl];

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

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{

    //    [self sectionIndexTitlesForTableView:_searchBar.]

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
    _tableView.tableHeaderView=[UIView new];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters=@{@"query":_keystring,@"page":[[NSString alloc] initWithFormat:@"%ld",(long)_page]};
    [manager GET:[[NSString alloc] initWithFormat:@"%@%@",DNS,@"/v1/schools"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {

        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];

        NSString *html = operation.responseString;
        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];

//        [_arrayData removeAllObjects];
        [self setdata:dict];
        if(_arrayData.count==0)
        {
            //                没有要找的学校，换一个筛选条件吧
            UIView *headview=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 300)];

            UIButton *touchbtn=[UIButton buttonWithType:UIButtonTypeCustom];
            [headview addSubview:touchbtn];
            touchbtn.frame=CGRectMake((ScreenWidth-80*_Scale)/2.0f, 70, 80*_Scale, 80*_Scale);
            [touchbtn setBackgroundImage:[UIImage imageNamed:@"setting_意见"] forState:UIControlStateNormal];
            [touchbtn addTarget:self action:@selector(saysomething_to_us) forControlEvents:UIControlEventTouchUpInside];
            NSArray *titlearr=@[@"要找的学校没有收录？",@"告诉我们吧。"];
            CGFloat _y_p=CGRectGetMaxY(touchbtn.frame)+15;
            CGFloat _height=60*_Scale;
            for (int i=0; i<2; i++) {
                UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, _y_p, ScreenWidth, _height)];
                [headview addSubview:label];
                label.textColor=_define_blue_color;
                label.font=[regular getFont:13.0f];
                label.textAlignment=1;

                [label setAttributedText:[regular createAttributeString:titlearr[i] andFloat:@(2.0)]];

                _y_p+=_height;

            }


            _tableView.tableHeaderView=headview;

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
-(void)setKeystring:(NSString *)keystring
{
    if(_keystring!=keystring)
    {
        _keystring=[keystring copy];
        _page=1;
    }
}
#pragma mark-to_suggest
-(void)saysomething_to_us
{
    [self.navigationController pushViewController:[SuggestViewController new] animated:YES];
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
        [_tableView reloadData];


    }else
    {
        NSArray *_result_arr=[[_dict objectForKey:@"data"] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [[obj1 objectForKey:@"en_name"] compare:[obj2 objectForKey:@"en_name"] options:NSNumericSearch];
        }];


        [_arrayData addObjectsFromArray:[foundModel parsingData:@{@"data":_result_arr}]];
        _dictPinyinAndChinese = [[NSMutableDictionary alloc] init];
//        banbenview.hidden=NO;
        footview.backgroundColor=_define_backview_color;

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

        for (NSString *keys in [_dictPinyinAndChinese allKeys]) {

            //        JXLOG(@"%@", [_dictPinyinAndChinese objectForKey:keys]);
            JXLOG(@"%@", keys);
            for (NSString *str in [_dictPinyinAndChinese objectForKey:keys]) {
                JXLOG(@"%@", str);
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

-(void)prepareData
{
    _m_row=0;
    _m_section=0;

    _is_suoyin=NO;
    _nav_donghua=NO;
    _appear=YES;
    _Dragging=NO;
    _start_y=0;
    _Record_cell_num=0;
    _iscard=YES;

    _arrayChar1=[[NSMutableArray alloc] init];
    _arrayData1=[[NSMutableArray alloc] init];
    _leftBarbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [_leftBarbtn setImage:[UIImage imageNamed:@"返回箭头"] forState:UIControlStateNormal];
    _leftBarbtn.frame=CGRectMake(0, 0, 22, 22);
    [_leftBarbtn addTarget:self action:@selector(popviewAction) forControlEvents:UIControlEventTouchUpInside];
    [_leftBarbtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    UIBarButtonItem *_btn=[[UIBarButtonItem alloc] initWithCustomView:_leftBarbtn];
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
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight+kTabBarHeight) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.showsVerticalScrollIndicator=YES;

    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    _tableView.sectionIndexColor = [UIColor colorWithRed:204.0f/255.0f green:204.0f/255.0f blue:204.0f/255.0f alpha:1];
    [self.view addSubview:_tableView];
    footview=[[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_tableView.frame), 100)];
    //    footview.hidden=YES;
    _tableView.backgroundColor=_define_backview_color;
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
    _searchBar.frame = CGRectMake(0, 64, ScreenWidth, 44);
    _searchBar.delegate=self;
    [self.view addSubview:_searchBar];


    [_searchBar setSearchFieldBackgroundImage:[UIImage imageNamed:@"found_school_所在州所在城市筛选框"] forState:UIControlStateNormal];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"found_sousuo_back"]];
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
//    [headview addSubview:_searchBar];
//    [self.view addSubview:];
    _tableView.tableHeaderView = _searchBar;

}
#pragma mark-tableview

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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    SchoolDetailViewController *schoolView=[[SchoolDetailViewController alloc] init];
    NSInteger _section=indexPath.section;
    JXLOG(@"%@",_arrayChar);
    NSString *strKey  = [_arrayChar objectAtIndex:_section];
    NSMutableArray  *__arr=[[NSMutableArray alloc] initWithArray:[_dictPinyinAndChinese objectForKey:strKey]];
    NSInteger num=indexPath.row;
    foundModel *model=nil;
    if(tableView==_tableView)
    {
        model=__arr[num];
    }else
    {
        model=_arrayResult[num];
    }

//    foundModel *model=__arr[num];
    schoolView.data_dict=[[NSDictionary alloc] initWithObjectsAndKeys:model.cn_name,@"schoolName",model.sid,@"schoolID",[NSNumber numberWithInteger:model.is_order_school],@"is_order_school",nil];

    [self.navigationController pushViewController:schoolView animated:YES];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(tableView==_tableView)
    {
        NSInteger _count=_arrayChar.count;
        return _count;
    }else
    {
        //因为在searchDC上的_searchBar就是创建searchDC时，由第一个参数指定的_searchBar
        //        NSString *searchCon = _searchBar.text;
        //        JXLOG(@"%@", searchCon);

        [_arrayResult removeAllObjects];
        NSString *title=_searchBar.text;

        //遍历数据源数据，找到与当前搜索内容相匹配的数据
        JXLOG(@"%@",_dictPinyinAndChinese);

        for (foundModel *model in _arrayData) {

            if(![title isEqualToString:@""])
            {
                NSRange range1;
                NSRange range2;
                NSRange range3;

                NSString *title1=nil;
                if([self IsChinese:title])
                {

                    title1=title;
                    range1 = [model.cn_name rangeOfString:title1];
                    range2 = [model.en_name rangeOfString:title1];
                    NSString *titeeee=model.city;
                    range3 = [titeeee rangeOfString:title1];
                }else
                {
                    title1=[ChineseToPinyin pinyinFromChiniseString:title];
                    range1 = [[ChineseToPinyin pinyinFromChiniseString:model.cn_name] rangeOfString:title1];
                    range2 = [[ChineseToPinyin pinyinFromChiniseString:model.en_name] rangeOfString:title1];
                    NSString *titeeee=model.city;
                    range3 = [[ChineseToPinyin pinyinFromChiniseString:titeeee] rangeOfString:title1];

                }



                if(((range1.location != NSNotFound)||(range2.location!=NSNotFound))&&(![model.en_name isEqualToString:@""])&&(![model.cn_name isEqualToString:@""]))
                {
                    [_arrayResult addObject:model];
                }else if(![model.city isEqualToString:@""])
                {
                    if((range3.location!=NSNotFound))
                    {
                        [_arrayResult addObject:model];
                    }
                }
            }
        }
        JXLOG(@"%@",_arrayResult);
        return 1;
    }

}
-(BOOL)IsChinese:(NSString *)str { for(int i=0; i< [str length];i++){ int a = [str characterAtIndex:i]; if( a > 0x4e00 && a < 0x9fff)
{ return YES;
}
} return NO;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView==_tableView)
    {
        if(_arrayData.count==section)
        {
            return 0;

        }
        NSString *strKey = [_arrayChar objectAtIndex:section];
        NSInteger _count=[[_dictPinyinAndChinese objectForKey:strKey] count];
        return _count;

        //    return _arrayData.count;

    }else
    {
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



    if(_iscard)
    {
        static NSString *cellid=@"cell_card";
        sousuo_card_Cell *cell_card=[tableView dequeueReusableCellWithIdentifier:cellid ];
        if(!cell_card)
        {
            cell_card=[[sousuo_card_Cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];

        }
        cell_card.selectionStyle=UITableViewCellSelectionStyleNone;
        if(tableView==_tableView)
        {
            if( _arrayData.count>0)
            {
                NSInteger _section=indexPath.section;
                NSString *strKey  = [_arrayChar objectAtIndex:_section];
                NSMutableArray  *__arr=[[NSMutableArray alloc] initWithArray:[_dictPinyinAndChinese objectForKey:strKey]];
                NSInteger num=indexPath.row;
                foundModel *model=__arr[num];

                cell_card.block=self.sousuoBlock;
                NSDictionary *_dict=[[NSDictionary alloc] initWithObjectsAndKeys:model,@"model",[NSNumber numberWithInteger:indexPath.row],@"row",[NSNumber numberWithInteger:indexPath.section],@"section",@"1",@"type",[_arrayChar objectAtIndex:indexPath.section],@"char",[NSNumber numberWithBool:_is_suoyin],@"suoyin",[NSNumber numberWithInteger:_m_row],@"m_row",[NSNumber numberWithInteger:_m_section],@"m_section",nil];
                cell_card.dict=_dict;
            }
        }else
        {

            tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
            NSDictionary *_dict=[[NSDictionary alloc] initWithObjectsAndKeys:[_arrayResult objectAtIndex:indexPath.row],@"model",[NSNumber numberWithInteger:indexPath.row],@"row",[NSNumber numberWithInteger:indexPath.section],@"section",@"2",@"type",[_arrayChar1 objectAtIndex:indexPath.section],@"char",[NSNumber numberWithBool:_is_suoyin],@"suoyin",nil];
            cell_card.block=self.sousuoBlock;
            cell_card.dict=_dict;

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
            if( _arrayData.count>0)
            {
                NSInteger _section=indexPath.section;
                NSString *strKey  = [_arrayChar objectAtIndex:_section];
                NSMutableArray  *__arr=[[NSMutableArray alloc] initWithArray:[_dictPinyinAndChinese objectForKey:strKey]];
                NSInteger num=indexPath.row;
                foundModel *model=__arr[num];
                cell.model =model;
            }
        }else
        {

            tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
            cell.model = [_arrayResult objectAtIndex:indexPath.row];
        }
        return cell;

    }


}

#pragma mark-检测当前偏移量

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{



    if(scrollView==_tableView&&_appear)
    {
        _start_y=scrollView.contentOffset.y;
        JXLOG(@"滚动视图即将开始拖动=%f",scrollView.contentOffset.y);
        _Dragging=YES;
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
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    NSInteger __count = 0;

    //    JXLOG(@"%@-%d",title,index);

    _is_suoyin=YES;
    for(NSString *character in _arrayChar)
    {
        if([character isEqualToString:title])
        {
            return __count;
        }
        __count ++;
    }
    return 0;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    if(_iscard)
    {
        JXLOG(@"%f",scrollView.contentOffset.y);
        CGFloat _height=scrollView.contentOffset.y+CGRectGetHeight(_tableView.frame)-_min_offset-kTabBarHeight;
//        NSInteger now_cell=(NSInteger)(_height/200);
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
                            //        动画显示
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
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(scrollView==_tableView&&_appear)
    {
        _Dragging=NO;
    }
    _is_suoyin=NO;
}

#pragma mark-索引
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    JXLOG(@"%@",_arrayChar);
    JXLOG(@"111");
    if(tableView==_tableView)
    {
        return _arrayChar;
    }
    JXLOG(@"%@",_arrayResult);

    _dictPinyinAndChinese1= [[NSMutableDictionary alloc] init];

    //name = “关羽”
    for (foundModel *model in _arrayResult) {
        //‘GUANYU’
        NSString *pinyin = [ChineseToPinyin pinyinFromChiniseString:model.en_name];

        //“G”
        NSString *charFirst = [pinyin substringToIndex:1];
        //从字典中招关于G的键值对
        NSMutableArray *charArray  = [_dictPinyinAndChinese1 objectForKey:charFirst];
        //没有找到
        if (charArray == nil) {
            NSMutableArray *subArray = [[NSMutableArray alloc] init];
            //“关羽”
            [subArray addObject:model];
            // dict   key = "G"  value = subArray -> "关羽"
            [_dictPinyinAndChinese1 setValue:subArray forKey:charFirst];
        }
        else
        {
            [charArray addObject:model];
        }
    }

    [_arrayChar1 removeAllObjects];
    for (int i = 0; i < 26; i++) {
        NSString *str = [NSString stringWithFormat:@"%c", 'A' + i];
        for (NSString *key in [_dictPinyinAndChinese1 allKeys]) {
            if ([str isEqualToString:key]) {
                [_arrayChar1 addObject:str];
            }
        }
    }
    JXLOG(@"%@",_arrayChar1);
    JXLOG(@"111");



    return _arrayChar1;
}
#pragma mark-点击状态栏时de导航栏重置
- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    _Dragging=NO;
    self.navigationController.navigationBar.frame=CGRectMake(0, kStatusBarHeight, [[UIScreen mainScreen] bounds].size.width, kNavigationBarHeight);
    self.navigationItem.titleView.alpha=1;
    _nav_donghua=NO;
    _leftBarbtn.alpha=1;
    rightbarbtn.alpha=1;

    return YES;
}
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
    [MobClick endLogPageView:@"souSuoViewController"];
}
-(void)viewWillAppear:(BOOL)animated
{

    _appear=YES;
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"souSuoViewController"];

    [[CustomTabbarController sharedManager] tabbarHide];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end
