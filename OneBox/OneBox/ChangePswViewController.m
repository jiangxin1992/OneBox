//
//  ChangePswViewController.m
//  OneBox
//
//  Created by 谢江新 on 15/10/20.
//  Copyright © 2015年 谢江新. All rights reserved.
//

#import "ChangePswViewController.h"

@interface ChangePswViewController ()<UITextFieldDelegate>

@end

@implementation ChangePswViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepare];
    [self UIConfig];

    // Do any additional setup after loading the view from its nib.
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [regular dismissKeyborad];

}
-(void)UIConfig
{
    UIView *backview=[[UIView alloc] initWithFrame:CGRectMake((ScreenWidth-600*_Scale)/2.0f, 64+28*_Scale, 600*_Scale, 256*_Scale)];
    [self.view addSubview:backview];
    backview.backgroundColor=[UIColor whiteColor];
    for (int i=0; i<3; i++) {

        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, 40*_Scale+60*_Scale*i, 160*_Scale, 56*_Scale)];
        [backview addSubview:label];
//        label.backgroundColor=[UIColor redColor];
        label.textAlignment=2;
        [label setAttributedText:[regular createAttributeString:i==0?@"当前密码":i==1?@"新密码":@"再次输入" andFloat:@(2.0)]];
        label.textColor=[UIColor colorWithRed:128.0f/255.0f green:128.0f/255.0f blue:128.0f/255.0f alpha:1];
        label.font=[regular getFont:11.0f];

        UITextField *textfield=[[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame)+10*_Scale, CGRectGetMinY(label.frame), CGRectGetWidth(backview.frame)-CGRectGetMaxX(label.frame)*(3.0f/2.0f), 56*_Scale)];
        textfield.tag=100+i;
        [backview addSubview:textfield];
        UIView *dibu=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(textfield.frame)-1*_Scale, CGRectGetWidth(textfield.frame), 1*_Scale)];
        [textfield addSubview:dibu];
        dibu.backgroundColor=[UIColor colorWithRed:225.0f/255.0f green:225.0f/255.0f blue:225.0f/255.0f alpha:1];
        textfield.secureTextEntry=YES;

        textfield.returnKeyType=UIReturnKeyDone;
        textfield.placeholder=i==0?@"请输入当前密码":i==1?@"请输入六位以上的密码":@"请再次输入新密码";
        textfield.font=[regular getFont:11.0f];
        textfield.delegate=self;
        textfield.textColor=[UIColor colorWithRed:200.0f/255.0f green:200.0f/255.0f blue:200.0f/255.0f alpha:1];
        textfield.clearButtonMode=UITextFieldViewModeWhileEditing;
        UIView *view_left=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 20*_Scale, CGRectGetHeight(textfield.frame))];
        view_left.backgroundColor=[UIColor clearColor];

        textfield.leftView=view_left;
        textfield.leftViewMode = UITextFieldViewModeAlways;


    }

}
-(void)prepare
{
    UIBarButtonItem *_btn=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回箭头"] style:UIBarButtonItemStylePlain target:self action:@selector(popviewAction)];
    self.navigationItem.leftBarButtonItem=_btn;
//    self.navigationItem.titleView=[regular returnNavView:@"修改密码"];
    self.view.backgroundColor=_define_backview_color;
    UIButton*btn2=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44*2*_Scale, 44*_Scale)];
    [btn2 setTitle:@"确定" forState:UIControlStateNormal];
    //    btn2.backgroundColor=[UIColor redColor];
    [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn2.titleLabel.font=(kIOSVersions>=9.0? [UIFont systemFontOfSize:13.0f]:[UIFont fontWithName:@"Helvetica Neue" size:13.0f]);
    btn2.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
    [btn2 addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barright=[[UIBarButtonItem alloc] initWithCustomView:btn2];
    self.navigationItem.rightBarButtonItem=barright;
}
-(void)sendAction
{
    NSString *content1=((UITextField *)[self.view viewWithTag:100]).text;
    NSString *content2=((UITextField *)[self.view viewWithTag:101]).text;
    NSString *content3=((UITextField *)[self.view viewWithTag:102]).text;

    NSArray *contentArr=@[content1,content2,content3];
    BOOL nocontent=NO;
    for (NSString *str in contentArr) {
        if([str isEqualToString:@""])
        {
            nocontent=YES;
            break;
        }
    }
    BOOL morethansixnum=YES;
    if(([content2 length]<6)||([content3 length]<6))
    {
        morethansixnum=NO;
    }


    if(nocontent)
    {
        [[ToolManager sharedManager] alertTitle_Simple:@"请输入密码"];
    }else if(![content2 isEqualToString:content3])
    {
        [[ToolManager sharedManager] alertTitle_Simple:@"两次密码输入不一致，请重新输入"];
    }else if(!morethansixnum)
    {
        [[ToolManager sharedManager] alertTitle_Simple:@"请输入六位以上的密码"];
    }
    else
    {

        [[ToolManager sharedManager] createProgress:@"提交中..."];
        
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        NSDictionary *parameters=@{@"token":[regular getToken],@"password":content1,@"new_password":content2};
        [manager POST:[[NSString alloc] initWithFormat:@"%@/v1/users/change_password",DNS] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *html = operation.responseString;
            NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
            [[ToolManager sharedManager] removeProgress];
            if([[dict objectForKey:@"code"] integerValue]==1)
            {
                [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"成功提交修改" WithImg:@"Prompt_密码修改成功"Withtype:1]];
                [self popviewAction];
            }else
            {
                 [[ToolManager sharedManager] alertTitle_Simple:[dict objectForKey:@"message"]];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
            [[ToolManager sharedManager] removeProgress];
        }];

    }


}
-(void)popviewAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"ChangePswViewController"];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"ChangePswViewController"];
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
