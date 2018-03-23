//
//  ToolManager.m
//  OneBox
//
//  Created by 谢江新 on 15/3/2.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//
#define login_url @"http://121.40.153.17/api/index.php/Home/User/login"
#import "MyMD5.h"
#import "ToolManager.h"
#import "MyMD5.h"
#import "KVNProgress.h"
@implementation ToolManager
{
    void (^_block)(void);
    UIImageView *backview;
}

static ToolManager *_t = nil;

/*手机号码验证 MODIFIED BY HELENSONG*/
+ (BOOL)validateMobile:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
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
//线程安全的方法二
//+(id)sharedManager
//{
//    dispatch_once_t once = 0;
//    dispatch_once(&once, ^{
//        if (!_t) {
//            _t = [[ToolManager alloc]init];
//        }
//    });
//    return _t;
//}
//线程安全的方法一
+(id)sharedManager
{
    @synchronized(self)
    {
        if (!_t) {
            _t = [[ToolManager alloc]init];
            }
    }
    return _t;
}
-(UIImageView *)showSuccessfulOperationViewWithTitle:(NSString *)title WithImg:(NSString *)imagename Withtype:(NSInteger)type
{

    if(backview==nil){
        CGFloat _h=220*_Scale;
        CGFloat _w=260*_Scale;
        if(backview==nil)
        {
            backview=[[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth-_w)/2.0f, (ScreenHeight-_h)/2.0f, _w, _h)];
        }else
        {
            backview.frame=CGRectMake((ScreenWidth-_w)/2.0f, (ScreenHeight-_h)/2.0f, _w, _h);
        }
        if(backview.alpha==0)
        {
            backview.alpha=1;
        }

        if(type==1)
        {
            backview.image=[UIImage imageNamed:@"Prompt_提示_backview"];
        }else if(type==2)
        {
            backview.backgroundColor=[UIColor whiteColor];
        }

        backview.layer.masksToBounds=YES;
        backview.layer.cornerRadius=3;
        backview.alpha=0.9;

        CGFloat _imagehight=70*_Scale;
        UIImageView *imageview=nil;
        if(imagename!=nil)
        {
            imageview=[[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(backview.frame)-_imagehight)/2.0f, 40*_Scale, _imagehight, _imagehight)];
            imageview.image=[UIImage imageNamed:imagename];
            [backview addSubview:imageview];
        }

        UILabel *label=[[UILabel alloc] init];

        label.textAlignment=1;
        label.text=title;

        if(type==1)
        {
            label.textColor=[UIColor whiteColor];
        }else if(type==2)
        {
            label.textColor=_define_blue_color;
        }

        label.numberOfLines=0;
        CGFloat _font=13.0f;
        label.font=[regular getFont:_font];
        if(imageview==nil)
        {

            label.frame=CGRectMake(0,(CGRectGetHeight(backview.frame)-70*_Scale)/2.0f, _w, 70*_Scale);

        }else
        {
            label.frame=CGRectMake(0,CGRectGetMaxY(imageview.frame)+20*_Scale, _w, 70*_Scale);

        }

        [backview addSubview:label];
        [UIView beginAnimations:@"anmationAppear" context:nil];
        [UIView setAnimationDuration:0.5];
        //设置动画延时多少秒启动
        [UIView setAnimationDelay:1];
        [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(anmationStop)];
        backview.alpha=0;
        [UIView commitAnimations];
        return backview;
    }else
    {
        return nil;
    }
}

-(void)anmationStop
{
    [backview removeFromSuperview];
    backview=nil;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}
+(BOOL)is_right_locationWithLong:(double)_long WithLat:(double)_lat
{
    BOOL _b=YES;
    if((_lat<90)&&(_lat>-90))
    {

    }else
    {
        _b=NO;
    }
    
    if((_long<180)&&(_long>-180))
    {

    }else
    {
        _b=NO;
    }

    return _b;
}


-(void)imageTap
{
    _block();
}
-(void)loginWithSuccess:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure pastdue:(void (^)())pastdue
{
    
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    
    
    NSURL *url = [NSURL URLWithString:[login_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    //    创建可变request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5];
    //    设定请求类型未post
    [request setHTTPMethod:@"POST"];
    //    创建包体
    NSString *body=[[NSString alloc] initWithFormat:@"username=%@&password=%@",[defaults objectForKey:@"username"],[defaults objectForKey:@"password"]];
    
    //    加入包体
    request.HTTPBody=[body dataUsingEncoding:NSUTF8StringEncoding];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    //    进行网络请求（AF框架）
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *html = operation.responseString;
        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
        //        进行解析以后的操作
        NSDictionary *__dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if([__dict[@"state"] intValue]==0)
        {
            success(__dict);
        }else
        {
            pastdue();
            
        }
        
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        //        下载失败时，打印错误信息
        failure(error);
        
    }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];

}
-(void) NetworkRequest:(NSString *)path bodyStr:(NSString *)body ispost:(BOOL )_ispost success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure{
    
    NSURL *url = [NSURL URLWithString:[path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    //    创建可变request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5];
    if(_ispost)
    {
        //    设定请求类型未post
        [request setHTTPMethod:@"POST"];
        //    创建包体
        //    加入包体
        request.HTTPBody=[body dataUsingEncoding:NSUTF8StringEncoding];
    }
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    //    进行网络请求（AF框架）
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *html = operation.responseString;
        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
        //        进行解析以后的操作
        NSDictionary *__dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        success(__dict);
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //        下载失败时，打印错误信息
        failure(error);
        
    }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];
    
}

-(UIButton *)createBtnWithRect:(CGRect) rect WithTitle:(NSString *)title WithNormalStr:(NSString *)nStr WithSelectStr:(NSString *)sStr
{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    
    [btn setFrame:rect];
    
    [btn setBackgroundImage:[UIImage imageNamed:sStr] forState:UIControlStateSelected];
    [btn setBackgroundImage:[UIImage imageNamed:nStr] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateSelected];
    return btn;
}
-(UIImageView *)createTitleView:(NSString *)title WithRect:(CGRect )rect WithImg:(NSString *)imageName WithtitleColor:(UIColor *)_color WithTextAlignment:(NSInteger) type Withjiange:(CGFloat)jiange
{
    UIImageView *titleImage=[[UIImageView alloc] initWithFrame:rect];
    titleImage.image=[UIImage imageNamed:imageName];
    //    [_view_StuGrade addSubview:titleImage];

    UILabel *labelImage=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(titleImage.frame), CGRectGetHeight(titleImage.frame))];

    labelImage.textAlignment=type;
    [labelImage setAttributedText:[regular createAttributeString:title andFloat:@(jiange)]];
    labelImage.textColor=_color;
    labelImage.font= [regular getFont:12.5f];
    [titleImage addSubview:labelImage];
    return titleImage;
}

-(UIImageView *)createTitleView:(NSString *)title WithRect:(CGRect )rect WithImg:(NSString *)imageName WithtitleColor:(UIColor *)_color WithTextAlignment:(NSInteger) type
{
    UIImageView *titleImage=[[UIImageView alloc] initWithFrame:rect];
    titleImage.image=[UIImage imageNamed:imageName];
    //    [_view_StuGrade addSubview:titleImage];
    
    UILabel *labelImage=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(titleImage.frame), CGRectGetHeight(titleImage.frame))];

    labelImage.text=title;
    labelImage.textAlignment=type;
    labelImage.textColor=_color;
    labelImage.font= [regular getFont:12.5f];

    [titleImage addSubview:labelImage];
    return titleImage;
}
-(UIImageView *)createTitleView:(NSString *)title WithRect:(CGRect )rect WithImg:(NSString *)imageName WithtitleColor:(UIColor *)_color WithTextAlignment:(NSInteger) type WithFontName:(NSString *)str WithFont:(CGFloat )_font
{
    UIImageView *titleImage=[[UIImageView alloc] initWithFrame:rect];
    titleImage.image=[UIImage imageNamed:imageName];
//    titleImage.backgroundColor=[UIColor redColor];
    //    [_view_StuGrade addSubview:titleImage];

    UILabel *labelImage=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(titleImage.frame), CGRectGetHeight(titleImage.frame))];
//    labelImage.backgroundColor=[UIColor redColor];
    labelImage.text=title;
    labelImage.textAlignment=type;
    labelImage.textColor=_color;

    labelImage.font=[regular getFont:_font];

   

    [titleImage addSubview:labelImage];
    return titleImage;
}
-(UIImageView *)createImgView:(NSString *)imageName WithRect:(CGRect )rect
{
    UIImageView *imageview=[[UIImageView alloc] initWithFrame:rect];
    [imageview setImage:[UIImage imageNamed:imageName]];
    return imageview;
}
-(UILabel *)createLabelView:(NSString *)title Withrect:(CGRect )rect WithTextColor:(UIColor *)_color WithTextAlignment:(NSInteger) type WithFont:(CGFloat )_font
{
    UILabel *label=[[UILabel alloc] initWithFrame:rect];
    label.textColor=_color;
    label.font=[regular getFont:_font];
    label.text=title;
    label.textAlignment=type;
    return label;

}
-(UIView *)createView:(CGRect )rect WithColor:(UIColor *)_color
{
    UIView *view=[[UIView alloc] initWithFrame:rect];
    view.backgroundColor=_color;
    return view;
}



-(void)createProgress:(NSString *)title
{
    [KVNProgress showWithParameters:@{KVNProgressViewParameterStatus: title,
                                      KVNProgressViewParameterBackgroundType: @(KVNProgressBackgroundTypeSolid),
                                      KVNProgressViewParameterFullScreen: @(NO)}];
}
-(void)removeProgress
{
    [KVNProgress dismiss];
}
-(UIView *)returnNavView:(NSString *)title withmaxwidth:(CGFloat )maxwidth
{
    CGFloat _Default_font=16.0;
    CGFloat _Default_Spacing=3.0f;
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, maxwidth, 40)];
//    view.backgroundColor=[UIColor redColor];
    UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(view.frame),CGRectGetHeight(view.frame))];

    titleLabel.font =  (kIOSVersions>=9.0? [UIFont systemFontOfSize:_Default_font]:[UIFont fontWithName:@"Helvetica Neue" size:_Default_font]);
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    [titleLabel setAttributedText:[ToolManager createAttributeString:title andFloat:@(_Default_Spacing)]];
    [view addSubview:titleLabel];
    [titleLabel sizeToFit];
    BOOL _isfit;
    if(CGRectGetWidth(titleLabel.frame)<=maxwidth)
    {
        _isfit=NO;
    }else
    {
        for (int i=_Default_font*2;i>0;i--) {


            if(_Default_Spacing<=0)
            {
                _Default_font-=0.5f;

            }else
            {
                _Default_Spacing-=0.5f;
            }

            titleLabel.font =  (kIOSVersions>=9.0? [UIFont systemFontOfSize:_Default_font]:[UIFont fontWithName:@"Helvetica Neue" size:_Default_font]);

            [titleLabel setAttributedText:[ToolManager createAttributeString:title andFloat:@(_Default_Spacing)]];
            [titleLabel sizeToFit];
            if(CGRectGetWidth(titleLabel.frame)<=maxwidth||_Default_font<=13.0f)
            {
                break;
            }
        }
    }
    JXLOG(@"Spacing=%f  font=%f",_Default_Spacing,_Default_font);
    if(CGRectGetWidth(titleLabel.frame)>maxwidth&&_Default_font==13.0f)
    {
        titleLabel.frame=CGRectMake(0, 0, CGRectGetWidth(view.frame), CGRectGetHeight(view.frame));

    }else
    {
        titleLabel.frame=CGRectMake((CGRectGetWidth(view.frame)-CGRectGetWidth(titleLabel.frame))/2.0f, (CGRectGetHeight(view.frame)-CGRectGetHeight(titleLabel.frame))/2.0f, CGRectGetWidth(titleLabel.frame), CGRectGetHeight(titleLabel.frame));
        
    }
    
    return view;

}

-(UIAlertView *)alertTitle_Simple:(NSString *)title
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:nil delegate:self cancelButtonTitle:@"好" otherButtonTitles: nil];
    [alert show];
    return alert;
    
}
-(UIButton *)CustomButtonWithFrame:(CGRect )rect
{
    UIButton *navBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    navBtn.frame=rect;
    NSUserDefaults *dict=[NSUserDefaults standardUserDefaults];
    navBtn.layer.masksToBounds=YES;
    navBtn.layer.cornerRadius=navBtn.frame.size.width/2.0f;
    navBtn.layer.borderWidth=1;
    navBtn.layer.borderColor=[[UIColor whiteColor] CGColor];
    
    if([regular isLogin])
    {
        [navBtn setImage:[UIImage imageWithData:[dict objectForKey:@"userImage"]] forState:UIControlStateNormal];
    }else
    {
        [navBtn setImage:[UIImage imageNamed:@"headImg_login1"] forState:UIControlStateNormal];
    }
    return navBtn;
}

-(void)createSuccessProgress
{
    [KVNProgress showSuccessWithStatus:@"Success"];
    
}
+ (NSAttributedString *)createAttributeString:(NSString *)str andFloat:(NSNumber*)nsKern{
    NSAttributedString *attributedString =[[NSAttributedString alloc] initWithString:str attributes:@{NSKernAttributeName : nsKern}];
    return attributedString;
}
@end
