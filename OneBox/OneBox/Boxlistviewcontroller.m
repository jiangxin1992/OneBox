//
//  bangdanlistViewController.m
//  OneBox
//
//  Created by 谢江新 on 15/11/16.
//  Copyright © 2015年 谢江新. All rights reserved.
//

#import "Boxlistviewcontroller.h"

#import "OnlineProjectsViewController.h"
#import "QianViewController.h"
#import "SubmitMaterialController.h"
#import "SubmitSchoolController.h"
#import "FlyMaterialController.h"
#import "CustomTabbarController.h"

@interface Boxlistviewcontroller ()

@end

@implementation Boxlistviewcontroller
{
    UIPageViewController *_pageVc;
    NSMutableArray *btnarr;
    NSInteger currentPage;
    
    SubmitMaterialController *ctn1;
    FlyMaterialController *ctn11;
    SubmitSchoolController *ctn2;
    QianViewController *ctn3;
}
-(void)helpAction
{

    NSString *login=nil;
    if(![regular isLogin])
    {
        login=@"0";
    }else
    {
        login=@"1";
    }

    OnlineProjectsViewController *online=[[OnlineProjectsViewController alloc] init];
    online.islogin=login;
    [self.navigationController pushViewController:online animated:YES];
}
-(void)setInfo:(NSDictionary *)info
{
    if(_info!=info)
    {
        _info=[info copy];
        _step=[[info objectForKey:@"step"] integerValue];
        _nowstep=[[info objectForKey:@"nowstep"] integerValue];
        _titlename=[info objectForKey:@"titlename"];
        self.navigationItem.titleView=[[ToolManager sharedManager] returnNavView:_titlename withmaxwidth:230];
        [self UIConfig];
    }
}

-(void)UIConfig
{
    self.view.backgroundColor=_define_backview_color;
    CGFloat _x_p=0;
    CGFloat _width=(ScreenWidth-2)/2.0f;

    for (int i=0; i<2; i++) {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];

        btn.frame=CGRectMake(_x_p, kStatusBarAndNavigationBarHeight,_width , 100*_Scale);
        _x_p+=_width+2;
        NSString *str=nil;
        if(_nowstep==1)
        {
            str=i==0?@"材料样例":@"申请状态";

        }else if(_nowstep==2)
        {
            str=i==0?@"材料样例":@"领馆信息";

        }
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
        if(i==0)
        {
            btn.selected=YES;
            [btn setBackgroundColor:[UIColor whiteColor]];
        }        [btnarr addObject:btn];


    }
    _pageVc = [[UIPageViewController alloc]initWithTransitionStyle:1 navigationOrientation:0 options:nil];
    _pageVc.view.frame = CGRectMake(0,kStatusBarAndNavigationBarHeight+100*_Scale, ScreenWidth*2, ScreenHeight-kStatusBarAndNavigationBarHeight);
    _pageVc.view.backgroundColor = [UIColor yellowColor];
    if(_nowstep==1)
    {
        if(ctn1==nil)
        {
            ctn1=[[SubmitMaterialController alloc] init];
        }
        [_pageVc setViewControllers:@[ctn1] direction:0 animated:YES completion:nil];
    }else if(_nowstep==2)
    {
        if(ctn11==nil)
        {
            ctn11=[[FlyMaterialController alloc] init];
        }
        [_pageVc setViewControllers:@[ctn11] direction:0 animated:YES completion:nil];
    }

    currentPage=0;
    [self.view addSubview:_pageVc.view];
}
-(void)popviewAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    backBlock=^(NSString *type,BOOL _iscom)
    {
        if(_iscom)
        {
            self.block(type);
        }
        [self.navigationController popViewControllerAnimated:YES];

    };

    btnarr=[[NSMutableArray alloc] init];

    UIBarButtonItem *_btn=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回箭头"] style:UIBarButtonItemStylePlain target:self action:@selector(popviewAction)];
    self.navigationItem.leftBarButtonItem=_btn;
    UIButton *_btn_r=[UIButton buttonWithType:UIButtonTypeCustom];
    _btn_r.frame=CGRectMake(0, 0, 28, 28);
    [_btn_r addTarget:self action:@selector(helpAction) forControlEvents:UIControlEventTouchUpInside];
    [_btn_r setBackgroundImage:[UIImage imageNamed:@"found_问问"] forState:UIControlStateNormal];
    UIBarButtonItem *_btn_bar=[[UIBarButtonItem alloc] initWithCustomView:_btn_r];
    self.navigationItem.rightBarButtonItem=_btn_bar;
}

-(void)qiehuan:(UIButton *)btn
{

    if(btn.tag-100==0)
    {
        if(currentPage>0)
        {
            if(_nowstep==1)
            {
                if(ctn1==nil)
                {
                    ctn1=[[SubmitMaterialController alloc] init];
                }
                [_pageVc setViewControllers:@[ctn1] direction:1 animated:YES completion:nil];
            }else if(_nowstep==2)
            {
                if(ctn11==nil)
                {
                    ctn11=[[FlyMaterialController alloc] init];
                }
                [_pageVc setViewControllers:@[ctn11] direction:1 animated:YES completion:nil];
            }

        }

    }else if(btn.tag-100==1)
    {


        if(currentPage>1)
        {
            if(_nowstep==1)
            {
                if(ctn2==nil)
                {
                    ctn2=[[SubmitSchoolController alloc] init];
                    ctn2.step=_step;
                    ctn2.block=backBlock;
                }
                [_pageVc setViewControllers:@[ctn2] direction:1 animated:YES completion:nil];
            }else if(_nowstep==2)
            {
                if(ctn3==nil)
                {
                    ctn3=[[QianViewController alloc] init];
                    ctn3.step=_step;
                    ctn3.block=backBlock;
                }

                [_pageVc setViewControllers:@[ctn3] direction:1 animated:YES completion:nil];

            }

        }else if(currentPage<1)
        {
            if(_nowstep==1)
            {
                if(ctn2==nil)
                {
                    ctn2=[[SubmitSchoolController alloc] init];
                    ctn2.step=_step;
                    ctn2.block=backBlock;
                }

                [_pageVc setViewControllers:@[ctn2] direction:0 animated:YES completion:nil];
            }else if(_nowstep==2)
            {
                if(ctn3==nil)
                {
                    ctn3=[[QianViewController alloc] init];
                    ctn3.step=_step;
                    ctn3.block=backBlock;
                }

                [_pageVc setViewControllers:@[ctn3] direction:0 animated:YES completion:nil];
            }
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
    [MobClick endLogPageView:@"Boxlistviewcontroller"];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"Boxlistviewcontroller"];

    [[CustomTabbarController sharedManager] tabbarHide];
}/*
 #pragma mark - Navigation

 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
