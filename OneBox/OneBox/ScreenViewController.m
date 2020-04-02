//
//  ScreenViewController.m
//  OneBox
//
//  Created by 谢江新 on 15/6/9.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import "ScreenViewController.h"

// c文件 —> 系统文件（c文件在前）

// 控制器
#import "SuggestViewController.h"
#import "SchoolDetailViewController.h"
#import "CustomTabbarController.h"

// 自定义视图
#import "ScreenTableView.h"

// 接口

// 分类

// 自定义类和三方类（ cocoapods类 > model > 工具类 > 其他）
#import "MJRefresh.h"

#import "FoundModel.h"
#import "TableViewSliderParameterModel.h"
#import "ChineseToPinyin.h"

@interface ScreenViewController ()<UISearchBarDelegate>

@property (nonatomic, strong) NSMutableArray *arrayData;
@property (nonatomic, strong) NSMutableDictionary *dictPinyinAndChinese;
@property (nonatomic, strong) NSMutableDictionary *dictPinyinAndChinese1;
@property (nonatomic, strong) NSMutableArray *arrayChar;
@property (nonatomic, strong) NSMutableArray *arrayChar1;

@property (nonatomic, strong) ScreenTableView *tableView;

@property (nonatomic, strong) YYAnimationIndicator *indicator;

@property (nonatomic, strong) UIButton *rightBarbtn;
@property (nonatomic, strong) UIButton *leftBarbtn;

@property (nonatomic, assign) NSInteger start;//开始
@property (nonatomic, assign) NSInteger count;//数量

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSNumber *isFirstRequest;//Bool

@property (nonatomic, strong) TableViewSliderParameterModel *parameterModel;//动画相关

@end

@implementation ScreenViewController

#pragma mark - --------------生命周期--------------
-(void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare];
    [self UIConfig];
    [self indicatorStartAnimation];
    [self requestData];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [MobClick endLogPageView:@"ScreenViewController"];

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

    [MobClick beginLogPageView:@"ScreenViewController"];

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
    _parameterModel.m_row1 = @(0);
    _parameterModel.m_section1 = @(0);

    self.page = 1;
    self.isFirstRequest = @(YES);
    self.arrayData = [[NSMutableArray alloc] init];
    self.arrayChar = [[NSMutableArray alloc] init];
    self.arrayChar1 = [[NSMutableArray alloc] init];
    self.dictPinyinAndChinese = [[NSMutableDictionary alloc] init];
    self.dictPinyinAndChinese1 = [[NSMutableDictionary alloc] init];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(navBarReset) name:@"navBarReset" object:nil];
}
- (void)PrepareUI{

    self.view.backgroundColor = _define_backview_color;

    self.navigationItem.titleView = [regular returnNavView:@"筛选结果" withmaxwidth:230];

    _leftBarbtn = [UIButton getCustomImgBtnWithImageStr:@"返回箭头" WithSelectedImageStr:nil];
    _leftBarbtn.frame = CGRectMake(0, 0, 22, 22);
    [_leftBarbtn addTarget:self action:@selector(popviewAction) forControlEvents:UIControlEventTouchUpInside];
    [_leftBarbtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_leftBarbtn];

    _rightBarbtn = [UIButton getCustomBackImgBtnWithImageStr:@"found_qiehuan_list" WithSelectedImageStr:@"found_qiehuan_card"];
    _rightBarbtn.frame = CGRectMake(0, 0, 20, 20);
    [_rightBarbtn addTarget:self action:@selector(card_qiehuan:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightBarbtn];

    _rightBarbtn.selected = YES;
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
        _tableView = [[ScreenTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain parameterModel:_parameterModel arrayData:_arrayData dictPinyinAndChinese:_dictPinyinAndChinese arrayChar:_arrayChar dictPinyinAndChinese1:_dictPinyinAndChinese1 arrayChar1:_arrayChar1 isFirstRequest:_isFirstRequest controller:self sreenTableViewBlock:^(NSString *type, NSIndexPath *indexPath) {
            if([type isEqualToString:@"navHideAction"]){
                [ws navHideAction];
            }else if([type isEqualToString:@"navShowAction"]){
                [ws navShowAction];
            }else if([type isEqualToString:@"cellClick_schooldetail1"] || [type isEqualToString:@"cellClick_schooldetail2"]){
                [ws cellClick_schooldetail:indexPath WithType:type];
            }else if([type isEqualToString:@"isapp1"] || [type isEqualToString:@"isapp2"]){
                [ws selectModelIsapp:indexPath WithType:type];
            }else if([type isEqualToString:@"scrollViewShouldScrollToTop"]){
                [ws scrollViewShouldScrollToTop];
            }else if([type isEqualToString:@"saysomething_to_us"]){
                [ws saysomething_to_us];
            }
        }];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(0);
            make.bottom.mas_equalTo(kIPhoneX ? 34.f : 0);
        }];
    }
}
-(void)indicatorStartAnimation{
    if(!_indicator){
        _indicator = [[YYAnimationIndicator alloc] initWithFrame:CGRectZero];
        [self.view addSubview:_indicator];
        [_indicator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.view);
            make.width.height.mas_equalTo(40*_Scale*2);
        }];
        [_indicator setLoadText:@"loading..."];
    }
    [_indicator startAnimation];
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
    _start += 100;
    _page++;
    [self requestData];
}
- (void)headerRereshing
{
    _page = 1;
    [_arrayData removeAllObjects];
    _tableView.footerView.hidden = YES;
    _tableView.banbenView.hidden = YES;
    [self requestData];
}
#pragma mark - --------------请求数据----------------------
-(void)requestData
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    JXLOG(@"%@",_data_dict);
    [_data_dict setValue:[[NSString alloc] initWithFormat:@"%ld",(long)_page] forKey:@"page"];

    [manager GET:[[NSString alloc] initWithFormat:@"%@%@",DNS,@"/v1/schools"] parameters:_data_dict success:^(AFHTTPRequestOperation *operation, id responseObject) {

        //        结束刷新
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];

        [self.indicator stopAnimationWithLoadText:@"loading..." withType:YES];

        NSString *html = operation.responseString;
        NSData* data = [html dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict = [NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];

        [self analysisDataWhenRequestSuccess:dict];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];

        [self.indicator stopAnimationWithLoadText:@"loading..." withType:YES];
        [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
    }];
}
#pragma mark - --------------系统代理----------------------

#pragma mark - --------------自定义代理/block----------------------


#pragma mark - --------------自定义响应----------------------
-(void)selectModelIsapp:(NSIndexPath *)indexPath WithType:(NSString *)type{
    if([type isEqualToString:@"isapp1"]){
        FoundModel *model = (_dictPinyinAndChinese[_arrayChar[indexPath.section]])[indexPath.row];
        model.isAppear = @(YES);
    }else if([type isEqualToString:@"isapp2"]){
        FoundModel *model = (_dictPinyinAndChinese1[_arrayChar1[indexPath.section]])[indexPath.row];
        model.isAppear = @(YES);
    }
}
//导航栏恢复
-(void)scrollViewShouldScrollToTop{
    _parameterModel.isDragging = @(NO);
    self.navigationController.navigationBar.frame = CGRectMake(0, kStatusBarHeight, [[UIScreen mainScreen] bounds].size.width, kNavigationBarHeight);
    self.navigationItem.titleView.alpha = 1;
    _leftBarbtn.alpha = 1;
    _rightBarbtn.alpha = 1;
}
-(void)navHideAction{
    _parameterModel.isNavAnimation = @(YES);
    [UIView animateWithDuration:0.2 animations:^{

        self.navigationController.navigationBar.frame = CGRectMake(0, kStatusBarHeight - kStatusBarAndNavigationBarHeight, [[UIScreen mainScreen] bounds].size.width, kNavigationBarHeight);
        self.navigationItem.titleView.alpha = 0;
        self.leftBarbtn.alpha = 0;
        self.rightBarbtn.alpha = 0;

    } completion:^(BOOL finished) {

        self.parameterModel.isNavShow = @(NO);
        self.parameterModel.isNavAnimation = @(NO);

    }];
}
-(void)navShowAction{
    _parameterModel.isNavAnimation = @(YES);
    [UIView animateWithDuration:0.2 animations:^{

        self.navigationController.navigationBar.frame = CGRectMake(0, kStatusBarHeight, [[UIScreen mainScreen] bounds].size.width, kNavigationBarHeight);
        self.navigationItem.titleView.alpha = 1;
        self.leftBarbtn.alpha = 1;
        self.rightBarbtn.alpha = 1;

    } completion:^(BOOL finished) {

        self.parameterModel.isNavShow = @(YES);
        self.parameterModel.isNavAnimation = @(NO);

    }];
}
-(void)cellClick_schooldetail:(NSIndexPath *)indexPath WithType:(NSString *)type{
    SchoolDetailViewController *schoolView = [[SchoolDetailViewController alloc] init];

    FoundModel *model = nil;

    if([type isEqualToString:@"cellClick_schooldetail1"])
    {
        model = (_dictPinyinAndChinese[_arrayChar[indexPath.section]])[indexPath.row];
    }else
    {
        model = (_dictPinyinAndChinese1[_arrayChar1[indexPath.section]])[indexPath.row];
    }

    schoolView.data_dict = @{
                             @"schoolName":model.cn_name
                             ,@"schoolID":model.sid
                             ,@"is_order_school":@(model.is_order_school)
                             };

    [self.navigationController pushViewController:schoolView animated:YES];
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
    if(_tableView != nil)
    {
        [_tableView reloadData];
    }
}
-(void)saysomething_to_us
{
    [self.navigationController pushViewController:[SuggestViewController new] animated:YES];
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
-(void)popviewAction
{
    [_tableView removeSearchController];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - --------------自定义方法----------------------
-(void)analysisDataWhenRequestSuccess:(NSDictionary *)dict
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

    }else
    {

        NSArray *result_arr = [[dict objectForKey:@"data"] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [[obj1 objectForKey:@"en_name"] compare:[obj2 objectForKey:@"en_name"] options:NSNumericSearch];
        }];


        [_arrayData addObjectsFromArray:[FoundModel parsingData:@{@"data":result_arr}]];

        _tableView.footerView.backgroundColor=_define_backview_color;

        [_dictPinyinAndChinese removeAllObjects];

        //name = “关羽”
        for (FoundModel *model in _arrayData) {
            //‘GUANYU’
            NSString *pinyin = [ChineseToPinyin pinyinFromChiniseString:model.en_name];

            //“G”
            NSString *charFirst = [pinyin substringToIndex:1];
            //从字典中招关于G的键值对
            NSMutableArray *charArray = [_dictPinyinAndChinese objectForKey:charFirst];
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
        NSInteger count = 0;
        for (int i = 0; i < _arrayChar.count; i++) {
            for (int j = 0; j < [[_dictPinyinAndChinese objectForKey:[_arrayChar objectAtIndex:i]] count]; j++) {
                count++;
                if(count <= 2)
                {
                    _parameterModel.m_row = @(j);
                    _parameterModel.m_section = @(i);
                }
                if(count == 2)
                {
                    break;
                }
            }
        }
        JXLOG(@"%ld %ld",[_parameterModel.m_row integerValue],[_parameterModel.m_section integerValue]);
        [_tableView reloadData];
    }

    if(_start == 0)
    {
        if(dict[@"count"] != [NSNull null])
        {
            NSString *countStr = (NSString *)dict[@"count"];
            _count = [countStr intValue];
        }else
        {
            _count = 0;
            [_arrayData removeAllObjects];
            [_arrayChar removeAllObjects];
        }
    }

    if(!self.arrayData.count)
    {
        //没有要找的学校，换一个筛选条件吧
        [self.tableView createHeaderViewWhenNoData];
    }else{
        [self.tableView createSearchController];
    }
    if([[dict objectForKey:@"data"] count] < 100)
    {
        self.tableView.banbenView.hidden = NO;
    }else
    {
        self.tableView.banbenView.hidden = YES;
    }

    if(_page == 1 && [_isFirstRequest boolValue]){
        [_tableView animationNotification];
    }
}

#pragma mark - --------------other----------------------

@end
