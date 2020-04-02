//
//  BindingEmailViewController.m
//  OneBox
//
//  Created by 谢江新 on 15/11/5.
//  Copyright © 2015年 谢江新. All rights reserved.
//

#import "BindingEmailViewController.h"

@interface BindingEmailViewController ()

@end

@implementation BindingEmailViewController
{
    NSMutableString *nowemail;
    BOOL _ischange;
    UITextField *new_email;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepare];
    [self requestdata];
    // Do any additional setup after loading the view from its nib.
}
-(void)requestdata
{

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[[NSString alloc] initWithFormat:@"%@/v1/users/user_email",DNS] parameters:@{@"token":[regular getToken]} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *html = operation.responseString;
        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
        if([[dict objectForKey:@"code"] integerValue]==1)
        {
            if([[dict objectForKey:@"data"] objectForKey:@"cell"]!=[NSNull null])
            {
                if([[[dict objectForKey:@"data"] objectForKey:@"email"] length]>0)
                {
                    [nowemail setString:[[dict objectForKey:@"data"] objectForKey:@"email"]];
                    _ischange=YES;
//                    self.navigationItem.titleView=[regular returnNavView:@"更换绑定邮箱"];
                }else
                {
                    _ischange=NO;
//                    self.navigationItem.titleView=[regular returnNavView:@"绑定邮箱"];
                }
                UIButton*btn2=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44*2*_Scale, 44*_Scale)];
                [btn2 setTitle:@"确定" forState:UIControlStateNormal];
                //    btn2.backgroundColor=[UIColor redColor];
                [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                btn2.titleLabel.font=(kIOSVersions>=9.0? [UIFont systemFontOfSize:13.0f]:[UIFont fontWithName:@"Helvetica Neue" size:13.0f]);
                btn2.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
                [btn2 addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
                UIBarButtonItem *barright=[[UIBarButtonItem alloc] initWithCustomView:btn2];
                self.navigationItem.rightBarButtonItem=barright;
                [self UIConfig];
            }

        }


    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
    }];
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [regular dismissKeyborad];

}
-(void)UIConfig
{
    UIView *backview=[[UIView alloc] init];
    if(_ischange)
    {

        backview.frame=CGRectMake((ScreenWidth-600*_Scale)/2.0f, 64+28*_Scale, 600*_Scale, 196*_Scale);
    }else
    {
        backview.frame=CGRectMake((ScreenWidth-600*_Scale)/2.0f, 64+28*_Scale, 600*_Scale, 136*_Scale);
    }
    [self.view addSubview:backview];
    backview.backgroundColor=[UIColor whiteColor];

    CGFloat _y_p=40*_Scale;
    if(_ischange)
    {
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, _y_p, 160*_Scale, 56*_Scale)];
        [backview addSubview:label];
        //        label.backgroundColor=[UIColor redColor];
        label.textAlignment=2;
        [label setAttributedText:[regular createAttributeString:@"当前邮箱" andFloat:@(2.0)]];
        label.textColor=[UIColor colorWithRed:128.0f/255.0f green:128.0f/255.0f blue:128.0f/255.0f alpha:1];
        label.font=[regular getFont:11.0f];

        UITextField *textfield=[[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame)+10*_Scale, CGRectGetMinY(label.frame), CGRectGetWidth(backview.frame)-CGRectGetMaxX(label.frame)*(3.0f/2.0f), 56*_Scale)];
        [backview addSubview:textfield];
        UIView *dibu=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(textfield.frame)-10*_Scale, CGRectGetWidth(textfield.frame), 1*_Scale)];
        [textfield addSubview:dibu];
        dibu.backgroundColor=[UIColor colorWithRed:225.0f/255.0f green:225.0f/255.0f blue:225.0f/255.0f alpha:1];
        textfield.userInteractionEnabled=NO;
        textfield.text=nowemail;
        [textfield setValue:[UIColor colorWithRed:200.0f/255.0f green:200.0f/255.0f blue:200.0f/255.0f alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
        [textfield setValue:[UIFont boldSystemFontOfSize:10] forKeyPath:@"_placeholderLabel.font"];
        textfield.font=[regular getFont:11.0f];
        textfield.textColor=[UIColor colorWithRed:200.0f/255.0f green:200.0f/255.0f blue:200.0f/255.0f alpha:1];
        UIView *view_left=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 44*_Scale, CGRectGetHeight(textfield.frame))];

        view_left.backgroundColor=[UIColor clearColor];
        UIImageView *icon=[[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(view_left.frame)-18*_Scale)/2.0f, (CGRectGetHeight(view_left.frame)-18*_Scale)/2.0f, 18*_Scale, 18*_Scale)];
        icon.userInteractionEnabled=YES;
        icon.image=[UIImage imageNamed:@"setting_邮箱"];
        [view_left addSubview:icon];

        textfield.leftView=view_left;
        textfield.leftViewMode = UITextFieldViewModeAlways;

        _y_p+=60*_Scale;
    }

    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, _y_p, 160*_Scale, 56*_Scale)];
    [backview addSubview:label];
    //        label.backgroundColor=[UIColor redColor];
    label.textAlignment=2;
    [label setAttributedText:[regular createAttributeString:@"新邮箱" andFloat:@(2.0)]];
    label.textColor=[UIColor colorWithRed:128.0f/255.0f green:128.0f/255.0f blue:128.0f/255.0f alpha:1];
    label.font=[regular getFont:11.0f];


    new_email.frame=CGRectMake(CGRectGetMaxX(label.frame)+10*_Scale, CGRectGetMinY(label.frame), CGRectGetWidth(backview.frame)-CGRectGetMaxX(label.frame)*(3.0f/2.0f), 56*_Scale);
    [backview addSubview:new_email];
    UIView *dibu=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(new_email.frame)-10*_Scale, CGRectGetWidth(new_email.frame), 1*_Scale)];
    [new_email addSubview:dibu];
    dibu.backgroundColor=[UIColor colorWithRed:225.0f/255.0f green:225.0f/255.0f blue:225.0f/255.0f alpha:1];

    [new_email setValue:[UIColor colorWithRed:200.0f/255.0f green:200.0f/255.0f blue:200.0f/255.0f alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    [new_email setValue:[UIFont boldSystemFontOfSize:10] forKeyPath:@"_placeholderLabel.font"];
    new_email.placeholder=@"请输入新邮箱";
    new_email.font=[regular getFont:11.0f];
    new_email.textColor=[UIColor colorWithRed:200.0f/255.0f green:200.0f/255.0f blue:200.0f/255.0f alpha:1];
    UIView *view_left=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 44*_Scale, CGRectGetHeight(new_email.frame))];
    view_left.backgroundColor=[UIColor clearColor];

    new_email.leftView=view_left;
    new_email.leftViewMode = UITextFieldViewModeAlways;


}
-(void)prepare
{
    new_email=[[UITextField alloc] init];
    nowemail=[[NSMutableString alloc] init];
    UIBarButtonItem *_btn=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回箭头"] style:UIBarButtonItemStylePlain target:self action:@selector(popviewAction)];
    self.navigationItem.leftBarButtonItem=_btn;
//    self.navigationItem.titleView=[regular returnNavView:@"绑定邮箱"];
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
- (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];

    return [emailTest evaluateWithObject:candidate];
}

-(void)sendAction
{

    if(_ischange&&[new_email.text isEqualToString:nowemail])
    {
        [[ToolManager sharedManager] alertTitle_Simple:@"新邮箱不能与原邮箱一致"];

    }else
    if([new_email.text isEqualToString:@""])
    {
        [[ToolManager sharedManager] alertTitle_Simple:@"请输入新邮箱"];
    }else if(![self validateEmail:new_email.text])
    {
        [[ToolManager sharedManager] alertTitle_Simple:@"请输入正确格式的邮箱"];
    }else
    {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:[[NSString alloc] initWithFormat:@"%@/v1/users/bind_email",DNS] parameters:@{@"email":new_email.text,@"token":[regular getToken]} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *html = operation.responseString;
            NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];

            if([[dict objectForKey:@"code"] integerValue]==1)
            {

                [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"请前往邮箱验证" WithImg:@"Prompt_邮箱成功修改" Withtype:1]];
                [self.navigationController popViewControllerAnimated:YES];


            }else
            {
               [[ToolManager sharedManager] alertTitle_Simple:[dict objectForKey:@"message"]];
            }

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
        }];

    }
    
}
-(void)popviewAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
