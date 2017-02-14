//
//  LoginViewController.m
//  OneBox
//
//  Created by 谢江新 on 15-2-4.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//
#import "chooseForgetViewController.h"
#import "chooseRegisterViewController.h"

#import "GeTuiSdk.h"
#import "KVNProgress.h"
#import "MyMD5.h"
#import "LoginViewController.h"
#import "RegisterController.h"
#import "RetrievePasswordController.h"
#import <CommonCrypto/CommonDigest.h>

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>

#define lightColor [UIColor colorWithRed:79.0f/255.0f green:190.0f/255.0f blue:221.0f/255.0f alpha:0.8]
#define darkColor [UIColor colorWithRed:66.0f/255.0f green:162.0f/255.0f blue:189.0f/255.0f alpha:0.8]
#define Color_t [UIColor colorWithRed:102.0f/255.0f green:203.0f/255.0f blue:233.0f/255.0f alpha:0.8]
#define Color_tp [UIColor colorWithRed:170.0f/255.0f green:230.0f/255.0f blue:245.0f/255.0f alpha:1]
#define Color_o [UIColor colorWithRed:172.0f/255.0f green:230.0f/255.0f blue:245.0f/255.0f alpha:1]
@interface LoginViewController ()<UITextFieldDelegate>

@end

@implementation LoginViewController
{

    NSArray *ohterimagename;
    UIImageView *backgroundImg;
    UIButton *login;
    UIButton *forgetPsw;
    UIButton *register_btn;

    //用户名
    UITextField *username;
    //密码
    UITextField *password;


}

- (void)viewDidLoad {
    [super viewDidLoad];

    //    UI布局
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
    registerBlock=^()
    {
        [self dismissModalViewControllerAnimated:YES];
    };
    resetpasswordBlock=^()
    {
        [self dismissModalViewControllerAnimated:YES];
    };

}
-(void)showpassword:(UIButton *)btn
{
    if(btn.selected)
    {
        btn.selected=NO;
        password.secureTextEntry=YES;
    }else
    {
        btn.selected=YES;
        password.secureTextEntry=NO;
    }


}
-(void)UIConfig
{
    //    给导航栏添加标题
   // self.view.backgroundColor=[UIColor colorWithRed:86.0f/255.0f green:190.0f/255.0f blue:215.0f/255.0f alpha:1];

    UIButton *back_btn=[UIButton buttonWithType:UIButtonTypeCustom];
    back_btn.frame=CGRectMake(ScreenWidth-(25+35)*_Scale, 40*_Scale,50*_Scale, 50*_Scale);
    UIImageView *imageqqq=[[UIImageView alloc] initWithFrame:CGRectMake(0, (CGRectGetWidth(back_btn.frame))/4.0f, (CGRectGetWidth(back_btn.frame))/2.0f, (CGRectGetWidth(back_btn.frame))/2.0f)];
    imageqqq.image=[UIImage imageNamed:@"login_返回"];
    [back_btn addSubview:imageqqq];

    [back_btn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back_btn];

    CGFloat _start_y=0;
    if(_isPad)
    {
        _start_y=(ScreenHeight/2)-80*_Scale;

    }else
    {
        _start_y=(ScreenHeight/2)-180*_Scale;
    }
    password=[[UITextField alloc] initWithFrame:CGRectMake((ScreenWidth/2)-200*_Scale, _start_y, 400*_Scale, 70*_Scale)];
//    password.backgroundColor=[UIColor whiteColor];
    password.placeholder=@" 密 码 ";
    password.returnKeyType=UIReturnKeyDone;
    [password setValue:Color_tp forKeyPath:@"_placeholderLabel.textColor"];
    [password setValue:[UIFont boldSystemFontOfSize:12] forKeyPath:@"_placeholderLabel.font"];
//    password.backgroundColor=[UIColor colorWithRed:1 green:1 blue:1 alpha:0.2];

    password.delegate=self;
    password.font=[regular getFont:12.0f];
    password.textColor=[UIColor whiteColor];
    //    保密输入
    password.secureTextEntry=YES;
    password.delegate=self;
    password.clearButtonMode=UITextFieldViewModeWhileEditing;
    UIView *dibu1=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(password.frame)-10*_Scale, CGRectGetWidth(password.frame), 2*_Scale)];
    dibu1.backgroundColor=[UIColor colorWithRed:1 green:1 blue:1 alpha:0.2];
    [password addSubview:dibu1];

//login_显示密码( 未选择)
//login_显示密码
    UIButton *view_left=[UIButton buttonWithType:UIButtonTypeCustom];
    view_left.frame=CGRectMake(0, 0, 70*_Scale, CGRectGetHeight(password.frame));
    [view_left setImage:[UIImage imageNamed:@"login_显示密码( 未选择)"] forState:UIControlStateNormal];
    [view_left setImage:[UIImage imageNamed:@"login_显示密码"] forState:UIControlStateSelected];
    [view_left setImageEdgeInsets:UIEdgeInsetsMake((CGRectGetHeight(view_left.frame)-22*_Scale)/2.0f, (CGRectGetWidth(view_left.frame)-60*_Scale)/2.0f, (CGRectGetHeight(view_left.frame)-22*_Scale)/2.0f, (CGRectGetWidth(view_left.frame)-60*_Scale)/2.0f)];

    [view_left addTarget:self action:@selector(showpassword:) forControlEvents:UIControlEventTouchUpInside];
    password.rightView=view_left;
    password.rightViewMode = UITextFieldViewModeAlways;

    [self.view addSubview:password];

    username=[[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(password.frame), CGRectGetMinY(password.frame)-8*_Scale-CGRectGetHeight(password.frame), CGRectGetWidth(password.frame), CGRectGetHeight(password.frame))];

    username.textColor=[UIColor whiteColor];
    username.placeholder=@" 手 机 号 或 邮 箱 ";
    [username setValue:Color_tp forKeyPath:@"_placeholderLabel.textColor"];
    [username setValue:[UIFont boldSystemFontOfSize:12] forKeyPath:@"_placeholderLabel.font"];
    username.font=[regular getFont:12.0f];
    username.delegate=self;
    username.clearButtonMode=UITextFieldViewModeWhileEditing;
    [self.view addSubview:username];

    UIView *dibu2=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(username.frame)-10*_Scale, CGRectGetWidth(username.frame), 2*_Scale)];
    dibu2.backgroundColor=[UIColor colorWithRed:1 green:1 blue:1 alpha:0.2];
    [username addSubview:dibu2];

        //    留美盒子icon
    UIImageView *icon=[[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth/2)-70*_Scale, 95*_Scale, 140*_Scale, 136*_Scale)];
    icon.image=[UIImage imageNamed:@"login_ICON11"];

    [self.view addSubview:icon];


    //    修改btn的frame
    login=[UIButton buttonWithType:UIButtonTypeCustom];
    [login setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];


    [login setBackgroundColor:_define_blue_color_login];
    login.titleLabel.font=[regular getFont:15.0f];
    [login setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [login setTitle:@"登   录" forState:UIControlStateNormal];
    [login addTarget:self action:@selector(sumbit_action:) forControlEvents:UIControlEventTouchUpInside];
    login.frame=CGRectMake(CGRectGetMinX(password.frame), CGRectGetMaxY(password.frame)+45*_Scale,CGRectGetWidth(password.frame), (50*_Scale*CGRectGetWidth(password.frame))/(330*_Scale));

    [self.view addSubview:login];


    forgetPsw=[UIButton buttonWithType:UIButtonTypeCustom];
    [forgetPsw setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    170 230 245
    [forgetPsw setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [forgetPsw.titleLabel setAttributedText:[regular createAttributeString:@"忘记密码?" andFloat:@(2.0)]];

    forgetPsw.titleLabel.font=[regular getFont:10.0f];
    [forgetPsw addTarget:self action:@selector(forget_password_action:) forControlEvents:UIControlEventTouchUpInside];
    forgetPsw.frame=CGRectMake(CGRectGetMinX(password.frame), CGRectGetMaxY(login.frame)+10*_Scale, 180*_Scale, 42*_Scale);
    forgetPsw.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    //    forgetPsw.backgroundColor=[UIColor redColor];
    [self.view addSubview:forgetPsw];
    register_btn=[UIButton buttonWithType:UIButtonTypeCustom];
    //    [register_btn setBackgroundColor:darkColor];
    [register_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [register_btn setTitle:@"没有账号?" forState:UIControlStateNormal];

    [register_btn.titleLabel setAttributedText:[regular createAttributeString:@"没有账号?" andFloat:@(2.0)]];

    register_btn.titleLabel.font=[regular getFont:10.0f];
    [register_btn addTarget:self action:@selector(register_action:) forControlEvents:UIControlEventTouchUpInside];
    register_btn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
    register_btn.frame=CGRectMake(CGRectGetMaxX(password.frame)-CGRectGetWidth(forgetPsw.frame), CGRectGetMinY(forgetPsw.frame), CGRectGetWidth(forgetPsw.frame), CGRectGetHeight(forgetPsw.frame));
    [self.view addSubview:register_btn];


    BOOL app1 = [ShareSDK isClientInstalled:SSDKPlatformSubTypeWechatSession];
    if(app1)
    {
        ohterimagename=@[@"login_微博",@"login_wechat",@"login_QQ"];
    }else
    {
        ohterimagename=@[@"login_微博",@"login_QQ"];

    }

    for (int i=0; i<ohterimagename.count; i++) {

        UIButton *btn_other=[UIButton buttonWithType:UIButtonTypeCustom];
        //        110
        btn_other.tag=100+i;
        [btn_other  addTarget:self action:@selector(otheraction:) forControlEvents:UIControlEventTouchUpInside];
        if(ohterimagename.count==2)
        {
            btn_other.frame=CGRectMake(CGRectGetMinX(login.frame)+16*_Scale+i*(CGRectGetWidth(login.frame)-80*_Scale-32*_Scale), CGRectGetMaxY(login.frame)+75*_Scale, 80*_Scale, 80*_Scale);

        }else
        {
            CGFloat _jiange=(CGRectGetWidth(login.frame)-80*_Scale*3-16*_Scale*2)/2.0f;
            btn_other.frame=CGRectMake(CGRectGetMinX(login.frame)+16*_Scale+i*(_jiange+80*_Scale), CGRectGetMaxY(login.frame)+75*_Scale, 80*_Scale, 80*_Scale);
        }

        NSString *imagetitle=ohterimagename[i];
        [btn_other setBackgroundImage:[UIImage imageNamed:imagetitle] forState:UIControlStateNormal];
        [self.view addSubview:btn_other];
    }
}
-(void)backAction:(UIButton *)btn
{
    if([self.type isEqualToString:@"userinfo"])
    {

        [[NSNotificationCenter defaultCenter] postNotificationName:@"xiaoshi" object:@"userinfo"];
    }else if([self.type isEqualToString:@"chat"])
    {

        [[NSNotificationCenter defaultCenter] postNotificationName:@"xiaoshi" object:@"chat"];

    }else
    {

        [[NSNotificationCenter defaultCenter] postNotificationName:@"xiaoshi" object:@"other"];

    }
}
-(void)otheraction:(UIButton*)btn
{

    if(ohterimagename.count==2)
    {
        if(btn.tag-100==0)
        {
            //        WEIBO
            [self reloadStateWithType:SSDKPlatformTypeSinaWeibo];
        }else
        {
            //        QQ
            [self reloadStateWithType:SSDKPlatformSubTypeQZone];
        }

    }else if(ohterimagename.count==3)
    {
        if(btn.tag-100==0)
        {
            //        WEIBO
            [self reloadStateWithType:SSDKPlatformTypeSinaWeibo];

        }else if(btn.tag-100==1)
        {
            //        wechat
            [self reloadStateWithType:SSDKPlatformTypeWechat];
            
        }else if(btn.tag-100==2)
        {
            //        QQ

            [self reloadStateWithType:SSDKPlatformSubTypeQZone];
        }
    }


}

- (void)reloadStateWithType:(SSDKPlatformType)type{
    //现实授权信息，包括授权ID、授权有效期等。
    //此处可以在用户进入应用的时候直接调用，如授权信息不为空且不过期可帮用户自动实现登录。
    [ShareSDK cancelAuthorize:type];
    [ShareSDK getUserInfo:type onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
        if (state == SSDKResponseStateSuccess)
        {
            [regular createProgress:@"登录中"];
            
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            NSString *url=nil;
            NSDictionary *parameters=nil;
            if(type==SSDKPlatformSubTypeQZone)
            {
                url=@"/v3/users/qq_connect/callback";
            }else if(type==SSDKPlatformTypeSinaWeibo)
            {
                url=@"/v3/users/weibo/callback";
                
            }if(type==SSDKPlatformTypeWechat)
            {
                url=@"/v3/users/weixin/callback";
                
            }
            
            parameters=@{@"userinfo":user.rawData,@"uid": user.uid};
            
            [manager POST:[[NSString alloc] initWithFormat:@"%@%@",DNS,url] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)  {
                
                NSString *html = operation.responseString;
                NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
                
                [[ToolManager sharedManager] removeProgress];
                if([[dict objectForKey:@"code"] integerValue]==1)
                {
                    
                    if(type==SSDKPlatformTypeSinaWeibo||type==SSDKPlatformTypeWechat)
                    {
                        [self login_success:dict];
                    }else if(type==SSDKPlatformSubTypeQZone)
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
                        
                        NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
                        if([defaults objectForKey:@"users"]==nil)
                        {
                            [defaults setObject:[[NSMutableArray alloc] init] forKey:@"users"];
                        }
                        
                        [defaults setObject:[[dict objectForKey:@"data"] objectForKey:@"ease_mob_username"] forKey:@"chatname"];
                        [defaults setObject:[[dict objectForKey:@"data"] objectForKey:@"ease_mob_password"] forKey:@"chatpassword"];
                        
                        //将islogin存入defaults中
                        NSDictionary *_dict=[dict objectForKey:@"data"];
                        
                        [defaults setObject:@"0" forKey:@"hangban"];
                        [defaults setObject:@"0" forKey:@"mianqian"];
                        
                        NSNumber *islogin=[[NSNumber alloc]initWithInt:1];
                        [defaults setObject:islogin forKey:@"islogin"];
                        //将username存入defaults中
                        [defaults setObject:username.text forKey:@"tel"];
                        [defaults setObject:[_dict objectForKey:@"username"] forKey:@"username"];
                        [defaults setObject:[_dict objectForKey:@"token"] forKey:@"token"];
                        [defaults setObject:[_dict objectForKey:@"is_auth"] forKey:@"is_auth"];
                        //将password存入defaults中
                        [defaults setObject:password.text forKey:@"password"];
                        //将uid存入defaults中
                        [defaults setObject:[_dict objectForKey:@"id"] forKey:@"uid"];
                        //取出头像对应的路径
                        NSString *imageurl=[[dict objectForKey:@"data"] objectForKey:@"avatar"];
                        
                        
                        NSString *_image_type=nil;
                        NSString *_image_url=nil;
                        if([imageurl isEqualToString:@"0"])
                        {
                            //当用户还未上传头像时
                            //将系统默认的头像（成功登录并未上传头像）,转换成nsdata类型的对象，并将该对象保存defaults中
                            NSData *imageData1 =UIImagePNGRepresentation([UIImage imageNamed:@"headImg_login1"]);
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
                        
                        //    保存后隐藏进度条
                        
                        [self getui];
                        
                        [regular removeProgress];
                        [self.navigationController setNavigationBarHidden:NO animated:NO];
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateImg" object:nil];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"reload" object:nil];
#pragma mark-发通知刷新发现美校
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeFound" object:nil];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"getnotification" object:nil];
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"getmessage" object:nil];
                        if([self.type isEqualToString:@"userinfo"])
                        {
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshList" object:nil];
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"backlogin" object:nil];
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"other" object:nil];
                            
                        }else if([self.type isEqualToString:@"chat"])
                        {
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshList" object:nil];
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"backlogin" object:nil];
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"other" object:nil];
                            
                        }else if ([self.type isEqualToString:@"other"])
                        {
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshList" object:nil];
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"backlogin" object:nil];
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"other" object:nil];
                        }
                        
                    }
                }else
                {
                    [[ToolManager sharedManager] alertTitle_Simple:[dict objectForKey:@"message"]];
                    [[ToolManager sharedManager] removeProgress];
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错蓝色" Withtype:2]];
                [regular removeProgress];
            }];
        }
        else
        {
            if(error)
            {
                //                                   [self presentViewController:[regular alertTitle_Simple:NSLocalizedString(error.description, @"")] animated:YES completion:nil];
                //                 NSLog(@"分享失败,错误码:%ld,错误描述:%@", (long)[error errorCode], [error errorDescription]);
            }
        }
    }];
}

#pragma mark-return后隐藏键盘
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if(theTextField==password)
    {

        [self sumbit_action:[UIButton new]];
    }
    [theTextField resignFirstResponder];
    return YES;
}

#pragma  mark-登录
-(void)sumbit_action:(UIButton *)btn
{

    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    //    post前进行判断，用户名、密码格式是否正确
    if([username.text isEqualToString:@""]||[password.text isEqualToString:@""])
    {
        //    账号密码中有空值时
        [regular alertTitle_Simple:@"账号或者密码不能为空"];
    }else if ([password.text length]<6||[password.text length]>16)
    {
        [regular alertTitle_Simple:@"密码长度为6到16位之间"];
    }else
    {
        if([self validateEmail:username.text])
        {
            //        判断是否为邮箱
            [self loginAction:@"email"];

        }else if([self validatePhonenum:username.text])
        {
            //        判断是否为手机格式
            [self loginAction:@"cell"];
        }else
        {
            [[ToolManager sharedManager] alertTitle_Simple:@"请输入正确格式"];
        }
        //    初步格式判断正确后，进行后台交互
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
//email格式验证函数
- (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:candidate];
}

-(void)loginAction:(NSString *)key
{


    //  创建进度条，并给标题

    [regular createProgress:@"登录中"];

    //    判断格式是否正确
    //    请求url
    NSString *str=[NSString stringWithFormat:@"%@/v1/users/login",DNS];
    NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    //    创建可变request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5];
    //    设定请求类型未post
    [request setHTTPMethod:@"POST"];
    //    创建包体
    NSString *bodyStr=[[NSString alloc] initWithFormat:@"%@=%@&password=%@",key,username.text,password.text];
    //    加入包体
    request.HTTPBody=[bodyStr dataUsingEncoding:NSUTF8StringEncoding];

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];

    //    进行网络请求（AF框架）
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [regular removeProgress];
        NSString *html = operation.responseString;
        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
        if([[dict objectForKey:@"code"] integerValue]==1)
        {
            NSString *html = operation.responseString;
            NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
            //        进行解析以后的操作
            [self login_praise:data];
        }else
        {
            [[ToolManager sharedManager] alertTitle_Simple:[dict objectForKey:@"message"]];
        }

    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错蓝色" Withtype:2]];

        [regular removeProgress];
    }];

    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];

}
-(void)login_praise:(NSData *)data
{

    //    json解析
    NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
    //    获取返回的dict中的state的值
    //    0:成功
    //    1:账号或者密码不能为空
    //    2:账号或者密码错误
    //    3:账号不存在
    int state=[[dict objectForKey:@"code"] intValue];

    if(state == 1)
    {
        //        登陆成功
        //        登陆成功调用的方法

        [self login_success:dict];

    }
    else
    {
        [[ToolManager sharedManager] alertTitle_Simple:[dict objectForKey:@"message"]];
        [regular removeProgress];
    }
}

-(void)login_success:(NSDictionary *)dict
{
    //将username、password、islogin、uid、userImage保存进NSUserDefaults
    //取出沙盒中的NSUserDefaults

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

    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    //将islogin存入defaults中
    NSDictionary *_dict=[dict objectForKey:@"data"];
    if([defaults objectForKey:@"users"]==nil)
    {
        [defaults setObject:[[NSMutableArray alloc] init] forKey:@"users"];
    }

    [defaults setObject:[[dict objectForKey:@"data"] objectForKey:@"ease_mob_username"] forKey:@"chatname"];
    [defaults setObject:[[dict objectForKey:@"data"] objectForKey:@"ease_mob_password"] forKey:@"chatpassword"];
    NSNumber *islogin=[[NSNumber alloc]initWithInt:1];
    [defaults setObject:islogin forKey:@"islogin"];
    //将username存入defaults中
     [defaults setObject:username.text forKey:@"tel"];
    [defaults setObject:[_dict objectForKey:@"username"] forKey:@"username"];
    [defaults setObject:[_dict objectForKey:@"token"] forKey:@"token"];
    [defaults setObject:[_dict objectForKey:@"is_auth"] forKey:@"is_auth"];
    //将password存入defaults中
    [defaults setObject:password.text forKey:@"password"];
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
        NSData *imageData1 =UIImagePNGRepresentation([UIImage imageNamed:@"headImg_login1"]);
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
   
    //    保存后隐藏进度条
    [regular removeProgress];
    [self getui];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    NSString * _deviceToken=[[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
//    [[ToolManager sharedManager] alertTitle_Simple:_deviceToken];
    if(_deviceToken!=nil)
    {
        [GeTuiSdk registerDeviceToken:_deviceToken];

        NSUserDefaults *dict=[NSUserDefaults standardUserDefaults];

        NSString *clientId = [GeTuiSdk clientId];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

        NSString *_token=nil;
        if([dict objectForKey:@"islogin"]!=[NSNull null])
        {

            if([[dict objectForKey:@"islogin"] integerValue]!=0)
            {

                if([dict objectForKey:@"token"]==nil)
                {

                    _token=@"";
                }else
                {
                    _token=[dict objectForKey:@"token"];
                }

            }else
            {
                _token=@"";
            }

        }else
        {
            _token=@"";
        }
        //    NSString *_token=[dict objectForKey:@"token"];
        if(clientId!=nil)
        {
            //        [[ToolManager sharedManager] alertTitle_Simple:[dict objectForKey:@"clientId!=nil"]];
            NSDictionary *parameters=@{@"token":_token,@"uuid":clientId,@"device_type":@"1"};
//            [[ToolManager sharedManager] alertTitle_Simple:[[NSString alloc] initWithFormat:@"%@",parameters]];
            [manager POST:[[NSString alloc] initWithFormat:@"%@%@",DNS,@"/v1/users/getui_uuid"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {

                NSString *html = operation.responseString;
                NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];

                if([[dict objectForKey:@"code"] integerValue]==1)
                {
                    //                [[ToolManager sharedManager] alertTitle_Simple:@"发送cg"];
                    NSLog(@"111");
                }else
                {
                    [[ToolManager sharedManager] alertTitle_Simple:[dict objectForKey:@"message"]];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错蓝色" Withtype:2]];
            }];
            
        }
        
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateImg" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"getnotification" object:nil];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"getmessage" object:nil];
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"reload" object:nil];
#pragma mark-发通知刷新发现美校
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeFound" object:nil];
    if([self.type isEqualToString:@"userinfo"])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshList" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"backlogin" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"other" object:nil];

    }else if([self.type isEqualToString:@"chat"])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshList" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"backlogin" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"other" object:nil];

    }else if ([self.type isEqualToString:@"other"])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshList" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"backlogin" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"other" object:nil];
    }



}
-(void)getui
{
    NSUserDefaults *dict=[NSUserDefaults standardUserDefaults];
    NSString *clientId = [dict objectForKey:@"clientId"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *_token=nil;


    if(clientId!=nil)
    {

        if([dict objectForKey:@"islogin"]!=[NSNull null])
        {

            if([[dict objectForKey:@"islogin"] integerValue]!=0)
            {
                _token=[dict objectForKey:@"token"];
            }else
            {
                _token=@"";
            }
            
        }else
        {
            _token=@"";
        }

        NSDictionary *parameters=@{@"token":_token,@"uuid":clientId,@"device_type":@"1"};

        [manager POST:[[NSString alloc] initWithFormat:@"%@%@",DNS,@"/v1/users/getui_uuid"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {

            NSString *html = operation.responseString;
            NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];

            if([[dict objectForKey:@"code"] integerValue]==1)
            {

            }else
            {
                [[ToolManager sharedManager] alertTitle_Simple:[dict objectForKey:@"message"]];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错蓝色" Withtype:2]];
        }];

    }

}
#pragma mark-注册
-(void)register_action:(UIButton *)btn
{
    chooseRegisterViewController *Register=[[chooseRegisterViewController alloc] init];
    Register.block=resetpasswordBlock;
    [self presentModalViewController:Register animated:YES];

//    RetrievePasswordController *ret=[[RetrievePasswordController alloc] init];
//    ret.type=self.type;
//    ret.type1=@"register";
//    ret.block=resetpasswordBlock;
//    [self presentModalViewController:ret animated:YES];


}
- (BOOL)isMobileNumber:(NSString *)mobileNum
{

    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10 * 中国移动：China Mobile
     11 * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12 */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15 * 中国联通：China Unicom
     16 * 130,131,132,152,155,156,185,186
     17 */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20 * 中国电信：China Telecom
     21 * 133,1349,153,180,189
     22 */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25 * 大陆地区固话及小灵通
     26 * 区号：010,020,021,022,023,024,025,027,028,029
     27 * 号码：七位或八位
     28 */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";

    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];

    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
    
}
- (BOOL)checkTel:(NSString *)str

{

    if ([str length] == 0) {

//        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请输入手机号" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];

//        [alert show];

        return NO;

    }

    //1[0-9]{10}

    //^((13[0-9])|(15[^4,\\D])|(18[0,5-9]))\\d{8}$

    //    NSString *regex = @"[0-9]{11}";

    NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$";

    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];

    BOOL isMatch = [pred evaluateWithObject:str];

    if (!isMatch) {

        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的手机号码" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];

        [alert show];
        
        return NO;
        
    }
    
    return YES;
    
}

#pragma mark-忘记密码
-(void)forget_password_action:(UIButton *)btn
{
    chooseForgetViewController *forget=[[chooseForgetViewController alloc] init];
    forget.block=resetpasswordBlock;
    [self presentModalViewController:forget animated:YES];
}

#pragma mark-touch开始时调用
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //    收回键盘
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"LoginViewController"];

    [[CustomTabbarController sharedManager] tabbarHide];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
-(void)viewWillDisappear:(BOOL)animated
{

    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"LoginViewController"];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}
- (void)applicationDidEnterBackground:(UIApplication *)application
{

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
