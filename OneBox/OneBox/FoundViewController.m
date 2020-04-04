//
//  FoundViewController.m
//  OneBox
//
//  Created by 谢江新 on 15/12/7.
//  Copyright © 2015年 谢江新. All rights reserved.
//

#import "FoundViewController.h"

// c文件 —> 系统文件（c文件在前）

// 控制器
#import "OnlineProjectsViewController.h"
#import "MapViewController.h"
#import "ScreenViewController.h"
#import "SouSuoCitiesViewController.h"
#import "SchoolDetailViewController.h"
#import "SouSuoViewController.h"
#import "bangdanlistViewController.h"
#import "bangdanViewController.h"
#import "CustomTabbarController.h"

// 自定义视图
#import "FoundListSousuoView.h"
#import "FoundListTableHeaderView.h"
#import "FoundListBangdanView.h"
#import "FoundListScreenView.h"
#import "FoundTableView.h"

// 接口

// 分类

// 自定义类和三方类（ cocoapods类 > model > 工具类 > 其他）
#import "MJRefresh.h"

#import "FoundModel_new.h"
#import "TableViewSliderParameterModel.h"

@interface FoundViewController ()

@property (nonatomic, strong) NSMutableArray *arrayData;//存放页面的数据

//view
@property (nonatomic, strong) FoundListTableHeaderView *tableHeaderView;//headview的背景图
@property (nonatomic, strong) FoundListSousuoView *sousuoView;
@property (nonatomic, strong) FoundListBangdanView *bangdanView;
@property (nonatomic, strong) FoundListScreenView *screenView;

@property (nonatomic, strong) UIButton *rightbtn;

@property (nonatomic, strong) FoundTableView *tableView;

//动画相关
@property (nonatomic, strong) TableViewSliderParameterModel *parameterModel;

@property (nonatomic, assign) NSInteger page;//记录当前page

@property (nonatomic, strong) NSNumber *total_students_min;//记录学生数的最小值
@property (nonatomic, strong) NSNumber *ap_count_max;//记录ap课程数量的最大值
@property (nonatomic, strong) NSNumber *total_students_max;//记录学生数的最大值
@property (nonatomic, strong) NSNumber *ap_count_min;//记录ap课程数量的最小值

@end

@implementation FoundViewController
#pragma mark - --------------生命周期--------------
- (void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare];
    [self UIConfig];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    _parameterModel.isAppear = @(YES);
    //    tabbar设为出现
    [[CustomTabbarController sharedManager] tabbarAppear];
    //    友盟页面监控（登出）
    [MobClick beginLogPageView:@"FoundViewController"];

    self.navigationController.navigationBar.subviews[0].subviews[0].hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //    导航栏还原
    _parameterModel.isAppear = @(NO);
    _parameterModel.isDragging = @(NO);
    self.rightbtn.alpha = 1;
    self.navigationController.navigationBar.frame = CGRectMake(0, kStatusBarHeight, [[UIScreen mainScreen] bounds].size.width, kNavigationBarHeight);
    self.navigationItem.titleView.alpha = 1;
    //    友盟页面监控（进入）
    [MobClick endLogPageView:@"FoundViewController"];
    
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
-(void)PrepareData
{
    [self initializeData];
    [self createNotication];
}
-(void)initializeData{
    _parameterModel = [[TableViewSliderParameterModel alloc] init];
    _parameterModel.bKeyBoardHide = @(YES);//开始时候键盘为隐藏状态
    _parameterModel.isAppear = @(YES);
    _parameterModel.isDragging = @(NO);
    _parameterModel.isNavShow = @(YES);
    _parameterModel.isNavAnimation = @(NO);
    self.arrayData = [[NSMutableArray alloc] init];

    self.page = 1;
}
//创建该界面中的Notication
-(void)createNotication
{
    //    将导航栏的位置还原（应对 app推出后台时候导航栏异常情况）
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(navBarReset) name:@"navBarReset" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(xiaoshi:) name:@"xiaoshi" object:nil];

    //    添加键盘监控,在键盘消失或者出现时候会调用，来改变bKeyBoardHide的值，以此来判断当前键盘是否为弹出状态
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
-(void)PrepareUI
{
    //    设置导航栏颜色
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:70.0f/255.0f green:195.0f/255.0f blue:247.0f/255.0f alpha:1];
    //    设置背景颜色
    self.view.backgroundColor = _define_backview_color;

    //    添加标题
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 230, 40)];
    UIImageView *icon = [UIImageView getImgWithImageStr:@"login_ICON11"];
    [view addSubview:icon];
    if(_isPad)
    {
        icon.frame = CGRectMake((CGRectGetWidth(view.frame)-32.5)/2.0f, (CGRectGetHeight(view.frame)-31.5)/2.0f-5*_Scale, 32.5, 31.5);
    }else
    {
        icon.frame = CGRectMake((CGRectGetWidth(view.frame)-65*_Scale)/2.0f, (CGRectGetHeight(view.frame)-63*_Scale)/2.0f-5*_Scale, 65*_Scale, 63*_Scale);
    }
    self.navigationItem.titleView = view;

    _rightbtn = [UIButton getCustomBackImgBtnWithImageStr:@"found_right_btn" WithSelectedImageStr:nil];
    _rightbtn.frame = CGRectMake(0, 0, 20, 20);
    [_rightbtn addTarget:self action:@selector(createSousuoView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc] initWithCustomView:_rightbtn];
    self.navigationItem.rightBarButtonItem = bar;

}

#pragma mark - --------------UIConfig----------------------
-(void)UIConfig{
    //    创建tableview
    [self createTableView];
}
-(void)createTableView
{
    WeakSelf(ws);
    _tableView = [[FoundTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.bottom.mas_equalTo(kIPhoneX?-kTabBarHeight:-kStatusBarAndNavigationBarHeight);
    }];
    _tableView.parameterModel = _parameterModel;
    _tableView.arrayData = _arrayData;
    [_tableView setFoundTableViewBlock:^(NSString *type, NSIndexPath *indexPath) {
        if([type isEqualToString:@"navHideAction"]){
            [ws navHideAction];
        }else if([type isEqualToString:@"navShowAction"]){
            [ws navShowAction];
        }else if([type isEqualToString:@"scrollViewShouldScrollToTop"]){
            [ws scrollViewShouldScrollToTop];
        }else if([type isEqualToString:@"cellClick_rank"]){
            [ws cellClick_rank:indexPath];
        }else if([type isEqualToString:@"cellClick_schooldetail"]){
            [ws cellClick_schooldetail:indexPath];
        }else if([type isEqualToString:@"cellClick_sousuo"]){
            [ws cellClick_sousuo:indexPath];
        }
    }];
    [_tableView reloadData];

    [self setupRefresh];
}
-(void)createTableHeadView:(NSString *)headviewimage
{
    if(!_tableHeaderView){
        WeakSelf(ws);
        //    创建tableview的headview，为空的时候（即网络数据获取后创建）
        _tableHeaderView = [[FoundListTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 420*_Scale)];
        _tableView.tableHeaderView = _tableHeaderView;
        [_tableHeaderView setHeadViewBlock:^(NSString *type ,NSString *textFieldStr) {
            if([type isEqualToString:@"gotoSouSuoView"]){
                //跳转搜索界面
                [ws pushToSouSuoView:textFieldStr];
            }else if([type isEqualToString:@"tapActionBangdan"]){
                //榜单
                [ws createBangdanView];
            }else if([type isEqualToString:@"tapActionMap"]){
                //地图
                [ws gotoMapView];
            }else if([type isEqualToString:@"tapActionScreen"]){
                //筛选
                [ws requestScreenViewData];
            }
        }];
        _tableHeaderView.backViewImagePath = headviewimage;
        [_tableHeaderView updateUI];
    }
}
//创建搜索视图
-(void)createSousuoView
{
    [regular dismissKeyborad];
    if(!_sousuoView){
        WeakSelf(ws);
        _sousuoView = [[FoundListSousuoView alloc] initWithFrame:CGRectZero];
        [self.view addSubview:_sousuoView];
        [_sousuoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.view);
        }];
        [_sousuoView setSousuoViewBlock:^(NSString *type, NSString *textFieldStr) {
            if([type isEqualToString:@"gotoSouSuoView"]){
                //跳转搜索界面
                [ws pushToSouSuoView:textFieldStr];
            }
        }];
    }else{
        _sousuoView.hidden = NO;
    }
}
//榜单
-(void)createBangdanView
{
    [regular dismissKeyborad];
    if(!_bangdanView){
        WeakSelf(ws);
        _bangdanView = [[FoundListBangdanView alloc] initWithFrame:CGRectZero];
        [self.view addSubview:_bangdanView];
        [_bangdanView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.view);
        }];
        [_bangdanView setBangdanViewBlock:^(NSString *type) {
            [ws bangdanAction:type];
        }];
    }else{
        _bangdanView.hidden = NO;
    }
}
// 创建筛选视图
-(void)createScreenView{
    [regular dismissKeyborad];
    if(!_screenView){
        WeakSelf(ws);
        _screenView = [[FoundListScreenView alloc] initWithFrame:CGRectZero];
        [self.view addSubview:_screenView];
        [_screenView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.view);
        }];
        [_screenView setScreenViewBlock:^(NSString *type) {
            if([type isEqualToString:@"hideAll"]){
                [ws.screenView initializeUI];
                ws.screenView.hidden = YES;
            }else if([type isEqualToString:@"screen"]){
                [ws screenAction];
            }
        }];
        _screenView.total_students_min = _total_students_min;
        _screenView.ap_count_max = _ap_count_max;
        _screenView.total_students_max = _total_students_max;
        _screenView.ap_count_min = _ap_count_min;
        [_screenView updateUI];
    }else{
        _screenView.hidden = NO;
    }
}
// 筛选视图请求
-(void)requestScreenViewData
{
    [regular dismissKeyborad];
    if(!_screenView){
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:[[NSString alloc] initWithFormat:@"%@/v1/schools/pre_search",DNS] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *html = operation.responseString;
            NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
            //        进行解析以后的操作
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            if([[dict objectForKey:@"code"] integerValue]==1)
            {
                NSString *html = operation.responseString;
                NSData* data = [html dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

                _total_students_min = [[dict objectForKey:@"data"] objectForKey:@"total_students_min"];
                _ap_count_max = [[dict objectForKey:@"data"] objectForKey:@"ap_count_max"];
                _total_students_max = [[dict objectForKey:@"data"] objectForKey:@"total_students_max"];
                _ap_count_min = [[dict objectForKey:@"data"] objectForKey:@"ap_count_min"];

                if((!_bangdanView || _bangdanView.hidden) && (!_sousuoView || _sousuoView.hidden)){
                    [self createScreenView];
                }

            }else
            {
                [[ToolManager sharedManager] alertTitle_Simple:[dict objectForKey:@"message"]];
            }

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
        }];
    }else{
        _screenView.hidden = NO;
    }
}
#pragma mark - --------------请求数据----------------------
//主界面列表数据的请求
-(void)requestData
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[[NSString alloc] initWithFormat:@"%ld",(long)_page] forKey:@"page"];
    [dict setObject:[regular getToken] forKey:@"token"];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[[NSString alloc] initWithFormat:@"%@%@",DNS,@"/v2/app_modules"] parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        请求成功后的处理
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        if(_page == 1)
        {
            [_arrayData removeAllObjects];//删除所有数据
        }
        //headview背景图url
        NSString *headviewimage = [[responseObject objectForKey:@"data"] objectForKey:@"search_bg"];
        [self createTableHeadView:headviewimage];

        //数据处理，获取模型数组
        NSArray *getdata = [FoundModel_new parsingData:responseObject];
        //当获取数据count数量大于0时候，刷新tableview

        if(getdata.count > 0)
        {
            [_arrayData addObjectsFromArray:getdata];
            [_tableView reloadData];
        }else
        {
            [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"没有更多了" WithImg:@"Prompt_提交成功" Withtype:1]];
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_tableView.mj_header endRefreshing];
        [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
    }];
}

#pragma mark - --------------系统代理----------------------

#pragma mark - --------------自定义代理/block----------------------

#pragma mark - --------------自定义响应----------------------
//跳转搜索结果view
-(void)pushToSouSuoView:(NSString *)textFieldStr{
    SouSuoViewController *sousuo = [[SouSuoViewController alloc] init];
    sousuo.keystring = textFieldStr;
    [self.navigationController pushViewController:sousuo animated:YES];
}
//跳转榜单view
-(void)bangdanAction:(NSString *)type
{
    //    榜单跳转到下个页面，榜单的type类型区分不同的榜单
    if(![NSString isNilOrEmpty:type]){
        if([type isEqualToString:@"bangdan_niche"]){
            bangdanViewController *bangdan = [[bangdanViewController alloc] init];
            bangdan.type = 1;
            [self.navigationController pushViewController:bangdan animated:YES];
        }else if([type isEqualToString:@"bangdan_business_insider"]){
            bangdanViewController *bangdan = [[bangdanViewController alloc] init];
            bangdan.type = 2;
            [self.navigationController pushViewController:bangdan animated:YES];
        }else if([type isEqualToString:@"bangdan_prep_review"]){
            [self.navigationController pushViewController:[bangdanlistViewController new] animated:YES];
        }else if([type isEqualToString:@"bangdan_blueribbon"]){
            bangdanViewController *bangdan = [[bangdanViewController alloc] init];
            bangdan.type = 4;
            [self.navigationController pushViewController:bangdan animated:YES];
        }
    }
}
//跳转地图view
-(void)gotoMapView
{
    MapViewController *mapView = [[MapViewController alloc] init];
    [self.navigationController pushViewController:mapView animated:YES];
}
//筛选
-(void)screenAction{
    if(_screenView){
        _page = 1;
        NSMutableDictionary *parameters = [_screenView getParameters];
        if(_page > 0)
        {
            [parameters setObject:[[NSString alloc] initWithFormat:@"%ld",(long)_page] forKey:@"page"];
        }

        //当没有选择筛选条件时，不给予跳转，提示请选择筛选条件。没有选择时，key count为2
        NSArray *keyarr = [parameters allKeys];

        if(keyarr.count > 2)
        {
            ScreenViewController *shaixuan = [[ScreenViewController alloc] init];
            shaixuan.data_dict = parameters;
            [self.navigationController pushViewController:shaixuan animated:YES];
        }else
        {
            [[ToolManager sharedManager] alertTitle_Simple:@"请选择筛选条件"];
        }
    }
}
#pragma mark - navAction
//导航栏上滑动画
-(void)navHideAction
{
    _parameterModel.isNavAnimation = @(YES);
    [UIView animateWithDuration:0.2 animations:^{

        self.navigationController.navigationBar.frame = CGRectMake(0, kStatusBarHeight - kStatusBarAndNavigationBarHeight, [[UIScreen mainScreen] bounds].size.width, kNavigationBarHeight);
        self.navigationItem.titleView.alpha = 0;
        _rightbtn.alpha = 0;

    } completion:^(BOOL finished) {

        _parameterModel.isNavShow = @(NO);
        _parameterModel.isNavAnimation = @(NO);

    }];
}

//导航栏恢复动画
-(void)navShowAction
{
    _parameterModel.isNavAnimation = @(YES);
    [UIView animateWithDuration:0.2 animations:^{

        self.navigationController.navigationBar.frame = CGRectMake(0, kStatusBarHeight, [[UIScreen mainScreen] bounds].size.width, kNavigationBarHeight);
        self.navigationItem.titleView.alpha = 1;
        _rightbtn.alpha = 1;

    } completion:^(BOOL finished) {

        _parameterModel.isNavShow = @(YES);
        _parameterModel.isNavAnimation = @(NO);

    }];
}
#pragma mark - Notification
-(void)navBarReset
{
    //将导航栏位置复原
    self.navigationController.navigationBar.frame = CGRectMake(0, kStatusBarHeight, [[UIScreen mainScreen] bounds].size.width, kNavigationBarHeight);
    //    导航栏标题透明度还原成1，还原_dragging，_isNavShow
    self.navigationItem.titleView.alpha = 1;
    _rightbtn.alpha = 1;
    _parameterModel.isNavShow = @(YES);
    _parameterModel.isNavAnimation = @(NO);
    _parameterModel.isDragging = @(NO);
}
-(void)xiaoshi:(NSNotification *)not
{
    if([not.object isEqualToString:@"other"])
    {
        [self dismissModalViewControllerAnimated:YES];
    }
}
//键盘消失时候调用
-(void)keyboardWillHide:(NSNotification *)notification
{
    _parameterModel.bKeyBoardHide = @(YES);
}
//键盘出现时候调用
-(void)keyboardWillShow:(NSNotification *)notification
{
    _parameterModel.bKeyBoardHide = @(NO);
}
#pragma mark - --------------自定义方法----------------------
-(void)cellClick_rank:(NSIndexPath *)indexPath{
    FoundModel_new *model = [_arrayData objectAtIndex:indexPath.row];
    if([[model.data objectForKey:@"rank_name"] isEqualToString:@"niche"])
    {
        [self bangdanAction:@"bangdan_niche"];
    }else if([[model.data objectForKey:@"rank_name"] isEqualToString:@"insider"])
    {
        [self bangdanAction:@"bangdan_business_insider"];
    }else if([[model.data objectForKey:@"rank_name"] isEqualToString:@"blue_ribbon"])
    {
        [self bangdanAction:@"bangdan_blueribbon"];
    }else if([[model.data objectForKey:@"rank_name"] isEqualToString:@"day"]||[[model.data objectForKey:@"rank_name"] isEqualToString:@"boarding"])
    {
        [self bangdanAction:@"bangdan_prep_review"];
    }
}
-(void)cellClick_schooldetail:(NSIndexPath *)indexPath{
    FoundModel_new *model = [_arrayData objectAtIndex:indexPath.row];
    NSString *schoolname = [model.data objectForKey:@"school_name_cn"];
    NSString *schoolid = [[NSString alloc] initWithFormat:@"%ld",[[model.data objectForKey:@"school_id"] longValue]];

    SchoolDetailViewController *schoolView = [[SchoolDetailViewController alloc] init];
    schoolView.data_dict = @{@"schoolName":schoolname,@"schoolID":schoolid};
    [self.navigationController pushViewController:schoolView animated:YES];
}
-(void)cellClick_sousuo:(NSIndexPath *)indexPath{
    FoundModel_new *model = [_arrayData objectAtIndex:indexPath.row];

    SouSuoCitiesViewController *pushctn = [[SouSuoCitiesViewController alloc] init];
    pushctn.cityNameDict = [[NSDictionary alloc] initWithObjectsAndKeys:[model.data objectForKey:@"city_names"],@"city_names",model.title,@"title",nil];
    [self.navigationController pushViewController:pushctn animated:YES];
}
//导航栏恢复
-(void)scrollViewShouldScrollToTop{
    _parameterModel.isDragging = @(NO);
    self.navigationController.navigationBar.frame = CGRectMake(0, kStatusBarHeight, [[UIScreen mainScreen] bounds].size.width, kNavigationBarHeight);
    self.navigationItem.titleView.alpha = 1;
}

#pragma mark - --------------other----------------------

#pragma mark - 集成刷新控件
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
    _page = 1;//page初始化
    [self requestData];//请求列表
}
-(void)footerRereshing
{
    _page++;//下一页
    [self requestData];//请求下一页列表
}

@end
