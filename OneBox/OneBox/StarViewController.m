//
//  StarViewController.m
//  OneBox
//
//  Created by 顾鹏 on 15/3/20.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import "StarViewController.h"
#define NEWCOLOR [UIColor colorWithRed:77/255.0 green:190/255.0 blue:217/255.0 alpha:1.0]
//#define NEWCOLOR [UIColor colorWithRed:77/255.0 green:190/255.0 blue:217/255.0 alpha:1.0]
#define NEXTCOLOR [UIColor colorWithRed:248/255.0 green:209/255.0 blue:82/255.0 alpha:1.0]


@interface StarViewController ()
{
    NSMutableArray *starsArr;
}
@end

@implementation StarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    starsArr = [[NSMutableArray alloc] init];

    UIImageView *backViewBottom = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"card1"]];
    backViewBottom.frame = CGRectMake(10, 100, 300, 226);
    backViewBottom.userInteractionEnabled = YES;
    [self.view addSubview:backViewBottom];
    
    UIImageView *icon = [[UIImageView alloc] init];
    NSUserDefaults *dict=[NSUserDefaults standardUserDefaults];
    //    navBtn.layer.masksToBounds=YES;
    //    navBtn.layer.cornerRadius=navBtn.frame.size.width/2.0f;
    if([[dict objectForKey:@"islogin"] intValue]==1)
    {
        [icon setImage:[UIImage imageWithData:[dict objectForKey:@"userImage"]]];
    }else
    {
        [icon setImage:[UIImage imageNamed:@"headImg_logout.jpg"]];
    }
    //    icon.backgroundColor = [UIColor redColor];
    icon.bounds = CGRectMake(0, 0, 60, 60);
    icon.center = CGPointMake(155, 0);
    icon.layer.masksToBounds = YES;
    icon.layer.cornerRadius = icon.frame.size.width/2.0;
    [backViewBottom addSubview:icon];
    
    UILabel *name = [regular createLabelView:[[NSUserDefaults standardUserDefaults] objectForKey:@"username"] Withrect:CGRectMake(125, 35, 60, 15) WithTextColor:NEWCOLOR WithTextAlignment:1 WithFont:14.0];
    [backViewBottom addSubview:name];
    UILabel *explain = [regular createLabelView:@"申 请 专 案" Withrect:CGRectMake(125, CGRectGetMaxY(name.frame) + 5, 60, 10) WithTextColor:NEWCOLOR WithTextAlignment:1 WithFont:12.0];
    [backViewBottom addSubview:explain];
    
    UIButton *typeBtn = [regular createBtnWithRect:CGRectMake(140, 70, 30, 30) WithTitle:nil WithNormalStr:@"圆点" WithSelectStr:nil];
    [backViewBottom addSubview:typeBtn];
    
    NSArray *listSev = @[@"工作态度",@"专业水准",@"完成情况"];
    for (int i = 0; i < listSev.count; i ++) {
        UILabel *single = [regular createLabelView:listSev[i] Withrect:CGRectMake(50, 105 + 20 * i, 100, 15) WithTextColor:[UIColor whiteColor] WithTextAlignment:1 WithFont:13.0];
        [backViewBottom addSubview:single];
        UIView *starView = [self createStar:CGRectMake(CGRectGetMaxX(single.frame) + 10, CGRectGetMinY(single.frame), 100, 20) andType:i];
        [backViewBottom addSubview:starView];
    }
    
    
}
- (UIView *)createStar:(CGRect)rect andType:(NSInteger)type
{
    UIView*view_star=[[UIView alloc] initWithFrame:rect];
    [self.view addSubview:view_star];
    NSMutableArray *Arr=[[NSMutableArray alloc] init];
    NSInteger starNum=5;
    for (int i=0; i<starNum; i++) {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(i*CGRectGetHeight(view_star.frame), 0, CGRectGetHeight(view_star.frame)-10*_Scale, CGRectGetHeight(view_star.frame)-10*_Scale);
        [btn setImage:[UIImage imageNamed:@"school_评星"] forState:UIControlStateSelected];
        [btn setImage:[UIImage imageNamed:@"school_评星灰色"] forState:UIControlStateNormal];
        btn.tag= (type + 1) * i;
        if(type == 0){
            [btn addTarget:self action:@selector(star_action:) forControlEvents:UIControlEventTouchUpInside];}
        else if (type == 1)
        {
            [btn addTarget:self action:@selector(star_action_two:) forControlEvents:UIControlEventTouchUpInside];
        }
        else
        {
            [btn addTarget:self action:@selector(star_action_third:) forControlEvents:UIControlEventTouchUpInside];
        }
        [Arr addObject:btn];
        [view_star addSubview:btn];
    }
    [starsArr addObject:Arr];
    return view_star;
    
    
}
-(void)star_action:(UIButton *)btn
{
    
    for (int i=0; i<[starsArr[0] count]; i++) {
        UIButton *_btn=starsArr[0][i] ;
        if(i<=btn.tag)
        {
            _btn.selected=YES;
        }
        else
        {
            _btn.selected=NO;
        }
        
    }
    //    }
    
}
- (void)star_action_two:(UIButton *)btn
{
    for (int i=0; i<[starsArr[1] count]; i++) {
        UIButton *_btn=starsArr[1][i] ;
        if(2*i<=btn.tag)
        {
            _btn.selected=YES;
        }
        else
        {
            _btn.selected=NO;
        }
        
    }

}
- (void)star_action_third:(UIButton *)btn
{
    for (int i=0; i<[starsArr[2] count]; i++) {
        UIButton *_btn=starsArr[2][i];
        if(3*i<=btn.tag)
        {
            _btn.selected=YES;
        }
        else
        {
            _btn.selected=NO;
        }
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
