//
//  PayAfterViewController.m
//  OneBox
//
//  Created by 顾鹏 on 15/3/11.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import "PayAfterViewController.h"
#import "ChooseCusView.h"
#define COLOR [UIColor colorWithRed:242/255.0 green:107/255.0 blue:84/255.0 alpha:1.0]
#define NEWCOLOR [UIColor colorWithRed:77/255.0 green:190/255.0 blue:217/255.0 alpha:1.0]

@interface PayAfterViewController ()

@end

@implementation PayAfterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createView];
}
- (void)createView
{
    UILabel * mustdata = [regular createLabelView:@"必须通用材料" Withrect:CGRectMake(5,64 + 15, 310, 30) WithTextColor:[UIColor whiteColor] WithTextAlignment:1 WithFont:14.0];
    mustdata.backgroundColor = COLOR;
    [self.view addSubview:mustdata];
    NSArray *titleArr = @[@"存款证明",@"推荐信",@"毕业证",@"护照",@"成绩单",@"学校申请表"];
    for (int i = 0; i < 6; i ++) {
        ChooseCusView *choose = [[ChooseCusView alloc] initWithFrame:CGRectMake(5 + 156 * (i%2), 64 +47 + 32 * (i/2), 154, 30)];
//        [choose initWithDataTitle:titleArr[i] withTarget:self withSelector:@selector(chooseClick:) ];
        [self.view addSubview:choose];
    }
    UIImageView *backViewBottom = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"card1"]];
    backViewBottom.frame = CGRectMake(10, 280, 300, 226);
    [self.view addSubview:backViewBottom];
    
    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"userImage"]]];
    icon.backgroundColor = [UIColor redColor];
    icon.bounds = CGRectMake(0, 0, 60, 60);
    icon.center = CGPointMake(155, 0);
    icon.layer.masksToBounds = YES;
    icon.layer.cornerRadius = icon.frame.size.width/2.0;
    [backViewBottom addSubview:icon];
    
    UILabel *name = [regular createLabelView:[[NSUserDefaults standardUserDefaults] objectForKey:@"username"] Withrect:CGRectMake(125, 35, 60, 15) WithTextColor:NEWCOLOR WithTextAlignment:1 WithFont:14.0];
    [backViewBottom addSubview:name];
    UILabel *explain = [regular createLabelView:@"专 案" Withrect:CGRectMake(125, CGRectGetMaxY(name.frame) + 5, 60, 10) WithTextColor:NEWCOLOR WithTextAlignment:1 WithFont:12.0];
    [backViewBottom addSubview:explain];
    
    UIButton *typeBtn = [regular createBtnWithRect:CGRectMake(140, 70, 30, 30) WithTitle:@"" WithNormalStr:@"圆点" WithSelectStr:nil];
    [backViewBottom addSubview:typeBtn];
//    UILabel *single = [regular createLabelView:@"" Withrect:CGRectMake(0, 105 , 310, 15) WithTextColor:<#(UIColor *)#> WithTextAlignment:<#(NSInteger)#> WithFont:<#(CGFloat)#>]
//    NSArray *listSev = @[@"- 赴美服务 -",@"陪飞或接机;",@"寄宿家庭管理;",@"在美监护;",@"约签及通知提醒;"];
//    for (int i = 0; i < 5; i ++) {
//        UILabel *single = [regular createLabelView:listSev[i] Withrect:CGRectMake(0, 105 + 20 * i, 310, 15) WithTextColor:[UIColor whiteColor] WithTextAlignment:1 WithFont:13.0];
//        [backViewBottom addSubview:single];
//    }
//    UIButton *achieveData = [regular createBtnWithRect:CGRectMake(10, CGRectGetMaxY(backViewBottom.frame) + 4, 300, 30) WithTitle:@"获取更多信息" WithNormalStr:nil WithSelectStr:nil];
//    [achieveData setBackgroundColor:NEXTCOLOR];
//    [achieveData setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [self.view addSubview:achieveData];


};
- (void)chooseClick:(UIButton *)btn
{
    
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
