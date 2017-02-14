//
//  SchoolDetailViewController.m
//  OneBox
//
//  Created by 谢江新 on 15/6/23.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import "SchoolDetailViewController.h"

#import <CoreLocation/CoreLocation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import "HttpRequestManager.h"
#import <MessageUI/MessageUI.h>
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import "followerViewController.h"
#import "followingViewController.h"
#import "AdmissionViewController.h"
#import "schoolCommentController.h"
#import "CustomTabbarController.h"
#import "ImageViewController.h"
#import "LoginViewController.h"
#import "ChatViewController.h"

#import "MyPoint.h"
#import "KVNProgress.h"

#import "Tools.h"
#import "usermodel.h"
#import "schoolDetailModel.h"
#import "graduationModel.h"

#define yellow_color [UIColor colorWithRed:248.0f/255.0f green:210.0f/255.0f blue:82.0f/255.0f alpha:1]
#define yellow_color_2 [UIColor colorWithRed:247.0f/255.0f green:152.0f/255.0f blue:25.0f/255.0f alpha:1]
#define photoHeight (ScreenWidth-_margin*2)*9.0f/16.0f

@interface SchoolDetailViewController ()<UIScrollViewDelegate,UIPageViewControllerDataSource,UIPageViewControllerDelegate,UIAlertViewDelegate,MKMapViewDelegate,CLLocationManagerDelegate,MFMailComposeViewControllerDelegate,UIActionSheetDelegate,UIWebViewDelegate,MFMailComposeViewControllerDelegate>

@end

@implementation SchoolDetailViewController
{
    UIActionSheet *isdaohang_sheet;
    UIImageView  *view_star;
    UIView *pingfen_no_numview;
    UIView *pingfen_numview;
    usermodel *kefu_model;

    UIImageView *banbenimg;
    UIButton *help_btn;
    UIButton *shareschoolBtn;

    NSMutableArray *mutable_school_image_arr;
    NSMutableDictionary *stardataDict;
    NSMutableDictionary *showstarDict;
    BOOL _Dragging;
    BOOL _appear;
    UIButton *_leftBarbtn;
    CGFloat _start_y;
    BOOL _nav_donghua;

    NSMutableDictionary *AdmissionDict;
    NSMutableArray *AdmissionsArr;
    UIView *_tabbar;
    UIWebView *web;
    UIActionSheet *renzheng_webSheet;
    NSMutableString *___web;
    NSMutableString *friend_token;
    NSMutableArray *admission_btnarr;
    UIImageView *imageGray;

    BOOL _isguanzhu;
    UIImageView *_coll_titleimg;
    UIView *_coll_titlelab;
    UIImageView *_tuition_titleimg;
    UILabel *_tution_titlelab;
    CLLocationCoordinate2D coordinate;
    UIView *_view_Admissions;
    YYAnimationIndicator *indicator;
    UIActionSheet *emailSheet1;
    UIActionSheet *phoneSheet1;
    UIActionSheet *emailSheet;
    UIActionSheet *webSheet;
    UIActionSheet *phoneSheet;
    UIActionSheet *JumpwebsiteSheet;
    UIImageView *_map_titleImg;
    UIButton *addGoalBtn;
    UILabel *addGoalLabel;
    UILabel *comment_num_label;
//    UIButton *quanping_btn;
    UIButton *suoxiao_btn;
    UIWebView *phoneCallWebView;

    NSInteger _is_order_school;
    NSMutableDictionary *dict_Data;


    UILabel *num_pf;
    NSMutableString *ratings_avg;
    CLGeocoder *Geocoder;//CLGeocoder
    NSMutableString *totleStr;
    MKMapView *_mkMapView;
    UIView *_mapView;
    BOOL _ispingfen;
    BOOL _ispingfen_change;
    //评分赞的view
    UILabel *label_num_view;
    schoolDetailModel *detail_model;
    NSArray *xunzhangArr;

    UIScrollView *_scrollView;
    UIImageView *_view_school_intro;
    UIView *_view_Category;
    UIView *_view_Rank;
    UIView *_view_Map;
    UIView *_view_Grade_ProportionView;
    UIView *_view_activity;
    UIView *_view_organization;
    UIView *_view_wenli;
    UIView *_view_zonghe;
    UIView *_view_AdmissionOfficer;
    UIView *_view_SSAT;
    UIView *_view_school_profile;
    UIView *_view_school_data;
    UIView *_view_AP_Lession;
    UIView *_view_student_Proportion;
    UIView *_view_Grade;
    UIView *_view_StuGrade;
    UIView *_view_other_Lession;
    UIView *_view_Tuition;
    UIView *_view_Certification;
    UIView *_view_Bag;
    NSInteger pingfen_num;


    //    存放星星的数组
    NSMutableArray *starsArr;

    UIPageControl *_pageControl;
    UIPageControl *_pageadmissionControl;
    UIPageViewController *_pageViewControler;
    UIPageViewController *_pageViewadmissionControler;

    NSInteger coll_Num;
    NSInteger praise_Num;
    NSInteger star_Num_s;
    NSString *isStar;
    UILabel *_num_p;
    //    收藏数量
    UILabel *_num_c;
    NSInteger starNum;
    BOOL isshow;

    BOOL app1;
    BOOL app2;

    
}
-(void)xiaoshi:(NSNotification *)not
{

    if([not.object isEqualToString:@"other"])
    {
        [self dismissModalViewControllerAnimated:YES];
    }

}
-(void)other
{
    [self dismissModalViewControllerAnimated:YES];
    [self requestUserDataisFirst:YES];

}
- (void)handleSwipes:(UISwipeGestureRecognizer *)sender
{
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        if(_sid!=nil)
        {
            schoolCommentController *comment=[[schoolCommentController alloc] init];
            comment.sid=_sid;
            [self.navigationController pushViewController:comment animated:YES];

        }


    }
    if (sender.direction == UISwipeGestureRecognizerDirectionRight) {

        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    self.rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    self.leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    self.rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:self.leftSwipeGestureRecognizer];
    [self.view addGestureRecognizer:self.rightSwipeGestureRecognizer];

    _appear=YES;
    _Dragging=NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(xiaoshi:) name:@"xiaoshi" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(other) name:@"other" object:nil];
    [self prepareData];
    _scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(_margin, _margin, ScreenWidth-2*_margin, ScreenHeight-2*_margin+49-100*_Scale)];
//    _scrollView.scrollsToTop=YES;
    _scrollView.showsVerticalScrollIndicator=YES;
    _scrollView.backgroundColor=_define_backview_color;
    _scrollView.delegate=self;
    _scrollView.contentSize=CGSizeMake(CGRectGetWidth(_scrollView.frame), 1000);
    [self.view addSubview:_scrollView];


    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Admissionblock:) name:@"Admissionblock" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(navBarReset) name:@"navBarReset" object:nil];

}

#pragma mark-点击状态栏时de导航栏重置
- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    _Dragging=NO;
    self.navigationController.navigationBar.frame=CGRectMake(0, 20, [[UIScreen mainScreen]bounds].size.width, 44);
    self.navigationItem.titleView.alpha=1;
    _nav_donghua=NO;
    _leftBarbtn.alpha=1;
    shareschoolBtn.alpha=1;

    // Do your action here
    return YES;
}
#pragma mark-导航栏重置
-(void)navBarReset
{
    _Dragging=NO;
    self.navigationController.navigationBar.frame=CGRectMake(0, 20, [[UIScreen mainScreen]bounds].size.width, 44);
    self.navigationItem.titleView.alpha=1;
    _nav_donghua=NO;
    _leftBarbtn.alpha=1;
    shareschoolBtn.alpha=1;
}

-(void)Admissionblock:(NSNotification *)not
{
//    key content
    NSDictionary *dict=not.object;
    [AdmissionDict removeAllObjects];
    [AdmissionDict setValuesForKeysWithDictionary:[dict objectForKey:@"content"]];
    NSLog(@"111");
    if([[dict objectForKey:@"key"] integerValue]==0)
    {
        //电话

        if(([[dict objectForKey:@"content"] objectForKey:@"cell"]!=[NSNull null])&&(![[[dict objectForKey:@"content"] objectForKey:@"cell"] isEqualToString:@""]))
        {
            phoneSheet1=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:[[dict objectForKey:@"content"] objectForKey:@"cell"] otherButtonTitles: nil];
            phoneSheet1.actionSheetStyle = UIActionSheetStyleBlackOpaque;
            [phoneSheet1 showInView:self.view];


        }
    }else if([[dict objectForKey:@"key"] integerValue]==1)
    {
        //邮件
        NSLog(@"%@",[[dict objectForKey:@"content"] objectForKey:@"email"]);
        if(([[dict objectForKey:@"content"] objectForKey:@"email"]!=[NSNull null])&&(![[[dict objectForKey:@"content"] objectForKey:@"email"] isEqualToString:@""]))
        {
            emailSheet1=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"发送邮件"otherButtonTitles: nil];
            emailSheet1.actionSheetStyle = UIActionSheetStyleBlackOpaque;
            [emailSheet1 showInView:self.view];
            
        }
    }
}

//#pragma mark-招生官
//-(void)Admissionblock
//{
//    Admissionblock=^(NSDictionary *dict,NSInteger num)
//    {
//        NSLog(@"%@",dict);
//        NSLog(@"%ld",(long)num);
//        NSLog(@"1111");
//
//    };
//
//}
-(void)commentAction
{


//    schoolCommentController
    schoolCommentController *comment=[[schoolCommentController alloc] init];
    comment.sid=_sid;
    [self.navigationController pushViewController:comment animated:YES];

}
-(void)changeCommentNum_Action:(NSNotification *)not
{
    comment_num_label.text=[[NSString alloc] initWithFormat:@"%ld",(long)[not.object integerValue]];
}
-(void)prepareData
{

    _nav_donghua=NO;
    _start_y=0;

    mutable_school_image_arr=[[NSMutableArray alloc] init];
    AdmissionDict=[[NSMutableDictionary alloc] init];
    AdmissionsArr=[[NSMutableArray alloc] init];
    comment_num_label=[[UILabel alloc] init];
    _num_c=[[UILabel alloc] init];
    _num_p=[[UILabel alloc] init];
    addGoalBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    addGoalLabel=[[UILabel alloc] init];
    friend_token=[[NSMutableString alloc] init];
    admission_btnarr=[[NSMutableArray alloc] init];
    ___web=[[NSMutableString alloc] init];
    isshow=NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCommentNum_Action:) name:@"changenum" object:nil];
  


    _leftBarbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [_leftBarbtn setImage:[UIImage imageNamed:@"返回箭头"] forState:UIControlStateNormal];
    _leftBarbtn.frame=CGRectMake(0, 0, 22, 22);
    [_leftBarbtn addTarget:self action:@selector(popviewAction) forControlEvents:UIControlEventTouchUpInside];
    [_leftBarbtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    UIBarButtonItem *_btn=[[UIBarButtonItem alloc] initWithCustomView:_leftBarbtn];
    self.navigationItem.leftBarButtonItem=_btn;

    shareschoolBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    shareschoolBtn.frame=CGRectMake(0, 0, 20, 20);
    [shareschoolBtn setImage:[UIImage imageNamed:@"school_share"] forState:UIControlStateNormal];
//    [shareschoolBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    [shareschoolBtn addTarget:self action:@selector(shareBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *_btn1=[[UIBarButtonItem alloc] initWithCustomView:shareschoolBtn];
    self.navigationItem.rightBarButtonItem=_btn1;


    dict_Data=[[NSMutableDictionary alloc] initWithObjectsAndKeys:
               [[NSMutableArray alloc] init],
               @"zonghe",
               [[NSMutableArray alloc] init],
               @"wenli",
               nil];

    ratings_avg=[[NSMutableString alloc] init];
    _ispingfen_change=NO;
    starNum=0;
    _ispingfen=NO;
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    pingfen_num=0;

    coll_Num=0;
    praise_Num=0;
    star_Num_s=143;
    isStar=@"0";

    self.view.backgroundColor=_define_backview_color;

}


#pragma mark-获取学校数据
-(void)loadAllData
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSUserDefaults *dict=[NSUserDefaults standardUserDefaults];
    NSString *_token=nil;
    if([dict objectForKey:@"token"]==nil)
    {
        _token=@"";
    }else
    {
        _token=[dict objectForKey:@"token"];
    }
    NSDictionary *parameters=@{@"token":_token};
    NSString *url=[[NSString alloc] initWithFormat:@"%@%@%@",DNS,@"/v3/schools/",_sid];
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *html = operation.responseString;
        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];

        if([[dict objectForKey:@"code"] intValue]==1)
        {
/*************************学习数据解析**********************/

            detail_model=[schoolDetailModel parsingWithJsonDataForModel:dict[@"data"]];
            kefu_model=[usermodel parsingData_single:[[dict objectForKey:@"data"] objectForKey:@"server"]];

            [dict_Data setValue:[graduationModel parsingWithJsonArr:[[dict objectForKey:@"data"] objectForKey:@"zonghe_universities"]] forKey:@"zonghe"];
            [dict_Data setValue:[graduationModel parsingWithJsonArr:[[dict objectForKey:@"data"] objectForKey:@"wenli_universities"]] forKey:@"wenli"];
/*************************学校数据解析**********************/
            NSInteger comment_count=[[[[dict objectForKey:@"data"] objectForKey:@"school_ratings"] objectForKey:@"comment_count"]integerValue];
            comment_num_label.text=[[NSString alloc] initWithFormat:@"%lu",(unsigned long)comment_count];
            coll_Num=detail_model.follows_count;
            praise_Num=detail_model.votes_count;
            pingfen_num=detail_model.ratings_count;
            [ratings_avg setString:detail_model.ratings_avg];

            [self loadWebview];


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
//        [regular removeProgress];
    }];
    
}
-(void)requestUserDataisFirst:(BOOL )isfrist
{


    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[[NSString alloc] initWithFormat:@"%@%@",DNS,@"/v2/schools/user_school_info"] parameters:@{@"school_id":_sid,@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *html = operation.responseString;
        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];

        if([[dict objectForKey:@"code"] intValue]==1)
        {
            if([[dict objectForKey:@"data"] objectForKey:@"had_rating"]==[NSNull null])
            {
                _ispingfen=NO;
            }else
            {
                if([[[dict objectForKey:@"data"] objectForKey:@"had_rating"] boolValue])
                {
                    _ispingfen=YES;
                    ((UIButton *)[self.view viewWithTag:7000]).selected=YES;
                }else
                {
                    _ispingfen=NO;

                }

            }
            if([[dict objectForKey:@"data"] objectForKey:@"is_order_school"]!=[NSNull null]&&[[dict objectForKey:@"data"] objectForKey:@"is_order_school"]!=nil)
            {
                _is_order_school=[[[dict objectForKey:@"data"] objectForKey:@"is_order_school"] integerValue];
                if(_is_order_school>0)
                {
                    ((UIButton *)[self.view viewWithTag:7002]).selected=YES;
                    addGoalLabel.text=@"移除目标";

                }else
                {
                    ((UIButton *)[self.view viewWithTag:7002]).selected=NO;
                    addGoalLabel.text=@"加为目标";
                }


            }

            if([[dict objectForKey:@"data"] objectForKey:@"had_voted"]!=[NSNull null]&&[[dict objectForKey:@"data"] objectForKey:@"had_voted"]!=nil)
            {
                detail_model.had_voted=[[[dict objectForKey:@"data"] objectForKey:@"had_voted"] boolValue];
                if(detail_model.had_voted)
                {
                    ((UIButton *)[self.view viewWithTag:7001]).selected=YES;
                }
            }


            if([[dict objectForKey:@"data"] objectForKey:@"rating_score"]!=[NSNull null]&&[[dict objectForKey:@"data"] objectForKey:@"rating_score"]!=nil)
            {
                detail_model.rating_score=[[[dict objectForKey:@"data"] objectForKey:@"rating_score"] floatValue];
            }

            if([[dict objectForKey:@"data"] objectForKey:@"had_followed"]!=[NSNull null]&&[[dict objectForKey:@"data"] objectForKey:@"had_followed"]!=nil)
            {
                detail_model.had_followed=[[[dict objectForKey:@"data"] objectForKey:@"had_followed"] boolValue];
                if(detail_model.had_followed)
                {
                    ((UIButton *)[self.view viewWithTag:7003]).selected=YES;
                }

            }

        }else
        {
            [[ToolManager sharedManager] alertTitle_Simple:[dict objectForKey:@"message"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
    }];

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{


    if([[NSUserDefaults standardUserDefaults] objectForKey:@"token"]==nil)
    {
        LoginViewController*login=[[LoginViewController alloc] init];
        login.type=@"other";
        [self presentModalViewController:login animated:YES];
    }
}
#pragma mark-勋章详情view消失
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[self.view viewWithTag:200] removeFromSuperview];
}

#pragma mark-大头针
-(MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation {

    MKAnnotationView *newAnnotation=[[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"annotation1"];
    newAnnotation.image = [UIImage imageNamed:@"map_单个学校"];
    newAnnotation.canShowCallout=YES;
    return newAnnotation;
}
-(void)backGes:(UIGestureRecognizer *)ges
{
    [[self.view.window viewWithTag:200] removeFromSuperview];

}
-(void)showtap{}
#pragma mark-勋章详情
-(void)showDetail:(UIGestureRecognizer *)ges
{

    NSInteger num=ges.view.tag-800;
    NSDictionary *dict=xunzhangArr[num];
    //    if(num)
    //    xunzhangArr
    UIView *backview=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    backview.tag=200;
    [self.view.window addSubview:backview];
    backview.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    UITapGestureRecognizer *tapback=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backGes:)];
    [backview addGestureRecognizer:tapback];

    UIImageView *showback=[[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth-600*_Scale)/2.0f, (ScreenHeight-580*_Scale)/2.0f, 600*_Scale, 580*_Scale)];

    showback.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap111=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showtap)];
    [showback addGestureRecognizer:tap111];
    showback.backgroundColor=_define_blue_color;

    NSString *___title=nil;
    if(([dict objectForKey:@"en_name"]==[NSNull null])||([dict objectForKey:@"en_name"]==nil))
    {
        ___title=@"";
    }else
    {
        ___title=[dict objectForKey:@"en_name"];
    }
    //    115
    UILabel *titlelabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 25*_Scale, CGRectGetWidth(showback.frame), 80*_Scale)];
    [showback addSubview:titlelabel];
    titlelabel.textAlignment=1;
    titlelabel.textColor=[UIColor whiteColor];
    titlelabel.font=[regular get_en_Font:14.0f];
//    titlelabel.backgroundColor=[UIColor redColor];
    titlelabel.numberOfLines=0;
    [titlelabel setAttributedText:[regular createAttributeString:___title andFloat:@(1.0)]];


    NSString *___title1=nil;
    if(([dict objectForKey:@"cn_name"]==[NSNull null])||([dict objectForKey:@"cn_name"]==nil))
    {
        ___title1=@"";
    }else
    {
        ___title1=[dict objectForKey:@"cn_name"];
    }
    UILabel *titlelabel1=[[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titlelabel.frame), CGRectGetWidth(showback.frame), 60*_Scale)];
//    titlelabel1.backgroundColor=[UIColor blueColor];
    [showback addSubview:titlelabel1];
    titlelabel1.textAlignment=1;
    titlelabel1.textColor=[UIColor whiteColor];
    titlelabel1.font=[regular getFont:14.0f];
    titlelabel1.numberOfLines=0;
    [titlelabel1 setAttributedText:[regular createAttributeString:___title1 andFloat:@(1.0)]];


    NSString *___year=nil;
    if(([dict objectForKey:@"year"]==[NSNull null])||([dict objectForKey:@"year"]==nil))
    {
        ___year=@"";
    }else
    {
        ___year=[[NSString alloc] initWithFormat:@"- %ld -",[[dict objectForKey:@"year"] longValue]];
    }
    //45
    UILabel *Timelabel=[[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titlelabel1.frame), CGRectGetWidth(showback.frame), 45*_Scale)];
    [showback addSubview:Timelabel];
    Timelabel.textAlignment=1;
    Timelabel.textColor=[UIColor whiteColor];
    Timelabel.font=[regular get_en_Font:12.0f];
    [Timelabel setAttributedText:[regular createAttributeString:___year andFloat:@(1.0)]];



    NSString *___content__=nil;
    if(([dict objectForKey:@"description"]==[NSNull null])||([dict objectForKey:@"description"]==nil))
    {
        ___content__=@"";
    }else
    {
        ___content__=[dict objectForKey:@"description"] ;
    }
    //240
    UIScrollView *___content=[[UIScrollView alloc] initWithFrame:CGRectMake(20*_Scale, CGRectGetMaxY(Timelabel.frame), CGRectGetWidth(showback.frame)-40*_Scale, 280*_Scale)];
    ___content.scrollsToTop=NO;
    [showback addSubview:___content];
    UILabel *contentLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(___content.frame), 9999)];
    contentLabel.numberOfLines=0;
    contentLabel.textColor=[UIColor whiteColor];
    contentLabel.lineBreakMode=NSLineBreakByCharWrapping;
    contentLabel.font=[regular get_en_Font:12.0f];

    [contentLabel setAttributedText:[regular createAttributeString:___content__ andFloat:@(1.0)]];

    [contentLabel sizeToFit];
    //    contentLabel.backgroundColor=[UIColor redColor];
    [___content addSubview:contentLabel];


    ___content.contentSize=CGSizeMake(CGRectGetWidth(___content.frame), CGRectGetMaxY(contentLabel.frame));



    //    CGFloat *___height=0;
    if(contentLabel.frame.size.height<___content.frame.size.height)
    {
        CGFloat __xx=___content.frame.size.height-contentLabel.frame.size.height;
        ___content.frame=CGRectMake(CGRectGetMinX(___content.frame), CGRectGetMinY(___content.frame), CGRectGetWidth(___content.frame), contentLabel.frame.size.height);
        showback.frame=CGRectMake(CGRectGetMinX(showback.frame), CGRectGetMinY(showback.frame)+(__xx/2.0f), CGRectGetWidth(showback.frame), CGRectGetHeight(showback.frame)-__xx);

    }


    if(([dict objectForKey:@"web"]==[NSNull null])||([dict objectForKey:@"web"]==nil))
    {
        [___web setString:@""];
    }else
    {
        [___web setString:[dict objectForKey:@"web"]];
    }



    if(![___web isEqualToString:@""])
    {
        UIImageView *toweb=[[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(showback.frame)-60*_Scale, CGRectGetWidth(showback.frame), 60*_Scale)];
        [showback addSubview:toweb];
        toweb.userInteractionEnabled=YES;
        //    if([___web isEqualToString:@""])
        //    {
        //        toweb.backgroundColor=[UIColor clearColor];
        //
        //    }else
        //    {

        toweb.backgroundColor=[UIColor whiteColor];
        //    }

        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(renzheng_web:)];
        [toweb addGestureRecognizer:tap];

        UILabel *weblabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(toweb.frame), CGRectGetHeight(toweb.frame))];
        [toweb addSubview:weblabel];
        weblabel.textColor=_define_blue_color;
        weblabel.userInteractionEnabled=YES;
        weblabel.textAlignment=1;

        //    [weblabel addGestureRecognizer:tap];
        weblabel.font=[regular get_en_Font:13.0f];
        [weblabel setAttributedText:[regular createAttributeString:___web andFloat:@(1.0)]];

    }else
    {
         showback=[[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth-600*_Scale)/2.0f, (ScreenHeight-440*_Scale)/2.0f, 600*_Scale, 440*_Scale)];
    }
    
    //    @"refreshList"
    //    @"backlogin"
    //    @"other"
    [backview addSubview:showback];
    
}
-(void)renzheng_web:(UIGestureRecognizer*)ges
{
    if(![___web isEqualToString:@""])
    {
        renzheng_webSheet=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"访问网站"otherButtonTitles: nil];
        renzheng_webSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [renzheng_webSheet showInView:self.view];

    }
    
}
-(void)popviewAction
{
    [[CustomTabbarController sharedManager] tabbarAppear];
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)backaction:(UIGestureRecognizer *)ges
{

}
-(void)xiaoshi
{
    [[self.view.window viewWithTag:3000] removeFromSuperview];
}
-(void)friend_list:(UIGestureRecognizer *)ges
{

    if(ges.view.tag==6000)
    {
        followerViewController *foll=[[followerViewController alloc] init];
        foll.token=friend_token;
        [self.navigationController pushViewController:foll animated:YES];
        [self xiaoshi];


    }else
    {
        followingViewController *foll=[[followingViewController alloc] init];
        foll.token=friend_token;
        [self.navigationController pushViewController:foll animated:YES];
        [self xiaoshi];

    }
}


-(void)createAdmissionsViewWithView:(UIView *)subview
{


    for (NSDictionary *dict in detail_model.admission_officers_json) {
        BOOL _b=YES;
        if((([[dict objectForKey:@"cell"] isEqualToString:@""])||([dict objectForKey:@"cell"]==[NSNull null]))&&(([[dict objectForKey:@"email"] isEqualToString:@""])||([dict objectForKey:@"email"]==[NSNull null])))
        {
            _b=NO;
        }

        if(dict!=nil&&_b)
        {
            [AdmissionsArr addObject:dict];
        }

    }

    NSLog(@"%@",AdmissionsArr);
    if(AdmissionsArr.count>0)
    {
        _view_Admissions=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(subview.frame)+_margin, CGRectGetWidth(_scrollView.frame), 460*_Scale)];
        _view_Admissions.backgroundColor=[UIColor whiteColor];
        _pageViewadmissionControler = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];

        AdmissionViewController *imgvc = [[AdmissionViewController alloc]init];
        imgvc.array=AdmissionsArr;
        imgvc.view.backgroundColor = [UIColor whiteColor];

        imgvc.currentPage = 0;
        [_pageViewadmissionControler setViewControllers:@[imgvc] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
        _pageViewadmissionControler.delegate = self;
        _pageViewadmissionControler.dataSource = self;

        CGFloat w = self.view.frame.size.width-2*_margin;
    
        _pageViewadmissionControler.view.frame = CGRectMake(0, 0, w, CGRectGetHeight(_view_Admissions.frame));
        [_view_Admissions addSubview:_pageViewadmissionControler.view];
    
        _pageadmissionControl = [[UIPageControl alloc]init];
        _pageadmissionControl.center = CGPointMake(w/2,  CGRectGetHeight(_view_Admissions.frame)-15);
        [_view_Admissions addSubview:_pageadmissionControl];
        _pageadmissionControl.numberOfPages = AdmissionsArr.count;
        _pageadmissionControl.currentPageIndicatorTintColor = yellow_color;
        _pageadmissionControl.pageIndicatorTintColor = [UIColor colorWithRed:204.0f/255.0f green:204.0f/255.0f blue:204.0f/255.0f alpha:1];

    }else
    {
        _view_Admissions=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(subview.frame), CGRectGetWidth(_scrollView.frame), 0)];
    }


    [_scrollView addSubview:_view_Admissions];
    _scrollView.contentSize=CGSizeMake(CGRectGetWidth(_scrollView.frame)-4*_Scale, CGRectGetMaxY(_view_Admissions.frame)+200*_Scale);

}

-(void)createGrade_ProportionViewWithView:(UIView *)subview
{
    NSString *guojibi=nil;
    NSString *shishengbi=nil;
    if(detail_model.total_students==0||detail_model.teachers_count==0)
    {
        guojibi=@"";
        shishengbi=@"";
    }else
    {
        if(detail_model.international_students==0)
        {
            guojibi=@"";
        }else
        {
            guojibi=[[NSString alloc] initWithFormat:@"%.0f%%",100*(((CGFloat)detail_model.international_students)/((CGFloat)detail_model.total_students))];
        }

        if(detail_model.teachers_count==0)
        {
            shishengbi=@"";
        }else
        {
            shishengbi=[[NSString alloc] initWithFormat:@"1:%.1ld",(detail_model.total_students)/(detail_model.teachers_count)];
        }
    }

    NSArray *_titleArr=@[@"总学生数",@"国际生数",@"中国学生数",@"国际生比",@"教职工数",@"课堂规模",@"校园面积",@"师生比"];
    NSArray *_contentArr=@[
                          [[NSString alloc]initWithFormat:@"%ld",(long)detail_model.total_students]
                          ,[[NSString alloc] initWithFormat:@"%ld",(long)detail_model.international_students]
                          ,detail_model.asian_students
                          ,guojibi
                          ,[[NSString alloc]initWithFormat:@"%ld",(long)detail_model.teachers_count]
                          ,detail_model.class_size
                          ,detail_model.square
                          ,shishengbi
                          ];
    BOOL _isshow=NO;
    for (int i=0 ; i<_contentArr.count; i++) {

        if(i==3||i==7)
        {
            if(![[_contentArr objectAtIndex:i] isEqualToString:@""])
            {
                _isshow=YES;
                break;
            }
        }else
        {
            if([[_contentArr objectAtIndex:i] integerValue]>0)
            {
                _isshow=YES;
                break;
            }
        }
    }
    if(_isshow)
    {
        _view_Grade_ProportionView=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(subview.frame)+_margin, CGRectGetWidth(_scrollView.frame), 440*_Scale)];
        CGFloat _diameter=100*_Scale;
        CGFloat _bianju=54*_Scale;
        CGFloat _y_p1=50*_Scale;
        CGFloat _y_p2=244*_Scale;
        CGFloat _x_p=_bianju;
        CGFloat _jiange=(CGRectGetWidth(_view_Grade_ProportionView.frame)-_diameter*4-2*_bianju)/3.0f;

        for (int i=0; i<_titleArr.count; i++) {

            CGFloat _y_p=i<4?_y_p1:_y_p2;
            UIView *backview=[[UIView alloc] initWithFrame:CGRectMake(_x_p, _y_p, _diameter, _diameter)];
            if([[_contentArr objectAtIndex:i] isEqualToString:@"0"]||[[_contentArr objectAtIndex:i] isEqualToString:@""])
            {
                backview.backgroundColor=[UIColor colorWithRed:250.0f/255.0f green:250.0f/255.0f  blue:250.0f/255.0f  alpha:1];
            }else
            {
                backview.backgroundColor=_define_blue_color;
            }
            backview.layer.masksToBounds=YES;
            backview.layer.cornerRadius=_diameter/2.0f;
            [_view_Grade_ProportionView addSubview:backview];
            UILabel *_content=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, _diameter, _diameter)];
            [backview addSubview:_content];
            _content.textColor=[UIColor whiteColor];
            _content.textAlignment=1;
            _content.font=[regular get_en_Font:16.0f];
            if([[_contentArr objectAtIndex:i] isEqualToString:@"0"])
            {
                _content.text=@"";

            }else
            {
                _content.text=[_contentArr objectAtIndex:i];
            }

            UILabel *_titlellabel=[[UILabel alloc] init];
            _titlellabel.textAlignment=1;
            _titlellabel.font=[regular getFont:11.0f];
            _titlellabel.text=[_titleArr objectAtIndex:i];
            _titlellabel.textColor=[UIColor colorWithRed:135.0f/255.0f green:135.0f/255.0f blue:135.0f/255.0f alpha:1];
            [_titlellabel sizeToFit];
            _titlellabel.frame=CGRectMake(CGRectGetMinX(backview.frame)+(CGRectGetWidth(backview.frame)-CGRectGetWidth(_titlellabel.frame))/2.0f, CGRectGetMaxY(backview.frame)+14*_Scale, CGRectGetWidth(_titlellabel.frame), CGRectGetHeight(_titlellabel.frame));
            [_view_Grade_ProportionView addSubview:_titlellabel];

            if(i==3)
            {
                _x_p=_bianju;
            }else
            {
                _x_p+=_jiange+_diameter;
            }
        }

    }else
    {
        _view_Grade_ProportionView=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(subview.frame), CGRectGetWidth(_scrollView.frame), 0)];
    }


    [_scrollView addSubview:_view_Grade_ProportionView];
    _view_Grade_ProportionView.backgroundColor=[UIColor whiteColor];


}
-(void)createGradeBagViewWithView:(UIView *)subview
{

    if([detail_model.grade isEqualToString:@""])
    {

         _view_Bag=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(subview.frame), CGRectGetWidth(_scrollView.frame), 0)];
    }else
    {
         _view_Bag=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(subview.frame)+_margin, CGRectGetWidth(_scrollView.frame), 220*_Scale)];

        UIImageView *bag=[[UIImageView alloc] initWithFrame:CGRectMake(100*_Scale, 60*_Scale, 80*_Scale, 80*_Scale)];
        [_view_Bag addSubview:bag];
        bag.image=[UIImage imageNamed:@"school_bag"];
        UILabel *titlelabel=[[UILabel alloc] init];
        [_view_Bag addSubview:titlelabel];
        titlelabel.textColor=[UIColor colorWithRed:135.0f/255.0f green:135.0f/255.0f blue:135.0f/255.0f alpha:1];
        [titlelabel setAttributedText:[regular createAttributeString:@"年级提供" andFloat:@(2.0)]];
        titlelabel.textAlignment=1;
        titlelabel.font=[regular getFont:13.0f];
        [titlelabel sizeToFit];
        titlelabel.frame=CGRectMake(CGRectGetMinX(bag.frame)-20*2*_Scale, CGRectGetMaxY(bag.frame)+14.0f*_Scale, CGRectGetWidth(bag.frame)+40*2*_Scale, CGRectGetHeight(titlelabel.frame));


        UILabel *_contenttitle=[[UILabel alloc] init];
        _contenttitle.textColor=_define_blue_color;
        _contenttitle.font=[regular get_en_Font:30.0f];
        _contenttitle.text=detail_model.grade;
        _contenttitle.textAlignment=1;
        [_contenttitle sizeToFit];
        _contenttitle.frame=CGRectMake(CGRectGetMaxX(bag.frame), (CGRectGetHeight(_view_Bag.frame)-CGRectGetHeight(_contenttitle.frame))/2.0f,CGRectGetWidth(_view_Bag.frame)-CGRectGetMaxX(bag.frame), CGRectGetHeight(_contenttitle.frame));
        [_view_Bag addSubview:_contenttitle];
    }
    [_scrollView addSubview:_view_Bag];
    _view_Bag.backgroundColor=[UIColor whiteColor];


}
#pragma mark-UIconfig
-(void)UIConfig
{
    [self createImgScreenView];
    [self createSchoolIntroduceView];
    [self createAdmissionOfficerViewWithView:_view_school_intro];
    [self createRankViewWithView:_view_AdmissionOfficer];
    [self createCategoryViewWithView:_view_Rank];
    [self createProfileViewWithView:_view_Category];
    [self createAdmissionsViewWithView:_view_school_profile];
    [self createMapViewWithView:_view_Admissions];
    [self createGrade_ProportionViewWithView:_view_Map];
    [self createGradeBagViewWithView:_view_Grade_ProportionView];
    [self createStuGradeNumViewWithView:_view_Bag];
    [self createDataViewWithView:_view_StuGrade];
    [self createAPLessionViewWithView:_view_school_data];
    [self create_extra_activityViewWithView:_view_AP_Lession];

    [self create_extra_organizationViewWithView:_view_activity];
    [self createCertificationViewWithView:_view_organization];
    [self createSSATViewWithView:_view_Certification];
    [self createTuitionViewWithView:_view_SSAT];

    NSArray *array1=[dict_Data objectForKey:@"zonghe"];
    NSArray *array2=[dict_Data objectForKey:@"wenli"];
    if((array1.count>0)||(array2.count>0))
    {
        _coll_titleimg=[[ToolManager sharedManager] createTitleView:@"毕业生去哪儿？＊" WithRect:CGRectMake(0, CGRectGetMaxY(_view_Tuition.frame)+_margin, CGRectGetWidth(_scrollView.frame), 60*_Scale) WithImg:@""  WithtitleColor:_define_blue_color WithTextAlignment:1  Withjiange:3.0f];
        _coll_titleimg.backgroundColor=_define_cailiao_color;

    }else{

        _coll_titleimg=[[ToolManager sharedManager] createTitleView:@"" WithRect:CGRectMake(0, CGRectGetMaxY(_view_Tuition.frame), CGRectGetWidth(_scrollView.frame), 0) WithImg:@""  WithtitleColor:_define_blue_color WithTextAlignment:1  Withjiange:3.0f];
        _coll_titleimg.backgroundColor=_define_cailiao_color;
    }
    [_scrollView addSubview:_coll_titleimg];

    [self createZongheViewWithView:_coll_titleimg];
    [self createWenliViewWithView:_view_zonghe];
    if((array1.count>0)||(array2.count>0))
    {
        _coll_titlelab=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_view_wenli.frame), CGRectGetWidth(_scrollView.frame), 50*_Scale)];
        _coll_titlelab.backgroundColor=self.view.backgroundColor;
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(34*_Scale, 0, CGRectGetWidth(_coll_titlelab.frame)-34*_Scale*2, CGRectGetHeight(_coll_titlelab.frame))];
        label.backgroundColor=_define_cailiao_color;
        [_coll_titlelab addSubview:label];

        label.font=[regular get_en_Font:10.0f];
        label.textColor=_define_blue_color;
        label.textAlignment=1;
        label.text=@"＊只统计 US NEWS 2016 排名 前200位学院";
        _scrollView.contentSize=CGSizeMake(CGRectGetWidth(_scrollView.frame)-4*_Scale, CGRectGetMaxY(_view_wenli.frame)+220*_Scale);

    }else
    {

        _coll_titlelab=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_view_wenli.frame), ScreenWidth, 0)];
        _scrollView.contentSize=CGSizeMake(CGRectGetWidth(_scrollView.frame)-4*_Scale, CGRectGetMaxY(_view_wenli.frame)+170*_Scale);
    }
    [_scrollView addSubview:_coll_titlelab];

    NSLog(@"y_p=%f",CGRectGetMaxY(_coll_titlelab.frame));
    help_btn=[UIButton buttonWithType:UIButtonTypeCustom];
    help_btn.backgroundColor=_define_blue_color;
    help_btn.frame=CGRectMake(10*_Scale, CGRectGetMaxY(_coll_titlelab.frame)+10*_Scale, CGRectGetWidth(_scrollView.frame)-20*_Scale, 80*_Scale);
    [help_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [help_btn setTitle:@"我要申请" forState:UIControlStateNormal];
    [help_btn.titleLabel setAttributedText:[regular createAttributeString:@"我要申请" andFloat:@(5.0)]];
    help_btn.titleLabel.font=[regular getFont:15.0f];
    help_btn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
    [help_btn addTarget:self action:@selector(help_action:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:help_btn];

    banbenimg=[[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(_scrollView.frame)-40*_Scale)/2.0f, CGRectGetMaxY(help_btn.frame)+20*_Scale, 40*_Scale, 39*_Scale)];
    banbenimg.image=[UIImage imageNamed:@"版本_v1.0"];

    [_scrollView addSubview:banbenimg];

    
    [self createtabbar];
}
//发起聊天
-(void)help_action:(UIButton *)btn
{
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"token"]!=nil)
    {
        ChatViewController *chatVC = [[ChatViewController alloc] initWithChatter:kefu_model.ease_mob_username isGroup:NO];
        [chatVC setH_title:kefu_model.username];
        chatVC.userinfo=@{@"cell":kefu_model.cell,@"is_server":[NSNumber numberWithBool:kefu_model.is_server],@"uid":kefu_model.user_id};
        chatVC.friend_head=kefu_model.avatar;
        chatVC.uid=kefu_model.user_id;
        chatVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:chatVC animated:YES];
    }else
    {
        LoginViewController*login=[[LoginViewController alloc] init];
        login.type=@"other";
        [self presentModalViewController:login animated:YES];
    }
}

- (void)shareBtnPress:(UIButton *)btn
{
    imageGray = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"蒙板"]];
    imageGray.userInteractionEnabled = YES;
    imageGray.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    imageGray.tag=878;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disapp)];
    [imageGray addGestureRecognizer:tap];
    [self.view.window addSubview:imageGray];

    app1 = [ShareSDK isClientInstalled:SSDKPlatformSubTypeWechatSession];
    app2 = [ShareSDK isClientInstalled:SSDKPlatformSubTypeQQFriend];

    UIView *fatherView=nil;
    if((app1==NO)&&(app2==NO))
    {
        fatherView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight-110*2*_Scale, kScreenWidth, 110*2*_Scale)];

    }else
    {
        fatherView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight-200*2*_Scale, kScreenWidth, 200*2*_Scale)];

    }

    fatherView.backgroundColor = [UIColor whiteColor];
    [imageGray addSubview:fatherView];

    NSArray *imageName = nil;
    NSArray *imageTitleName=nil;

    if((app1==NO)&&(app2==NO))
    {
        imageName = @[@"微博Share",@"qq空间Share",@"emailShare"];
        imageTitleName= @[@"微博",@"QQ空间",@"邮件"];

    }else if((app1==YES)&&(app2==NO))
    {

        imageName = @[@"微信Share",@"朋友圈Share",@"微博Share",@"qq空间Share",@"emailShare"];
        imageTitleName= @[@"微信",@"朋友圈",@"微博",@"QQ空间",@"邮件"];

    }else if((app1==NO)&&(app2==YES))
    {

        imageName = @[@"微博Share",@"qqShare",@"qq空间Share",@"emailShare"];
        imageTitleName= @[@"微博",@"QQ",@"QQ空间",@"邮件"];

    }else
    {

        imageName = @[@"微信Share",@"朋友圈Share",@"微博Share",@"qqShare",@"qq空间Share",@"emailShare"];
        imageTitleName= @[@"微信",@"朋友圈",@"微博",@"QQ",@"QQ空间",@"邮件"];
    }

    CGFloat _width=50*2*_Scale;

    CGFloat _jiange=(ScreenWidth-50*3*2*_Scale)/4.0f;
    for (int i = 0; i < imageName.count; i ++) {
        UIButton *btn = [regular createBtnWithRect:CGRectMake(_jiange + (_width+_jiange) * (i%3),15*2*_Scale+ 10*2*_Scale + 78*2*_Scale * (i/3), _width, _width) WithTitle:@"" WithNormalStr:imageName[i] WithSelectStr:nil];
        btn.tag = 9000 + i;

        [btn addTarget:self action:@selector(sharePressBtn:) forControlEvents:UIControlEventTouchUpInside];
        [fatherView addSubview:btn];
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(btn.frame)-10*2*_Scale, CGRectGetMaxY(btn.frame), CGRectGetWidth(btn.frame)+20*2*_Scale, 30*2*_Scale)];
//        label.backgroundColor=[UIColor redColor];
        [fatherView addSubview:label];
        label.textAlignment=1;
        label.textColor=[UIColor colorWithRed:150.0f/255.0f green:150.0f/255.0f  blue:150.0f/255.0f  alpha:1];
        label.font=[regular getFont:12.0f];
        [label setAttributedText:[regular createAttributeString:imageTitleName[i] andFloat:@(3.0)]];
        
    }


}
#pragma mark-发送邮件
-(void)displayComposerSheet:(NSString *)str
{

    BOOL _b=[MFMailComposeViewController canSendMail];
    if(_b==YES)
    {


        MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];

        picker.mailComposeDelegate = self;

        [picker setSubject:@"Enter Your Subject!"];

        // Set up recipients
        NSArray *toRecipients = [NSArray arrayWithObject:str];


        [picker setToRecipients:toRecipients];
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
        [self presentViewController:picker animated:NO completion:nil];


    }else
    {
        [[ToolManager sharedManager] alertTitle_Simple:@"请先设置邮箱帐号"];
        
    }
    
    
}
-(void)displayComposerSheetshare:(NSString *)str
{

    BOOL _b=[MFMailComposeViewController canSendMail];
    if(_b==YES)
    {

        [self.navigationController setNavigationBarHidden:NO animated:NO];

        MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
        picker.mailComposeDelegate = self;
        //  picker.navigationBar.tintColor = [UIColor blueColor];
        [picker setSubject:@"‘留美盒子’  美国高中都在这！"];



        [picker setMessageBody:str isHTML:YES];
        // Set up recipients
        NSArray *toRecipients = [NSArray arrayWithObject:str];

        [picker setToRecipients:toRecipients];
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

        [self presentViewController:picker animated:NO completion:nil];


    }else
    {
        [[ToolManager sharedManager] alertTitle_Simple:@"请先设置邮箱帐号"];

    }

}
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{

    switch (result)
    {
        case MFMailComposeResultCancelled: // 用户取消编辑
            NSLog(@"Mail send canceled...");
            break;
        case MFMailComposeResultSaved: // 用户保存邮件
            NSLog(@"Mail saved...");
            break;
        case MFMailComposeResultSent: // 用户点击发送
            NSLog(@"Mail sent...");
            break;
        case MFMailComposeResultFailed: // 用户尝试保存或发送邮件失败
            NSLog(@"Mail send errored: %@...", [error localizedDescription]);
            break;
    }
    // 关闭邮件发送视图
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)disapp
{
    [[self.view.window viewWithTag:878] removeFromSuperview];
    
}
- (void)sharePressBtn:(UIButton *)btn
{
    [self disapp];

    NSArray *arrayName =nil;
    //    id<ISSWeChatApp> app1 =(id<ISSWeChatApp>)[ShareSDK getClientWithType:ShareTypeWeixiTimeline];
    //    id<ISSQQApp> app2 =(id<ISSQQApp>)[ShareSDK getClientWithType:ShareTypeQQSpace];
    
    //  @[@(22),@(23),@(1),@(24),@(6),@(18)];
    //    @[@"微信Share",@"朋友圈Share",@"微博Share",@"qqShare",@"qq空间Share",@"emailShare"];
    if((app1==NO)&&(app2==NO))
    {
        
        arrayName =  @[@(1),@(6),@(18)];
        
    }else if((app1==YES)&&(app2==NO))
    {
        
        arrayName =@[@(22),@(23),@(1),@(6),@(18)];
        
        
    }else if((app1==NO)&&(app2==YES))
    {
        arrayName = @[@(1),@(24),@(6),@(18)];
        
    }else
    {
        arrayName = @[@(22),@(23),@(1),@(24),@(6),@(18)];
    }
    NSLog(@"ssss%ld",(long)[arrayName[btn.tag - 9000] integerValue]);
    
    //1、创建分享参数（必要）
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:@"" images:nil url:[NSURL URLWithString:@"https://appsto.re/cn/HYZ77.i"] title:[_data_dict objectForKey:@"schoolName"] type:SSDKContentTypeAuto];
    
    [shareParams SSDKEnableUseClientShare];
    NSInteger platformType = [arrayName[btn.tag - 9000] integerValue];
    //2、分享
    [ShareSDK share:(long)platformType parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        switch (state) {
                
            case SSDKResponseStateBegin:
            {
                break;
            }
            case SSDKResponseStateSuccess:
            {
                [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"分享成功" WithImg:@"Prompt_提交成功" Withtype:1]];
            }
            case SSDKResponseStateFail:
            {
                if(platformType==18)
                {
                    [[ToolManager sharedManager] alertTitle_Simple:@"请设置邮件账户"];
                }else if (platformType==24)
                {
                    [[ToolManager sharedManager] alertTitle_Simple:@"请安装QQ客户端"];
                    
                }else if(platformType==6)
                {
                    [[ToolManager sharedManager] alertTitle_Simple:@"请安装QQ空间客户端"];
                }else if (platformType==1)
                {
                    if(error.code==20019)
                    {
                        [[ToolManager sharedManager] alertTitle_Simple:@"请不要分享重复的内容"];
                    }
                }
            }
            case SSDKResponseStateCancel:
            {
                if(platformType!=SSDKPlatformSubTypeWechatSession&&platformType!=SSDKPlatformSubTypeQQFriend)
                {
                    [[ToolManager sharedManager] alertTitle_Simple:@"分享已取消"];
                }
                break;
            }
            default:
                break;
        }
    }];
}
-(void)tabbarAction:(UIButton *)btn
{

    NSInteger tag=btn.tag-7000;
    if(tag==0)
    {
//        评星
        [self showAlertStar];


    }else if(tag==1)
    {
//        点赞
        [self praise_action:btn];

    }else if(tag==2)
    {
//        添加到学校列表
        [self goalBtnAction:btn];

    }else if(tag==3)
    {
//        收藏
        [self collection_action:btn];

    }else if(tag==4)
    {
//        评论
        [self commentAction];

    }
}
-(void)createtabbar
{

    _tabbar=[[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight-100*_Scale, ScreenWidth, 100*_Scale)];
    [self.view addSubview:_tabbar];

    CGFloat _button_width=CGRectGetWidth(_tabbar.frame)/5.0f;

    for (int i=0; i<5; i++) {
        NSString *title_str=nil;
        UIButton *btn=nil;
        if(i==2)
        {
            btn=addGoalBtn;
        }else
        {
            btn=[UIButton buttonWithType:UIButtonTypeCustom];
        }
        btn.backgroundColor=[UIColor whiteColor];
        btn.frame=CGRectMake(_button_width*i, 0, _button_width, CGRectGetHeight(_tabbar.frame));
        btn.tag=7000+i;
        NSString *normalImgName=i==0?@"school_tabbar_评星":i==1?@"school_tabbar_赞":i==2?@"school_tabbar_添加":i==3?@"school_tabbar_喜欢":@"school_tabbar_评论";
        NSString *selectImgName=i==0?@"school_tabbar_评星select":i==1?@"school_tabbar_赞select":i==2?@"school_tabbar_删除":i==3?@"school_tabbar_喜欢select":@"school_tabbar_评论select";

        [btn setImage:[UIImage imageNamed:selectImgName] forState:UIControlStateSelected];

        [btn setImage:[UIImage imageNamed:normalImgName] forState:UIControlStateNormal];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(5*_Scale, 0, 25*_Scale, 0)];

        [_tabbar addSubview:btn];
        [[CustomTabbarController sharedManager] tabbarHide];

//        加线条
        if(i==1||i==3)
        {
            for (int j=0; j<2; j++) {
                UIView *xian=[[UIView alloc] initWithFrame:CGRectMake((_button_width-1*_Scale)*j, -5*_Scale+((CGRectGetHeight(_tabbar.frame)-66*_Scale)/2.0f), 1*_Scale, 76*_Scale)];
                xian.backgroundColor=self.view.backgroundColor;
                [btn addSubview:xian];
            }
        }
        if(i==2)
        {

//            添加目标学校状态
            if(_is_order_school==0)
            {
                btn.selected=NO;
                title_str=@"加为目标";
            }else if(_is_order_school>0)
            {
                btn.selected=YES;
                title_str=@"移除目标";
            }

        }else if(i==0)
        {
            title_str=@"评星";
//            评星状态
            if(detail_model.rating_score>0)
            {
                btn.selected=YES;
            }else
            {
                btn.selected=NO;
            }
        }else if(i==1)
        {
            title_str=@"点赞";
            if(detail_model.had_voted==YES)
            {
                btn.selected=YES;
            }else
            {
                btn.selected=NO;
            }
        }else if(i==3)
        {
            title_str=@"心愿";
            if(detail_model.had_followed==YES)
            {
                btn.selected=YES;
            }else
            {
                btn.selected=NO;
            }
        }else if(i==4)
        {
            title_str=@"评论";
        }
        [btn addTarget:self action:@selector(tabbarAction:) forControlEvents:UIControlEventTouchUpInside];
        if(i!=2)
        {

            UILabel *label=nil;
            if(i==0)
            {
                label=[[UILabel alloc] init];
            }else if(i==1)
            {
                label=_num_p;
            }else if(i==3)
            {
                label=_num_c;
            }else if(i==4)
            {
                label=comment_num_label;
            }
            else
            {
                label=[[UILabel alloc] init];
            }
            label.frame=CGRectMake(84*_Scale, 25*_Scale, CGRectGetWidth(btn.frame)-84*_Scale, 24*_Scale);
            [btn addSubview:label];
            label.font=[regular get_en_Font:9.0f];
            label.textAlignment=0;
            label.textColor=_define_blue_color;
            if(i==0)
            {
                label.text=[[NSString alloc] initWithFormat:@"%ld",(long)pingfen_num];
                label.tag=20000;
            }else if(i==1)
            {

                label.text=[[NSString alloc] initWithFormat:@"%ld",(long)detail_model.votes_count];
            }else if(i==3)
            {

                label.text=[[NSString alloc] initWithFormat:@"%ld",(long)detail_model.follows_count];

            }

        }

        UILabel *titlelabel=nil;
        if(i==2)
        {
            titlelabel=addGoalLabel;
        }else
        {
            titlelabel=[[UILabel alloc] init];
        }
        titlelabel.frame=CGRectMake(0, 60*_Scale, CGRectGetWidth(btn.frame), 40*_Scale);
        [btn addSubview:titlelabel];
//        titlelabel.backgroundColor=[UIColor redColor];
        titlelabel.textAlignment=1;
        titlelabel.font=[regular getFont:9.0f];
        if(i==2)
        {
            titlelabel.text=title_str;

        }else
        {
            [titlelabel setAttributedText:[regular createAttributeString:title_str andFloat:@(2.0)]];

        }

        titlelabel.textColor=[UIColor colorWithRed:150.0f/255.0f green:150.0f/255.0f blue:150.0f/255.0f alpha:1];
    }
    UIView *qufen=[[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_tabbar.frame), 2*_Scale)];
    qufen.backgroundColor=[UIColor colorWithRed:250.0f/255.0f green:250.0f/255.0f blue:250.0f/255.0f alpha:1];
    [_tabbar addSubview:qufen];



}
-(void)create_extra_activityViewWithView:(UIView *)subview
{
    if(detail_model.sports_images.count!=0)
    {

//140 40
        NSArray *activityArray=detail_model.sports_images;

        NSInteger Remainder=activityArray.count%3;
        NSInteger row=Remainder?(activityArray.count/3)+1:(activityArray.count/3);

        _view_activity=[[ToolManager sharedManager] createView:CGRectMake(0, CGRectGetMaxY(subview.frame)+_margin, CGRectGetWidth(_scrollView.frame),110*_Scale+140*_Scale*row) WithColor:[UIColor whiteColor]];
        [_scrollView addSubview:_view_activity];

        //    标题“ap课程”
        UIImageView *_imageview=[[ToolManager sharedManager] createTitleView:@" 课 外 活 动 " WithRect:CGRectMake(36*_Scale, 0, CGRectGetWidth(_scrollView.frame)-72*_Scale, 60*_Scale) WithImg:@""  WithtitleColor:_define_blue_color WithTextAlignment:1];
        _imageview.backgroundColor=_define_cailiao_color;
        [_view_activity addSubview:_imageview];

        CGFloat _width=CGRectGetWidth(_view_activity.frame)/3.0f;
        CGFloat _y_p=100*_Scale;
        CGFloat _height=140*_Scale;

        for (int i=0; i<activityArray.count; i++) {

            UIView * view=[[UIView alloc] initWithFrame:CGRectMake(((i)%3)*_width, _y_p, _width, _height)];
            [_view_activity addSubview:view];

            DBImageView *dbimage=[[DBImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(view.frame)-76*_Scale)/2.0f, 0, 76*_Scale, 76*_Scale)];
            dbimage.backgroundColor=[UIColor clearColor];

            [view addSubview:dbimage];

            if(([(NSDictionary *)activityArray[i] objectForKey:@"url"]!=[NSNull null])&&(![[(NSDictionary *)activityArray[i] objectForKey:@"url"]isEqualToString:@""] ))
            {
                dbimage.placeHolder=[UIImage imageNamed:@"school_activities_img"];
                [dbimage setImageWithPath:[(NSDictionary *)activityArray[i] objectForKey:@"url"]];

            }else
            {
                dbimage.image=[UIImage imageNamed:@"school_activities_img"];
            }

            UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(dbimage.frame),CGRectGetWidth(view.frame), 50*_Scale)];
//            label.backgroundColor=[UIColor redColor];
            [view addSubview:label];
            label.font=[regular getFont:12.0f];
            label.textAlignment=1;
            label.textColor=[UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1];
            if([(NSDictionary *)activityArray[i] objectForKey:@"cn_name"]!=[NSNull null])
            {
                [label setAttributedText:[regular createAttributeString:[(NSDictionary *)activityArray[i] objectForKey:@"cn_name"] andFloat:@(3.0)]];
            }else
            {
                [label setAttributedText:[regular createAttributeString:@"" andFloat:@(2.0)]];
            }




            if((i+1)%3==0&&i!=0)
            {
                if(activityArray.count/3==0)
                {

                }else
                {
                    _y_p+=_height;

                }

            }

        }



    }else
    {
        _view_activity=[[ToolManager sharedManager] createView:CGRectMake(0, CGRectGetMaxY(subview.frame), CGRectGetWidth(_scrollView.frame), 0) WithColor:[UIColor whiteColor]];
    }
    _scrollView.contentSize=CGSizeMake(CGRectGetWidth(_scrollView.frame)-4*_Scale, CGRectGetMaxY(_view_activity.frame)+200*_Scale);

}
-(void)create_extra_organizationViewWithView:(UIView *)subview
{
    if(detail_model.extra_organization_list.count!=0)
    {
        NSArray *array_ap=detail_model.extra_organization_list;
        NSInteger _ap_remainder=array_ap.count%2;
        NSInteger ap_list_lineNum=_ap_remainder==0?array_ap.count/2:(1+array_ap.count/2);
        _view_organization=[[ToolManager sharedManager] createView:CGRectMake(0, CGRectGetMaxY(subview.frame)+_margin, CGRectGetWidth(_scrollView.frame), (50+12)*_Scale+58*_Scale*ap_list_lineNum+12*_Scale+10*_Scale+10*_Scale) WithColor:[UIColor whiteColor]];
        [_scrollView addSubview:_view_organization];

        //    标题“ap课程”
        UIImageView *_imageview=[[ToolManager sharedManager] createTitleView:@" 课 外 组 织 " WithRect:CGRectMake(36*_Scale, 0, CGRectGetWidth(_scrollView.frame)-72*_Scale, 60*_Scale) WithImg:@""  WithtitleColor:_define_blue_color WithTextAlignment:1];
        [_view_organization addSubview:_imageview];
        _imageview.backgroundColor=_define_cailiao_color;


        //    创建课程列表
        NSInteger ___num=0;
        if(array_ap.count%2==1)
        {
            ___num=array_ap.count+1;
        }else
        {
            ___num=array_ap.count;
        }

        for (int i=0; i<___num; i++) {
            NSString *_imagename=(i/2)%2==0?@"school_课外组织横条（白色）":@"school_课外组织横条（白色）";
            CGFloat _width=(CGRectGetWidth(_scrollView.frame)-4*_Scale-40*_Scale)/2;


            UIImageView *titleImage=[[UIImageView alloc] initWithFrame:CGRectMake(18*_Scale+(_width+4*_Scale)*(i%2), CGRectGetHeight(_imageview.frame)+20*_Scale+58*_Scale*(i/2), _width, 48*_Scale)];
            titleImage.image=[UIImage imageNamed:_imagename];
            UILabel *labelImage=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(titleImage.frame), CGRectGetHeight(titleImage.frame))];
            NSString *title=nil;
            if((array_ap.count%2==1)&&(i==array_ap.count))
            {
                title=@"";
            }else
            {
                title=array_ap[i];
            }
            labelImage.text=title;
            labelImage.textAlignment=1;
            labelImage.textColor=[UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1];
            labelImage.font=[regular getFont:12.0f];

            [titleImage addSubview:labelImage];



            [_view_organization addSubview:titleImage];
        }


    }else
    {
        _view_organization=[[ToolManager sharedManager] createView:CGRectMake(0, CGRectGetMaxY(subview.frame), CGRectGetWidth(_scrollView.frame), 0) WithColor:[UIColor whiteColor]];
    }
    

    _scrollView.contentSize=CGSizeMake(CGRectGetWidth(_scrollView.frame)-4*_Scale, CGRectGetMaxY(_view_organization.frame)+200*_Scale);

}
-(void)changeIcon
{
    if(_is_order_school>0)
    {
//        "school_exit"    @"school_申请1"
        //            删除目标学校
//        [addGoalBtn setBackgroundImage:[UIImage imageNamed:@"school_删除"] forState:UIControlStateNormal];
        addGoalBtn.selected=NO;
        addGoalLabel.text=@"加为目标";


    }else if(_is_order_school==0)
    {
        //        添加目标学校
//        [addGoalBtn setBackgroundImage:[UIImage imageNamed:@"school_增加"] forState:UIControlStateNormal];
        addGoalBtn.selected=YES;
        addGoalLabel.text=@"移除目标";

    }

    
}
-(void)createaddBtn
{
    addGoalBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    addGoalBtn.frame=CGRectMake((ScreenWidth-70*_Scale)/2.0f, ScreenHeight-135*_Scale, 70*_Scale, 70*_Scale);
#pragma mark-添加或删除
    if(_is_order_school==0)
    {
        [addGoalBtn setBackgroundImage:[UIImage imageNamed:@"school_增加"] forState:UIControlStateNormal];

    }else if(_is_order_school>0)
    {
        [addGoalBtn setBackgroundImage:[UIImage imageNamed:@"school_删除"] forState:UIControlStateNormal];
    }


    [addGoalBtn addTarget:self action:@selector(goalBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addGoalBtn];
}
-(void)login_action
{
    LoginViewController*login=[[LoginViewController alloc] init];
    login.type=@"other";
    [self presentModalViewController:login animated:YES];
}
-(void)goalBtnAction:(UIButton *)btn
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults] ;

    if([[defaults objectForKey:@"islogin"] integerValue]==0)
    {
//        UIAlertView *alertview=[[ToolManager sharedManager] alertTitle_Simple:@"用户还未登录，请先登录"];
//        alertview.delegate=self;
        [self login_action];

    }else
    {
        if(_is_order_school>0)
        {
            addGoalLabel.text=@"加为目标";
            addGoalBtn.selected=NO;
            //            删除目标学校
            [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"已取消目标" WithImg:@"Prompt_取消目标" Withtype:1]];
            NSUserDefaults *dict=[NSUserDefaults standardUserDefaults];
            //    删除
            NSString *_token=nil;
            if([dict objectForKey:@"token"]==nil)
            {
                _token=@"";
            }else
            {
                _token=[dict objectForKey:@"token"];
            }

            NSDictionary *parameters=@{@"token":_token};

            NSString *url=[[NSString alloc] initWithFormat:@"%@%@%ld",DNS,@"/v1/order_schools/",(long)_is_order_school];

            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            [manager DELETE:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {

                NSString *html = operation.responseString;
                NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
                if([[dict objectForKey:@"code"] integerValue]==1)
                {

                    _is_order_school=0;

#pragma mark-发通知刷新发现美校
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeFound" object:nil];
//                    [[ToolManager sharedManager]alertTitle_Simple:@"成功从目标学校中删除该学校"];

                }else
                {
                     [[ToolManager sharedManager] alertTitle_Simple:[dict objectForKey:@"message"]];
                }

                [[ToolManager sharedManager] removeProgress];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
                [[ToolManager sharedManager] removeProgress];
            }];


        }else if(_is_order_school==0)
        {
            addGoalLabel.text=@"移除目标";

            addGoalBtn.selected=YES;
            [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"成功添加目标" WithImg:@"Prompt_成功添加目标" Withtype:1]];

            //        添加目标学校
            NSString *str=[NSString stringWithFormat:@"%@/v1/order_schools",DNS];
            NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            //    创建可变request
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5];
            //    设定请求类型未post
            [request setHTTPMethod:@"POST"];
            //    创建包体

            NSString *_token=nil;
            NSUserDefaults *dict=[NSUserDefaults standardUserDefaults];
            if([[dict objectForKey:@"islogin"] integerValue]==0)
            {
                _token=@"";
            }else
            {
                _token=[dict objectForKey:@"token"];
            }
            NSString *bodyStr=[[NSString alloc] initWithFormat:@"school_id=%@&token=%@",_sid,_token];
            //    加入包体
            request.HTTPBody=[bodyStr dataUsingEncoding:NSUTF8StringEncoding];

            AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];

            //    进行网络请求（AF框架）
            [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {

                NSString *html = operation.responseString;
                NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
                if([[dict objectForKey:@"code"] intValue]==1)
                {
#pragma mark-讲返回的值给他
                    _is_order_school=[[[dict objectForKey:@"data"] objectForKey:@"id"] integerValue];
#pragma mark-发通知刷新发现美校
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeFound" object:nil];

//                    [[ToolManager sharedManager]alertTitle_Simple:@"成功添加至目标学校列表"];

                }else
                {
                     [[ToolManager sharedManager] alertTitle_Simple:[dict objectForKey:@"message"]];

                }
                
                
                
            }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
                //        下载失败时，打印错误信息
//                NSLog(@"发生错误！%@",error);
                [regular removeProgress];
            }];
            
            NSOperationQueue *queue = [[NSOperationQueue alloc] init];
            [queue addOperation:operation];
            
            
        }

    }


}
-(void)createWenliViewWithView:(UIView *)subview
{
    NSArray *array=[dict_Data objectForKey:@"wenli"];
    if(array.count>0)
    {

        CGFloat _height=60*_Scale+40*_Scale+45*_Scale*array.count+10*_Scale+10*_Scale;
        _view_wenli=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(subview.frame)+_margin, CGRectGetWidth(_scrollView.frame), _height)];
        _view_wenli.backgroundColor=[UIColor whiteColor];
        UIImageView *_imageview=[[ToolManager sharedManager] createTitleView:@"文理学院" WithRect:CGRectMake(36*_Scale, 0, CGRectGetWidth(_scrollView.frame)-72*_Scale, 60*_Scale) WithImg:@""  WithtitleColor:_define_blue_color WithTextAlignment:1  Withjiange:10.0f];
        _imageview.backgroundColor=_define_cailiao_color;
        [_view_wenli addSubview:_imageview];
        [_scrollView addSubview:_view_wenli];



        NSArray *_titleArr=@[@"排名",@"名称",@"城市",@"州"];
         UIImageView *_typeView=[regular createImgView:@"" WithRect:CGRectMake(6*_Scale, CGRectGetMaxY(_imageview.frame),CGRectGetWidth(_imageview.frame), 40*_Scale)];
        _typeView.backgroundColor=[UIColor whiteColor];

        [_view_wenli addSubview:_typeView];
        CGFloat max_x=0.0f;
        CGFloat _width=0.0f;
        for ( int i=0; i<_titleArr.count; i++) {
            _width=i==0?80*_Scale:i==1?(315*_Scale-2*_margin):i==2?140*_Scale:90*_Scale;
            NSInteger _TextAlignment=0;
            if(i==1||i==2)
            {
                _TextAlignment=0;
            }else
            {
                _TextAlignment=1;
            }

            UILabel *label=[regular createLabelView:_titleArr[i] Withrect:CGRectMake(max_x, 0, _width, CGRectGetHeight(_typeView.frame)) WithTextColor:yellow_color WithTextAlignment:_TextAlignment WithFont:12.0f];
//            label.font=[regular get_en_Font:12.0f];
            if(i==1)
            {

                label.font=[regular getFont:12.0f];
            }else
            {
                label.font=[regular get_en_Font:12.0f];
                
            }

            max_x=CGRectGetMaxX(label.frame);
            [_typeView addSubview:label];
        }

        CGFloat _y_p=CGRectGetMaxY(_typeView.frame);

        for (int i=0; i<array.count; i++) {
             UIImageView *cell=[[UIImageView alloc] initWithFrame:CGRectMake(6*_Scale, _y_p+i*45*_Scale,CGRectGetWidth(_imageview.frame), 45*_Scale)];
            //            NSString *_imagename=i%2==0?@"school_课外组织横条（白色）":@"school_课外组织横条（白色）";
            //            cell.image=[UIImage imageNamed:_imagename];
            cell.backgroundColor=[UIColor whiteColor];
            [_view_wenli addSubview:cell];

            //        labelArray=[[NSMutableArray alloc] init];
            CGFloat max_x=0.0f;
            CGFloat _width=0.0f;
            for ( int j=0; j<4; j++) {
                //        _width=i==0?130*_Scale:i==1?280*_Scale:i==2?140*_Scale:90*_Scale;
                _width=j==0?80*_Scale:j==1?(295*_Scale-2*_margin):j==2?140*_Scale:90*_Scale;
                NSInteger _TextAlignment=0;
                if(j==1||j==2)
                {
                    _TextAlignment=0;
                }else
                {
                    _TextAlignment=1;
                }


                UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(max_x, 0, _width, CGRectGetHeight(cell.frame))];
                label.textAlignment=_TextAlignment;
                CGFloat _font=j==0?12.0f:j==1?11.0f:10.5f;

                if(j==1)
                {
                    label.font=[regular getFont:_font];
                }else
                {
                    label.font=[regular get_en_Font:_font];
                }
                graduationModel *model=array[i];
                NSString *title=j==0?model.rank:j==1?model.cn_name:j==2?model.en_city:model.short_name;

                label.text=title;

                if(j==0)
                {
                    label.textColor=yellow_color;

                }else
                {
                    label.textColor=[UIColor colorWithRed:140.0f/255.0f green:140.0f/255.0f blue:140.0f/255.0f alpha:1];

                }

                max_x=CGRectGetMaxX(label.frame);
                if(j==1)
                {
                    max_x+=20*_Scale;
                }
                [cell addSubview:label];

            }
        }
    }else
    {
        _view_wenli=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(subview.frame), CGRectGetWidth(_scrollView.frame), 0)];
    }
    [_scrollView addSubview:_view_wenli];
    NSLog(@"%f",CGRectGetMinY(_view_wenli.frame));
    NSLog(@"111");

    
}
-(void)createZongheViewWithView:(UIView *)subview
{
    NSArray *array=[dict_Data objectForKey:@"zonghe"];
    if(array.count>0)
    {
        CGFloat _height=60*_Scale+40*_Scale+45*_Scale*array.count+10*_Scale+10*_Scale;


        _view_zonghe=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(subview.frame), CGRectGetWidth(_scrollView.frame), _height)];
        _view_zonghe.backgroundColor=[UIColor whiteColor];
        UIImageView *_imageview=[[ToolManager sharedManager] createTitleView:@"综合大学" WithRect:CGRectMake(36*_Scale, 0, CGRectGetWidth(_scrollView.frame)-72*_Scale, 60*_Scale) WithImg:@""  WithtitleColor:_define_blue_color WithTextAlignment:1  Withjiange:10.0f];
        _imageview.backgroundColor=_define_cailiao_color;
        [_view_zonghe addSubview:_imageview];
        [_scrollView addSubview:_view_zonghe];


        NSArray *_titleArr=@[@"排名",@"名称",@"城市",@"州"];
         UIImageView *_typeView=[regular createImgView:@"" WithRect:CGRectMake(6*_Scale, CGRectGetMaxY(_imageview.frame),CGRectGetWidth(_imageview.frame), 40*_Scale)];
        _typeView.backgroundColor=[UIColor whiteColor];

        [_view_zonghe addSubview:_typeView];
        CGFloat max_x=0.0f;
        CGFloat _width=0.0f;
        for ( int i=0; i<_titleArr.count; i++) {
            _width=i==0?80*_Scale:i==1?(315*_Scale-2*_margin):i==2?140*_Scale:90*_Scale;
            NSInteger _TextAlignment=0;
            if(i==1||i==2)
            {
                _TextAlignment=0;
            }else
            {
                _TextAlignment=1;
            }

            UILabel *label=[regular createLabelView:_titleArr[i] Withrect:CGRectMake(max_x, 0, _width, CGRectGetHeight(_typeView.frame)) WithTextColor:yellow_color WithTextAlignment:_TextAlignment WithFont:12.0f];
            if(i==1)
            {

                label.font=[regular getFont:12.0f];
            }else
            {
                label.font=[regular get_en_Font:12.0f];

            }

            //            if(i==0)
            //            {
            //                label.backgroundColor=[UIColor redColor];
            //            }

            max_x=CGRectGetMaxX(label.frame);
            [_typeView addSubview:label];
        }

        CGFloat _y_p=CGRectGetMaxY(_typeView.frame);

        for (int i=0; i<array.count; i++) {
             UIImageView *cell=[[UIImageView alloc] initWithFrame:CGRectMake(6*_Scale, _y_p+i*45*_Scale,CGRectGetWidth(_imageview.frame), 45*_Scale)];

            cell.backgroundColor=[UIColor whiteColor];
            [_view_zonghe addSubview:cell];


            CGFloat max_x=0.0f;
            CGFloat _width=0.0f;
            for ( int j=0; j<4; j++) {

                _width=j==0?80*_Scale:j==1?(295*_Scale-2*_margin):j==2?140*_Scale:90*_Scale;
                NSInteger _TextAlignment=0;
                if(j==1||j==2)
                {
                    _TextAlignment=0;
                }else
                {
                    _TextAlignment=1;
                }

                UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(max_x, 0, _width, CGRectGetHeight(cell.frame))];
                label.textAlignment=_TextAlignment;
                CGFloat _font=j==0?12.0f:j==1?11.0f:10.5f;

                if(j==1)
                {
                    label.font=[regular getFont:_font];
                }else
                {
                    label.font=[regular get_en_Font:_font];
                }
                graduationModel *model=array[i];
                NSString *title=j==0?model.rank:j==1?model.cn_name:j==2?model.en_city:model.short_name;

                label.text=title;
                if(j==0)
                {
                    label.textColor=yellow_color;
                }else
                {
                    label.textColor=[UIColor colorWithRed:140.0f/255.0f green:140.0f/255.0f blue:140.0f/255.0f alpha:1];
                }

                max_x=CGRectGetMaxX(label.frame);
                if(j==1)
                {
                    max_x+=20*_Scale;
                }
                [cell addSubview:label];
                
            }
        }
        
        
    }else
    {
        
        _view_zonghe=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(subview.frame), CGRectGetWidth(_scrollView.frame), 0)];
        
    }
    
    [_scrollView addSubview:_view_zonghe];
    _scrollView.contentSize=CGSizeMake(CGRectGetWidth(_scrollView.frame)-4*_Scale, CGRectGetMaxY(_view_zonghe.frame)+200*_Scale);
    
}


-(void)createCertificationViewWithView:(UIView *)subview
{

    xunzhangArr=detail_model.edu_certifications_json;

    [_scrollView addSubview:_view_Certification];

    NSLog(@"%@",xunzhangArr);
    if(xunzhangArr.count>0)
    {
        _view_Certification=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(subview.frame)+_margin, CGRectGetWidth(_scrollView.frame), 190*_Scale)];
        _view_Certification.backgroundColor=[UIColor whiteColor];
        //        未有认证和成员信息

        UIImageView *_imageview=[[ToolManager sharedManager] createTitleView:@"认 证 和 会 员" WithRect:CGRectMake(36*_Scale, 0, CGRectGetWidth(_scrollView.frame)-72*_Scale, 60*_Scale) WithImg:@"" WithtitleColor:_define_blue_color WithTextAlignment:1];
        _imageview.backgroundColor=_define_cailiao_color;
        [_view_Certification addSubview:_imageview];


        CGFloat imgWidth=(CGRectGetWidth(_scrollView.frame)-(86*2)*_Scale-(60*2)*_Scale)/3.0f;

        UIScrollView *_xunzhang_view=[[UIScrollView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(_imageview.frame) , CGRectGetWidth(_view_Certification.frame), CGRectGetHeight(_view_Certification.frame)-CGRectGetMaxY(_imageview.frame))];
        _xunzhang_view.scrollsToTop=NO;

        [_view_Certification addSubview:_xunzhang_view];
        CGFloat _width_xz=0;
        if(xunzhangArr.count>3)
        {
            _width_xz=50*_Scale+(imgWidth+56*_Scale)*xunzhangArr.count;
        }else
        {
            _width_xz=CGRectGetWidth(_xunzhang_view.frame);
        }

        _xunzhang_view.contentSize=CGSizeMake(_width_xz, CGRectGetHeight(_xunzhang_view.frame));

        CGFloat _x_p=0;
        NSInteger _count=xunzhangArr.count;
        if(_count<3)
        {
            if(_count==1)
            {
                _x_p=(CGRectGetWidth(_xunzhang_view.frame)-imgWidth)/2.0f;
            }else if(_count==2)
            {

                _x_p=(CGRectGetWidth(_xunzhang_view.frame)/2.0f)-53*_Scale-imgWidth;
            }
        }else if(_count==3)
        {
            _x_p=70*_Scale;
        }else
        {
            _x_p=50*_Scale;
        }
        for (int i=0; i<xunzhangArr.count; i++) {

            CGFloat _jiange=_count>3?56*_Scale:86*_Scale;

            CGRect _rect=CGRectMake(_x_p+(_jiange+imgWidth)*i,20*_Scale, imgWidth, imgWidth*38/48);

            UIImageView *__imageview=[[ToolManager sharedManager] createImgView:@"school_勋章" WithRect:_rect];
            __imageview.tag=800+i;
            UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showDetail:)];
            __imageview.userInteractionEnabled=YES;
            [__imageview addGestureRecognizer:tap];
            UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(10*_Scale, -3*_Scale+CGRectGetHeight(__imageview.frame)*2.0f/5.0f, CGRectGetWidth(__imageview.frame)-20*_Scale,  CGRectGetHeight(__imageview.frame)/3.0f)];
            //        label.backgroundColor=[UIColor blueColor];

            NSString *title=nil;
            if([(NSDictionary *)xunzhangArr[i] objectForKey:@"short_name"]==[NSNull null])
            {
                title=@"";
            }else
            {
                title=[(NSDictionary *)xunzhangArr[i] objectForKey:@"short_name"];
            }
            label.text=title;
            label.textColor=[UIColor whiteColor];
            label.textAlignment=1;
            label.font=[regular get_en_Font:11.0f];
            [__imageview addSubview:label];
            [_xunzhang_view addSubview:__imageview];

        }

    }else if(xunzhangArr.count==0)
    {
        _view_Certification=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(subview.frame), CGRectGetWidth(_scrollView.frame), 0)];
        _view_Certification.backgroundColor=[UIColor whiteColor];
    }
    [_scrollView addSubview:_view_Certification];
    _scrollView.contentSize=CGSizeMake(CGRectGetWidth(_scrollView.frame)-4*_Scale, CGRectGetMaxY(_view_Certification.frame)+200*_Scale);

}



-(void)createGradeView
{

    if(![detail_model.grade isEqualToString:@""])
    {
        _view_Grade=[[ToolManager sharedManager] createView:CGRectMake(0, CGRectGetMaxY(_view_Map.frame)+_margin, CGRectGetWidth(_scrollView.frame), 200*_Scale) WithColor:[UIColor whiteColor]];
//        w 80 h 36 w 180 h 60
        NSArray *__titlearr=@[@"Grades",detail_model.grade];
        CGFloat _x_p=(CGRectGetWidth(_view_school_data.frame)-500*_Scale)/2.0f;
        for (int i=0; i<__titlearr.count; i++) {
            UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(_x_p+250*_Scale*i, (CGRectGetHeight(_view_Grade.frame)-98*_Scale)/2.0f, 250*_Scale, 98*_Scale)];
            [_view_Grade addSubview:label];
            label.textAlignment=1;
            label.font=[regular get_en_Font:17.0f];
            [label setAttributedText:[regular createAttributeString:__titlearr[i] andFloat:@(3.0)]];
            label.textColor=[UIColor whiteColor];
            label.backgroundColor=i==0?[UIColor colorWithRed:146.0f/255.0f green:219.0f/255.0f blue:211.0f/255.0f alpha:1]:[UIColor colorWithRed:107.0f/255.0f green:203.0f/255.0f blue:202.0f/255.0f alpha:1];

        }

    }else
    {
         _view_Grade=[[ToolManager sharedManager] createView:CGRectMake(0, CGRectGetMaxY(_view_Map.frame), CGRectGetWidth(_scrollView.frame), 0) WithColor:[UIColor whiteColor]];

    }
    [_scrollView addSubview:_view_Grade];

    _scrollView.contentSize=CGSizeMake(CGRectGetWidth(_scrollView.frame)-4*_Scale, CGRectGetMaxY(_view_Grade.frame)+200*_Scale);


}
//[labelImage setAttributedText:[regular createAttributeString:@"接受考试&送分代码" andFloat:@(3.0f)]];_view_Certification
-(void)createSSATViewWithView:(UIView *)subview
{
    NSArray *titlearr=detail_model.school_preferreds;
    BOOL b=NO;
    if(titlearr.count>0)
    {
        b=YES;
    }
    if(b)
    {

        _view_SSAT=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(subview.frame)+_margin, CGRectGetWidth(_scrollView.frame), 250*_Scale)];
        UIScrollView *ssat_scrollview=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 50*_Scale, CGRectGetWidth(_view_SSAT.frame), CGRectGetHeight(_view_SSAT.frame)-50*_Scale)];
        ssat_scrollview.scrollsToTop=NO;
        [_view_SSAT addSubview:ssat_scrollview];
        ssat_scrollview.contentSize=CGSizeMake(titlearr.count*(CGRectGetWidth(ssat_scrollview.frame)/3.0f),CGRectGetHeight(ssat_scrollview.frame));

        _view_SSAT.backgroundColor=[UIColor whiteColor];
        [_scrollView addSubview:_view_SSAT];
        UIImageView *titleImage=[[ToolManager sharedManager]createTitleView:@"接受考试&送分代码" WithRect:CGRectMake(36*_Scale, 0, CGRectGetWidth(_scrollView.frame)-72*_Scale-2*_margin, 60*_Scale) WithImg:@"" WithtitleColor:_define_blue_color WithTextAlignment:1 Withjiange:3.0f];
        titleImage.backgroundColor=_define_cailiao_color;

        [_view_SSAT addSubview:titleImage];

        // w 18 h 39 w168 h 58 i 8 2
        CGFloat _x_p=(CGRectGetWidth(_view_SSAT.frame)-168*_Scale*3-8*_Scale*2)/2.0f;
        CGFloat _x_p1=(CGRectGetWidth(_view_SSAT.frame)-168*_Scale*2-10*_Scale)/2.0f;
        for (int i=0; i<titlearr.count; i++) {
            NSDictionary *ssat_dict=titlearr[i];
            CGRect _rect;
            if(titlearr.count==2)
            {
                _rect=CGRectMake(_x_p1, 20*_Scale, 168*_Scale, 58*_Scale);

            }
            else if(titlearr.count>2)
            {
                _rect=CGRectMake(_x_p, 20*_Scale, 168*_Scale, 58*_Scale);
            }else if(titlearr.count==1)
            {
                _rect=CGRectMake((CGRectGetWidth(_view_SSAT.frame)-168*_Scale)/2.0f, 20*_Scale, 168*_Scale, 58*_Scale);
            }
            UIImageView *upimageview=[[UIImageView alloc] initWithFrame:_rect];
            if(titlearr.count==2&&i==0)
            {

                _x_p1+=((168+10)*_Scale);

            }else
            {
                _x_p+=(168+8)*_Scale;

            }
            upimageview.image=[UIImage imageNamed:@"school_送分"];
            UILabel *uplabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(upimageview.frame), CGRectGetHeight(upimageview.frame))];
            [uplabel setAttributedText:[regular createAttributeString:[ssat_dict objectForKey:@"preferred_name"] andFloat:@(1.0)]];
            uplabel.font=[regular get_en_Font:14.0f];
            uplabel.textAlignment=1;
            uplabel.textColor=[UIColor whiteColor];
            //        uplabel.text=arr[0];

            [upimageview addSubview:uplabel];
            [ssat_scrollview addSubview:upimageview];
            UIImageView *downimageview=[[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(upimageview.frame), CGRectGetMaxY(upimageview.frame), CGRectGetWidth(upimageview.frame), 78*_Scale)];
            for (int i=0; i<2; i++) {
                UILabel *downlabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 5*_Scale+(-5*_Scale+CGRectGetHeight(downimageview.frame)/2.0f)*i, CGRectGetWidth(downimageview.frame), CGRectGetHeight(downimageview.frame)/2.0f)];
                [downimageview addSubview:downlabel];
                downlabel.textAlignment=1;
                downlabel.textColor=[UIColor whiteColor];

                if(i==0)
                {
                    [uplabel setAttributedText:[regular createAttributeString:[ssat_dict objectForKey:@"preferred_name"] andFloat:@(1.0)]];


                    if([[ssat_dict objectForKey:@"school_code"] isEqualToString:@""])
                    {
                        downlabel.text=@"官网未提供";
                        downlabel.font=[regular getFont:12.0f];
                    }else
                    {
                        downlabel.text=[ssat_dict objectForKey:@"school_code"];
                        downlabel.font=[regular get_en_Font:14.0f];
                    }
                }else
                {

                    downlabel.text=@"code";
                    downlabel.font=[regular get_en_Font:9.0f];

                }


            }


            downimageview.image=[UIImage imageNamed:@"school_送分代码（1）"];
            [ssat_scrollview addSubview:downimageview];
            
        }
        
        
    }else
    {
        _view_SSAT=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(subview.frame), CGRectGetWidth(_scrollView.frame), 0)];
    }
    [_scrollView addSubview:_view_SSAT];
}
-(void)createTuitionViewWithView:(UIView *)subview
{

    NSMutableArray *skusArr=[[NSMutableArray alloc] init];
    //    int codads=0;
    NSArray *___arr=detail_model.school_skus;
    for (NSDictionary *__dict in ___arr)
    {


        if([[__dict objectForKey:@"inter_or_native"]isEqualToString:@"international"])
        {


            if(([__dict objectForKey:@"price"]!=[NSNull null])&&(([[__dict objectForKey:@"price"] integerValue])>0))
            {
                [skusArr addObject:__dict];
            }

        }
        //        codads++;
        //        if(codads==1)
        //        {
        //            break;
        //        }
    }


    
    if(skusArr.count==0)
    {
        _view_Tuition=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(subview.frame), CGRectGetWidth(_scrollView.frame), 0)];
        [_scrollView addSubview:_view_Tuition];
    }else
    {
        _view_Tuition=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(subview.frame)+_margin, CGRectGetWidth(_scrollView.frame), 260*_Scale-17*_Scale)];

        _view_Tuition.backgroundColor=[UIColor whiteColor];
        [_scrollView addSubview:_view_Tuition];



        UIImageView *_imageview=[[ToolManager sharedManager]createTitleView:@"学 费" WithRect:CGRectMake(36*_Scale, 0, CGRectGetWidth(_scrollView.frame)-72*_Scale, 60*_Scale) WithImg:@"" WithtitleColor:_define_blue_color WithTextAlignment:1 WithFontName:(kIOSVersions>=9.0? @"":@"Helvetica Neue") WithFont:12.5f];
        _imageview.backgroundColor=_define_cailiao_color;
        [_view_Tuition addSubview:_imageview];


        NSLog(@"%@",skusArr);
        NSLog(@"111");
        CGFloat _width=102*_Scale;
        CGFloat _interval=(ScreenWidth-_margin*2-_width*4)/5.0f;
        CGFloat _x_p=0;
        if(skusArr.count==3)
        {
            _interval=(ScreenWidth-_margin*2-_width*3)/4.0f;

        }
        for (int i=0; i<skusArr.count; i++) {
            NSDictionary *___dict=skusArr[i];
            if(skusArr.count==3)
            {
                _x_p=_interval+(_width+_interval)*i;
            }else if(skusArr.count==1)
            {
                _x_p=(ScreenWidth-_margin*2-_width)/2.0f;
            }else if(skusArr.count==2)
            {
                _x_p=_interval+(_width+_interval)*(i+1);
            }else
            {
                _x_p=_interval+(_width+_interval)*i;
            }


            CGRect _rect=CGRectMake(_x_p, CGRectGetMaxY(_imageview.frame)+10*_Scale, 102*_Scale,  102*_Scale);

            UIImageView *__imageview=[[ToolManager sharedManager] createImgView:@"school_费用图标" WithRect:_rect];

            [_view_Tuition addSubview:__imageview];

            NSString *price=nil;
            if([___dict objectForKey:@"price"]==[NSNull null])
            {
                price=@"0";
            }else
            {
                price=[[NSString alloc] initWithFormat:@"%ld",(long)[[___dict objectForKey:@"price"] integerValue]];
            }

            UILabel *_content_Label=[[ToolManager sharedManager] createLabelView:price Withrect:CGRectMake(0, 9*_Scale, 100*_Scale, 100*_Scale) WithTextColor:[UIColor colorWithRed:136.0f/255.0f green:136.0f/255.0f blue:136.0f/255.0f alpha:1] WithTextAlignment:1 WithFont:11.5f];

            [__imageview addSubview:_content_Label];


            NSString *_title_str=nil;
            if([[___dict objectForKey:@"school_level"] isEqualToString:@"junior"]){
                if([[___dict objectForKey:@"boarding_day"]isEqualToString:@"boarding"])
                {
                    _title_str=@"寄宿初中";
                }else
                {
                    _title_str=@"走读初中";
                }
            }else
            {
                if([[___dict objectForKey:@"boarding_day"]isEqualToString:@"boarding"])
                {
                    _title_str=@"寄宿高中";
                }else
                {
                    _title_str=@"走读高中";
                }

            }


            UILabel *_title_Label=[[ToolManager sharedManager] createLabelView:_title_str Withrect:CGRectMake(CGRectGetMinX(__imageview.frame)-20*_Scale, CGRectGetMaxY(__imageview.frame)+4*_Scale, 40*_Scale+CGRectGetWidth(__imageview.frame), CGRectGetHeight(_view_Tuition.frame)-CGRectGetMaxY(__imageview.frame)-10*_Scale) WithTextColor:[UIColor colorWithRed:200.0f/255.0f green:200.0f/255.0f blue:200.0f/255.0f alpha:1] WithTextAlignment:1 WithFont:11.0f];
//            _title_Label.backgroundColor=[UIColor redColor];
            _title_Label.font=[regular get_en_Font:12.0f];
            [_title_Label setAttributedText:[regular createAttributeString:_title_str andFloat:@(1.0f)]];
            
            [_view_Tuition addSubview:_title_Label];
            
            
        }
    }
    _scrollView.contentSize=CGSizeMake(CGRectGetWidth(_scrollView.frame)-4*_Scale, CGRectGetMaxY(_view_Tuition.frame)+200*_Scale);
    
    
}
-(void)createStuGradeNumViewWithView:(UIView *)subview
{
    NSDictionary *_dict_grade=detail_model.grade_number;
    NSArray *keyArr=@[@"grade_6",@"grade_7",@"grade_8",@"grade_9",@"grade_10",@"grade_11",@"grade_12"];
    BOOL _have_student_num=NO;
    for (int i=0; i<keyArr.count; i++) {
        NSString *key=keyArr[i];

        if((![[_dict_grade objectForKey:key] isEqualToString:@""])&&(![[_dict_grade objectForKey:key] isEqualToString:@"0"])&&([_dict_grade objectForKey:key]!=nil))
        {
            _have_student_num=YES;
            break;
        }

    }

    if(_have_student_num)
    {
        _view_StuGrade=[[ToolManager sharedManager] createView:CGRectMake(0, CGRectGetMaxY(subview.frame)+_margin, CGRectGetWidth(_scrollView.frame), 490*_Scale) WithColor:[UIColor whiteColor]];
        [_scrollView addSubview:_view_StuGrade];

        UIImageView *titleImage=[[ToolManager sharedManager] createTitleView:[[NSString alloc] initWithFormat:@"各 年 级 人 数"] WithRect:CGRectMake(36*_Scale, 0,CGRectGetWidth(_scrollView.frame)-72*_Scale, 60*_Scale) WithImg:@""  WithtitleColor:_define_blue_color WithTextAlignment:1];
        titleImage.backgroundColor=_define_cailiao_color;
        [_view_StuGrade addSubview:titleImage];
        NSInteger max_num=0;
        NSMutableDictionary *height_arr=[[NSMutableDictionary alloc] init];
        for (int j=0; j<keyArr.count; j++) {
            NSString *key=[keyArr objectAtIndex:j];
            if([_dict_grade objectForKey:key]!=[NSNull null])
            {
                if([_dict_grade objectForKey:key]==nil)
                {
                    [height_arr setObject:[NSNumber numberWithInteger:0] forKey:key];
                }else
                {
                    NSString *value=[_dict_grade objectForKey:key];
                    NSNumber *_number=[NSNumber numberWithLong:[value integerValue]];
                    [height_arr setObject:_number forKey:key];
                    NSInteger _num=[[_dict_grade objectForKey:key] integerValue];
                    if(_num>max_num)
                    {
                        max_num=_num;
                    }
                }
            }else
            {
                [height_arr setObject:[NSNumber numberWithInteger:0] forKey:key];
            }
        }

        NSLog(@"%ld",(long)max_num);
        NSLog(@"%@",height_arr);
        CGFloat _width=44*_Scale;
        CGFloat _bianju=60*_Scale;
        CGFloat _jiange=(CGRectGetWidth(_view_StuGrade.frame)-_bianju*2-_width*7)/6.0f;
        CGFloat _x_p=_bianju;
        for (int i=0; i<keyArr.count; i++) {
             NSString *key=[keyArr objectAtIndex:i];
            NSInteger _num=[[height_arr objectForKey:key] integerValue];
//            48 _width
            UIImageView *imageview=[[UIImageView alloc] init];
            imageview.frame=CGRectMake(_x_p, CGRectGetHeight(_view_StuGrade.frame)-48*_Scale-_width, _width, _width);
            imageview.layer.masksToBounds=YES;
            imageview.layer.cornerRadius=CGRectGetWidth(imageview.frame)/2.0f;

            [_view_StuGrade addSubview:imageview];

            UIColor *color=nil;
            if(_num)
            {
                if(i>2)
                {
                    color=[UIColor colorWithRed:125.0f/255.0f green:121.0f/255.0f blue:188.0f/255.0f alpha:1];
                }else
                {
                    color=[UIColor colorWithRed:159.0f/255.0f green:211.0f/255.0f blue:91.0f/255.0f alpha:1];
                }
            }else
            {

                color=[UIColor colorWithRed:240.0f/255.0f green:240.0f/255.0f blue:240.0f/255.0f alpha:1];
            }
            imageview.backgroundColor=color;
             UILabel *gradenum=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(imageview.frame), CGRectGetHeight(imageview.frame))];
            gradenum.textAlignment=1;
            gradenum.font=[regular get_en_Font:15.0f];
            gradenum.textColor=[UIColor whiteColor];
            gradenum.text=[[NSString alloc] initWithFormat:@"%d",i+6];
            [imageview addSubview:gradenum];


            if(_num)
            {
                CGFloat _view_height=200*_Scale*(((CGFloat)_num)/((CGFloat)max_num));
                UIView *zhuview=[[UIView alloc] initWithFrame:CGRectMake(_x_p, CGRectGetMinY(imageview.frame)-20*_Scale-_view_height, _width, _view_height)];
                zhuview.backgroundColor=color;
                [_view_StuGrade addSubview:zhuview];
                UILabel *_num_label=[[UILabel alloc] initWithFrame:CGRectMake(_x_p-_jiange/2.0f, CGRectGetMinY(zhuview.frame)-80*_Scale, _width+_jiange, 80*_Scale)];
                [_view_StuGrade addSubview:_num_label];
                _num_label.textAlignment=1;
                _num_label.font=[regular get_en_Font:17.0f];
                _num_label.textColor=[UIColor colorWithRed:155.0f/255.0f green:155.0f/255.0f blue:155.0f/255.0f alpha:1];
                [_num_label setAttributedText:[regular createAttributeString:[[NSString alloc] initWithFormat:@"%ld",(long)_num] andFloat:@(2.0)]];
            }


            _x_p+=_width+_jiange;
        }

    }else
    {
        _view_StuGrade=[[ToolManager sharedManager] createView:CGRectMake(0, CGRectGetMaxY(subview.frame), CGRectGetWidth(_scrollView.frame), 0) WithColor:[UIColor whiteColor]];
    }
    _scrollView.contentSize=CGSizeMake(CGRectGetWidth(_scrollView.frame)-4*_Scale, CGRectGetMaxY(_view_StuGrade.frame)+200*_Scale);
}

//-(void)createStuGradeNumViewWithView:(UIView *)subview
//{
//
//
//    NSDictionary *_dict_grade=detail_model.grade_number;
//    NSArray *keyArr=@[@"grade_7",@"grade_8",@"grade_9",@"grade_10",@"grade_11",@"grade_12"];
//    NSArray *keyArr1=@[@"grade_7",@"grade_8"];
//    NSArray *keyArr2=@[@"grade_9",@"grade_10",@"grade_11",@"grade_12"];
//    //    是否初中未0 高中有2
//    //    是否高中为0 初中有 1
//    //    是否全有 3
//    NSInteger exits_type=0;
//
//    BOOL _senior=NO;
//    BOOL _isjunior=NO;
//
//    for (int i=0; i<keyArr1.count; i++) {
//
//        NSString *key=keyArr1[i];
//        NSString *grade=[_dict_grade objectForKey:key];
//        if((![grade isEqualToString:@""])&&(![grade isEqualToString:@"0"]))
//        {
//            _isjunior=YES;
//            break;
//        }
//
//    }
//    for (int i=0; i<keyArr2.count; i++) {
//
//        NSString *key=keyArr2[i];
//        NSString *grade=[_dict_grade objectForKey:key];
//        if((![grade isEqualToString:@""])&&(![grade isEqualToString:@"0"]))
//        {
//            _senior=YES;
//            break;
//        }
//    }
//    if(_senior&&_isjunior)
//    {
//        exits_type=3;
//    }
//    if(_senior&&!_isjunior)
//    {
//        exits_type=2;
//    }
//    if(!_senior&&_isjunior)
//    {
//        exits_type=1;
//    }
//    if(!_senior&&!_isjunior)
//    {
//        exits_type=0;
//    }
//
//
//    if(exits_type>0)
//    {
//
//        if(exits_type==3)
//        {
//            _view_StuGrade=[[ToolManager sharedManager] createView:CGRectMake(0, CGRectGetMaxY(subview.frame)+_margin, CGRectGetWidth(_scrollView.frame), 342*_Scale) WithColor:[UIColor whiteColor]];
//        }else
//        {
//            _view_StuGrade=[[ToolManager sharedManager] createView:CGRectMake(0, CGRectGetMaxY(subview.frame)+_margin, CGRectGetWidth(_scrollView.frame), 218*_Scale) WithColor:[UIColor whiteColor]];
//        }
//
//
//        [_scrollView addSubview:_view_StuGrade];
//
//        UIImageView *titleImage=[[ToolManager sharedManager] createTitleView:[[NSString alloc] initWithFormat:@"各 年 级 人 数"] WithRect:CGRectMake(36*_Scale, 0,CGRectGetWidth(_scrollView.frame)-72*_Scale, 60*_Scale) WithImg:@""  WithtitleColor:_define_blue_color WithTextAlignment:1];
//        titleImage.backgroundColor=_define_cailiao_color;
//        [_view_StuGrade addSubview:titleImage];
//
//
//
//        NSMutableArray *contentArray=[[NSMutableArray alloc] init];
//        //    是否初中未0 高中有2
//        //    是否高中为0 初中有 1
//        //    是否全有 3
//
//        NSArray *arr111=nil;
//        if(exits_type==3)
//        {
//            arr111=keyArr;
//        }else if(exits_type==1)
//        {
//            arr111=keyArr1;
//        }else
//        {
//            arr111=keyArr2;
//        }
//        for (NSString *_key in arr111) {
//            NSString *__count=nil;
//            if([_dict_grade objectForKey:_key]==[NSNull null])
//            {
//                __count=@"";
//            }else
//            {
//               __count=[_dict_grade objectForKey:_key];
//
//            }
//            [contentArray addObject:__count];
//        }
//        NSLog(@"111");
//
//        for (int i=0; i<contentArray.count; i++) {
//
//            UIImageView *_imageview=nil;
//            UILabel *labelRight_top=nil;
//            UILabel *labelContent=nil;
//            NSInteger hh=0;
//            NSString *imgname1=nil;
//            NSString *imgname2=nil;
//            if(contentArray.count==6)
//            {
//                hh=1;
//                imgname1=@"school_年级人数1";
//                imgname2=@"school_年级人数2";
//            }else if(contentArray.count==4)
//            {
//                hh=5;
//                imgname1=@"school_年级人数2";
//                imgname2=@"school_年级人数2";
//            }else
//            {
//                hh=5;
//                imgname1=@"school_年级人数1";
//                imgname2=@"school_年级人数1";
//            }
//            if(i>hh)
//            {
//                _imageview=[[UIImageView alloc]initWithImage:[UIImage imageNamed:imgname2]];
//                _imageview.frame=CGRectMake(93*_Scale+(86+34)*(i-2)*_Scale, CGRectGetMaxY(titleImage.frame)+(23+101+23)*_Scale, 86*_Scale, 101*_Scale);
//
//                labelRight_top=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(_imageview.frame)-38*_Scale, -5*_Scale, 38*_Scale, 38*_Scale)];
//                labelRight_top.text=[[NSString alloc] initWithFormat:@"%d",i+7];
//
//
//            }else
//            {
//
//
//                _imageview=[[UIImageView alloc]initWithImage:[UIImage imageNamed:imgname1]];
//
//                if(contentArray.count==4)
//                {
//
//
//                    _imageview.frame=CGRectMake(93*_Scale+(86+34)*(i)*_Scale, CGRectGetMaxY(titleImage.frame)+23*_Scale, 86*_Scale, 101*_Scale);
//                     labelRight_top=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(_imageview.frame)-38*_Scale, -5*_Scale, 38*_Scale, 38*_Scale)];
//                    labelRight_top.text=[[NSString alloc] initWithFormat:@"%d",i+9];
//                    
//                }else if(contentArray.count==6)
//                {
//                    _imageview.frame=CGRectMake(195*_Scale+(28+20+20+86)*i*_Scale, CGRectGetMaxY(titleImage.frame)+23*_Scale, 86*_Scale, 101*_Scale);
//                     labelRight_top=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(_imageview.frame)-38*_Scale, -5*_Scale, 38*_Scale, 38*_Scale)];
//                    labelRight_top.text=[[NSString alloc] initWithFormat:@"%d",i+7];
//
//                }else if(contentArray.count==2)
//                {
//                    _imageview.frame=CGRectMake(195*_Scale+(28+20+20+86)*i*_Scale, CGRectGetMaxY(titleImage.frame)+23*_Scale, 86*_Scale, 101*_Scale);
//                     labelRight_top=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(_imageview.frame)-38*_Scale, -5*_Scale, 38*_Scale, 38*_Scale)];
//                    labelRight_top.text=[[NSString alloc] initWithFormat:@"%d",i+7];
//
//                }
//
//
//
//
//            }
//
//
////            _imageview.backgroundColor=[UIColor redColor];
////            _imageview.alpha=0.1;
//            [_imageview addSubview:labelRight_top];
////            labelRight_top.backgroundColor=[UIColor redColor];
//            labelRight_top.textAlignment=NSTextAlignmentCenter;
//            labelRight_top.textColor=[UIColor whiteColor];
//            labelRight_top.font=[regular get_en_Font:16.0f];
//            [_view_StuGrade addSubview:_imageview];
//
//            labelContent=[[UILabel alloc] initWithFrame:CGRectMake(0, 10*_Scale, CGRectGetWidth(_imageview.frame), CGRectGetHeight(_imageview.frame)-10*_Scale)];
//
//            NSString *content_text=nil;
//            if([contentArray[i] isEqualToString:@"0"])
//            {
//                content_text=@"";
//            }else
//            {
//                content_text=contentArray[i];
//            }
//            labelContent.text=content_text;
//            labelContent.textAlignment=NSTextAlignmentCenter;
//            labelContent.font=[regular get_en_Font:20.0f];
//
//            labelContent.textColor=[UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1];
//            [_imageview addSubview:labelContent];
//
//        }
//
//
//    }else
//    {
//        _view_StuGrade=[[ToolManager sharedManager] createView:CGRectMake(0, CGRectGetMaxY(subview.frame), CGRectGetWidth(_scrollView.frame), 0) WithColor:[UIColor whiteColor]];
//        
//    }
//     _scrollView.contentSize=CGSizeMake(CGRectGetWidth(_scrollView.frame)-4*_Scale, CGRectGetMaxY(_view_StuGrade.frame)+200*_Scale);
//
//    
//}
-(void)createStudentProportionView
{

    BOOL _b=YES;
    if(detail_model.total_students==0&&detail_model.international_students==0)
    {
        _b=NO;
    }


    if((detail_model.total_students==0||detail_model.teachers_count==0)&&(detail_model.international_students==0))
    {
        _b=NO;
    }


    if(_b)
    {
        NSString *guojisheng=nil;
        NSString *guojibi=nil;
        NSString *shishengbi=nil;
        if(detail_model.international_students==0)
        {
            guojisheng=@"／";

        }else
        {
            guojisheng=[[NSString alloc] initWithFormat:@"%ld",(long)detail_model.international_students];
        }

        if(detail_model.total_students==0||detail_model.teachers_count==0)
        {
            guojibi=@"／";
            shishengbi=@"／";
        }else
        {
            if(detail_model.international_students==0)
            {
                guojibi=@"／";
            }else
            {
                guojibi=[[NSString alloc] initWithFormat:@"%.0f%%",100*(((CGFloat)detail_model.international_students)/((CGFloat)detail_model.total_students))];
            }

            if(detail_model.teachers_count==0)
            {
                shishengbi=@"／";
            }else
            {
                shishengbi=[[NSString alloc] initWithFormat:@"1:%.1ld",(detail_model.total_students)/(detail_model.teachers_count)];
            }
        }
        if([guojisheng isEqualToString:@"／"]&&[guojibi isEqualToString:@"／"]&&[shishengbi isEqualToString:@"／"])
        {
            _view_student_Proportion=[[ToolManager sharedManager] createView:CGRectMake(0, CGRectGetMaxY(_view_Grade.frame), CGRectGetWidth(_scrollView.frame), 0) WithColor:[UIColor whiteColor]];

        }else
        {
            if(CGRectGetHeight(_view_Grade.frame))
            {
                _view_student_Proportion=[[ToolManager sharedManager] createView:CGRectMake(0, CGRectGetMaxY(_view_Grade.frame)-36*_Scale, CGRectGetWidth(_scrollView.frame), 194*_Scale) WithColor:[UIColor whiteColor]];

            }else
            {
                _view_student_Proportion=[[ToolManager sharedManager] createView:CGRectMake(0, CGRectGetMaxY(_view_Grade.frame)+_margin, CGRectGetWidth(_scrollView.frame), 194*_Scale) WithColor:[UIColor whiteColor]];
            }

            [_scrollView addSubview:_view_student_Proportion];
            _view_student_Proportion.backgroundColor=[UIColor whiteColor];
            NSArray *titlearr=@[@"国 际 生 数",@"国 际 生 比",@"师 生 比"];
            //84
            CGFloat _x_p=(CGRectGetWidth(_scrollView.frame)-548*_Scale)/2.0f;
            CGFloat _width=(548*_Scale-2*_Scale*2)/3.0f;

            for (int i=0; i<3; i++) {

                //                CGFloat _y_p=0;
                UIColor *color=i==0?_define_blue_color:i==1?[UIColor colorWithRed:107.0f/255.0f green:202.0f/255.0f blue:202.0f/255.0f alpha:1]:[UIColor colorWithRed:160.0f/255.0f green:213.0f/255.0f blue:103.0f/255.0f alpha:1];


                    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(_x_p, 20*_Scale, _width, 64*_Scale)];
                    [_view_student_Proportion addSubview:label];
                    label.textAlignment=1;
                    label.textColor=color;
                    label.font=[regular getFont:13.0f];
                    label.text=titlearr[i];

                UILabel *imageview=[[UILabel alloc] initWithFrame:CGRectMake(_x_p, 84*_Scale, _width, 70*_Scale)];
                [_view_student_Proportion addSubview:imageview];
                imageview.backgroundColor=color;
                imageview.textColor=[UIColor whiteColor];
                imageview.text=i==0?guojisheng:i==1?guojibi:shishengbi;
                imageview.font=[regular get_en_Font:12.0f];
                imageview.textAlignment=1;
                _x_p+=1+_width;
                
            }

            
        }




    }else
    {
        _view_student_Proportion=[[ToolManager sharedManager] createView:CGRectMake(0, CGRectGetMaxY(_view_Grade.frame), CGRectGetWidth(_scrollView.frame), 0) WithColor:[UIColor whiteColor]];
        
        
    }
    _scrollView.contentSize=CGSizeMake(CGRectGetWidth(_scrollView.frame)-4*_Scale, CGRectGetMaxY(_view_student_Proportion.frame)+200*_Scale);


    
}

-(void)createAPLessionViewWithView:(UIView *)subview
{

    if(detail_model.ap_course_list.count!=0)
    {
        NSArray *array_ap=detail_model.ap_course_list;
        NSInteger _ap_remainder=array_ap.count%2;
        NSInteger ap_list_lineNum=_ap_remainder==0?array_ap.count/2:(1+array_ap.count/2);
        _view_AP_Lession=[[ToolManager sharedManager] createView:CGRectMake(0, CGRectGetMaxY(subview.frame)+_margin, CGRectGetWidth(_scrollView.frame), (50+12)*_Scale+58*_Scale*ap_list_lineNum+12*_Scale+10*_Scale+10*_Scale) WithColor:[UIColor whiteColor]];
        [_scrollView addSubview:_view_AP_Lession];

        //    标题“ap课程”
        UIImageView *_imageview=[[ToolManager sharedManager] createTitleView:@" A P 课 程 " WithRect:CGRectMake(36*_Scale, 0, CGRectGetWidth(_scrollView.frame)-72*_Scale, 60*_Scale) WithImg:@""  WithtitleColor:_define_blue_color WithTextAlignment:1];
        _imageview.backgroundColor=_define_cailiao_color;
        [_view_AP_Lession addSubview:_imageview];


        //    创建课程列表
        NSInteger ___num=0;
        if(array_ap.count%2==1)
        {
            ___num=array_ap.count+1;
        }else
        {
            ___num=array_ap.count;
        }

        for (int i=0; i<___num; i++) {
            NSString *_imagename=(i/2)%2==0?@"school_课外组织横条（白色）":@"school_课外组织横条（白色）";
            CGFloat _width=(CGRectGetWidth(_scrollView.frame)-4*_Scale-40*_Scale)/2;


            UIImageView *titleImage=[[UIImageView alloc] initWithFrame:CGRectMake(18*_Scale+(_width+4*_Scale)*(i%2), CGRectGetHeight(_imageview.frame)+20*_Scale+58*_Scale*(i/2), _width, 48*_Scale)];
            titleImage.image=[UIImage imageNamed:_imagename];
            UILabel *labelImage=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(titleImage.frame), CGRectGetHeight(titleImage.frame))];
            NSString *title=nil;
            if((array_ap.count%2==1)&&(i==array_ap.count))
            {
                title=@"";
            }else
            {
                title=array_ap[i];
            }
            labelImage.text=title;
            labelImage.textAlignment=1;
            labelImage.textColor=[UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1];
            labelImage.font=[regular getFont:12.0f];

            [titleImage addSubview:labelImage];



            [_view_AP_Lession addSubview:titleImage];
        }


    }else
    {
        _view_AP_Lession=[[ToolManager sharedManager] createView:CGRectMake(0, CGRectGetMaxY(subview.frame), CGRectGetWidth(_scrollView.frame), 0) WithColor:[UIColor whiteColor]];
    }


    _scrollView.contentSize=CGSizeMake(CGRectGetWidth(_scrollView.frame)-4*_Scale, CGRectGetMaxY(_view_AP_Lession.frame)+200*_Scale);
}
-(void)is_daohang
{


    isdaohang_sheet=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"开启导航？"otherButtonTitles: nil];
    isdaohang_sheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [isdaohang_sheet showInView:self.view];

}

-(void)createMapViewWithView:(UIView *)subview

{
   _view_Map=[[ToolManager sharedManager] createView:CGRectMake(0, CGRectGetMaxY(subview.frame)+_margin, CGRectGetWidth(_scrollView.frame), 550*_Scale) WithColor:[UIColor whiteColor]];
    [_scrollView addSubview:_view_Map];


   _mapView=[regular createView:CGRectMake(0,0, CGRectGetWidth(_view_Map.frame), CGRectGetHeight(_view_Map.frame)) WithColor:[UIColor whiteColor]];

    [_view_Map addSubview:_mapView];
    UIView *view_function=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_view_Map.frame)-80*_Scale, CGRectGetWidth(_view_Map.frame), 80*_Scale)];
    view_function.backgroundColor=self.view.backgroundColor;
    [_view_Map addSubview:view_function];
    CGFloat _width=(CGRectGetWidth(view_function.frame)-1)/2.0f;
    for (int i=0; i<2; i++) {
        NSString *title_str=i==0?@"导航":@"放大";
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(i*(_width+1),0, _width, CGRectGetHeight(view_function.frame));
        [btn setTitle:title_str forState:UIControlStateNormal];
        [btn.titleLabel setAttributedText:[regular createAttributeString:title_str andFloat:@(3.0)]];
        btn.backgroundColor=[UIColor whiteColor];
        [btn setTitleColor:_define_blue_color forState:UIControlStateNormal];
        btn.titleLabel.font=[regular getFont:14.0f];
        [view_function addSubview:btn];
        if(i==0)
        {
            [btn addTarget:self action:@selector(is_daohang) forControlEvents:UIControlEventTouchUpInside];
        }else if(i==1)
        {
            [btn addTarget:self action:@selector(quanping_action:) forControlEvents:UIControlEventTouchUpInside];
        }
    }


     _mkMapView=[[MKMapView alloc] initWithFrame:CGRectMake(0, 120*_Scale, CGRectGetWidth(_mapView.frame), CGRectGetHeight(_mapView.frame)-200*_Scale)];

//    // w 30 h 24 r 60
//    quanping_btn=[UIButton buttonWithType:UIButtonTypeCustom];
//    quanping_btn.frame=CGRectMake(CGRectGetWidth(_mkMapView.frame)-120*_Scale, CGRectGetHeight(_mkMapView.frame)-90*_Scale, 60*_Scale, 60*_Scale);
//    [quanping_btn addTarget:self action:@selector(quanping_action:) forControlEvents:UIControlEventTouchUpInside];
//    [quanping_btn setBackgroundImage:[UIImage imageNamed:@"school_全屏"] forState:UIControlStateNormal];
//    [_mkMapView addSubview:quanping_btn];

    [_mapView addSubview:_mkMapView];
    [_mkMapView setDelegate:self];
    totleStr=[[NSMutableString alloc] init];

    [_mkMapView removeOverlays:_mkMapView.overlays];
    [_mkMapView removeAnnotations:_mkMapView.annotations];

    double _long=0;
    double _lat=0;
    BOOL _isloc=[ToolManager is_right_locationWithLong:[detail_model.longtitude doubleValue] WithLat:[detail_model.latitude doubleValue]];
    if(_isloc)
    {
        _long=[detail_model.longtitude doubleValue];
        _lat=[detail_model.latitude doubleValue];

    }else
    {
        _long=-97;
        _lat=38.5;
    }
    CLLocation*_location=[[CLLocation alloc] initWithLatitude:_lat longitude:_long];
    CLLocationCoordinate2D coord = [_location coordinate];



    MyPoint *myPoint = [[MyPoint alloc] initWithCoordinate:coord andTitle:@""];


//    NSLog(@"111%@",totleStr);
    //添加标注
    [_mkMapView addAnnotation:myPoint];
    MKCoordinateRegion reg;

    if(_isloc)
    {
        //放大到标注的位置
        reg = MKCoordinateRegionMakeWithDistance(coord, 3000, 3000);

    }else
    {
        CLLocationCoordinate2D c;
        c.latitude=38.5;
        c.longitude=-97;
        _long=-97;
        _lat=38.5;
        MKCoordinateSpan span;
        span.latitudeDelta=16;//20
        span.longitudeDelta=54;
        reg=MKCoordinateRegionMake(c, span);
    }
    
    [_mkMapView setRegion:reg animated:YES];

    _map_titleImg=[regular createImgView:@"" WithRect:CGRectMake(0,0, CGRectGetWidth(_view_Map.frame), 120*_Scale)];
    _map_titleImg.backgroundColor=[UIColor whiteColor];
    [_view_Map addSubview:_map_titleImg];


    NSArray *_arr=@[[[NSString alloc]initWithFormat:@"%@，%@",detail_model.city,detail_model.cn_state],detail_model.full_address];

    CGFloat _label_height=(CGRectGetHeight(_map_titleImg.frame)-26*_Scale-21*_Scale)/2.0f;
    CGFloat __y_p=0;
    CGFloat _font=0;
    for (int i=0; i<_arr.count; i++) {

        __y_p=i==1?26*_Scale+_label_height:26*_Scale;
        _font=i==0?14:11;

        UILabel *label=[regular createLabelView:_arr[i] Withrect:CGRectMake(0, __y_p, CGRectGetWidth(_view_Map.frame), _label_height) WithTextColor:_define_blue_color WithTextAlignment:1 WithFont:_font];

        label.font=[regular get_en_Font:_font];

        [_map_titleImg addSubview:label];
    }



}
-(void)daohang
{
#pragma mark-导航

    //目的地位置
    CGFloat _lat=[detail_model.latitude doubleValue];
    CGFloat _long=[detail_model.longtitude doubleValue];
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

    NSString *myname=detail_model.full_address;

    toLocation.name =myname;

    NSArray *items = [NSArray arrayWithObjects:currentLocation, toLocation, nil];

    NSDictionary *options = @{ MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving, MKLaunchOptionsMapTypeKey: [NSNumber numberWithInteger:MKMapTypeStandard], MKLaunchOptionsShowsTrafficKey:@YES };
    
    //打开苹果自身地图应用，并呈现特定的item
    
    [MKMapItem openMapsWithItems:items launchOptions:options];
}
-(void)quanping_action:(UIButton *)btn
{

    [self.navigationController setNavigationBarHidden:YES animated:YES];

//    quanping_btn.hidden=YES;

    BOOL _isloc=[ToolManager is_right_locationWithLong:[detail_model.longtitude doubleValue] WithLat:[detail_model.latitude doubleValue]];
    MKCoordinateRegion reg;
    double _long=0;
    double _lat=0;
    if(_isloc)
    {
        _long=[detail_model.longtitude doubleValue];
        _lat=[detail_model.latitude doubleValue];

    }else
    {
        _long=-97;
        _lat=38.5;

    }
    CLLocation*_location=[[CLLocation alloc] initWithLatitude:_lat longitude:_long];
    CLLocationCoordinate2D coord = [_location coordinate];
    if(_isloc)
    {
        //放大到标注的位置
        reg = MKCoordinateRegionMakeWithDistance(coord, 3000, 3000);

    }else
    {
        CLLocationCoordinate2D c;
        c.latitude=38.5;
        c.longitude=-97;
        _long=-97;
        _lat=38.5;
        MKCoordinateSpan span;
        span.latitudeDelta=16;//20
        span.longitudeDelta=54;
        reg=MKCoordinateRegionMake(c, span);
    }

    [_mkMapView setRegion:reg animated:YES];
    _mkMapView.frame=CGRectMake(0, 0, ScreenWidth, ScreenHeight);


    UIImageView *_map_title=[regular createImgView:@"导航底图" WithRect:CGRectMake(0, 0,ScreenWidth , 64)];
    [_mkMapView addSubview:_map_title];
    _map_title.userInteractionEnabled=YES;
    _map_title.tag=1000;
    //    18*21x


    UILabel *label_title=[[UILabel alloc] initWithFrame:CGRectMake((CGRectGetWidth(_map_title.frame)-200)/2.0f, CGRectGetHeight(_map_title.frame)-40, 200, 40)];

    label_title.font=(kIOSVersions>=9.0? [UIFont systemFontOfSize:16.0f]:[UIFont fontWithName:@"Helvetica Neue" size:16.0f]);

    [label_title setAttributedText:[regular createAttributeString:detail_model.cn_name andFloat:@(3.0)]];
    label_title.textColor=[UIColor whiteColor];
    label_title.textAlignment=1;
    [_map_title addSubview:label_title];


    if(suoxiao_btn==nil)
    {
        suoxiao_btn=[UIButton buttonWithType:UIButtonTypeCustom];
        suoxiao_btn.frame=CGRectMake(0, 0, 64, 64);

        //        suoxiao_btn.frame=CGRectMake(100, 100, 60, 60);
        suoxiao_btn.userInteractionEnabled=YES;
        //        [suoxiao_btn setBackgroundImage:[UIImage imageNamed:@"返回箭头"] forState:UIControlStateNormal];
        [suoxiao_btn addTarget:self action:@selector(suoxiao_action:) forControlEvents:UIControlEventTouchUpInside];
        [_map_title addSubview:suoxiao_btn];
        UIImageView *icon=[[UIImageView alloc] initWithFrame:CGRectMake(14, 30, 10, 15)];
        icon.image=[UIImage imageNamed:@"返回箭头"];
        [suoxiao_btn addSubview:icon];
    }else
    {
        suoxiao_btn.hidden=NO;
        [_map_title addSubview:suoxiao_btn];
    }
    //    [_mkMapView addSubview:_map_title];
    UIImageView *fulladdress=[[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(_mkMapView.frame)-600*_Scale)/2.0f, CGRectGetHeight(_mkMapView.frame)-60*_Scale-180*_Scale, 600*_Scale, 180*_Scale)];
    fulladdress.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(daohang)];
    [fulladdress addGestureRecognizer:tap];
    [_mkMapView addSubview:fulladdress];
    fulladdress.image=[UIImage imageNamed:@"school_fulladdress"];
    UILabel *label_fulladdress=[[UILabel alloc] initWithFrame:CGRectMake(0, 20*_Scale, 600*_Scale, 68*_Scale)];
    //    label_fulladdress.backgroundColor=[UIColor redColor];
    //    label_fulladdress.alpha=0.5;
    label_fulladdress.textColor=[UIColor whiteColor];
    label_fulladdress.textAlignment=1;
    label_fulladdress.font=[regular get_en_Font:15.0f];
    [label_fulladdress setAttributedText:[regular createAttributeString:@"开启导航?" andFloat:@(2.0)]];
    [fulladdress addSubview:label_fulladdress];

    NSArray *arrtitle= [detail_model.full_address componentsSeparatedByString:@","];

    NSLog(@"%lu",(unsigned long)arrtitle.count);

    UIView *backview=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    CGFloat _jiange=(CGRectGetHeight(fulladdress.frame)-CGRectGetMaxY(label_fulladdress.frame)-60*_Scale)/2.0f;
    for (int i=0; i<2; i++) {
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, _jiange+30*_Scale*i+ CGRectGetMaxY(label_fulladdress.frame), CGRectGetWidth(fulladdress.frame), 30*_Scale)];
        //        label.backgroundColor=[UIColor redColor];
        label.textColor= [UIColor colorWithRed:77/255.0 green:190/255.0 blue:217/255.0 alpha:1.0];
        label.textAlignment=1;
        label.font=[regular get_en_Font:12.0f];
        if(i==0)
        {
            [label setAttributedText:[regular createAttributeString:arrtitle[0] andFloat:@(1.0)]];
        }else
        {
            NSMutableString *mutablestr=[[NSMutableString alloc] init];
            if(arrtitle.count>1)
            {
                for (int i=1;i<arrtitle.count; i++) {

                    [mutablestr appendString:arrtitle[i]];
                    if(i<arrtitle.count-1)
                    {
                        [mutablestr appendString:@","];

                    }
                }


            }
            [label setAttributedText:[regular createAttributeString:mutablestr andFloat:@(1.0)]];
            NSLog(@"%@",mutablestr);
        }
        [fulladdress addSubview:label];
        
    }
    backview.tag=2000;
    backview.backgroundColor=[UIColor grayColor];
    [self.view addSubview:backview];
    [backview addSubview:_mkMapView];
}
-(void)suoxiao_action:(UIButton *)btn
{
    [[self.view viewWithTag:1000] removeFromSuperview];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
//    [[UIApplication sharedApplication] setStatusBarHidden:NO];
//    []
     _mkMapView.frame=CGRectMake(0, 120*_Scale, CGRectGetWidth(_mapView.frame), CGRectGetHeight(_mapView.frame)-200*_Scale);
    [_mapView addSubview:_mkMapView];
    suoxiao_btn.hidden=YES;
//    quanping_btn.hidden=NO;
    [[self.view viewWithTag:2000] removeFromSuperview];



}
-(void)createAdmissionOfficerViewWithView:(UIView *)subview
{
    if([detail_model.web isEqualToString:@""]&&[detail_model.email isEqualToString:@""]&&[detail_model.phone isEqualToString:@""])
    {
        _view_AdmissionOfficer=[[ToolManager sharedManager] createView:CGRectMake(0, CGRectGetMaxY(subview.frame), CGRectGetWidth(_scrollView.frame),0) WithColor:[UIColor whiteColor]];

    }else
    {
        _view_AdmissionOfficer=[[ToolManager sharedManager] createView:CGRectMake(0, CGRectGetMaxY(subview.frame)+_margin, CGRectGetWidth(_scrollView.frame),380*_Scale) WithColor:[UIColor whiteColor]];

        DBImageView *head=[[DBImageView alloc]initWithFrame:CGRectMake((CGRectGetWidth(_view_AdmissionOfficer.frame)-142*_Scale)/2.0f, 52*_Scale, 142*_Scale, 142*_Scale)];
        head.layer.masksToBounds=YES;
        head.layer.cornerRadius=74*_Scale;

        UIView *zhegai=[[UIView alloc] initWithFrame:CGRectMake(-1,-1 , CGRectGetWidth(head.frame)+2, CGRectGetWidth(head.frame)+2)];
        zhegai.backgroundColor=[UIColor clearColor];
        zhegai.layer.masksToBounds=YES;
        zhegai.layer.cornerRadius=CGRectGetWidth(zhegai.frame)/2.0f;
        zhegai.layer.borderColor =[_define_head_color CGColor];
        zhegai.layer.borderWidth = 4.0f;
        [head addSubview:zhegai];



        if(detail_model.logo_url==nil)
        {
            head.image=[UIImage imageNamed:@"school_head_Default"];
        }else
        {
            head.placeHolder=[UIImage imageNamed:@"school_head_Default"];
            [head setImageWithPath:detail_model.logo_url];
        }


        [_view_AdmissionOfficer addSubview:head];

        //       50  120
        CGFloat _diameter=80*_Scale;
        CGFloat _jiange=(CGRectGetWidth(_view_AdmissionOfficer.frame)-_diameter*3-120*_Scale*2)/2.0f;
        CGFloat _x_p=120*_Scale;
        for (int i=0; i<3;i++) {

            UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
            [_view_AdmissionOfficer addSubview:btn];
            btn.frame=CGRectMake(_x_p, CGRectGetMaxY(head.frame)+50*_Scale, _diameter, _diameter);
            _x_p+=_jiange+_diameter;
            [btn addTarget:self action:@selector(AdmissionAction:) forControlEvents:UIControlEventTouchUpInside];
//            detail_model.phone
//            detail_model.web
//            detail_model.email

            btn.tag=1100+i;
            NSString *imagename=nil;
            if(i==0)
            {
                if([detail_model.phone isEqualToString:@""])
                {
                    imagename=@"school_电话_gray";

                }else
                {
                    imagename=@"school_电话";

                }

            }else if(i==1)
            {
                if([detail_model.web isEqualToString:@""])
                {
                    imagename=@"school_网址_gray";

                }else
                {
                    imagename=@"school_网址";
                    
                }

            }else if(i==2)
            {
                if([detail_model.email isEqualToString:@""])
                {
                    imagename=@"school_邮箱_gray";
                }else
                {

                    imagename=@"school_邮箱";
                }
            }

            [btn setBackgroundImage:[UIImage imageNamed:imagename] forState:UIControlStateNormal];
        }
    }
    [_scrollView addSubview:_view_AdmissionOfficer];
    _scrollView.contentSize=CGSizeMake(CGRectGetWidth(_scrollView.frame)-4*_Scale, CGRectGetMaxY(_view_AdmissionOfficer.frame)+200*_Scale);

}
#pragma mark-发送邮件
//-(void)displayComposerSheet
//{
//
//   BOOL _b=[MFMailComposeViewController canSendMail];
//    if(_b==YES)
//    {
//        MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
//        picker.mailComposeDelegate = self;
//
//        [picker setSubject:@"Enter Your Subject!"];
//
//        // Set up recipients
//        NSArray *toRecipients = [NSArray arrayWithObject:detail_model.email];
//
//
//        [picker setToRecipients:toRecipients];
//        [self presentViewController:picker animated:YES completion:nil];
//
//
//    }else
//    {
//        [[ToolManager sharedManager] alertTitle_Simple:@"请设置邮件账户"];
//        
//    }
//   
//
//
//
//
//
//}

-(void)AdmissionAction:(UIButton *)btn
{
    if(btn.tag-1100==0)
    {
//电话

        if(![detail_model.phone isEqualToString:@""])
        {
            phoneSheet=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:detail_model.phone otherButtonTitles: nil];
            phoneSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
            [phoneSheet showInView:self.view];


        }
    }else if(btn.tag-1100==1)
    {
        //网站
        if(![detail_model.web isEqualToString:@""])
        {
            webSheet=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"跳转至官网"otherButtonTitles: nil];
            webSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
            [webSheet showInView:self.view];

        }



    }else if(btn.tag-1100==2)
    {
//邮件
        if(![detail_model.email isEqualToString:@""])
        {
            emailSheet=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"发送邮件"otherButtonTitles: nil];
            emailSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
            [emailSheet showInView:self.view];

        }



    }

}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
//
    if(actionSheet==isdaohang_sheet)
    {
        if(buttonIndex==0)
        {
            [self daohang];
        }

    }else if(actionSheet == phoneSheet)
    {
        if (buttonIndex == 0) {
//            [self showAlert:@"确定"];
            NSMutableString *phonenum=[[NSMutableString alloc] initWithFormat:@"001"];
            for (int i=0; i<detail_model.phone.length; i++) {
                char a=[detail_model.phone characterAtIndex:i];
                if(a<='9'&&a>='0')
                {
                    [phonenum appendFormat:@"%c",a];

                }
            }

            [self dialPhoneNumber:phonenum];
            NSLog(@"111");
        }else if (buttonIndex == 1) {
//            [self showAlert:@"第一项"];
            NSLog(@"111");
        }

    }else if (actionSheet==webSheet)
    {
        if (buttonIndex == 0) {

            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[[NSString alloc] initWithFormat:@"http://%@",detail_model.web]]];
            NSLog(@"111");
        }else if (buttonIndex == 1) {
            //            [self showAlert:@"第一项"];
            NSLog(@"111");
        }
    }else if(actionSheet==JumpwebsiteSheet)
    {
        if (buttonIndex == 0) {

            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.schoolbox.us/"]];
            NSLog(@"111");
        }else if (buttonIndex == 1) {
            //            [self showAlert:@"第一项"];
            NSLog(@"111");
        }
    }
    else if (actionSheet==emailSheet)
    {
        if (buttonIndex == 0) {


            [self displayComposerSheet:detail_model.email];

        }else if (buttonIndex == 1) {
            //            [self showAlert:@"第一项"];
            NSLog(@"111");
        }

    }else if(actionSheet==phoneSheet1)
    {
        if (buttonIndex == 0) {

            NSMutableString *phonenum=[[NSMutableString alloc] initWithFormat:@"001"];
            for (int i=0; i<((NSString *)[AdmissionDict objectForKey:@"cell"]).length; i++) {
                char a=[[AdmissionDict objectForKey:@"cell"] characterAtIndex:i];
                if(a<='9'&&a>='0')
                {
                    [phonenum appendFormat:@"%c",a];

                }
            }
            NSLog(@"%@",phonenum);
            [self dialPhoneNumber:phonenum];
            NSLog(@"111");
        }
    }else if(actionSheet==emailSheet1)
    {

        if (buttonIndex == 0) {

            NSLog(@"%@",[AdmissionDict objectForKey:@"email"]);
            [self displayComposerSheet:[AdmissionDict objectForKey:@"email"]];


        }else if (buttonIndex == 1) {
            //            [self showAlert:@"第一项"];
            NSLog(@"111");
        }
        
        
    }else if(actionSheet==renzheng_webSheet)
    {

        if (buttonIndex == 0) {

            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[[NSString alloc] initWithFormat:@"http://%@",___web]]];
            NSLog(@"111");
        }else if (buttonIndex == 1) {
            //            [self showAlert:@"第一项"];
            NSLog(@"111");
        }
        
    }

}


- (void) dialPhoneNumber:(NSString *)aPhoneNumber
{
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",aPhoneNumber]];
    if ( !phoneCallWebView ) {
        phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    }
    [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
}
//@"总学生数",@"AP课程数",@"SAT均分",@"ACT均分"
//_view_school_profile
-(void)createDataViewWithView:(UIView *)subview
{

    if(([detail_model.ap_count integerValue]>0)||([detail_model.sat_avg integerValue]>0)||([detail_model.act_avg integerValue]>0))
    {
        _view_school_data=[[ToolManager sharedManager] createView:CGRectMake(0, CGRectGetMaxY(subview.frame)+_margin, CGRectGetWidth(_scrollView.frame), 200*_Scale) WithColor:[UIColor whiteColor]];
//        @"总学生数",
        [_scrollView addSubview:_view_school_data];
        NSArray *titleArr=@[@"AP课程数",@"SAT均分",@"ACT均分"];
//        [[NSString alloc]initWithFormat:@"%ld",(long)detail_model.total_students]
        NSArray *dataArr=@[detail_model.ap_count,detail_model.sat_avg,detail_model.act_avg];
        CGFloat interval=(CGRectGetWidth(_scrollView.frame)-110*3*_Scale)/4;
        for (int i=0; i<titleArr.count; i++) {

            UIImageView *titleImage=[[UIImageView alloc] initWithFrame:CGRectMake((i+1)*interval+i*110*_Scale, 22*_Scale, 110*_Scale, 110*_Scale)];
            [_view_school_data addSubview:titleImage];


            UIColor *color=nil;
            titleImage.layer.masksToBounds=YES;
            titleImage.layer.cornerRadius=55*_Scale;
            if([dataArr[i] isEqualToString:@"0"])
            {
                color=[UIColor colorWithRed:220.0f/255.0f green:220.0f/255.0f blue:220.0f/255.0f alpha:1];
                titleImage.backgroundColor=[UIColor colorWithRed:249.0f/255.0f green:249.0f/255.0f blue:249.0f/255.0f alpha:1];
            }else
            {
                color=[UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1];
                NSString *title=nil;
                titleImage.backgroundColor=[UIColor whiteColor];

                titleImage.layer.borderWidth=1;
                UIColor *_color=[UIColor colorWithRed:236.0f/255.0f green:236.0f/255.0f blue:236.0f/255.0f alpha:1];
                titleImage.layer.borderColor=[_color CGColor];

                title=dataArr[i];
                UILabel *labelImage=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(titleImage.frame), CGRectGetHeight(titleImage.frame))];
                labelImage.font=[regular get_en_Font:18.0f];

                labelImage.text=title;
                labelImage.textAlignment=1;
                labelImage.textColor=_define_blue_color;

                [titleImage addSubview:labelImage];
            }
            UILabel *label=[[ToolManager sharedManager] createLabelView:titleArr[i] Withrect:CGRectMake(CGRectGetMinX(titleImage.frame)-20, CGRectGetMaxY(titleImage.frame), CGRectGetWidth(titleImage.frame)+40, CGRectGetHeight(_view_school_data.frame)-CGRectGetMaxY(titleImage.frame)) WithTextColor:color WithTextAlignment:1 WithFont:13.0f];
            label.font=[regular getFont:11.0f];
            [_view_school_data addSubview:label];
        }



    }else
    {
        _view_school_data=[[ToolManager sharedManager] createView:CGRectMake(0, CGRectGetMaxY(subview.frame), CGRectGetWidth(_scrollView.frame),0) WithColor:[UIColor whiteColor]];
        
    }
    [_scrollView addSubview:_view_school_data];

    _scrollView.contentSize=CGSizeMake(CGRectGetWidth(_scrollView.frame)-4*_Scale, CGRectGetMaxY(_view_school_data.frame)+200*_Scale);

    
}

-(void)createProfileViewWithView:(UIView *)subview
{
//    CGFloat max_y=CGRectGetMaxY(_view_Category.frame)+CGRectGetWidth(_scrollView.frame)*7/320;
//    NSString *_description=nil;
    if([detail_model.miaoshu isEqualToString:@""])
    {

        //        _description=@"正在翻译学校介绍，请稍候。";
        _view_school_profile=[[ToolManager sharedManager] createView:CGRectMake(0, CGRectGetMaxY(subview.frame), CGRectGetWidth(_scrollView.frame), 0) WithColor:[UIColor whiteColor]];
    }else
    {

        _view_school_profile=[[ToolManager sharedManager] createView:CGRectMake(0, CGRectGetMaxY(subview.frame)+_margin, CGRectGetWidth(_scrollView.frame), CGRectGetHeight(web.frame)+60*_Scale) WithColor:[UIColor whiteColor]];

        [_scrollView addSubview:_view_school_profile];

        [_view_school_profile addSubview:web];
    }
        _scrollView.contentSize=CGSizeMake(CGRectGetWidth(_scrollView.frame)-4*_Scale, CGRectGetMaxY(_view_school_profile.frame)+200*_Scale);
}
- (void)webViewDidFinishLoad:(UIWebView *)webView { //webview 自适应高度
    CGRect frame = webView.frame;
    CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
    webView.frame = frame;


    _view_school_profile.frame=CGRectMake(CGRectGetMinX(_view_school_profile.frame),CGRectGetMinY(_view_school_profile.frame), CGRectGetWidth(_view_school_profile.frame), CGRectGetHeight(_view_school_profile.frame)+frame.size.height);
    _view_Admissions.frame=CGRectMake(CGRectGetMinX(_view_Admissions.frame),CGRectGetMinY(_view_Admissions.frame)+frame.size.height, CGRectGetWidth(_view_Admissions.frame), CGRectGetHeight(_view_Admissions.frame));

     _view_Map.frame=CGRectMake(CGRectGetMinX(_view_Map.frame), CGRectGetMinY(_view_Map.frame)+frame.size.height, CGRectGetWidth(_view_Map.frame),CGRectGetHeight(_view_Map.frame)) ;



    _view_Grade_ProportionView.frame=CGRectMake(CGRectGetMinX(_view_Grade_ProportionView.frame), CGRectGetMinY(_view_Grade_ProportionView.frame)+frame.size.height, CGRectGetWidth(_view_Grade_ProportionView.frame),CGRectGetHeight(_view_Grade_ProportionView.frame)) ;
    _view_Bag.frame=CGRectMake(CGRectGetMinX(_view_Bag.frame), CGRectGetMinY(_view_Bag.frame)+frame.size.height, CGRectGetWidth(_view_Bag.frame),CGRectGetHeight(_view_Bag.frame)) ;

    _view_StuGrade.frame=CGRectMake(CGRectGetMinX(_view_StuGrade.frame), CGRectGetMinY(_view_StuGrade.frame)+frame.size.height, CGRectGetWidth(_view_StuGrade.frame),CGRectGetHeight(_view_StuGrade.frame)) ;
    _view_school_data.frame=CGRectMake(CGRectGetMinX(_view_school_data.frame), CGRectGetMinY(_view_school_data.frame)+frame.size.height, CGRectGetWidth(_view_school_data.frame),CGRectGetHeight(_view_school_data.frame));

    _view_AP_Lession.frame=CGRectMake(CGRectGetMinX(_view_AP_Lession.frame), CGRectGetMinY(_view_AP_Lession.frame)+frame.size.height, CGRectGetWidth(_view_AP_Lession.frame),CGRectGetHeight(_view_AP_Lession.frame)) ;

    _view_activity.frame=CGRectMake(CGRectGetMinX(_view_activity.frame), CGRectGetMinY(_view_activity.frame)+frame.size.height, CGRectGetWidth(_view_activity.frame),CGRectGetHeight(_view_activity.frame)) ;

    _view_organization.frame=CGRectMake(CGRectGetMinX(_view_organization.frame), CGRectGetMinY(_view_organization.frame)+frame.size.height, CGRectGetWidth(_view_organization.frame),CGRectGetHeight(_view_organization.frame)) ;

    _view_Certification.frame=CGRectMake(CGRectGetMinX(_view_Certification.frame), CGRectGetMinY(_view_Certification.frame)+frame.size.height, CGRectGetWidth(_view_Certification.frame),CGRectGetHeight(_view_Certification.frame)) ;

    _view_SSAT.frame=CGRectMake(CGRectGetMinX(_view_SSAT.frame), CGRectGetMinY(_view_SSAT.frame)+frame.size.height, CGRectGetWidth(_view_SSAT.frame),CGRectGetHeight(_view_SSAT.frame)) ;

    _view_Tuition.frame=CGRectMake(CGRectGetMinX(_view_Tuition.frame), CGRectGetMinY(_view_Tuition.frame)+frame.size.height, CGRectGetWidth(_view_Tuition.frame),CGRectGetHeight(_view_Tuition.frame)) ;

    _coll_titleimg.frame=CGRectMake(CGRectGetMinX(_coll_titleimg.frame), CGRectGetMinY(_coll_titleimg.frame)+frame.size.height, CGRectGetWidth(_coll_titleimg.frame),CGRectGetHeight(_coll_titleimg.frame)) ;

    _view_zonghe.frame=CGRectMake(CGRectGetMinX(_view_zonghe.frame), CGRectGetMinY(_view_zonghe.frame)+frame.size.height, CGRectGetWidth(_view_zonghe.frame),CGRectGetHeight(_view_zonghe.frame)) ;

    _view_wenli.frame=CGRectMake(CGRectGetMinX(_view_wenli.frame), CGRectGetMinY(_view_wenli.frame)+frame.size.height, CGRectGetWidth(_view_wenli.frame),CGRectGetHeight(_view_wenli.frame)) ;


    _coll_titlelab.frame=CGRectMake(CGRectGetMinX(_coll_titlelab.frame), CGRectGetMinY(_coll_titlelab.frame)+frame.size.height, CGRectGetWidth(_coll_titlelab.frame),CGRectGetHeight(_coll_titlelab.frame)) ;
    help_btn.frame=CGRectMake(CGRectGetMinX(help_btn.frame), CGRectGetMinY(help_btn.frame)+frame.size.height, CGRectGetWidth(help_btn.frame),CGRectGetHeight(help_btn.frame)) ;

    banbenimg.frame=CGRectMake(CGRectGetMinX(banbenimg.frame), CGRectGetMinY(banbenimg.frame)+frame.size.height, CGRectGetWidth(banbenimg.frame),CGRectGetHeight(banbenimg.frame)) ;


    _scrollView.contentSize=CGSizeMake(CGRectGetWidth(_scrollView.frame), _scrollView.contentSize.height+frame.size.height);


    //tableView reloadData
}

-(UIImageView  *)CreateVerifiedBackView
{
    UIImageView *imageview=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [self.view addSubview:imageview];
    imageview.image=[UIImage imageNamed:@"蒙板"];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissVerifiedBackView:)];
    [imageview addGestureRecognizer:tap];
    imageview.userInteractionEnabled=YES;
    return imageview;
}
-(void)dismissVerifiedBackView:(UITapGestureRecognizer *)sender
{

    [sender.view removeFromSuperview];
}

#pragma mark-跳转至官网
-(void)Jumptowebsite
{

    JumpwebsiteSheet=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"跳转至官网" otherButtonTitles: nil];
    JumpwebsiteSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [JumpwebsiteSheet showInView:self.view];

}
#pragma mark-认证view
-(void)CreateVerifiedView
{
    UIImageView *imageview=[self CreateVerifiedBackView];
    NSLog(@"%@",AdmissionsArr);

    //320 305 258
//    [detail_model.is_identification isEqualToString:@"0"]?@"待认证":@"认证",］

    //320 305 258
    UIView *contentview=[[UIView alloc] init];
    contentview.backgroundColor=[UIColor whiteColor];
    [imageview addSubview:contentview];
    CGFloat content_w=400*_Scale;
    CGFloat content_h=0;
    NSString *headstr=nil;
    if([detail_model.is_identification isEqualToString:@"0"])
    {
        headstr=@"screenShcoolView_未认证";
        content_h=280*_Scale;
        contentview.frame=CGRectMake((CGRectGetWidth(imageview.frame)-content_w)/2.0f, (CGRectGetHeight(imageview.frame)-content_h)/2.0f, content_w, content_h);
        //        y100 h40
        //        h36
        //        h36 50
        NSArray *contentarr=@[@"本校数据信息获取自",@"学校官网",@"尚未获得官方正式认证"];

        CGFloat _label_y_p=100*_Scale;
        for (int i=0; i<contentarr.count; i++) {
            CGFloat _labelheight=i==0?40*_Scale:i==1?40*_Scale:64*_Scale;

            CGRect _rect=CGRectMake(0, _label_y_p, CGRectGetWidth(contentview.frame), _labelheight);

            UILabel *label=[[UILabel alloc] initWithFrame:_rect];
            [contentview addSubview:label];

            CGFloat _jiange=i==2?2.0f:2.0f;
            [label setAttributedText:[regular createAttributeString:contentarr[i] andFloat:@(_jiange)]];
            label.textAlignment=1;
            label.textColor=i==0?[UIColor colorWithRed:135.0f/255.0f green:135.0f/255.0f blue:135.0f/255.0f alpha:1]:i==1?yellow_color_2:[UIColor colorWithRed:210.0f/255.0f green:210.0f/255.0f blue:210.0f/255.0f alpha:1];
            label.font=i==2?[regular getFont:10.0f]:i==1?[regular getFont:12.0f]:[regular getFont:11.0f];

            if(i==1)
            {

                _label_y_p+=_labelheight+5*_Scale;
            }else
            {
                _label_y_p+=_labelheight;
            }

        }


        CGFloat _head_r=135*_Scale;
        UIImageView *head=[[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(contentview.frame)-_head_r)/2.0f, -_head_r/2.0f, _head_r, _head_r)];
        [contentview addSubview:head];
        head.image=[UIImage imageNamed:headstr];
    }else
    {

         headstr=@"screenShcoolView_认证";
        NSLog(@"%@",AdmissionsArr);
        if(AdmissionsArr.count>0)
        {
            NSDictionary *dict=AdmissionsArr[0];
            content_h=305*_Scale;
            contentview.frame=CGRectMake((CGRectGetWidth(imageview.frame)-content_w)/2.0f, (CGRectGetHeight(imageview.frame)-content_h)/2.0f, content_w, content_h);
            //        y94 h30
            //        h50
            //        h40 30

            NSString *username=nil;
            if([dict objectForKey:@"username"]==[NSNull null])
            {
                username=@"";
            }else
            {
                if([dict objectForKey:@"username"]==nil)
                {
                     username=@"";
                }else if([[dict objectForKey:@"username"] isKindOfClass:[NSString class]])
                {
                    username=[dict objectForKey:@"username"];
                }else
                {
                    username=@"";
                }

            }
            NSString *title=nil;
            if([dict objectForKey:@"title"]==[NSNull null])
            {
                title=@"";
            }else
            {
                if([dict objectForKey:@"title"]==nil)
                {
                    title=@"";
                }else if([[dict objectForKey:@"title"] isKindOfClass:[NSString class]])
                {
                    title=[dict objectForKey:@"title"];
                }else
                {
                    title=@"";
                }

            }
            NSArray *contentarr=@[@"数据信息已由校方",@"核实认证",username,title];

            CGFloat _label_y_p=94*_Scale;
            for (int i=0; i<contentarr.count; i++) {
                CGFloat _labelheight=i==0?30*_Scale:i==1?30*_Scale:i==2?40*_Scale:30*_Scale;

                CGRect _rect=CGRectMake(0, _label_y_p, CGRectGetWidth(contentview.frame), _labelheight);

                UILabel *label=[[UILabel alloc] initWithFrame:_rect];
                [contentview addSubview:label];

                CGFloat _jiange=i==0?2.0f:i==1?3.0f:0;
                [label setAttributedText:[regular createAttributeString:contentarr[i] andFloat:@(_jiange)]];
                label.textAlignment=1;
                label.textColor=(i==2||i==1)?yellow_color_2:[UIColor colorWithRed:135.0f/255.0f green:135.0f/255.0f blue:135.0f/255.0f alpha:1];
                if(i==2)
                {
                    label.font=[regular get_en_Font:13.0f];
                }else
                {
                    if(i==3)
                    {
                        label.font=[regular get_en_Font:11.0f];
                    }else
                    {
                        label.font=[regular getFont:11.0f];
                    }

                }
                _label_y_p+=_labelheight;

            }
            //144 60

            BOOL _showsign=NO;

            if([dict objectForKey:@"sign_pic"]==[NSNull null])
            {
                _showsign=NO;

            }else
            {
                if([dict objectForKey:@"sign_pic"]==nil)
                {
                    _showsign=NO;
                }else if([[dict objectForKey:@"sign_pic"] isKindOfClass:[NSString class]])
                {
                    _showsign=YES;
                }
            }
            if(_showsign)
            {
                DBImageView *sign=[[DBImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(contentview.frame)-144*_Scale)/2.0f, _label_y_p+((CGRectGetHeight(contentview.frame)-_label_y_p-60*_Scale)/2.0f), 144*_Scale, 60*_Scale)];
                [contentview addSubview:sign];
                [sign setImageWithPath:[dict objectForKey:@"sign_pic"]];
                [contentview addSubview:sign];
            }else
            {
                contentview.frame=CGRectMake((CGRectGetWidth(imageview.frame)-content_w)/2.0f, (CGRectGetHeight(imageview.frame)-content_h-60*_Scale)/2.0f, content_w, content_h-60*_Scale);

            }
            CGFloat _head_r=135*_Scale;
            UIImageView *head=[[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(contentview.frame)-_head_r)/2.0f, -_head_r/2.0f, _head_r, _head_r)];
            [contentview addSubview:head];
            head.image=[UIImage imageNamed:headstr];
        }



    }


}
#pragma mark-合作view
-(void)CreateParteredView
{
    UIImageView *imageview=[self CreateVerifiedBackView];

//320 305 258
    UIView *contentview=[[UIView alloc] init];
    contentview.backgroundColor=[UIColor whiteColor];
    [imageview addSubview:contentview];
    CGFloat content_w=400*_Scale;
    CGFloat content_h=0;
    NSString *headstr=nil;
    if([detail_model.is_teamwork isEqualToString:@"0"])
    {
        headstr=@"screenShcoolView_未合作";
        content_h=280*_Scale;
        contentview.frame=CGRectMake((CGRectGetWidth(imageview.frame)-content_w)/2.0f, (CGRectGetHeight(imageview.frame)-content_h)/2.0f, content_w, content_h);
        //        y100 h40
        //        h36
        //        h36 50
        NSArray *contentarr=@[@"正在努力联系学校加入",@"'平台计划'",@"尚未参加平台计划"];

        CGFloat _label_y_p=100*_Scale;
        for (int i=0; i<contentarr.count; i++) {
            CGFloat _labelheight=i==0?40*_Scale:i==1?40*_Scale:64*_Scale;

            CGRect _rect=CGRectMake(0, _label_y_p, CGRectGetWidth(contentview.frame), _labelheight);

            UILabel *label=[[UILabel alloc] initWithFrame:_rect];
            [contentview addSubview:label];

            CGFloat _jiange=i==2?2.0f:2.0f;
            [label setAttributedText:[regular createAttributeString:contentarr[i] andFloat:@(_jiange)]];
            label.textAlignment=1;
            label.textColor=i==0?[UIColor colorWithRed:135.0f/255.0f green:135.0f/255.0f blue:135.0f/255.0f alpha:1]:i==1?yellow_color_2:[UIColor colorWithRed:210.0f/255.0f green:210.0f/255.0f blue:210.0f/255.0f alpha:1];
            label.font=i==2?[regular getFont:10.0f]:i==1?[regular getFont:12.0f]:[regular getFont:11.0f];

            if(i==1)
            {

                _label_y_p+=_labelheight+5*_Scale;
            }else
            {
                _label_y_p+=_labelheight;
            }
            
        }


    }else
    {
        headstr=@"screenShcoolView_合作";
        content_h=305*_Scale;
        contentview.frame=CGRectMake((CGRectGetWidth(imageview.frame)-content_w)/2.0f, (CGRectGetHeight(imageview.frame)-content_h)/2.0f, content_w, content_h);
//        y115 h40
//        h50
//        h30 30
        NSArray *contentarr=@[@"学校已加入平台计划",@"正式合作",@"schoolbox.us",@"让老师互动，在线申请吧",@"更多功能请访问网站"];

        CGFloat _label_y_p=85*_Scale;
        for (int i=0; i<contentarr.count; i++) {
            CGFloat _labelheight=i==0?40*_Scale:i==1?40*_Scale:i==2?50*_Scale:i==3?30*_Scale:30*_Scale;

            CGRect _rect=CGRectMake(0, _label_y_p, CGRectGetWidth(contentview.frame), _labelheight);
            if(i==2)
            {
                UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame=_rect;
                [contentview addSubview:btn];
                [btn setTitleColor:yellow_color_2 forState:UIControlStateNormal];
                [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
                [btn setTitle:contentarr[i] forState:UIControlStateNormal];
                btn.titleLabel.font=[regular get_en_Font:13.0f];
                [btn addTarget:self action:@selector(Jumptowebsite) forControlEvents:UIControlEventTouchUpInside];


            }else
            {
                UILabel *label=[[UILabel alloc] initWithFrame:_rect];
                [contentview addSubview:label];

                CGFloat _jiange=i==0?2.0f:3.0f;
                [label setAttributedText:[regular createAttributeString:contentarr[i] andFloat:@(_jiange)]];
                label.textAlignment=1;
                label.textColor=i==1?yellow_color_2:[UIColor colorWithRed:135.0f/255.0f green:135.0f/255.0f blue:135.0f/255.0f alpha:1];
                label.font=[regular getFont:11.0f];

            }
            if(i==2)
            {

                _label_y_p+=_labelheight+5*_Scale;
            }else
            {
                _label_y_p+=_labelheight;
            }

        }


    }
    CGFloat _head_r=135*_Scale;
    UIImageView *head=[[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(contentview.frame)-_head_r)/2.0f, -_head_r/2.0f, _head_r, _head_r)];
    [contentview addSubview:head];
    head.image=[UIImage imageNamed:headstr];
}
-(void)createRankViewWithView:(UIView *)subview
{
    /** 大学榜单排名 business_insider(Business Insider 排名)  niche(Niche School 排名)  prep_review(Prep Review 排名)*/
//    __dict(ranks);
//    _view_Rank
    CGFloat max_y=0;
    bool _haveRankData=NO;
    NSArray *titleArr=@[@"Business Insider",@"Niche School",@"Prep Review"];
    NSArray *keyArr=@[@"business_insider",@"niche",@"prep_review"];
    for (NSString *ketstr in keyArr) {
        NSString *str=[detail_model.ranks objectForKey:ketstr];
        if([str integerValue])
        {
            _haveRankData=YES;
            break;
        }
    }
    if(_haveRankData)
    {
        max_y=CGRectGetMaxY(subview.frame)+_margin;
        _view_Rank=[[ToolManager sharedManager] createView:CGRectMake(0, max_y, CGRectGetWidth(_scrollView.frame), 250*_Scale) WithColor:[UIColor whiteColor]];
//        50 20
        CGFloat _jiange = (ScreenWidth-50*3*_Scale)/4.0f;
        for (int i=0; i<3; i++) {
            UIView *_view=[[UIView alloc] init];
            [_view_Rank addSubview:_view];
            _view.frame=CGRectMake(_jiange+(_jiange+50*_Scale)*i, 20*_Scale, 50*_Scale, 50*_Scale);
            _view.layer.masksToBounds=YES;
            _view.layer.cornerRadius=25;
            _view.backgroundColor=[UIColor colorWithDisplayP3Red:186.0f/255.0f green:198.0f/255.0f blue:67.0f/255.0f alpha:1];
            
            UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50*_Scale, 50*_Scale)];
            [_view addSubview:label];
            label.font=[regular get_en_Font:18.0f];
            label.textColor=[UIColor whiteColor];
            label.textAlignment=1;
            label.text=[detail_model.ranks objectForKey:[keyArr objectAtIndex:i]];
            
            UILabel *titlelabel1=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_view.frame)-5*_Scale, CGRectGetMaxY(_view.frame), CGRectGetWidth(_view.frame)+10*_Scale, 26*_Scale)];
            [_view_Rank addSubview:titlelabel1];
            titlelabel1.font=[regular get_en_Font:12.0f];
            titlelabel1.textAlignment=1;
            titlelabel1.textColor=[UIColor colorWithRed:135.0f/255.0f green:135.0f/255.0f blue:135.0f/255.0f alpha:1];
            titlelabel1.text=[titleArr objectAtIndex:i];
            
            
            UILabel *titlelabel2=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_view.frame)-5*_Scale, CGRectGetMaxY(titlelabel1.frame), CGRectGetWidth(_view.frame)+10, 26*_Scale)];
            [_view_Rank addSubview:titlelabel2];
            titlelabel2.font=[regular getFont:12.0f];
            titlelabel2.textAlignment=1;
            titlelabel2.textColor=[UIColor colorWithRed:135.0f/255.0f green:135.0f/255.0f blue:135.0f/255.0f alpha:1];
            titlelabel2.text=@"排名";
        }
        
    }else
    {
        max_y=CGRectGetMaxY(subview.frame);
        _view_Rank=[[ToolManager sharedManager] createView:CGRectMake(0, max_y, CGRectGetWidth(_scrollView.frame), 0) WithColor:[UIColor whiteColor]];
    }
    [_scrollView addSubview:_view_Rank];
    
}
-(void)createCategoryViewWithView:(UIView *)subview
{
    CGFloat max_y=CGRectGetMaxY(subview.frame)+_margin;
    _view_Category=[[ToolManager sharedManager] createView:CGRectMake(0, max_y, CGRectGetWidth(_scrollView.frame), 180*_Scale*2) WithColor:[UIColor whiteColor]];
    [_scrollView addSubview:_view_Category];


    //
    CGFloat _maxY_CategoryMinView=24*_Scale;

    CGFloat _min_radius=78*_Scale;
    CGFloat _max_radius=78*_Scale;
    CGFloat _interval_CategoryView=(CGRectGetWidth(_scrollView.frame)-_min_radius*3-_max_radius-1*_Scale-48*_Scale*4)/2;
//    has_religiou
    NSArray *array=@[
                     [[NSDictionary alloc] initWithObjectsAndKeys:@"screenShcool_高中",@"高 中",@"screenShcool_初中",@"初 中",@"screenShcool_初中高中",@"初 高 中", nil]
                     ,
                     [[NSDictionary alloc] initWithObjectsAndKeys:@"screenShcool_走读",@"走 读",@"screenShcool_寄宿",@"寄 宿", nil],
                     [[NSDictionary alloc] initWithObjectsAndKeys:@"screenShcool_混校",@"混 校",@"screenShcool_男校",@"男 校",@"screenShcool_女校",@"女 校", nil],

                     [[NSDictionary alloc] initWithObjectsAndKeys:@"screenShcool_认证",@"认证",@"screenShcool_未认证",@"待认证", nil],
                     [[NSDictionary alloc] initWithObjectsAndKeys:@"school_uniform",@"有校服",@"school_uniform未点击",@"无校服", nil],
                     [[NSDictionary alloc] initWithObjectsAndKeys:@"school_宗教",@"有宗教",@"school_宗教未点击",@"无宗教", nil],
                     [[NSDictionary alloc] initWithObjectsAndKeys:@"screenShcool_esl",@"ESL",@"screenShcool_无esl1",@"无ESL", nil],
                      [[NSDictionary alloc] initWithObjectsAndKeys:@"screenShcool_合作",@"合作",@"screenShcool_未合作",@"未合作", nil]

                     ];
    NSString *day_type=nil;
    //    boarding day
    if([detail_model.boarding_day isEqualToString:@"day"])
    {
        day_type=@"走 读";
    }else if([detail_model.boarding_day isEqualToString:@"boarding"])
    {
        day_type=@"寄 宿";
    }else if([detail_model.boarding_day isEqualToString:@"all"])
    {
        day_type=@"寄 宿";
    }else
    {
        day_type=@"";
    }

    NSInteger chugaozhong=0;
    if([detail_model.is_junior isEqualToString:@"1"]&&[detail_model.is_senior isEqualToString:@"1"])
    {
        chugaozhong=3;
    }else if([detail_model.is_junior isEqualToString:@"0"]&&[detail_model.is_senior isEqualToString:@"1"])
    {
        chugaozhong=2;
    }else if([detail_model.is_junior isEqualToString:@"1"]&&[detail_model.is_senior isEqualToString:@"0"])
    {
        chugaozhong=1;
    }


//([detail_model.isesl isEqualToString:@"1"]?@"ESL":[detail_model.isesl isEqualToString:@"0"]?@"无ESL":@"")
    NSArray *titleArray=@[
                          chugaozhong==1?@"初 中":chugaozhong==2?@"高 中":chugaozhong==3?@"初 高 中":@""
                          ,day_type
                          ,
                           ([detail_model.student_sex_limit isEqualToString:@"2"]?@"混 校":[detail_model.student_sex_limit  isEqualToString:@"1"]?@"男 校":[detail_model.student_sex_limit  isEqualToString:@"0"]?@"女 校":@""),

                            [detail_model.is_identification isEqualToString:@"0"]?@"待认证":@"认证",
                          [detail_model.uniform isEqualToString:@"0"]?@"无校服":@"有校服",
                          [detail_model.has_religiou isEqualToString:@"0"]?@"无宗教":@"有宗教",
                          ([detail_model.isesl isEqualToString:@"1"]?@"ESL":[detail_model.isesl isEqualToString:@"0"]?@"无ESL":@""),
                          [detail_model.is_teamwork isEqualToString:@"0"]?@"未合作":@"合作"

                          ];
    NSLog(@"%@",titleArray);
//    [detail_model.is_teamwork isEqualToString:@"0"]?@"未合作":@"合作"

    int j=0;
    CGFloat radius=0;
    CGFloat maxY=0;
    CGFloat sum=0;
    for (int i=0; i<array.count; i++) {
        i==3?(j+=2):(j++);
        radius=i<3?_min_radius:_max_radius;

        if(i>3)
        {
            maxY=180*_Scale+_maxY_CategoryMinView;
        }else
        {
            maxY=_maxY_CategoryMinView;

        }
        if(i==0||i==4)
        {
            sum=_interval_CategoryView;
        }else
        {
            if(i!=3&&i!=7)
            {
                sum+=(radius+48*_Scale);

            }else
            {

                sum+=(radius+48*_Scale);
                UIView *view=[[ToolManager sharedManager] createView:CGRectMake(sum-0.5*_Scale, _maxY_CategoryMinView+7*_Scale,1*_Scale , CGRectGetHeight(_view_Category.frame)-(_maxY_CategoryMinView+7*_Scale)*2) WithColor:_define_cailiao_text_color];
                [_view_Category addSubview:view];
                sum+=48*_Scale+CGRectGetWidth(view.frame);
            }

        }



        UIImageView *imageview=[[UIImageView alloc] initWithFrame:CGRectMake(sum, maxY, radius, radius)];
//        imageview.backgroundColor=[UIColor redColor];
        if([titleArray[i] isEqualToString:@""])
        {
            imageview.backgroundColor=[UIColor whiteColor];
        }else
        {

            NSString *imagename=[((NSDictionary *)array[i]) objectForKey:titleArray[i]];
            [imageview setImage:[UIImage imageNamed:imagename]];
        }
        imageview.userInteractionEnabled=YES;
        if(i==3)
        {
            UITapGestureRecognizer *tap1=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(CreateVerifiedView)];
            [imageview addGestureRecognizer:tap1];

        }else if(i==7)
        {
            UITapGestureRecognizer *tap2=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(CreateParteredView)];
            [imageview addGestureRecognizer:tap2];
        }

        [_view_Category addSubview:imageview];

        NSString *title=nil;
        if([titleArray[i] isEqualToString:@"有校服"]||[titleArray[i] isEqualToString:@"无校服"])
        {
            title=@"校 服";
        }else if([titleArray[i] isEqualToString:@"有宗教"]||[titleArray[i] isEqualToString:@"无宗教"])
        {
            title=@"宗 教";
        }else if([titleArray[i] isEqualToString:@"无ESL"]||[titleArray[i] isEqualToString:@"ESL"])
        {
            title=@"ESL";
        }else if([titleArray[i] isEqualToString:@"合作"]||[titleArray[i] isEqualToString:@"未合作"])
        {
            title=@"合 作";
        }else if([titleArray[i] isEqualToString:@"待认证"]||[titleArray[i] isEqualToString:@"认证"])
        {
            title=@"认 证";
        }else
        {
            title=titleArray[i];
        }

        UILabel *label=[[ToolManager sharedManager] createLabelView:title Withrect:CGRectMake(imageview.frame.origin.x-20, CGRectGetMaxY(imageview.frame), radius+40,180*_Scale-radius-_maxY_CategoryMinView) WithTextColor:[UIColor colorWithRed:135.0f/255.0f green:135.0f/255.0f blue:135.0f/255.0f alpha:1] WithTextAlignment:1 WithFont:11.0f];


        label.font=label.font = [regular getFont:11.0f];
        [_view_Category addSubview:label];
        
        //        }
    }
    
    
}

#pragma mark-检测当前偏移量

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{

    if(scrollView==_scrollView&&_appear)
    {
        _start_y=scrollView.contentOffset.y;
        NSLog(@"滚动视图即将开始拖动=%f",scrollView.contentOffset.y);
        _Dragging=YES;
    }


}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    if(_Dragging)
    {
        if(scrollView==_scrollView&&_appear)
        {

            NSLog(@"滚动视图正在滚动=%f",scrollView.contentOffset.y);
            if(_start_y<20&&scrollView.contentOffset.y>20)
            {

                if(!_nav_donghua)
                {
                    [UIView beginAnimations:@"anmationAppear" context:nil];
                    [UIView setAnimationDuration:0.2];
                    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
                    [UIView setAnimationDelegate:self];
                    self.navigationController.navigationBar.frame=CGRectMake(0, -24, [[UIScreen mainScreen]bounds].size.width, 44);
                    self.navigationItem.titleView.alpha=0;
                    //        _leftBarbtn
                    _leftBarbtn.alpha=0;
                    shareschoolBtn.alpha=0;
                    [UIView commitAnimations];
                    _nav_donghua=YES;

                }

            }else
            {
                if(scrollView.contentOffset.y<20)
                {

                    if(_nav_donghua)
                    {
                        [UIView beginAnimations:@"anmationAppear" context:nil];
                        [UIView setAnimationDuration:0.2];
                        [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
                        [UIView setAnimationDelegate:self];
                        self.navigationController.navigationBar.frame=CGRectMake(0, 20, [[UIScreen mainScreen]bounds].size.width, 44);
                        self.navigationItem.titleView.alpha=1;
                        _leftBarbtn.alpha=1;
                        shareschoolBtn.alpha=1;
                        [UIView commitAnimations];
                        _nav_donghua=NO;
                    }
                }else
                {
                    if(((scrollView.contentOffset.y-_start_y)>(ScreenHeight/4.0f)))
                    {
                        if(!_nav_donghua)
                        {
                            //        动画显示
                            [UIView beginAnimations:@"anmationAppear" context:nil];
                            [UIView setAnimationDuration:0.2];
                            [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
                            [UIView setAnimationDelegate:self];
                            self.navigationController.navigationBar.frame=CGRectMake(0, -24, [[UIScreen mainScreen]bounds].size.width, 44);
                            self.navigationItem.titleView.alpha=0;
                            _leftBarbtn.alpha=0;
                            shareschoolBtn.alpha=0;
                            [UIView commitAnimations];

                            _nav_donghua=YES;

                        }
                    }else if(((_start_y-scrollView.contentOffset.y)>(ScreenHeight/4.0f)))
                    {

                        if(_nav_donghua)
                        {
                            [UIView beginAnimations:@"anmationAppear" context:nil];
                            [UIView setAnimationDuration:0.2];
                            [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
                            [UIView setAnimationDelegate:self];
                            self.navigationController.navigationBar.frame=CGRectMake(0, 20, [[UIScreen mainScreen]bounds].size.width, 44);
                            self.navigationItem.titleView.alpha=1;
                            _leftBarbtn.alpha=1;
                            shareschoolBtn.alpha=1;
                            [UIView commitAnimations];
                            _nav_donghua=NO;
                            
                        }
                    }
                }
            }
        }

    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(scrollView==_scrollView&&_appear)
    {
        _Dragging=NO;
    }
}


-(void)collection_action:(UIButton *)btn
{

    NSUserDefaults *dict=[NSUserDefaults standardUserDefaults];
    if([[dict objectForKey:@"islogin"] integerValue])
    {
        NSString *showtitle=nil;
        NSString *showimg=nil;
        if (btn.selected) {
            coll_Num--;
            btn.selected=NO;
            _num_c.text=[NSString stringWithFormat:@"%ld",(long)coll_Num];
            showimg=@"Prompt_移除心愿单";
            showtitle=@"已移除心愿";

        }else
        {
            coll_Num++;
            btn.selected=YES;
            _num_c.text=[NSString stringWithFormat:@"%ld",(long)coll_Num];
            showimg=@"Prompt_加入心愿单";
            showtitle=@"已加入心愿单";

        }

        [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:showtitle WithImg:showimg Withtype:1]];
        NSString *url=nil;
        if(detail_model.had_followed)
        {
            url=@"/v1/follows/cancel";
        }else
        {
            url=@"/v1/follows";
        }

        NSString *_token=nil;
        if([dict objectForKey:@"token"]==nil)
        {
            _token=@"";
        }else
        {
            _token=[dict objectForKey:@"token"];
        }


        NSDictionary *parameters=@{@"followable_type":@"school",@"followable_id":_sid,@"token":_token};


        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:[[NSString alloc] initWithFormat:@"%@%@",DNS,url] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *html = operation.responseString;
            NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
            if([[dict objectForKey:@"code"] integerValue]==1)
            {
                if(detail_model.had_followed)
                {
                    detail_model.had_followed=NO;
                }else
                {
                    detail_model.had_followed=YES;
                }
            }else
            {
                 [[ToolManager sharedManager] alertTitle_Simple:[dict objectForKey:@"message"]];
            }

            [[ToolManager sharedManager] removeProgress];

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
            [[ToolManager sharedManager] removeProgress];
        }];


    }else
    {
//        UIAlertView *alertview=[[ToolManager sharedManager] alertTitle_Simple:@"用户还未登录，请先登录"];
//        alertview.delegate=self;
        [self login_action];

    }
    
    
    
}
-(void)praise_action:(UIButton *)btn
{
    NSUserDefaults *dict=[NSUserDefaults standardUserDefaults];
    if([[dict objectForKey:@"islogin"] integerValue])
    {
        NSString *showtitle=nil;
        NSString *showimg=nil;
        if (btn.selected) {
            praise_Num--;
            btn.selected=NO;
            _num_p.text=[NSString stringWithFormat:@"%ld",(long)praise_Num];
            showtitle=@"已取消点赞";
            showimg=@"Prompt_已取消点赞";
        }else
        {
            praise_Num++;
            btn.selected=YES;
            _num_p.text=[NSString stringWithFormat:@"%ld",(long)praise_Num];
            showtitle=@"已点赞";
            showimg=@"Prompt_已点赞";
        }

        [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:showtitle WithImg:showimg Withtype:1]];


        NSString *url=nil;
        if(detail_model.had_voted)
        {
            url=@"/v1/votes/cancel";
        }else
        {
            url=@"/v1/votes";
        }
        NSString *_token=nil;
        if([dict objectForKey:@"token"]==nil)
        {
            _token=@"";
        }else
        {
            _token=[dict objectForKey:@"token"];
        }

        NSDictionary *parameters=@{@"voteable_type":@"school",@"voteable_id":_sid,@"token":_token};

        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:[[NSString alloc] initWithFormat:@"%@%@",DNS,url] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *html = operation.responseString;
            NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
            if([[dict objectForKey:@"code"] integerValue]==1)
            {

                if(detail_model.had_voted)
                {
                    detail_model.had_voted=NO;
                }else
                {
                    detail_model.had_voted=YES;
                }

            }else
            {
                 [[ToolManager sharedManager] alertTitle_Simple:[dict objectForKey:@"message"]];
            }

            [[ToolManager sharedManager] removeProgress];

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
            [[ToolManager sharedManager] removeProgress];
        }];


    }else
    {

//        UIAlertView *alertview=[[ToolManager sharedManager] alertTitle_Simple:@"用户还未登录，请先登录"];
//        alertview.delegate=self;
        [self login_action];

    }
    
    
}


-(void)createImgScreenView
{
    if(detail_model.feature_images.count)
    {
        //    创建pageViewControler（活动图片浏览视图）
        _pageViewControler = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];

        ImageViewController *imgvc = [[ImageViewController alloc]init];

        if(detail_model.feature_video.count>0)
        {
            for (int i=0; i<detail_model.feature_video.count; i++) {
                [mutable_school_image_arr addObject:[[NSDictionary alloc] initWithObjectsAndKeys:[detail_model.feature_video objectAtIndex:i],@"url",@"video",@"type",nil]];
            }
        }
        for (int i=0; i<detail_model.feature_images.count; i++) {
            [mutable_school_image_arr addObject:[[NSDictionary alloc] initWithObjectsAndKeys:[detail_model.feature_images objectAtIndex:i],@"url",@"image",@"type",nil]];
        }


        imgvc.array=mutable_school_image_arr;
        imgvc.view.backgroundColor = [UIColor whiteColor];
        imgvc.currentPage = 0;
        [_pageViewControler setViewControllers:@[imgvc] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
        _pageViewControler.delegate = self;
        _pageViewControler.dataSource = self;

        CGFloat w = self.view.frame.size.width-2*_margin;

        _pageViewControler.view.frame = CGRectMake(0, 0, w, photoHeight);
        [_scrollView addSubview:_pageViewControler.view];

        _pageControl = [[UIPageControl alloc]init];
        _pageControl.center = CGPointMake(w/2, photoHeight-10);
        [_scrollView addSubview:_pageControl];
        _pageControl.numberOfPages = detail_model.feature_images.count;
        _pageControl.currentPageIndicatorTintColor = yellow_color;
        _pageControl.pageIndicatorTintColor = [UIColor colorWithRed:204.0f/255.0f green:204.0f/255.0f blue:204.0f/255.0f alpha:1];

    }


}

#pragma  mark-pageViewController代理方法
-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{

    if(pageViewController==_pageViewControler)
    {

        ImageViewController *vc = (ImageViewController*)viewController;
        NSInteger index = vc.currentPage;
        index ++ ;

        ImageViewController *imgvc = [[ImageViewController alloc]init];
        imgvc.array=mutable_school_image_arr;
        imgvc.view.backgroundColor = [UIColor whiteColor];
        imgvc.maxPage = mutable_school_image_arr.count-1;
        imgvc.currentPage = index;
        return imgvc;
    }

    AdmissionViewController *vc = (AdmissionViewController*)viewController;
    NSInteger index = vc.currentPage;
    index ++ ;

    AdmissionViewController *imgvc = [[AdmissionViewController alloc]init];
    imgvc.array=AdmissionsArr;
    imgvc.view.backgroundColor = [UIColor whiteColor];
    imgvc.maxPage = AdmissionsArr.count-1;
    imgvc.currentPage = index;
    return imgvc;

}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    if(pageViewController==_pageViewControler)
    {
        ImageViewController *vc = (ImageViewController*)viewController;
        NSInteger index = vc.currentPage;
        index -- ;

        ImageViewController *imgvc = [[ImageViewController alloc]init];
        imgvc.array=mutable_school_image_arr;
        imgvc.view.backgroundColor = [UIColor whiteColor];
        imgvc.maxPage =mutable_school_image_arr.count-1;
        imgvc.currentPage = index;
        
        return imgvc;
    }
    AdmissionViewController *vc = (AdmissionViewController*)viewController;
    NSInteger index = vc.currentPage;
    index -- ;

    AdmissionViewController *imgvc = [[AdmissionViewController alloc]init];
    imgvc.array=AdmissionsArr;
    imgvc.view.backgroundColor = [UIColor whiteColor];
    imgvc.maxPage = AdmissionsArr.count-1;
    imgvc.currentPage = index;

    return imgvc;

}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if(pageViewController==_pageViewControler)
    {
        ImageViewController *vc =  pageViewController.viewControllers[0];
        _pageControl.currentPage = vc.currentPage;
        return;

    }
    

    AdmissionViewController *vc =  pageViewController.viewControllers[0];
    _pageadmissionControl.currentPage = vc.currentPage;

}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    if(pageViewController==_pageViewControler)
    {
        return mutable_school_image_arr.count;
    }

    return AdmissionsArr.count;
}


-(void)createSchoolIntroduceView
{
//pingfen_num
    _view_school_intro=[[ToolManager sharedManager] createImgView:@"" WithRect:CGRectMake(0, CGRectGetMaxY(_pageViewControler.view.frame), CGRectGetWidth(_scrollView.frame), 320*_Scale)];
    _view_school_intro.userInteractionEnabled=YES;
    _view_school_intro.backgroundColor=[UIColor whiteColor];

    CGSize _size_schoolIntro=_view_school_intro.frame.size;
    NSArray *_array_Intro=@[detail_model.setup_year,detail_model.en_name,detail_model.cn_name,[[NSString alloc]initWithFormat:@"%@，%@",detail_model.city,detail_model.cn_state]];

    CGFloat _y_p=10*_Scale;
    CGFloat _height=(CGRectGetHeight(_view_school_intro.frame)-40*_Scale-40*_Scale-74*_Scale)/3.0f;
    for (int i=0; i<_array_Intro.count; i++) {

        NSString *__title=i==0?[[NSString alloc] initWithFormat:@"- %@ 年-",_array_Intro[i]]:_array_Intro[i];
        CGFloat _font=i==1?17.5f:12.0f;
        UILabel *label=[[ToolManager sharedManager] createLabelView:__title Withrect:CGRectMake(0, _y_p, _size_schoolIntro.width, _height) WithTextColor:i==3?[UIColor colorWithRed:170.0/255.0f green:170.0/255.0f  blue:170.0/255.0f  alpha:1]:_define_blue_color WithTextAlignment:1 WithFont:_font];

        if(i==0)
        {
            [label setAttributedText:[regular createAttributeString:__title andFloat:@(1)]];

        }else if(i==1)
        {
            [label setAttributedText:[regular createAttributeString:__title andFloat:@(0)]];

        }else if(i==2)
        {
            [label setAttributedText:[regular createAttributeString:__title andFloat:@(2)]];

        }else
        {
            [label setAttributedText:[regular createAttributeString:__title andFloat:@(0)]];
        }


        if(i==2)
        {
            label.font = [regular getFont:15.0f];

        }else
        {
            if(i==3)
            {
                label.font = [regular getFont:_font];
            }else
            {
                label.font = [regular get_en_Font:_font];
            }

        }
        if(i==0)
        {
            _y_p+=_height-3*_Scale;
        }else if(i==1)
        {
            _y_p+=_height-7*_Scale;
        }else if(i==2)
        {
            _y_p+=_height-7*_Scale;
        }

        [_view_school_intro addSubview:label];
        
    }
    [_scrollView addSubview:_view_school_intro];

    view_star=[[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(_view_school_intro.frame)-184*_Scale)/2.0f, CGRectGetHeight(_view_school_intro.frame)-64*_Scale-40*_Scale, 184*_Scale, 35*_Scale)];
    view_star.userInteractionEnabled=YES;
    UITapGestureRecognizer *showtap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showCurrentlyStar)];
    [view_star addGestureRecognizer:showtap];

    [_view_school_intro addSubview:view_star];

    NSString *str_score=detail_model.ratings_avg;
    NSInteger _avg_score=0;
    CGFloat _cha_score=[str_score floatValue]-(CGFloat )[str_score integerValue];
    if(_cha_score>0.3)
    {

        _avg_score=[str_score integerValue]+1;
    }else
    {

        _avg_score=[str_score integerValue];
    }

    starsArr=[[NSMutableArray alloc] init];

    for (int i=0;i<5;i++) {

        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(i*(29*_Scale+10*_Scale), 2*_Scale, 29*_Scale, 29*_Scale);
//        btn.backgroundColor=[UIColor grayColor];
        [btn setImage:[UIImage imageNamed:@"school_评星"] forState:UIControlStateSelected];
        [btn setImage:[UIImage imageNamed:@"school_评星灰色"] forState:UIControlStateNormal];

        [btn addTarget:self action:@selector(showCurrentlyStar) forControlEvents:UIControlEventTouchUpInside];

        if(_avg_score>i)
        {
            btn.selected=YES;
        }

        [view_star addSubview:btn];
        [starsArr addObject:btn];
    }



    num_pf=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(view_star.frame)+25*_Scale, CGRectGetMinY(view_star.frame), CGRectGetWidth(_view_school_intro.frame)-CGRectGetMaxX(view_star.frame)-25*_Scale, 32*_Scale)];
    [_view_school_intro addSubview:num_pf];
//    starlabel.backgroundColor=[UIColor redColor];
    num_pf.textAlignment=0;
    num_pf.font=[regular get_en_Font:12.0f];
    num_pf.textColor=yellow_color;
    if([detail_model.ratings_avg isEqualToString:@"0.0"])
    {
        num_pf.text=@"";
    }else
    {
        num_pf.text=detail_model.ratings_avg;
    }

    NSLog(@"%ld",(long)pingfen_num);
    NSLog(@"111");

    [self createpingfennum_view];

}
-(void)createpingfennum_view
{
    if(pingfen_num==0)
    {
        pingfen_numview.hidden=YES;

        if(pingfen_no_numview==nil)
        {
            pingfen_no_numview=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(view_star.frame),CGRectGetWidth(_view_school_intro.frame) , CGRectGetHeight(_view_school_intro.frame)-CGRectGetMaxY(view_star.frame)-20*_Scale)];
            [_view_school_intro addSubview:pingfen_no_numview];

            UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(pingfen_no_numview.frame), CGRectGetHeight(pingfen_no_numview.frame))];
            label.textColor=[UIColor colorWithRed:170.0/255.0f green:170.0/255.0f  blue:170.0/255.0f  alpha:1];
            [pingfen_no_numview addSubview:label];
            label.textAlignment=1;
            label.font=[regular getFont:10.0f];
            [label setAttributedText:[regular createAttributeString:@"还没有评星" andFloat:@(1.0)]];

        }else
        {
            pingfen_no_numview.hidden=NO;
        }

    }else
    {
        pingfen_no_numview.hidden=YES;
        [pingfen_numview removeFromSuperview];
        pingfen_numview=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(view_star.frame),CGRectGetWidth(_view_school_intro.frame) , CGRectGetHeight(_view_school_intro.frame)-CGRectGetMaxY(view_star.frame)-20*_Scale)];
        [_view_school_intro addSubview:pingfen_numview];
        NSArray *arr=@[@"共",[[NSString alloc] initWithFormat:@" %ld ",(long)pingfen_num],@"个盒粉评星"];
        NSMutableArray *btnarr=[[NSMutableArray alloc] init];
        CGFloat _width=0;
        for (int i=0; i<arr.count; i++) {
            UILabel *label=[[UILabel alloc] init];
            [pingfen_numview addSubview:label];
            label.font=i==1?[regular get_en_Font:10.0f]:[regular getFont:10.0f];
            label.textColor=i==1?_define_blue_color:[UIColor colorWithRed:170.0f/255.0f green:170.0f/255.0f blue:170.0f/255.0f alpha:1];
            label.text=arr[i];
            [label sizeToFit];
            [btnarr addObject:label];
            _width+=CGRectGetWidth(label.frame);
        }
        CGFloat _x_p=(CGRectGetWidth(pingfen_numview.frame)-_width)/2.0f;
        for (int i=0; i<btnarr.count; i++) {
            UILabel *label=(UILabel *)btnarr[i];
            label.frame=CGRectMake(_x_p, (CGRectGetHeight(pingfen_numview.frame)-CGRectGetHeight(label.frame))/2.0f, CGRectGetWidth(label.frame), CGRectGetHeight(label.frame));
            _x_p+=CGRectGetWidth(label.frame);
            
        }
        
        
    }
    
}
-(void)dismissCurrentlyStarback
{
    [[self.view.window viewWithTag:8000] removeFromSuperview];
}
-(void)createSubmitStar:(UIView *)view
{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    [[self.view.window viewWithTag:8000] addSubview:btn];
    btn.frame=CGRectMake(CGRectGetMinX(view.frame), CGRectGetMaxY(view.frame), CGRectGetWidth(view.frame), 60*_Scale);
    [btn setBackgroundColor:[UIColor colorWithRed:107.0f/255.0f green:203.0f/255.0f blue:202.0f/255.0f alpha:1]];
    [btn setTitle:@"提交" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn.titleLabel setAttributedText:[regular createAttributeString:@"提交" andFloat:@(7.0)]];
    [btn addTarget:self action:@selector(SubmitStarnum) forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font=[regular getFont:13.0f];
}
-(void)SubmitStarnum
{
    [[self.view.window viewWithTag:8000] removeFromSuperview];
    [[ToolManager sharedManager] removeProgress];
    if(!_ispingfen)
    {
        ((UIButton *)[self.view viewWithTag:7000]).selected=YES;
    }
    [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"评星成功" WithImg:@"Prompt_评星成功" Withtype:1]];

    NSString *_token=nil;
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"token"]==nil)
    {
        _token=@"";
    }else
    {
        _token=[[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    }
    NSDictionary *parameters=@{@"school_id":_sid,@"token":_token,@"user_ratings":stardataDict};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:[[NSString alloc] initWithFormat:@"%@/v1/ratings/user_rating_school",DNS] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *html = operation.responseString;
        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
        if([[dict objectForKey:@"code"] integerValue]==1)
        {

            detail_model.school_ratings=[[dict objectForKey:@"data"] objectForKey:@"school_ratings"];

            NSString *rating_str=[[NSString alloc] initWithFormat:@"%.1f",[[[[dict objectForKey:@"data"] objectForKey:@"school_ratings"] objectForKey:@"main"] floatValue]];
            if([rating_str isEqualToString:@"0.0"])
            {
                num_pf.text=@"";
            }else
            {
                num_pf.text=rating_str;
            }

            [ratings_avg setString:rating_str];
            NSInteger pingxing=0;
            CGFloat jianju=[rating_str floatValue]-(CGFloat)[rating_str integerValue];
            if(jianju>0.3)
            {
                pingxing=[rating_str integerValue]+1;
            }else
            {
                pingxing=[rating_str integerValue];
            }
            //                重新设置平行
//            设置按钮点亮状态
            for (int i=0; i<starsArr.count; i++) {
                UIButton *btn=starsArr[i];
                if(pingxing-1<i)
                {
                    btn.selected=NO;
                }else
                {
                    btn.selected=YES;
                }
            }
//评星人数增加
            pingfen_num++;
            if(!_ispingfen)
            {

                ((UILabel *)[self.view viewWithTag:20000]).text=[[NSString alloc] initWithFormat:@"%ld",(long)pingfen_num];
                _ispingfen=YES;
            }



            [[self.view viewWithTag:200] removeFromSuperview];
            _ispingfen_change=YES;
            [self createpingfennum_view];

        }else
        {
             [[ToolManager sharedManager] alertTitle_Simple:[dict objectForKey:@"message"]];
        }



    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        [[self.view.window viewWithTag:8000] removeFromSuperview];
        [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
        [[ToolManager sharedManager] removeProgress];
    }];

}
-(void)showAlertStar
{
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"token"]!=nil)
    {
        stardataDict=[[NSMutableDictionary alloc] init];
        UIView *view=[self showAlertStarView];
        [self createSubmitStar:view];
        [self requestUserStarAvg];
    }else
    {
//        UIAlertView *alertview=[[ToolManager sharedManager] alertTitle_Simple:@"用户还未登录，请先登录"];
//        alertview.delegate=self;
        [self login_action];
    }
}
-(UIView *)showAlertStarView
{
    UIImageView *back=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [self.view.window addSubview:back];
    back.image=[UIImage imageNamed:@"蒙板"];
    back.tag=8000;
    back.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissCurrentlyStarback)];
    [back addGestureRecognizer:tap];
    //    520 800

    UIView *showback=[[UIView alloc] initWithFrame:CGRectMake((ScreenWidth-480*_Scale)/2.0f, (ScreenHeight-760*_Scale)/2.0f, 480*_Scale, 700*_Scale)];
    [back addSubview:showback];
    UITapGestureRecognizer *tap111=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hhhh)];
    [showback addGestureRecognizer:tap111];
    showback.backgroundColor=[UIColor whiteColor];
    NSArray *headarr=@[@"school_showstar_学术",@"school_showstar_位置",@"school_showstar_体育",@"school_showstar_毕业",@"school_showstar_校园",@"school_showstar_艺术"];
    NSArray *headatitle=@[@"学术",@"位置",@"体育",@"毕业",@"校园",@"艺术"];

    NSArray *dataarr=@[@"academic",@"location",@"sports",@"graduation",@"campus",@"art"];

    //    94 50
    //    5
    //    90

    CGFloat _jiange=(CGRectGetHeight(showback.frame)-90*_Scale-70*_Scale*6)/5.0f;
    //    50 40
    CGFloat _y_p=70*_Scale;
    CGFloat _height=70*_Scale;

    showstarDict =[[NSMutableDictionary alloc] init];
    for (int i=0; i<headarr.count; i++) {

        CGFloat _x_p=54*_Scale;
        UIView *view_min=[[UIView alloc] initWithFrame:CGRectMake(0, _y_p, CGRectGetWidth(showback.frame), _height)];
       //  view_min.backgroundColor=[UIColor redColor];
        [showback addSubview:view_min];

        _y_p+=_height+_jiange;
        UIImageView *img=[[UIImageView alloc] initWithFrame:CGRectMake(_x_p, 0, 40*_Scale, 40*_Scale)];
        [view_min addSubview:img];
        img.image=[UIImage imageNamed:[headarr objectAtIndex:i]];

        UIView *starview=[self setstarView:[NSNumber numberWithFloat:0] withkey:dataarr[i] withselect:NO];
        starview.frame=CGRectMake(CGRectGetMaxX(img.frame)+25*_Scale, -5*_Scale, CGRectGetWidth(starview.frame), CGRectGetHeight(starview.frame));
        [view_min addSubview:starview];

        UILabel *schoolavg=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(starview.frame)+25*_Scale, 0, CGRectGetWidth(view_min.frame)-CGRectGetMaxX(starview.frame)-25*_Scale, CGRectGetHeight(img.frame))];
        [view_min addSubview:schoolavg];
        //        schoolavg.backgroundColor=[UIColor cyanColor];
        schoolavg.textAlignment=0;
        schoolavg.textColor=[UIColor colorWithRed:174.0f/255.0f green:174.0f/255.0f blue:174.0f/255.0f alpha:1];
        schoolavg.font=[regular getFont:12.0f];
        [schoolavg setAttributedText:[regular createAttributeString:headatitle[i] andFloat:@(3.0)]];




    }

    return showback;
    
}
-(void)hhhh{}
-(void)showCurrentlyStarView
{

    UIImageView *back=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [self.view.window addSubview:back];
    back.image=[UIImage imageNamed:@"蒙板"];
    back.tag=8000;
    back.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissCurrentlyStarback)];
    [back addGestureRecognizer:tap];
    //    520 800

    UIView *showback=[[UIView alloc] initWithFrame:CGRectMake((ScreenWidth-480*_Scale)/2.0f, (ScreenHeight-700*_Scale)/2.0f, 480*_Scale, 700*_Scale)];
    [back addSubview:showback];
    UITapGestureRecognizer *tap111=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hhhh)];
    [showback addGestureRecognizer:tap111];
    showback.backgroundColor=[UIColor whiteColor];

    NSArray *headarr=@[@"school_showstar_学术",@"school_showstar_位置",@"school_showstar_体育",@"school_showstar_毕业",@"school_showstar_校园",@"school_showstar_艺术"];
    NSArray *headatitle=@[@"学术",@"位置",@"体育",@"毕业",@"校园",@"艺术"];

    NSArray *dataarr=@[@"academic",@"location",@"sports",@"graduation",@"campus",@"art"];

    //    94 50
    //    5
    //    90
    CGFloat _jiange=(CGRectGetHeight(showback.frame)-90*_Scale-90*_Scale*6)/5.0f;
    //    50 40
    CGFloat _y_p=70*_Scale;
    CGFloat _height=90*_Scale;

    showstarDict =[[NSMutableDictionary alloc] init];
    for (int i=0; i<headarr.count; i++) {

        CGFloat _x_p=54*_Scale;
        UIView *view_min=[[UIView alloc] initWithFrame:CGRectMake(0, _y_p, CGRectGetWidth(showback.frame), _height)];
//        view_min.backgroundColor=[UIColor redColor];
        [showback addSubview:view_min];
        _y_p+=_height+_jiange;
        UIImageView *img=[[UIImageView alloc] initWithFrame:CGRectMake(_x_p, 0, 40*_Scale, 40*_Scale)];
        [view_min addSubview:img];
        img.image=[UIImage imageNamed:[headarr objectAtIndex:i]];

        UILabel *title=[[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(img.frame), CGRectGetWidth(showback.frame), CGRectGetHeight(view_min.frame)-CGRectGetMaxY(img.frame))];
        [view_min addSubview:title];
        title.textAlignment=1;
        [title setAttributedText:[regular createAttributeString:headatitle[i] andFloat:@(3.0)]];
        title.textColor=[UIColor colorWithRed:174.0f/255.0f green:174.0f/255.0f blue:174.0f/255.0f alpha:1];
        title.font=[regular getFont:12.0f];


        UIView *starview=[self setstarView:[NSNumber numberWithFloat:0] withkey:dataarr[i] withselect:YES];
        starview.frame=CGRectMake(CGRectGetMaxX(img.frame)+25*_Scale, -5*_Scale, CGRectGetWidth(starview.frame), CGRectGetHeight(starview.frame));
        [view_min addSubview:starview];

        UILabel *schoolavg=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(starview.frame)+25*_Scale, 0, CGRectGetWidth(view_min.frame)-CGRectGetMaxX(starview.frame)-25*_Scale, CGRectGetHeight(img.frame))];
        [view_min addSubview:schoolavg];
//                schoolavg.backgroundColor=[UIColor cyanColor];
        schoolavg.textAlignment=0;
        schoolavg.textColor=_define_blue_color;
        schoolavg.font=[regular get_en_Font:12.0f];
        NSString *con=nil;
        if(detail_model.school_ratings!=nil)
        {
            if([detail_model.school_ratings isKindOfClass:[NSDictionary class]])
            {

                if([detail_model.school_ratings objectForKey:dataarr[i]]!=[NSNull null])
                {


                    if([detail_model.school_ratings objectForKey:dataarr[i]]!=nil&&[[detail_model.school_ratings objectForKey:dataarr[i]] floatValue]>0)
                    {



                        con=[[NSString alloc] initWithFormat:@"%.1f",[[detail_model.school_ratings objectForKey:dataarr[i]] floatValue]];
                        
                    }
                    
                }
                
                
            }
        }
        if(con!=nil)
        {
            schoolavg.text=con;
        }
    }



    for (int i=0; i<[[showstarDict allKeys] count]; i++) {
        NSDictionary *sss=detail_model.school_ratings;
        NSString *_key=dataarr[i];
        NSNumber *num=[sss objectForKey:_key];
        [self setstarnum:num withkey:dataarr[i]];

    }

}
-(void)showCurrentlyStar
{

        [self showCurrentlyStarView];


}
-(void)requestUserStarAvg
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSUserDefaults *dict=[NSUserDefaults standardUserDefaults];
    NSString *_token=nil;
    if([dict objectForKey:@"token"]==nil)
    {
        _token=@"";
    }else
    {
        _token=[dict objectForKey:@"token"];
    }
    NSDictionary *parameters=@{@"token":_token,@"school_id":_sid};
    [manager GET:[[NSString alloc] initWithFormat:@"%@%@",DNS,@"/v1/schools/user_ratings"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSString *html = operation.responseString;
        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];

        if([[dict objectForKey:@"code"] intValue]==1)
        {
            NSArray *dataarr=@[@"academic",@"location",@"sports",@"graduation",@"campus",@"art"];


            for (int i=0; i<[[showstarDict allKeys] count]; i++) {
                NSDictionary *sss=[[dict objectForKey:@"data"] objectForKey:@"user_ratings"];
                NSString *_key=dataarr[i];
                NSNumber *num=[sss objectForKey:_key];
                [self setstarnum:num withkey:dataarr[i]];

            }


        }else
        {
             [[ToolManager sharedManager] alertTitle_Simple:[dict objectForKey:@"message"]];
        }


    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
    }];


}
-(void)setstarnum:(NSNumber *)str_score withkey:(NSString *)key
{
    [showstarDict objectForKey:key];
    if([showstarDict objectForKey:key]!=nil&&[[showstarDict objectForKey:key] isKindOfClass:[NSMutableArray class]])
    {

        NSArray *btnarrr=[showstarDict objectForKey:key];
        NSInteger _avg_score=0;
        CGFloat _cha_score=[str_score floatValue]-(CGFloat )[str_score integerValue];
        if(_cha_score>0.3)
        {

            _avg_score=[str_score integerValue]+1;
        }else
        {

            _avg_score=[str_score integerValue];
        }
        for (int i=0; i<btnarrr.count; i++) {
            UIButton *btn=btnarrr[i];
            if(_avg_score>i)
            {
                btn.selected=YES;
            }else
            {
                btn.selected=NO;
            }
        }


    }

}
-(UIView *)setstarView:(NSNumber *)str_score withkey:(NSString *)key withselect:(BOOL )select
{
    NSMutableArray *mutablearr=[[NSMutableArray alloc] init];

    UIView *view_star=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 240*_Scale, 50*_Scale)];


    NSInteger _avg_score=0;
    CGFloat _cha_score=[str_score floatValue]-(CGFloat )[str_score integerValue];
    if(_cha_score>0.3)
    {

        _avg_score=[str_score integerValue]+1;
    }else
    {

        _avg_score=[str_score integerValue];
    }
    NSArray *dataarr=@[@"academic",@"location",@"sports",@"graduation",@"campus",@"art"];
    CGFloat _jiange=(CGRectGetWidth(view_star.frame)-36*_Scale*5)/4.0f;

//    starsArr=[[NSMutableArray alloc] init];
    for (int i=0;i<5;i++) {
        NSInteger _getindex=0;
        for (int j=0; j<dataarr.count; j++) {
            if([dataarr[j] isEqualToString:key])
            {
                _getindex=j;
            }
        }
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(i*(36*_Scale+_jiange), (CGRectGetHeight(view_star.frame)-36*_Scale)/2.0f, 36*_Scale, 36*_Scale);
        if(select)
        {
            btn.userInteractionEnabled=NO;

        }else
        {
            btn.userInteractionEnabled=YES;
            btn.tag=8500+_getindex*10+i;
            [btn addTarget:self action:@selector(selectstarview:) forControlEvents:UIControlEventTouchUpInside];
        }

        //        btn.backgroundColor=[UIColor grayColor];
        [btn setImage:[UIImage imageNamed:@"school_评星"] forState:UIControlStateSelected];
        [btn setImage:[UIImage imageNamed:@"school_评星灰色"] forState:UIControlStateNormal];
        if(_avg_score>i)
        {
            btn.selected=YES;
        }

        [view_star addSubview:btn];
        [mutablearr addObject:btn];
    }

    [showstarDict setObject:mutablearr forKey:key];
    return view_star;

}
-(void)selectstarview:(UIButton *)btn
{
    NSInteger tag=btn.tag-8500;
    NSArray *dataarr=@[@"academic",@"location",@"sports",@"graduation",@"campus",@"art"];
    NSInteger gaibian=tag%10;
    NSInteger index=tag/10;
    NSString *key=dataarr[index];
    NSLog(@"111");

    NSArray *arr=[showstarDict objectForKey:key];
    for (int i=0;i<arr.count; i++) {
        UIButton*btn=arr[i];
        if(gaibian>=i)
        {
            btn.selected=YES;
        }else
        {
            btn.selected=NO;
        }

    }
//stardataDict
    [stardataDict setObject:[NSNumber numberWithInteger:gaibian+1] forKey:key];


}
#pragma mark-传值

-(void)setData_dict:(NSDictionary *)data_dict
{

    if(_data_dict!=data_dict)
    {
        _data_dict=[data_dict copy];

        _sid=[[data_dict objectForKey:@"schoolID"] copy];


        UIView *view=[regular returnNavView:[data_dict objectForKey:@"schoolName"] withmaxwidth:230];
//        view.backgroundColor=[UIColor redColor];
        self.navigationItem.titleView=view;

        indicator = [[YYAnimationIndicator alloc]initWithFrame:CGRectMake(ScreenWidth/2-20*_Scale*2, ScreenHeight/2-20*_Scale*2, 40*_Scale*2, 40*_Scale*2)];
        [indicator setLoadText:@"loading..."];

        [self.view addSubview:indicator];
        [indicator startAnimation];

        [self loadAllData];
    }


}
-(void)loadWebview
{

//    <br>
    [indicator stopAnimationWithLoadText:@"loading..." withType:YES];

    NSString *newStr =detail_model.miaoshu;
    NSString *temp = nil;
    NSMutableString *mut=[[NSMutableString alloc] init];
    for(int i =0; i < [newStr length]; i++)
    {
        temp = [newStr substringWithRange:NSMakeRange(i, 1)];
        if([temp isEqualToString:@"\n"])
        {
            [mut appendString:@"<br>"];

        }else
        {
            [mut appendString:temp];
        }
    }

    web=[[UIWebView alloc] initWithFrame:CGRectMake(30*_Scale, 30*_Scale, CGRectGetWidth(_scrollView.frame)-60*_Scale, 10)];
    web.backgroundColor = [UIColor clearColor];
    web.delegate=self;

    NSString *font=nil;
    if(_isPad)
    {
        font=@"34px/40px";
    }else
    {
        font=@"14px/20px";
    }

    [web loadHTMLString:[NSString stringWithFormat:@"<style>body{word-wrap:break-word;margin:0;background-color:transparent;font:%@ Custom-Font-Name;align:justify;color:#999999}</style><div align='justify'>%@<div>",font,mut] baseURL:nil];
    web.opaque = NO;

    web.dataDetectorTypes = UIDataDetectorTypeNone;
    CGFloat height = [[web stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
    web.frame=CGRectMake(30*_Scale, 30*_Scale, CGRectGetWidth(_scrollView.frame)-60*_Scale, height);
    //        web.backgroundColor=[UIColor redColor];
    //        [_view_school_profile addSubview:web];
    [web sizeToFit];
    [self.view addSubview:web];
    [self UIConfig];

    if([[NSUserDefaults standardUserDefaults] objectForKey:@"token"])
    {
        [self requestUserDataisFirst:YES];
    }
}


-(void)viewWillDisappear:(BOOL)animated
{
    _appear=NO;
    _Dragging=NO;
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.frame=CGRectMake(0, 20, [[UIScreen mainScreen]bounds].size.width, 44);
    self.navigationItem.titleView.alpha=1;
    _leftBarbtn.alpha=1;
    shareschoolBtn.alpha=1;
    _nav_donghua=NO;
    [MobClick endLogPageView:@"SchoolDetailViewController"];

}
-(void)viewWillAppear:(BOOL)animated
{
    _appear=YES;
    [super viewWillAppear:animated];

    self.tabBarController.tabBar.hidden=YES;
    [[CustomTabbarController sharedManager] tabbarHide];
    [MobClick beginLogPageView:@"SchoolDetailViewController"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

