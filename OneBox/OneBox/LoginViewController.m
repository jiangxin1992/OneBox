//
//  LoginViewController.m
//  OneBox
//
//  Created by 谢江新 on 15-2-4.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//
#import "LoginViewController.h"

#import <CommonCrypto/CommonDigest.h>
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>

#import "RegisterController.h"
#import "chooseForgetViewController.h"
#import "chooseRegisterViewController.h"
#import "RetrievePasswordController.h"
#import "CustomTabbarController.h"

#import "LoginTool.h"
#import <GTSDK/GeTuiSdk.h>
#import "KVNProgress.h"
#import "MyMD5.h"

#define Color_placeholder [UIColor colorWithRed:170.0f/255.0f green:230.0f/255.0f blue:245.0f/255.0f alpha:1]

@interface LoginViewController ()<UITextFieldDelegate>

@end

@implementation LoginViewController
{
    UIImageView *backgroundImg;
    UIButton *login;
    UIButton *forgetPsw;
    UIButton *register_btn;
    //用户名
    UITextField *username;
    //密码
    UITextField *password;
    
    NSArray *ohterimagename;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare];
    [self UIConfig];
}
#pragma mark - SomePrepare
-(void)SomePrepare
{
    [self PrepareData];
    [self PrepareUI];
}
-(void)PrepareData{
    __block LoginViewController *weakself = self;
    registerBlock=^()
    {
        [weakself dismissModalViewControllerAnimated:YES];
    };
    resetpasswordBlock=^()
    {
        [weakself dismissModalViewControllerAnimated:YES];
    };
}
-(void)PrepareUI{
    backgroundImg=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    if(_isPad)
    {
        backgroundImg.backgroundColor=_define_login_background;
        
    }else
    {
        backgroundImg.image=[UIImage imageNamed:@"login_背景层"];
    }
    
    [self.view addSubview:backgroundImg];
}
#pragma mark - UIConfig
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

    CGFloat _start_y=0;
    if(_isPad){
        _start_y=(ScreenHeight/2)-80*_Scale;
        
    }else{
        _start_y=(ScreenHeight/2)-180*_Scale;
    }
    
    password=[[UITextField alloc] initWithFrame:CGRectMake((ScreenWidth/2)-200*_Scale, _start_y, 400*_Scale, 70*_Scale)];
    [self.view addSubview:password];
    password.placeholder=@" 密 码 ";
    password.returnKeyType=UIReturnKeyDone;
    [password setValue:Color_placeholder forKeyPath:@"_placeholderLabel.textColor"];
    [password setValue:[UIFont boldSystemFontOfSize:12] forKeyPath:@"_placeholderLabel.font"];
    password.delegate=self;
    password.font=[regular getFont:12.0f];
    password.textColor=[UIColor whiteColor];
    //    保密输入
    password.secureTextEntry=YES;
    password.delegate=self;
    password.clearButtonMode=UITextFieldViewModeWhileEditing;
    UIView *dibu1=[UIView getCustomViewWithColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.2]];
    dibu1.frame = CGRectMake(0, CGRectGetHeight(password.frame)-10*_Scale, CGRectGetWidth(password.frame), 2*_Scale);
    [password addSubview:dibu1];

    UIButton *view_left=[UIButton getCustomImgBtnWithImageStr:@"login_显示密码( 未选择)" WithSelectedImageStr:@"login_显示密码"];
    view_left.frame=CGRectMake(0, 0, 70*_Scale, CGRectGetHeight(password.frame));
    [view_left setImageEdgeInsets:UIEdgeInsetsMake((CGRectGetHeight(view_left.frame)-22*_Scale)/2.0f, (CGRectGetWidth(view_left.frame)-60*_Scale)/2.0f, (CGRectGetHeight(view_left.frame)-22*_Scale)/2.0f, (CGRectGetWidth(view_left.frame)-60*_Scale)/2.0f)];
    [view_left addTarget:self action:@selector(showpassword:) forControlEvents:UIControlEventTouchUpInside];
    password.rightView=view_left;
    password.rightViewMode = UITextFieldViewModeAlways;
    
    username=[[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(password.frame), CGRectGetMinY(password.frame)-8*_Scale-CGRectGetHeight(password.frame), CGRectGetWidth(password.frame), CGRectGetHeight(password.frame))];
    username.textColor=[UIColor whiteColor];
    username.placeholder=@" 手 机 号 或 邮 箱 ";
    [username setValue:Color_placeholder forKeyPath:@"_placeholderLabel.textColor"];
    [username setValue:[UIFont boldSystemFontOfSize:12] forKeyPath:@"_placeholderLabel.font"];
    username.font=[regular getFont:12.0f];
    username.delegate=self;
    username.clearButtonMode=UITextFieldViewModeWhileEditing;
    [self.view addSubview:username];
    
    UIView *dibu2=[UIView getCustomViewWithColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.2]];
    dibu2.frame = CGRectMake(0, CGRectGetHeight(username.frame)-10*_Scale, CGRectGetWidth(username.frame), 2*_Scale);
    [username addSubview:dibu2];
    
    //    留美盒子icon
    UIImageView *icon=[UIImageView getImgWithImageStr:@"login_ICON11"];
    [self.view addSubview:icon];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(140*_Scale);
        make.height.mas_equalTo(136*_Scale);
        make.top.mas_equalTo(self.mas_topLayoutGuideBottom).with.offset(95*_Scale);
        make.centerX.mas_equalTo(self.view);
    }];

    //    修改btn的frame
    login=[UIButton getCustomTitleBtnWithAlignment:0 WithFont:15.0f WithSpacing:0 WithNormalTitle:@"登   录" WithNormalColor:[UIColor whiteColor] WithSelectedTitle:nil WithSelectedColor:nil];
    login.frame=CGRectMake(CGRectGetMinX(password.frame), CGRectGetMaxY(password.frame)+45*_Scale,CGRectGetWidth(password.frame), (50*_Scale*CGRectGetWidth(password.frame))/(330*_Scale));
    [login setBackgroundColor:_define_blue_color_login];
    [login addTarget:self action:@selector(sumbit_action:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:login];
    
    
    forgetPsw=[UIButton getCustomTitleBtnWithAlignment:1 WithFont:10.0f WithSpacing:0 WithNormalTitle:@"忘记密码?" WithNormalColor:[UIColor whiteColor] WithSelectedTitle:nil WithSelectedColor:nil];
    [forgetPsw.titleLabel setAttributedText:[regular createAttributeString:@"忘记密码?" andFloat:@(2.0)]];
    [forgetPsw addTarget:self action:@selector(forget_password_action:) forControlEvents:UIControlEventTouchUpInside];
    forgetPsw.frame=CGRectMake(CGRectGetMinX(password.frame), CGRectGetMaxY(login.frame)+10*_Scale, 180*_Scale, 42*_Scale);
    [self.view addSubview:forgetPsw];
    
    
    register_btn=[UIButton getCustomTitleBtnWithAlignment:2 WithFont:10.0f WithSpacing:0 WithNormalTitle:@"没有账号?" WithNormalColor:[UIColor whiteColor] WithSelectedTitle:nil WithSelectedColor:nil];
    [register_btn.titleLabel setAttributedText:[regular createAttributeString:@"没有账号?" andFloat:@(2.0)]];
    [register_btn addTarget:self action:@selector(register_action:) forControlEvents:UIControlEventTouchUpInside];
    register_btn.frame=CGRectMake(CGRectGetMaxX(password.frame)-CGRectGetWidth(forgetPsw.frame), CGRectGetMinY(forgetPsw.frame), CGRectGetWidth(forgetPsw.frame), CGRectGetHeight(forgetPsw.frame));
    [self.view addSubview:register_btn];
    
    BOOL app1 = [ShareSDK isClientInstalled:SSDKPlatformTypeWechat];
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
#pragma mark - SomeAction
//显示密码
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

-(void)backAction:(UIButton *)btn
{
    if([self.type isEqualToString:@"userinfo"]){
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"xiaoshi" object:@"userinfo"];
        
    }else if([self.type isEqualToString:@"chat"]){
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"xiaoshi" object:@"chat"];

    }else{

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
-(void)sumbit_action:(UIButton *)btn
{
    
    [regular dismissKeyborad];
    //    post前进行判断，用户名、密码格式是否正确
    if([username.text isEqualToString:@""]||[password.text isEqualToString:@""])
    {
        //    账号密码中有空值时
        [self presentViewController:[regular alertTitle_Simple:@"账号或者密码不能为空"] animated:YES completion:nil];
    }else if ([password.text length]<6||[password.text length]>16)
    {
        [self presentViewController:[regular alertTitle_Simple:@"密码长度为6到16位之间"] animated:YES completion:nil];
    }else
    {
        
        if([regular emailVerify:username.text])
        {
            //        判断是否为邮箱
            [self loginAction:@"email"];
            
        }else if([regular phoneVerify:username.text])
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
#pragma mark - 第三方登录
- (void)reloadStateWithType:(SSDKPlatformType)type{
    //现实授权信息，包括授权ID、授权有效期等。
    //此处可以在用户进入应用的时候直接调用，如授权信息不为空且不过期可帮用户自动实现登录。
    [ShareSDK cancelAuthorize:type];
    [ShareSDK getUserInfo:type
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
    {
        if (state == SSDKResponseStateSuccess)
        {
            [regular createProgress:@"登录中"];
            
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            //获取请求参数
            NSDictionary *parameters=[LoginTool getCallbackParameters:user];
            
            [manager POST:[[NSString alloc] initWithFormat:@"%@%@",DNS,[LoginTool getAPIWithPlatformType:type]] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)  {
                
                NSString *html = operation.responseString;
                NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
                
                [[ToolManager sharedManager] removeProgress];
                if([[dict objectForKey:@"code"] integerValue]==1)
                {
                    [self login_success:dict isAuth:YES];
                }else
                {
                    [[ToolManager sharedManager] alertTitle_Simple:[dict objectForKey:@"message"]];
                    [[ToolManager sharedManager] removeProgress];
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错蓝色" Withtype:2]];
                [regular removeProgress];
            }];
        }else{
            if(error)
            {
                //                [self presentViewController:[regular alertTitle_Simple:NSLocalizedString(error.description, @"")] animated:YES completion:nil];
                //                 JXLOG(@"分享失败,错误码:%ld,错误描述:%@", (long)[error errorCode], [error errorDescription]);
            }
        }
    }];
}
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
-(void)forget_password_action:(UIButton *)btn
{
    chooseForgetViewController *forget=[[chooseForgetViewController alloc] init];
    forget.block=resetpasswordBlock;
    [self presentModalViewController:forget animated:YES];
}
#pragma mark - 登录
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

        [self login_success:dict isAuth:NO];
    }
    else
    {
        [[ToolManager sharedManager] alertTitle_Simple:[dict objectForKey:@"message"]];
        [regular removeProgress];
    }
}

-(void)login_success:(NSDictionary *)dict isAuth:(BOOL)isAuth
{
    //将username、password、islogin、uid、userImage保存进NSUserDefaults
    //取出沙盒中的NSUserDefaults
    NSDictionary *_user = [[dict objectForKey:@"data"] objectForKey:@"user"];
    BOOL isAutoLogin = [[EaseMob sharedInstance].chatManager isAutoLoginEnabled];
    if (!isAutoLogin) {
        [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:[_user objectForKey:@"ease_mob_username"] password:[_user objectForKey:@"ease_mob_password"]
                                                          completion:^(NSDictionary *loginInfo, EMError *error) {
                                                              if (!error) {
                                                                  // 设置自动登录
                                                                  [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
                                                              }


                                                          }onQueue:nil];
    }else
    {
        [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:[_user objectForKey:@"ease_mob_username"] password:[_user objectForKey:@"ease_mob_password"]
                                                          completion:^(NSDictionary *loginInfo, EMError *error) {
                                                              if (!error) {
                                                                  // 设置自动登录
                                                                  [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
                                                              }
                                                              
                                                              
                                                          }onQueue:nil];
    }

    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    //将islogin存入defaults中
    if([defaults objectForKey:@"users"]==nil)
    {
        [defaults setObject:[[NSMutableArray alloc] init] forKey:@"users"];
    }

    [defaults setObject:[_user objectForKey:@"ease_mob_username"] forKey:@"chatname"];
    [defaults setObject:[_user objectForKey:@"ease_mob_password"] forKey:@"chatpassword"];
    
    //将islogin存入defaults中
    
    [defaults setObject:@"0" forKey:@"hangban"];
    [defaults setObject:@"0" forKey:@"mianqian"];
    
    NSNumber *islogin=[[NSNumber alloc]initWithInt:1];
    [defaults setObject:islogin forKey:@"islogin"];
    //将username存入defaults中
     [defaults setObject:username.text forKey:@"tel"];
    [defaults setObject:[_user objectForKey:@"username"] forKey:@"username"];
    [defaults setObject:[_user objectForKey:@"token"] forKey:@"token"];
    [defaults setObject:[NSNumber numberWithInt:isAuth] forKey:@"is_auth"];
    //将password存入defaults中
    [defaults setObject:password.text forKey:@"password"];
    //将uid存入defaults中
    [defaults setObject:[_user objectForKey:@"id"] forKey:@"uid"];
    //取出头像对应的路径
    NSString *_image_type=nil;
    NSString *_image_url=nil;
    if([NSString isNilOrEmpty:[_user objectForKey:@"avatar"]])
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
        [defaults setObject:[NSData dataWithContentsOfURL:[NSURL URLWithString:[_user objectForKey:@"avatar"]]]forKey:@"userImage"];
        _image_type=@"1";
        _image_url=[_user objectForKey:@"avatar"];
    }
    [defaults setObject:[[NSDictionary alloc] initWithObjectsAndKeys:_image_type,@"type",_image_url,@"image",nil] forKey:@"userImageurl"];
   
    //    保存后隐藏进度条
    [regular removeProgress];
    [regular registerGeTui];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    NSString * _deviceToken=[[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
//    [[ToolManager sharedManager] alertTitle_Simple:_deviceToken];
    if(_deviceToken!=nil)
    {
        [GeTuiSdk registerDeviceToken:_deviceToken];
        
        [regular registerGeTui];
        
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateImg" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"getnotification" object:nil];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"getmessage" object:nil];
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"reload" object:nil];
    //发通知刷新发现美校
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
    }}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if(theTextField==password){
        
        [self sumbit_action:[UIButton new]];
    }
    [theTextField resignFirstResponder];
    return YES;
}
#pragma mark - Other
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //    收回键盘
    [regular dismissKeyborad];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
