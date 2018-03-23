//
//  resetPasswordViewController.m
//  OneBox
//
//  Created by 谢江新 on 15/5/5.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import "resetPasswordViewController.h"

#define Color_tp [UIColor colorWithRed:170.0f/255.0f green:230.0f/255.0f blue:245.0f/255.0f alpha:1]

@interface resetPasswordViewController ()<UITextFieldDelegate,UIAlertViewDelegate>

@end

@implementation resetPasswordViewController
{
    //用户名
    UITextField *username;
    //密码
    UITextField *password;
    UIButton *login;
    UIAlertView *alertview;
    UIButton *showpass_btn;
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
    UIButton *back_btn=[UIButton getCustomImgBtnWithImageStr:@"login_返回" WithSelectedImageStr:nil];
    [self.view addSubview:back_btn];
    [back_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(50*_Scale);
        make.top.mas_equalTo(self.mas_topLayoutGuideBottom).with.offset(20*_Scale);
        make.right.mas_equalTo(-55*_Scale);
    }];
    [back_btn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    back_btn.imageEdgeInsets = UIEdgeInsetsMake(12.5*_Scale, 12.5*_Scale, 12.5*_Scale, 12.5*_Scale);


    username=[[UITextField alloc] initWithFrame:CGRectMake((ScreenWidth-400*_Scale)/2.0f, 336*_Scale, 280*_Scale, 50*_Scale)];
    username.delegate=self;
    username.textColor=[UIColor whiteColor];
    username.placeholder=@" 新 密 码 ";
    [username setValue:Color_tp forKeyPath:@"_placeholderLabel.textColor"];
     username.secureTextEntry=YES;
    [username setValue:[UIFont boldSystemFontOfSize:12] forKeyPath:@"_placeholderLabel.font"];
    username.font=[regular getFont:12.0f];
    UIView *dibu=[[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(username.frame), CGRectGetMaxY(username.frame)-10*_Scale, 400*_Scale, 2*_Scale)];
    dibu.backgroundColor=[UIColor colorWithRed:1 green:1 blue:1 alpha:0.2];
    [self.view addSubview:dibu];
    username.delegate=self;
    username.clearButtonMode=UITextFieldViewModeWhileEditing;
    [self.view addSubview:username];
    showpass_btn=[UIButton buttonWithType:UIButtonTypeCustom];
    showpass_btn.frame=CGRectMake(CGRectGetMaxX(username.frame), CGRectGetMinY(username.frame), 120*_Scale, CGRectGetHeight(username.frame));
    [showpass_btn addTarget:self action:@selector(showpassAction:) forControlEvents:UIControlEventTouchUpInside];
    [showpass_btn setImage:[UIImage imageNamed:@"login_显示密码( 未选择)"] forState:UIControlStateNormal];
    [showpass_btn setImage:[UIImage imageNamed:@"login_显示密码"] forState:UIControlStateSelected];
    [showpass_btn setImageEdgeInsets:UIEdgeInsetsMake((CGRectGetHeight(showpass_btn.frame)-47*_Scale)/2.0f, 60*_Scale, (CGRectGetHeight(showpass_btn.frame)-47*_Scale)/2.0f, 0)];
    [self.view addSubview:showpass_btn];

    //    修改btn的frame
    login=[UIButton buttonWithType:UIButtonTypeCustom];

    [login setBackgroundColor:_define_blue_color_login];
    [login setTitle:@"提   交" forState:UIControlStateNormal];
    [login setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    login.titleLabel.font=[regular getFont:13.0f];
    [login addTarget:self action:@selector(sumbit_action:) forControlEvents:UIControlEventTouchUpInside];
    login.frame=CGRectMake(CGRectGetMinX(username.frame), CGRectGetMaxY(username.frame)+25*_Scale,400*_Scale, 400*_Scale*2.0f/13.0f);
    [self.view addSubview:login];

}
-(void)showpassAction:(UIButton *)btn
{
    if(btn.selected)
    {
        username.secureTextEntry=YES;
        btn.selected=NO;
    }else
    {
        username.secureTextEntry=NO;
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
-(void)sumbit_action:(UIButton *)btn
{
    if([username.text isEqualToString:@""])
    {
        [self presentViewController:[regular alertTitle_Simple:@"密码不能为空"] animated:YES completion:nil];
    }else if([username.text length]<6||[username.text length]>16)
    {
        [self presentViewController:[regular alertTitle_Simple:@"密码长度为6到16位之间"] animated:YES completion:nil];
    }else
    {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

        NSDictionary *parameters=@{@"cell":[_dict objectForKey:@"tel"],@"code":[_dict objectForKey:@"code"],@"password":username.text,@"update":@"1"};
        [manager POST:[[NSString alloc] initWithFormat:@"%@%@",DNS,@"/v1/users/update_password"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {

            NSString *html = operation.responseString;
            NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
            if([[dict objectForKey:@"code"] intValue]==1)
            {
                alertview=[[ToolManager sharedManager] alertTitle_Simple:@"修改成功请重新登录"];
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
        self.block();
}
#pragma mark-touch开始时调用
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //    收回键盘
    [regular dismissKeyborad];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"resetPasswordViewController"];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"resetPasswordViewController"];
}
#pragma mark-return后隐藏键盘
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
