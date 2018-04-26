//
//  SouSuoViewController.m
//  OneBox
//
//  Created by 谢江新 on 15/6/9.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import "SouSuoViewController.h"

// c文件 —> 系统文件（c文件在前）

// 控制器
#import "SuggestViewController.h"
#import "SchoolDetailViewController.h"
#import "CustomTabbarController.h"

// 自定义视图
#import "SouSuoHeaderView.h"
#import "SouSuoTableView.h"

// 接口

// 分类

// 自定义类和三方类（ cocoapods类 > model > 工具类 > 其他）
#import "MJRefresh.h"

#import "foundModel.h"
#import "TableViewSliderParameterModel.h"
#import "ChineseToPinyin.h"

@interface SouSuoViewController ()

@property (nonatomic, strong) NSMutableArray *arrayData;
@property (nonatomic, strong) NSMutableArray *arrayChar;
@property (nonatomic, strong) NSMutableDictionary *dictPinyinAndChinese;

@property (nonatomic, strong) SouSuoTableView *tableView;
@property (nonatomic, strong) SouSuoHeaderView *headerView;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UIView *banbenview;

@property (nonatomic, strong) YYAnimationIndicator *indicator;

@property (nonatomic, strong) UIButton *rightBarbtn;
@property (nonatomic, strong) UIButton *leftBarbtn;

@property (nonatomic, assign) NSInteger start;//开始
@property (nonatomic, assign) NSInteger count;//数量

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) TableViewSliderParameterModel *parameterModel;//动画相关

@end

@implementation SouSuoViewController

#pragma mark - --------------生命周期--------------
- (void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare];
    [self UIConfig];
    [self indicatorStartAnimation];
    [self RequestData];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [MobClick endLogPageView:@"SouSuoViewController"];

    _parameterModel.isAppear = @(NO);
    _parameterModel.isDragging = @(NO);

    self.navigationController.navigationBar.frame = CGRectMake(0, kStatusBarHeight, [[UIScreen mainScreen] bounds].size.width, kNavigationBarHeight);
    self.navigationItem.titleView.alpha = 1;
    _leftBarbtn.alpha = 1;
    _rightBarbtn.alpha = 1;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [MobClick beginLogPageView:@"SouSuoViewController"];

    _parameterModel.isAppear = @(YES);

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

    _parameterModel = [[TableViewSliderParameterModel alloc] init];
    _parameterModel.bKeyBoardHide = @(YES);//开始时候键盘为隐藏状态
    _parameterModel.isAppear = @(YES);
    _parameterModel.isDragging = @(NO);
    _parameterModel.isNavShow = @(YES);
    _parameterModel.isNavAnimation = @(NO);

    _parameterModel.isCard = @(YES);
    _parameterModel.m_row = @(0);
    _parameterModel.m_section = @(0);

    self.arrayData = [[NSMutableArray alloc] init];
    self.arrayChar = [[NSMutableArray alloc] init];
    self.dictPinyinAndChinese = [[NSMutableDictionary alloc] init];
    self.page = 1;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(navBarReset) name:@"navBarReset" object:nil];

}
- (void)PrepareUI{

    self.view.backgroundColor = _define_backview_color;

    self.navigationItem.titleView=[regular returnNavView:@"搜索结果" withmaxwidth:230];

    _rightBarbtn = [UIButton getCustomImgBtnWithImageStr:@"found_qiehuan_list" WithSelectedImageStr:@"found_qiehuan_card"];
    _rightBarbtn.frame=CGRectMake(0, 0, 20, 20);
    [_rightBarbtn addTarget:self action:@selector(card_qiehuan:) forControlEvents:UIControlEventTouchUpInside];
    _rightBarbtn.selected=YES;
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:_rightBarbtn];

    _leftBarbtn = [UIButton getCustomImgBtnWithImageStr:@"返回箭头" WithSelectedImageStr:nil];
    _leftBarbtn.frame=CGRectMake(0, 0, 22, 22);
    [_leftBarbtn addTarget:self action:@selector(popviewAction) forControlEvents:UIControlEventTouchUpInside];
    [_leftBarbtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:_leftBarbtn];
}

#pragma mark - --------------UIConfig----------------------
-(void)UIConfig{
    [self createTableView];
    [self setupRefresh];
}
-(void)createTableView
{
    WeakSelf(ws);
    if(!_tableView){
        _tableView = [[SouSuoTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(0);
            make.bottom.mas_equalTo(kIPhoneX ? 34.f : 0);
        }];
        _tableView.parameterModel = _parameterModel;
        _tableView.arrayData = _arrayData;
        _tableView.parameterModel = _parameterModel;
        _tableView.dictPinyinAndChinese = _dictPinyinAndChinese;
        _tableView.arrayChar = _arrayChar;

        [_tableView setSouSuoTableViewBlock:^(NSString *type, NSIndexPath *indexPath) {
            if([type isEqualToString:@"navHideAction"]){
                [ws navHideAction];
            }else if([type isEqualToString:@"navShowAction"]){
                [ws navShowAction];
            }else if([type isEqualToString:@"cellClick_schooldetail"]){
                [ws cellClick_schooldetail:indexPath];
            }else if([type isEqualToString:@"scrollViewShouldScrollToTop"]){
                [ws scrollViewShouldScrollToTop];
            }else if([type isEqualToString:@"isapp"]){
                [ws selectModelIsapp:indexPath];
            }
        }];
        [_tableView reloadData];
    }

    if(!_footerView){
        _footerView = [UIView getCustomViewWithColor:_define_backview_color];
        _footerView.frame = CGRectMake(0, 0, CGRectGetWidth(_tableView.frame), 100);
        _footerView.hidden = YES;

        [self banben_view];
    }
    _tableView.tableFooterView=_footerView;
}
-(void)cellClick_schooldetail:(NSIndexPath *)indexPath{
    SchoolDetailViewController *schoolView = [[SchoolDetailViewController alloc] init];
    NSInteger section = indexPath.section;
    JXLOG(@"%@",_arrayChar);
    NSString *strKey = [_arrayChar objectAtIndex:section];
    NSMutableArray  *arr = [[NSMutableArray alloc] initWithArray:[_dictPinyinAndChinese objectForKey:strKey]];
    NSInteger num = indexPath.row;
    FoundModel *model = arr[num];
    schoolView.data_dict = @{
                             @"schoolName":model.cn_name
                             ,@"schoolID":model.sid
                             ,@"is_order_school":[NSNumber numberWithInteger:model.is_order_school]
                             };
    [self.navigationController pushViewController:schoolView animated:YES];
}
-(void)selectModelIsapp:(NSIndexPath *)indexPath{
    FoundModel *model = (_dictPinyinAndChinese[_arrayChar[indexPath.section]])[indexPath.row];
    model.isAppear = @(YES);
}
//导航栏恢复
-(void)scrollViewShouldScrollToTop{
    _parameterModel.isDragging = @(NO);
    self.navigationController.navigationBar.frame=CGRectMake(0, kStatusBarHeight, [[UIScreen mainScreen] bounds].size.width, kNavigationBarHeight);
    self.navigationItem.titleView.alpha=1;
    _leftBarbtn.alpha = 1;
    _rightBarbtn.alpha = 1;
}
-(void)navHideAction{
    _parameterModel.isNavAnimation = @(YES);
    [UIView animateWithDuration:0.2 animations:^{

        self.navigationController.navigationBar.frame = CGRectMake(0, kStatusBarHeight - kStatusBarAndNavigationBarHeight, [[UIScreen mainScreen] bounds].size.width, kNavigationBarHeight);
        self.navigationItem.titleView.alpha = 0;
        _leftBarbtn.alpha = 0;
        _rightBarbtn.alpha = 0;

    } completion:^(BOOL finished) {

        _parameterModel.isNavShow = @(NO);
        _parameterModel.isNavAnimation = @(NO);

    }];

}
-(void)navShowAction{
    _parameterModel.isNavAnimation = @(YES);
    [UIView animateWithDuration:0.2 animations:^{

        self.navigationController.navigationBar.frame = CGRectMake(0, kStatusBarHeight, [[UIScreen mainScreen] bounds].size.width, kNavigationBarHeight);
        self.navigationItem.titleView.alpha = 1;
        _leftBarbtn.alpha = 1;
        _rightBarbtn.alpha = 1;

    } completion:^(BOOL finished) {

        _parameterModel.isNavShow = @(YES);
        _parameterModel.isNavAnimation = @(NO);

    }];
}
-(void)banben_view
{
    _banbenview = [UIImageView getImgWithImageStr:@"版本_v1.0"];
    [_footerView addSubview:_banbenview];
    [_banbenview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_footerView);
        make.width.mas_equalTo(25);
        make.height.mas_equalTo(50*_Scale);
        make.top.mas_equalTo(50*_Scale);
    }];
    _banbenview.hidden = YES;
}
-(void)indicatorStartAnimation{
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

}
- (void)footerRereshing
{
    self.start+=100;
    _page++;
    [self RequestData];
}
- (void)headerRereshing
{
    self.page = 1;
    [_arrayData removeAllObjects];
    _footerView.hidden = YES;
    _banbenview.hidden = YES;
    [self RequestData];
}
#pragma mark - --------------请求数据----------------------
-(void)RequestData{

    _tableView.tableHeaderView = [UIView new];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"query":_keystring
                                 ,@"page":[[NSString alloc] initWithFormat:@"%ld"
                                           ,(long)_page]
                                 };

    [manager GET:[[NSString alloc] initWithFormat:@"%@%@",DNS,@"/v1/schools"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {

        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];

        NSString *html = operation.responseString;
        NSData* data = [html dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

        [self setdata:dict];
        if(!_arrayData.count)
        {
            //没有要找的学校，换一个筛选条件吧
            [self addHeadViewWhenNoData];

            _footerView.hidden = YES;
            _banbenview.hidden = YES;
        }else{
            if([[dict objectForKey:@"data"] count] < 100)
            {
                //说明到底了 没有下一页
                _footerView.hidden = NO;
                _banbenview.hidden = NO;
            }else
            {
                //说明还没完 还有下一页
                _footerView.hidden = YES;
                _banbenview.hidden = YES;
            }
        }
        [_indicator stopAnimationWithLoadText:@"loading..." withType:YES];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_indicator stopAnimationWithLoadText:@"loading..." withType:YES];
        [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
    }];

}

#pragma mark - --------------系统代理----------------------


#pragma mark - --------------自定义代理/block----------------------

#pragma mark - --------------自定义响应----------------------
-(void)saysomething_to_us
{
    [self.navigationController pushViewController:[SuggestViewController new] animated:YES];
}
-(void)card_qiehuan:(UIButton *)btn
{
    if(btn.selected)
    {
        btn.selected = NO;
        _parameterModel.isCard = @(NO);
    }else
    {
        btn.selected = YES;
        _parameterModel.isCard = @(YES);
    }
    if(!_tableView)
    {
        [_tableView reloadData];
    }
}
-(void)popviewAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)navBarReset
{
    self.navigationController.navigationBar.frame = CGRectMake(0, kStatusBarHeight, [[UIScreen mainScreen] bounds].size.width, kNavigationBarHeight);
    self.navigationItem.titleView.alpha = 1;
    _leftBarbtn.alpha = 1;
    _rightBarbtn.alpha = 1;
    _parameterModel.isDragging = @(NO);
    _parameterModel.isNavShow = @(YES);
    _parameterModel.isNavAnimation = @(NO);
}
#pragma mark - --------------自定义方法----------------------
-(void)setKeystring:(NSString *)keystring
{
    if(_keystring != keystring)
    {
        _keystring = [keystring copy];
        self.page = 1;
    }
}
-(void)setdata:(NSDictionary *)dict
{
    if(((NSArray *)[dict objectForKey:@"data"]).count == 0)
    {

        if(_page > 1)
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
        NSArray *_result_arr = [[dict objectForKey:@"data"] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [[obj1 objectForKey:@"en_name"] compare:[obj2 objectForKey:@"en_name"] options:NSNumericSearch];
        }];


        [_arrayData addObjectsFromArray:[FoundModel parsingData:@{@"data":_result_arr}]];
        [_dictPinyinAndChinese removeAllObjects];
        _footerView.backgroundColor = _define_backview_color;
        //name = “关羽”
        for (FoundModel *model in _arrayData) {
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

        [_arrayChar removeAllObjects];
        for (int i = 0; i < 26; i++) {
            NSString *str = [NSString stringWithFormat:@"%c", 'A' + i];
            for (NSString *key in [_dictPinyinAndChinese allKeys]) {
                if ([str isEqualToString:key]) {
                    [_arrayChar addObject:str];
                }
            }
        }

        _parameterModel.m_row = @(0);
        _parameterModel.m_section = @(0);
        NSInteger _count = 0;
        for (int i = 0; i < _arrayChar.count; i++) {
            for (int j = 0; j < [[_dictPinyinAndChinese objectForKey:[_arrayChar objectAtIndex:i]] count]; j++) {
                _count++;
                if(_count <= 2)
                {
                    _parameterModel.m_row = @(j);
                    _parameterModel.m_section = @(i);
                }
                if(_count==2)
                {
                    break;
                }
            }
        }
        [_tableView reloadData];
    }

    if(_start == 0)
    {
        if(dict[@"count"]!=[NSNull null])
        {
            NSString *countStr=(NSString *)dict[@"count"];
            self.count=[countStr intValue];

        }else
        {
            self.count=0;
            [_arrayData removeAllObjects];
            [_arrayChar removeAllObjects];
        }
    }
}

#pragma mark - --------------other----------------------

@end
