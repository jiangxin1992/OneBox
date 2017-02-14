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
@implementation regular
{

}
static regular *_tools = nil;

+(regular *)shared
{
    @synchronized(self)
    {
        if (_tools == nil) {
            _tools = [[regular alloc] init];

        }
        return _tools;
    }
}

- (instancetype)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

+ (BOOL )isNilOrEmpty: (NSString *) str;
{
    if (str && ![str isEqualToString:@""])
    {
        return NO;
    }

    return YES;
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

+(UIAlertView *)alertTitle_Simple:(NSString *)title
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

#pragma mark ---------------- 缓存处理 -----------------
/**
 *  获取缓存大小（带单位）
 *
 *  @return 缓存大小（带单位）, 单位 M，小于1M用kb
 */
- (NSString *) getCacheSize
{
    CGFloat tempSize = [self folderSizeAtPath:[self getCachesPathWithAppendPath:nil]];

    if (tempSize / 1024.0 > 1.0)
    {
        return [NSString stringWithFormat:@"%.2f M", tempSize / (1024.0 * 1024.0)];
    }
    else
    {
        return [NSString stringWithFormat:@"%.2f kb", tempSize / 1024.0];
    }
}

/**
 *  获取指定全路径的文件总大小
 *
 *  @param folderPath 指定全路径
 *
 *  @return 总大小B
 */
- (float ) folderSizeAtPath:(NSString*) folderPath
{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath])
    {
        return 0;
    }
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];//从前向后枚举器
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        //        NSLog(@"fileName ==== %@",fileName);
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        //        NSLog(@"fileAbsolutePath ==== %@",fileAbsolutePath);
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    //    NSLog(@"folderSize ==== %lld",folderSize);
    return folderSize;
}


/**
 *  获取指定缓存文件路径
 *
 *  @param appendPath 指定子路径，为空或Nil时返回整个缓存文件夹大小
 *
 *  @return 指定缓存文件路径
 */
- (NSString *) getCachesPathWithAppendPath: (NSString *) appendPath
{
    // 获取Caches目录路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDir = [paths objectAtIndex:0];

    NSString *filePath = cachesDir;
    if (![NSString isNilOrEmpty:appendPath ])
    {
        filePath = [cachesDir stringByAppendingPathComponent:appendPath];
    }

    return filePath;
}


//计算某个文件的大小
- (long long) fileSizeAtPath:(NSString*) filePath
{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath])
    {

        //        //取得一个目录下得所有文件名
        //        NSArray *files = [manager subpathsAtPath:filePath];
        //        NSLog(@"files1111111%@ == %ld",files,files.count);
        //
        //        // 从路径中获得完整的文件名（带后缀）
        //        NSString *exe = [filePath lastPathComponent];
        //        NSLog(@"exeexe ====%@",exe);
        //
        //        // 获得文件名（不带后缀）
        //        exe = [exe stringByDeletingPathExtension];
        //
        //        // 获得文件名（不带后缀）
        //        NSString *exestr = [[files objectAtIndex:1] stringByDeletingPathExtension];
        //        NSLog(@"files2222222%@  ==== %@",[files objectAtIndex:1],exestr);

        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }

    return 0;
}


/**
 *  清理指定类型的指定路径文件(NSHomeDirectory 目录下)
 *
 *  @param fullPath 指定全路径，如果为空或者nil，表示整个NSDocumentDirectory
 *  @param extension  指定文件类型如 m4r,如果为空或者nil,表示删除所有文件
 */
- (void) clearFileWithPath: (NSString *) fullPath withExtension: (NSString *) extension
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *homePath = NSHomeDirectory();
    //    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = homePath;
    if (![NSString isNilOrEmpty:fullPath ])
    {
        filePath = fullPath;
    }

    NSArray *contents = [fileManager contentsOfDirectoryAtPath:filePath error:NULL];
    NSEnumerator *e = [contents objectEnumerator];
    NSString *filename;
    while ((filename = [e nextObject])) {

        if ([NSString isNilOrEmpty:extension ])
        {
            [fileManager removeItemAtPath:[filePath stringByAppendingPathComponent:filename] error:NULL];
        }
        else if ([[filename pathExtension] isEqualToString:extension])
        {

            [fileManager removeItemAtPath:[filePath stringByAppendingPathComponent:filename] error:NULL];
        }
    }
}
//+ (void)checkLogin
//{
//    NSLog(@"islogin%ld",[[[NSUserDefaults standardUserDefaults] objectForKey:@"islogin"] integerValue]);
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
//                [regular alertTitle_Simple:@"请查收你的邮箱"];
//            }else
//            {
//                NSString *html = operation.responseString;
//                NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
//                //        进行解析以后的操作
////                [self login_praise:data];
//                id res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//                [[NSUserDefaults standardUserDefaults] setObject:res[@"data"][@"token"] forKey:@"token"];
//                NSLog(@"token%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]);
//
//
//            }
//
//        }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            //        下载失败时，打印错误信息
//            NSLog(@"发生错误！%@",error);
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
        [regular alertTitle_Simple:[dict objectForKey:@"message"]];
        [regular removeProgress];
    }

}

+ (NSMutableAttributedString *)createAttributeString:(NSString *)str andFloat:(NSNumber*)nsKern{
    NSMutableAttributedString *attributedString =[[NSMutableAttributedString alloc] initWithString:str attributes:@{NSKernAttributeName : nsKern}];
    return attributedString;
}

@end
