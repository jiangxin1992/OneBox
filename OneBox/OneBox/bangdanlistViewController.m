//
//  bangdanlistViewController.m
//  OneBox
//
//  Created by 谢江新 on 15/11/16.
//  Copyright © 2015年 谢江新. All rights reserved.
//

#import "bangdanlistViewController.h"

#import "bangdanViewController.h"
#import "SchoolDetailViewController.h"
#import "CustomTabbarController.h"

@interface bangdanlistViewController ()

@end

@implementation bangdanlistViewController
{
    UIPageViewController *_pageVc;
    NSMutableArray *btnarr;
    NSInteger currentPage;
    bangdanViewController *ctn1;
    bangdanViewController *ctn2;
    bangdanViewController *ctn3;
}

-(void)popviewAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    btnarr=[[NSMutableArray alloc] init];
    [super viewDidLoad];

    CGFloat _Default_font=16.0;
    CGFloat _Default_Spacing=3.0f;
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 230, 40)];
    self.view.backgroundColor=_define_backview_color;
    UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(view.frame), CGRectGetHeight(view.frame))];
    titleLabel.font=[UIFont fontWithName:@"Skia" size:_Default_font];

    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    [titleLabel setAttributedText:[regular createAttributeString:@"Prep Review 榜" andFloat:@(_Default_Spacing)]];
    [view addSubview:titleLabel];
    [titleLabel sizeToFit];
    BOOL _isfit;
    if(CGRectGetWidth(titleLabel.frame)<=230)
    {
        _isfit=NO;
    }else
    {
        for (int i=_Default_font*2;i>0;i--) {


            if(_Default_Spacing<=0)
            {
                _Default_font-=0.5f;

            }else
            {
                _Default_Spacing-=0.5f;
            }

            titleLabel.font=[UIFont fontWithName:@"Skia" size:_Default_font];

            [titleLabel setAttributedText:[ToolManager createAttributeString:@"Prep Review 榜" andFloat:@(_Default_Spacing)]];
            [titleLabel sizeToFit];
            if(CGRectGetWidth(titleLabel.frame)<=230||_Default_font<=13.0f)
            {
                break;
            }
        }
    }
    JXLOG(@"Spacing=%f  font=%f",_Default_Spacing,_Default_font);
    if(CGRectGetWidth(titleLabel.frame)>230&&_Default_font==13.0f)
    {
        titleLabel.frame=CGRectMake(0, 0, CGRectGetWidth(view.frame), CGRectGetHeight(view.frame));

    }else
    {
        titleLabel.frame=CGRectMake((CGRectGetWidth(view.frame)-CGRectGetWidth(titleLabel.frame))/2.0f, (CGRectGetHeight(view.frame)-CGRectGetHeight(titleLabel.frame))/2.0f, CGRectGetWidth(titleLabel.frame), CGRectGetHeight(titleLabel.frame));

    }
    self.navigationItem.titleView=view;


    UIBarButtonItem *_btn=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回箭头"] style:UIBarButtonItemStylePlain target:self action:@selector(popviewAction)];
    self.navigationItem.leftBarButtonItem=_btn;

    CGFloat _x_p=0;
    CGFloat _width=(ScreenWidth-2)/2.0f;

    for (int i=0; i<2; i++) {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];

        btn.frame=CGRectMake(_x_p, 64,_width , 100*_Scale);
        _x_p+=_width+2;
        NSString *str=i==0?@"走读榜单":@"寄宿榜单";

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
    _pageVc.view.frame = CGRectMake(0, 64+100*_Scale, ScreenWidth*2, ScreenHeight-64);
    _pageVc.view.backgroundColor = [UIColor yellowColor];
    //    _pageVc.delegate = self;
    //    _pageVc.dataSource = self;
    if(ctn1==nil)
    {
        ctn1=[[bangdanViewController alloc] init];
        ctn1.type=5;

    }
    [_pageVc setViewControllers:@[ctn1] direction:0 animated:YES completion:nil];
    currentPage=0;
    [self.view addSubview:_pageVc.view];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bangdanpush_detail:) name:@"bangdanpush_detail" object:nil];
}
-(void)bangdanpush_detail:(NSNotification *)not
{

    SchoolDetailViewController *schoolView=[[SchoolDetailViewController alloc] init];

    schoolView.data_dict=not.object;
    [self.navigationController pushViewController:schoolView animated:YES];

}
-(void)qiehuan:(UIButton *)btn
{

    if(btn.tag-100==0)
    {
        if(currentPage>0)
        {
            if(ctn1==nil)
            {
                ctn1=[[bangdanViewController alloc] init];
                ctn1.type=5;

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
                ctn2=[[bangdanViewController alloc] init];
                ctn2.type=6;

            }

            [_pageVc setViewControllers:@[ctn2] direction:1 animated:YES completion:nil];

        }else if(currentPage<1)
        {
            if(ctn2==nil)
            {
                ctn2=[[bangdanViewController alloc] init];
                ctn2.type=6;

            }
            [_pageVc setViewControllers:@[ctn2] direction:0 animated:YES completion:nil];

        }


    }else if(btn.tag-100==2)
    {
        if(ctn3==nil)
        {
            ctn3=[[bangdanViewController alloc] init];
            ctn3.type=7;

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
    [MobClick endLogPageView:@"bangdanViewController"];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"bangdanViewController"];

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
