//
//  QianViewController.m
//  OneBox
//
//  Created by 谢江新 on 15/7/7.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import "QianViewController.h"

#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

#import "OnlineProjectsViewController.h"
#import "CustomTabbarController.h"

#import "MyPoint.h"

#define COLOR [UIColor colorWithRed:77/255.0 green:190/255.0 blue:217/255.0 alpha:1.0]

@interface QianViewController ()<MKMapViewDelegate,UIActionSheetDelegate>

@end

@implementation QianViewController
{
    YYAnimationIndicator *indicator;
    CLLocationCoordinate2D coordinate;
     NSInteger telStr;
    UIScrollView *_scrollView;
//    地图
    MKMapView *mapView;
//    存放按钮
    NSMutableArray *btnArr;
//地址
    NSMutableArray *address;
//    电话
    NSMutableArray *telarr;
//    设定时间view
    UIView *clockView;
//     地址view
    UIView *addressview;
    UILabel *addressLabel;
//    电话label
    UILabel *tellabel;
//    sheetview
    UIActionSheet *sheet_tel;
    UIActionSheet *sheet_loc;
//    经纬度
    NSMutableArray *Latitude;
    NSMutableArray *longitude;
//当前修改的num
    NSInteger _alert_num;
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
    [self createScrollview];
    [self createView];
    [self requestData];
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
        unsigned int unitFlags = NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
        NSDateComponents *comps = [gregorian components:unitFlags fromDate:now  toDate:alert_date  options:0];

        NSString *upData = [dateFormatter stringFromDate:alert_date];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSString *Url = [NSString stringWithFormat:@"%@/v1/user_boxes/go_visa?token=%@",DNS,[regular getToken]];
        NSDictionary *dict = @{@"go_visa_at":upData};
        [manager POST:Url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *html = operation.responseString;
            NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
            if([[dict objectForKey:@"code"]integerValue]==1)
            {
                NSArray *narry=[[UIApplication sharedApplication] scheduledLocalNotifications];
                NSUInteger acount=[narry count];
                if (acount>0){
                    // 遍历找到对应nfkey和notificationtag的通知
                    for (int i=0; i<acount; i++){
                        UILocalNotification *myUILocalNotification = [narry objectAtIndex:i];
                        NSDictionary *userInfo = myUILocalNotification.userInfo;
                        NSNumber *obj = [userInfo objectForKey:@"nfkey"];
                        int mytag=[obj intValue];
                        if (mytag==1||mytag==2){
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

                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

                        //提前24小时的通知
                        //本地推送
                        UILocalNotification*notification = [[UILocalNotification alloc]init];
//
                        NSDate * pushDate = [NSDate dateWithTimeIntervalSinceNow:[datePick.date timeIntervalSinceNow]-60*60*24];
                        if (notification != nil) {
                            notification.fireDate = pushDate;
                            notification.timeZone = [NSTimeZone defaultTimeZone];
                            notification.repeatInterval = kCFCalendarUnitDay;
                            notification.soundName = UILocalNotificationDefaultSoundName;
                            notification.alertBody = @"距面签时间不到24小时，请您带好材料，祝你好运";
                            notification.applicationIconBadgeNumber = 0;

                            NSDictionary* info = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:3],@"nfkey",nil];
                            notification.userInfo = info;
                            [[UIApplication sharedApplication] scheduleLocalNotification:notification];

                        }
                    });
                }else if(time-time2>60*60*2)
                {
                    //提前2小时的通知
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

                        //本地推送
                        UILocalNotification*notification = [[UILocalNotification alloc]init];
//                        [datePick.date timeIntervalSinceNow]-60*60*2
                       NSDate * pushDate = [NSDate dateWithTimeIntervalSinceNow:[datePick.date timeIntervalSinceNow]-60*60*2];
                        if (notification != nil) {
                            notification.fireDate = pushDate;
                            notification.timeZone = [NSTimeZone defaultTimeZone];
                            notification.repeatInterval = kCFCalendarUnitDay;
                            notification.soundName = UILocalNotificationDefaultSoundName;
                            notification.alertBody = @"距面签时间不到2小时，请您带好材料，祝你好运";
                            notification.applicationIconBadgeNumber = 0;

                            NSDictionary* info = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:4],@"nfkey",nil];
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
            [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
            JXLOG(@"失败");
        }];

    }
    [UIView setAnimationDuration:1];
    SelfbottomView.frame = CGRectMake(0,ScreenHeight-64-100*_Scale, ScreenWidth, 192);
    [UIView commitAnimations];

}
- (void)application:(UIApplication *)app didReceiveLocalNotification:(UILocalNotification *)notif
{

}
#pragma mark-数据请求
-(void)requestData
{
    [self requestTimeData];
    [self requestLoc];
}
-(void)requestLoc
{
//
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters=@{@"token":[regular getToken]};

    [manager GET:[[NSString alloc] initWithFormat:@"%@/v1/app_settings/consulates",DNS] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *html = operation.responseString;
        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
        JXLOG(@"%@",dict);
        if([[dict objectForKey:@"code"] integerValue]==1)
        {
            requestnum++;
            if(requestnum==2)
            {
                [indicator stopAnimationWithLoadText:@"loading..." withType:YES];
            }

            NSArray *dataarr=(NSArray *)[dict objectForKey:@"data"];
            for (int i=0; i<dataarr.count; i++) {
                [Latitude addObject:[NSNumber numberWithDouble:[[dataarr[i] objectForKey:@"latitude"] doubleValue]]];
                [longitude addObject:[NSNumber numberWithDouble:[[dataarr[i] objectForKey:@"longitude"] doubleValue]]];
                [address addObject:[dataarr[i] objectForKey:@"address"]];
                [telarr addObject:[dataarr[i] objectForKey:@"tel"]];

            }

            UILabel *addressQian = [regular createLabelView:@"领馆地址" Withrect:CGRectMake(36*_Scale,CGRectGetMaxY(clockView.frame) + 5 * __Scale, CGRectGetWidth(_scrollView.frame)-72*_Scale, 60*_Scale) WithTextColor:[UIColor  colorWithRed:77/255.0 green:190/255.0 blue:217/255.0 alpha:1.0] WithTextAlignment:1 WithFont:12.5];
            addressQian.font = [regular getFont:15.0f];
            addressQian.backgroundColor=[UIColor whiteColor];
            [addressQian setAttributedText:[regular createAttributeString:@"美领馆" andFloat:@(6.0)]];


//            addressQian.backgroundColor = [UIColor colorWithRed:244.0f/255.0f green:244.0f/255.0f blue:244.0f/255.0f alpha:1];
            [_scrollView addSubview:addressQian];

            UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(6*_Scale, CGRectGetMaxY(addressQian.frame)+1, CGRectGetWidth(_scrollView.frame)-12*_Scale, 70 * _Scale)];
            bottomView.backgroundColor = [UIColor whiteColor];
            [_scrollView addSubview:bottomView];
            CGFloat _width=CGRectGetWidth(bottomView.frame)/5.0f;
            NSArray *arrAddress = @[@"北 京",@"上 海",@"广 州",@"沈 阳",@"成 都"];
            for (int i = 0; i < 5; i++) {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = CGRectMake(_width*i,0, _width, CGRectGetHeight(bottomView.frame));
                [btn setBackgroundImage:[UIImage imageNamed:@"qianzheng_city"] forState:UIControlStateSelected];

                [btn.titleLabel setFont:[regular getFont:12.0f]];
                [btn setTitleColor:[UIColor colorWithRed:204.0f/255.0f green:204.0f/255.0f blue:204.0f/255.0f alpha:1] forState:UIControlStateNormal];
                [btn setTitleColor:_define_blue_color forState:UIControlStateSelected];
                [btn addTarget:self action:@selector(addressPress:) forControlEvents:UIControlEventTouchUpInside];
                [btn setTitle:arrAddress[i] forState:UIControlStateNormal];
                [btn setTitle:arrAddress[i] forState:UIControlStateSelected];
                btn.tag = 500 + i;
                [bottomView addSubview:btn];
                [btnArr addObject:btn];
                if(i == 1)
                {
                    btn.selected = YES;
                }
                
            }

            mapView = [[MKMapView alloc] initWithFrame:CGRectMake(6*_Scale, CGRectGetMaxY(bottomView.frame)+1*_Scale, CGRectGetWidth(_scrollView.frame)-12*_Scale, 440 * _Scale)];
            [mapView setShowsUserLocation:YES];
            mapView.delegate = self;
            [_scrollView addSubview:mapView];
            //    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom]


            CLLocation *loc = [[CLLocation alloc] initWithLatitude:31.228932 longitude:121.456888];
            CLLocationCoordinate2D coord = [loc coordinate];
            MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord, 500, 500);
            [mapView setRegion:region animated:YES];
            MyPoint *myPoint = [[MyPoint alloc] initWithCoordinate:coord andTitle:address[1]];


            telStr=1;
            //添加标注
            [mapView addAnnotation:myPoint];
            addressview=[[UIView alloc] initWithFrame:CGRectMake(6*_Scale, CGRectGetMaxY(mapView.frame), CGRectGetWidth(_scrollView.frame)-12*_Scale, 120 * _Scale)];
            addressview.backgroundColor=[UIColor whiteColor];

            //    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(telAction:)];
            //    [addressview addGestureRecognizer:tap];

            [_scrollView addSubview:addressview];

            addressLabel = [regular createLabelView:nil Withrect:CGRectMake(0, 0, 520*_Scale, 40 * __Scale) WithTextColor:[UIColor colorWithRed:77/255.0 green:190/255.0 blue:217/255.0 alpha:1.0] WithTextAlignment:2 WithFont:12.0];

            [addressview addSubview:addressLabel];


            tellabel=[[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(addressLabel.frame)-10, 520*_Scale , CGRectGetHeight(addressview.frame)-CGRectGetMaxY(addressLabel.frame))];

            tellabel.font=[regular get_en_Font:12.0f];
            tellabel.textAlignment=2;
            tellabel.textColor=[UIColor colorWithRed:77/255.0 green:190/255.0 blue:217/255.0 alpha:1.0];
            //    tellabel.backgroundColor=[UIColor redColor];
            [tellabel setAttributedText:[regular createAttributeString:telarr[1] andFloat:@(1.0)]];
            //    tellabel.text=telarr[1];
            [addressview addSubview:tellabel];
            UIImageView *img_loc=[[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(addressLabel.frame)+25*_Scale, CGRectGetMinY(addressLabel.frame)+(CGRectGetHeight(addressLabel.frame)-25*_Scale)/2.0f, 25*_Scale, 25*_Scale)];
            img_loc.image=[UIImage imageNamed:@"box_icon_地址"];
            //    img_icon.backgroundColor=[UIColor redColor];
            [addressview addSubview:img_loc];

            UIImageView *img_tel=[[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(tellabel.frame)+25*_Scale, CGRectGetMinY(tellabel.frame)+(CGRectGetHeight(tellabel.frame)-25*_Scale)/2.0f, 25*_Scale, 25*_Scale)];
            img_tel.image=[UIImage imageNamed:@"box_icon_电话"];
            //    img_icon.backgroundColor=[UIColor redColor];
            [addressview addSubview:img_tel];
            //    addressLabel.text = address[1];
            [addressLabel setAttributedText:[regular createAttributeString:address[1] andFloat:@(2.0f)]];



            UIButton *openGPSBtn=[regular createBtnWithRect:CGRectMake(6*_Scale, CGRectGetMaxY(addressview.frame) +1, (CGRectGetWidth(_scrollView.frame)-12.0f*_Scale-2)/2.0f, 60*_Scale) WithTitle:@"导 航" WithNormalColor:_define_blue_color WithSelectColor:nil WithTitleFont:[regular getFont:14.0]];
            openGPSBtn.backgroundColor = [UIColor whiteColor];
            [openGPSBtn addTarget:self action:@selector(openGPS:) forControlEvents:UIControlEventTouchUpInside];
            [_scrollView addSubview:openGPSBtn];
            UIButton *phoneBtn=[regular createBtnWithRect:CGRectMake(CGRectGetMaxX(openGPSBtn.frame)+1, CGRectGetMaxY(addressview.frame) +1, CGRectGetWidth(openGPSBtn.frame), CGRectGetHeight(openGPSBtn.frame)) WithTitle:@"电 话" WithNormalColor:_define_blue_color WithSelectColor:nil WithTitleFont:[regular getFont:14.0]];
            phoneBtn.backgroundColor = [UIColor whiteColor];
            [phoneBtn addTarget:self action:@selector(telAction) forControlEvents:UIControlEventTouchUpInside];
            [_scrollView addSubview:phoneBtn];


            UIButton *NextBtn = [regular createBtnWithRect:CGRectMake(6*_Scale, CGRectGetMaxY(openGPSBtn.frame) +10, CGRectGetWidth(_scrollView.frame)-12.0f*_Scale, 70*_Scale) WithTitle:@"下 一 步" WithNormalColor:[UIColor whiteColor] WithSelectColor:nil WithTitleFont:[regular getFont:14.0]];

            NSString *nexttitle=nil;
            UIColor *nextcolor=nil;
            if(self.step>=3)
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
            [_scrollView addSubview:NextBtn];

            JXLOG(@"%f",CGRectGetMaxY(NextBtn.frame));
            _scrollView.contentSize = CGSizeMake(CGRectGetWidth(_scrollView.frame), CGRectGetMaxY(NextBtn.frame)+10);



        }else
        {
            [[ToolManager sharedManager] alertTitle_Simple:[dict objectForKey:@"message"]];
            [indicator stopAnimationWithLoadText:@"loading..." withType:YES];

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
#pragma mark-请求面签时间数据
-(void)requestTimeData
{
    NSString *timeUrl = [NSString stringWithFormat:@"%@/v1/user_boxes/go_visa?token=%@",DNS,[regular getToken]];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    [manager POST:timeUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *html = operation.responseString;
        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
        if([[dict objectForKey:@"code"] integerValue]==1)
        {
            requestnum++;
            if(requestnum==2)
            {
                [indicator stopAnimationWithLoadText:@"loading..." withType:YES];
            }

        }else
        {
            [indicator stopAnimationWithLoadText:@"loading..." withType:YES];
        }
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
#pragma mark-不为null值的时候
        if(dict[@"data"][@"go_visa_at"]!= [NSNull null])
        {

            NiceNewdate = [dateFormat dateFromString:dict[@"data"][@"go_visa_at"]];
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
                    [[ToolManager sharedManager] alertTitle_Simple:@"签证时间已过，请重新设置"];

                    NSUserDefaults *_defaults=[NSUserDefaults standardUserDefaults];
                    [_defaults setObject:@"1" forKey:@"hangban"];

                }

                addShowTimeBack.hidden=YES;
                addQianBack.hidden=NO;

            }else
            {
//                今天为面签日
                if((((long)(time/(86400)))==((long)(timenow/(86400))))&&(time>timenow))
                {
                    UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"提示" message:@"今天为签证面试日，请带好材料，祝你好运！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [view show];
                }else if((((long)(time/(86400))-1)==((long)(timenow/(86400))))&&(time>timenow))
                {
//                明天为面签日
                    UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"提示" message:@"明天要去签证面试啦，请带好材料，祝你好运！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [view show];
                }
//                显示当前时间
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                [dateFormat setDateFormat:@"YYYY-MM-dd HH:mm"];
                NSString *nowtimeStr = [dateFormat stringFromDate:NiceNewdate];
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
- (NSDate *)dateFromString:(NSDate *)dateString{

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //   NSDate *date =[dateFormatter dateFromString:@"2011-04-02 00:00:00"];
    NSTimeZone* timeZone1 = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateFormatter setTimeZone:timeZone1];
    NSString *newDate = [dateFormatter stringFromDate:dateString];
    NSDate *todate = [dateFormatter dateFromString:newDate];
    return todate;

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
//    JXLOG(@"day=%ld,hour=%ld,minyte=%ld,second=%ld",(long)[d day],[d hour],[d minute],(long)[d second]);

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

-(void)createScrollview
{
     _scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64-100*_Scale)];
    _scrollView.contentSize=CGSizeMake(ScreenWidth, ScreenHeight);
    [self.view addSubview:_scrollView];

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
            SelfbottomView.frame = CGRectMake(0,ScreenHeight-64-100*_Scale-192, ScreenWidth, 192);
            [UIView commitAnimations];

    }else
    {
        [[ToolManager sharedManager] alertTitle_Simple:@"请先开启推送开关"];
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
-(void)CancelBtnPress:(UIButton *)btn
{
    SelfbottomView.frame = CGRectMake(0,ScreenHeight-64-100*_Scale, ScreenWidth, 192);
}
- (void)createView
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


    clockView = [[UIView alloc] initWithFrame:CGRectMake(6*_Scale, 10*_Scale , CGRectGetWidth(_scrollView.frame) - 12*_Scale, 180*_Scale)];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(settimeAction:)];
    [clockView addGestureRecognizer:tap];
    clockView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:clockView];
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
    [contentlabel setAttributedText:[regular createAttributeString:@"设定签证提醒" andFloat:@(10.0)]];
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
    [mianqianri setAttributedText:[regular createAttributeString:@"面签日" andFloat:@(2.0)]];
    [timeback addSubview:mianqianri];

    qianTimeLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(mianqianri.frame)+20*_Scale, CGRectGetMinY(mianqianri.frame), CGRectGetWidth(timeback.frame)-CGRectGetMaxX(mianqianri.frame)-20*_Scale, CGRectGetHeight(mianqianri.frame))];
    qianTimeLabel.textAlignment=0;
    qianTimeLabel.textColor=_define_blue_color;
    qianTimeLabel.font=[regular get_en_Font:11.0f];
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

}
#pragma mark-下一步
- (void)NextBtnPress:(UIButton *)btn
{

    if(self.step>=3)
    {
        //        取消
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSString *Url = [NSString stringWithFormat:@"%@/v1/user_boxes/cancel?token=%@",DNS,[regular getToken]];
        NSDictionary *dict=@{@"name":@"go_visa"};
        [manager POST:Url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *html = operation.responseString;
            NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
            //        进行解析以后的操作
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            if([[dict objectForKey:@"code"] integerValue]==1)
            {

                self.block(@"qian",NO);

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
        NSDictionary *dict=@{@"name":@"go_visa"};
        [manager PUT:Url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *html = operation.responseString;
            NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
            //        进行解析以后的操作
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            if([[dict objectForKey:@"code"] integerValue]==1)
            {


                self.block(@"qian",YES);
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

#pragma mark-电话
-(void)telAction{

//    telarr
    NSMutableArray *telarr1=[[NSMutableArray alloc] init];
    for (int i=0; i<telarr.count; i++) {
        NSString *str= [telarr[i] stringByReplacingOccurrencesOfString:@"-" withString:@""];
        [telarr1 addObject:str];

    }

    sheet_tel=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:telarr1[telStr] otherButtonTitles:nil];
    sheet_tel.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [sheet_tel showInView:self.view];

}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(actionSheet==sheet_tel)
    {
        if (buttonIndex == 0)
        {
            NSMutableArray *telarr1=[[NSMutableArray alloc] init];
            for (int i=0; i<telarr.count; i++) {
                NSString *str= [telarr[i] stringByReplacingOccurrencesOfString:@"-" withString:@""];
                [telarr1 addObject:str];
                
            }

            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[[NSString alloc] initWithFormat:@"tel://%@",telarr1[telStr]]]];

        }else if (buttonIndex == 1) {

        }

    }else if(actionSheet==sheet_loc)
    {
        if (buttonIndex == 0)
        {
            //获取当前位置
            NSInteger _index=0;
            for (int i=500; i<505; i++) {
                UIButton *btn=(UIButton *)[self.view viewWithTag:i];
                if(btn.selected)
                {
                    _index=i-500;
                    break;
                }
            }
//            MKMapItem *mylocation = [MKMapItem mapItemForCurrentLocation];



            //当前经维度

//            float currentLatitude=mylocation.placemark.location.coordinate.latitude;
//
//            float currentLongitude=mylocation.placemark.location.coordinate.longitude;



//            CLLocationCoordinate2D coords1 = CLLocationCoordinate2DMake(currentLatitude,currentLongitude);



            //目的地位置
            CGFloat _lat=[Latitude[_index] doubleValue];
            CGFloat _long=[longitude[_index] doubleValue];
            coordinate.latitude=_lat;

            coordinate.longitude=_long;





            CLLocationCoordinate2D coords2 = coordinate;





            //当前的位置

            MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];

            //起点

            //MKMapItem *currentLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:coords1 addressDictionary:nil]];

            //目的地的位置

            MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:coords2 addressDictionary:nil]];



            toLocation.name = @"目的地";

            NSString *myname=address[_index];

            toLocation.name =myname;

            NSArray *items = [NSArray arrayWithObjects:currentLocation, toLocation, nil];

            NSDictionary *options = @{ MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving, MKLaunchOptionsMapTypeKey: [NSNumber numberWithInteger:MKMapTypeStandard], MKLaunchOptionsShowsTrafficKey:@YES };
            
            //打开苹果自身地图应用，并呈现特定的item
            
            [MKMapItem openMapsWithItems:items launchOptions:options];
            
            
        }else if (buttonIndex == 1)
        {

            
        }
        
        
    }
    
}
#pragma mark-导航
-(void)openGPS:(UIButton *)btn
{
    sheet_loc=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"开启导航" otherButtonTitles:nil];
    sheet_loc.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [sheet_loc showInView:self.view];

}
- (void)addressPress:(UIButton *)btn
{
    [mapView removeOverlays:mapView.overlays];
    [mapView removeAnnotations:mapView.annotations];
    for (UIButton *b in btnArr) {
        b.selected = NO;
    }
    btn.selected = YES;
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:[Latitude[btn.tag - 500] floatValue] longitude:[longitude[btn.tag - 500] floatValue]];
    CLLocationCoordinate2D coord = [loc coordinate];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord, 500, 500);
    [mapView setRegion:region animated:YES];
    MyPoint *myPoint = [[MyPoint alloc] initWithCoordinate:coord andTitle:address[btn.tag - 500]];

    //添加标注
    [mapView addAnnotation:myPoint];


    telStr=btn.tag - 500;
    addressLabel.text = address[btn.tag - 500];

    [tellabel setAttributedText:[regular createAttributeString:telarr[btn.tag-500] andFloat:@(1.0)]];
    
    
}


//数据准备
-(void)prapareData
{
    isshow=NO;
    requestnum=0;
    TimeArray=[[NSMutableArray alloc] init];


    btnArr=[[NSMutableArray alloc] init];
    telStr=0;

    Latitude = [[NSMutableArray alloc] init];
    longitude = [[NSMutableArray alloc] init];

    address = [[NSMutableArray alloc] init];
    telarr=[[NSMutableArray alloc] init];
    
    self.view.backgroundColor = _define_backview_color;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"QianViewController"];
    [[CustomTabbarController sharedManager] tabbarHide];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"QianViewController"];
    [requireTime setFireDate:[NSDate distantFuture]];
}


@end
