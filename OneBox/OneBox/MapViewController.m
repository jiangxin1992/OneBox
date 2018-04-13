//
//  MapViewController.m
//  OneBox
//
//  Created by 谢江新 on 15-2-2.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import "MapViewController.h"

#import "SchoolDetailViewController.h"
#import "ADClusterMapView.h"
#import "ADClusterableAnnotation.h"
#import "customMKPinAnnotationView.h"
#import "CustomTabbarController.h"

#import "cardView.h"

#import "ADClusterableAnnotation.h"
#import "MyPoint.h"
#import "customTap.h"
#import "surveyModel.h"

@interface MapViewController ()<UIAlertViewDelegate,UIGestureRecognizerDelegate>

@property MKCoordinateRegion origin;

@property NSInteger justSelect;

@property NSInteger numberOfCluster;
@property double clusterDiscrimination;


@property BOOL shouldShow;

@end

@implementation MapViewController
{
//    BOOL _ishide;
    //保存双击手势对象
    UITapGestureRecognizer *_tapRec;
    NSInteger start;
    NSInteger _page;
    //2的时候缓存
//    NSInteger huancun;
    BOOL nowrefresh;
    YYAnimationIndicator *indicator;
    BOOL hasnum;
    NSInteger _num;
    UIImageView *mengbanImg;
    BOOL haschange;
    NSInteger jjj;
    NSInteger _iii;
    ADClusterMapView *_mapview;
    void(^changeBlock)();
    NSMutableString *sid;
    NSMutableString *ename;
    NSMutableString *cname;
    NSArray *dataarr;

    UIView *coverView;

    BOOL is_order_school;


}

- (void)viewDidLoad {
    [super viewDidLoad];

//    _ishide=NO;
    nowrefresh=NO;
    ADClusterableAnnotation* anno=[[ADClusterableAnnotation alloc]initWithDictionary:@{@"is_order_school":[NSNumber numberWithLong:0],@"id":[NSNumber numberWithLong:4],@"latitude":@"38.5",@"longtitude":@"97"}];
    hasnum=NO;
    _num=0;
    _annoations1=@[anno];
    jjj=0;
    haschange=NO;
    dataarr=[[NSArray alloc] init];
    is_order_school=NO;
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
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
    UIBarButtonItem *_btn=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回箭头"] style:UIBarButtonItemStylePlain target:self action:@selector(popviewAction)];
    self.navigationItem.leftBarButtonItem=_btn;

    self.navigationController.navigationBar.barTintColor =[UIColor colorWithRed:70.0f/255.0f green:195.0f/255.0f blue:247.0f/255.0f alpha:1];
    ename=[[NSMutableString alloc] init];
    cname=[[NSMutableString alloc] init];
    sid=[[NSMutableString alloc] init];

    self.navigationItem.titleView=[regular returnNavView:@"地图找校" withmaxwidth:230];

    _justSelect=0;
    //init the mapview
    _mapview=[[ADClusterMapView alloc] initWithFrame:CGRectMake(0, 0,ScreenWidth, ScreenHeight)];
    [self.view addSubview:_mapview];
    _mapview.delegate=self;
    [_mapview setScrollEnabled:YES];
    [_mapview setZoomEnabled:YES];


    CLLocationCoordinate2D c;
    c.latitude=38.5;
    c.longitude=-97;
    MKCoordinateSpan span;
    if(_isPad)
    {
        span.latitudeDelta=35;//20
        span.longitudeDelta=80;//60
    }else
    {
        span.latitudeDelta=25;//20
        span.longitudeDelta=70;//60
    }
//    span.latitudeDelta=25;//20
//    span.longitudeDelta=70;//60
    MKCoordinateRegion reg=MKCoordinateRegionMake(c, span);
    [_mapview setRegion:reg];

    _annoations=[[NSMutableArray alloc] init];
    _showcard=NO;

    _origin=_mapview.region;
#pragma mark-创建单击手势 用于地图导航栏动态显示
    [self createTapGesture];
#pragma mark-创建双击手势
    [self createTapGestureDoubleClick];

    [self get_location_info];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showyindao) name:@"showyindao" object:nil];
    changeBlock=^( )
    {
        //        跳转到下一页面
        //        JXLOG(@"222");
        SchoolDetailViewController *schoolView=[[SchoolDetailViewController alloc] init]  ;
        schoolView.data_dict=[[NSDictionary alloc] initWithObjectsAndKeys:cname,@"schoolName",sid,@"schoolID",[NSNumber numberWithInteger:is_order_school],@"is_order_school",nil];

        [[cardView sharedManager] setHidden:YES];
        [self.navigationController pushViewController:schoolView animated:YES];
    };


    [self createRefreshBtn];
}
-(void)createTapGestureDoubleClick
{
    UITapGestureRecognizer * tapDoubleGes = [[UITapGestureRecognizer alloc] init];

    [tapDoubleGes addTarget:self action:@selector(tapDoubleGes:)];
    //设置当前手势需要的点击次数
    tapDoubleGes.numberOfTapsRequired = 2;
    //设置当前需要几个手指同时点击
    tapDoubleGes.numberOfTouchesRequired = 1;

    [_mapview addGestureRecognizer:tapDoubleGes];
    //设置单击手势的成功需要依赖双击手势的失败
    //    只有双击失败得时候单击才会调用
    [_tapRec  requireGestureRecognizerToFail:tapDoubleGes];
}
-(void)popviewAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 手势协议方法
//这个方法默认返回为NO，返回NO，则不支持多个手势同时处理，YES，支持
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
-(void)createTapGesture
{
    //一个手势只能添加到一个view上面
    //点击手势,创建点击手势对象
    _tapRec = [[UITapGestureRecognizer alloc] init];
    //设置当前手势需要的点击次数
    _tapRec.numberOfTapsRequired = 1;//(默认为1)
    //设置当前需要几个手指同时点击
    _tapRec.numberOfTouchesRequired = 1;//(默认为1)
    //为当前手势添加处理方法
    //参数1 : 处理该手势的对象
    //参数2 : 处理手势的方法
    [_tapRec addTarget:self action:@selector(tapRec:)];
    //将手势添加到_imageView上，_imageView就会处理手势tapRec，
    //当_imageView收到手势时，会让self调用前面添加的手势处理的方法
    [_mapview addGestureRecognizer:_tapRec];
}
- (void)tapDoubleGes:(UITapGestureRecognizer *)tapGes
{
    JXLOG(@"tapDoubleGes");
}
#pragma mark-单击隐藏状态栏和导航栏
- (void)tapRec:(UIGestureRecognizer *)tapGes
{

//    if(_ishide)
//    {
////        显示
//
//        [self.navigationController setNavigationBarHidden:NO animated:YES];
//
//        _ishide=NO;
//
//    }else
//    {
////        隐藏'
//
//        [self.navigationController setNavigationBarHidden:YES animated:YES];
//
//        _ishide=YES;
//
//
//    }
//
//    JXLOG(@"tapRec");


}
-(void)showyindao
{
    NSUserDefaults *Defaults=[NSUserDefaults standardUserDefaults];

    if([Defaults objectForKey:@"map_yd"]==nil)
    {
#pragma  mark-添加新手说明
        coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        coverView.backgroundColor=[UIColor blackColor];
        coverView.alpha = 0.7;
        [[UIApplication sharedApplication].keyWindow addSubview:coverView];
        UIImageView *imageview=[[UIImageView alloc] initWithFrame:coverView.frame];
        imageview.contentMode=UIViewContentModeScaleAspectFit;
        imageview.image=[UIImage imageNamed:@"新手引导页2"];
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeYindao:)];
        [imageview addGestureRecognizer:tap];
        imageview.userInteractionEnabled=YES;
        [coverView addSubview:imageview];
        [Defaults setObject:@"1" forKey:@"map_yd"];
    }
}

-(void)createRefreshBtn
{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake((ScreenWidth-70*_Scale)/2.0f, ScreenHeight-70*_Scale-64, 70*_Scale, 70*_Scale);
    [btn setBackgroundImage:[UIImage imageNamed:@"刷新icon"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(initMap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}
-(void)initMap:(UIButton *)btn
{

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *Url = [NSString stringWithFormat:@"%@/v1/schools/total_count",DNS];
    [manager GET:Url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *html = operation.responseString;
        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
        CLLocationCoordinate2D c;
        c.latitude=32.8;
        c.longitude=-97;
        MKCoordinateSpan span;
        if(_isPad)
        {
            span.latitudeDelta=30;//20
            span.longitudeDelta=75;//60
        }else
        {
            span.latitudeDelta=25;//20
            span.longitudeDelta=70;//60
        }

        MKCoordinateRegion reg=MKCoordinateRegionMake(c, span);
        [_mapview setRegion:reg];
        if([[dict objectForKey:@"code"]integerValue]==1)
        {
            for (UIView *view in mengbanImg.subviews) {
                if([view isKindOfClass:[UILabel class]])
                {

                    UILabel *label=(UILabel *)view;
                    if([[[dict objectForKey:@"data"] objectForKey:@"total_count"] integerValue]!=[label.text integerValue])
                    {
                        label.text=[[NSString alloc] initWithFormat:@"%ld",[[[dict objectForKey:@"data"] objectForKey:@"total_count"] longValue]];

                    }
                    break;
                }
            }

        }else
        {
             [[ToolManager sharedManager] alertTitle_Simple:[dict objectForKey:@"message"]];
        }




    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];

    }];

//    _annoations=[[NSMutableArray alloc] init];
//    _showcard=NO;
//
//    _origin=_mapview.region;
//    dataarr=[[NSArray alloc] init];
//    [self get_location_info];

}
-(void)removeYindao:(UIGestureRecognizer *)ges
{

    [coverView removeFromSuperview];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [MobClick beginLogPageView:@"MapViewController"];

    [[CustomTabbarController sharedManager] tabbarHide];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [MobClick endLogPageView:@"MapViewController"];
}



#pragma mark get school location info
-(void)get_location_info{


    if(!indicator){
        indicator = [[YYAnimationIndicator alloc]initWithFrame:CGRectZero];
        [self.view addSubview:indicator];
        [indicator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.view);
            make.width.height.mas_equalTo(40*_Scale*2);
        }];
        [indicator setLoadText:@"loading..."];
    }
    [indicator startAnimation];

    //URL 统一资源定位 ， 一个url代表了一个链接地址，代表了一个资源
    NSURL *url1 = [NSURL URLWithString:[[NSString alloc] initWithFormat:@"%@/v1/schools/map_setting",DNS]];

    //创建一个请求数据包，请求的资源是url代表的资源
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url1];

    //存储返回的错误内容
    NSError *error = nil;
    //存储返回的响应包（应答内容）
    NSURLResponse *urlResponse = nil;
    //存储返回的数据
    NSData *data = nil;

    //这个方法会一直阻塞，直到数据下载完成，或者出错
    //通过这个方法 ，我们向服务器发送了一个同步下载请求数据包，
    //如果没有出错，就会返回我们需要的数据到data中
    //参数1 : 请求包
    //参数2 ; 返回响应包
    //参数3 : 如果出错，返回的错误代码（内容）
    data =  [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&urlResponse error:&error];
    //没有出错
    if (error == nil) {
        [indicator stopAnimationWithLoadText:@"loading..." withType:YES];
        JXLOG(@"urlResponse = %@", urlResponse);

        NSString *html = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
        if([[dict objectForKey:@"code"] integerValue]==1)
        {


            NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
            [self setdata11:dict];
        }

    }
    else
    {
        [indicator stopAnimationWithLoadText:@"loading..." withType:YES];
        //打印出错内容
        JXLOG(@"error = %@", error);
        _numberOfCluster=25;
        _clusterDiscrimination=1;
        JXLOG(@"Error: %@", error);
       [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];

    }

}


-(void)setdata11:(NSDictionary *)dict
{

    _numberOfCluster=(int)[[[dict objectForKey:@"data"]objectForKey:@"numberOfCluster"]floatValue];
    _clusterDiscrimination=[[[dict objectForKey:@"data"] objectForKey:@"discriminationOfCluster"]floatValue];

    _annoations=[[NSMutableArray alloc] init];



    //URL 统一资源定位 ， 一个url代表了一个链接地址，代表了一个资源
    NSURL *url1 = [NSURL URLWithString:[[NSString alloc] initWithFormat:@"%@%@",DNS,@"/v1/schools/all"]];

    //创建一个请求数据包，请求的资源是url代表的资源
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url1];

    //存储返回的错误内容
    NSError *error = nil;
    //存储返回的响应包（应答内容）
    NSURLResponse *urlResponse = nil;
    //存储返回的数据
    NSData *data = nil;

    //这个方法会一直阻塞，直到数据下载完成，或者出错
    //通过这个方法 ，我们向服务器发送了一个同步下载请求数据包，
    //如果没有出错，就会返回我们需要的数据到data中
    //参数1 : 请求包
    //参数2 ; 返回响应包
    //参数3 : 如果出错，返回的错误代码（内容）
    data =  [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&urlResponse error:&error];
    //没有出错
    if (error == nil) {
        JXLOG(@"urlResponse = %@", urlResponse);

        NSString *html = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        //        JXLOG(@"html = %@", html);
        //        NSString *html = operation.responseString;
        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

        if([[dict objectForKey:@"code"] integerValue]==1)
        {

            if([dict objectForKey:@"data"]!=[NSNull null])
            {
                //                [dataarr setArray:];
                dataarr=[dict objectForKey:@"data"];
                NSMutableArray *arr111=[[NSMutableArray alloc] init];
                for (NSInteger i=0;i<dataarr.count;i++) {

                    NSDictionary* annotationDictionary =dataarr[i];


                    //                    if((![[annotationDictionary objectForKey:@"longtitude"] isEqualToString:@""])&&(![[annotationDictionary objectForKey:@"latitude"] isEqualToString:@""]))
                    //                    {
                    ADClusterableAnnotation* anno=[[ADClusterableAnnotation alloc]initWithDictionary:annotationDictionary];

                    [arr111 addObject:anno];
                    //                        [ addObject:anno];

                    [_mapview setAnnotations:_annoations];
                    //                    }


                }
                _annoations=arr111;
                JXLOG(@"%@",_annoations);

            }

        }else
        {

            _numberOfCluster=25;
            _clusterDiscrimination=1;
            [[ToolManager sharedManager] alertTitle_Simple:[dict objectForKey:@"message"]];

        }
        [[ToolManager sharedManager] removeProgress];
    }
    else
    {

        _numberOfCluster=25;
        _clusterDiscrimination=1;
        JXLOG(@"Error: %@", error);
        [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
        [[ToolManager sharedManager] removeProgress];

    }


}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

-(void)showdetail:(customTap*)recognizer{
//    JXLOG(@"ssss%d",_mapview.annotations.count);
    if(_mapview.annotations.count!=1)
    {
        [self mapView:_mapview didSelectAnnotationView:recognizer.v];
    }

}
-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    if(_mapview.annotations.count!=1)
    {
        NSString *__title=[view.annotation title];

        NSRange  range=[__title rangeOfString:@"所学校"];
        NSInteger _length= range.length;


        if(_length>0)
        {

        }else
        {
            NSDictionary* dict=nil;

            for (int i=0; i<dataarr.count; i++) {
                NSDictionary *ddd=dataarr[i];
                if([[[NSString alloc] initWithFormat:@"%ld",(long)[[ddd objectForKey:@"id"] integerValue]]isEqualToString:[view.annotation title]]){
                    dict=ddd;
                    break;
                }

            }

            [sid setString:[[NSString alloc] initWithFormat:@"%ld",(long)[dict[@"id"] integerValue]]];

            JXLOG(@"%@",dict);


            void (^blockSuccess)(NSDictionary *dict);
            blockSuccess=^(NSDictionary *_dict)
            {


                if([[_dict objectForKey:@"code"] integerValue]==1)
                {
                    is_order_school=[[[_dict objectForKey:@"data"] objectForKey:@"is_order_school"] boolValue];

                    [sid setString:[[NSString alloc] initWithFormat:@"%ld",(long)[[[_dict objectForKey:@"data"] objectForKey:@"id"] integerValue]]];

                    [ename setString:[[_dict objectForKey:@"data"] objectForKey:@"en_name"]];
                    [cname setString:[[_dict objectForKey:@"data"] objectForKey:@"cn_name"]];

                    //                NSMutableString *ename;

                    surveyModel *model=[surveyModel parsingWithJsonDataForModel:_dict];

                    [[cardView sharedManager] setBlock:changeBlock];
                    [[cardView sharedManager] setdata:model];
                    [[cardView sharedManager] setHidden:NO];
                    [[cardView sharedManager] removeView:NO];
                    UIView *___view=[cardView sharedManager];


                    [self.view addSubview:___view];


                    [_mapview becomeFirstResponder];

                }else
                {

                }

            };
            void (^blockFailure)(NSError *error);
            blockFailure=^(NSError *_error)
            {

                [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
            };

            //    创建包体

            NSString *url=[[NSString alloc] initWithFormat:@"%@/v1/schools/%@/map_school",DNS,sid];

            [[ToolManager sharedManager] NetworkRequest:url bodyStr:nil ispost:NO success:blockSuccess failure:blockFailure];
        }


    }


}



//-(IBAction)exitToHere:(UIStoryboardPopoverSegue *)sender{
//
//
//}

#pragma mark ADC
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    MKAnnotationView * pinView = ( MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"ADClusterableAnnotation"];
    if (!pinView) {
        pinView = [[ MKAnnotationView alloc] initWithAnnotation:annotation
                                                reuseIdentifier:@"ADClusterableAnnotation"];
        NSString* s=[annotation title];
        NSDictionary* dict;
        for(NSInteger i=0;i<dataarr.count;i++){
            dict=[dataarr objectAtIndex:i];
            if([[dict objectForKey:@"EName"] isEqualToString:s]){
                break;
            }
        }
        JXLOG(@"%lu",(unsigned long)_annoations.count);
        if(_annoations.count==1)
        {
            pinView.image=[UIImage imageNamed:@"newMapIcon_new.png"];


        }else
        {
            pinView.image=[UIImage imageNamed:@"map_单个学校.png"];
        }


        customTap *tap=[[customTap alloc]initWithTarget:self action:@selector(showdetail:) dictionary:dict view:pinView];
        [pinView addGestureRecognizer:tap];

        pinView.canShowCallout = NO;



    }
    else {

        JXLOG(@"lat =%f",_mapview.region.span.latitudeDelta);
        //
        pinView.annotation = annotation;
        if(_mapview.region.span.latitudeDelta>50.0)
        {

            pinView.hidden=YES;

        }else
        {
            pinView.hidden=NO;
        }

    }


    return pinView;
}
- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
- (MKAnnotationView *)mapView:(ADClusterMapView *)mapView viewForClusterAnnotation:(id<MKAnnotation>)annotation {

    //    NSString *title=[annotation title];
    NSArray *a=[[annotation title] componentsSeparatedByString:@"所"];

    customMKPinAnnotationView* pinView=[[customMKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"cus"];

    if([a firstObject]==nil||[[a firstObject] isEqualToString:@""])
    {


        if(!haschange)
        {
            if(jjj==0)
            {
                jjj=1;
            }else if(jjj==1)
            {
                jjj=2;
            }
            haschange=YES;
        }


    }else
    {
        pinView.label.text=[a firstObject];
        haschange=NO;
        jjj=0;

        hasnum=YES;
        JXLOG(@"%f",_mapview.region.span.latitudeDelta);
        if(_mapview.region.span.latitudeDelta>73.0f)
        {
            pinView.hidden=YES;

        }else
        {
            pinView.hidden=NO;
            pinView.image=[UIImage imageNamed:@"newMapIcon_new.png"];
        }


    }


    pinView.canShowCallout=NO;


    return pinView;
}
-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view{


}

-(void)mapViewDidFinishLoadingMap:(MKMapView *)mapView
{

}
- (void)mapViewDidFinishClustering:(ADClusterMapView *)mapView {
    if(_mapview.region.span.latitudeDelta>73.0f)
    {

        if(nowrefresh==YES)
        {
            nowrefresh=NO;
        }else
        {
            if(mengbanImg==nil)
            {
                nowrefresh=NO;
            }else
            {

            }
        }

        [mengbanImg removeFromSuperview];
        mengbanImg=[[UIImageView alloc] init];
        [self.view addSubview:mengbanImg];
        [mengbanImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(100);
            make.centerX.mas_equalTo(self.view);
            make.centerY.mas_equalTo(self.view);
        }];

        mengbanImg.image=[UIImage imageNamed:@"school_center"];
        mengbanImg.layer.cornerRadius=50;
        mengbanImg.layer.masksToBounds=YES;

        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 90)];
        [mengbanImg addSubview:label];
        label.textAlignment=1;
        label.font=[UIFont fontWithName:@"Skia" size:30.0f];
        label.textColor=[UIColor whiteColor];
        label.text=[[NSString alloc] initWithFormat:@"%lu",(unsigned long)dataarr.count];
        
    }else
    {
        JXLOG(@"%f",_mapview.region.span.latitudeDelta);
        [mengbanImg removeFromSuperview];
        if(jjj==1&&_num<2&&!hasnum)
        {
            _num++;
            
            haschange=NO;
        }else
        {
            _num=0;
            if(jjj==2)
            {
                jjj=1;
            }
            
        }
        
    }
    
    
    hasnum=NO;
}


- (NSInteger)numberOfClustersInMapView:(ADClusterMapView *)mapView {
    
    JXLOG(@"%ld",(long)_numberOfCluster);
    return _numberOfCluster;
}

- (double)clusterDiscriminationPowerForMapView:(ADClusterMapView *)mapView {
    
    JXLOG(@"%ld",(long)_clusterDiscrimination);
    return _clusterDiscrimination;
}

- (void)mapViewWillStartLoadingMap:(MKMapView *)mapView
{
    _origin=mapView.region;
    
}

-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{

    JXLOG(@"latitudeDelta=%lf",_mapview.region.center.latitude);
    
    [_mapview removeAnnotations:_mapview.annotations];
    [_mapview setAnnotations:_annoations];
    JXLOG(@"%f",_mapview.region.span.latitudeDelta);

    _iii=0;
    
    
}





@end
