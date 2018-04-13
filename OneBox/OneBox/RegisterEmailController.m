//
//  RegisterController.m
//  OneBox
//
//  Created by 谢江新 on 15-2-5.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import "RegisterEmailController.h"

#import <GTSDK/GeTuiSdk.h>
#import "MyMD5.h"

#import "webViewController.h"

#define Color_tp [UIColor colorWithRed:170.0f/255.0f green:230.0f/255.0f blue:245.0f/255.0f alpha:1]

@interface RegisterEmailController ()<UITextFieldDelegate,UIAlertViewDelegate>
{
    NSMutableArray *chooseArray ;
    UITextField *textfield_email;
    UITextField *textfield_nickname;
    UITextField *textfield_password;
    UITextField *textfield_makeSurePassword;
    UITextField *textfield_yanzhengma;
    UIButton *showpass_btn;
    UIImageView *showimg;

//获取验证码
//    UIButton *getYanz;
//    提交
    UIButton *submit;

    UIButton *get_yanzheng;
    NSInteger _time;
    NSTimer *timer;
    BOOL yanzhengma;
    NSMutableString *remainTime;
    UIImageView *backgroundImg;
}

@end

@implementation RegisterEmailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    yanzhengma=NO;
    _time=60;
    textfield_email=[[UITextField alloc] init];
    textfield_makeSurePassword=[[UITextField alloc] init];
    textfield_nickname=[[UITextField alloc] init];
    textfield_password=[[UITextField alloc] init];
    textfield_yanzhengma=[[UITextField alloc] init];
    UIBarButtonItem *_btn=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回箭头"] style:UIBarButtonItemStylePlain target:self action:@selector(popviewAction)];
    self.navigationItem.leftBarButtonItem=_btn;
    
    [self UIConfig];

    disblock=^()
    {
        [self dismissModalViewControllerAnimated:YES];
    };
}
-(void)popviewAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)UIConfig
{
    backgroundImg=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    if(_isPad)
    {
        backgroundImg.backgroundColor=_define_login_background;

    }else
    {
        backgroundImg.image=[UIImage imageNamed:@"login_背景层"];
    }
    [self.view addSubview:backgroundImg];
    

    //    给导航栏添加标题
    self.navigationItem.titleView=[regular returnNavView:@"注册"  withmaxwidth:230];
    
    UIButton *back_btn=[UIButton getCustomImgBtnWithImageStr:@"login_返回" WithSelectedImageStr:nil];
    [self.view addSubview:back_btn];
    [back_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(50*_Scale);
        make.top.mas_equalTo(self.mas_topLayoutGuideBottom).with.offset(20*_Scale);
        make.right.mas_equalTo(-55*_Scale);
    }];
    [back_btn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    back_btn.imageEdgeInsets = UIEdgeInsetsMake(12.5*_Scale, 12.5*_Scale, 12.5*_Scale, 12.5*_Scale);


    NSArray *titlearr=@[@"昵 称",@"邮 箱",@"密 码"];
    CGFloat _y_p=244*_Scale;
    CGFloat _height=50*_Scale;

    for (int i=0; i<titlearr.count; i++) {

        UITextField *textfield=i==0?textfield_nickname:i==1?textfield_email:textfield_password;
        CGRect _rect;

        _rect=CGRectMake((ScreenWidth-400*_Scale)/2.0f, _y_p+(_height+15*_Scale)*i, 400*_Scale,_height);

        textfield.frame=_rect;
        textfield.placeholder=titlearr[i];

        UIView *dibu=[[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(textfield.frame), CGRectGetMaxY(textfield.frame)-10*_Scale, 400*_Scale, 2*_Scale)];
        dibu.backgroundColor=[UIColor colorWithRed:1 green:1 blue:1 alpha:0.2];
        [self.view addSubview:dibu];

        textfield.font=[regular get_en_Font:12.0f];
        textfield.textColor=[UIColor whiteColor];

        [self.view addSubview:textfield];
        [textfield setValue:Color_tp forKeyPath:@"_placeholderLabel.textColor"];
        [textfield setValue:[regular get_en_Font:12.0f] forKeyPath:@"_placeholderLabel.font"];
        textfield.font=[regular get_en_Font:12.0f];
        textfield.textAlignment=0;
        if(i==2)
        {
            textfield.secureTextEntry=YES;
            showpass_btn=[UIButton buttonWithType:UIButtonTypeCustom];
            showpass_btn.frame=CGRectMake(CGRectGetMaxX(textfield.frame)-120*_Scale, CGRectGetMinY(textfield.frame), 120*_Scale, CGRectGetHeight(textfield.frame));
            [showpass_btn addTarget:self action:@selector(showpassAction:) forControlEvents:UIControlEventTouchUpInside];

            [showpass_btn setImage:[UIImage imageNamed:@"login_显示密码( 未选择)"] forState:UIControlStateNormal];
            [showpass_btn setImage:[UIImage imageNamed:@"login_显示密码"] forState:UIControlStateSelected];
            [showpass_btn setImageEdgeInsets:UIEdgeInsetsMake((CGRectGetHeight(showpass_btn.frame)-47*_Scale)/2.0f, 60*_Scale, (CGRectGetHeight(showpass_btn.frame)-47*_Scale)/2.0f, 0)];

            [self.view addSubview:showpass_btn];

        }


    }
    submit=[UIButton buttonWithType:UIButtonTypeCustom];
    submit.frame=CGRectMake((ScreenWidth-400*_Scale)/2,CGRectGetMaxY(textfield_password.frame)+50*_Scale, 400*_Scale, (400*_Scale*60.0f)/390.0f);
    [submit setBackgroundColor:[UIColor colorWithRed:130.0f/255.0f green:211.0f/255.0f blue:236.0f/255.0f alpha:1]];
    [submit setTitle:@"注   册" forState:UIControlStateNormal];

    submit.titleLabel.font=[regular getFont:13.0f];

    [submit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submit addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:submit];


    UIView *yinsi=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(submit.frame)+25*_Scale, ScreenWidth, 50*_Scale)];
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(yinsi.frame), CGRectGetHeight(yinsi.frame))];

    UIView *view1=[[UIView alloc] init];
    if(_isPad)
    {
        view1.frame=CGRectMake(ScreenWidth/2.0f-10, 0, 42.5, CGRectGetHeight(yinsi.frame));

    }else
    {
        view1.frame=CGRectMake(148.5, 0, 42.5, CGRectGetHeight(yinsi.frame));
        
    }
//        view1.backgroundColor=[UIColor redColor];
    UITapGestureRecognizer *tap1=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(yinsi:)];
    [view1 addGestureRecognizer:tap1];
    [yinsi addSubview:view1];
    UIView *view11=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(view1.frame)-4, CGRectGetWidth(view1.frame), 1)];
    view11.backgroundColor=[UIColor whiteColor];
    [view1 addSubview:view11];

    UIView *view2=[[UIView alloc] init];
    if(_isPad)
    {
        view2.frame=CGRectMake(ScreenWidth/2.0f+45.5, 0, 42.5, CGRectGetHeight(yinsi.frame));

    }else
    {
        view2.frame=CGRectMake(204, 0, 42.5, CGRectGetHeight(yinsi.frame));

    }
//    view2.backgroundColor=[UIColor yellowColor];
    UITapGestureRecognizer *tap2=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(xieyi:)];
    [view2 addGestureRecognizer:tap2];
    [yinsi addSubview:view2];
    UIView *view22=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(view2.frame)-4, CGRectGetWidth(view2.frame), 1)];
    view22.backgroundColor=[UIColor whiteColor];
    [view2 addSubview:view22];

    label.textAlignment=1;
    label.textColor=[UIColor whiteColor];
    label.font=[regular getFont:9.0f];
    [label setAttributedText:[regular createAttributeString:@"注册即代表同意隐私条款及使用协议" andFloat:@(2.0)]];
    [yinsi addSubview:label];
    [self.view addSubview:yinsi];
}
-(void)showpassAction:(UIButton *)btn
{
    if(btn.selected)
    {
        textfield_password.secureTextEntry=YES;
        btn.selected=NO;
    }else
    {
        textfield_password.secureTextEntry=NO;
        btn.selected=YES;
    }

}

-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)xieyi:(UIGestureRecognizer *)ges
{
    webViewController *web=[[webViewController alloc] init];
    web.block=disblock;
    web.dict=[[NSDictionary alloc] initWithObjectsAndKeys:@"http://www.abroadbox.cn/?page_id=497",@"web",@"使用协议",@"title",@"help",@"type",nil];
    [self presentModalViewController:web animated:YES];
}
-(void)yinsi:(UIGestureRecognizer *)ges
{
    webViewController *web=[[webViewController alloc] init];
    web.block=disblock;
    web.dict=[[NSDictionary alloc] initWithObjectsAndKeys:@"http://www.abroadbox.cn/?page_id=499",@"web",@"隐私条款",@"title",@"privacy",@"type",nil];

    //    [self.navigationController pushViewController:web animated:YES];
    [self presentModalViewController:web animated:YES];
    
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
-(void)backAction:(UIButton *)btn
{

    self.block();

}

-(void)submitAction:(UIButton *)btn
{

    [regular dismissKeyborad];

    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:@" " delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];

    BOOL _isemail=YES;
    

    if(![self validateEmail:textfield_email.text])
    {
        _isemail=NO;
    }
    if(!_isemail)
    {
        [self presentViewController:[regular alertTitle_Simple:@"请输入正确格式的邮箱"] animated:YES completion:nil];

    }else  if([textfield_nickname.text isEqualToString:@""])
    {
        alertView.message=@"用户名不能为空";
        [alertView show];
    }
    else if([textfield_password.text length]<6||[textfield_password.text length]>16)
    {
        [self presentViewController:[regular alertTitle_Simple:@"密码长度为6到16位之间"] animated:YES completion:nil];
    }
    else
    {

        [[ToolManager sharedManager] createProgress:@"注册中..."];

        NSURL *url=[NSURL URLWithString:[[NSString alloc] initWithFormat:@"%@/v1/users/register",DNS]];

        NSMutableURLRequest *request=[[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
        [request setHTTPMethod:@"POST"];
        NSMutableString *str=[[NSMutableString alloc ] initWithString: @"username="];
        [str appendString:textfield_nickname.text];
        [str appendString:@"&password="];
        [str appendString:textfield_password.text];



        [str appendString:@"&email="];
        [str appendString: textfield_email.text];

        NSData *data=[str dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:data];
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        //    进行网络请求（AF框架）
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {

            NSString *html = operation.responseString;
            NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reload" object:nil];
                //        进行解析以后的操作
            [self login_praise:data];

        }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            //        下载失败时，打印错误信息
            JXLOG(@"发生错误！%@",error);
            [[ToolManager sharedManager] removeProgress];
        }];
        
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        [queue addOperation:operation];
        
        
    }
    

}

-(void)login_praise:(NSData *)data
{
    //    json解析
    NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
    NSInteger _code=[[dict objectForKey:@"code"] integerValue];
    if(_code==1)
    {
        BOOL isAutoLogin = [[EaseMob sharedInstance].chatManager isAutoLoginEnabled];
        if (!isAutoLogin) {
            [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:[[dict objectForKey:@"data"] objectForKey:@"ease_mob_username"] password:[[dict objectForKey:@"data"] objectForKey:@"ease_mob_password"]
                                                              completion:^(NSDictionary *loginInfo, EMError *error) {
                                                                  if (!error) {
                                                                      // 设置自动登录
                                                                      [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
                                                                  }


                                                              }onQueue:nil];
        }else
        {
            [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:[[dict objectForKey:@"data"] objectForKey:@"ease_mob_username"] password:[[dict objectForKey:@"data"] objectForKey:@"ease_mob_password"]
                                                              completion:^(NSDictionary *loginInfo, EMError *error) {
                                                                  if (!error) {
                                                                      // 设置自动登录
                                                                      [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
                                                                  }
                                                                  
                                                                  
                                                              }onQueue:nil];


        }

        [[ToolManager sharedManager] removeProgress];
#pragma mark-发通知刷新发现美校
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeFound" object:nil];
        
            //将username、password、islogin、uid、userImage保存进NSUserDefaults
            //取出沙盒中的NSUserDefaults
            NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
            //将islogin存入defaults中
            if([defaults objectForKey:@"users"]==nil)
            {
                [defaults setObject:[[NSMutableArray alloc] init] forKey:@"users"];
            }
            NSDictionary *_dict=[dict objectForKey:@"data"];
            NSNumber *islogin=[[NSNumber alloc]initWithInt:1];
            [defaults setObject:@"0" forKey:@"hangban"];
            [defaults setObject:@"0" forKey:@"mianqian"];
            [defaults setObject:[_dict objectForKey:@"ease_mob_username"] forKey:@"chatname"];
            [defaults setObject:[_dict objectForKey:@"ease_mob_password"] forKey:@"chatpassword"];
            [defaults setObject:islogin forKey:@"islogin"];
            //将username存入defaults中
            [defaults setObject:textfield_email.text forKey:@"tel"];
            [defaults setObject:[_dict objectForKey:@"username"] forKey:@"username"];
            [defaults setObject:[_dict objectForKey:@"token"] forKey:@"token"];
            [defaults setObject:[_dict objectForKey:@"is_auth"] forKey:@"is_auth"];
            //将password存入defaults中
            [defaults setObject:textfield_password.text forKey:@"password"];
            //将uid存入defaults中
            [defaults setObject:[_dict objectForKey:@"id"] forKey:@"uid"];
            //取出头像对应的路径
            NSString *imageurl=nil;
            if([_dict objectForKey:@"avatar"]==[NSNull null])
            {
                imageurl=@"0";
            }else
            {
                imageurl=[_dict objectForKey:@"avatar"];
            }

            NSString *_image_type=nil;
            NSString *_image_url=nil;
            if([imageurl isEqualToString:@"0"])
            {
                //当用户还未上传头像时
                //将系统默认的头像（成功登录并未上传头像）,转换成nsdata类型的对象，并将该对象保存defaults中
                NSData *imageData1 =UIImagePNGRepresentation([UIImage imageNamed:@"headImg_login1.png"]);
                //        UIImagePNGRepresentation[UIImage imageNamed:@"headImg_login1"];
                [defaults setObject:imageData1 forKey:@"userImage"];
                _image_type=@"0";
                _image_url=@"headImg_login1";

            }
            else
            {
                //当用户有上传头像时
                //创建头像的完整路径
                //        NSString *myURL=[NSString stringWithFormat:@"http://121.40.153.17/api/Public/User/%@",imageurl];
                //根据图片路径，下载图片，并保存defaults中（nsdata类型）
                [defaults setObject:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageurl]]forKey:@"userImage"];
                _image_type=@"1";
                _image_url=imageurl;
            }
            [defaults setObject:[[NSDictionary alloc] initWithObjectsAndKeys:_image_type,@"type",_image_url,@"image",nil] forKey:@"userImageurl"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateImg" object:nil];
            //    保存后隐藏进度条
            [[ToolManager sharedManager] removeProgress];

            [self.navigationController setNavigationBarHidden:NO animated:NO];
//            [[UIApplication sharedApplication] setStatusBarHidden:NO];
            //    返回上一级视图
            [self.navigationController popToRootViewControllerAnimated:YES];


            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshList" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"backlogin" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"other" object:nil];

            NSString * _deviceToken=[[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
//            [[ToolManager sharedManager] alertTitle_Simple:_deviceToken];
            if(_deviceToken!=nil)
            {
                [GeTuiSdk registerDeviceToken:_deviceToken];

                [regular registerGeTui];
                                
            }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getnotification" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getmessage" object:nil];


    }else
    {
        [[ToolManager sharedManager] removeProgress];
        
        UIAlertView *alertview=[regular alertTitle_Simple_OLD:[dict objectForKey:@"message"]];
        alertview.delegate=self;

    }

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0)
    {

        self.block2();
    }

}

//email格式验证函数
- (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:candidate];
}



#pragma mark-touch开始时调用
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //    收回键盘
    [regular dismissKeyborad];
}
#pragma mark-return后隐藏键盘
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"RegisterController"];

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"RegisterController"];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {

    [theTextField resignFirstResponder];
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
