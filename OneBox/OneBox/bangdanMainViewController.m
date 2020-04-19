//
//  bangdanMainViewController.m
//  OneBox
//
//  Created by sunian on 2020/4/19.
//  Copyright © 2020 谢江新. All rights reserved.
//

#import "bangdanMainViewController.h"

#import "FoundListBangdanView.h"
#import "bangdanViewController.h"
#import "bangdanlistViewController.h"
#import "CustomTabbarController.h"

@interface bangdanMainViewController ()

@end

@implementation bangdanMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self PrepareUI];
    [self UIConfig];
}
- (void)UIConfig{
    self.view.backgroundColor=_define_backview_color;
    WeakSelf(ws);
    FoundListBangdanView *bangdanView = [[FoundListBangdanView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:bangdanView];
    [bangdanView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    [bangdanView setBangdanViewBlock:^(NSString *type) {
        [ws bangdanAction:type];
    }];
}
-(void)PrepareUI
{
//    设置导航栏颜色
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:70.0f/255.0f green:195.0f/255.0f blue:247.0f/255.0f alpha:1];
//    设置背景颜色
    self.view.backgroundColor=_define_backview_color;
//    添加标题

    self.navigationItem.titleView=[regular returnNavView:@"权威榜单" withmaxwidth:200];

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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [[CustomTabbarController sharedManager] tabbarAppear];
//    友盟页面监控（登出）
    [MobClick beginLogPageView:@"bangdanMainViewController"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    友盟页面监控（进入）
    [MobClick endLogPageView:@"bangdanMainViewController"];
}

@end
