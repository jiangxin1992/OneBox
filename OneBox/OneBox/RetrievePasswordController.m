//
//  RetrievePasswordController.m
//  OneBox
//
//  Created by 谢江新 on 15-2-5.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import "RetrievePasswordController.h"

#import "RegisterController.h"
#import "resetPasswordViewController.h"

#import "CountryCodeLoginCell.h"

#define foundCellHeight 60*_Scale
#define Color_tp [UIColor colorWithRed:170.0f/255.0f green:230.0f/255.0f blue:245.0f/255.0f alpha:1]

@interface RetrievePasswordController ()<UITextFieldDelegate>

@end

@implementation RetrievePasswordController
{
    NSMutableDictionary *countrydict;
    NSMutableArray *_arrayChar;
    
    UIView *choosecity;
    NSMutableString *countrycode;
    UIButton *_country_code_btn;
    UIImageView *backgroundImg;
    NSInteger _time;
    UITextField *textfield_email;
    UITextField *textfield_yanzheng;
    UIButton *get_yanzheng;
    UIButton *submit;
    NSTimer *timer;
    NSMutableString *remainTime;

    BOOL yanzhengma;

}
- (void)viewDidLoad {
    [super viewDidLoad];

    registerBlock2=^()
    {
        self.block2();
    };

    registerBlock=^()
    {
        [self dismissModalViewControllerAnimated:YES];
    };
}
-(void)prepareData
{

    countrydict=[[NSMutableDictionary alloc] init];
    _arrayChar=[[NSMutableArray alloc] init];
    countrycode=[[NSMutableString alloc] initWithString:@"+86"];
    backgroundImg=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    if(_isPad)
    {
        backgroundImg.backgroundColor=_define_login_background;

    }else
    {
        backgroundImg.image=[UIImage imageNamed:@"login_背景层"];
    }
    [self.view addSubview:backgroundImg];
    _time=60;
    textfield_email=[[UITextField alloc] init];
    textfield_yanzheng=[[UITextField alloc] init];
    yanzhengma=NO;


    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"country_code" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    NSMutableDictionary *data1=[[NSMutableDictionary alloc] init];
    NSArray *keyarr=[data allKeys];
    for (int i=0; i<keyarr.count; i++) {
        NSArray *arr=[data objectForKey:[keyarr objectAtIndex:i]];
        if(arr.count>0)
        {

            NSMutableArray *mutablearr=[[NSMutableArray alloc] init];
            for (NSString *content in arr) {
                NSArray *array = [content componentsSeparatedByString:@"+"];

                if(array.count==2)
                {
                    NSDictionary *dict___t=@{@"country":[array objectAtIndex:0],@"code":[array objectAtIndex:1]};
                    [mutablearr addObject:dict___t];

                }
            }
            [data1 setObject:mutablearr forKey:[keyarr objectAtIndex:i]];
        }
    }


    for (int i=0; i<keyarr.count; i++) {
        NSArray *arr=[data1 objectForKey:[keyarr objectAtIndex:i]];
        if(arr.count>0)
        {
            [countrydict setObject:arr forKey:[keyarr objectAtIndex:i]];
        }
    }

    for (int i = 0; i < 26; i++) {
        NSString *str = [NSString stringWithFormat:@"%c", 'A' + i];
        for (NSString *key in [countrydict allKeys]) {
            if ([str isEqualToString:key]) {
                [_arrayChar addObject:str];
            }
        }
    }
}
-(void)setType1:(NSString *)type1
{
    if(_type1!=type1)
    {
        _type1=[type1 copy];
        [self prepareData];
        [self UIConfig];
    }
}
-(void)UIConfig
{
    self.view.backgroundColor=[UIColor colorWithRed:86.0f/255.0f green:190.0f/255.0f blue:215.0f/255.0f alpha:1];
    textfield_email.delegate=self;
    textfield_email.clearButtonMode=UITextFieldViewModeWhileEditing;
    //    给导航栏添加标题

    UIButton *back_btn=[UIButton buttonWithType:UIButtonTypeCustom];
    back_btn.frame=CGRectMake(ScreenWidth-(25+35)*_Scale, 40*_Scale,50*_Scale, 50*_Scale);
    UIImageView *imageqqq=[[UIImageView alloc] initWithFrame:CGRectMake(0, (CGRectGetWidth(back_btn.frame))/4.0f, (CGRectGetWidth(back_btn.frame))/2.0f, (CGRectGetWidth(back_btn.frame))/2.0f)];
    imageqqq.image=[UIImage imageNamed:@"login_返回"];
    [back_btn addSubview:imageqqq];

    [back_btn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back_btn];    //    留美盒子icon

    CGFloat _y_p=230*_Scale;

    for (int i=0; i<2; i++) {
        UITextField *textfiled=i==0?textfield_email:textfield_yanzheng;

        if(i==0)
        {
            _country_code_btn=[UIButton buttonWithType:UIButtonTypeCustom];

            _country_code_btn.frame=CGRectMake((ScreenWidth-500*_Scale)/2, _y_p,90*_Scale, 70*_Scale);


            [_country_code_btn addTarget:self action:@selector(choose_countrycode:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:_country_code_btn];
            [_country_code_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

            _country_code_btn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
            _country_code_btn.titleLabel.font=[regular get_en_Font:11.0f];
            [_country_code_btn setTitle:countrycode forState:UIControlStateNormal];
            UIImageView *xiala=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bangding_xiala"]];
            xiala.frame=CGRectMake(CGRectGetWidth(_country_code_btn.frame)-20*_Scale, 24*_Scale, 14*_Scale, 8*_Scale);
            [_country_code_btn addSubview:xiala];

            textfiled.frame=CGRectMake((ScreenWidth-500*_Scale)/2+100*_Scale, _y_p,400*_Scale, 70*_Scale);
            UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_country_code_btn.frame)-10*_Scale, CGRectGetWidth(_country_code_btn.frame), 2*_Scale)];
            view.backgroundColor=[UIColor colorWithRed:1 green:1 blue:1 alpha:0.2];
            [_country_code_btn addSubview:view];
            [self.view addSubview:textfiled];

        }else
        {
            textfiled.frame=CGRectMake((ScreenWidth-500*_Scale)/2, _y_p,500*_Scale, 70*_Scale);
        }




        NSString *title=i==0?@" 手 机 号 ":@" 验 证 码 ";
        textfiled.placeholder=title;

        textfiled.font=[regular getFont:12.0f];
        textfiled.delegate=self;
        textfiled.textColor=[UIColor whiteColor];


        [textfiled setValue:Color_tp forKeyPath:@"_placeholderLabel.textColor"];

        [textfiled setValue:[regular getFont:12.0f] forKeyPath:@"_placeholderLabel.font"];

        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(textfiled.frame)-10*_Scale, CGRectGetWidth(textfiled.frame), 2*_Scale)];
        view.backgroundColor=[UIColor colorWithRed:1 green:1 blue:1 alpha:0.2];
        [textfiled addSubview:view];
        [self.view addSubview:textfiled];
        _y_p+=CGRectGetHeight(textfiled.frame)+10*_Scale;

    }

    UIView *rightView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 130*_Scale, CGRectGetHeight(textfield_email.frame))];
    get_yanzheng=[UIButton buttonWithType:UIButtonTypeCustom];
    get_yanzheng.frame=CGRectMake(0, (CGRectGetHeight(textfield_email.frame)-(130*_Scale*44.0f)/130.0f)/2.0f, 130*_Scale, (130*_Scale*44.0f)/130.0f);
    remainTime=[[NSMutableString alloc] initWithFormat:@"%lds",(long)_time];
    [get_yanzheng setTitle:remainTime forState:UIControlStateSelected];
    [get_yanzheng addTarget:self action:@selector(yanzheng:) forControlEvents:UIControlEventTouchUpInside];
    [get_yanzheng setBackgroundImage:[UIImage imageNamed:@"获取验证码"] forState:UIControlStateNormal];
    [get_yanzheng setBackgroundImage:[UIImage imageNamed:@"获取验证码select"] forState:UIControlStateSelected];
//    [get_yanzheng setTitle:@"获取验证码" forState:UIControlStateNormal];

    get_yanzheng.titleLabel.font=[regular get_en_Font:9.0f];
    [rightView addSubview:get_yanzheng];

    textfield_email.rightViewMode = UITextFieldViewModeAlways;
    textfield_email.rightView=rightView;


//    提交
    submit=[UIButton buttonWithType:UIButtonTypeCustom];
    submit.frame=CGRectMake(CGRectGetMinX(textfield_yanzheng.frame), _y_p+28*_Scale, CGRectGetWidth(textfield_yanzheng.frame), CGRectGetWidth(textfield_yanzheng.frame)*60.0f/399.0f);
    [submit addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
    submit.titleLabel.font=[regular getFont:13.0f];
    [submit setBackgroundColor:_define_blue_color_login];
    [submit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if([_type1 isEqualToString:@"register"])
    {
        [submit setTitle:@"下  一  步" forState:UIControlStateNormal];
    }else
    {
        [submit setTitle:@"验   证" forState:UIControlStateNormal];
    }

    [submit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];


    [self.view addSubview:submit];

}
#pragma mark-选择国家编码
-(void)choose_countrycode:(UIButton *)btn
{
    UIImageView *back=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [self.view addSubview:back];
    back.userInteractionEnabled=YES;
    back.image=[UIImage imageNamed:@"蒙板"];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [back addGestureRecognizer:tap];
    back.tag=200;
    [self createscrollview];

}
-(void)createscrollview
{
    UIScrollView *_scr=[[UIScrollView alloc] initWithFrame:CGRectMake(50, 100, ScreenWidth-100, ScreenHeight-200)];
    [[self.view viewWithTag:200] addSubview:_scr];
    _scr.backgroundColor=[UIColor clearColor];

    JXLOG(@"%@",countrydict);
    JXLOG(@"%@",_arrayChar);
    JXLOG(@"111");
    CGFloat _y_p=0;
    for (int i=0; i<_arrayChar.count; i++) {
        NSArray *arr=[countrydict objectForKey:_arrayChar[i]];
        for (int j=0; j<arr.count; j++) {
            UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
            [_scr addSubview:btn];
            btn.frame=CGRectMake(0, _y_p, CGRectGetWidth(_scr.frame), 70*_Scale);
            [btn setBackgroundColor:_define_blue_color];
            [btn setTitle:[[NSString alloc] initWithFormat:@"+%@",[arr[j] objectForKey:@"code"]] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(setcitycode:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];

            _y_p+=70*_Scale;

            for (int z=0; z<2; z++) {
                UILabel *label=[[UILabel alloc] init];
                if(z==0)
                {

                    label.frame=CGRectMake(10, 0, 100, CGRectGetHeight(btn.frame));

                }else
                {
                    label.frame=CGRectMake(110, 0, CGRectGetWidth(btn.frame)-130, CGRectGetHeight(btn.frame));

                }

                [btn addSubview:label];
                label.textAlignment=z==0?0:2;
                label.textColor=[UIColor whiteColor];
                label.font=z==0?[regular getFont:14.0f]:[regular get_en_Font:14.0f];
                label.text=z==0?[arr[j] objectForKey:@"country"]:[[NSString alloc] initWithFormat:@"+%@",[arr[j] objectForKey:@"code"]];


            }

        }


    }
    _scr.contentSize=CGSizeMake(CGRectGetWidth(_scr.frame), _y_p);
}
-(void)setcitycode:(UIButton *)btn
{
    [_country_code_btn setTitle:btn.titleLabel.text forState:UIControlStateNormal];
    [[self.view viewWithTag:200] removeFromSuperview];
}
-(void)dismiss
{
    [[self.view viewWithTag:200] removeFromSuperview];
}

-(void)function
{
    _time--;

    [get_yanzheng setTitle:[[NSString alloc] initWithFormat:@"%lds",(long)_time] forState:UIControlStateSelected];
    if(!_time)
    {

        [timer invalidate];
        get_yanzheng.selected=NO;
        get_yanzheng.userInteractionEnabled=YES;
    }

}
-(BOOL) validatePhonenum:(NSString *)phonenum
{
    BOOL b=NO;
    for (int i=0; i<phonenum.length; i++) {
        char a=[phonenum characterAtIndex:i];
        if(a<='9'&&a>='0')
        {

        }else
        {
            b=NO;
            return b;
        }
    }
    return  b=YES;
}
-(void)yanzheng:(UIButton *)btn
{
    [regular dismissKeyborad];
    if([textfield_email.text isEqualToString:@""])
    {

        [[ToolManager sharedManager] alertTitle_Simple:@"请输入手机号"];
    }else  if([self validatePhonenum:textfield_email.text])
    {

//        [[ToolManager sharedManager] createProgress:@"发送中"];
        NSString *urltitle=nil;
        if([_type1 isEqualToString:@"register"])
        {
            urltitle=[[NSString alloc] initWithFormat:@"%@/v1/users/send_register_message",DNS];
        }else
        {

            urltitle=[[NSString alloc] initWithFormat:@"%@/v1/users/forget_password",DNS];
        }
        NSURL *url=[NSURL URLWithString:urltitle];

        NSMutableURLRequest *request=[[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
        [request setHTTPMethod:@"POST"];
        NSMutableString *str=[[NSMutableString alloc ] initWithString: @"cell="];

        [str appendString:textfield_email.text];

       [str appendFormat:@"&cell_code=%@",_country_code_btn.titleLabel.text];



        NSData *data=[str dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:data];

        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        //    进行网络请求（AF框架）
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *html = operation.responseString;
            NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
            //        进行解析以后的操作
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];

            if([[dict objectForKey:@"code"] intValue]==1)
            {
                yanzhengma=YES;

                [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"验证码已发送" WithImg:@"Prompt_验证码发送蓝色" Withtype:2]];
                _time=60;
                btn.selected=YES;
                btn.userInteractionEnabled=NO;
                //开启定时器
                timer =  [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(function) userInfo:nil repeats:YES];
                [timer fire];
                //每1秒运行一次function方法。

            }else
            {
                [[ToolManager sharedManager] alertTitle_Simple:[dict objectForKey:@"message"]];
            }

            [[ToolManager sharedManager] removeProgress];
        }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            //        下载失败时，打印错误信息
//            JXLOG(@"发生错误！%@",error);
            [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错蓝色" Withtype:2]];

            [[ToolManager sharedManager] removeProgress];
        }];
        
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        [queue addOperation:operation];
    }else
    {
        [self presentViewController:[regular alertTitle_Simple:@"请输入正确格式的手机号"] animated:YES completion:nil];
    }


}
-(void)backAction:(UIButton *)btn
{
    self.block();
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];


}

-(void)submit:(UIButton *)btn
{

    [regular dismissKeyborad];

    if(![self validatePhonenum:textfield_email.text])
    {
        [[ToolManager sharedManager]alertTitle_Simple:@"请输入正确格式的手机号"];
    }else if([textfield_yanzheng.text isEqualToString:@""])
    {
        [[ToolManager sharedManager]alertTitle_Simple:@"请输入验证码"];
    }else if([textfield_email.text isEqualToString:@""])
    {
        [[ToolManager sharedManager]alertTitle_Simple:@"请输入手机号"];
    }
    else
    {
        NSString *urltitle=nil;
        if([_type1 isEqualToString:@"register"])
        {
            urltitle=[[NSString alloc] initWithFormat:@"%@/v1/users/verify_code",DNS];

        }else
        {
            urltitle=[[NSString alloc] initWithFormat:@"%@/v1/users/update_password",DNS];
        }

//        [regular createProgress:@"验证中"];
        NSURL *url=[NSURL URLWithString:urltitle];
        NSMutableURLRequest *request=[[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
        [request setHTTPMethod:@"POST"];
        NSMutableString *str=[[NSMutableString alloc ] initWithString: @"cell="];
        [str appendFormat:@"%@",textfield_email.text];
        if(yanzhengma)
        {
            [str appendFormat:@"&code=%@",textfield_yanzheng.text];
        }

        [str appendFormat:@"&cell_code=%@",_country_code_btn.titleLabel.text];


        NSData *data=[str dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:data];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        //    进行网络请求（AF框架）
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *html = operation.responseString;
            NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
            //        进行解析以后的操作
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            if([[dict objectForKey:@"code"] intValue]==1)
            {
                //跳转到输入重置密码界面
                [regular removeProgress];

                if([_type1 isEqualToString:@"register"])
                {
                    RegisterController  *_register=[[RegisterController alloc] init];
                    _register.dict=[[NSDictionary alloc] initWithObjectsAndKeys:textfield_email.text,@"tel",textfield_yanzheng.text,@"code",_country_code_btn.titleLabel.text,@"cell_code",nil];

                    _register.block=registerBlock;
                    _register.block2=registerBlock2;

                    [self presentModalViewController:_register animated:YES];
                }else
                {
                    resetPasswordViewController *ctn=[[resetPasswordViewController alloc] init];
                    ctn.dict=[[NSDictionary alloc] initWithObjectsAndKeys:textfield_email.text,@"tel",textfield_yanzheng.text,@"code", nil];
                    ctn.block2=registerBlock2;
                    ctn.block=registerBlock;
                   [self presentModalViewController:ctn animated:YES];
                }
            }else
            {
                [regular removeProgress];
                [[ToolManager sharedManager] alertTitle_Simple:[dict objectForKey:@"message"]];
            }


        }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            //        下载失败时，打印错误信息
            [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错蓝色" Withtype:2]];
            [regular removeProgress];

        }];

        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        [queue addOperation:operation];

    }



//    }

}

-(void)login_praise:(NSData *)data
{
    [regular removeProgress];
    NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSString *str1=[dict objectForKey:@"state"];
    if([str1 isEqualToString:@"0"])
    {
//        [regular createSuccessProgress];

    }
    else if([str1 isEqualToString:@"1"])
    {
        [self presentViewController:[regular alertTitle_Simple:@"邮箱格式错误"] animated:YES completion:nil];

    }
    else if([str1 isEqualToString:@"2"])
    {
        [self presentViewController:[regular alertTitle_Simple:@"邮箱未使用"] animated:YES completion:nil];
    }
    else
    {
        [self presentViewController:[regular alertTitle_Simple:@"请求次数过多，请24小时后再次尝试"] animated:YES completion:nil];
    }

}
//email格式验证函数
- (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:candidate];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"RetrievePasswordController"];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"RetrievePasswordController"];
}
#pragma mark-return后隐藏键盘
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];
    return YES;
}
#pragma mark-touch开始时调用
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //    收回键盘
    [regular dismissKeyborad];
}



@end
