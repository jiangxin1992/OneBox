//
//  bangdanlistViewController.m
//  OneBox
//
//  Created by 谢江新 on 15/11/16.
//  Copyright © 2015年 谢江新. All rights reserved.
//

#import "fly_material_controller.h"

#import "CustomTabbarController.h"

#import "ApplyFilemodel.h"

@interface fly_material_controller ()

@end

@implementation fly_material_controller
{


    UIScrollView *_scrollView;
    //    必要材料view
    UIView *mustView;
    UIView *backview_must;
    //可选材料view
    UIView *optionView;
    UIView *backview_option;
    //    材料model
    ApplyFilemodel *appleFilemodel;
    //    获取的材料状态数据
    NSMutableDictionary *data_dict_must;
    //    标题
    NSArray *mustTitleArray;
    NSArray *optionTitleArray;
    //    照片
    NSArray *imageArr_option;
    NSArray *imageArr_must;
    //参数名
    NSArray *titleArr_must;
    NSArray *titleArr_option;
    //图片名
    NSArray *_must_select_img_arr;
    NSArray *_must_normal_img_arr;
    NSArray *_option_select_img_arr;
    NSArray *_option_normal_img_arr;

    //    1表示必须2表示可选
    NSInteger nowtouch;
    //当前修改的num
    NSInteger _alert_num;
    //    显示材料照片
    UIImageView *desImage;


}

-(void)popviewAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareData];
    [self createScrollView];
    [self UIConfig];
    [self requestCailiaoData];
}
-(void)prepareData
{
    nowtouch=0;
    self.view.backgroundColor=_define_backview_color;
    _option_normal_img_arr=@[
                                      @"box_progress_成绩单点击",
                                      @"box_progress_成绩单点击",
                                      @"box_progress_录取未点击",
                                      @"box_progress_证明未点击",
                                      @"box_progress_毕业证未点击",
                                      @"box_progress_毕业证未点击"
                                      ];
    _option_select_img_arr=@[
                                      @"box_progress_成绩单",
                                      @"box_progress_成绩单",
                                      @"box_progress_录取",
                                      @"box_progress_证明",
                                      @"box_progress_毕业证",
                                      @"box_progress_毕业证"
                                      ];
    _must_normal_img_arr=@[
                                    @"box_progress_户口本未点击",
                                    @"box_progress_护照未点击",
                                    @"box_progress_录取未点击",
                                    @"box_progress_费用未点击",
                                    @"box_progress_费用未点击",
                                    @"box_progress_录取未点击",
                                    @"box_progress_证明未点击",
                                    @"box_progress_证明未点击",
                                    @"box_progress_照片未点击"
                                    ];
    _must_select_img_arr=@[
                                    @"box_progress_户口本",
                                    @"box_progress_护照",
                                    @"box_progress_录取",
                                    @"box_progress_费用",
                                    @"box_progress_费用",
                                    @"box_progress_录取",
                                    @"box_progress_证明",
                                    @"box_progress_证明",
                                    @"box_progress_照片"
                                    ];
    data_dict_must=[[NSMutableDictionary alloc] init];
    titleArr_must=@[@"manage_notice",@"passport",@"ds160",@"sevis_fee_pay",@"visa_pay",@"a120",@"bank_savings",@"income",@"picture"];
    titleArr_option=@[@"study_reports",@"school_reports",@"enroll_letter",@"is_reading",@"house",@"household"];
    mustTitleArray=@[@"入馆通知",@"护照",@"DS160表",@"SEVIS费",@"签证费",@"I2O",@"存款证明",@"收入证明",@"照片"];
    optionTitleArray=@[@"学习成绩",@"语言成绩",@"录取信",@"在读证明",@"房产证",@"户口本"];
    imageArr_option = @[
                        @{@"imgname":@"学校成绩单.jpg",
                          @"w":[NSNumber numberWithInt:960],
                          @"h":[NSNumber numberWithInt:1400]
                          },
                        @{@"imgname":@"语言成绩.jpg",
                          @"w":[NSNumber numberWithInt:960],
                          @"h":[NSNumber numberWithInt:1400]
                          },
                        @{@"imgname":@"录取信.jpg",
                          @"w":[NSNumber numberWithInt:960],
                          @"h":[NSNumber numberWithInt:1400]
                          },
                        @{@"imgname":@"Applyfile_在读证明.jpg",
                          @"w":[NSNumber numberWithInt:960],
                          @"h":[NSNumber numberWithInt:1400]
                          },
                        @{@"imgname":@"",
                          @"w":[NSNumber numberWithInt:0],
                          @"h":[NSNumber numberWithInt:0]
                          },
                        @{@"imgname":@"",
                          @"w":[NSNumber numberWithInt:0],
                          @"h":[NSNumber numberWithInt:0]
                          }
                        ];
    imageArr_must = @[
                      @{@"imgname":@"入馆通知.jpg",
                        @"w":[NSNumber numberWithInt:960],
                        @"h":[NSNumber numberWithInt:1400]                        },
                      @{@"imgname":@"Applyfile_护照.jpg",
                        @"w":[NSNumber numberWithInt:960],
                        @"h":[NSNumber numberWithInt:1400]
                        },
                      @{@"imgname":@"ds160.jpg",
                        @"w":[NSNumber numberWithInt:960],
                        @"h":[NSNumber numberWithInt:1400]
                        },
                      @{@"imgname":@"sevis.jpg",
                        @"w":[NSNumber numberWithInt:960],
                        @"h":[NSNumber numberWithInt:1400]
                        },
                      @{@"imgname":@"签证费.jpg",
                        @"w":[NSNumber numberWithInt:960],
                        @"h":[NSNumber numberWithInt:1400]
                        },

                      @{@"imgname":@"I20.jpg",
                        @"w":[NSNumber numberWithInt:960],
                        @"h":[NSNumber numberWithInt:1400]
                        },

                      @{@"imgname":@"Applyfile_银行.jpg",
                        @"w":[NSNumber numberWithInt:960],
                        @"h":[NSNumber numberWithInt:1400]
                        },
                      @{@"imgname":@"工作收入证明.jpg",
                        @"w":[NSNumber numberWithInt:960],
                        @"h":[NSNumber numberWithInt:1400]
                        },
                      @{@"imgname":@"照片.jpg",
                        @"w":[NSNumber numberWithInt:960],
                        @"h":[NSNumber numberWithInt:1400]
                        }
                      ];
}
#pragma mark-材料的数据
-(void)requestCailiaoData
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    NSDictionary *parameters=@{@"token":[regular getToken]};
    [manager GET:[[NSString alloc] initWithFormat:@"%@%@",DNS,@"/v1/users/show_apply_documents"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *html = operation.responseString;
        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
        if([[dict objectForKey:@"code"] integerValue]==1)
        {

            appleFilemodel=[ApplyFilemodel parsingWithJsonDataForModel:dict];
            [data_dict_must setDictionary:[[dict objectForKey:@"data"] objectForKey:@"documents"]];

            CGFloat _radius=(CGRectGetWidth(backview_must.frame)-70*_Scale*2-85*_Scale*2)/3.0f;
            CGFloat interval=(CGRectGetHeight(backview_must.frame)-(50*_Scale+_radius)*3-50*_Scale)/2.0f;

            for (int i=0; i<mustTitleArray.count; i++) {
                UIButton *btn1=[UIButton buttonWithType:UIButtonTypeCustom];
                btn1.tag=800+i;


                [btn1 setBackgroundImage:[UIImage imageNamed:_must_normal_img_arr[i]] forState:UIControlStateNormal];
                [btn1 setBackgroundImage:[UIImage imageNamed:_must_select_img_arr[i]] forState:UIControlStateSelected];
                if([[data_dict_must objectForKey:titleArr_must[i]] integerValue]==1)
                {
                    btn1.selected=YES;
                }else
                {
                    btn1.selected=NO;
                }



                [backview_must addSubview:btn1];
                [btn1 addTarget:self action:@selector(subAction:) forControlEvents:UIControlEventTouchUpInside];
                btn1.frame=CGRectMake(70*_Scale+(85*_Scale+_radius)*(i%3), 30*_Scale+(_radius+50*_Scale+interval)*(i/3),_radius,_radius);
                UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(btn1.frame)-10, 30*_Scale+_radius+(_radius+50*_Scale+interval)*(i/3),_radius+20,50*_Scale)];
                label.textAlignment=1;
                [label setAttributedText:[regular createAttributeString:mustTitleArray[i] andFloat:@(2.0)]];
                label.textColor=_define_cailiao_text_color;
                label.font=[regular getFont:11.0f];
                [backview_must addSubview:label];

            }


            for (int i=0; i<optionTitleArray.count; i++) {
                UIButton *btn2=[UIButton buttonWithType:UIButtonTypeCustom];
                btn2.tag=200+i;
                if([[data_dict_must objectForKey:titleArr_option[i]] integerValue]==1)
                {
                    btn2.selected=YES;
                }else
                {
                    btn2.selected=NO;
                }


                [btn2 setBackgroundImage:[UIImage imageNamed:_option_normal_img_arr[i]] forState:UIControlStateNormal];
                [btn2 setBackgroundImage:[UIImage imageNamed:_option_select_img_arr[i]] forState:UIControlStateSelected];
                [backview_option addSubview:btn2];
                [btn2 addTarget:self action:@selector(subAction:) forControlEvents:UIControlEventTouchUpInside];
                btn2.frame=CGRectMake(70*_Scale+(85*_Scale+_radius)*(i%3), 30*_Scale+(_radius+50*_Scale+interval)*(i/3),_radius,_radius);
                //        btn.backgroundColor=[UIColor redColor];
                [backview_option addSubview:btn2];
                UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(btn2.frame)-10, 30*_Scale+_radius+(_radius+50*_Scale+interval)*(i/3),_radius+20,50*_Scale)];
                label.textAlignment=1;
                [label setAttributedText:[regular createAttributeString:optionTitleArray[i] andFloat:@(2.0)]];
                label.textColor=_define_cailiao_text_color;
                label.font=[regular getFont:11.0f];
                [backview_option addSubview:label];

            }


        }else
        {
            [[ToolManager sharedManager] alertTitle_Simple:[dict objectForKey:@"message"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

            [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
    }];
}
#pragma mark－提交材料
-(void)submitcailiao:(UIButton *)btn
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];

    NSInteger _index=_alert_num;
    UIButton *btn11=nil;
    NSMutableArray *arr111=[[NSMutableArray alloc] init];
    NSInteger _count=0;
    if(nowtouch==1)
    {

        btn11=(UIButton *)[self.view viewWithTag:800+_alert_num];
        [arr111 setArray:titleArr_must];
        _count=arr111.count;


    }else if(nowtouch==2)
    {
        btn11=(UIButton *)[self.view viewWithTag:_index+200];
        [arr111 setArray:titleArr_option];
        _count=arr111.count;

    }

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *parameters=[[NSMutableDictionary alloc] init];
    [parameters setObject:[regular getToken] forKey:@"token"];
    //    JXLOG(@"titleArr=%@",titleArr);

    for (int i=0; i<arr111.count; i++) {
        if(i==_index)
        {
            JXLOG(@"%@",data_dict_must);
            NSInteger _obj=0;
            if([[data_dict_must objectForKey:arr111[i]] integerValue])
            {
                _obj=0;
            }else
            {
                _obj=1;
            }
            [parameters setObject:[NSNumber numberWithInteger:_obj] forKey:arr111[i]];


        }else
        {
            NSInteger _obj=0;
            if([data_dict_must objectForKey:arr111[i]]==nil)
            {
                _obj=0;
                [parameters setObject:[NSNumber numberWithInteger:_obj] forKey:arr111[i]];
            }else
            {
                [parameters setObject:[data_dict_must objectForKey:arr111[i]] forKey:arr111[i]];

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

            [[self.view.window viewWithTag:10000] removeFromSuperview];


            if(!btn11.selected)
            {
                [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"完成材料" WithImg:@"Prompt_完成材料" Withtype:1]];
                btn11.selected=YES;
            }else
            {
                [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"取消完成材料" WithImg:@"Prompt_取消完成材料" Withtype:1]];
                btn11.selected=NO;
            }


            NSInteger _obj=0;
            if([[data_dict_must objectForKey:arr111[_index]] integerValue])
            {
                _obj=0;
            }else
            {
                _obj=1;
            }
            [data_dict_must removeObjectForKey:arr111[_index]];
            [data_dict_must setObject:[NSNumber numberWithInteger:_obj] forKey:arr111[_index]];

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

    if(btn.tag>=800&&900>btn.tag)
    {
        nowtouch=1;
    }else if(btn.tag>=200&&300>btn.tag)
    {
        nowtouch=2;
    }
    if(nowtouch==1)
    {
        _alert_num=btn.tag-800;

    }else if ( nowtouch==2)
    {
        _alert_num=btn.tag-200;
    }

    if(btn.selected)
    {
        [self submitcailiao:btn];
    }else
    {

#pragma mark-隐藏导航状态栏
        //    蒙板
        CGFloat __w=0;
        CGFloat __h=0;
        if(nowtouch==1)
        {
            //        _alert_num=btn.tag-100;
            __w=[[((NSDictionary *)imageArr_must[_alert_num]) objectForKey:@"w"] floatValue];
            __h=[[((NSDictionary *)imageArr_must[_alert_num]) objectForKey:@"h"] floatValue];

        }else if (nowtouch==2)
        {
            //        _alert_num=btn.tag-200;
            __w=[[((NSDictionary *)imageArr_option[_alert_num]) objectForKey:@"w"] floatValue];
            __h=[[((NSDictionary *)imageArr_option[_alert_num]) objectForKey:@"h"] floatValue];
        }
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

            [self.view.window addSubview:backview];
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
            if(nowtouch==1)
            {

                desImage.image = [UIImage imageNamed:[((NSDictionary *)imageArr_must[_alert_num]) objectForKey:@"imgname"]];


            }else if ( nowtouch==2)
            {

                desImage.image = [UIImage imageNamed:[((NSDictionary *)imageArr_option[_alert_num]) objectForKey:@"imgname"]];

            }

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
- (void)removeImage:(UITapGestureRecognizer *)tap
{

    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    //    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[self.view.window viewWithTag:10000] removeFromSuperview];
}
-(void)createScrollView
{
    _scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64-100*_Scale)];
    _scrollView.contentSize=CGSizeMake(ScreenWidth, ScreenHeight);
    _scrollView.backgroundColor=self.view.backgroundColor;
    _scrollView.showsVerticalScrollIndicator=YES;
    [self.view addSubview:_scrollView];
}
-(void)UIConfig
{
    //    56
    mustView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_scrollView.frame), 682*_Scale)];
    //    mustView.backgroundColor=[UIColor redColor];
    [_scrollView addSubview:mustView];
    //10 56 602 10 140
    UIView *_view_title=[[UIView alloc] initWithFrame:CGRectMake(8*_Scale, 10*_Scale,CGRectGetWidth(mustView.frame)-16*_Scale, 60*_Scale)];
    _view_title.backgroundColor=[UIColor whiteColor];
    [mustView addSubview:_view_title];


    UIImageView *_titleview=[[ToolManager sharedManager]createTitleView:@" 必 要 材 料 样 例 " WithRect:CGRectMake(28*_Scale, 0,CGRectGetWidth(_view_title.frame)-56*_Scale,CGRectGetHeight(_view_title.frame)) WithImg:@"" WithtitleColor:_define_blue_color WithTextAlignment:1 WithFontName:(kIOSVersions>=9.0? @"":@"Helvetica Neue" ) WithFont:14.0];
    _titleview.backgroundColor=_define_cailiao_color;
    [_view_title addSubview:_titleview];
    backview_must=[[UIView alloc] initWithFrame:CGRectMake(8*_Scale, CGRectGetMaxY(_view_title.frame), CGRectGetWidth(_scrollView.frame)-16*_Scale, 602*_Scale)];
    backview_must.backgroundColor=[UIColor whiteColor];
    [mustView addSubview:backview_must];

    optionView=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(mustView.frame)+10*_Scale, CGRectGetWidth(_scrollView.frame), 506*_Scale)];

    //    optionView.backgroundColor=[UIColor redColor];
    [_scrollView addSubview:optionView];
    //10 56 602 10 140
    UIView *_view_title1=[[UIView alloc] initWithFrame:CGRectMake(8*_Scale,0,CGRectGetWidth(optionView.frame)-16*_Scale, 60*_Scale) ];
    _view_title1.backgroundColor=[UIColor whiteColor];
    [optionView addSubview:_view_title1];

    UIImageView *_titleview11=[[ToolManager sharedManager]createTitleView:@" 补 充 材 料 样 例 " WithRect:CGRectMake(28*_Scale, 0, CGRectGetWidth(_view_title1.frame)-56*_Scale, CGRectGetHeight(_view_title1.frame)) WithImg:@"" WithtitleColor:_define_blue_color WithTextAlignment:1 WithFontName:(kIOSVersions>=9.0? @"":@"Helvetica Neue" ) WithFont:14.0f];
    _titleview11.backgroundColor=_define_cailiao_color;
    [_view_title1 addSubview:_titleview11];
    backview_option=[[UIView alloc] initWithFrame:CGRectMake(8*_Scale, CGRectGetMaxY(_titleview.frame), CGRectGetWidth(_scrollView.frame)-16*_Scale, 426*_Scale)];
    backview_option.backgroundColor=[UIColor whiteColor];
    [optionView addSubview:backview_option];
    _scrollView.contentSize=CGSizeMake(CGRectGetWidth(_scrollView.frame), CGRectGetMaxY(optionView.frame));
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[CustomTabbarController sharedManager] tabbarHide];
}/*
 #pragma mark - Navigation

 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
