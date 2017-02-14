//
//  new_AcademicRecordsController.m
//  OneBox
//
//  Created by 谢江新 on 15/6/30.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import "new_AcademicRecordsController.h"
#import "collectionSchool.h"
#import "NMRangeSlider.h"
@interface new_AcademicRecordsController ()

@end

@implementation new_AcademicRecordsController
{

    NSInteger _request_num;
    UILabel *leftLabel1;
    UILabel *rightLabel1;
    UILabel *leftLabel2;
    UILabel *rightLabel2;

    long total_students_min;
    long ap_count_max;
    long total_students_max;
    long ap_count_min;



    NSMutableArray *cityArray;
    UIImageView *backviewcity;
    UIScrollView *_scrollview_city;
    UIButton *all_city;
    UIView *upviewcity;
    BOOL _alert_grade;
//    CGFloat firstApp;
    NSMutableArray *stateArr;
    NSMutableArray *cityArr;
    NSInteger _now_tag;
    NSArray *titleArray;
    NSArray *keyArray;
    NSDictionary *data_dict;
    NSInteger userid;
    UIScrollView *_scrollview;
    NSMutableArray *_imgArray;
    NSMutableArray *screen_btnArr;
    NSArray *screen_titleArr;
    NSArray *screen_normalImg;
    NSArray *screen_selectImg;
    BOOL _isfirst_choose;
    NSMutableString *state_id;
    NSMutableString *city_id;
    CGFloat _smallCardWidth;
    CGFloat __y_p;
    NSMutableString *_alertNum;
    UIView *downView;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createScrollView];
    [self prepareData];
    [self requestData];
}
-(void)UIConfig
{

    [self createUpView];
    [self createchooseView];
}
-(void)stateAction:(UIButton *)btn
{
    if([btn.titleLabel.text isEqualToString:@"所有州"])
    {
        [_state setString:@""];
        [state_id setString:@""];
        UIButton *_btn=(UIButton *)[self.view viewWithTag:400];
        [_btn setTitle:@"所在州" forState:UIControlStateNormal];
        UIButton *_btn1=(UIButton *)[self.view viewWithTag:401];
        [_btn1 setTitle:@"所在城市" forState:UIControlStateNormal];
        [_city setString:@""];
        [city_id setString:@""];

    }else
    {
        if(![btn.titleLabel.text isEqualToString:_state]&&![_state isEqualToString:@""])
        {
            UIButton *_btn1=(UIButton *)[self.view viewWithTag:401];
            [_btn1 setTitle:@"所在城市" forState:UIControlStateNormal];
            [_city setString:@""];
            [city_id setString:@""];
        }


//        UIButton *_btn=(UIButton *)[self.view viewWithTag:400];
        NSLog(@"%@",btn.titleLabel.text);
        for (NSDictionary *_dict in stateArr) {
            if([[_dict objectForKey:@"en_name"]isEqualToString:btn.titleLabel.text])
            {
                if([_dict objectForKey:@"id"]!=[NSNull null])
                {
                    [state_id setString:[[NSString alloc] initWithFormat:@"%d",[[_dict objectForKey:@"id"] intValue]]];
                    if([_dict objectForKey:@"cn_name"]!=[NSNull null])
                    {
                        [_state setString:[_dict objectForKey:@"cn_name"]];

                    }else
                    {
                        [_state setString:@""];
                    }

                    break;
                }

            }
        }
        [[self.view viewWithTag:400] removeFromSuperview];

        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(chooseLoc:) forControlEvents:UIControlEventTouchUpInside];

        btn.frame=CGRectMake((CGRectGetWidth(downView.frame)-(18+240*2)*_Scale)/2, (CGRectGetHeight(downView.frame)-46.0f*_Scale)/2.0f, 240*_Scale, 46*_Scale);
        btn.tag=400;
        [btn setBackgroundColor:[UIColor colorWithRed:244.0f/255.0f green:244.0f/255.0f blue:244.0f/255.0f alpha:1]];
        btn.titleLabel.font=[regular getFont:11.0f];
        [btn setTitleColor:_define_blue_color forState:UIControlStateNormal];
        [btn setTitle:_state forState:UIControlStateNormal];
        [downView addSubview:btn];
//        [_btn setTitle:_state forState:UIControlStateNormal];
    }
    [[self.view viewWithTag:1001] removeFromSuperview];
//    ((UIView *)[self.view viewWithTag:200]).hidden=NO;
}
-(void)removestate:(UIGestureRecognizer *)ges
{
    [[self.view viewWithTag:1001] removeFromSuperview];
}
-(void)removecity:(UIGestureRecognizer *)ges
{
    [[self.view viewWithTag:1002] removeFromSuperview];
}
-(void)createChooseStateView
{

    UIImageView *backimg=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    backimg.tag=1001;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removestate:)];
    [backimg addGestureRecognizer:tap];
    backimg.userInteractionEnabled=YES;
    backimg.image=[UIImage imageNamed:@"蒙板"];
    [self.view addSubview:backimg];

//    UIImageView *backview=(UIImageView*)[self.view viewWithTag:100];
    CGFloat _y_p=(ScreenHeight-485*_Scale)*(2.0f/5.0f);
    //    180  310
    UIImageView *backview1=[[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(backimg.frame)-360*_Scale)/2.0f, _y_p, 360*_Scale, 600*_Scale)];
    [backimg addSubview:backview1];
    //    backview1.backgroundColor=[UIColor redColor];
    backview1.userInteractionEnabled=YES;

//    UITapGestureRecognizer *tap1=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backview2Action)];
//    [backview1 addGestureRecognizer:tap1];
    //    backview1.backgroundColor=[UIColor blueColor];
    backview1.tag=201;
//    [backview addSubview:backview1];

    UIView *upview=[[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(backview1.frame), 544*_Scale)];
    upview.backgroundColor=[UIColor colorWithRed:65.0f/255.0f green:176.0f/255.0f blue:211.0f/255.0f alpha:1];
    [backview1 addSubview:upview];

    UIButton *all_state=[UIButton buttonWithType:UIButtonTypeCustom];
    all_state.frame=CGRectMake(0, CGRectGetHeight(backview1.frame)-50*_Scale, CGRectGetWidth(backview1.frame), 50*_Scale);
    all_state.backgroundColor=[UIColor colorWithRed:107.0f/255.0f green:203.0f/255.0f blue:202.0f/255.0f alpha:1];;
    all_state.titleLabel.textAlignment=1;
    [all_state setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    all_state.titleLabel.font=[regular getFont:12.0f];
    [all_state setTitle:@"所有州" forState:UIControlStateNormal];
    [all_state.titleLabel setAttributedText:[regular createAttributeString:@"所有州" andFloat:@(5.0)]];
    [all_state addTarget:self action:@selector(stateAction:) forControlEvents:UIControlEventTouchUpInside];
    [backview1 addSubview:all_state];



    UIScrollView *__scrollview=[[UIScrollView alloc] initWithFrame:CGRectMake(10*_Scale, 30*_Scale, CGRectGetWidth(upview.frame)-20*_Scale, CGRectGetHeight(upview.frame)-60*_Scale)];
    __scrollview.backgroundColor=upview.backgroundColor;
    __scrollview.showsVerticalScrollIndicator=YES;
    __scrollview.contentSize=CGSizeMake(__scrollview.frame.size.width, __scrollview.frame.size.height);
    [upview addSubview:__scrollview];



    //    [[ToolManager sharedManager] createProgress:@"加载中"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[[NSString alloc] initWithFormat:@"%@%@",DNS,@"/v1/us_states"] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSString *html = operation.responseString;
        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];

        if([[dict objectForKey:@"code"] intValue] ==1)
        {
            //数据呈现
            [stateArr removeAllObjects];
            [stateArr setArray:[dict objectForKey:@"data"]];
            //            stateArr=[dict objectForKey:@"data"];

            NSMutableArray *stateArray=[[NSMutableArray alloc] init];
            for (NSDictionary *___dict in stateArr) {
                NSString *en_name=nil;
                NSDictionary *dict=nil;
                if([___dict objectForKey:@"en_name"]!=[NSNull null])
                {

                    en_name=[___dict objectForKey:@"en_name"];


                }else
                {
                    en_name=@"";
                }
                dict=[[NSDictionary alloc] initWithObjectsAndKeys:[___dict objectForKey:@"en_name"],@"name", [___dict objectForKey:@"short_name"],@"short_name",[___dict objectForKey:@"cn_name"],@"cn_name",nil];
                [stateArray addObject:dict];
            }
            __scrollview.contentSize=CGSizeMake(CGRectGetWidth(__scrollview.frame), stateArray.count*42*_Scale);

            for (int i=0; i<stateArray.count; i++) {
                UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame=CGRectMake(20*_Scale,i*42*_Scale,CGRectGetWidth(__scrollview.frame)-40*_Scale,42*_Scale);

                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                btn.titleLabel.font=[regular getFont:11.0f];
                btn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
                [btn addTarget:self action:@selector(stateAction:) forControlEvents:UIControlEventTouchUpInside];
                [btn setTitle:[stateArray[i] objectForKey:@"name"] forState:UIControlStateNormal];
                btn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
                [btn setBackgroundColor:upview.backgroundColor];

                UILabel *label1=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 85*_Scale, CGRectGetHeight(btn.frame))];
                label1.backgroundColor=upview.backgroundColor;
                label1.text=[stateArray[i] objectForKey:@"short_name"];
                label1.textColor=[UIColor whiteColor];
                label1.textAlignment=2;
                label1.font=[regular get_en_Font:12.0f];
                [btn addSubview:label1];


                UILabel *label3=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label1.frame), 0, 22*_Scale, CGRectGetHeight(label1.frame))];
                label3.backgroundColor=upview.backgroundColor;
                [btn addSubview:label3];
//label1.backgroundColor=[UIColor redColor];

                UILabel *label2=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label1.frame)+22*_Scale, 0,CGRectGetWidth(btn.frame)-CGRectGetMaxX(label1.frame)-22*_Scale, CGRectGetHeight(btn.frame))];
                label2.backgroundColor=upview.backgroundColor;
                label2.text=[stateArray[i] objectForKey:@"cn_name"];
                label2.textColor=[UIColor whiteColor];
                label2.textAlignment=0;
                label2.font=[regular getFont:12.0f];
                [btn addSubview:label2];
                [__scrollview addSubview:btn];
                UIView *view=[[UIView alloc] initWithFrame:CGRectMake(-5, CGRectGetHeight(btn.frame)-1*_Scale,CGRectGetWidth(btn.frame)+10 , 1*_Scale)];
                [btn addSubview:view];
                view.backgroundColor=[UIColor colorWithRed:134.0f/255.0f green:210.0f/255.0f blue:219.0f/255.0f alpha:1];
                
            }
        }else
        {
             [[ToolManager sharedManager] alertTitle_Simple:[dict objectForKey:@"message"]];
        }
        //        blockSuccess(dict);
        [[ToolManager sharedManager] removeProgress];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
    }];

}
-(void)deleteAction:(UIButton *)btn
{
    UIView *backview=nil;
    if(btn.tag-10==0)
    {
        backview=[self.view viewWithTag:100];
    }else if(btn.tag-10==1)
    {
        [[self.view viewWithTag:1001] removeFromSuperview];
//        backview=[self.view viewWithTag:201];
//        ((UIView *)[self.view viewWithTag:200]).hidden=NO;
    }else if(btn.tag-10==2)
    {
        [[self.view viewWithTag:1002] removeFromSuperview];
//        backview=[self.view viewWithTag:202];
//        ((UIView *)[self.view viewWithTag:200]).hidden=NO;
    }
    [backview removeFromSuperview];
}
-(void)cityAction:(UIButton *)btn
{
    if([btn.titleLabel.text isEqualToString:@"所有市"])
    {

        [_city setString:@""];
        UIButton *_btn=(UIButton *)[self.view viewWithTag:401];

        [city_id setString:@""];
        [_btn setTitle:@"所在城市" forState:UIControlStateNormal];
    }else
    {

        [_city setString:btn.titleLabel.text];
//        UIButton *_btn=(UIButton *)[self.view viewWithTag:401];
        for (NSDictionary *__dict in cityArr) {
            if(([__dict objectForKey:@"en_name"]!=[NSNull null])&&([__dict objectForKey:@"en_name"]!=nil))
            {
                if([[__dict objectForKey:@"en_name"]isEqualToString:btn.titleLabel.text])
                {
                    [city_id setString:[[NSString alloc] initWithFormat:@"%ld",[[__dict objectForKey:@"id"] longValue]]];
                    if([__dict objectForKey:@"cn_name"]!=[NSNull null])
                    {
                        [_city setString:[__dict objectForKey:@"cn_name"]];
                    }else
                    {
                        [_city setString:@""];
                    }

                    break;
                }
            }


        }
//        [_btn setTitle:_city forState:UIControlStateNormal];
        [[self.view viewWithTag:401] removeFromSuperview];

        //        [((UIButton *)[self.view viewWithTag:401]) setTitle:_city forState:UIControlStateNormal];
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(chooseLoc:) forControlEvents:UIControlEventTouchUpInside];

        btn.frame=CGRectMake((CGRectGetWidth(downView.frame)-(18+240*2)*_Scale)/2+1*(240+18)*_Scale, (CGRectGetHeight(downView.frame)-46.0f*_Scale)/2.0f, 240*_Scale, 46*_Scale);
        btn.tag=401;
        [btn setBackgroundColor:[UIColor colorWithRed:244.0f/255.0f green:244.0f/255.0f blue:244.0f/255.0f alpha:1]];
        btn.titleLabel.font=[regular getFont:11.0f];
        [btn setTitleColor:_define_blue_color forState:UIControlStateNormal];
        [btn setTitle:_city forState:UIControlStateNormal];
        [downView addSubview:btn];

    }

    [[self.view viewWithTag:1002] removeFromSuperview];
//    ((UIView *)[self.view viewWithTag:200]).hidden=NO;
}
-(void)backimgAction
{

}

-(void)createChooseCityView
{

    UIImageView *backimg=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    backimg.tag=1002;
    backimg.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removecity:)];
    [backimg addGestureRecognizer:tap];
    backimg.image=[UIImage imageNamed:@"蒙板"];
    [self.view addSubview:backimg];
    CGFloat _y_p=(ScreenHeight-485*_Scale)*(2.0f/5.0f);
    backviewcity=[[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(backimg.frame)-440*_Scale)/2.0f, _y_p, 440*_Scale, 600*_Scale)];

    backviewcity.userInteractionEnabled=YES;
    backviewcity.tag=202;
    [backimg addSubview:backviewcity];

    upviewcity=[[UIView alloc] initWithFrame:CGRectMake(0, 29*_Scale, CGRectGetWidth(backviewcity.frame), 500*_Scale)];
    upviewcity.backgroundColor=[UIColor colorWithRed:65.0f/255.0f green:176.0f/255.0f blue:211.0f/255.0f alpha:1];
    [backviewcity addSubview:upviewcity];

    all_city=[UIButton buttonWithType:UIButtonTypeCustom];
    all_city.frame=CGRectMake(0, CGRectGetMaxY(upviewcity.frame)+4, CGRectGetWidth(backviewcity.frame), 50*_Scale);
    all_city.backgroundColor=[UIColor colorWithRed:107.0f/255.0f green:203.0f/255.0f blue:202.0f/255.0f alpha:1];
    all_city.titleLabel.textAlignment=1;
    [all_city setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    all_city.titleLabel.font=[regular getFont:12.0f];
    [all_city setTitle:@"所有市" forState:UIControlStateNormal];
    [all_city.titleLabel setAttributedText:[regular createAttributeString:@"所有市" andFloat:@(5.0)]];
    [all_city addTarget:self action:@selector(cityAction:) forControlEvents:UIControlEventTouchUpInside];
    [backviewcity addSubview:all_city];
    all_city.hidden=YES;


    _scrollview_city=[[UIScrollView alloc] initWithFrame:CGRectMake(30*_Scale, 30*_Scale, CGRectGetWidth(upviewcity.frame)-60*_Scale, CGRectGetHeight(upviewcity.frame)-60*_Scale)];
    _scrollview_city.backgroundColor=[UIColor redColor];
    _scrollview_city.contentSize=CGSizeMake(_scrollview_city.frame.size.width,_scrollview_city.frame.size.height);
    _scrollview_city.backgroundColor=upviewcity.backgroundColor;
    _scrollview_city.showsVerticalScrollIndicator=YES;
    [upviewcity addSubview:_scrollview_city];
    NSLog(@"%@",state_id);


    //    [[ToolManager sharedManager] createProgress:@"加载中"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[[NSString alloc] initWithFormat:@"%@%@%@",DNS,@"/v1/us_states/",state_id] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",state_id);

        NSString *html = operation.responseString;
        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];

        if([[dict objectForKey:@"code"] intValue] ==1)
        {
            [cityArr removeAllObjects];
            [cityArr setArray:[dict objectForKey:@"data"]];

            cityArray=[[NSMutableArray alloc] init];
            for (NSDictionary *___dict in cityArr) {
                NSString *en_name=nil;
                NSDictionary *dict=nil;
                if([___dict objectForKey:@"en_name"]==[NSNull null])
                {
                    en_name=@"";
                }else
                {
                    en_name=[___dict objectForKey:@"en_name"];
                }
                if([___dict objectForKey:@"cn_name"]==[NSNull null])
                {
                    dict=[[NSDictionary alloc] initWithObjectsAndKeys:[___dict objectForKey:@"en_name"],@"en_name", @"",@"cn_name",nil];

                }else
                {
                    dict=[[NSDictionary alloc] initWithObjectsAndKeys:[___dict objectForKey:@"en_name"],@"en_name", [___dict objectForKey:@"cn_name"],@"cn_name",nil];
                }


                [cityArray addObject:dict];
            }

            _scrollview_city.contentSize=CGSizeMake(CGRectGetWidth(_scrollview_city.frame), cityArray.count*42*_Scale);
            CGFloat _backheight=0;
            if(cityArray.count>12)
            {
                _backheight= 12*42*_Scale+60*_Scale+54*_Scale;

            }else
            {
                _backheight= cityArray.count*42*_Scale+60*_Scale+54*_Scale;
            }
            [UIView beginAnimations:@"anmationName" context:nil];
            [UIView setAnimationDidStopSelector:@selector(anmationstop)];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
            //设置当前动画的代理
            [UIView setAnimationDelegate:self];
            backviewcity.frame=CGRectMake(CGRectGetMinX(backviewcity.frame), (ScreenHeight-_backheight)/2.0f, CGRectGetWidth(backviewcity.frame), _backheight);
            upviewcity.frame=CGRectMake(CGRectGetMinX(upviewcity.frame), 0, CGRectGetWidth(upviewcity.frame), _backheight-54*_Scale);
            _scrollview_city.frame=CGRectMake(30*_Scale, 30*_Scale, CGRectGetWidth(upviewcity.frame)-60*_Scale, CGRectGetHeight(upviewcity.frame)-60*_Scale);

            [UIView commitAnimations];


        }else
        {
             [[ToolManager sharedManager] alertTitle_Simple:[dict objectForKey:@"message"]];
        }        //        blockSuccess(dict);
        [[ToolManager sharedManager] removeProgress];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
    }];
    
}
-(void)anmationstop
{
    all_city.frame=CGRectMake(0, CGRectGetHeight(backviewcity.frame)-50*_Scale, CGRectGetWidth(backviewcity.frame), 50*_Scale);
    all_city.hidden=NO;

    CGFloat _width=(CGRectGetWidth(_scrollview_city.frame)-22*_Scale)/2.0f;
    for (int i=0; i<cityArray.count; i++) {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(0,i*42*_Scale,CGRectGetWidth(_scrollview_city.frame),42*_Scale);
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font=[regular get_en_Font:11.0f];
        btn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
        btn.titleLabel.textAlignment=0;
        [btn addTarget:self action:@selector(cityAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:[cityArray[i] objectForKey:@"en_name"] forState:UIControlStateNormal];
        [btn setBackgroundColor:upviewcity.backgroundColor];
        [_scrollview_city addSubview:btn];
        UILabel *label1=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, _width, CGRectGetHeight(btn.frame))];
        //                label1.backgroundColor=upviewcity.backgroundColor;
        label1.backgroundColor=upviewcity.backgroundColor;
        //                label1.backgroundColor=[UIColor redColor];
        //                label1.text=[[NSString alloc] initWithFormat:@"%@",[stateArray[i] objectForKey:@"name"]];
        [label1 setAttributedText:[regular createAttributeString:[[NSString alloc] initWithFormat:@"%@",[cityArray[i] objectForKey:@"en_name"]] andFloat:@(1.0)]];
        label1.textColor=[UIColor whiteColor];
        label1.textAlignment=2;
        label1.font=[regular get_en_Font:12.0f];
        [btn addSubview:label1];
        UILabel *label3=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label1.frame), 0, 22*_Scale, CGRectGetHeight(label1.frame))];
        label3.backgroundColor=upviewcity.backgroundColor;

        [btn addSubview:label3];

        UILabel *label2=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label1.frame)+22*_Scale, 0, _width, CGRectGetHeight(btn.frame))];
        label2.backgroundColor=upviewcity.backgroundColor;

        [label2 setAttributedText:[regular createAttributeString:[[NSString alloc] initWithFormat:@"%@",[cityArray[i] objectForKey:@"cn_name"]] andFloat:@(1.0)]];
        label2.textColor=[UIColor whiteColor];
        label2.textAlignment=0;
        label2.font=[regular getFont:12.0f];
        //                 label2.backgroundColor=[UIColor redColor];
        [btn addSubview:label2];
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(-5, CGRectGetHeight(btn.frame)-1*_Scale,CGRectGetWidth(btn.frame)+10 , 1*_Scale)];
        [btn addSubview:view];
        view.backgroundColor=[UIColor colorWithRed:134.0f/255.0f green:210.0f/255.0f blue:219.0f/255.0f alpha:1];
    }
    
}


-(void)chooseLoc:(UIButton *)btn
{

    if(btn.tag-400==0)
    {
        //        所在州
        [self createChooseStateView];
//        UIView *backView=[self.view viewWithTag:200];
//        backView.hidden=YES;

    }else if(btn.tag-400==1)
    {
        //        所在城市
        if([_state isEqualToString:@""])
        {
            [[ToolManager sharedManager] alertTitle_Simple:@"请先选择州"];
        }else
        {
            [self createChooseCityView];
//            UIView *backView=[self.view viewWithTag:200];
//            backView.hidden=YES;
        }
        
    }
}




-(void)createchooseView
{

    screen_btnArr=[[NSMutableArray alloc] init];
//    [self createBackView_min];
    UIImageView *_imageview=[[ToolManager sharedManager]createTitleView:@"选 校 倾 向" WithRect:CGRectMake(28*_Scale, __y_p+46*_Scale, CGRectGetWidth(_scrollview.frame)-28*_Scale*2, 60*_Scale) WithImg:@"box_choose_提交" WithtitleColor:[UIColor whiteColor] WithTextAlignment:1 WithFontName:(kIOSVersions>=9.0? @"":@"Helvetica Neue" ) WithFont:15];
    __y_p=CGRectGetMaxY(_imageview.frame);
    [_scrollview addSubview:_imageview];

    UIView *view=[self createupView];
    UIImageView *view3=[self createfanweiView1:CGRectGetMaxY(view.frame)];
    [self createdownView:CGRectGetMaxY(view3.frame)];

}
-(UIView *)dingbuView:(CGFloat )_y_p
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(28*_Scale, _y_p-1*_Scale, CGRectGetWidth(_scrollview.frame)-28*_Scale*2, 3*_Scale)];
    view.backgroundColor=[UIColor whiteColor];
    UIView *view1=[[UIView alloc] initWithFrame:CGRectMake(14*_Scale, 1*_Scale, CGRectGetWidth(view.frame)-28*_Scale, 1*_Scale)];
    [view addSubview:view1];
    view1.backgroundColor=[UIColor colorWithRed:220.0f/255.0f green:220.0f/255.0f blue:220.0f/255.0f alpha:1];
    return view;
}
-(UIImageView *)createfanweiView1:(CGFloat )maxy
{

    UIView *dingbu=[self dingbuView:maxy];
    [_scrollview addSubview:dingbu];

    UIImageView *_downview=[[UIImageView alloc] initWithFrame:CGRectMake(28*_Scale, maxy+1*_Scale, CGRectGetWidth(_scrollview.frame)-28*_Scale*2, 119*_Scale)];

    //    [_downview addGestureRecognizer:_tap];
    _downview.userInteractionEnabled=YES;
    [_scrollview addSubview:_downview];
    _downview.backgroundColor=[UIColor whiteColor];


    NMRangeSlider *slider = [[NMRangeSlider alloc] initWithFrame:CGRectMake(30*_Scale, ((CGRectGetHeight(_downview.frame)-25.)/2.0f)-15*_Scale, CGRectGetWidth(_downview.frame)-60*_Scale, 25.)];
    slider.minimumValue=ap_count_min;
    slider.maximumValue=ap_count_max;
    slider.lowerValue=ap_count_min;
    slider.upperValue=ap_count_max;
    [_downview addSubview:slider];
    slider.tag=5001;
    [slider addTarget:self action:@selector(valueChangedForDoubleSlider:) forControlEvents:UIControlEventValueChanged];
    //        [self valueChangedForDoubleSlider:slider];
    UILabel *downlabel=[[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(slider.frame)-CGRectGetHeight(slider.frame)/2.0f, CGRectGetWidth(_downview.frame), CGRectGetHeight(_downview.frame)-CGRectGetMaxY(slider.frame)+CGRectGetHeight(slider.frame)/2.0f)];
    [_downview addSubview:downlabel];

    downlabel.textAlignment=1;
    downlabel.font=[regular getFont:11.0f];
    UITapGestureRecognizer *_tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fangantap)];
    [downlabel addGestureRecognizer:_tap];
    //        downlabel.userInteractionEnabled=YES;
    NSString *downstr=@"AP 课程数";
    downlabel.textColor=[UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1];
    downlabel.text=downstr;

    long __min=ap_count_min;
    long __max=ap_count_max;
    UILabel *_left=leftLabel2;
    UILabel *_right=rightLabel2;
    CGFloat _qishi=(CGRectGetMinX(slider.frame)+CGRectGetHeight(slider.frame)/2.0f);

    for (int j=0; j<2; j++) {
        long _str=j==0?__min:__max;
        UILabel *label=j==0?_left:_right;
        //            label.backgroundColor=[UIColor redColor];
        label.text=[[NSString alloc] initWithFormat:@"%ld",_str];
        label.frame=CGRectMake(_qishi+(CGRectGetWidth(_downview.frame)-2*_qishi-80*_Scale)*j,CGRectGetMinY(downlabel.frame), 80*_Scale, CGRectGetHeight(downlabel.frame));


        if(j==0)
        {
            label.textAlignment=0;
        }else
        {
            label.textAlignment=2;
        }
        label.font=[regular get_en_Font:12.0f];
        label.textColor=_define_blue_color;
        [_downview addSubview:label];
    }
    //    }
    return _downview;
}
-(UIView *)createdownView:(CGFloat )_y_p
{
    UIView *dingbu=[self dingbuView:_y_p];
    [_scrollview addSubview:dingbu];
//    UIView *backview=[self.view viewWithTag:200];
    downView=[[UIView alloc] initWithFrame:CGRectMake(28*_Scale, _y_p+1*_Scale, CGRectGetWidth(_scrollview.frame)-28*_Scale*2, 100*_Scale)];
    downView.backgroundColor=[UIColor whiteColor];
    [_scrollview addSubview:downView];


    for (int i=0; i<2; i++) {

        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];

        [btn addTarget:self action:@selector(chooseLoc:) forControlEvents:UIControlEventTouchUpInside];

        btn.frame=CGRectMake((CGRectGetWidth(downView.frame)-(18+240*2)*_Scale)/2+i*(240+18)*_Scale, (CGRectGetHeight(downView.frame)-46.0f*_Scale)/2.0f, 240*_Scale, 46*_Scale);
        btn.tag=400+i;
        [btn setBackgroundColor:[UIColor colorWithRed:244.0f/255.0f green:244.0f/255.0f blue:244.0f/255.0f alpha:1]];

        NSString *title=nil;
        if(i==0)
        {
            if([_state isEqualToString:@""])
            {
                title=@"所在州";
            }else
            {
                title=_state;
            }
        }else
        {
            if([_city isEqualToString:@""])
            {
                title=@"所在城市";
            }else
            {
                title=_city;
            }

        }

        btn.titleLabel.font=[regular getFont:11.0f];
        [btn setTitleColor:_define_blue_color forState:UIControlStateNormal];
        [btn setTitle:title forState:UIControlStateNormal];
        [downView addSubview:btn];
    }


    UIButton *subImg=[UIButton buttonWithType:UIButtonTypeCustom];

    //    UIImageView *backview=(UIImageView *)[self.view viewWithTag:200];
    subImg.frame=CGRectMake(CGRectGetMinX(downView.frame), CGRectGetMaxY(downView.frame)+1*_Scale, CGRectGetWidth(downView.frame), 60*_Scale);
    subImg.backgroundColor=[UIColor colorWithRed:107.0f/255.0f green:203.0f/255.0f blue:202.0f/255.0f alpha:1];;
    [subImg setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [subImg setTitle:@"筛选" forState:UIControlStateNormal];
    [subImg.titleLabel setAttributedText:[regular createAttributeString:@"筛选" andFloat:@(7.0)]];
    subImg.titleLabel.font=[regular getFont:14.0f];
    [subImg addTarget:self action:@selector(subAction:) forControlEvents:UIControlEventTouchUpInside];

    [_scrollview addSubview:subImg];

    _scrollview.contentSize=CGSizeMake(CGRectGetWidth(_scrollview.frame), CGRectGetMaxY(subImg.frame)+100*_Scale);


    return downView;
}
-(NSDictionary *)getparameters
{

    NSMutableDictionary *parameters=[[NSMutableDictionary alloc] init];


    NSLog(@"%@",data_dict);
    for (int i=0;i<keyArray.count ; i++) {
        UILabel *label=(UILabel*)[self.view viewWithTag:i+1];
        if([_alertNum isEqualToString:@""])
        {
            if([label.text isEqualToString:@""])
            {
                [parameters setValue:[data_dict objectForKey:keyArray[i]] forKey:keyArray[i]];
            }else
            {
                id res=nil;
                CGFloat grade=[label.text floatValue];
                res=[NSNumber numberWithFloat:grade];
                [parameters setValue:res forKey:keyArray[i]];
            }
        }else
        {
            if(_now_tag-1==i)
            {
                [parameters setValue:[NSNumber numberWithFloat:[_alertNum floatValue]] forKey:keyArray[i]];
                [_alertNum setString:@""];
            }else
            {

                if([label.text isEqualToString:@""])
                {
                    [parameters setValue:[data_dict objectForKey:keyArray[i]] forKey:keyArray[i]];
                }else
                {
                    id res=nil;
                    CGFloat grade=[label.text floatValue];
                    res=[NSNumber numberWithFloat:grade];
                    [parameters setValue:res forKey:keyArray[i]];
                }

            }


        }

    }

    NSMutableString *key1=[[NSMutableString alloc] init];
    NSMutableString *key2=[[NSMutableString alloc] init];
    NSMutableString *key3=[[NSMutableString alloc] init];
    for (int i=0; i<screen_titleArr.count; i++) {
        for (int j=0; j<((NSArray *)screen_titleArr[i]).count; j++) {
            UIButton *btn=(UIButton *)[self.view viewWithTag:500+10*i+j];
//            混校类型
            if(i==0)
            {
                if(j<3)
                {
                    NSString *key=nil;
                    if(btn.selected)
                    {
                        key=@"1";

                    }else
                    {
                        key=@"0";
                    }
                    if(j==0)
                    {
                        [key1 setString:key];
                    }else
                    {
                        [key1 appendString:@","];
                        [key1 appendString:key];
                        
                    }
                }else
                {
                    NSString *key=nil;
                    if(btn.selected)
                    {
                        key=@"1";

                    }else
                    {
                        key=@"0";
                    }
                    if(j==3)
                    {
                        [parameters setValue:key forKey:@"isesl"];


                    }

                }
            }else if(i==1)
            {
                if(j<2)
                {

                    NSString *key=nil;
                    if(btn.selected)
                    {
                        if(j==0)
                        {
                            key=@"day";
                        }else
                        {
                            key=@"boarding";
                        }

                    }
                    if(j==0)
                    {
                        if(key!=nil)
                        {
                            [key2 setString:key];
                        }

                    }else
                    {
                        if(key!=nil)
                        {
                            if([key2 isEqualToString:@""])
                            {
                                [key2 appendString:key];

                            }else
                            {
                                [key2 appendString:@","];
                                [key2 appendString:key];

                            }


                        }


                    }


                }else
                {
                    NSString *key=nil;
                    if(btn.selected)
                    {
                        key=@"1";

                    }else
                    {
                        key=@"0";
                    }
                    if(j==2)
                    {
                        [key3 setString:key];
                    }else
                    {
                        [key3 appendString:@","];
                        [key3 appendString:key];

                    }

                }
            }

        }
    }
    [parameters setValue:key1 forKey:@"student_sex_limit"];
    [parameters setValue:key2 forKey:@"boarding_day"];
    [parameters setValue:key3 forKey:@"apply_grade"];
//    apply_grade
//    boarding_day
    NSUserDefaults *dict=[NSUserDefaults standardUserDefaults];
    NSString *_token=nil;
    if([dict objectForKey:@"token"]==nil)
    {
        _token=@"";
    }else
    {
        _token=[dict objectForKey:@"token"];
    }
    [parameters setValue:_token forKey:@"token"];

    if(![city_id isEqualToString:@"0"])
    {
//        if(![city_id isEqualToString:@""])
//        {
            [parameters setValue:city_id forKey:@"trend_us_city_id"];
//        }
    }

    if(![state_id isEqualToString:@"0"])
    {
//        if(![state_id isEqualToString:@""])
//        {
            [parameters setValue:state_id forKey:@"trend_us_state_id"];
//        }
    }

    [parameters setObject:[[NSString alloc] initWithFormat:@"%@,%@",leftLabel2.text,rightLabel2.text] forKey:@"ap_count"];
    [parameters setObject:[[NSString alloc] initWithFormat:@"%@,%@",leftLabel1.text,rightLabel1.text] forKey:@"total_students"];

    return parameters;


}
-(NSDictionary *)getparameters1
{

    NSMutableDictionary *parameters=[[NSMutableDictionary alloc] init];


    NSLog(@"%@",data_dict);
    for (int i=0;i<keyArray.count ; i++) {
        UILabel *label=(UILabel*)[self.view viewWithTag:i+1];
        if([_alertNum isEqualToString:@""])
        {
            if([label.text isEqualToString:@""])
            {
                [parameters setValue:[data_dict objectForKey:keyArray[i]] forKey:keyArray[i]];
            }else
            {
                id res=nil;
                CGFloat grade=[label.text floatValue];
                res=[NSNumber numberWithFloat:grade];
                [parameters setValue:res forKey:keyArray[i]];
            }
        }else
        {
            if(_now_tag-1==i)
            {
                [parameters setValue:[NSNumber numberWithFloat:[_alertNum floatValue]] forKey:keyArray[i]];
                [_alertNum setString:@""];
            }else
            {

                if([label.text isEqualToString:@""])
                {
                    [parameters setValue:[data_dict objectForKey:keyArray[i]] forKey:keyArray[i]];
                }else
                {
                    id res=nil;
                    CGFloat grade=[label.text floatValue];
                    res=[NSNumber numberWithFloat:grade];
                    [parameters setValue:res forKey:keyArray[i]];
                }

            }


        }

    }



    NSMutableArray *key1=[[NSMutableArray alloc] init];
    NSMutableArray *key2=[[NSMutableArray alloc] init];
    NSMutableArray *key3=[[NSMutableArray alloc] init];
    for (int i=0; i<screen_titleArr.count; i++) {
        for (int j=0; j<((NSArray *)screen_titleArr[i]).count; j++) {
            UIButton *btn=(UIButton *)[self.view viewWithTag:500+10*i+j];
            //            混校类型
            if(i==0)
            {
                if(j<3)
                {
                    NSString *key=nil;
                    if(j==0&&btn.selected)
                    {
                        key=@"2";
                        [key1 addObject:key];
                    }else if(j==1&&btn.selected)
                    {
                        key=@"0";
                        [key1 addObject:key];
                    }else if(j==1&&btn.selected)
                    {
                        key=@"1";
                        [key1 addObject:key];
                    }

                }else
                {
                    NSString *key=nil;
                    if(j==3&&btn.selected)
                    {
                        key=@"1";
                        [parameters setValue:key forKey:@"isesl"];


                    }

                }
            }else if(i==1)
            {
                if(j<2)
                {

                    NSString *key=nil;
                    if(j==0&&btn.selected)
                    {
                        key=@"day";
                        [key2 addObject:key];
                    }else if(j==1&&btn.selected)
                    {
                        key=@"boarding";
                        [key2 addObject:key];
                    }


                }else
                {
                    NSString *key=nil;
                    if(j==2&&btn.selected)
                    {
                        key=@"senior";
                        [key3 addObject:key];
                    }else if(j==3&&btn.selected)
                    {
                        key=@"junior";
                        [key3 addObject:key];
                    }


                }
            }

        }
    }
    if(key1.count>0)
    {
        [parameters setValue:key1 forKey:@"student_sex_limit"];
    }
    if(key2.count>0)
    {
        [parameters setValue:key2 forKey:@"boarding_day"];
    }
    if(key3.count>0)
    {
        [parameters setValue:key2 forKey:@"branch_type"];
    }

    //    apply_grade
    //    boarding_day
    NSUserDefaults *dict=[NSUserDefaults standardUserDefaults];
    NSString *_token=nil;
    if([dict objectForKey:@"token"]==nil)
    {
        _token=@"";
    }else
    {
        _token=[dict objectForKey:@"token"];
    }
    [parameters setValue:_token forKey:@"token"];
    NSLog(@"%@  %@",state_id,city_id);
    if(![city_id isEqualToString:@"0"])
    {
        if(![city_id isEqualToString:@""])
        {
             [parameters setValue:city_id forKey:@"us_city_id"];
        }
    }

    if(![state_id isEqualToString:@"0"])
    {
        if(![state_id isEqualToString:@""])
        {
            [parameters setValue:state_id forKey:@"us_state_id"];
        }
    }
    

    [parameters setValue:@"1" forKey:@"comment"];

    [parameters setObject:[[NSString alloc] initWithFormat:@"%@,%@",leftLabel2.text,rightLabel2.text] forKey:@"ap_count"];
    [parameters setObject:[[NSString alloc] initWithFormat:@"%@,%@",leftLabel1.text,rightLabel1.text] forKey:@"total_students"];

    return parameters;

}
#pragma mark-提交
-(void)subAction:(UIButton *)btn
{
    //    [[ToolManager sharedManager] createProgress:@"提交中"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters=[self getparameters];
    NSDictionary *parameters1=[self getparameters1];

    [manager PUT:[[NSString alloc] initWithFormat:@"%@%@%ld",DNS,@"/v1/students/",(long)userid] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *html = operation.responseString;
        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
        if([[dict objectForKey:@"code"] integerValue]==1)
        {

            if(_alert_grade)
            {
                if(_now_tag==1)
                {
                    ((UILabel *)[self.view viewWithTag:_now_tag]).text=[[NSString alloc] initWithFormat:@"%.1f",[((UITextField *)[self.view viewWithTag:60]).text floatValue]];

                }else
                {
                    ((UILabel *)[self.view viewWithTag:_now_tag]).text=[[NSString alloc] initWithFormat:@"%ld",(long)[((UITextField *)[self.view viewWithTag:60]).text integerValue]];
                }

                [[self.view viewWithTag:50] removeFromSuperview];
                
                ((UIImageView *)[self.view viewWithTag:_now_tag+100]).hidden=YES;
                _alert_grade=NO;
            }else
            {
                collectionSchool *col=[[collectionSchool alloc] init];
                col.dict=[[NSDictionary alloc] initWithObjectsAndKeys:@"recommend",@"type",parameters1,@"dict",nil];
                [self.navigationController pushViewController:col animated:YES];
            }

        }else
        {
             [[ToolManager sharedManager] alertTitle_Simple:[dict objectForKey:@"message"]];
        }

        [[ToolManager sharedManager] removeProgress];

    } failure:
     ^(AFHTTPRequestOperation *operation, NSError *error) {
         [[ToolManager sharedManager] removeProgress];
     }];


}

-(void)screenAction:(UIButton *)btn
{

    if(btn.selected)
    {
        btn.selected=NO;
    }else
    {
        btn.selected=YES;
    }
    
}
-(void)valueChangedForDoubleSlider:(NMRangeSlider *)slider
{
    NSLog(@"up=%f,down=%f",slider.upperValue,slider.lowerValue);
    if(slider.tag==5000)
    {

        leftLabel1.text=[[NSString alloc] initWithFormat:@"%.f",slider.lowerValue];
        rightLabel1.text=[[NSString alloc] initWithFormat:@"%.f",slider.upperValue];

    }else
    {
        leftLabel2.text=[[NSString alloc] initWithFormat:@"%.f",slider.lowerValue];
        rightLabel2.text=[[NSString alloc] initWithFormat:@"%.f",slider.upperValue];
        
    }
}
-(void)fangantap
{

}

-(UIView *)createupView
{
//    UIView *backview=[self.view viewWithTag:200];
    UIView *upview=[[UIView alloc] initWithFrame:CGRectMake(28*_Scale, __y_p, CGRectGetWidth(_scrollview.frame)-28*_Scale*2, 150*_Scale)];
    upview.backgroundColor=[UIColor whiteColor];
    [_scrollview addSubview:upview];

    UIView *dingbu1=[self dingbuView:CGRectGetMaxY(upview.frame)];
    [_scrollview addSubview:dingbu1];

    UIView *middleView1=[[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(upview.frame), CGRectGetMaxY(upview.frame)+1*_Scale, CGRectGetWidth(upview.frame), 119*_Scale)];
    middleView1.backgroundColor=[UIColor whiteColor];
    [_scrollview addSubview:middleView1];


    UIView *dingbu2=[self dingbuView:CGRectGetMaxY(middleView1.frame)];
    [_scrollview addSubview:dingbu2];

    UIView *middleView=[[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(middleView1.frame), CGRectGetMaxY(middleView1.frame)+1*_Scale, CGRectGetWidth(middleView1.frame), 150*_Scale)];
    middleView.backgroundColor=[UIColor whiteColor];
    [_scrollview addSubview:middleView];


    NMRangeSlider *slider = [[NMRangeSlider alloc] initWithFrame:CGRectMake(30*_Scale, ((CGRectGetHeight(middleView1.frame)-25.0)/2.0f)-15*_Scale, CGRectGetWidth(middleView1.frame)-60*_Scale, 25.) ];
    [middleView1 addSubview:slider];
    slider.tag=5000;
    slider.minimumValue=total_students_min;
    slider.maximumValue=total_students_max;
    slider.lowerValue=total_students_min;
    slider.upperValue=total_students_max;
    [slider addTarget:self action:@selector(valueChangedForDoubleSlider:) forControlEvents:UIControlEventValueChanged];
    [self valueChangedForDoubleSlider:slider];
    UILabel *downlabel=[[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(slider.frame)-CGRectGetHeight(slider.frame)/2.0f, CGRectGetWidth(middleView1.frame), CGRectGetHeight(middleView1.frame)-CGRectGetMaxY(slider.frame)+CGRectGetHeight(slider.frame)/2.0f)];
    [middleView1 addSubview:downlabel];

    downlabel.textAlignment=1;
    downlabel.font=[regular getFont:11.0f];
    UITapGestureRecognizer *_tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fangantap)];
    [downlabel addGestureRecognizer:_tap];
    NSString *downstr=@"学生数";
    downlabel.textColor=[UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1];
    downlabel.text=downstr;

    long __min=total_students_min;
    long __max=total_students_max;
    UILabel *_left=leftLabel1;
    UILabel *_right=rightLabel1;
    CGFloat _qishi=(CGRectGetMinX(slider.frame)+CGRectGetHeight(slider.frame)/2.0f);

    for (int j=0; j<2; j++) {
        long _str=j==0?__min:__max;
        UILabel *label=j==0?_left:_right;
        label.text=[[NSString alloc] initWithFormat:@"%ld",_str];
//        

        label.frame=CGRectMake(_qishi+(CGRectGetWidth(middleView1.frame)-2*_qishi-80*_Scale)*j,CGRectGetMinY(downlabel.frame), 80*_Scale, CGRectGetHeight(downlabel.frame));
        if(j==0)
        {
            label.textAlignment=0;
        }else
        {
            label.textAlignment=2;
        }
        label.font=[regular get_en_Font:12.0f];
        label.textColor=_define_blue_color;
        [middleView1 addSubview:label];
    }


    NSArray *array=@[@[_ismixed,_isfemale,_ismale,_isESL],@[_isday,_isboardind,_issenior,_isjunior]];
    CGFloat jiange=0;
    CGFloat _jiange1=0;
    CGFloat _jiange2=0;
    CGFloat _jiange3=0;
    CGFloat _radius=60*_Scale;
    CGFloat _y_p=0;
    CGFloat _x_p=0;
    for (int i=0; i<screen_titleArr.count; i++) {

            _jiange2=55*_Scale;
            _jiange3=80*_Scale;
            _jiange1=(CGRectGetWidth(upview.frame)-_radius*4-_jiange3-_jiange2*2)/2.0f;
            _y_p=28*_Scale;
            _x_p=_jiange1;

        for (int j=0; j<((NSArray *)screen_titleArr[i]).count; j++) {



            if((i==0&&j==2)||(i==1&&j==1))
            {
                jiange=_jiange3;
            }else
            {
                jiange=_jiange2;
            }

            UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame=CGRectMake(_x_p, _y_p, _radius, _radius);

            if([array[i][j] isEqualToString:@"1"])
            {
                btn.selected=YES;
            }else
            {
                btn.selected=NO;
            }
            [btn setBackgroundImage:[UIImage imageNamed:((NSArray *)screen_normalImg[i])[j]] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:((NSArray *)screen_selectImg[i])[j]] forState:UIControlStateSelected];

            btn.tag=500+i*10+j;
            [btn addTarget:self  action:@selector(screenAction:) forControlEvents:UIControlEventTouchUpInside];
            [screen_btnArr addObject:btn];
            CGFloat __y_p1=i==0?(CGRectGetHeight(upview.frame)-CGRectGetMaxY(btn.frame)-20*_Scale):(CGRectGetHeight(middleView.frame)-CGRectGetMaxY(btn.frame)-10*_Scale);

            UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(btn.frame)-5*_Scale, CGRectGetMaxY(btn.frame), CGRectGetWidth(btn.frame)+10*_Scale, __y_p1)];
            label.text=((NSArray *)screen_titleArr[i])[j];
            label.textColor=[UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1];
            label.textAlignment=1;
            label.font=[regular getFont:12.0f];
            if(i==0)
            {
                [upview addSubview:btn];
                [upview addSubview:label];
            }else
            {
                [middleView addSubview:btn];
                [middleView addSubview:label];
            }

            if(i==0&&j==2)
            {
                UIView *view=[[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btn.frame)+jiange/2.0f, 10*_Scale, 1*_Scale, CGRectGetHeight(upview.frame)-20*_Scale)];
                view.backgroundColor=_define_backview_color;
                [upview addSubview:view];



            }else if(i==1&&j==1)
            {
                UIView *view=[[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btn.frame)+jiange/2.0f, 10*_Scale, 1*_Scale, CGRectGetHeight(middleView.frame)-20*_Scale)];
                view.backgroundColor=_define_backview_color;
                [middleView addSubview:view];
                
            }

            _x_p+=_radius+jiange;

        }
    }
    
    if(!_isfirst_choose)
    {
        [self setBtnState];
        
    }
    return middleView;
}
#pragma mark-设置btn的状态
-(void)setBtnState
{
    //screen_btnArr
    NSArray *array=@[_ismixed,_isfemale,_ismale,_isESL,_isday,_isboardind,_issenior,_isjunior];
    for (int i=0; i<array.count; i++) {
        NSString *value=array[i];
        UIButton *btn=screen_btnArr[i];
        if([value isEqualToString:@"1"])
        {
            btn.selected=YES;
        }else
        {
            btn.selected=NO;
        }
    }
    
}


-(void)createBackView_min
{

//    CGFloat _y_p=(ScreenHeight-485*_Scale)*(2.0f/5.0f);
//    CGRect rect=CGRectMake(70*_Scale, _y_p,ScreenWidth-70*_Scale*2 , 485*_Scale);
//    UIView *backview1=[[UIView alloc] initWithFrame:rect];
//    backview1.tag=200;
//    //    backview1.backgroundColor=[UIColor redColor];
//    UIView *view=[self.view viewWithTag:100];
//    [view addSubview:backview1];
    //    [backviewArray addObject:backview1];
    
}

-(void)dismiss:(UIGestureRecognizer *)ges
{
    [[self.view viewWithTag:50] removeFromSuperview];
}
-(void)submitAction:(UIButton *)btn
{
//    [self subAction:btn];
    UITextField *ttt111=(UITextField *)[self.view viewWithTag:60];
    NSInteger _num=[ttt111.text integerValue];
    NSString *_num_str=[[NSString alloc] initWithFormat:@"%ld",(long)_num];
//    ([().text integerValue]).
    if(_num_str.length<=4)
    {
        if(_now_tag==1)
        {
            [_alertNum setString:[[NSString alloc] initWithFormat:@"%.1f",[((UITextField *)[self.view viewWithTag:60]).text floatValue]]];
            //        ((UILabel *)[self.view viewWithTag:_now_tag]).text=[[NSString alloc] initWithFormat:@"%.1f",[((UITextField *)[self.view viewWithTag:60]).text floatValue]];

        }else
        {
            [_alertNum setString:[[NSString alloc] initWithFormat:@"%ld",(long)[((UITextField *)[self.view viewWithTag:60]).text integerValue]]];
            //        ((UILabel *)[self.view viewWithTag:_now_tag]).text=[[NSString alloc] initWithFormat:@"%d",[((UITextField *)[self.view viewWithTag:60]).text integerValue]];
        }
        
        _alert_grade=YES;
        [self subAction:btn];

    }else
    {
        [[ToolManager sharedManager] alertTitle_Simple:@"超出四位数，请重新输入"];
    }


}
-(void)addAction:(UIGestureRecognizer *)ges
{
    _now_tag=ges.view.tag;
    UIImageView *imageview=[[UIImageView alloc] init];
    imageview.frame=CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    imageview.image=[UIImage imageNamed:@"蒙板"];
    imageview.tag=50;
    imageview.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss:)];
    [imageview addGestureRecognizer:tap];
    [self.view addSubview:imageview];
    UIView *card=[[UIView alloc] initWithFrame:CGRectMake((ScreenWidth-240*_Scale)/2.0f,ScreenHeight*1.0f/3.0f , 240*_Scale, 140*_Scale)];
    card.backgroundColor=[UIColor clearColor];
    [imageview addSubview:card];
    UIImageView *img=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(card.frame), CGRectGetHeight(card.frame))];
    img.userInteractionEnabled=YES;

    img.image=[UIImage imageNamed:@"box_choose_sat"];
    [card addSubview:img];
    UILabel *___title=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(img.frame), 80*_Scale)];
    ___title.text=titleArray[ges.view.tag-1];
    ___title.textColor=[UIColor colorWithRed:205.0f/255.0f green:205.0f/255.0f blue:205.0f/255.0f alpha:1];
    ___title.textAlignment=1;
    ___title.font=[regular get_en_Font:17.0f];
    [img addSubview:___title];


    UIButton *submit=[UIButton buttonWithType:UIButtonTypeCustom];
    submit.frame=CGRectMake((ScreenWidth-154*_Scale)/2.0f, CGRectGetMaxY(card.frame)+26*_Scale, 154*_Scale, 52*_Scale);

    [submit addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
    [submit setBackgroundImage:[UIImage imageNamed:@"box_choose_提交"] forState:UIControlStateNormal];
    [submit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submit setTitle:@"提交" forState:UIControlStateNormal];
    submit.titleLabel.font=[regular getFont:15.0f];
    [submit.titleLabel setAttributedText:[regular createAttributeString:@"提交" andFloat:@(4.0)]];
    submit.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
//    11 190 217
    [imageview addSubview:submit];

    UITextField *textfield=[[UITextField alloc] initWithFrame:CGRectMake(10*_Scale, CGRectGetMaxY(___title.frame), CGRectGetWidth(img.frame)-10*_Scale*2, CGRectGetHeight(img.frame)-CGRectGetMaxY(___title.frame))];
//    textfield.backgroundColor=[UIColor redColor];
    textfield.textColor=_define_blue_color;
    textfield.textAlignment=1;
    textfield.tag=60;
    textfield.font=[regular get_en_Font:18.0f];
    textfield.keyboardType=UIKeyboardTypeNumbersAndPunctuation;
//    textfield.backgroundColor=[UIColor redColor];
    textfield.text=((UILabel *)ges.view).text;
    [img addSubview:textfield];

//    UIView *dibu=[[UIView alloc] initWithFrame:CGRectMake(30*_Scale, CGRectGetHeight(img.frame)-10*_Scale, CGRectGetWidth(img.frame)-60*_Scale, 1*_Scale)];
//    [img addSubview:dibu];
//    dibu.backgroundColor=[UIColor colorWithRed:193.0f/255.0f green:193.0f/255.0f blue:193.0f/255.0f alpha:1];


}
-(void)createUpView
{
//    y_p 28 20 20 44
//    38 8 8 38
//    h 64 1 61


    for (int i=0; i<titleArray.count; i++) {
        UIView *card=[[UIView alloc] initWithFrame:CGRectMake(38*_Scale-2*_margin+(_smallCardWidth+8*_Scale)*(i%3), 28*_Scale+(126+20)*_Scale*(i/3), _smallCardWidth, 126*_Scale)];
        card.backgroundColor=[UIColor clearColor];
        [_scrollview addSubview:card];
        UIImageView *img=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(card.frame), 64*_Scale)];
        img.image=[UIImage imageNamed:@"box_choose_学术档案_back"];

        [card addSubview:img];
        UIView *_downview=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(img.frame)+1*_Scale, CGRectGetWidth(img.frame), CGRectGetHeight(card.frame)-CGRectGetMaxY(img.frame)-1*_Scale)];
        _downview.backgroundColor=[UIColor whiteColor];
        [card addSubview:_downview];
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(img.frame), CGRectGetHeight(img.frame))];
        label.textAlignment=1;
        label.textColor=[UIColor colorWithRed:195.0f/255.0f green:195.0f/255.0f blue:195.0f/255.0f alpha:1];
        label.text=titleArray[i];
        label.font=[regular get_en_Font:17.0f];
        [img addSubview:label];

        UILabel *label1=[[UILabel alloc] initWithFrame:CGRectMake(0,0, CGRectGetWidth(img.frame), CGRectGetHeight(card.frame)-CGRectGetMaxY(img.frame)-1*_Scale)];
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addAction:)];
        label1.userInteractionEnabled=YES;
        [label1 addGestureRecognizer:tap];
        label1.textAlignment=1;
        label1.font=[regular get_en_Font:18.0f];
        label1.tag=i+1;
        label1.userInteractionEnabled=YES;
        label1.textColor=_define_blue_color;
        NSString *__title=nil;
        if([data_dict objectForKey:keyArray[i]]==[NSNull null]||[[data_dict objectForKey:keyArray[i]] integerValue]==0)
        {

            UIImageView *_img=_imgArray[i];
            _img.frame=CGRectMake((CGRectGetWidth(card.frame)-40*_Scale)/2.0f,(CGRectGetHeight(label1.frame)-40*_Scale)/2.0f, 40*_Scale, 40*_Scale);

            [label1 addSubview:_img];
            __title=@"";

        }else
        {
            if(i==0)
            {
                __title=[[NSString alloc] initWithFormat:@"%.1f",[[data_dict objectForKey:keyArray[i]] floatValue]];

            }else
            {
                __title=[[NSString alloc] initWithFormat:@"%ld",(long)[[data_dict objectForKey:keyArray[i]] integerValue]];

            }


        }
        if(i==titleArray.count-1)
        {
            __y_p=CGRectGetMaxY(card.frame);
        }
        label1.text=__title;

        [_downview addSubview:label1];


    }



}
-(void)createScrollView
{
    _scrollview=[[UIScrollView alloc] initWithFrame:CGRectMake(_margin, 0, ScreenWidth-2*_margin, ScreenHeight+kTabBarHeight)];
    _scrollview.contentSize=CGSizeMake(CGRectGetWidth(_scrollview.frame), CGRectGetHeight(_scrollview.frame));
    [self.view addSubview:_scrollview];
}
-(void)request_maxnum
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[[NSString alloc] initWithFormat:@"%@/v1/schools/pre_search",DNS] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {

            NSString *html = operation.responseString;
            NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
            //        进行解析以后的操作
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

            if([[dict objectForKey:@"code"] integerValue]==1)
            {
                _request_num++;
                total_students_min=[[[dict objectForKey:@"data"] objectForKey:@"total_students_min"] longValue];
                ap_count_max=[[[dict objectForKey:@"data"] objectForKey:@"ap_count_max"] longValue];

                total_students_max=[[[dict objectForKey:@"data"] objectForKey:@"total_students_max"] longValue];
                ap_count_min=[[[dict objectForKey:@"data"] objectForKey:@"ap_count_min"] longValue];

                if(_request_num==2)
                {
                    [self setdata];
                    [self UIConfig];
                }


            }else
            {
                 [[ToolManager sharedManager] alertTitle_Simple:[dict objectForKey:@"message"]];
            }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
    }];
    

}
-(void)request_grade
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


    [manager GET:[[NSString alloc] initWithFormat:@"%@%@",DNS,@"/v1/students"] parameters:@{@"token":_token} success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSString *html = operation.responseString;
        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
        if([[dict objectForKey:@"code"] integerValue]==1)
        {
            _request_num++;
//            if([dict objectForKey:@"data"]!=[NSNull null])

                data_dict=[dict objectForKey:@"data"];
                userid=[[[data_dict objectForKey:@"data"] objectForKey:@"user_id"] integerValue];
            if(_request_num==2)
            {
                [self setdata];
                [self UIConfig];
            }

//            }
            [[ToolManager sharedManager] removeProgress];
        }else
        {
            data_dict=[[NSDictionary alloc] init];
            [[ToolManager sharedManager] alertTitle_Simple:[dict objectForKey:@"message"]];
            [[ToolManager sharedManager] removeProgress];

        }


    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
        NSLog(@"Error: %@", error);
        [[ToolManager sharedManager] removeProgress];
    }];

}
-(void)requestData
{

    [self request_maxnum];
    [self request_grade];
}
-(void)setdata
{


    if ([data_dict objectForKey:@"apply_grade"]!=[NSNull null]) {
        if([[data_dict objectForKey:@"apply_grade"] isEqualToString:@"1,0"])
        {
            [_issenior setString:@"1"];
            [_isjunior setString:@"0"];


        }else if([[data_dict objectForKey:@"apply_grade"] isEqualToString:@"1,1"])
        {
            [_issenior setString:@"1"];
            [_isjunior setString:@"1"];
        }else if([[data_dict objectForKey:@"apply_grade"] isEqualToString:@"0,1"])
        {
            [_issenior setString:@"0"];
            [_isjunior setString:@"1"];
        }else
        {
            [_issenior setString:@"0"];
            [_isjunior setString:@"0"];
        }
    }else
    {
        [_issenior setString:@"0"];
        [_isjunior setString:@"0"];

    }

    if ([data_dict objectForKey:@"isesl"]!=[NSNull null]) {
        if([[data_dict objectForKey:@"isesl"] integerValue]==1)
        {
            [_isESL setString:@"1"];

        }else
        {
            [_isESL setString:@"0"];
        }
    }else
    {
        [_isESL setString:@"0"];
    }



    if ([data_dict objectForKey:@"boarding_day"]!=[NSNull null]) {
        if([[data_dict objectForKey:@"boarding_day"] isEqualToString:@"day,boarding"])
        {
            [_isboardind setString:@"1"];
            [_isday setString:@"1"];
        }else if([[data_dict objectForKey:@"boarding_day"] isEqualToString:@"day"])
        {

            [_isday setString:@"1"];
        }else if([[data_dict objectForKey:@"boarding_day"] isEqualToString:@"boarding"])
        {

            [_isboardind setString:@"1"];
        }else
        {
            [_isboardind setString:@"0"];
            [_isday setString:@"0"];
        }
    }else
    {
        [_isboardind setString:@"0"];
        [_isday setString:@"0"];
    }

    if ([data_dict objectForKey:@"student_sex_limit"]!=[NSNull null]) {

        if([[data_dict objectForKey:@"student_sex_limit"] isEqualToString:@"0,0,0"])
        {
            [_ismixed setString:@"0"];
            [_isfemale setString:@"0"];
            [_ismale setString:@"0"];

        }else if([[data_dict objectForKey:@"student_sex_limit"] isEqualToString:@"1,1,1"])
        {
            [_ismixed setString:@"1"];
            [_isfemale setString:@"1"];
            [_ismale setString:@"1"];

        }else if([[data_dict objectForKey:@"student_sex_limit"] isEqualToString:@"0,0,1"])
        {
            [_ismixed setString:@"0"];
            [_isfemale setString:@"0"];
            [_ismale setString:@"1"];

        }else if([[data_dict objectForKey:@"student_sex_limit"] isEqualToString:@"0,1,0"])
        {
            [_ismixed setString:@"0"];
            [_isfemale setString:@"1"];
            [_ismale setString:@"0"];

        }else if([[data_dict objectForKey:@"student_sex_limit"] isEqualToString:@"1,0,0"])
        {
            [_ismixed setString:@"1"];
            [_isfemale setString:@"0"];
            [_ismale setString:@"0"];

        }else if([[data_dict objectForKey:@"student_sex_limit"] isEqualToString:@"1,1,0"])
        {
            [_ismixed setString:@"1"];
            [_isfemale setString:@"1"];
            [_ismale setString:@"0"];

        }else if([[data_dict objectForKey:@"student_sex_limit"] isEqualToString:@"1,0,1"])
        {
            [_ismixed setString:@"1"];
            [_isfemale setString:@"0"];
            [_ismale setString:@"1"];

        }else if([[data_dict objectForKey:@"student_sex_limit"] isEqualToString:@"0,1,1"])
        {
            [_ismixed setString:@"0"];
            [_isfemale setString:@"1"];
            [_ismale setString:@"1"];

        }else
        {
            [_ismixed setString:@"0"];
            [_isfemale setString:@"0"];
            [_ismale setString:@"0"];

        }

    }else
    {
        [_ismixed setString:@"0"];
        [_ismale setString:@"0"];
        [_isfemale setString:@"0"];
    }

    if([data_dict objectForKey:@"trend_us_state_id"]!=[NSNull null])
    {
        if([data_dict objectForKey:@"trend_state_cn"]!=[NSNull null])
        {
            [_state setString:[data_dict objectForKey:@"trend_state_cn"]];
        }else
        {
            [_state setString:@""];

        }
    }else
    {
        [_state setString:@""];
    }

    if([data_dict objectForKey:@"trend_us_city_id"]!=[NSNull null])
    {
        if([data_dict objectForKey:@"trend_city_cn"]!=[NSNull null])
        {
            [_city setString:[data_dict objectForKey:@"trend_city_cn"]];
        }else
        {
             [_city setString:@""];

        }
    }else
    {
        [_city setString:@""];
    }

    if([data_dict objectForKey:@"trend_us_state_id"]!=[NSNull null])
    {

        [state_id setString:[[NSString alloc] initWithFormat:@"%ld",[[data_dict objectForKey:@"trend_us_state_id"] longValue]]];

    }else
    {
        [state_id setString:@"0"];
    }

    if([data_dict objectForKey:@"trend_us_city_id"]!=[NSNull null])
    {

        [city_id setString:[[NSString alloc] initWithFormat:@"%ld",[[data_dict objectForKey:@"trend_us_city_id"] longValue]]];

    }else
    {
        [city_id setString:@"0"];
    }

//    state_id
//    city_id

}
-(void)prepareData
{

    _request_num=0;

    leftLabel1=[[UILabel alloc] init];
    leftLabel2=[[UILabel alloc] init];
    rightLabel1=[[UILabel alloc] init];
    rightLabel2=[[UILabel alloc] init];



    _alertNum=[[NSMutableString alloc] initWithString:@""];
    _alert_grade=NO;

    _ismixed=[[NSMutableString alloc] init];
    _ismale=[[NSMutableString alloc] init];
    _isfemale=[[NSMutableString alloc] init];
    _isday=[[NSMutableString alloc] init];
    _isboardind=[[NSMutableString alloc] init];
    _isjunior=[[NSMutableString alloc] init];
    _issenior=[[NSMutableString alloc] init];
    _isESL=[[NSMutableString alloc] init];
    _state=[[NSMutableString alloc] init];
    _city=[[NSMutableString alloc] init];

    _smallCardWidth=(ScreenWidth-38*_Scale*2-8*_Scale)/3.0f;
    __y_p=0;
    stateArr=[[NSMutableArray alloc] init];
    cityArr=[[NSMutableArray alloc] init];
    state_id=[[NSMutableString alloc] init];
    city_id=[[NSMutableString alloc] init];
    screen_selectImg=@[@[@"screenShcool_混校",@"screenShcool_女校",@"screenShcool_男校",@"screenShcool_esl"],@[@"screenShcool_走读",@"screenShcool_寄宿",@"screenShcool_高中",@"screenShcool_初中"]];
    screen_normalImg=@[@[@"screenShcool_混合学校未点击",@"screenShcool_女校未点击",@"screenShcool_男校未选中",@"screenShcool_无esl1"],@[@"screenShcool_走读未选中",@"screenShcool_寄宿未选中",@"screenShcool_高中未选中",@"screenShcool_初中未选中"]];
    screen_titleArr=@[@[@"混 校",@"女 校",@"男 校",@"ESL"],@[@"走 读",@"寄 宿",@"高 中",@"初 中"]];
    _isfirst_choose=YES;
    _now_tag=0;
    UIBarButtonItem *_btn=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回箭头"] style:UIBarButtonItemStylePlain target:self action:@selector(popviewAction)];
    self.navigationItem.leftBarButtonItem=_btn;
    self.navigationItem.titleView=[[ToolManager sharedManager] returnNavView:@"学术档案" withmaxwidth:230];
    self.view.backgroundColor=_define_backview_color;
    keyArray=@[
               @"gpa",@"sat",@"ssat",
               @"toefl",@"toefl_junior",@"ielts",
               @"slate",@"act",@"isee"
               ];
    titleArray=@[
                 @"GPA",@"SAT",@"SSAT",
                 @"TOEFL",@"TOEFL J",@"IELTS",
                 @"SLATE",@"ACT",@"ISEE"
                 ];
    _imgArray=[[NSMutableArray alloc] init];
    for (int i=0; i<titleArray.count; i++) {
        UIImageView *imageview=[[UIImageView alloc] init];
        imageview.tag=100+i+1;
        imageview.image=[UIImage imageNamed:@"box_choose_add"];
        imageview.userInteractionEnabled=YES;
        [_imgArray addObject:imageview];

    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"AcademicRecordsController"];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"AcademicRecordsController"];
}

-(void)popviewAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
