//
//  UsaServeViewController.m
//  OneBox
//
//  Created by 顾鹏 on 15/3/18.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import "UsaServeViewController.h"
#import "StarViewController.h"
#define NEWCOLOR [UIColor colorWithRed:77/255.0 green:190/255.0 blue:217/255.0 alpha:1.0]
//#define NEWCOLOR [UIColor colorWithRed:77/255.0 green:190/255.0 blue:217/255.0 alpha:1.0]
#define NEXTCOLOR [UIColor colorWithRed:248/255.0 green:209/255.0 blue:82/255.0 alpha:1.0]
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"

@interface UsaServeViewController ()

@end

@implementation UsaServeViewController
- (void)loadView
{
    UIScrollView *view = [[UIScrollView alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    self.view = view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.titleView=[regular returnNavView:@"美 服 务"];
    self.view.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0];
    UIView * view= [self createType:0 andRect:CGRectMake(0, 0, ScreenWidth, 320)];
    UIView *view1 = [self createType:1 andRect:CGRectMake(0, 320, ScreenWidth, 320)];
    UIView *view2 = [self createType:2 andRect:CGRectMake(0, 640, ScreenWidth, 320)];
    UIView *view3 = [self createType:3 andRect:CGRectMake(0, 960, ScreenWidth, 320)];
    [self.view addSubview:view];
    [self.view addSubview:view1];
    [self.view addSubview:view2];
    [self.view addSubview:view3];
    UIScrollView *viewScr = (UIScrollView *)self.view;
    viewScr.contentSize = CGSizeMake(ScreenWidth, CGRectGetMaxY(view3.frame) + 40);
    viewScr.showsVerticalScrollIndicator=NO;
    UIBarButtonItem *_btn=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回箭头"] style:UIBarButtonItemStylePlain target:self action:@selector(popviewAction)];
    self.navigationItem.leftBarButtonItem=_btn;
   
}
-(void)popviewAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (UIView *)createType:(NSInteger)type andRect:(CGRect)rect
{
    UIView *view = [[UIView alloc] initWithFrame:rect];
    NSArray *serveType = @[@"申 请 加 速",@"申 请 专 案",@"签 证 专 案",@"赴 美 专 案"];
    NSArray *title = @[@[@"- 申 请 辅 助 -",@"在线问答支持,全程疑难指导;",@"目标学校申请表格及材料清单提供",@"申请递交,面试安排等全程美校沟通。"],@[@"- 申 请 全 案 -",@"目标学校全部申请表格及材料准备;",@"5所学校申请,保证2所学校录取。"],@[@"- 签 证 全 案 -",@"专家在线问答支援，全程疑难指导",@"DS160表格填写;",@"签证材料准备辅助",@"约签及通知提醒;",@"面试视频辅导(1次)。",@"等"],@[@"- 赴 美 服 务 -",@"陪飞或接机",@"寄宿家庭管理",@"在美监护",@"每月家长报告等"]];
    NSArray *money = @[@"￥680",@"￥18000",@"￥1600",@"获取更多信息"];
    NSArray *wordType = @[@"",@"a",@"b",@"c"];
    UIImageView *backViewBottom = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"card1"]];
    backViewBottom.frame = CGRectMake(10, 53, 300, 226);
    backViewBottom.userInteractionEnabled = YES;
    [view addSubview:backViewBottom];
    
    UIButton *achieveData = [regular createBtnWithRect:CGRectMake(10, CGRectGetMaxY(backViewBottom.frame) + 4, 300, 30) WithTitle:money[type] WithNormalColor:nil WithSelectColor:nil WithTitleFont:[UIFont systemFontOfSize:12.0]];
    achieveData.tag = type;
    if (type == 0||type == 3) {
        [achieveData setBackgroundColor:NEXTCOLOR];
    }
    else{
        [achieveData setBackgroundColor:[UIColor colorWithRed:234/255.0 green:85/255.0 blue:68/255.0 alpha:1.0]];}
    [achieveData setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [achieveData addTarget:self action:@selector(pay:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:achieveData];

    
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
    if (type == 0) {
        [icon setImage:[UIImage imageNamed:@"飞机"]];
    }
    //    icon.backgroundColor = [UIColor redColor];
    icon.bounds = CGRectMake(0, 0, 60, 60);
    icon.center = CGPointMake(155, 0);
    icon.layer.masksToBounds = YES;
    icon.layer.cornerRadius = icon.frame.size.width/2.0;
    [backViewBottom addSubview:icon];
    
    UILabel *name = [regular createLabelView:[[NSUserDefaults standardUserDefaults] objectForKey:@"username"] Withrect:CGRectMake(125, 35, 60, 15) WithTextColor:NEWCOLOR WithTextAlignment:1 WithFont:14.0];
    [backViewBottom addSubview:name];
    UILabel *explain = [regular createLabelView:serveType[type] Withrect:CGRectMake(125, CGRectGetMaxY(name.frame) + 5, 60, 10) WithTextColor:NEWCOLOR WithTextAlignment:1 WithFont:12.0];
    [backViewBottom addSubview:explain];
    
    UIButton *typeBtn = [regular createBtnWithRect:CGRectMake(140, 70, 30, 30) WithTitle:wordType[type] WithNormalStr:@"圆点" WithSelectStr:nil];
    [backViewBottom addSubview:typeBtn];
    
//    NSArray *listSev = @[@"- 赴美服务 -",@"陪飞或接机;",@"寄宿家庭管理;",@"在美监护;",@"约签及通知提醒;"];
    for (int i = 0; i < [title[type] count]; i ++) {
        UILabel *single = [regular createLabelView:title[type][i] Withrect:CGRectMake(0, 105 + 20 * i, 310, 15) WithTextColor:[UIColor whiteColor] WithTextAlignment:1 WithFont:13.0];
        [backViewBottom addSubview:single];
    }
    return view;
}
- (void)pay:(UIButton *)btn
{
    if(btn.tag <= 2){
    NSArray *tradeNO = @[@"100",@"1000",@"10000"];
    NSArray *price = @[@(680),@(18000),@(1600)];
    Order *order = [[Order alloc] init];
    order.partner = PARTNER;
    order.seller = SELLER;
    order.tradeNO = tradeNO[btn.tag]; //订单ID(由商家□自□行制定)
    order.productName = @"申请专案"; //商品标题
    order.productDescription = @"专案包括专家在线问答支持，全程疑难解答；DSL表格填写；签证材料准备辅助；约签及通知提醒；面试视频辅导(1次)"; //商品描述
    order.amount = [NSString stringWithFormat:@"%.2f",[price[btn.tag] floatValue]];
    //    order.notifyURL = @"http://www.xxx.com"; //回调URL
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    NSString *appScheme = @"OneBox";
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    id<DataSigner> signer = CreateRSADataSigner(PRIVATEKEY);
    NSString *signedString = [signer signString:orderSpec];
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        NSLog(@"%@",orderString);
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
        }];}}
    else
    {
        StarViewController *starVC = [[StarViewController alloc] init];
        [self.navigationController pushViewController:starVC animated:YES];
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
