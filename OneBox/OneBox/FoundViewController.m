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
#import "shaiXuanViewController.h"
#import "souSuoCitiesViewController.h"
#import "SchoolDetailViewController.h"
#import "souSuoViewController.h"
#import "bangdanlistViewController.h"
#import "bangdanViewController.h"
#import "CustomTabbarController.h"

// 自定义视图
#import "FoundCell_new.h"
#import "FoundListSousuoView.h"
#import "FoundListTableHeaderView.h"
#import "FoundListBangdanView.h"
#import "FoundListScreenView.h"

// 接口

// 分类

// 自定义类和三方类（ cocoapods类 > model > 工具类 > 其他）
#import "MJRefresh.h"

#import "foundModel_new.h"

#define foundCellHeight 380*_Scale

@interface FoundViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *arrayData;//存放页面的数据

@property (nonatomic,copy) void (^blockSuccess)(NSDictionary *dict);//主界面数据请求成功后调用
@property (nonatomic,copy) void (^changeBlock)(NSInteger row);

//view
@property (nonatomic, strong) FoundListTableHeaderView *tableHeaderView;//headview的背景图
@property (nonatomic, strong) FoundListSousuoView *sousuoView;
@property (nonatomic, strong) FoundListBangdanView *bangdanView;
@property (nonatomic, strong) FoundListScreenView *screenView;

@property (nonatomic, strong) UIButton *rightbtn;
@property (nonatomic, copy) NSString *headviewimage;//headview的背景图url

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) BOOL bKeyBoardHide;//判断键盘显示状态

//动画相关
@property (nonatomic, assign) NSInteger record_cell_num;
@property (nonatomic, assign) CGFloat min_offset;
@property (nonatomic, assign) BOOL nav_donghua;//记录导航栏是否滑动上去（是否消失）
@property (nonatomic, assign) CGFloat start_y;//表示tableview开始拖动时候的起始位置
@property (nonatomic, assign) BOOL dragging;//表示tableview开始拖动，记录拖动的开始
@property (nonatomic, assign) BOOL appear;
@property (nonatomic, assign) NSInteger page;//记录当前page

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

    self.appear = YES;
    //    tabbar设为出现
    [[CustomTabbarController sharedManager] tabbarAppear];
    //    友盟页面监控（登出）
    [MobClick beginLogPageView:@"FoundViewController"];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //    导航栏还原
    self.appear = NO;
    self.dragging = NO;
    self.nav_donghua = NO;
    self.rightbtn.alpha = 1;
    self.navigationController.navigationBar.frame = CGRectMake(0, kStatusBarHeight, [[UIScreen mainScreen]bounds].size.width, kNavigationBarHeight);
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
    [self createBlock];
    [self createNotication];
}
-(void)initializeData{
    self.record_cell_num = 0;
    self.bKeyBoardHide = YES;//开始时候键盘为隐藏状态
    self.appear = YES;
    self.dragging = NO;
    self.nav_donghua = NO;
    self.start_y = 0;
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

    //   应对导航栏黑线问题（异常）
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        NSArray *list=self.navigationController.navigationBar.subviews;
        for (id obj in list) {
            if ([obj isKindOfClass:[UIImageView class]]) {
                UIImageView *imageView=(UIImageView *)obj;
                NSArray *list2=imageView.subviews;
                for (id obj2 in list2) {
                    if ([obj2 isKindOfClass:[UIImageView class]]) {
                        UIImageView *imageView2=(UIImageView *)obj2;
                        imageView2.hidden=YES;
                    }
                }
            }
        }
    }

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
    //    创建视图下方三个按钮
    [self createHelp];
}
-(void)createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.bottom.mas_equalTo(-kTabBarHeight);
    }];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //    水平方向滑条显示
    _tableView.showsVerticalScrollIndicator = YES;
    _tableView.backgroundColor = _define_backview_color;
    //    消除分割线
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _min_offset = _tableView.contentOffset.y;

    [self setupRefresh];
}
-(void)createHelp
{
    UIView *helpview = [UIView getCustomViewWithColor:nil];
    [self.view addSubview:helpview];
    [helpview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-70*_Scale);
        make.bottom.mas_equalTo(-10*_Scale-kTabBarHeight);
        make.width.mas_equalTo(90*_Scale);
        make.height.mas_equalTo(150*_Scale);
    }];

    UIButton *help_btn = [UIButton getCustomImgBtnWithImageStr:@"found_问问" WithSelectedImageStr:nil];
    [helpview addSubview:help_btn];
    [help_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(90*_Scale);
    }];
    [help_btn addTarget:self action:@selector(helpAction:) forControlEvents:UIControlEventTouchUpInside];

    UILabel *label_title = [UILabel getLabelWithAlignment:1 WithTitle:@"问问" WithFont:12.0f WithTextColor:_define_white_color WithSpacing:3.0];
    [helpview addSubview:label_title];
    [label_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(help_btn.mas_bottom).with.offset(12*_Scale);
        make.height.mas_equalTo(34*_Scale);
    }];
}
-(void)createTableHeadView
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
                [ws createScreenView];
            }
        }];
        _tableHeaderView.backViewImagePath = _headviewimage;
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
// 筛选视图请求
-(void)createScreenView
{
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
                NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

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
                    _screenView.total_students_min = [[dict objectForKey:@"data"] objectForKey:@"total_students_min"];
                    _screenView.ap_count_max = [[dict objectForKey:@"data"] objectForKey:@"ap_count_max"];
                    _screenView.total_students_max = [[dict objectForKey:@"data"] objectForKey:@"total_students_max"];
                    _screenView.ap_count_min = [[dict objectForKey:@"data"] objectForKey:@"ap_count_min"];
                    [_screenView updateUI];
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
        _blockSuccess((NSDictionary *)responseObject);
        [[ToolManager sharedManager] removeProgress];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_tableView.mj_header endRefreshing];
        [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
        [[ToolManager sharedManager] removeProgress];
    }];
}

#pragma mark - --------------系统代理----------------------
#pragma mark - ScrollViewDelegate
//导航栏的动画显示与隐藏
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if(_appear && scrollView == _tableView)
    {
        //        记录开始滑动时候tableview的偏移量
        self.start_y = scrollView.contentOffset.y;
        //        开始滑动
        self.dragging = YES;
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    JXLOG(@"%f",scrollView.contentOffset.y);
    CGFloat _height = scrollView.contentOffset.y+CGRectGetHeight(_tableView.frame)-_min_offset-kTabBarHeight-420*_Scale;
    NSInteger now_cell = 0;
    if(_isPad)
    {
        now_cell = (NSInteger)(_height/((NSInteger)380*_Scale));
    }else
    {
        now_cell = (NSInteger)(_height/190);
    }

    if(now_cell != _record_cell_num)
    {
        _record_cell_num = now_cell;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FoundAnimation" object:[NSNumber numberWithLong:_record_cell_num]];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FoundAnimation1" object:nil];

    if(_dragging)
    {
        //        当导航栏已经消失
        if(_appear && scrollView == _tableView)
        {
            if(_start_y < 20 && scrollView.contentOffset.y > 20)
            {
                //            当开始时偏移量小于20并且当前偏移量大于20，开始上滑动画
                [self SlideUpAction];
            }else
            {
                if(scrollView.contentOffset.y < 20)
                {
                    [self SlideDownAction];
                }else
                {
                    if(!_nav_donghua && ((scrollView.contentOffset.y-_start_y) > (ScreenHeight/4.0f)))
                    {
                        [self SlideUpAction];
                    }else if(_nav_donghua && ((_start_y-scrollView.contentOffset.y) > (ScreenHeight/4.0f)))
                    {
                        [self SlideDownAction];
                    }
                }
            }
        }
    }
}
//滑动结束时候调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(_appear && (scrollView == _tableView))
    {
        self.dragging = NO;
    }
}
// 回到最顶部
- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    //导航栏恢复
    self.dragging = NO;
    self.navigationController.navigationBar.frame = CGRectMake(0, kStatusBarHeight, [[UIScreen mainScreen]bounds].size.width, kNavigationBarHeight);
    self.navigationItem.titleView.alpha = 1;
    self.nav_donghua = NO;

    return YES;
}
#pragma mark - TableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return foundCellHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if(!_bKeyBoardHide)
    {
        //        当键盘为出现状态时，触发 键盘消失方法
        [regular dismissKeyborad];

    }else
    {
        //键盘没有出现时候调用
        foundModel_new *model = [_arrayData objectAtIndex:indexPath.row];
        if(model.m_type != nil)
        {

            if([model.m_type isEqualToString:@"rank"])
            {
                //                当cell类型为榜单时候
                if([model.data objectForKey:@"rank_name"] != nil)
                {
                    //                    判断点击cell榜单类型
                    if([[model.data objectForKey:@"rank_name"] isKindOfClass:[NSString class]])
                    {
                        if([[model.data objectForKey:@"rank_name"] isEqualToString:@"niche"])
                        {
                            bangdanViewController *bangdan = [[bangdanViewController alloc] init];
                            bangdan.type = 1;
                            [self.navigationController pushViewController:bangdan animated:YES];
                        }else if([[model.data objectForKey:@"rank_name"] isEqualToString:@"insider"])
                        {
                            bangdanViewController *bangdan = [[bangdanViewController alloc] init];
                            bangdan.type = 2;
                            [self.navigationController pushViewController:bangdan animated:YES];
                        }else if([[model.data objectForKey:@"rank_name"] isEqualToString:@"blue_ribbon"])
                        {
                            bangdanViewController *bangdan = [[bangdanViewController alloc] init];
                            bangdan.type = 4;
                            [self.navigationController pushViewController:bangdan animated:YES];
                        }else if([[model.data objectForKey:@"rank_name"] isEqualToString:@"day"]||[[model.data objectForKey:@"rank_name"] isEqualToString:@"boarding"])
                        {
                            [self.navigationController pushViewController:[bangdanlistViewController new] animated:YES];
                        }
                    }
                }
            }else if([model.m_type isEqualToString:@"school"])
            {
                //当当前cell类型为school时候
                BOOL _canpush = NO;//判断当前时候满足跳转条件（及schoolID不为空）
                NSString *schoolname = nil;
                NSString *schoolid = nil;
                if([model.data objectForKey:@"school_name_cn"] != [NSNull null])
                {
                    if([model.data objectForKey:@"school_name_cn"] != nil)
                    {
                        schoolname = [model.data objectForKey:@"school_name_cn"];
                    }else
                    {
                        schoolname = @"";
                    }
                }else
                {
                    schoolname = @"";
                }

                if([model.data objectForKey:@"school_id"] != [NSNull null])
                {
                    if([model.data objectForKey:@"school_id"] != nil)
                    {
                        schoolid = [[NSString alloc] initWithFormat:@"%ld",[[model.data objectForKey:@"school_id"] longValue]];
                        _canpush = YES;
                    }else
                    {
                        schoolid = @"";
                    }
                }else
                {
                    schoolid = @"";
                }

                if(_canpush)
                {

                    SchoolDetailViewController *schoolView = [[SchoolDetailViewController alloc] init];
                    schoolView.data_dict = [[NSDictionary alloc] initWithObjectsAndKeys:schoolname,@"schoolName",schoolid,@"schoolID",nil];
                    [self.navigationController pushViewController:schoolView animated:YES];
                }

            }if([model.m_type isEqualToString:@"city"])
            {
                //当前cell为city类型时,当数据类型正确并且城市多余0个的时候允许跳转。
                if([model.data objectForKey:@"city_names"] != [NSNull null])
                {
                    if([model.data objectForKey:@"city_names"] != nil)
                    {
                        if([[model.data objectForKey:@"city_names"] isKindOfClass:[NSArray class]])
                        {
                            if([[model.data objectForKey:@"city_names"] count] > 0)
                            {
                                souSuoCitiesViewController *pushctn = [[souSuoCitiesViewController alloc] init];
                                pushctn.cityNameDict = [[NSDictionary alloc] initWithObjectsAndKeys:[model.data objectForKey:@"city_names"],@"city_names",model.title,@"title",nil];
                                [self.navigationController pushViewController:pushctn animated:YES];
                            }
                        }
                    }
                }
            }
        }
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if(_arrayData.count == section)
    {
        return 0;
    }
    return _arrayData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //数据还未获取时候
    if(_arrayData.count == indexPath.section)
    {
        static NSString *cellid = @"cellid";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if(!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    //获取到数据以后
    static NSString *cellid = @"cell_found";
    FoundCell_new *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if(!cell)
    {
        cell = [[FoundCell_new alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:[_arrayData objectAtIndex:indexPath.row],@"model",[NSNumber numberWithInteger:indexPath.row],@"row",[NSNumber numberWithInteger:[_arrayData count]],@"num",nil];
    cell.block = _changeBlock;
    cell.dict = dict;
    return cell;
}

#pragma mark - --------------自定义代理/block----------------------
-(void)createBlock
{
    WeakSelf(ws);
    self.changeBlock = ^(NSInteger row)
    {
        JXLOG(@"%@",ws.arrayData);
        ((foundModel_new *)[ws.arrayData objectAtIndex:row]).isapp = YES;
    };

    self.blockSuccess = ^(NSDictionary *dict)
    {
        //        刷新动画收起
        [ws.tableView.mj_header endRefreshing];
        [ws.tableView.mj_footer endRefreshing];
        if(ws.page == 1)
        {
            [ws.arrayData removeAllObjects];//删除所有数据
        }
        //headview背景图url
        if(![NSString isNilOrEmpty:[[dict objectForKey:@"data"] objectForKey:@"search_bg"]])
        {
            ws.headviewimage = [[dict objectForKey:@"data"] objectForKey:@"search_bg"];
        }else
        {
            ws.headviewimage = nil;
        }

        [ws createTableHeadView];

        //数据处理，获取模型数组
        NSArray *getdata = [foundModel_new parsingData:dict];
        //当获取数据count数量大于0时候，刷新tableview

        if(getdata.count > 0)
        {
            [ws.arrayData addObjectsFromArray:getdata];
            [ws.tableView reloadData];
        }else
        {
            [ws.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"没有更多了" WithImg:@"Prompt_提交成功" Withtype:1]];
        }
    };
}

#pragma mark - --------------自定义响应----------------------
//跳转搜索结果view
-(void)pushToSouSuoView:(NSString *)textFieldStr{
    souSuoViewController *sousuo = [[souSuoViewController alloc] init];
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
//跳转帮助view
-(void)helpAction:(UIButton*)btn
{
    NSString *login = nil;
    if(![regular isLogin])
    {
        login = @"0";
    }else
    {
        login = @"1";
    }
    OnlineProjectsViewController *online = [[OnlineProjectsViewController alloc] init];
    online.islogin = login;
    [self.navigationController pushViewController:online animated:YES];
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
            shaiXuanViewController *shaixuan = [[shaiXuanViewController alloc] init];
            shaixuan.data_dict = parameters;
            [self.navigationController pushViewController:shaixuan animated:YES];
        }else
        {
            [[ToolManager sharedManager] alertTitle_Simple:@"请选择筛选条件"];
        }
    }
}
#pragma mark - slideAction
//导航栏上滑动画
-(void)SlideUpAction
{
    [UIView beginAnimations:@"SlideUpAction" context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDelegate:self];
    self.navigationController.navigationBar.frame = CGRectMake(0, kStatusBarHeight - kStatusBarAndNavigationBarHeight, [[UIScreen mainScreen]bounds].size.width, kNavigationBarHeight);
    self.navigationItem.titleView.alpha = 0;
    _rightbtn.alpha = 0;
    [UIView commitAnimations];
    self.nav_donghua = NO;
}
//导航栏恢复动画
-(void)SlideDownAction
{
    [UIView beginAnimations:@"SlideDownAction" context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDelegate:self];
    self.navigationController.navigationBar.frame = CGRectMake(0, kStatusBarHeight, [[UIScreen mainScreen]bounds].size.width, kNavigationBarHeight);
    _rightbtn.alpha = 1;
    self.navigationItem.titleView.alpha = 1;
    [UIView commitAnimations];
    self.nav_donghua = NO;
}
#pragma mark - Notification
-(void)navBarReset
{
    //将导航栏位置复原
    self.navigationController.navigationBar.frame = CGRectMake(0, kStatusBarHeight, [[UIScreen mainScreen]bounds].size.width, kNavigationBarHeight);
    //    导航栏标题透明度还原成1，还原_dragging，_nav_donghua
    self.navigationItem.titleView.alpha = 1;
    _rightbtn.alpha = 1;
    self.dragging = NO;
    self.nav_donghua = NO;
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
    _bKeyBoardHide = YES;
}
//键盘出现时候调用
-(void)keyboardWillShow:(NSNotification *)notification
{
    _bKeyBoardHide = NO;
}
#pragma mark - --------------自定义方法----------------------


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
