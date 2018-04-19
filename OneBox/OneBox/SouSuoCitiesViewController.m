//
//  souSuoViewController.m
//  OneBox
//
//  Created by 谢江新 on 15/6/9.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import "SouSuoCitiesViewController.h"

// c文件 —> 系统文件（c文件在前）

// 控制器
#import "suggestViewController.h"
#import "SchoolDetailViewController.h"
#import "CustomTabbarController.h"

// 自定义视图
#import "FoundCell.h"
#import "sousuo_card_Cell.h"

// 接口

// 分类

// 自定义类和三方类（ cocoapods类 > model > 工具类 > 其他）
#import "MJRefresh.h"

#import "foundModel.h"
#import "ChineseToPinyin.h"

#define foundCellHeight 184*_Scale
#define foundCellHeight_card 400*_Scale

@interface SouSuoCitiesViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, assign) NSInteger m_row;
@property (nonatomic, assign) NSInteger m_section;
@property (nonatomic, strong) YYAnimationIndicator *indicator;
@property (nonatomic, strong) UIView *banbenview;
@property (nonatomic, strong) UIView *footview;

@property (nonatomic, strong) NSDictionary *dictPinyinAndChinese;
@property (nonatomic, strong) NSMutableArray *arrayChar;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger start;//开始
@property (nonatomic, assign) NSInteger count;//数量

@property (nonatomic, strong) NSMutableArray *arrayData;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) UIButton *rightbarbtn;
@property (nonatomic, assign) BOOL iscard;
@property (nonatomic, assign) NSInteger Record_cell_num;
@property (nonatomic, assign) CGFloat min_offset;
@property (nonatomic, assign) CGFloat start_y;
@property (nonatomic, assign) BOOL Dragging;
@property (nonatomic, assign) BOOL appear;
@property (nonatomic, assign) BOOL nav_donghua;
@property (nonatomic, strong) UIButton *leftBarbtn;
@property (nonatomic, assign) BOOL is_suoyin;//是否点击索引

@end

@implementation SouSuoCitiesViewController
#pragma mark - --------------生命周期--------------
- (void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare];
    [self UIConfig];
    [self RequestData];
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
    _rightbarbtn.alpha=1;

    [MobClick endLogPageView:@"souSuoViewController"];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _appear=YES;
    [MobClick beginLogPageView:@"souSuoViewController"];

    [[CustomTabbarController sharedManager] tabbarHide];
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
    WeakSelf(ws);
    self.sousuoBlock=^(NSInteger row ,NSInteger section,NSString *type)
    {
        if([type isEqualToString:@"1"])
        {
            foundModel *model=[[ws.dictPinyinAndChinese objectForKey:[ws.arrayChar objectAtIndex:section]] objectAtIndex:row];

            model.isapp=YES;
        }
    };

    _m_row=0;
    _m_section=0;

    _is_suoyin=NO;
    _nav_donghua=NO;
    _appear=YES;
    _Dragging=NO;
    _start_y=0;
    _Record_cell_num=0;
    _iscard=YES;

    _arrayData=[[NSMutableArray alloc] init];
    _page=1;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(navBarReset) name:@"navBarReset" object:nil];
}
- (void)PrepareUI{
    self.view.backgroundColor=_define_backview_color;

    _leftBarbtn = [UIButton getCustomImgBtnWithImageStr:@"返回箭头" WithSelectedImageStr:nil];
    _leftBarbtn.frame=CGRectMake(0, 0, 22, 22);
    [_leftBarbtn addTarget:self action:@selector(popviewAction) forControlEvents:UIControlEventTouchUpInside];
    [_leftBarbtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    UIBarButtonItem *_btn=[[UIBarButtonItem alloc] initWithCustomView:_leftBarbtn];
    self.navigationItem.leftBarButtonItem=_btn;

    self.rightbarbtn = [UIButton getCustomImgBtnWithImageStr:@"found_qiehuan_list" WithSelectedImageStr:@"found_qiehuan_card"];
    _rightbarbtn.frame=CGRectMake(0, 0, 20, 20);
    [_rightbarbtn addTarget:self action:@selector(card_qiehuan:) forControlEvents:UIControlEventTouchUpInside];
    _rightbarbtn.selected=YES;
    UIBarButtonItem *btn=[[UIBarButtonItem alloc] initWithCustomView:_rightbarbtn];
    self.navigationItem.rightBarButtonItem=btn;
}

#pragma mark - --------------UIConfig----------------------
-(void)UIConfig{
    [self createTableView];
    [self setupRefresh];
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
    _footview=[[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_tableView.frame), 100)];
    _tableView.backgroundColor=_define_backview_color;
    _tableView.tableFooterView=_footview;
    _min_offset=_tableView.contentOffset.y;
    [self banben_view];
}
-(void)banben_view
{
    self.banbenview=[[UIView alloc] initWithFrame:CGRectMake((CGRectGetWidth(_tableView.frame)-100*_Scale)/2.0f,50*_Scale, 100*_Scale, 100*_Scale)];
    _banbenview.backgroundColor=[UIColor clearColor];
    [_footview addSubview:_banbenview];
    UIImageView *banbenimg=[[UIImageView alloc] initWithFrame:CGRectMake(25*_Scale, 0, 25, 50*_Scale)];
    banbenimg.image=[UIImage imageNamed:@"版本_v1.0"];
    [_banbenview addSubview:banbenimg];

    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(banbenimg.frame), CGRectGetWidth(_banbenview.frame), CGRectGetHeight(_banbenview.frame)-CGRectGetMaxY(banbenimg.frame))];
    label.textAlignment=1;

    label.textColor=[UIColor colorWithRed:193.0f/255.0f green:193.0f/255.0f blue:193.0f/255.0f alpha:1];
    label.font=[regular get_en_Font:11.0f];
    [_banbenview addSubview:label];

    _banbenview.hidden=YES;
}
//Refresh
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
    self.start+=100;
    _page++;
    [self RequestData];
}
- (void)headerRereshing
{
    _page=1;
    [_arrayData removeAllObjects];
    [self RequestData];
}
#pragma mark - --------------请求数据----------------------
-(void)RequestData
{
    if(!_indicator){
        _indicator = [[YYAnimationIndicator alloc]initWithFrame:CGRectZero];
        [self.view addSubview:_indicator];
        [_indicator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.view);
            make.width.height.mas_equalTo(40*_Scale*2);
        }];
        [_indicator setLoadText:@"loading..."];
    }
    [_indicator startAnimation];

    _tableView.tableHeaderView=[UIView new];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    NSDictionary *parameters=@{@"areas":[_cityNameDict objectForKey:@"city_names"],@"page":[[NSString alloc] initWithFormat:@"%ld",(long)_page]};
    [manager GET:[[NSString alloc] initWithFormat:@"%@/v2/schools/schools_by_areas",DNS] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {

        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];

        NSString *html = operation.responseString;
        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
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
            _banbenview.hidden=NO;
        }else
        {
            _banbenview.hidden=YES;
        }
        [_indicator stopAnimationWithLoadText:@"loading..." withType:YES];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_indicator stopAnimationWithLoadText:@"loading..." withType:YES];
        [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
    }];

}

#pragma mark - --------------系统代理----------------------

#pragma mark - UIScrollViewDelegate
- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    _Dragging=NO;
    self.navigationController.navigationBar.frame=CGRectMake(0, kStatusBarHeight, [[UIScreen mainScreen] bounds].size.width, kNavigationBarHeight);
    self.navigationItem.titleView.alpha=1;
    _nav_donghua=NO;
    _leftBarbtn.alpha=1;
    _rightbarbtn.alpha=1;

    return YES;
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if(_appear)
    {
        _start_y=scrollView.contentOffset.y;
        JXLOG(@"滚动视图即将开始拖动=%f",scrollView.contentOffset.y);
        _Dragging=YES;
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    if(_iscard)
    {
        CGFloat _height=scrollView.contentOffset.y+CGRectGetHeight(_tableView.frame)-_min_offset-kTabBarHeight;
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
            NSDictionary *pushnum=[self getnumWithChar:_arrayChar WithPinyin:_dictPinyinAndChinese];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SousuoAnimation" object:pushnum];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SousuoAnimation1" object:nil];
    }
    if(_Dragging)
    {
        if(_appear)
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
                    _rightbarbtn.alpha=0;
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
                        _rightbarbtn.alpha=1;
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
                            _rightbarbtn.alpha=0;
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
                            _rightbarbtn.alpha=1;
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
    if(_appear)
    {
        _Dragging=NO;
    }
    _is_suoyin=NO;
}
#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    NSInteger __count = 0;

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
    foundModel *model=__arr[num];
    schoolView.data_dict=[[NSDictionary alloc] initWithObjectsAndKeys:model.cn_name,@"schoolName",model.sid,@"schoolID",[NSNumber numberWithInteger:model.is_order_school],@"is_order_school",nil];

    [self.navigationController pushViewController:schoolView animated:YES];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger _count=_arrayChar.count;
    return _count;

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_arrayData.count==section)
    {
        return 0;

    }
    NSString *strKey = [_arrayChar objectAtIndex:section];
    NSInteger _count=[[_dictPinyinAndChinese objectForKey:strKey] count];
    return _count;
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
        cell_card.block=self.sousuoBlock;
        NSDictionary *_dict=[[NSDictionary alloc] initWithObjectsAndKeys:[[_dictPinyinAndChinese objectForKey:[_arrayChar objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row],@"model",[NSNumber numberWithInteger:indexPath.row],@"row",[NSNumber numberWithInteger:indexPath.section],@"section",@"1",@"type",[_arrayChar objectAtIndex:indexPath.section],@"char",[NSNumber numberWithBool:_is_suoyin],@"suoyin",[NSNumber numberWithInteger:_m_row],@"m_row",[NSNumber numberWithInteger:_m_section],@"m_section",nil];
        cell_card.dict=_dict;
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
        cell.model =[[_dictPinyinAndChinese objectForKey:[_arrayChar objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;

    }
}
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    JXLOG(@"%@",_arrayChar);
    JXLOG(@"111");
    return _arrayChar;
}

#pragma mark - --------------自定义代理/block----------------------


#pragma mark - --------------自定义响应----------------------
-(void)saysomething_to_us
{
    [self.navigationController pushViewController:[suggestViewController new] animated:YES];
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
-(void)popviewAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - --------------自定义方法----------------------

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

        //        cn_name
        NSArray *_result_arr=[[_dict objectForKey:@"data"] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [[obj1 objectForKey:@"en_name"] compare:[obj2 objectForKey:@"en_name"] options:NSNumericSearch];
        }];


        [_arrayData addObjectsFromArray:[foundModel parsingData:@{@"data":_result_arr}]];
        _dictPinyinAndChinese = [[NSMutableDictionary alloc] init];
        _footview.backgroundColor=_define_backview_color;
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

    if(_start==0)
    {
        if(_dict[@"count"]!=[NSNull null])
        {
            NSString *countStr=(NSString *)_dict[@"count"];
            self.count=[countStr intValue];

        }else
        {
            self.count=0;
            [_arrayData removeAllObjects];
            [_arrayChar removeAllObjects];
        }
    }
}

-(void)setCityNameDict:(NSDictionary *)cityNameDict
{
    if(_cityNameDict!=cityNameDict)
    {
        _cityNameDict=[cityNameDict copy];
        _page=1;
        self.navigationItem.titleView=[regular returnNavView:[cityNameDict objectForKey:@"title"] withmaxwidth:230];

    }
}
//导航栏重置
-(void)navBarReset
{
    _Dragging=NO;
    self.navigationController.navigationBar.frame=CGRectMake(0, kStatusBarHeight, [[UIScreen mainScreen] bounds].size.width, kNavigationBarHeight);
    self.navigationItem.titleView.alpha=1;
    _nav_donghua=NO;
    _leftBarbtn.alpha=1;
    _rightbarbtn.alpha=1;
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
#pragma mark - --------------other----------------------

@end
