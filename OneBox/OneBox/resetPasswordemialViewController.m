//
//  resetPasswordViewController.m
//  OneBox
//
//  Created by 谢江新 on 15/5/5.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import "resetPasswordemialViewController.h"

#import <objc/runtime.h>

#define Color_tp [UIColor colorWithRed:170.0f/255.0f green:230.0f/255.0f blue:245.0f/255.0f alpha:1]

@interface resetPasswordemialViewController ()<UITextFieldDelegate,UIAlertViewDelegate>

@end

@implementation resetPasswordemialViewController
{
    //用户名
    UITextField *username;
    //密码
    UITextField *password;
    UIButton *login;
    UIAlertView *alertview;
//    UIButton *showpass_btn;
    UIImageView *showimg;
    UIImageView *backgroundImg;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    backgroundImg=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    if(_isPad)
    {
        backgroundImg.backgroundColor=_define_login_background;

    }else
    {
        backgroundImg.image=[UIImage imageNamed:@"login_背景层"];
    }
    [self.view addSubview:backgroundImg];
    [self UIConfig];

}
-(void)UIConfig
{
//    self.view.backgroundColor=[UIColor colorWithRed:86.0f/255.0f green:190.0f/255.0f blue:215.0f/255.0f alpha:1];

    UIButton *back_btn=[UIButton getCustomImgBtnWithImageStr:@"login_返回" WithSelectedImageStr:nil];
    [self.view addSubview:back_btn];
    [back_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(50*_Scale);
        make.top.mas_equalTo(self.mas_topLayoutGuideBottom).with.offset(20*_Scale);
        make.right.mas_equalTo(-55*_Scale);
    }];
    [back_btn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    back_btn.imageEdgeInsets = UIEdgeInsetsMake(12.5*_Scale, 12.5*_Scale, 12.5*_Scale, 12.5*_Scale);
    

    username=[[UITextField alloc] initWithFrame:CGRectMake((ScreenWidth-400*_Scale)/2.0f, 336*_Scale, 400*_Scale, 50*_Scale)];

    username.delegate=self;

    username.textColor=[UIColor whiteColor];
    username.placeholder=@"邮 箱";
    [username setValue:Color_tp forKeyPath:@"_placeholderLabel.textColor"];

    username.textAlignment=1;
    [username setValue:[UIFont boldSystemFontOfSize:12] forKeyPath:@"_placeholderLabel.font"];
    username.font=[regular get_en_Font:12.0f];
    UIView *dibu=[[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(username.frame), CGRectGetMaxY(username.frame)-10*_Scale, 400*_Scale, 2*_Scale)];
    dibu.backgroundColor=[UIColor colorWithRed:1 green:1 blue:1 alpha:0.2];
    [self.view addSubview:dibu];


    username.delegate=self;
    username.clearButtonMode=UITextFieldViewModeWhileEditing;
    [self.view addSubview:username];


    UILabel *titlelabel=[[UILabel alloc] initWithFrame:CGRectMake(80*_Scale, CGRectGetMaxY(username.frame)-100*_Scale-100*_Scale, ScreenWidth-80*_Scale*2, 100*_Scale)];

    titlelabel.numberOfLines=0;
    titlelabel.font=[regular getFont:11.0f];
    titlelabel.textColor=[UIColor whiteColor];
    [self.view addSubview:titlelabel];

    NSMutableAttributedString *attributedString =[[NSMutableAttributedString alloc] initWithString:@"如果您忘记密码，我们会向您发送可以用于重设密码的电子邮件。" attributes:@{NSKernAttributeName : @(1.0)}];

    //设置行间距


    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];

    [paragraphStyle setLineSpacing:3];//调整行间距

    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [@"如果您忘记密码，我们会向您发送可以用于重设密码的电子邮件。" length])];
    titlelabel.attributedText = attributedString;
 titlelabel.textAlignment=1;

    //    修改btn的frame
    login=[UIButton buttonWithType:UIButtonTypeCustom];
    [login setTitle:@"发  送  邮  件" forState:UIControlStateNormal];

    login.titleLabel.font=[regular getFont:13.0f];
    [login setBackgroundColor:_define_blue_color_login];

    [login addTarget:self action:@selector(sumbit_action:) forControlEvents:UIControlEventTouchUpInside];
    login.frame=CGRectMake(CGRectGetMinX(username.frame), CGRectGetMaxY(username.frame)+25*_Scale,400*_Scale, 400*_Scale*2.0f/13.0f);

    [self.view addSubview:login];

}
-(void)showpassAction:(UIButton *)btn
{
    if(btn.selected)
    {
        username.secureTextEntry=YES;
        showimg.image=[UIImage imageNamed:@""];
        btn.selected=NO;
    }else
    {
        username.secureTextEntry=NO;
        showimg.image=[UIImage imageNamed:@"login_显示密码"];
        btn.selected=YES;
    }

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView==alertview)
    {
        self.block2();
    }
}
- (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];

    return [emailTest evaluateWithObject:candidate];
}

-(void)sumbit_action:(UIButton *)btn
{

    [regular dismissKeyborad];
    
    if(![self validateEmail:username.text])
    {
        [self presentViewController:[regular alertTitle_Simple:@"请输入正确格式的邮箱。"] animated:YES completion:nil];
    }else
    {
        [regular dismissKeyborad];

        [[ToolManager sharedManager] createProgress:@"提交中..."];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

        NSDictionary *parameters=@{@"email":username.text};
        [manager POST:[[NSString alloc] initWithFormat:@"%@%@",DNS,@"/v1/users/forget_password"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {

            NSString *html = operation.responseString;
            NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
            if([[dict objectForKey:@"code"] intValue]==1)
            {
                alertview=[[ToolManager sharedManager] alertTitle_Simple:@"我们已将更改密码的链接发送至您的邮箱，请注意查收"];
                alertview.delegate=self;

            }else
            {
                [[ToolManager sharedManager] alertTitle_Simple:[dict objectForKey:@"message"]];
            }

            [[ToolManager sharedManager] removeProgress];


        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错蓝色" Withtype:2]];

            [[ToolManager sharedManager] removeProgress];
        }];


    }
}
-(void)backAction:(UIButton *)btn
{

    [self.navigationController setNavigationBarHidden:NO animated:YES];
//    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.block();


}
#pragma mark-touch开始时调用
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //    收回键盘
    [regular dismissKeyborad];
}

#pragma mark-return后隐藏键盘
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"resetPasswordViewController"];

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"resetPasswordViewController"];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
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
