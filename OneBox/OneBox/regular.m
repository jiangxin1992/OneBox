//
//  regular.m
//  OneBox
//
//  Created by 谢江新 on 15-2-3.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//
#import "KVNProgress.h"
#import "regular.h"
#import "NSString+extra.h"
#import "Tools.h"
#import <CommonCrypto/CommonDigest.h>
@implementation regular

static regular *_t = nil;

/**
 * 单例
 */
+(id)sharedManager
{
    @synchronized(self)
    {
        if (!_t) {
            _t = [[regular alloc]init];
        }
    }
    return _t;
}
+(BOOL)isEnableAPNS
{
    UIRemoteNotificationType types;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        types = [[UIApplication sharedApplication] currentUserNotificationSettings].types;
    }else{
        // 原来的代码
        types = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        
    }
    return (types & UIRemoteNotificationTypeAlert);
    
}
+ (NSString *)getRoundNum:(CGFloat )_num
{
    CGFloat _changeNum=round(_num*100)/100;
    long _changeNum2=round(_num*100);
    
    NSInteger _index=0;
    
    if(_changeNum2 % 100)
    {
        _index++;
    }
    if(_changeNum2 % 10)
    {
        _index++;
    }
    
    NSString *_str=@"";
    if(_index==0)
    {
        _str=[[NSString alloc] initWithFormat:@"%.0lf",_changeNum];
    }else if(_index==1)
    {
        _str=[[NSString alloc] initWithFormat:@"%.1lf",_changeNum];
    }else if(_index==2)
    {
        _str=[[NSString alloc] initWithFormat:@"%.2lf",_changeNum];
    }
    return _str;
}
+ (NSString *)getHTMLStringWithContent:(NSString *)content WithFont:(NSString *)font WithColorCode:(NSString *)color
{
    if(!content)content=@"";
    if(!font)font=@"15px/20px";
    if(!color)color=@"#000000";
    NSString *temp = nil;
    NSMutableString *mut=[[NSMutableString alloc] init];
    for(int i =0; i < [content length]; i++)
    {
        temp = [content substringWithRange:NSMakeRange(i, 1)];
        if([temp isEqualToString:@"\n"])
        {
            [mut appendString:@"<br>"];
            
        }else
        {
            [mut appendString:temp];
        }
    }
    return [NSString stringWithFormat:@"<!DOCTYPE HTML><html><head><meta charset=utf-8><meta name=viewport content=width=device-width, initial-scale=1><style>body{word-wrap:break-word;margin:0;background-color:transparent;font:%@ Helvetica;align:justify;color:%@}</style><div align='justify'>%@<div>",font,color,mut];
}
+(CGFloat )getHeightWithWidth:(CGFloat )width WithContent:(NSString *)content WithFont:(UIFont *)font
{
    CGSize titleSize = [content boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    return titleSize.height+1;
}
+(CGFloat )getWidthWithHeight:(CGFloat )height WithContent:(NSString *)content WithFont:(UIFont *)font
{
    CGSize titleSize = [content boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    return titleSize.width+1;
}
+(NSString *)getSpacingTime:(long)createTime
{
    long _minute=60;
    long _hour=60*60;
    long _day=60*60*24;
    long _year=60*60*24*365;
    long space=[NSDate nowTime]-createTime;
    if(space)
    {
        if(space<_minute)
        {
            return [[NSString alloc] initWithFormat:@"%ld秒前",space];
        }else if(space<_hour)
        {
            return [[NSString alloc] initWithFormat:@"%ld分钟前",space/_minute];
        }else if(space<_day)
        {
            return [[NSString alloc] initWithFormat:@"%ld小时前",space/_hour];
        }else if(space<_year)
        {
            return [[NSString alloc] initWithFormat:@"%ld天前",space/_day];
        }else
        {
            return [[NSString alloc] initWithFormat:@"%ld年前",space/_year];
        }
    }
    return @"";
}
/**
 * 根据shareAdvise获取当前label高度
 */
+(CGFloat )getHeightWithContent:(NSString *)shareAdvise WithWidth:(CGFloat)Width WithFont:(CGFloat )font
{
    CGSize size=[Tools sizeOfStr:shareAdvise andFont:[regular getFont:font] andMaxSize:CGSizeMake(Width, 99999999) andLineBreakMode:NSLineBreakByWordWrapping];
    return size.height;
}
+(void)setBorder:(UIView *)view
{
    view.layer.masksToBounds=YES;
    view.layer.borderColor=[[UIColor blackColor] CGColor];
    view.layer.borderWidth=1;
}
+(void)setZeroBorder:(UIView *)view
{
    //    view.layer.masksToBounds=YES;
    //    view.layer.borderColor=[[UIColor blackColor] CGColor];
    //    view.layer.borderWidth=0;
    view.clipsToBounds=YES;
}
+(void)setBorder:(UIView *)view WithColor:(UIColor *)color WithWidth:(CGFloat )width
{
    view.layer.masksToBounds=YES;
    view.layer.borderColor=[color CGColor];
    view.layer.borderWidth=width;
}
+(void)dispatch_cancel:(dispatch_source_t )_timer
{
    if(_timer)
    {
        if(!dispatch_source_testcancel(_timer))
        {
            dispatch_source_cancel(_timer);
        }
    }
}
+(NSDate*)zoneChange:(long)time{
    return [NSDate dateWithTimeIntervalSince1970:time];
}
- (instancetype)init
{
    self = [super init];
    if (self) {

    }
    return self;
}
+(NSString *)getTimeStr:(long)time
{
    if(time>=0)
    {
        NSCalendar *cal = [NSCalendar currentCalendar];//定义一个NSCalendar对象
        NSDate *today = [NSDate date];//得到当前时间
        
        //用来得到具体的时差
        unsigned int unitFlags =  NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
        NSDate *NiceNewdate=[regular zoneChange:[NSDate nowTime]+time];
        NSDateComponents *d = [cal components:unitFlags fromDate:today toDate:NiceNewdate options:0];
        
        
        if([d day]<0||[d hour]<0||[d minute]<0||[d second]<0)
        {
            return @"发布会已结束";
        }else
        {
            return [[NSString alloc] initWithFormat:@"%ld天%ld时%ld分%ld秒",[d day],[d hour],[d minute],[d second]];
        }
    }else
    {
        return @"发布会已结束";
    }
}
+(NSString *)getTimeStr:(long)time WithFormatter:(NSString *)_formatter
{
    
    
    NSDate*detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    
    JXLOG(@"date:%@",[detaildate description]);
    
    //实例化一个NSDateFormatter对象
    
    NSDateFormatter*dateFormatter = [[NSDateFormatter alloc]init];
    
    //设定时间格式,这里可以设置成自己需要的格式
    
    [dateFormatter setDateFormat:_formatter];
    
    NSString*currentDateStr = [dateFormatter stringFromDate:detaildate];
    
    return currentDateStr;
    
    //NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //[formatter setDateFormat:_formatter];
    //NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:time];
    //NSString *nowtimeStr = [formatter stringFromDate:confromTimesp];//----------将nsdate按formatter格式转成nsstring
    //return nowtimeStr;
    
}
+(long )getTimeWithTimeStr:(NSString *)time
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    NSDate* date = [formatter dateFromString:time];
    return [date timeIntervalSince1970];
}
+(long)date
{
    return [[NSDate date] timeIntervalSince1970];
}
+(void)pushSystem
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}
+(void)dismissKeyborad
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}
/**
 *  // 验证是固话或者手机号
 *
 *  @param mobileNum 手机号
 *
 *  @return 是否
 */
+ (BOOL)isMobilePhoneOrtelePhone:(NSString *)mobileNum {
    if (mobileNum==nil || mobileNum.length ==0) {
        return NO;
    }
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^((13)|(14)|(15)|(17)|(18))\\d{9}$";// @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
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
    NSString * PHS = @"^((0\\d{2,3}-?)\\d{7,8}(-\\d{2,5})?)$";// @"^0(10|2[0-5789]-|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestPHS = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES)
        || ([regextestPHS evaluateWithObject:mobileNum]==YES)) {
        return YES;
    }
    else{
        return NO;
    }
}
+(BOOL )emailVerify:(NSString *)email
{
    return [self Verify:email WithCode:@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"];
}
+(BOOL )codeVerify:(NSString *)phone
{
    return [self Verify:phone WithCode:@"^[A-Za-z0-9]+$"];
}
+(BOOL )phoneVerify:(NSString *)phone
{
    return [self Verify:phone WithCode:@"^1[3|4|5|7|8][0-9]\\d{8}$"];
}
+(BOOL )PostCodeVerify:(NSString *)phone
{
    
    return [self Verify:phone WithCode:@"^[1-9][0-9]{5}$"];
}

+ (BOOL)checkPassword:(NSString *) password
{
    return [self Verify:password WithCode:@"^[A-Za-z0-9]{6,16}$"];
    
}

+(BOOL)numberVerift:(NSString *)phone
{
    return [self Verify:phone WithCode:@"^[0-9]+([.]{0,1}[0-9]+){0,1}$"];
}
+(BOOL )telephoneAreaCode:(NSString *)telephoneArea
{
    // 03xx
    NSString *fourDigit03 = @"03([157]\\d|35|49|9[1-68])";
    // 04xx
    NSString *fourDigit04 = @"04([17]\\d|2[179]|[3,5][1-9]|4[08]|6[4789]|8[23])";
    // 05xx
    NSString *fourDigit05 = @"05([1357]\\d|2[37]|4[36]|6[1-6]|80|9[1-9])";
    // 06xx
    NSString *fourDigit06 = @"06(3[1-5]|6[0238]|9[12])";
    // 07xx
    NSString *fourDigit07 = @"07(01|[13579]\\d|2[248]|4[3-6]|6[023689])";
    // 08xx
    NSString *fourDigit08 = @"08(1[23678]|2[567]|[37]\\d)|5[1-9]|8[3678]|9[1-8]";
    // 09xx
    NSString *fourDigit09 = @"09(0[123689]|[17][0-79]|[39]\\d|4[13]|5[1-5])";
    
    NSString *codeStr = [NSString stringWithFormat:@"%@|%@|%@|%@|%@|%@|%@",fourDigit03,fourDigit04,fourDigit05,fourDigit06,fourDigit07,fourDigit08,fourDigit09];
    
    return [self Verify:telephoneArea WithCode:codeStr]||[self Verify:telephoneArea WithCode:@"010|02[0-57-9]"];
}

+(BOOL)Verify:(NSString *)content WithCode:(NSString *)code
{
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:code options:NSRegularExpressionCaseInsensitive error:&error];
    NSTextCheckingResult *result = [regex firstMatchInString:content options:0 range:NSMakeRange(0, [content length])];
    if (result) {
        return YES;
    }
    return NO;
}
+ (NSString *)md5:(NSString *)str
{
    const char *original_str = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wconversion"
    CC_MD5(original_str, strlen(original_str), result);
#pragma clang diagnostic pop
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}

//#define _fz  (kIOSVersions>=9.0? @"San Francisco":@"Helvetica Neue")
//(kIOSVersions>=9.0? @"":@"Helvetica Neue" )
+(UIFont *)get_en_Font:(CGFloat)font
{
    CGFloat _font=0;
    if(_isPad)
    {
        _font=font+16;

    }else
    {
        _font=font;
        
    }
    return [UIFont fontWithName:@"Skia" size:_font];
}
+(UIFont *)getFont:(CGFloat )font
{
    CGFloat _font=0;
    if(_isPad)
    {
        _font=font+16;

    }else
    {
        _font=font;

    }
    return (kIOSVersions>=9.0? [UIFont systemFontOfSize:_font]:[UIFont fontWithName:@"Helvetica Neue" size:_font]);
}
+(UIAlertController *)alertTitle_Simple:(NSString *)title
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:title preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"ok", @"") style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:okAction];
    return alertController;
}
+(UIAlertController *)alertTitle_Simple:(NSString *)title WithBlock:(void(^)())block
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:title preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"ok", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        block();
    }];
    [alertController addAction:okAction];
    return alertController;
}

+(UIAlertController *)alertTitleCancel_Simple:(NSString *)title WithBlock:(void(^)())block
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:title preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"ok", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        block();
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", @"") style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    return alertController;
}

+(UIAlertController *)alert_NONETWORKING
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"NetworkConnectError", @"") preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"ok", @"") style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:okAction];
    return alertController;
}
+ (UIButton *)createBtnWithRect:(CGRect) rect WithTitle:(NSString *)title WithNormalStr:(NSString *)nStr WithSelectStr:(NSString *)sStr
{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:rect];
    [btn setBackgroundImage:[UIImage imageNamed:sStr] forState:UIControlStateSelected];
    [btn setBackgroundImage:[UIImage imageNamed:nStr] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font=[regular getFont:17.0f];
    [btn setTitle:title forState:UIControlStateSelected];
    return btn;
}
+ (UIButton *)createBtnWithRect:(CGRect)rect WithTitle:(NSString *)title WithNormalColor:(UIColor *)normalColor WithSelectColor:(UIColor *)selectColor WithTitleFont:(UIFont *)font
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = rect;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:normalColor forState:UIControlStateNormal];
    [btn setTitleColor:selectColor forState:UIControlStateSelected];
    btn.titleLabel.font = font;
    return btn;
}
+(UIImageView *)createTitleView:(NSString *)title WithRect:(CGRect )rect WithImg:(NSString *)imageName WithtitleColor:(UIColor *)_color WithTextAlignment:(NSInteger) type
{
    UIImageView *titleImage=[[UIImageView alloc] initWithFrame:rect];
    titleImage.image=[UIImage imageNamed:imageName];
    //    [_view_StuGrade addSubview:titleImage];

    UILabel *labelImage=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(titleImage.frame), CGRectGetHeight(titleImage.frame))];
    labelImage.tag=999;
    labelImage.text=title;
    labelImage.textAlignment=type;
    labelImage.textColor=_color;

    [titleImage addSubview:labelImage];
    return titleImage;
}
+ (NSMutableAttributedString *)createAttributeString:(NSString *)str andFloat:(NSNumber*)nsKern{
    NSMutableAttributedString *attributedString =[[NSMutableAttributedString alloc] initWithString:str attributes:@{NSKernAttributeName : nsKern}];
    return attributedString;
}
+(UIImageView *)createImgView:(NSString *)imageName WithRect:(CGRect )rect
{
    UIImageView *imageview=[[UIImageView alloc] initWithFrame:rect];
    [imageview setImage:[UIImage imageNamed:imageName]];
    return imageview;
}
+(UILabel *)createLabelView:(NSString *)title Withrect:(CGRect )rect WithTextColor:(UIColor *)_color WithTextAlignment:(NSInteger) type WithFont:(CGFloat )_font
{
    UILabel *label=[[UILabel alloc] initWithFrame:rect];
    label.textColor=_color;
    label.font=[regular getFont:_font];
    label.text=title;
    label.textAlignment=type;
    //    label.numberOfLines = 0;
    return label;
}
+(UIView *)createView:(CGRect )rect WithColor:(UIColor *)_color
{
    UIView *view=[[UIView alloc] initWithFrame:rect];
    view.backgroundColor=_color;
    return view;
}



+(void)createProgress:(NSString *)title
{
    [KVNProgress showWithParameters:@{KVNProgressViewParameterStatus: title,
                                      KVNProgressViewParameterBackgroundType: @(KVNProgressBackgroundTypeSolid),
                                      KVNProgressViewParameterFullScreen: @(NO)}];
}
+(void)removeProgress
{
    [KVNProgress dismiss];
}
+(UIView *)returnNavView:(NSString *)title withmaxwidth:(CGFloat )maxwidth
{

    CGFloat _Default_font=16.0;
    CGFloat _Default_Spacing=3.0f;
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, maxwidth, 40)];

    UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(view.frame), CGRectGetHeight(view.frame))];

    titleLabel.font =  (kIOSVersions>=9.0? [UIFont systemFontOfSize:_Default_font]:[UIFont fontWithName:@"Helvetica Neue" size:_Default_font]);
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.textAlignment=1;
    [titleLabel setAttributedText:[regular createAttributeString:title andFloat:@(_Default_Spacing)]];
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

            titleLabel.font =
            (kIOSVersions>=9.0? [UIFont systemFontOfSize:_Default_font]:[UIFont fontWithName:@"Helvetica Neue" size:_Default_font]);
            [titleLabel setAttributedText:[ToolManager createAttributeString:title andFloat:@(_Default_Spacing)]];
            [titleLabel sizeToFit];
            if(CGRectGetWidth(titleLabel.frame)<=maxwidth||_Default_font<=13.0f)
            {
                break;
            }
        }
    }

    if(CGRectGetWidth(titleLabel.frame)>maxwidth&&_Default_font==13.0f)
    {
        titleLabel.frame=CGRectMake(0, 0, CGRectGetWidth(view.frame), CGRectGetHeight(view.frame));

    }else
    {
        titleLabel.frame=CGRectMake((CGRectGetWidth(view.frame)-CGRectGetWidth(titleLabel.frame))/2.0f, (CGRectGetHeight(view.frame)-CGRectGetHeight(titleLabel.frame))/2.0f, CGRectGetWidth(titleLabel.frame), CGRectGetHeight(titleLabel.frame));
        
    }

    return view;

}

+(UIAlertView *)alertTitle_Simple_OLD:(NSString *)title
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:nil delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
    [alert show];
    return alert;

}
+(UIButton *)CustomButtonWithFrame:(CGRect )rect
{
    UIButton *navBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    navBtn.frame=rect;
    NSUserDefaults *dict=[NSUserDefaults standardUserDefaults];
    navBtn.layer.masksToBounds=YES;
    navBtn.layer.cornerRadius=navBtn.frame.size.width/2.0f;
    navBtn.layer.borderWidth=2.0f;
    navBtn.layer.borderColor=[[UIColor whiteColor] CGColor];
    if([[dict objectForKey:@"islogin"] intValue]==1)
    {
        //        [navBtn setImage:[UIImage imageWithData:[dict objectForKey:@"userImage"]] forState:UIControlStateNormal];
        if(([dict objectForKey:@"userImage"]==[NSNull null])||([dict objectForKey:@"userImage"]==nil))
        {
            [navBtn setImage:[UIImage imageNamed:@"headImg_login1"] forState:UIControlStateNormal];
        }else
        {
            [navBtn setImage:[UIImage imageWithData:[dict objectForKey:@"userImage"]] forState:UIControlStateNormal];
        }
    }else
    {
        [navBtn setImage:[UIImage imageNamed:@"headImg_login1"] forState:UIControlStateNormal];
    }
    return navBtn;
}

+(void)createSuccessProgress
{
    [KVNProgress showSuccessWithStatus:@"Success"];

}
+ (UITextField *)createTextField:(CGRect)rect withReturnKeyType: (UIReturnKeyType) returnKeyType textColor: (UIColor *) textColor font: (UIFont *) font textAlignment: (NSTextAlignment) textAlignment toDelegate: (UIViewController<UITextFieldDelegate> *) delegate
                             tag: (NSInteger) tag

{
    UITextField *text = [[UITextField alloc] initWithFrame:rect];
    text.borderStyle = UITextBorderStyleNone;
    text.returnKeyType = returnKeyType;
    text.textColor = textColor;
    text.font = font;
    text.textAlignment = textAlignment;
    text.delegate = delegate;
    //    text.accessibilityLabel = accessibilityLabel;
    text.tag = tag;
    //    text.backgroundColor = [UIColor blackColor];
    return text;
}

//+ (void)checkLogin
//{
//    JXLOG(@"islogin%ld",[[[NSUserDefaults standardUserDefaults] objectForKey:@"islogin"] integerValue]);
//    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"islogin"] integerValue] == 1){
////        [regular createProgress:@"登录中"];
//
//        //    判断格式是否正确
//        //    请求url
//        NSString *str=[NSString stringWithFormat:@"%@/v1/users/login",DNS];
//        NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//        //    创建可变request
//        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5];
//        //    设定请求类型未post
//        [request setHTTPMethod:@"POST"];
//        //    创建包体
//        NSString *bodyStr=[[NSString alloc] initWithFormat:@"cell=%@&password=%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"tel"],[[NSUserDefaults standardUserDefaults] objectForKey:@"password"]];
//        //    加入包体
//        request.HTTPBody=[bodyStr dataUsingEncoding:NSUTF8StringEncoding];
//
//        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//
//        //    进行网络请求（AF框架）
//        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
////            [regular removeProgress];
//            if(!operation.response)
//            {
//                [self presentViewController:[regular alertTitle_Simple:@"请查收你的邮箱"] animated:YES completion:nil];
//            }else
//            {
//                NSString *html = operation.responseString;
//                NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
//                //        进行解析以后的操作
////                [self login_praise:data];
//                id res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//                [[NSUserDefaults standardUserDefaults] setObject:res[@"data"][@"token"] forKey:@"token"];
//                JXLOG(@"token%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]);
//
//
//            }
//
//        }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            //        下载失败时，打印错误信息
//            JXLOG(@"发生错误！%@",error);
////            [regular removeProgress];
//        }];
//
//        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
//        [queue addOperation:operation];
//
//    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
//    //将islogin存入defaults中
//    NSNumber *islogin=[[NSNumber alloc]initWithInt:1];
//    [defaults setObject:islogin forKey:@"islogin"];
//
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateImg" object:nil];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"islogin" object:nil];}
//
//}
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
        //        [self login_success:dict];

    }
    else
    {
        [regular alertTitle_Simple_OLD:[dict objectForKey:@"message"]];
        [regular removeProgress];
    }

}

@end
