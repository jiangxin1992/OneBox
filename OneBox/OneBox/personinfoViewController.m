//
//  personinfoViewController.m
//  OneBox
//
//  Created by 谢江新 on 15/10/21.
//  Copyright © 2015年 谢江新. All rights reserved.
//

#import "personinfoViewController.h"

#import "QiniuSDK.h"
#import <CoreLocation/CoreLocation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import "UIImageView+AFNetworking.h"
#import "HttpRequestManager.h"

#import "countryViewController.h"
#import "statechooseViewController.h"
#import "citychooseViewController.h"

#import "MyInfo.h"

@interface personinfoViewController ()<UIAlertViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>

@end

@implementation personinfoViewController
{
//    国家城市id
    NSMutableString *country_id;
    NSMutableString *state_id;
    NSMutableString *city_id;


    NSString *upToken;
    MyInfo *info;
    UIScrollView *_scrollview;
    UIView *backview;
    UIImageView *icon;
    UIAlertView *alertviewalbum;
    UIAlertView *alertviewCamera;
    UIButton *diqu;

}
- (void) registerForKeyboardNotifications

{

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

}

//键盘将要隐藏时调用的方法
//将底部的评论 view，根据键盘的变化而变化
- (void)keyboardWillHide:(NSNotification *)not
{

    NSDictionary *userInfo = [not userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
//    int height = keyboardRect.size.height;

        NSDictionary *dict = not.userInfo;

        //取到键盘动画上浮的时间
        NSString *timeStr = [dict objectForKey:@"UIKeyboardAnimationDurationUserInfoKey"];


        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:[timeStr floatValue]];
         _scrollview.frame=CGRectMake(0, 0, ScreenWidth, ScreenHeight+kTabBarHeight);
        [UIView commitAnimations];


}
//键盘将要出现时调用的方法
//将底部的评论 view，根据键盘的变化而变化
- (void)keyboardWillShow:(NSNotification *)not
{
    NSDictionary *userInfo = [not userInfo];

    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGFloat height = CGRectGetHeight(_scrollview.frame)-(214+70)-keyboardRect.size.height;
    JXLOG(@"%f",keyboardRect.size.height);

    UITextView *text0=(UITextView *)[self.view viewWithTag:100];
    UITextView *text1=(UITextView *)[self.view viewWithTag:103];
    UITextView *text2=(UITextView *)[self.view viewWithTag:104];


    if(kIPhone4s)
    {

        if(text1.isFirstResponder)
        {
            height = 120;

        }else if(text2.isFirstResponder)
        {
            height = 150;
        }

    }else
    {
        if(text1.isFirstResponder)
        {
            height = CGRectGetHeight(_scrollview.frame)-(214+70)-keyboardRect.size.height-kTabBarHeight;

        }else if(text2.isFirstResponder)
        {
            height = CGRectGetHeight(_scrollview.frame)-(184+70)-keyboardRect.size.height-kTabBarHeight;
        }

    }


    if(!text0.isFirstResponder)
    {
        NSDictionary *dict = not.userInfo;

                //    //取到键盘动画上浮的时间
        NSString *timeStr = [dict objectForKey:@"UIKeyboardAnimationDurationUserInfoKey"];

        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:[timeStr floatValue]];
        _scrollview.frame=CGRectMake(CGRectGetMinX(_scrollview.frame),CGRectGetMinY(_scrollview.frame)-height-10, CGRectGetWidth(_scrollview.frame), CGRectGetHeight(_scrollview.frame));
        [UIView commitAnimations];
    }


}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
     if(alertView==alertviewalbum||alertView==alertviewCamera)
    {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]])
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
        
    }

}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            //相机:先判断是否支持相机,然后询问用户是否同意使用
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                //打开相机
                [self loadImageWithType:UIImagePickerControllerSourceTypeCamera];
            }
            else
            {
                JXLOG(@"不能打开相机");
            }

        }
            break;
        case 1:
        {
            //相册
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                [self loadImageWithType:UIImagePickerControllerSourceTypePhotoLibrary];
            }
            else
            {
                JXLOG(@"无法打开相册");
            }


        }
            break;

        default:
            break;
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //找出图片

    UIImage *originImage = info[UIImagePickerControllerEditedImage];

    icon.image = originImage;

    [picker dismissViewControllerAnimated:YES completion:nil];

    NSData *data1 = UIImageJPEGRepresentation(originImage, 1.0f);
    QNUploadManager *upManager = [[QNUploadManager alloc] init];

    [upManager putData:data1 key:nil token:upToken
              complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                  [self uploadImage:resp[@"key"]];
              } option:nil];


}
- (void)uploadImage:(NSString *)key
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *Url = [NSString stringWithFormat:@"%@/v1/users/%@?token=%@",DNS,[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]];
    NSDictionary *dict = @{@"avatar":key};
    [manager PUT:Url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSString *html = operation.responseString;
        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
        if([[dict objectForKey:@"code"] integerValue]==1)
        {
            //                [[ToolManager sharedManager] alertTitle_Simple:@"上传成功"];

            NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
            //将islogin存入defaults中
            //                NSDictionary *_dict=[dict objectForKey:@"data"];
            NSString *imageurl=nil;
            if([defaults objectForKey:@"avatar"]==[NSNull null])
            {
                imageurl=@"0";
            }else
            {
                imageurl=[[NSString alloc] initWithFormat:@"http://7ximo7.com1.z0.glb.clouddn.com/%@",key];
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
            //                [[ToolManager sharedManager] createSuccessProgress];


            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateImg" object:[[NSDictionary alloc] initWithObjectsAndKeys:((UITextField *)[self.view viewWithTag:100]).text,@"name",info.area,@"loc",((UITextField *)[self.view viewWithTag:102]).text,@"sign", nil]];

        }else
        {
             [[ToolManager sharedManager] alertTitle_Simple:[dict objectForKey:@"message"]];
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
        JXLOG(@"失败");
    }];

}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picke
{
    [picke dismissViewControllerAnimated:YES completion:nil];
}


-(void)loadImageWithType:(UIImagePickerControllerSourceType)type
{
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];

    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];

    if (author == kCLAuthorizationStatusRestricted || author ==kCLAuthorizationStatusDenied){

        alertviewCamera=[[UIAlertView alloc] initWithTitle:@"" message:@"请在iPhone的 设置－隐私－相机 选项中，允许留美盒子访问你的相册。" delegate:self cancelButtonTitle:@"好的" otherButtonTitles: nil];
        alertviewCamera.delegate=self;
        [alertviewCamera show];
    }else if(authStatus == ALAuthorizationStatusRestricted || authStatus == ALAuthorizationStatusDenied)
    {
        alertviewalbum=[[UIAlertView alloc] initWithTitle:@"" message:@"请在iPhone的 设置－隐私－相机 选项中，允许留美盒子访问你的相机。" delegate:self cancelButtonTitle:@"好的" otherButtonTitles: nil];
        alertviewalbum.delegate=self;
        [alertviewalbum show];
    }else
    {
        //创建图片选取器
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        //设置选取器类型
        picker.sourceType = type;
        //编辑
        picker.allowsEditing = YES;
        if ([picker.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
            NSArray *list=self.navigationController.navigationBar.subviews;
            for (id obj in list) {
                if ([obj isKindOfClass:[UIImageView class]]) {
                    UIImageView *imageView=(UIImageView *)obj;
                    NSArray *list2=imageView.subviews;
                    for (id obj2 in list2) {
                        if ([obj2 isKindOfClass:[UIImageView class]]) {
                            UIImageView *imageView2=(UIImageView *)obj2;
                            imageView2.hidden=YES;
                        }
                    }
                }
            }
        }
        picker.navigationBar.barTintColor =[UIColor colorWithRed:70.0f/255.0f green:195.0f/255.0f blue:247.0f/255.0f alpha:1];
        UIColor * color = [UIColor whiteColor];

        //    2    //这里我们设置的是颜色，还可以设置shadow等，具体可以参见api

        NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:UITextAttributeTextColor];

        //    3    //大功告成

        picker.navigationBar.titleTextAttributes = dict;


        //弹出
        [self presentViewController:picker animated:YES completion:nil];
        
    }
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];

    [self prepare];
    [self prepareToken];
    [self getData];
    [self UIConfig];
//    [self bangdingUIConfig];
    [self registerForKeyboardNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(location_change:) name:@"location_change" object:nil];
    // Do any additional setup after loading the view from its nib.
}

-(void)location_change:(NSNotification *)not
{

    [country_id setString:@""];
    [state_id setString:@""];
    [city_id setString:@""];
    NSDictionary *dict=not.object;
    NSString *country=nil;
    NSString *state=nil;
    NSString *city=nil;
    NSArray *statearr=nil;
    NSArray *cityarr=nil;
    NSString* path = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"json"];

    NSData *theData = [NSData dataWithContentsOfFile:path];
    NSArray *countryarr = [[NSJSONSerialization JSONObjectWithData:theData options:NSJSONReadingMutableContainers error:nil] objectForKey:@"CountryRegion"];

    if([dict objectForKey:@"country_code"]!=nil)
    {
        NSString * countrycode1=nil;
        NSString * countrycode2=nil;
        if([[dict objectForKey:@"country_code"] isKindOfClass:[NSNumber class]])
        {
            countrycode1=[[NSString alloc] initWithFormat:@"%ld",[[dict objectForKey:@"country_code"] longValue]];
        }else
        {
            countrycode1=[dict objectForKey:@"country_code"];
        }

        for (NSDictionary *_dict in countryarr) {
            if([[_dict objectForKey:@"code"] isKindOfClass:[NSNumber class]])
            {
                countrycode2=[[NSString alloc] initWithFormat:@"%ld",[[_dict objectForKey:@"code"] longValue]];
            }else
            {
                countrycode2=[_dict objectForKey:@"code"];
            }

            if([countrycode2 isEqualToString:countrycode1])
            {
                country=[_dict objectForKey:@"name"];
                [country_id setString:[[NSString alloc] initWithFormat:@"%ld",[[_dict objectForKey:@"id"] longValue]]];

                if([[_dict objectForKey:@"State"] isKindOfClass:[NSArray class]])
                {
                    if([[_dict objectForKey:@"State"] count])
                    {
                        if([[[_dict objectForKey:@"State"] objectAtIndex:0] isKindOfClass:[NSDictionary class]])
                        {
                            NSArray *keya=[[[_dict objectForKey:@"State"] objectAtIndex:0] allKeys];
                            if(keya.count>1)
                            {
                                statearr=[_dict objectForKey:@"State"];

                            }else
                            {
                                statearr=[[[_dict objectForKey:@"State"] objectAtIndex:0] objectForKey:@"City"];
                            }



                        }else
                        {
                            statearr=[_dict objectForKey:@"State"];

                        }

                    }else
                    {
                        statearr=[_dict objectForKey:@"State"];

                    }
                    JXLOG(@"%@",statearr);

                }else
                {
                    statearr=[[NSArray alloc] init];
                }
                break;
            }
        }

    }
    JXLOG(@"%@",statearr);
    JXLOG(@"%@",country);

    if(statearr.count>0)
    {
        NSString * statecode1=nil;
        NSString * statecode2=nil;
        if([[dict objectForKey:@"state_code"] isKindOfClass:[NSNumber class]])
        {
            statecode1=[[NSString alloc] initWithFormat:@"%ld",[[dict objectForKey:@"state_code"] longValue]];
        }else
        {
            statecode1=[dict objectForKey:@"state_code"];
        }
        for (NSDictionary *_dict in statearr) {

            if([[_dict objectForKey:@"code"] isKindOfClass:[NSNumber class]])
            {
                statecode2=[[NSString alloc] initWithFormat:@"%ld",[[_dict objectForKey:@"code"] longValue]];
            }else
            {
                statecode2=[_dict objectForKey:@"code"];
            }
            if([statecode2 isEqualToString:statecode1])
            {
                state=[_dict objectForKey:@"name"];
                [state_id setString:[[NSString alloc] initWithFormat:@"%ld",[[_dict objectForKey:@"id"] longValue]]];




                if([[_dict objectForKey:@"City"] isKindOfClass:[NSArray class]])
                {
                    cityarr=[_dict objectForKey:@"City"];
                    JXLOG(@"1111");
                }else
                {
                    cityarr=[[NSArray alloc] init];
                }
                break;
            }


        }

    }
    JXLOG(@"%@",cityarr);
    JXLOG(@"%@",state);

    if(cityarr.count>0)
    {
        NSString * citycode1=nil;
        NSString * citycode2=nil;
        if([[dict objectForKey:@"city_code"]isKindOfClass:[NSNumber class]])
        {
            citycode1=[[NSString alloc] initWithFormat:@"%ld",[[dict objectForKey:@"city_code"] longValue]];
        }else
        {
            citycode1=[dict objectForKey:@"city_code"];
        }
        for (NSDictionary *_dict in cityarr) {
            if([[_dict objectForKey:@"code"] isKindOfClass:[NSNumber class]])
            {
                citycode2=[[NSString alloc] initWithFormat:@"%ld",[[_dict objectForKey:@"code"] longValue]];
            }else
            {
                citycode2=[_dict objectForKey:@"code"];
            }
            if([citycode2 isEqualToString:citycode1])
            {
                city=[_dict objectForKey:@"name"];
                [city_id setString:[[NSString alloc] initWithFormat:@"%ld",[[_dict objectForKey:@"id"] longValue]]];

                break;
            }

        }
    }
    JXLOG(@"%@",city);

//    country_id,state_id,city_id;


//    UILabel *label=(UILabel *)[self.view viewWithTag:501];
    NSString *content=nil;

    if(country==nil&&state==nil&&city==nil)
    {
        content=@"";
    }else
        if(country!=nil&&state==nil&&city==nil)
        {
            content=country;
        }else
            if(country!=nil&&state!=nil&&city==nil)
            {
                content=[[NSString alloc] initWithFormat:@"%@，%@",state,country];
            }else
                if(country!=nil&&state!=nil&&city!=nil)
                {
                    content=[[NSString alloc] initWithFormat:@"%@，%@",city,country];
                }
    
    [(UILabel *)[self.view viewWithTag:501] setAttributedText:[regular createAttributeString:content andFloat:@(1.0)] ];
}
-(void)createScrollView
{
    _scrollview=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight+kTabBarHeight)];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disjianpan)];
    [_scrollview addGestureRecognizer:tap];
    [self.view addSubview:_scrollview];
//    _scrollview.backgroundColor=[UIColor redColor];
    _scrollview.contentSize=CGSizeMake(ScreenWidth, ScreenHeight-64);
}
-(void)disjianpan
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}
-(void)UIConfig
{

    [self createScrollView];
    backview=[[UIView alloc] initWithFrame:CGRectMake(20*_Scale, 140*_Scale, ScreenWidth-20*_Scale*2, 480*_Scale)];
    backview.backgroundColor=[UIColor whiteColor];
    [_scrollview addSubview:backview];

    [self createHeadimg];
    CGFloat _y_p=110*_Scale;
    for (int j=0; j<2; j++) {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        [backview addSubview:btn];
        btn.frame=CGRectMake(((CGRectGetWidth(backview.frame)-68*_Scale-68*_Scale*2)/2.0f)+(68+68)*_Scale*j, _y_p, 68*_Scale, 68*_Scale);

        NSString *normalImg=j==0?@"screenShcool_女校未点击":@"screenShcool_男校未选中";
        NSString *selectImg=j==0?@"screenShcool_女校":@"screenShcool_男校";
        [btn setBackgroundImage:[UIImage imageNamed:normalImg] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:selectImg] forState:UIControlStateSelected];
        btn.selected=NO;
        btn.tag=200+j;
        [btn addTarget:self action:@selector(chooseSex:) forControlEvents:UIControlEventTouchUpInside];
    }
    _y_p+=85*_Scale+68*_Scale;
    CGFloat _height=55*_Scale;
    for (int i=0; i<3; i++) {


        if(i==1)
        {
            diqu=[UIButton buttonWithType:UIButtonTypeCustom];
            diqu.frame=CGRectMake((CGRectGetWidth(backview.frame)-440*_Scale)/2.0f, _y_p, 440*_Scale, _height);
//            diqu.backgroundColor=[UIColor redColor];
            diqu.tag=100+i;

            [backview addSubview:diqu];
            UILabel *diqulabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(diqu.frame), CGRectGetHeight(diqu.frame))];
            diqulabel.textAlignment=1;
            diqulabel.textColor=[UIColor colorWithRed:128.0f/255.0f green:128.0f/255.0f blue:128.0f/255.0f alpha:1];
            diqulabel.font=[regular getFont:11.0f];
            diqulabel.tag=500+i;
            [diqu addSubview:diqulabel];

            [diqu addTarget:self action:@selector(chooseCity:) forControlEvents:UIControlEventTouchUpInside];
            UIView *viewdibu=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(diqu.frame)-1*_Scale, CGRectGetWidth(diqu.frame), 1*_Scale)];
            viewdibu.backgroundColor=[UIColor colorWithRed:225.0f/255.0f green:225.0f/255.0f blue:225.0f/255.0f alpha:1];
            [diqu addSubview:viewdibu];

            UIImageView *icon_loc=[[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetHeight(diqu.frame)-18*_Scale)/2.0f, (CGRectGetHeight(diqu.frame)-18*_Scale)/2.0f, 18*_Scale, 18*_Scale)];
            icon_loc.userInteractionEnabled=YES;
            icon_loc.image=[UIImage imageNamed:@"setting_定位"];
            [diqu addSubview:icon_loc];


        }else
        {
            UITextField *textfield=[[UITextField alloc] initWithFrame:CGRectMake((CGRectGetWidth(backview.frame)-440*_Scale)/2.0f, _y_p, 440*_Scale, _height)];

            textfield.tag=100+i;
            [backview addSubview:textfield];
            UIView *viewdibu=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(textfield.frame)-1*_Scale, CGRectGetWidth(textfield.frame), 1*_Scale)];
            if(i==0)
            {
                viewdibu.backgroundColor=[UIColor colorWithRed:225.0f/255.0f green:225.0f/255.0f blue:225.0f/255.0f alpha:1];
            }else
            {
                viewdibu.backgroundColor=[UIColor colorWithRed:225.0f/255.0f green:225.0f/255.0f blue:225.0f/255.0f alpha:1];
            }

            if(i==3||i==4)
            {
                JXLOG(@"%f",CGRectGetMaxY(textfield.frame));


            }
            [textfield addSubview:viewdibu];

            textfield.returnKeyType=UIReturnKeyDone;
            textfield.placeholder=i==0?@"昵  称":i==1?@"":@"个  性  签  名";
            [textfield setValue:[UIColor colorWithRed:200.0f/255.0f green:200.0f/255.0f blue:200.0f/255.0f alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
            [textfield setValue:[UIFont boldSystemFontOfSize:10] forKeyPath:@"_placeholderLabel.font"];
            textfield.font=[regular getFont:11.0f];
            textfield.delegate=self;
            textfield.textAlignment=1;
            textfield.textColor=[UIColor colorWithRed:128.0f/255.0f green:128.0f/255.0f blue:128.0f/255.0f alpha:1];
            textfield.clearButtonMode=UITextFieldViewModeWhileEditing;


        }
        _y_p+=_height+6*_Scale;
    }


    _scrollview.contentSize=CGSizeMake(CGRectGetWidth(_scrollview.frame), 600*_Scale);
}
-(void)chooseCity:(UIButton *)btn
{
    countryViewController *cou=[[countryViewController alloc] init];
    cou.person=self;
    [self.navigationController pushViewController:cou animated:YES];

}
-(void)chooseSex:(UIButton *)btn
{
    if(btn.tag==200)
    {
        btn.selected=YES;
        ((UIButton *)[self.view viewWithTag:201]).selected=NO;
    }else if(btn.tag==201)
    {
        btn.selected=YES;
        ((UIButton *)[self.view viewWithTag:200]).selected=NO;

    }

}
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];
//    if(theTextField==password)
//    {
//
//        [self sumbit_action:[UIButton new]];
//    }
//    [theTextField resignFirstResponder];
    return YES;
}
- (void)prepareToken
{
    NSString *achieveToken = [NSString stringWithFormat:@"%@/v1/uptoken",DNS];
    [HttpRequestManager GET:achieveToken complete:^(NSData *data) {
        id res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        upToken = res[@"uptoken"];

    } failed:^{
        JXLOG(@"失败");
    }];

}
-(void)createHeadimg
{
    NSUserDefaults *dict=[NSUserDefaults standardUserDefaults];
    NSData *headImg_data=[dict objectForKey:@"userImage"];
    icon.backgroundColor=[UIColor clearColor];
    icon = [[UIImageView alloc] initWithImage:[UIImage imageWithData:headImg_data]];
    icon.frame=CGRectMake((ScreenWidth-154*_Scale)/2.0f, 67*_Scale, 154*_Scale, 154*_Scale);
    icon.userInteractionEnabled = YES;
    icon.layer.masksToBounds = YES;
    icon.layer.cornerRadius = icon.frame.size.width/2.0;
//    icon.layer.borderColor = [[UIColor whiteColor] CGColor];
//    icon.layer.borderWidth = 2.0f;

    UIView *zhegai=[[UIView alloc] initWithFrame:CGRectMake(-1,-1 , CGRectGetWidth(icon.frame)+2, CGRectGetWidth(icon.frame)+2)];
    zhegai.backgroundColor=[UIColor clearColor];
    zhegai.layer.masksToBounds=YES;
    zhegai.layer.cornerRadius=CGRectGetWidth(zhegai.frame)/2.0f;
    zhegai.layer.borderColor = [_define_head_color CGColor];
    zhegai.layer.borderWidth = 4.0f;
    [icon addSubview:zhegai];


    [_scrollview addSubview:icon];
    UIButton *updateIcon = [UIButton buttonWithType:UIButtonTypeCustom];
    [updateIcon setImage:[UIImage imageNamed:@"修改头像"] forState:UIControlStateNormal];
    if(_isPad)
    {
        updateIcon.frame = CGRectMake(CGRectGetMaxX(icon.frame)-34, CGRectGetMinY(icon.frame)+20, 20 , 20 );

    }else
    {
        updateIcon.frame = CGRectMake(105 + 70 * __Scale+4, 35, 20 * __Scale, 20 * __Scale);

    }

    [updateIcon addTarget:self action:@selector(detailView:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollview addSubview:updateIcon];
    UITapGestureRecognizer *tap1=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(detailView:)];
    [icon addGestureRecognizer:tap1];



}
-(void)detailView:(UIGestureRecognizer *)sender
{

    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册选择", nil];

    [sheet showInView:self.view];
    
}
-(void)getData
{
    NSString *url = [NSString stringWithFormat:@"%@/v1/users/%@?token=%@",DNS,[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]];
    [HttpRequestManager GET:url complete:^(NSData *data) {
        id res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *_dict=(NSDictionary*)res;
        if([[_dict objectForKey:@"code"] integerValue]==1)
        {
            info = [MyInfo parsingWithJsonDataForModel:data];
            [icon setImageWithURL:[NSURL URLWithString:info.avatar]];

            if(info.gender==1)
            {
                ((UIButton *)[self.view viewWithTag:201]).selected=YES;
                ((UIButton *)[self.view viewWithTag:200]).selected=NO;
            }else if(info.gender==2)
            {
                ((UIButton *)[self.view viewWithTag:200]).selected=YES;
                ((UIButton *)[self.view viewWithTag:201]).selected=NO;
            }else if(info.gender==0)
            {
                ((UIButton *)[self.view viewWithTag:200]).selected=NO;
                ((UIButton *)[self.view viewWithTag:201]).selected=NO;
            }


            [(UITextField *)[self.view viewWithTag:100] setAttributedText:[regular createAttributeString:info.username andFloat:@(1.0f)]];

            [(UITextField *)[self.view viewWithTag:102] setAttributedText:[regular createAttributeString:info.mark andFloat:@(1.0f)]];


            NSString *loc=info.area;


            [(UILabel *)[self.view viewWithTag:501] setAttributedText:[regular createAttributeString:loc andFloat:@(1.0)] ];


            NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
            NSData *imageData1 = UIImageJPEGRepresentation(icon.image, 1.0);
            [defaults setObject:imageData1 forKey:@"userImage"];


            NSString *_image_type=nil;
            NSString *_image_url=nil;
            if([info.avatar isEqualToString:@""])
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
                [defaults setObject:[NSData dataWithContentsOfURL:[NSURL URLWithString: info.avatar]]forKey:@"userImage"];
                _image_type=@"1";
                _image_url=info.avatar;
            }

            [defaults setObject:[[NSDictionary alloc] initWithObjectsAndKeys:_image_type,@"type",_image_url,@"image",nil] forKey:@"userImageurl"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateImg" object:[[NSDictionary alloc] initWithObjectsAndKeys:((UITextField *)[self.view viewWithTag:100]).text,@"name",info.area,@"loc",((UITextField *)[self.view viewWithTag:102]).text,@"sign", nil]];


        }else
        {
             [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:[_dict objectForKey:@"message"] WithImg:@"Prompt_网络出错白色" Withtype:1]];
        }
        
    } failed:^{
        [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];

    }];
}
-(void)prepare
{
    UIBarButtonItem *_btn=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回箭头"] style:UIBarButtonItemStylePlain target:self action:@selector(popviewAction)];
    self.navigationItem.leftBarButtonItem=_btn;
    self.navigationItem.titleView=[regular returnNavView:@"关于我" withmaxwidth:180];
    self.view.backgroundColor=_define_backview_color;
    UIButton*btn2=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44*2*_Scale, 44*_Scale)];
    [btn2 setTitle:@"完成" forState:UIControlStateNormal];
    //    btn2.backgroundColor=[UIColor redColor];
    [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn2.titleLabel.font=(kIOSVersions>=9.0? [UIFont systemFontOfSize:13.0f]:[UIFont fontWithName:@"Helvetica Neue" size:13.0f]);
    btn2.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
    [btn2 addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barright=[[UIBarButtonItem alloc] initWithCustomView:btn2];
    self.navigationItem.rightBarButtonItem=barright;
    country_id=[[NSMutableString alloc] initWithString:@""];
    state_id=[[NSMutableString alloc] initWithString:@""];
    city_id=[[NSMutableString alloc] initWithString:@""];
}
-(void)popviewAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];

    return [emailTest evaluateWithObject:candidate];
}
-(void)sendAction
{

    NSString *string2 = ((UITextField *)[self.view viewWithTag:100]).text;
    const char *chars2 = [string2 cStringUsingEncoding:NSUTF8StringEncoding];
    NSInteger _leng2=0;
    for (int i = 0; i < strlen(chars2); i++) {
        printf("%x", chars2[i]);
        _leng2+=sizeof(chars2[i]);
    }

    NSString *string3 = ((UITextField *)[self.view viewWithTag:102]).text;
    const char *chars3 = [string3 cStringUsingEncoding:NSUTF8StringEncoding];
    NSInteger _leng3=0;
    for (int i = 0; i < strlen(chars3); i++) {
        printf("%x", chars3[i]);
        _leng3+=sizeof(chars3[i]);
    }
    if(_leng2>30)
    {
        [[ToolManager sharedManager] alertTitle_Simple:@"昵称最多不超过10个汉字"];

    }else if(_leng3>36)
    {
        [[ToolManager sharedManager] alertTitle_Simple:@"签名最多不超过12个汉字"];
    }else
    {
        NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];

        [defaults setObject:((UITextField *)[self.view viewWithTag:100]).text forKey:@"username"];
#pragma mark-保存用户信息

        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSString *Url = [NSString stringWithFormat:@"%@/v1/users/%@?token=%@",DNS,[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]];
        NSInteger gender=0;

        if(((UIButton *)[self.view viewWithTag:200]).selected==NO&&((UIButton *)[self.view viewWithTag:201]).selected==NO)
        {
            gender=0;
        }else if(((UIButton *)[self.view viewWithTag:200]).selected==YES)
        {
            gender=2;
        }else if(((UIButton *)[self.view viewWithTag:201]).selected==YES)
        {
            gender=1;
        }

//        country_id,state_id,city_id
        NSDictionary *dict = @{@"username":((UITextField *)[self.view viewWithTag:100]).text,@"mark":((UITextField *)[self.view viewWithTag:102]).text,@"gender":[NSNumber numberWithInteger:gender],@"city":((UILabel *)[self.view viewWithTag:501]).text,@"country_id":country_id,@"state_id":state_id,@"city_id":city_id};


        [manager PUT:Url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *html = operation.responseString;
            NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];

            if([[dict objectForKey:@"code"] integerValue]==1)
            {
                [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"成功提交修改" WithImg:@"Prompt_账号修改" Withtype:1]];

                [[NSNotificationCenter defaultCenter] postNotificationName:@"updateImg" object:[[NSDictionary alloc] initWithObjectsAndKeys:((UITextField *)[self.view viewWithTag:100]).text,@"name",((UILabel *)[self.view viewWithTag:501]).text,@"loc",((UITextField *)[self.view viewWithTag:102]).text,@"sign", nil]];

            }else
            {
                 [[ToolManager sharedManager] alertTitle_Simple:[dict objectForKey:@"message"]];
            }
            [[ToolManager sharedManager] removeProgress];

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            JXLOG(@"失败");

            [[ToolManager sharedManager] removeProgress];
            [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
        }];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillDisappear:(BOOL)animated
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"personinfoViewController"];
}
-(void)viewWillAppear:(BOOL)animated
{
//
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"personinfoViewController"];

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
