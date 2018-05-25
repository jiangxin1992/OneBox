//
//  bangdanlistViewController.m
//  OneBox
//
//  Created by 谢江新 on 15/11/16.
//  Copyright © 2015年 谢江新. All rights reserved.
//

#import "SubmitMaterialController.h"

#import "CustomTabbarController.h"

#import "ApplyFilemodel.h"

@interface SubmitMaterialController ()

@end

@implementation SubmitMaterialController
{
    ApplyFilemodel *appleFilemodel;
    UIImageView *desImage;
    NSArray *imageArr;
    CGFloat _alert_num;
    UIScrollView *_scrollView;
    NSArray *mustTitleArray;
    NSMutableDictionary *data_dict_must;
    NSArray *titleArr;
}

-(void)popviewAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setstate
{
    for (int i=0; i<mustTitleArray.count; i++) {
        UIButton *btn=(UIButton *)[self.view viewWithTag:100+i];
        if([[data_dict_must objectForKey:titleArr[i]] integerValue]==1)
        {
            btn.selected=YES;
        }else
        {
            btn.selected=NO;
        }

    }

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
            JXLOG(@"111");
            appleFilemodel=[ApplyFilemodel parsingWithJsonDataForModel:dict];
            [data_dict_must setDictionary:[[dict objectForKey:@"data"] objectForKey:@"documents"]];
            [self setstate];

        }else
        {
            [[ToolManager sharedManager] alertTitle_Simple:[dict objectForKey:@"message"]];
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

            [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
    }];
}
-(void)prepareData
{
    imageArr = @[
                 @{@"imgname":@"Applyfile_申请表",
                   @"w":[NSNumber numberWithInt:960],
                   @"h":[NSNumber numberWithInt:1400]
                   },
                 @{@"imgname":@"Applyfile_护照.jpg",
                   @"w":[NSNumber numberWithInt:960],
                   @"h":[NSNumber numberWithInt:1400]
                   },
                 @{@"imgname":@"Applyfile_毕业证",
                   @"w":[NSNumber numberWithInt:960],
                   @"h":[NSNumber numberWithInt:1400]
                   },
                 @{@"imgname":@"Applyfile_成绩单.jpg",
                   @"w":[NSNumber numberWithInt:960],
                   @"h":[NSNumber numberWithInt:1400]
                   },
                 @{@"imgname":@"语言成绩.jpg",
                   @"w":[NSNumber numberWithInt:960],
                   @"h":[NSNumber numberWithInt:1400]
                   },

                 @{@"imgname":@"学校成绩单.jpg",
                   @"w":[NSNumber numberWithInt:960],
                   @"h":[NSNumber numberWithInt:1400]
                   },

                 @{@"imgname":@"Applyfile_银行.jpg",
                   @"w":[NSNumber numberWithInt:960],
                   @"h":[NSNumber numberWithInt:1400]
                   },

                 @{@"imgname":@"Applyfile_在读证明.jpg",
                   @"w":[NSNumber numberWithInt:960],
                   @"h":[NSNumber numberWithInt:1400]
                   },

                 @{@"imgname":@"Applyfile_推荐信.jpg",
                   @"w":[NSNumber numberWithInt:960],
                   @"h":[NSNumber numberWithInt:1400]
                   }
                 ];

    mustTitleArray=@[@"申请表",@"护照",@"毕业证",@"测试成绩",@"语言成绩",@"学习成绩",@"存款证明",@"在读证明",@"推荐信"];
    data_dict_must=[[NSMutableDictionary alloc] init];
    titleArr=@[@"school_apply_table",@"passport",@"diploma",@"test_report",@"school_reports",@"study_reports",@"bank_savings",@"is_reading",@"recommend_letter"];

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
    [self createScrollView];
    [self createMustMaterialView];

}
-(UIView *)createMustMaterialView
{
    UIView *mustView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_scrollView.frame), 822*_Scale)];
    [_scrollView addSubview:mustView];
    UIView *_view_title=[[UIView alloc] initWithFrame:CGRectMake(8*_Scale, 10*_Scale,CGRectGetWidth(_scrollView.frame)-16*_Scale, 60*_Scale) ];
    _view_title.backgroundColor=[UIColor whiteColor];
    [mustView addSubview:_view_title];

    UIImageView *_titleview=[[ToolManager sharedManager]createTitleView:@" 通 用 材 料 样 例 " WithRect:CGRectMake(28*_Scale, 0,CGRectGetWidth(_view_title.frame)-56*_Scale, CGRectGetHeight(_view_title.frame)) WithImg:@"" WithtitleColor:_define_blue_color WithTextAlignment:1 WithFontName:(kIOSVersions>=9.0? @"":@"Helvetica Neue" ) WithFont:14.0f];
    _titleview.backgroundColor=_define_cailiao_color;
    [_view_title addSubview:_titleview];
    UIView *backview=[[UIView alloc] initWithFrame:CGRectMake(8*_Scale, CGRectGetMaxY(_view_title.frame), CGRectGetWidth(_scrollView.frame)-16*_Scale, 602*_Scale)];
    backview.backgroundColor=[UIColor whiteColor];
    [mustView addSubview:backview];

    NSArray *normal_img_arr=@[
                              @"box_progress_申请表未点击",
                              @"box_progress_护照未点击",
                              @"box_progress_毕业证未点击",
                              @"box_progress_成绩单点击",
                              @"box_progress_成绩单点击",
                              @"box_progress_成绩单点击",
                              @"box_progress_证明未点击",
                              @"box_progress_证明未点击",
                              @"box_progress_录取未点击"
                              ];
    NSArray *select_img_arr=@[
                              @"box_progress_申请表",
                              @"box_progress_护照",
                              @"box_progress_毕业证",
                              @"box_progress_成绩单",
                              @"box_progress_成绩单",
                              @"box_progress_成绩单",
                              @"box_progress_证明",
                              @"box_progress_证明",
                              @"box_progress_录取"
                              ];
    CGFloat _radius=(CGRectGetWidth(backview.frame)-70*_Scale*2-85*_Scale*2)/3.0f;
    CGFloat interval=(CGRectGetHeight(backview.frame)-(50*_Scale+_radius)*3-50*_Scale)/2.0f;
    for (int i=0; i<mustTitleArray.count; i++) {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag=100+i;

       [btn setBackgroundImage:[UIImage imageNamed:normal_img_arr[i]] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:select_img_arr[i]] forState:UIControlStateSelected];
        [backview addSubview:btn];
        [btn addTarget:self action:@selector(subAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame=CGRectMake(70*_Scale+(85*_Scale+_radius)*(i%3), 30*_Scale+(_radius+50*_Scale+interval)*(i/3),_radius,_radius);
        //        btn.backgroundColor=[UIColor redColor];
        [backview addSubview:btn];
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(btn.frame)-10, 30*_Scale+_radius+(_radius+50*_Scale+interval)*(i/3),_radius+20,50*_Scale)];
        label.textAlignment=1;
        [label setAttributedText:[regular createAttributeString:mustTitleArray[i] andFloat:@(2.0)]];
        label.textColor=_define_cailiao_text_color;
        label.font=[regular getFont:11.0f];
        [backview addSubview:label];


    }

    UIImageView *instructionView=[[UIImageView alloc] initWithFrame:CGRectMake(36*_Scale, CGRectGetMaxY(backview.frame), CGRectGetWidth(_scrollView.frame)-72*_Scale, 140*_Scale)];

    instructionView.backgroundColor=[UIColor colorWithRed:252.0f/255.0f green:252.0f/255.0f blue:252.0f/255.0f alpha:1];
    NSArray *titlearr=@[@"各个学校具体申请要求和材料不同，",@"可以到官网获取相关申请信息及表格。"];
    for (int i=0; i<titlearr.count; i++) {
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, 30*_Scale+40*_Scale*i, CGRectGetWidth(instructionView.frame), 40*_Scale)];
        label.textAlignment=1;
        [label setAttributedText:[regular createAttributeString:titlearr[i] andFloat:@(2.0)]];
        label.textColor=_define_blue_color;
        //        label.text=titlearr[i];
        label.font=[regular getFont:11.0f];
        [instructionView addSubview:label];
    }
    [mustView addSubview:instructionView];
    _scrollView.contentSize=CGSizeMake(CGRectGetWidth(_scrollView.frame), CGRectGetMaxY(mustView.frame));
    return mustView;
    
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
    JXLOG(@"titleArr=%@",titleArr);
    for (int i=0; i<titleArr.count; i++) {
        if(i==_index)
        {
            JXLOG(@"%@",data_dict_must);
            NSInteger _obj=0;
            if([[data_dict_must objectForKey:titleArr[i]] integerValue])
            {
                _obj=0;
            }else
            {
                _obj=1;
            }
            [parameters setObject:[NSNumber numberWithInteger:_obj] forKey:titleArr[i]];

        }else
        {
            JXLOG(@"2222%@",titleArr[i]);
            if([((NSString *)titleArr[i])isEqualToString: @"test_report"])
            {
                if([data_dict_must objectForKey:@"test_report"]==nil)
                {
                    [parameters setObject:[NSNumber numberWithInteger:0] forKey:@"test_report"];
                }

            }else
            {
                JXLOG(@"2222%@",[data_dict_must objectForKey:titleArr[i]]);
                [parameters setObject:[data_dict_must objectForKey:titleArr[i]] forKey:titleArr[i]];

            }

        }
    }
    [manager PUT:[[NSString alloc] initWithFormat:@"%@%@",DNS,@"/v1/users/update_apply_documents"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *html = operation.responseString;
        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
        if([[dict objectForKey:@"code"] integerValue]==1)
        {
            [[self.view.window viewWithTag:10000] removeFromSuperview];
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
            if([[data_dict_must objectForKey:titleArr[_index]] integerValue])
            {
                _obj=0;
            }else
            {
                _obj=1;
            }
            [data_dict_must removeObjectForKey:titleArr[_index]];
            [data_dict_must setObject:[NSNumber numberWithInteger:_obj] forKey:titleArr[_index]];

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
- (void)removeImage:(UITapGestureRecognizer *)tap
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];

    [[self.view.window viewWithTag:10000] removeFromSuperview];
}
-(void)subAction:(UIButton *)btn
{
    _alert_num=btn.tag-100;
    if(btn.selected)
    {
        [self submitcailiao:btn];
    }else
    {
#pragma mark-隐藏导航状态栏
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        //    蒙板
        CGFloat __w=[[((NSDictionary *)imageArr[btn.tag-100]) objectForKey:@"w"] floatValue];
        CGFloat __h=[[((NSDictionary *)imageArr[btn.tag-100]) objectForKey:@"h"] floatValue];
        CGFloat _height=__h*(ScreenWidth)/__w;

        UIView *backview=[[UIView alloc] initWithFrame:CGRectZero];
        [self.view.window addSubview:backview];
        [backview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.view.window);
        }];
        backview.backgroundColor=_define_backview_color;
        backview.tag=10000;
        UITapGestureRecognizer *tapges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeImage:)];
        [backview addGestureRecognizer:tapges];

        desImage=[[UIImageView alloc] init];
        [backview addSubview:desImage];
        if(__w==0)
        {
//            desImage.frame=backview.frame;
            [desImage mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(backview);
            }];

        }else
        {
            if(_isPad)
            {
                CGFloat _width=(ScreenHeight-107)*ScreenWidth/__h;
                [desImage mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(6);
                    make.centerX.mas_equalTo(backview);
                    make.width.mas_equalTo(_width);
                    make.height.mas_equalTo(ScreenHeight-107);
                }];
//                desImage.frame=CGRectMake((ScreenWidth-_width)/2.0f, 6, _width ,ScreenHeight-107);

            }else
            {
                [desImage mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.mas_equalTo(backview);
                    make.centerY.mas_equalTo(backview).with.offset(kIPhoneX?(-34-24):0);
                    make.width.mas_equalTo(ScreenWidth);
                    make.height.mas_equalTo(_height);
                }];
//                desImage.frame=CGRectMake(0, (ScreenHeight-_height)/2.0f, ScreenWidth,_height);
            }

        }

        desImage.userInteractionEnabled = YES;
        desImage.image = [UIImage imageNamed:[((NSDictionary *)imageArr[btn.tag-100]) objectForKey:@"imgname"]];

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
    }
}

- (void)viewDidLoad {

    [super viewDidLoad];
    self.view.backgroundColor=_define_backview_color;
    [self prepareData];
    [self UIConfig];
    [self getmustData];


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
