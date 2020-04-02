//
//  UserListViewController.m
//  OneBox
//
//  Created by 谢江新 on 15/8/13.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import "UserListViewController.h"

#import "AttentionViewController.h"
#import "FriendsViewController.h"
#import "AdmissionOfficerViewController.h"
#import "GroupViewController.h"

@interface UserListViewController ()

@end

@implementation UserListViewController
{
    UIPageViewController *_pageVc;
    NSMutableArray *btnarr;
    NSInteger currentPage;
    FriendsViewController *ctn1;
    AttentionViewController *ctn2;
    AdmissionOfficerViewController *ctn3;
}

- (void)viewDidLoad {
    btnarr=[[NSMutableArray alloc] init];
    [super viewDidLoad];
    self.view.backgroundColor=_define_backview_color;


    CGFloat _x_p=0;
    CGFloat _width=(ScreenWidth-2)/3.0f;

    UIView *lastView = nil;
    for (int i=0; i<3; i++) {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];

        btn.frame=CGRectMake(_x_p, 0,_width , 80*_Scale);
        _x_p+=_width+1;
        NSString *str=i==0?@"粉 丝":i==1?@"关 注":i==2?@"专案":@"Group";

        btn.titleLabel.font=[regular getFont:13.0f];
        [btn setTitle:str forState:UIControlStateNormal];
        [btn.titleLabel setAttributedText:[regular createAttributeString:str andFloat:@(1.0)]];
        [btn setTitleColor:[UIColor colorWithRed:190.0f/255.0f green:190.0f/255.0f blue:190.0f/255.0f alpha:1] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithRed:245.0f/255.0f green:152.0f/255.0f blue:34.0f/255.0f alpha:1] forState:UIControlStateSelected];
        [btn setBackgroundImage:[UIImage imageNamed:@"chatview_关注好友"] forState:UIControlStateSelected];
        [btn setBackgroundColor:[UIColor colorWithRed:251.0f/255.0f green:251.0f/255.0f blue:251.0f/255.0f alpha:1]];
        [btn addTarget:self action:@selector(qiehuan:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag=100+i;
        [self.view addSubview:btn];
        if(i==1)
        {
            btn.selected=YES;
            [btn setBackgroundColor:[UIColor whiteColor]];
        }
        [btnarr addObject:btn];
        lastView = btn;
    }
    _pageVc = [[UIPageViewController alloc]initWithTransitionStyle:1 navigationOrientation:0 options:nil];
    [self.view addSubview:_pageVc.view];
    [_pageVc.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(ScreenWidth*2);
        make.top.mas_equalTo(lastView.mas_bottom).with.offset(0);
        make.bottom.mas_equalTo(-kTabBarHeight-kStatusBarAndNavigationBarHeight);
    }];
    _pageVc.view.backgroundColor = [UIColor yellowColor];
    if(ctn2==nil)
    {
        ctn2=[[AttentionViewController alloc] init];

    }
    [_pageVc setViewControllers:@[ctn2] direction:0 animated:YES completion:nil];
    currentPage=1;
}

-(void)qiehuan:(UIButton *)btn
{

    if(btn.tag-100==0)
    {
        if(currentPage>0)
        {
            if(ctn1==nil)
            {
                ctn1=[[FriendsViewController alloc] init];

            }
            [_pageVc setViewControllers:@[ctn1] direction:1 animated:YES completion:nil];

        }
        //[_pageVc setViewControllers:@[SubVC] direction:a animated:YES completion:nil];

    }else if(btn.tag-100==1)
    {

        if(currentPage>1)
        {
            if(ctn2==nil)
            {
                ctn2=[[AttentionViewController alloc] init];

            }

            [_pageVc setViewControllers:@[ctn2] direction:1 animated:YES completion:nil];

        }else if(currentPage<1)
        {
            if(ctn2==nil)
            {
                ctn2=[[AttentionViewController alloc] init];

            }
            [_pageVc setViewControllers:@[ctn2] direction:0 animated:YES completion:nil];

        }


    }else if(btn.tag-100==2)
    {
        if(ctn3==nil)
        {
            ctn3=[[AdmissionOfficerViewController alloc] init];

        }
        if(currentPage<2&&ctn3!=nil)
        {
            [_pageVc setViewControllers:@[ctn3] direction:0 animated:YES completion:nil];
        }

    }
    for (UIButton *_btn in btnarr) {
        _btn.selected=NO;
        _btn.backgroundColor=[UIColor colorWithRed:251.0f/255.0f green:251.0f/255.0f blue:251.0f/255.0f alpha:1];
        if(_btn.tag==btn.tag)
        {
            _btn.selected=YES;
            _btn.backgroundColor=[UIColor whiteColor];
            currentPage=_btn.tag-100;
        }
    }
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"UserListViewController"];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"UserListViewController"];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
