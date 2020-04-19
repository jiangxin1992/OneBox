//
//  ScreenMainViewController.m
//  OneBox
//
//  Created by sunian on 2020/4/19.
//  Copyright © 2020 谢江新. All rights reserved.
//

#import "ScreenMainViewController.h"
#import "FoundListScreenView.h"
#import "ScreenViewController.h"
#import "UserInfoViewController.h"
#import "CustomTabbarController.h"

@interface ScreenMainViewController ()

@property (nonatomic, strong) NSNumber *total_students_min;//记录学生数的最小值
@property (nonatomic, strong) NSNumber *ap_count_max;//记录ap课程数量的最大值
@property (nonatomic, strong) NSNumber *total_students_max;//记录学生数的最大值
@property (nonatomic, strong) NSNumber *ap_count_min;//记录ap课程数量的最小值
@property (nonatomic, strong) FoundListScreenView *screenView;
@end

@implementation ScreenMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self PrepareUI];
    [self requestScreenViewData];
}
// 筛选视图请求
-(void)requestScreenViewData
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
                NSData* data = [html dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

                _total_students_min = [[dict objectForKey:@"data"] objectForKey:@"total_students_min"];
                _ap_count_max = [[dict objectForKey:@"data"] objectForKey:@"ap_count_max"];
                _total_students_max = [[dict objectForKey:@"data"] objectForKey:@"total_students_max"];
                _ap_count_min = [[dict objectForKey:@"data"] objectForKey:@"ap_count_min"];

                [self createScreenView];

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

//筛选
-(void)screenAction{
    if(_screenView){
        NSMutableDictionary *parameters = [_screenView getParameters];
        [parameters setObject:@"1" forKey:@"page"];

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

// 创建筛选视图
-(void)createScreenView{
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
-(void)PrepareUI
{
//    设置导航栏颜色
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:70.0f/255.0f green:195.0f/255.0f blue:247.0f/255.0f alpha:1];
//    设置背景颜色
    self.view.backgroundColor=_define_backview_color;
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

    UIButton *_rightbtn = [UIButton getCustomBackImgBtnWithImageStr:@"found_activity_user_normal12" WithSelectedImageStr:nil];
    _rightbtn.frame = CGRectMake(0, 0, 20, 20);
    [_rightbtn addTarget:self action:@selector(pushToUserCenter) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc] initWithCustomView:_rightbtn];
    self.navigationItem.rightBarButtonItem = bar;
}
-(void)pushToUserCenter{
    UserInfoViewController *userVC = [[UserInfoViewController alloc] init];
    [self.navigationController pushViewController:userVC animated:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [[CustomTabbarController sharedManager] tabbarAppear];
//    友盟页面监控（登出）
    [MobClick beginLogPageView:@"ScreenMainViewController"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    友盟页面监控（进入）
    [MobClick endLogPageView:@"ScreenMainViewController"];
}

@end
