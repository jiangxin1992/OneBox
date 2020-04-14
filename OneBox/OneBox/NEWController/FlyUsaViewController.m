//
//  FlyUsaViewController.m
//  OneBox
//
//  Created by 谢江新 on 15/7/8.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//
#import "OnlineProjectsViewController.h"

#import "HttpRequestManager.h"

#import "FlyUsaViewController.h"
#import "CustomTabbarController.h"

#import "ApplyFilemodel.h"

#define COLOR [UIColor colorWithRed:77/255.0 green:190/255.0 blue:217/255.0 alpha:1.0]

@interface FlyUsaViewController ()

@end

@implementation FlyUsaViewController
{
    YYAnimationIndicator *indicator;

    UIImageView *desImage;
    NSInteger _alert_num;
    UIScrollView *_Scr;
    NSArray *imageArr_must;
    NSArray *titleArr_must;
    NSArray *mustTitleArray;
    NSMutableDictionary *data_dict_must;
    NSMutableArray *buttonFly;
    UIView *mustView;
    UIView *backview_must;
    UIView *clockView;
    UIView *backFly;
    ApplyFilemodel *appleFilemodel;
    //    添加签证时间的view
    UIView *addQianBack;
    //    添加显示签证时间的view
    UIView *addShowTimeBack;
    //    面签日
    UILabel *qianTimeLabel;
    //    倒计时时间
    NSMutableArray *TimeArray;
    //    计时器
    NSTimer *requireTime;
    //    时间
    NSDate *NiceNewdate;
    NSDateComponents *compsNew;
    //   时间选择器
    UIView *SelfbottomView;
    UIDatePicker *datePick;
    NSInteger requestnum;
    BOOL isshow;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prapareData];
    [self createScrollView];
    [self createView];
    [self requestData];

}
-(void)requestStepData
{
    NSString *newsDetailUrl = [NSString stringWithFormat:@"%@/v1/user_fly_infos?token=%@",DNS,[regular getToken]];
    [HttpRequestManager GET:newsDetailUrl complete:^(NSData *data) {
        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        JXLOG(@"%@",str);
        id res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//        NSInteger step = [res[@"data"][@"step"] integerValue];
        if([res[@"code"] integerValue]==1)
        {
            requestnum++;
            if(requestnum==3)
            {
                [indicator stopAnimationWithLoadText:@"loading..." withType:YES];
            }
        }else
        {

            [indicator stopAnimationWithLoadText:@"loading..." withType:YES];
        }


    } failed:^{
        if(isshow==NO)
        {
            [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
            isshow=YES;

        }
        [indicator stopAnimationWithLoadText:@"loading..." withType:YES];
        JXLOG(@"失败");
    }];

}
-(void)getmustData
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters=@{@"token":[regular getToken]};
    [manager GET:[[NSString alloc] initWithFormat:@"%@%@",DNS,@"/v1/users/show_apply_documents"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSString *html = operation.responseString;
        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
        if([[dict objectForKey:@"code"] integerValue]==1)
        {


                requestnum++;
                if(requestnum==3)
                {
                    [indicator stopAnimationWithLoadText:@"loading..." withType:YES];
                }


            appleFilemodel=[ApplyFilemodel parsingWithJsonDataForModel:dict];
            [data_dict_must setDictionary:[[dict objectForKey:@"data"] objectForKey:@"documents"]];

            CGFloat _radius=(CGRectGetWidth(backview_must.frame)-140*_Scale*3)/2.0f;

            CGFloat heights=(CGRectGetHeight(backview_must.frame)-_radius*2-50*_Scale*2-18*_Scale)/2.0f;
            NSArray *normal_img_arr=@[
                                      @"box_progress_护照未点击",
                                      @"box_progress_签证未点击",
                                      @"box_progress_录取未点击",
                                      @"box_progress_申请表未点击"
                                      ];
            NSArray *select_img_arr=@[
                                      @"box_progress_护照",
                                      @"box_progress_签证",
                                      @"box_progress_录取",
                                      @"box_progress_申请表"
                                      ];
            for (int i=0; i<mustTitleArray.count; i++) {
                UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame=CGRectMake(140*_Scale+(_radius+140*_Scale)*(i%2),  heights+5+(158*_Scale+18*_Scale)*(i/2),_radius,_radius);
                btn.tag=100+i;
                if([[data_dict_must objectForKey:titleArr_must[i]] integerValue]==1)
                {
                    btn.selected=YES;
                }else
                {
                    btn.selected=NO;
                }

                [btn setBackgroundImage:[UIImage imageNamed:normal_img_arr[i]] forState:UIControlStateNormal];
                [btn setBackgroundImage:[UIImage imageNamed:select_img_arr[i]] forState:UIControlStateSelected];
                [backview_must addSubview:btn];
                [btn addTarget:self action:@selector(subAction:) forControlEvents:UIControlEventTouchUpInside];

                UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(btn.frame)-10, CGRectGetMaxY(btn.frame),_radius+20,50*_Scale)];
                label.textAlignment=1;
                [label setAttributedText:[regular createAttributeString:mustTitleArray[i] andFloat:@(2.0)]];
                label.textColor=_define_cailiao_text_color;
                label.font=[regular getFont:11.0f];
                [backview_must addSubview:label];

            }
        }else
        {
            [indicator stopAnimationWithLoadText:@"loading..." withType:YES];
             [[ToolManager sharedManager] alertTitle_Simple:[dict objectForKey:@"message"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(isshow==NO)
        {
            [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
            isshow=YES;

        }
        [indicator stopAnimationWithLoadText:@"loading..." withType:YES];
    }];
}
-(void)submitcailiao:(UIButton *)btn
{

    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];

    NSInteger _index=_alert_num;
    UIButton *btn1=(UIButton *)[self.view viewWithTag:_index+100];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    NSMutableDictionary *parameters=[[NSMutableDictionary alloc] init];
    [parameters setObject:[regular getToken] forKey:@"token"];
    JXLOG(@"titleArr=%@",titleArr_must);
    for (int i=0; i<titleArr_must.count; i++) {

        if(i==_index)
        {
            JXLOG(@"%@",data_dict_must);
            NSInteger _obj=0;
            if([[data_dict_must objectForKey:titleArr_must[i]] integerValue])
            {
                _obj=0;
            }else
            {
                _obj=1;
            }

            [parameters setObject:[NSNumber numberWithInteger:_obj] forKey:titleArr_must[i]];


        }else
        {

            if([data_dict_must objectForKey:titleArr_must[i]]==nil)
            {
                [parameters setObject:[NSNumber numberWithInteger:0] forKey:titleArr_must[i]];

            }else
            {
                [parameters setObject:[data_dict_must objectForKey:titleArr_must[i]] forKey:titleArr_must[i]];

            }

        }
    }
    [manager PUT:[[NSString alloc] initWithFormat:@"%@%@",DNS,@"/v1/users/update_apply_documents"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *html = operation.responseString;
        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
        if([[dict objectForKey:@"code"] integerValue]==1)
        {

//            [[UIApplication sharedApplication] setStatusBarHidden:NO];

            [[self.view viewWithTag:10000] removeFromSuperview];
            if(!btn1.selected)
            {
                [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"完成材料" WithImg:@"Prompt_完成材料" Withtype:1]];
                btn1.selected=YES;
            }else
            {
                [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"取消完成材料" WithImg:@"Prompt_取消完成材料" Withtype:1]];
                btn1.selected=NO;
            }

            NSInteger _obj=0;
            if([[data_dict_must objectForKey:titleArr_must[_index]] integerValue])
            {
                _obj=0;
            }else
            {
                _obj=1;
            }
            [data_dict_must removeObjectForKey:titleArr_must[_index]];
            [data_dict_must setObject:[NSNumber numberWithInteger:_obj] forKey:titleArr_must[_index]];


        }else
        {

            [[ToolManager sharedManager] alertTitle_Simple:[dict objectForKey:@"message"]];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
    }];
}

// 处理旋转手势
- (void) rotateView:(UIRotationGestureRecognizer *)rotationGestureRecognizer
{
    UIView *view = rotationGestureRecognizer.view;
    if (rotationGestureRecognizer.state == UIGestureRecognizerStateBegan || rotationGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformRotate(view.transform, rotationGestureRecognizer.rotation);
        [rotationGestureRecognizer setRotation:0];
    }
}

// 处理缩放手势
- (void) pinchView:(UIPinchGestureRecognizer *)pinchGestureRecognizer
{
    UIView *view = pinchGestureRecognizer.view;
    if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan || pinchGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformScale(view.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
        pinchGestureRecognizer.scale = 1;
    }
}
-(void)subAction:(UIButton *)btn
{
//    NSInteger _tag=btn.tag;
    _alert_num=btn.tag-100;

    if(btn.selected)
    {
        [self submitcailiao:btn];
    }else
    {

#pragma mark-隐藏导航状态栏
        //    蒙板
        CGFloat __w=0;
        CGFloat __h=0;

        //        _alert_num=btn.tag-100;
        __w=[[((NSDictionary *)imageArr_must[_alert_num]) objectForKey:@"w"] floatValue];
        __h=[[((NSDictionary *)imageArr_must[_alert_num]) objectForKey:@"h"] floatValue];

        if(__w>0)
        {
            [self.navigationController setNavigationBarHidden:YES animated:YES];
             [[UIApplication sharedApplication] setStatusBarHidden:YES];

            CGFloat _height=__h*ScreenWidth/__w;

            UIView *backview=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth ,ScreenHeight)];
            backview.backgroundColor=_define_backview_color;
            backview.tag=10000;
            UITapGestureRecognizer *tapges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeImage:)];
            [backview addGestureRecognizer:tapges];

            [self.view addSubview:backview];


            desImage=[[UIImageView alloc] init];
            if(__w==0)
            {
                desImage.frame=backview.frame;

            }else
            {
                if(_isPad)
                {
                    CGFloat _width=(ScreenHeight-107)*ScreenWidth/__h;
                    desImage.frame=CGRectMake((ScreenWidth-_width)/2.0f, 6, _width ,ScreenHeight-107);
                }else
                {
                    desImage.frame=CGRectMake(0, (ScreenHeight-_height)/2.0f, ScreenWidth,_height);
                }

            }


            desImage.userInteractionEnabled = YES;


            desImage.image = [UIImage imageNamed:[((NSDictionary *)imageArr_must[_alert_num]) objectForKey:@"imgname"]];

            [backview addSubview:desImage];

            // 旋转手势
            UIRotationGestureRecognizer *rotationGestureRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotateView:)];
            [desImage addGestureRecognizer:rotationGestureRecognizer];

            // 缩放手势
            UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
            [desImage addGestureRecognizer:pinchGestureRecognizer];

            UIButton *comptleView=[UIButton buttonWithType:UIButtonTypeCustom];
            [backview addSubview:comptleView];
            if(_isPad)
            {
                [comptleView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.bottom.mas_equalTo(0);
                    make.height.mas_equalTo(100);
                }];
            }else
            {
                [comptleView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(18);
                    make.right.mas_equalTo(-18);
                    make.height.mas_equalTo(90*_Scale);
                    make.bottom.mas_equalTo(-(20*_Scale+(kIPhoneX?34.f:0.f)));
                }];
            }

            comptleView.backgroundColor=[UIColor colorWithRed:91.0f/255.0f green:192.0f/255.0f blue:190.0f/255.0f alpha:1];
            [comptleView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [comptleView setTitle:@"点击完成本材料" forState:UIControlStateNormal];
            [comptleView.titleLabel setAttributedText:[regular createAttributeString:@"点击完成本材料" andFloat:@(3.0)]];
            comptleView.titleLabel.font=[regular getFont:14.0f];
            [comptleView addTarget:self action:@selector(submitcailiao:) forControlEvents:UIControlEventTouchUpInside];

        }else
        {
            //        submitcailiao
            [self submitcailiao:btn];
        }
        
    }
}
#pragma mark-下一步
- (void)NextBtnPress:(UIButton *)btn
{

    if(self.step>=4)
    {
        //        取消
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSString *Url = [NSString stringWithFormat:@"%@/v1/user_boxes/cancel?token=%@",DNS,[regular getToken]];
        NSDictionary *dict=@{@"name":@"go_us"};
        [manager POST:Url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *html = operation.responseString;
            NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
            //        进行解析以后的操作
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            if([[dict objectForKey:@"code"] integerValue]==1)
            {

                [self.navigationController popViewControllerAnimated:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"updataBox" object:nil];

            }else
            {
                [[ToolManager sharedManager] alertTitle_Simple:[dict objectForKey:@"message"]];
            }


        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
            JXLOG(@"失败");
        }];



    }else
    {
        //        完成
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSString *Url = [NSString stringWithFormat:@"%@/v1/user_boxes/%@?token=%@",DNS,[regular getUID],[regular getToken]];
        NSDictionary *dict=@{@"name":@"go_us"};
        [manager PUT:Url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *html = operation.responseString;
            NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
            //        进行解析以后的操作
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            if([[dict objectForKey:@"code"] integerValue]==1)
            {

                self.block(@"fly");
                [self.navigationController popViewControllerAnimated:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"updataBox" object:nil];

            }else
            {
                [[ToolManager sharedManager] alertTitle_Simple:[dict objectForKey:@"message"]];
            }


        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
            JXLOG(@"失败");
        }];
        
    }
}
- (void)removeImage:(UITapGestureRecognizer *)tap
{


    [self.navigationController setNavigationBarHidden:NO animated:YES];
     [[UIApplication sharedApplication] setStatusBarHidden:NO];

    [tap.view removeFromSuperview];
}
-(void)requestData
{
    if(!indicator){
        indicator = [[YYAnimationIndicator alloc] initWithFrame:CGRectZero];
        [self.view addSubview:indicator];
        [indicator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.view);
            make.width.height.mas_equalTo(40*_Scale*2);
        }];
        [indicator setLoadText:@"loading..."];
    }
    [indicator startAnimation];

    [self requestStepData];
    [self getmustData];
    [self requestTimeData];
}
#pragma mark-请求面签时间数据
-(void)requestTimeData
{
    NSString *timeUrl = [NSString stringWithFormat:@"%@/v1/user_fly_infos?token=%@",DNS,[regular getToken]];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    [manager GET:timeUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *html = operation.responseString;
        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"YYYY-MM-dd HH:mm:SS"];
        if([dict[@"code"] integerValue]==1)
        {
            requestnum++;
            if(requestnum==3)
            {
                [indicator stopAnimationWithLoadText:@"loading..." withType:YES];
            }
        }else
        {
            [indicator stopAnimationWithLoadText:@"loading..." withType:YES];
        }
#pragma mark-不为null值的时候
        if(dict[@"data"][@"fly_at"]!= [NSNull null])
        {

            NiceNewdate = [dateFormat dateFromString:dict[@"data"][@"fly_at"]];
            NSDate * nowdate= [NSDate date];

            NSTimeInterval time= [NiceNewdate timeIntervalSince1970];
            NSTimeInterval timenow= [nowdate timeIntervalSince1970];
            long jiantime=(long)(time-timenow);

            JXLOG(@"timenow=%ld,time=%ld",(long)timenow,(long)time);
            JXLOG(@"time=%ld",(long)(time-timenow));

            if(jiantime<=0)
            {
                if([[[NSUserDefaults standardUserDefaults] objectForKey:@"hangban"]isEqualToString:@"0"])
                {
                    [[ToolManager sharedManager] alertTitle_Simple:@"航班时间已过，请重新设置"];
                    NSUserDefaults *_defaults=[NSUserDefaults standardUserDefaults];
                    [_defaults setObject:@"1" forKey:@"hangban"];

                }


                //                显示添加签证时间
                addShowTimeBack.hidden=YES;
                addQianBack.hidden=NO;

            }else
            {
                JXLOG(@"time=%ld  timenow=%ld",(long)(time/(86400)),(long)(timenow/(86400)));
                //                今天为面签日
                if((((long)(time/(86400)))==((long)(timenow/(86400))))&&(time>timenow))
                {


                    UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"提示" message:@"今天要飞赴美国啦，不要忘记带好海关材料哦！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [view show];
                }else if((((long)(time/(86400))-1)==((long)(timenow/(86400))))&&(time>timenow))
                {
                    //                明天为面签日
                    UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"提示" message:@"今天要飞赴美国啦，请带好材料，祝你好运！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [view show];
                }
                //                显示当前时间
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                [dateFormat setDateFormat:@"YYYY-MM-dd HH:mm"];
//                [dateFormat setDateFormat:@"YYYY/MM/dd HH:mm"];
                NSString *nowtimeStr = [dateFormat stringFromDate:NiceNewdate];
                //                NSAttributedString * attributeString = [regular createAttributeString:nowtimeStr andFloat:@(1.0)];
                qianTimeLabel.text = nowtimeStr;
                addShowTimeBack.hidden=NO;
                addQianBack.hidden=YES;

                requireTime = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(requiredTime:) userInfo:nil repeats:YES];

                [requireTime fire];

            }

        }else
        {
            //            显示添加签证时间
            addShowTimeBack.hidden=YES;
            addQianBack.hidden=NO;
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(isshow==NO)
        {
            [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
            isshow=YES;

        }
        [indicator stopAnimationWithLoadText:@"loading..." withType:YES];
        JXLOG(@"失败");
    }];
    
}
#pragma mark-定时器
- (void)requiredTime:(NSTimer *)theTimer
{
    NSCalendar *cal = [NSCalendar currentCalendar];//定义一个NSCalendar对象
    NSDate *today = [NSDate date];//得到当前时间
    //用来得到具体的时差
    unsigned int unitFlags =  NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;

    NSDateComponents *d = [cal components:unitFlags fromDate:today toDate:NiceNewdate options:0];
    compsNew = d;

    if([d day]==0&&[d hour]==0&&[d minute]==0&&[d second]==0)
    {
        [requireTime setFireDate:[NSDate distantFuture]];
        addQianBack.hidden=NO;
        addShowTimeBack.hidden=YES;
    }else
    {
        //TimeArray
        for (int i=0; i<TimeArray.count; i++) {
            UILabel *label=(UILabel *)TimeArray[i];
            NSInteger _num=i==0?[d day]:i==1?[d hour]:i==2?[d minute]:[d second];
            NSString *str=[[NSString alloc] initWithFormat:@"%ld",(long)_num];
            [label setAttributedText:[regular createAttributeString:str andFloat:@(2.0)]];
        }
    }

    // :@"%d  %d   %d  %d",day,[d hour],[d minute],[d second]]
    
    
    
}

#pragma mark-保存时间
- (void)completeBtnPress:(UIButton *)btn
{

    NSDate *now=[NSDate date];
    NSTimeInterval time= [datePick.date timeIntervalSince1970];
    NSTimeInterval time2= [[NSDate date] timeIntervalSince1970];
    NSDate *alert_date=[NSDate dateWithTimeIntervalSince1970:time-(((long)time)%60)];
    NSTimeInterval time3= [alert_date timeIntervalSince1970];
    if(time2>time3)
    {
        //        设置为过去的时间
        [[ToolManager sharedManager] alertTitle_Simple:@"不能设置为过去的时间"];

    }else
    {
        //实例化一个NSDateFormatter对象
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //设定时间格式,这里可以设置成自己需要的格式
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSTimeZone* timeZone1 = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
        [dateFormatter setTimeZone:timeZone1];
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        unsigned int unitFlags =  NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
        NSDateComponents *comps = [gregorian components:unitFlags fromDate:now  toDate:alert_date  options:0];


        NSString *upData = [dateFormatter stringFromDate:alert_date];

        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSString *Url = [NSString stringWithFormat:@"%@/v1/user_fly_infos/:1",DNS];
        NSDictionary *paraDict =[[NSDictionary alloc] initWithObjectsAndKeys:upData,@"fly_at",[regular getToken],@"token",nil];
        [manager PUT:Url parameters:paraDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *html = operation.responseString;
            NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
            if([[dict objectForKey:@"code"]integerValue]==1)
            {
//删除航班的本地通知
                NSArray *narry=[[UIApplication sharedApplication] scheduledLocalNotifications];
                NSUInteger acount=[narry count];
                if (acount>0){
                    // 遍历找到对应nfkey和notificationtag的通知
                    for (int i=0; i<acount; i++){
                        UILocalNotification *myUILocalNotification = [narry objectAtIndex:i];
                        NSDictionary *userInfo = myUILocalNotification.userInfo;
                        NSNumber *obj = [userInfo objectForKey:@"nfkey"];
                        int mytag=[obj intValue];
                        if (mytag==3||mytag==4){
                            //                         删除本地通知
                            [[UIApplication sharedApplication] cancelLocalNotification:myUILocalNotification];
                            break;
                        }
                    }
                }
                NSTimeInterval time= [datePick.date timeIntervalSince1970];
                NSTimeInterval time2= [[NSDate date] timeIntervalSince1970];
                if(time-time2>60*60*24)
                {


                    //提前24小时的通知
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

                        //本地推送
                        UILocalNotification*notification = [[UILocalNotification alloc]init];
                        NSDate * pushDate = [NSDate dateWithTimeIntervalSinceNow:[datePick.date timeIntervalSinceNow]-60*60*24];
                        if (notification != nil) {
                            notification.fireDate = pushDate;
                            notification.timeZone = [NSTimeZone defaultTimeZone];
                            notification.repeatInterval = kCFCalendarUnitDay;
                            notification.soundName = UILocalNotificationDefaultSoundName;
                            notification.alertBody = @"航班还有24小时起飞，不要忘记带好海关材料哦！";
                            notification.applicationIconBadgeNumber = 0;

                            NSDictionary* info = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:1],@"nfkey",nil];
                            notification.userInfo = info;
                            [[UIApplication sharedApplication] scheduleLocalNotification:notification];

                        }
                    });


                }else if(time-time2>60*60*3)
                {
                    //提前三小时的通知

                    //提前三小时的通知
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

                        //本地推送
                        UILocalNotification*notification = [[UILocalNotification alloc]init];
                        NSDate * pushDate = [NSDate dateWithTimeIntervalSinceNow:[datePick.date timeIntervalSinceNow]-60*60*3];
                        if (notification != nil) {
                            notification.fireDate = pushDate;
                            notification.timeZone = [NSTimeZone defaultTimeZone];
                            notification.repeatInterval = kCFCalendarUnitDay;
                            notification.soundName = UILocalNotificationDefaultSoundName;
                            notification.alertBody = @"航班还有3小时起飞，不要忘记带好海关材料哦！";
                            notification.applicationIconBadgeNumber = 0;

                            NSDictionary* info = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:2],@"nfkey",nil];
                            notification.userInfo = info;
                            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
                            
                        }
                    });
                }

                
                NSUserDefaults *_defaults=[NSUserDefaults standardUserDefaults];
                [_defaults setObject:@"0" forKey:@"hangban"];
                qianTimeLabel.text = upData;
                compsNew = comps;
                NiceNewdate=alert_date;
                addShowTimeBack.hidden=NO;
                addQianBack.hidden=YES;
                requireTime = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(requiredTime:) userInfo:nil repeats:YES];
                [requireTime fire];

            }else
            {
                 [[ToolManager sharedManager] alertTitle_Simple:[dict objectForKey:@"message"]];
            }


        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            JXLOG(@"失败");
            [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
        }];

    }
    [UIView setAnimationDuration:1];
    SelfbottomView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 192);
    [UIView commitAnimations];
    
}
-(void)CancelBtnPress:(UIButton *)btn
{
    SelfbottomView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 192);
}

-(void)createView
{

    SelfbottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 192 + (kIPhoneX?34.f:0.f))];
    [self.view addSubview:SelfbottomView];
    UIView *completeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    completeView.backgroundColor = [UIColor whiteColor];
    [SelfbottomView addSubview:completeView];

    UIButton *cancelBtn = [regular createBtnWithRect:CGRectMake(0, 0, kScreenWidth/5, completeView.frame.size.height) WithTitle:@"取消" WithNormalStr:nil WithSelectStr:nil];
    [cancelBtn addTarget:self action:@selector(CancelBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    [completeView addSubview:cancelBtn];
    [cancelBtn setTitleColor:COLOR forState:UIControlStateNormal];
    cancelBtn.backgroundColor = [UIColor whiteColor];

    UIButton *completeBtn = [regular createBtnWithRect:CGRectMake(kScreenWidth * 4/5, 0, kScreenWidth/5, completeView.frame.size.height) WithTitle:@"完成" WithNormalStr:nil WithSelectStr:nil];
    [completeBtn addTarget:self action:@selector(completeBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    [completeView addSubview:completeBtn];
    [completeBtn setTitleColor:COLOR forState:UIControlStateNormal];
    completeBtn.backgroundColor = [UIColor whiteColor];

    datePick = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(completeView.frame), kScreenWidth, 162)];
    datePick.datePickerMode =  UIDatePickerModeDateAndTime;
    [datePick setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [SelfbottomView addSubview:datePick];
    datePick.backgroundColor = [UIColor whiteColor];


    mustView=[[UIView alloc] initWithFrame:CGRectMake(8*_Scale, 10*_Scale, CGRectGetWidth(_Scr.frame)-2*8*_Scale, 460*_Scale)];
    [_Scr addSubview:mustView];
//    mustView.backgroundColor=[UIColor redColor];
    //10 56 602 10 140
    UIView *_view_title=[[UIView alloc] initWithFrame:CGRectMake(0, 0,CGRectGetWidth(mustView.frame), 60*_Scale)];
    [mustView addSubview:_view_title];
    mustView.backgroundColor=[UIColor whiteColor];

    UIImageView *_titleview=[[ToolManager sharedManager]createTitleView:@" 海 关 材 料 样 例" WithRect:CGRectMake(28*_Scale, 0,CGRectGetWidth(_view_title.frame)-56*_Scale, 60*_Scale) WithImg:@"" WithtitleColor:_define_blue_color WithTextAlignment:1 WithFontName:(kIOSVersions>=9.0? @"":@"Helvetica Neue" ) WithFont:14.0];
    _titleview.backgroundColor=_define_cailiao_color;
    [_view_title addSubview:_titleview];


    backview_must=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_titleview.frame), CGRectGetWidth(mustView.frame), 400*_Scale)];

    [mustView addSubview:backview_must];

#pragma mark-时钟
    clockView = [[UIView alloc] initWithFrame:CGRectMake(8*_Scale, CGRectGetMaxY(mustView.frame)+10 , CGRectGetWidth(_Scr.frame) - 16*_Scale, 180*_Scale)];
    clockView.backgroundColor = [UIColor whiteColor];
    [_Scr addSubview:clockView];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(settimeAction:)];
    [clockView addGestureRecognizer:tap];
#pragma mark-添加面签时间
    addQianBack=[[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(clockView.frame), CGRectGetHeight(clockView.frame))];
    [clockView addSubview:addQianBack];
    UIImageView *addimage=[[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(clockView.frame)-25*_Scale)/2.0f, 60*_Scale, 25*_Scale, 25*_Scale)];
    addimage.image=[UIImage imageNamed:@"qianview_加"];
    [addQianBack addSubview:addimage];
    UILabel *contentlabel=[[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(addimage.frame), CGRectGetWidth(clockView.frame), CGRectGetHeight(clockView.frame)-CGRectGetMaxY(addimage.frame))];
    [addQianBack addSubview:contentlabel];
    contentlabel.textAlignment=1;
    contentlabel.textColor=_define_blue_color;
    contentlabel.font=[regular getFont:16.0f];
    [contentlabel setAttributedText:[regular createAttributeString:@"设定航班提醒" andFloat:@(10.0)]];
    addQianBack.hidden=YES;
#pragma mark-显示面签时间
    addShowTimeBack=[[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(clockView.frame), CGRectGetHeight(clockView.frame))];
    [clockView addSubview:addShowTimeBack];
    UIImageView *clock=[[UIImageView alloc] initWithFrame:CGRectMake(46*_Scale, (CGRectGetHeight(clockView.frame)-102*_Scale)/2.0f, 102*_Scale, 102*_Scale)];
    clock.image=[UIImage imageNamed:@"qianview_clock.jpg"];
    [addShowTimeBack addSubview:clock];
    UIImageView *timeback=[[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(clock.frame)+5, 5, CGRectGetWidth(clockView.frame)-CGRectGetMaxX(clock.frame)-10, CGRectGetHeight(clockView.frame)-10)];
    timeback.backgroundColor=[UIColor whiteColor];
    [addShowTimeBack addSubview:timeback];
    addShowTimeBack.hidden=YES;
    //    w216 yp16 h46
    UILabel *mianqianri=[[UILabel alloc] initWithFrame:CGRectMake(0, 16*_Scale, 216*_Scale, 46*_Scale)];
    mianqianri.textColor=_define_blue_color;
    mianqianri.font=[regular getFont:11.0f];
    mianqianri.textAlignment=2;
    [mianqianri setAttributedText:[regular createAttributeString:@"航班日" andFloat:@(2.0)]];
    [timeback addSubview:mianqianri];

    qianTimeLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(mianqianri.frame)+20*_Scale, CGRectGetMinY(mianqianri.frame), CGRectGetWidth(timeback.frame)-CGRectGetMaxX(mianqianri.frame)-20*_Scale, CGRectGetHeight(mianqianri.frame))];
    qianTimeLabel.textAlignment=0;
    qianTimeLabel.textColor=_define_blue_color;
    qianTimeLabel.font=[regular get_en_Font:11.0f];
    //    qianTimeLabel.backgroundColor=[UIColor redColor];
    [timeback addSubview:qianTimeLabel];
    //460
    //    0 150 70 113 90

    CGFloat _x_p=0;
    for (int i=0; i<4; i++) {
        CGFloat _width=i==0?150*_Scale:i==1?70*_Scale:i==2?113*_Scale:90*_Scale;
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(_x_p, CGRectGetMaxY(mianqianri.frame), _width, 50*_Scale)];

        label.textAlignment=2;
        label.font=[regular get_en_Font:20.0f];
        label.textColor=_define_blue_color;
        //        UIColor *_color=i==0?[UIColor redColor]:i==1?[UIColor greenColor]:i==2?[UIColor grayColor]:[UIColor blueColor];
        //        label.backgroundColor=_color;
        [timeback addSubview:label];
        [TimeArray addObject:label];
        UILabel *label1=[[UILabel alloc] initWithFrame:CGRectMake(_x_p, CGRectGetMaxY(label.frame), _width, 50*_Scale)];
        label1.textAlignment=2;
        label1.textColor=_define_blue_color;
        NSString *title=i==0?@"日":i==1?@"时":i==2?@"分":@"秒";
        label1.text=title;
        label1.font=[regular getFont:12.0f];
        [timeback addSubview:label1];
        _x_p+=_width;
        
    }



    UIButton *NextBtn = [regular createBtnWithRect:CGRectMake(6*_Scale, CGRectGetMaxY(clockView.frame) +10, CGRectGetWidth(_Scr.frame)-12.0f*_Scale, 70*_Scale) WithTitle:@"下 一 步" WithNormalColor:[UIColor whiteColor] WithSelectColor:nil WithTitleFont:[regular getFont:14.0]];


    NSString *nexttitle=nil;
    UIColor *nextcolor=nil;
    if(self.step>=4)
    {
        nexttitle=@"取消完成";

        nextcolor=[UIColor colorWithRed:242/255.0 green:107/255.0 blue:85/255.0 alpha:1.0];
        //
    }else
    {
        nexttitle=@"确认完成";

        nextcolor=[UIColor colorWithRed:51.0f/255.0f green:204.0f/255.0f blue:204.0f/255.0f alpha:1];
    }
    [NextBtn setBackgroundColor:nextcolor];
    JXLOG(@"%f %f",NextBtn.frame.origin.y,ScreenHeight);
    [NextBtn setTitle:nexttitle forState:UIControlStateNormal];
    NextBtn.titleLabel.font=[regular getFont:12.0f];
    [NextBtn.titleLabel setAttributedText:[regular createAttributeString:nexttitle andFloat:@(3)]];

    [NextBtn addTarget:self action:@selector(NextBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    [_Scr addSubview:NextBtn];

    _Scr.contentSize = CGSizeMake(0, CGRectGetMaxY(NextBtn.frame) + 10);


}
- (void)flyBtnClick:(UIButton *)button
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *Url = [NSString stringWithFormat:@"%@/v1/user_fly_infos/step?token=%@",DNS,[regular getToken]];
    NSDictionary *dict = @{@"step":@(button.tag - 100)};
    [manager PUT:Url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {

        JXLOG(@"%@",responseObject);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updataBox" object:nil];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        JXLOG(@"失败");
        [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
    }];

    for(int i = 0; i < buttonFly.count;i ++)
    {
        UIButton *btn = buttonFly[i];
        if (btn.tag == button.tag) {
            btn.selected = YES;
        }
        else
        {
            btn.selected = NO;
        }
        if (btn.tag > button.tag - 100 + 1) {
            //            [btn setBackgroundImage:[UIImage imageNamed:@"抵达"] forState:UIControlStateNormal];
        }
    }
    if(button.tag < 103){
//        UIButton *nextBtn = buttonFly[button.tag - 100 + 1];
        //        [nextBtn setBackgroundImage:[UIImage imageNamed:@"接到"] forState:UIControlStateNormal];
    }
}
- (BOOL)isAllowedNotification {
    //iOS8 check if user allow notification
    double version = [[UIDevice currentDevice].systemVersion doubleValue];//判定系统版本。

    if (version>=8.0f) {// system is iOS8
         #if version<8
        UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if (UIUserNotificationTypeNone != setting.types) {
            return YES;
        }
        #endif
    } else {//iOS7
        UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        if(UIRemoteNotificationTypeNone != type)
            return YES;
    }

    return NO;
}

#pragma mark-弹出时间选择器
-(void)settimeAction:(UIGestureRecognizer *)ges
{

    BOOL _b=[self isAllowedNotification];
    //    [[ToolManager sharedManager] alertTitle_Simple:[[NSString alloc] initWithFormat:@"%d",_b]];
    if(_b)
    {

        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1];
        SelfbottomView.frame = CGRectMake(0, kScreenHeight - 192, kScreenWidth, 192);
        [UIView commitAnimations];

    }else
    {
        [[ToolManager sharedManager] alertTitle_Simple:@"请先开启推送开关"];
    }
}
-(void)createScrollView
{
    _Scr = [[UIScrollView alloc] initWithFrame:CGRectMake(0*_Scale, 0*_Scale, kScreenWidth, kScreenHeight)];
    _Scr.showsVerticalScrollIndicator=NO;
    [self.view addSubview:_Scr];
}

-(void)prapareData
{
    isshow=NO;
    requestnum=0;
    self.view.backgroundColor = _define_backview_color;
    self.navigationItem.titleView=[regular returnNavView:@"飞赴美国" withmaxwidth:230];
    UIBarButtonItem *_btn=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回箭头"] style:UIBarButtonItemStylePlain target:self action:@selector(popviewAction)];
    self.navigationItem.leftBarButtonItem=_btn;

    TimeArray=[[NSMutableArray alloc] init];
    
    imageArr_must = @[
                      @{@"imgname":@"Applyfile_护照.jpg",
                        @"w":[NSNumber numberWithInt:960],
                        @"h":[NSNumber numberWithInt:1400]
                        },
                      @{@"imgname":@"f1 visa .jpg",
                        @"w":[NSNumber numberWithInt:960],
                        @"h":[NSNumber numberWithInt:1400]
                        },
                      @{@"imgname":@"I20.jpg",
                        @"w":[NSNumber numberWithInt:960],
                        @"h":[NSNumber numberWithInt:1400]
                        },
                      @{@"imgname":@"申报单.jpg",
                        @"w":[NSNumber numberWithInt:960],
                        @"h":[NSNumber numberWithInt:1400]
                        }
                      ];
    titleArr_must=@[@"passport",@"f1_visa",@"a120",@"declaration_form"];
    mustTitleArray=@[@"护照",@"F1签证",@"I20表",@"申报单"];
    
    data_dict_must=[[NSMutableDictionary alloc] init];

    buttonFly = [[NSMutableArray alloc] init];

}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"FlyUsaViewController"];
    [[CustomTabbarController sharedManager] tabbarHide];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"FlyUsaViewController"];
}
-(void)popviewAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
