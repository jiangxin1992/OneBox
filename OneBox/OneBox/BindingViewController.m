//
//  BindingViewController.m
//  OneBox
//
//  Created by 谢江新 on 15/10/21.
//  Copyright © 2015年 谢江新. All rights reserved.
//

#import "BindingViewController.h"

#import "CountryCodeViewController.h"

@interface BindingViewController ()

@end

@implementation BindingViewController
{
    NSInteger _time;
    NSTimer *timer;
    BOOL yanzhengma;

    
    BOOL _ischange;
    NSMutableString *cell;
    UIButton *_country_code_btn;
    UITextField *_newphonenum_text;
    UIButton *_yanzheng_btn;
    UITextField *_yanzheng_text;
    NSMutableString *countrycode;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepare];
    [self requestdata];
    codeBlock=^(NSString *code)
    {
//        记录国家code

        [_country_code_btn setTitle:[[NSString alloc] initWithFormat:@"+%@",code] forState:UIControlStateNormal];
    };
    // Do any additional setup after loading the view from its nib.
}
#pragma mark－获取是否已经存在手机号
-(void)requestdata
{

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[[NSString alloc] initWithFormat:@"%@/v1/users/cell_code",DNS] parameters:@{@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *html = operation.responseString;
        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
        if([[dict objectForKey:@"code"] integerValue]==1)
        {
            if([[dict objectForKey:@"data"] objectForKey:@"cell"]!=[NSNull null])
            {
                if([[[dict objectForKey:@"data"] objectForKey:@"cell"] length]>0)
                {
                    [cell setString:[[dict objectForKey:@"data"] objectForKey:@"cell"]];
                    _ischange=YES;

                }else
                {
                    _ischange=NO;
                }
                UIButton*btn2=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44*2*_Scale, 44*_Scale)];
                [btn2 setTitle:@"确定" forState:UIControlStateNormal];

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
-(void)UIConfig
{
    UIView *backview=[[UIView alloc] init];
    if(_ischange)
    {

        backview.frame=CGRectMake((ScreenWidth-600*_Scale)/2.0f, 64+28*_Scale, 600*_Scale, 256*_Scale);
    }else
    {
        backview.frame=CGRectMake((ScreenWidth-600*_Scale)/2.0f, 64+28*_Scale, 600*_Scale, 196*_Scale);
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
        [label setAttributedText:[regular createAttributeString:@"当前号码" andFloat:@(2.0)]];
        label.textColor=[UIColor colorWithRed:128.0f/255.0f green:128.0f/255.0f blue:128.0f/255.0f alpha:1];
        label.font=[regular getFont:11.0f];

        UITextField *textfield=[[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame)+10*_Scale, CGRectGetMinY(label.frame), CGRectGetWidth(backview.frame)-CGRectGetMaxX(label.frame)*(3.0f/2.0f), 56*_Scale)];
        [backview addSubview:textfield];
        UIView *dibu=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(textfield.frame)-10*_Scale, CGRectGetWidth(textfield.frame), 1*_Scale)];
        [textfield addSubview:dibu];
        dibu.backgroundColor=[UIColor colorWithRed:225.0f/255.0f green:225.0f/255.0f blue:225.0f/255.0f alpha:1];
        textfield.userInteractionEnabled=NO;
        textfield.text=cell;
        [textfield setValue:[UIColor colorWithRed:200.0f/255.0f green:200.0f/255.0f blue:200.0f/255.0f alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
        [textfield setValue:[UIFont boldSystemFontOfSize:10] forKeyPath:@"_placeholderLabel.font"];
        textfield.font=[regular getFont:11.0f];
        textfield.textColor=[UIColor colorWithRed:200.0f/255.0f green:200.0f/255.0f blue:200.0f/255.0f alpha:1];
        UIView *view_left=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 44*_Scale, CGRectGetHeight(textfield.frame))];
        view_left.backgroundColor=[UIColor clearColor];

        UIImageView *icon=[[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(view_left.frame)-18*_Scale)/2.0f, (CGRectGetHeight(view_left.frame)-18*_Scale)/2.0f, 18*_Scale, 18*_Scale)];
        icon.userInteractionEnabled=YES;
        icon.image=[UIImage imageNamed:@"setting_电话"];
        [view_left addSubview:icon];

        textfield.leftView=view_left;
        textfield.leftViewMode = UITextFieldViewModeAlways;

        _y_p+=60*_Scale;
    }

    for (int i=0; i<2; i++) {
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, _y_p+60*_Scale*i, 160*_Scale, 56*_Scale)];

        [backview addSubview:label];
        //        label.backgroundColor=[UIColor redColor];
        label.textAlignment=2;
        [label setAttributedText:[regular createAttributeString:i==0?@"新号码":@"验证码" andFloat:@(2.0)]];
        label.textColor=[UIColor colorWithRed:128.0f/255.0f green:128.0f/255.0f blue:128.0f/255.0f alpha:1];
        label.font=[regular getFont:11.0f];
        if(i==1)
        {

            _yanzheng_text.frame=CGRectMake(CGRectGetMaxX(label.frame)+10*_Scale, CGRectGetMinY(label.frame), CGRectGetWidth(backview.frame)-CGRectGetMaxX(label.frame)*(3.0f/2.0f), 56*_Scale);
            [backview addSubview:_yanzheng_text];
            UIView *dibu=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_yanzheng_text.frame)-10*_Scale, CGRectGetWidth(_yanzheng_text.frame), 1*_Scale)];
            [_yanzheng_text addSubview:dibu];
            dibu.backgroundColor=[UIColor colorWithRed:225.0f/255.0f green:225.0f/255.0f blue:225.0f/255.0f alpha:1];

            [_yanzheng_text setValue:[UIColor colorWithRed:200.0f/255.0f green:200.0f/255.0f blue:200.0f/255.0f alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
            [_yanzheng_text setValue:[UIFont boldSystemFontOfSize:10] forKeyPath:@"_placeholderLabel.font"];
            _yanzheng_text.font=[regular getFont:11.0f];
            _yanzheng_text.textColor=[UIColor colorWithRed:200.0f/255.0f green:200.0f/255.0f blue:200.0f/255.0f alpha:1];
            _yanzheng_text.placeholder=@"请输入验证码";

            UIView *view_right=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 110*_Scale, CGRectGetHeight(_yanzheng_text.frame))];
//            view_right.backgroundColor=[UIColor grayColor];
//36
            _yanzheng_btn.frame=CGRectMake(0, (CGRectGetHeight(view_right.frame)-10*_Scale-36*_Scale)/2.0f, 100*_Scale, 36*_Scale);
            [view_right addSubview:_yanzheng_btn];
            [_yanzheng_btn setBackgroundColor:_define_blue_color];
            [_yanzheng_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_yanzheng_btn setTitle:@"获取验证码" forState:UIControlStateNormal];
            [_yanzheng_btn setTitle:@"" forState:UIControlStateSelected];
            if(_isPad)
            {
                _yanzheng_btn.titleLabel.font=(kIOSVersions>=9.0? [UIFont systemFontOfSize:20.0f]:[UIFont fontWithName:@"Helvetica Neue" size:20.0f]);

            }else
            {
                _yanzheng_btn.titleLabel.font=(kIOSVersions>=9.0? [UIFont systemFontOfSize:8.0f]:[UIFont fontWithName:@"Helvetica Neue" size:8.0f]);

            }

            _yanzheng_btn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
            [_yanzheng_btn addTarget:self action:@selector(getyanzheng_code:) forControlEvents:UIControlEventTouchUpInside];


            _yanzheng_text.rightView=view_right;
            _yanzheng_text.rightViewMode = UITextFieldViewModeAlways;

            UIView *view_left=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 20*_Scale, CGRectGetHeight(_yanzheng_text.frame))];
//            view_left.backgroundColor=[UIColor redColor];

            _yanzheng_text.leftView=view_left;
            _yanzheng_text.leftViewMode = UITextFieldViewModeAlways;



        }else
        {
            CGFloat _x_p=CGRectGetMaxX(label.frame)+10*_Scale;
            for (int j=0; j<2; j++) {
                CGFloat _width=j==0?100*_Scale:(CGRectGetWidth(backview.frame)-CGRectGetMaxX(label.frame)*(3.0f/2.0f)-106*_Scale);
                if(j==0)
                {
                    _country_code_btn.frame=CGRectMake(_x_p, CGRectGetMinY(label.frame), _width, CGRectGetHeight(label.frame));
//                    _country_code_btn.backgroundColor=[UIColor grayColor];
                    [_country_code_btn addTarget:self action:@selector(choose_countrycode:) forControlEvents:UIControlEventTouchUpInside];
                    [backview addSubview:_country_code_btn];
                    [_country_code_btn setTitleColor:[UIColor colorWithRed:200.0f/255.0f green:200.0f/255.0f blue:200.0f/255.0f alpha:1] forState:UIControlStateNormal];
//                    _country_code_btn.backgroundColor=[UIColor redColor];
                    _country_code_btn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
                    _country_code_btn.titleLabel.font=[regular get_en_Font:11.0f];
                    [_country_code_btn setTitle:countrycode forState:UIControlStateNormal];
                    UIImageView *xiala=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bangding_xiala"]];
                    xiala.frame=CGRectMake(CGRectGetWidth(_country_code_btn.frame)-20*_Scale, 24*_Scale, 14*_Scale, 8*_Scale);
                    [_country_code_btn addSubview:xiala];


                }else
                {
                    _newphonenum_text.frame=CGRectMake(_x_p, CGRectGetMinY(label.frame), _width, CGRectGetHeight(label.frame));
//                    _newphonenum_text.backgroundColor=[UIColor redColor];
                    [backview addSubview:_newphonenum_text];
                    [_newphonenum_text setValue:[UIColor colorWithRed:200.0f/255.0f green:200.0f/255.0f blue:200.0f/255.0f alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
                    [_newphonenum_text setValue:[UIFont boldSystemFontOfSize:10] forKeyPath:@"_placeholderLabel.font"];
                    _newphonenum_text.font=[regular getFont:11.0f];
                    _newphonenum_text.textColor=[UIColor colorWithRed:200.0f/255.0f green:200.0f/255.0f blue:200.0f/255.0f alpha:1];

                    UIView *view_left=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 20*_Scale, CGRectGetHeight(_newphonenum_text.frame))];
                    view_left.backgroundColor=[UIColor clearColor];

                    _newphonenum_text.leftView=view_left;
                    _newphonenum_text.leftViewMode = UITextFieldViewModeAlways;

                }
                UIView *dibu=[[UIView alloc] initWithFrame:CGRectMake(_x_p, CGRectGetMaxY(label.frame)-10*_Scale,_width, 1*_Scale)];
                [backview addSubview:dibu];
                dibu.backgroundColor=[UIColor colorWithRed:225.0f/255.0f green:225.0f/255.0f blue:225.0f/255.0f alpha:1];
                _x_p+=106*_Scale;


            }


        }
    }

}
#pragma mark-获取验证码
-(void)getyanzheng_code:(UIButton *)btn
{

    if(_ischange&&[_newphonenum_text.text isEqualToString:cell])
    {

            [[ToolManager sharedManager] alertTitle_Simple:@"新号码不能与原密码一致"];


    }else if([_newphonenum_text.text isEqualToString:@""])
    {
        [[ToolManager sharedManager] alertTitle_Simple:@"请填写新号码"];

    }else
    {
        NSString *_code=_country_code_btn.titleLabel.text;

//        NSString *content=nil;
//        if([_code isEqualToString:@"+86"])
//        {
//            content=_newphonenum_text.text;
//        }else
//        {
//            content=[[NSString alloc] initWithFormat:@"%@%@",_code,_newphonenum_text.text];
//        }

        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSDictionary *pushdict=@{@"cell":_newphonenum_text.text,@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],@"cell_code":_code};
        [manager POST:[[NSString alloc] initWithFormat:@"%@/v1/users/send_bind_cell_message",DNS] parameters:pushdict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *html = operation.responseString;
            NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];

            if([[dict objectForKey:@"code"] integerValue]==1)
            {

                [self presentViewController:[regular alertTitle_Simple:@"发送成功"] animated:YES completion:nil];
#pragma mark-激活定时器
                yanzhengma=YES;
                _time=60;
                btn.selected=YES;
                btn.userInteractionEnabled=NO;
                //开启定时器
                if(timer==nil)
                {
                    timer =  [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(function) userInfo:nil repeats:YES];
                    [timer fire];
                }


            }else
            {
                [[ToolManager sharedManager] alertTitle_Simple:[dict objectForKey:@"message"]];

            }

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
        }];

    }
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];

}
-(void)function
{
    _time--;

    [_yanzheng_btn setTitle:[[NSString alloc] initWithFormat:@"%lds",(long)_time] forState:UIControlStateSelected];
    if(!_time)
    {

        [timer invalidate];
        _yanzheng_btn.selected=NO;
        _yanzheng_btn.userInteractionEnabled=YES;
    }
    
}
-(void)choose_countrycode:(UIButton *)btn
{
    CountryCodeViewController *country=[[CountryCodeViewController alloc] init];
    country.block=codeBlock;
    [self.navigationController pushViewController:country animated:YES];

}
-(void)prepare
{

    _time=60;
    yanzhengma=NO;

    countrycode=[[NSMutableString alloc] initWithString:@"+86"];
    _country_code_btn=[UIButton buttonWithType:UIButtonTypeCustom];
    _yanzheng_btn=[UIButton buttonWithType:UIButtonTypeCustom];
    _newphonenum_text=[[UITextField alloc] init];
    _yanzheng_text=[[UITextField alloc] init];
    cell=[[NSMutableString alloc] init];
    _ischange=NO;
    UIBarButtonItem *_btn=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回箭头"] style:UIBarButtonItemStylePlain target:self action:@selector(popviewAction)];
    self.navigationItem.leftBarButtonItem=_btn;

    self.view.backgroundColor=_define_backview_color;

}
#pragma mark-验证并更改
-(void)sendAction
{
    if(_ischange&&[_newphonenum_text.text isEqualToString:cell])
    {
        [[ToolManager sharedManager] alertTitle_Simple:@"新号码不能与原密码一致"];

    }else if([_newphonenum_text.text isEqualToString:@""]||[_yanzheng_text.text isEqualToString:@""])
    {
        [[ToolManager sharedManager] alertTitle_Simple:@"请输入完整信息"];
    }else
    {
        NSString *_code=_country_code_btn.titleLabel.text;
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSDictionary *dict=@{@"cell":_newphonenum_text.text,@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],@"code":_yanzheng_text.text,@"cell_code":_code};
        [manager POST:[[NSString alloc] initWithFormat:@"%@/v1/users/bind_cell",DNS] parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *html = operation.responseString;
            NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];

            if([[dict objectForKey:@"code"] integerValue]==1)
            {
                [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"成功提交修改" WithImg:@"Prompt_手机修改" Withtype:1]];
#pragma mark-激活定时器
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
-(void)viewWillAppear:(BOOL)animated
{
//
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"BindingViewController"];

}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"BindingViewController"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
