//
//  ChooseSchoolController.m
//  OneBox
//
//  Created by 谢江新 on 15/3/9.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import "ChooseSchoolController.h"

#import "OnlineProjectsViewController.h"
#import "AcademicRecordsController.h"
#import "SchoolDetailViewController.h"
#import "CustomTabbarController.h"

#import "CollectionSchoolViewController.h"
#import "chooseModel.h"
#import "surveyModel.h"
#import "Tools.h"

#define cardHeight 300*_Scale
#define card_detail 300*_Scale
#define card_type 140*_Scale
#define schoolSign @"注:以上学费信息为官网获取，可能未包含书本，校服，活动等费用，最终费用请以学校通知为准。"

@interface ChooseSchoolController ()<UIAlertViewDelegate,UIScrollViewDelegate>

@end

@implementation ChooseSchoolController
{
    YYAnimationIndicator *indicator;
    UIView *_bottom_view;
    BOOL _deleteAct;
    UIScrollView *_scrollView;
    UIImageView *upview;
    UIView *middleview;
    UIView *downview;
    UIButton *_addbtn;
    UIButton *_nextBtn;
    NSDictionary *data_dict;
    
    CGRect _rect_add;
    CGFloat max_y;
    CGFloat _addDiameter;
    CGFloat add_y_p;
    CGFloat _nextBtn_height;

    BOOL firstdelete;
    BOOL isanimation;
    BOOL isAppear;
    BOOL isToCol;
    
    NSMutableArray *_dataArray;
    NSMutableArray *_cardArray;
    NSMutableArray *_titleImgArray;
    NSMutableArray *_titleImgArray1;
    NSMutableArray *_deleteBtnArray;
    NSMutableArray *_alertViewArray;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
  
}
-(void)prepareData
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadGoal) name:@"reloadGoal" object:nil];
    _deleteAct=NO;
    firstdelete=YES;
    isToCol=NO;
    _alertViewArray=[[NSMutableArray alloc] init];
    _nextBtn_height=70*_Scale;
    _addDiameter=110*_Scale;
    add_y_p=ScreenHeight-26*_Scale-_addDiameter;
    
    isAppear=YES;
    _dataArray=[[NSMutableArray alloc] init];
    isanimation=YES;
    _deleteBtnArray=[[NSMutableArray alloc] init];
    _titleImgArray=[[NSMutableArray alloc] init];
    _titleImgArray1=[[NSMutableArray alloc] init];
    _cardArray=[[NSMutableArray alloc] init];
    max_y=0;
    self.navigationItem.titleView=[[ToolManager sharedManager] returnNavView:@" 定学校!" withmaxwidth:230];

    UIBarButtonItem *_btn=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回箭头"] style:UIBarButtonItemStylePlain target:self action:@selector(popviewAction)];
    self.navigationItem.leftBarButtonItem=_btn;


    UIButton *_btn_r=[UIButton buttonWithType:UIButtonTypeCustom];
    _btn_r.frame=CGRectMake(0, 0, 28, 28);
    [_btn_r addTarget:self action:@selector(helpAction) forControlEvents:UIControlEventTouchUpInside];
    [_btn_r setBackgroundImage:[UIImage imageNamed:@"found_问问"] forState:UIControlStateNormal];
    UIBarButtonItem *_btn_bar=[[UIBarButtonItem alloc] initWithCustomView:_btn_r];
    self.navigationItem.rightBarButtonItem=_btn_bar;
    
}
-(void)helpAction
{

    NSString *login=nil;
    if(![regular isLogin])
    {
        login=@"0";
    }else
    {
        login=@"1";
    }

    OnlineProjectsViewController *online=[[OnlineProjectsViewController alloc] init];
    online.islogin=login;
    [self.navigationController pushViewController:online animated:YES];
}
-(void)popviewAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)UIConfig
{
    [self createScrollView];

    [self getData];
}
-(void)getData
{

    if(!isToCol)
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

    }


    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters=@{@"token":[regular getToken]};
     NSString *str=[NSString stringWithFormat:@"%@/v1/order_schools",DNS];
    [manager GET:str parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {

         [indicator stopAnimationWithLoadText:@"loading..." withType:YES];
        NSString *html = operation.responseString;
        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
        data_dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
        max_y=0;
        if([[data_dict objectForKey:@"code"] intValue]==1)
        {
            [_dataArray setArray:[chooseModel parsingWithJsonDataForModel:data_dict]];
            if(_dataArray.count>0)
            {
                _titleImgArray=[[NSMutableArray alloc] init];
                _titleImgArray1=[[NSMutableArray alloc] init];
                for (int i=0; i<_dataArray.count; i++) {
                    [self customCard:_dataArray[i] WithIndex:i];

                    NSInteger index=1000+i;
                    UIAlertView *countersign_delete=[[UIAlertView alloc] initWithTitle:nil message:@"确定删除" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"YES", nil];
                    countersign_delete.tag=index;
                    countersign_delete.delegate = self;
                    [_alertViewArray addObject:countersign_delete];
                }
                _bottom_view=[[UIView alloc] initWithFrame:CGRectMake(20*_Scale, max_y+10*_Scale,CGRectGetWidth(_scrollView.frame)-40*_Scale , 0)];



                _scrollView.contentSize=CGSizeMake(ScreenWidth, CGRectGetMaxY(_bottom_view.frame)+250*_Scale);

            }else
            {
                add_y_p=ScreenHeight-26*_Scale-_addDiameter-100*_Scale;
                NSArray *arr=@[@"还没有设定目标学校哦",@"点我"];
                for (int i=0; i<arr.count; i++) {
                    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, 130*_Scale+100*_Scale*i, ScreenWidth, 38*_Scale)];
                    label.font=[regular getFont:12.0f];
                    [label setAttributedText:[regular createAttributeString:arr[i] andFloat:@(3.0)]];
                    label.textColor=_define_blue_color;
                    label.textAlignment=1;
                    [_scrollView addSubview:label];
                }
            }

            if(_dataArray.count>0)
            {
                [self createNextBtn];
            }
            [self createAddBtn];

        }else
        {
             [[ToolManager sharedManager] alertTitle_Simple:[data_dict objectForKey:@"message"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
         [indicator stopAnimationWithLoadText:@"loading..." withType:YES];
    }];


}
-(void)createNextBtn
{
    _nextBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    if((_cardArray.count-1)*cardHeight+250*_Scale<ScreenHeight-64)
    {
        _nextBtn.frame=CGRectMake(20, _scrollView.contentSize.height-100*_Scale, _scrollView.contentSize.width-20*2, _nextBtn_height);

    }else
    {
        _nextBtn.frame=CGRectMake(20, _scrollView.contentSize.height-100*_Scale, _scrollView.contentSize.width-20*2, _nextBtn_height);
    }

    NSString *nexttitle=nil;
    UIColor *nextcolor=nil;
    if(self.step>=1)
    {
        nexttitle=@"取消完成";
        nextcolor=[UIColor colorWithRed:242/255.0 green:107/255.0 blue:85/255.0 alpha:1.0];

//
    }else
    {
        nexttitle=@"确认完成";
        nextcolor=[UIColor colorWithRed:51.0f/255.0f green:204.0f/255.0f blue:204.0f/255.0f alpha:1];

    }
    [_nextBtn setBackgroundColor:nextcolor];
    JXLOG(@"%f %f",_nextBtn.frame.origin.y,ScreenHeight);
    [_nextBtn setTitle:nexttitle forState:UIControlStateNormal];
    _nextBtn.titleLabel.font=[regular getFont:12.0f];
    [_nextBtn.titleLabel setAttributedText:[regular createAttributeString:nexttitle andFloat:@(3)]];
    [_nextBtn addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
    [_nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_scrollView addSubview:_nextBtn];

}
-(void)nextAction:(UIButton *)btn
{
    if(self.step>=1)
    {
//        取消
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSString *Url = [NSString stringWithFormat:@"%@/v1/user_boxes/cancel?token=%@",DNS,[regular getToken]];
        NSDictionary *dict=@{@"name":@"order_school"};
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

        }];



    }else
    {
//        完成
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSString *Url = [NSString stringWithFormat:@"%@/v1/user_boxes/%@?token=%@",DNS,[regular getUID],[regular getToken]];
        NSDictionary *dict=@{@"name":@"order_school"};
        [manager PUT:Url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *html = operation.responseString;
            NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
            //        进行解析以后的操作
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            if([[dict objectForKey:@"code"] integerValue]==1)
            {
                self.block(@"choose");
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
-(void)createAddBtn
{

    _addbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    
    [_addbtn setBackgroundImage:[UIImage imageNamed:@"box_choose_添加1"] forState:UIControlStateNormal];

    [self refreshrect];
    _addbtn.frame=_rect_add;
    
    [_addbtn addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_addbtn];
    
}
-(void)refreshrect
{
    if(_dataArray.count==0)
    {
        _rect_add=CGRectMake((ScreenWidth-200*_Scale)/2, (ScreenHeight-200*_Scale)/2.0f, 200*_Scale, 200*_Scale);



    }else if(_dataArray.count==1||_dataArray.count==2)
    {
        _rect_add=CGRectMake((ScreenWidth-_addDiameter)/2, add_y_p-kTabBarHeight-30, _addDiameter, _addDiameter);


    }else
    {
        _rect_add=CGRectMake((ScreenWidth-_addDiameter)/2, add_y_p, _addDiameter, _addDiameter);
    }
}
-(void)addAction:(UIButton *)btn
{
//    跳转到添加页面
//    遮盖层
//    []
    UIView *backview=[[UIView alloc] initWithFrame:self.view.frame];
    backview.tag=50;
    backview.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.63];
    [self.view.window addSubview:backview];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeBackview)];
    [backview addGestureRecognizer:tap];
    
    CGFloat _v_interval=20*_Scale;
    CGFloat _cell_height=160*_Scale;
    CGFloat _y_p=(CGRectGetHeight(backview.frame)/2)-_cell_height-_v_interval/2;
    CGFloat _x_p=(ScreenWidth-400*_Scale)/2.0f;
    CGFloat _cell_width=400*_Scale;
    
    for (int i=0; i<2; i++) {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(_x_p, _y_p, _cell_width, _cell_height);
        [backview addSubview:btn];
        [btn setBackgroundColor:[UIColor colorWithRed:77.0f/255.0f green:190.0f/255.0f  blue:217.0f/255.0f  alpha:1]];

        btn.tag=200+i;
        [btn addTarget:self action:@selector(jumpview:) forControlEvents:UIControlEventTouchUpInside];
        _y_p+=_cell_height+_v_interval;

        NSArray *array=i==0?@[@"心愿学校",@"从您的心愿单添加"]:@[@"推荐学校",@"根据学术和选校倾向添加"];
        for (int j=0;j<2 ;j++) {
            UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, 30*_Scale+50*_Scale*j, CGRectGetWidth(btn.frame), 50*_Scale)];
//            label.backgroundColor=[UIColor whiteColor];
            
            [btn addSubview:label];
            label.textAlignment=1;
            label.textColor=[UIColor whiteColor];
            label.font=j==0?[regular getFont:14.0f]:[regular getFont:12.0f];

            [label setAttributedText:[regular createAttributeString:array[j] andFloat:@(j==0?5:2)]];


        }
        
    }
}
-(void)removeBackview
{

    [[self.view.window viewWithTag:50] removeFromSuperview];
}
-(void)jumpview:(UIButton *)btn
{
    [[self.view.window viewWithTag:50] removeFromSuperview];
    NSInteger _index=btn.tag-200;
    if(_index)
    {
        [self.navigationController pushViewController:[AcademicRecordsController new] animated:YES];

    }else
    {
//     收藏学校
        CollectionSchoolViewController *col=[[CollectionSchoolViewController alloc] init];
        col.dict=[[NSDictionary alloc] initWithObjectsAndKeys:@"add",@"type",[NSDictionary new],@"dict",nil];

        isToCol=YES;
        [self.navigationController pushViewController:col animated:YES];
        
    }
}

-(void)tiaozhuan:(UIGestureRecognizer *)ges
{
    int index=0;
    for (int i=0; i<_cardArray.count ; i++) {
        UIView *__view=_cardArray[i];
        if(ges.view.tag==__view.tag)
        {
            index=i;
            break;
        }
    }


    SchoolDetailViewController *school=[[SchoolDetailViewController alloc] init];
    chooseModel *choosemodel=_dataArray[index];
    school.data_dict=[[NSDictionary alloc] initWithObjectsAndKeys:choosemodel.cn_name,@"schoolName",[[NSString alloc] initWithFormat:@"%ld",(long)choosemodel.sid],@"schoolID",[NSNumber numberWithInteger:1],@"is_order_school",nil];
    [self.navigationController pushViewController:school animated:YES];

}
-(void)customCard:(chooseModel *)model WithIndex:(NSInteger )index
{
    max_y+=45*_Scale;
    UIView *_card=[[UIView alloc] initWithFrame:CGRectMake(40*_Scale, max_y, 560*_Scale,cardHeight)];
    _card.backgroundColor=[UIColor colorWithRed:234.0f/255.0f green:234.0f/255.0f blue:234.0f/255.0f alpha:1];
    _card.tag=4000+index;
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tiaozhuan:)];
    [_card addGestureRecognizer:tap];
    [_scrollView addSubview:_card];
    _scrollView.contentSize=CGSizeMake(ScreenWidth, CGRectGetMaxY(_card.frame));
    max_y=CGRectGetMaxY(_card.frame);



    UIImageView *titleImg=[[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(_scrollView.frame)-59*_Scale)/2.0f, CGRectGetMinY(_card.frame)-3-69*_Scale/2, 64*_Scale, 64*_Scale)];

    titleImg.image=[UIImage imageNamed:@"box_choose_圆点"];
    titleImg.userInteractionEnabled=YES;
    titleImg.tag=2000+index;
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(titleImg.frame), CGRectGetHeight(titleImg.frame)-3)];
//    label.backgroundColor=[UIColor blueColor];
    label.textAlignment=1;
    label.text=[[NSString alloc] initWithFormat:@"%ld",index+1];
    label.font=[regular get_en_Font:24.0f];
    label.tag=3000+index;
    label.textColor=[UIColor whiteColor];
    [_titleImgArray1 addObject:label];
    [titleImg addSubview:label];
    [_scrollView addSubview:titleImg];
    [_titleImgArray addObject:titleImg];


    
    UIImageView *deleteImg=[[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(_scrollView.frame)-71.5*_Scale, CGRectGetMinY(_card.frame)-47.5*_Scale/2, 59*_Scale, 59*_Scale)];
    deleteImg.image=[UIImage imageNamed:@"box_choose_关闭按钮"];
    deleteImg.userInteractionEnabled=YES;
    deleteImg.tag=100+index;
    UITapGestureRecognizer *tap11=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(delete_card:)];
    [deleteImg addGestureRecognizer:tap11];
    [_scrollView addSubview:deleteImg];
    [_deleteBtnArray addObject:deleteImg];
    [_cardArray addObject:_card];
    [self createUpView:model WithCard:_card];
    [self createMiddleView:model WithCard:_card];
//    [self createDownView:model WithCard:_card WithIndex:index];
    
}

-(void)createDownView:(chooseModel *)model WithCard:(UIView *)_card WithIndex:(NSInteger )index
{
    downview=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(middleview.frame)+4*_Scale, CGRectGetWidth(_card.frame), CGRectGetHeight(_card.frame)-CGRectGetMaxY(middleview.frame)-4*_Scale)];
    downview.backgroundColor=[UIColor whiteColor];
    [_card addSubview:downview];


    NSMutableArray *skusArr=[[NSMutableArray alloc] init];
//    int codads=0;

    chooseModel *choosemodel=_dataArray[index];
    for (NSDictionary *__dict in choosemodel.prices)
    {


        if([[__dict objectForKey:@"inter_or_native"]isEqualToString:@"international"])
        {


            if(([__dict objectForKey:@"price"]!=[NSNull null])&&(([[__dict objectForKey:@"price"] integerValue])>0))
            {
                [skusArr addObject:__dict];
            }

        }

    }

    

    if(skusArr.count==0)
    {
        NSArray *titlearr=@[@"暂时还未更新学费信息",@"再等等哦～"];
        CGFloat _font=10.0f;
        CGSize _size=[Tools sizeOfStr:titlearr[0] andFont:[UIFont systemFontOfSize:_font] andMaxSize:CGSizeMake(CGRectGetWidth(downview.frame), 999999) andLineBreakMode:NSLineBreakByWordWrapping];

        CGFloat _y_p=-8*_Scale-_size.height+(CGRectGetHeight(downview.frame)/2.0f);
        for (int i=0; i<titlearr.count; i++) {



            UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0,_y_p+i*(_size.height+16*_Scale) , CGRectGetWidth(downview.frame), _size.height)];
            //            label.backgroundColor=[UIColor redColor];
            label.numberOfLines=0;
            label.textAlignment=1;
            label.textColor=[UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1];
            label.font=[regular getFont:_font];
            [label setAttributedText:[regular createAttributeString:titlearr[i] andFloat:@(1.0)]];

            [downview addSubview:label];
            
        }
        
        
        
    }else
    {
        JXLOG(@"%@",skusArr);

        CGFloat _width=102*_Scale;
        CGFloat _interval=(CGRectGetWidth(downview.frame)-_width*4)/5.0f;
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
                _x_p=(CGRectGetWidth(downview.frame)-_width)/2.0f;
            }else if(skusArr.count==2)
            {
                _x_p=_interval+(_width+_interval)*(i+1);
            }else
            {
                _x_p=_interval+(_width+_interval)*i;
            }


            CGRect _rect=CGRectMake(_x_p,+10*_Scale, 102*_Scale, 102*_Scale);

            UIImageView *__imageview=[[ToolManager sharedManager] createImgView:@"school_费用图标" WithRect:_rect];

            [downview addSubview:__imageview];

            NSString *price=nil;
            if([___dict objectForKey:@"price"]==[NSNull null])
            {
                price=@"0";
            }else
            {
                price=[[NSString alloc] initWithFormat:@"%ld",(long)[[___dict objectForKey:@"price"] integerValue]];
            }

            UILabel *_content_Label=[[UILabel alloc] initWithFrame:CGRectMake(0, 9*_Scale, 100*_Scale, 100*_Scale)];
            _content_Label.textColor=[UIColor colorWithRed:136.0f/255.0f green:136.0f/255.0f blue:136.0f/255.0f alpha:1];
            _content_Label.font=[regular get_en_Font:11.5f];
            _content_Label.text=price;
            _content_Label.textAlignment=1;
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
                    _title_str=@"寄宿初中";
                }

            }


            UILabel *_title_Label=[[ToolManager sharedManager] createLabelView:_title_str Withrect:CGRectMake(CGRectGetMinX(__imageview.frame)-20*_Scale, CGRectGetMaxY(__imageview.frame), 40*_Scale+CGRectGetWidth(__imageview.frame), CGRectGetHeight(downview.frame)-CGRectGetMaxY(__imageview.frame)-10*_Scale) WithTextColor:[UIColor colorWithRed:136.0f/255.0f green:136.0f/255.0f blue:136.0f/255.0f alpha:1] WithTextAlignment:1 WithFont:11.0f];
            _title_Label.font=[regular get_en_Font:12.0f];
             [_title_Label setAttributedText:[regular createAttributeString:_title_str andFloat:@(1.0f)]];

            [downview addSubview:_title_Label];
            
        }
    }

}
-(void)delete_card:(UIGestureRecognizer *)sender
{
//    deleteImg
    NSInteger index=0;
    
//    NSInteger index=sender.view.tag-100;
    
    for (int i=0; i<_deleteBtnArray.count; i++) {
        UIImageView *_imageView=_deleteBtnArray[i];
        if(_imageView.tag==sender.view.tag)
        {
            index=i;
            break;
        }
    }

    [(UIAlertView *)_alertViewArray[index] show];


}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1)
    {
        NSInteger index=0;
//        NSInteger index1=0;
        for (int i=0; i<_alertViewArray.count; i++)
        {
            UIAlertView *__alertView=_alertViewArray[i];
            if(__alertView.tag==alertView.tag)
            {
                index=i;
                break;
            }
        }
        //    删除
        chooseModel *model=_dataArray[index];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

        NSDictionary *parameters=@{@"token":[regular getToken]};
        NSString *url=[[NSString alloc] initWithFormat:@"%@%@%@",DNS,@"/v1/order_schools/",model.goal_id];
        [manager DELETE:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {

            NSString *html = operation.responseString;
            NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
            if([[dict objectForKey:@"code"] integerValue]==1)
            {

                _deleteAct=YES;
                [self deleteAnimation:index];
#pragma mark-发通知刷新发现美校
                [[NSNotificationCenter defaultCenter] postNotificationName:@"changeFound" object:nil];

            }

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
        }];
    }

}
#pragma mark-donghua
-(void)deleteAnimation:(NSInteger )_index
{

    if(firstdelete)
    {
        _scrollView.contentSize=CGSizeMake(_scrollView.contentSize.width , _scrollView.contentSize.height);
        firstdelete=NO;
    }
    //        删除成功
    UIImageView *imageview=_deleteBtnArray[_index];
    UIImageView *titleimg=_titleImgArray[_index];
    UIView *view=_cardArray[_index];
    JXLOG(@"%@",_alertViewArray);
    if((_cardArray.count)*cardHeight+250*_Scale<ScreenHeight-64)
    {

         _scrollView.contentSize=CGSizeMake(_scrollView.contentSize.width, _scrollView.contentSize.height-45*_Scale-cardHeight);
    }
    else
    {
        _scrollView.contentSize=CGSizeMake(_scrollView.contentSize.width, _scrollView.contentSize.height-45*_Scale-cardHeight);

    }

    if(_dataArray.count==1)
    {
        _nextBtn.hidden=YES;
        NSArray *arr=@[@"还没有设定目标学校哦",@"点我"];
        for (int i=0; i<arr.count; i++) {
            UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, 130*_Scale+100*_Scale*i, ScreenWidth, 38*_Scale)];
            label.font=[regular getFont:11.0f];
            [label setAttributedText:[regular createAttributeString:arr[i] andFloat:@(3.0)]];
            label.textColor=[UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1];
            label.textAlignment=1;
            [_scrollView addSubview:label];
        }

    }else
    {
        _nextBtn.hidden=NO;
    }
    BOOL _ddd=YES;

    [view removeFromSuperview];
    [imageview removeFromSuperview];
    [titleimg removeFromSuperview];
    [_dataArray removeObjectAtIndex:_index];
    [_titleImgArray removeObjectAtIndex:_index];
    [_titleImgArray1 removeObjectAtIndex:_index];
    [_deleteBtnArray removeObjectAtIndex:_index];
    [_cardArray removeObjectAtIndex:_index];
    [_alertViewArray removeObjectAtIndex:_index];

    for (int i=0; i<_titleImgArray1.count; i++) {
        UILabel *label=_titleImgArray1[i];
        label.text=[[NSString alloc] initWithFormat:@"%d",i+1];

    }

    if(_index==_cardArray.count)
    {
        //        动画
        [UIView beginAnimations:@"anmationName" context:nil];
        //设置动画的时间间隔（从动画开始到结束所用时间）
        [UIView setAnimationDuration:1];

        //设置当前动画的代理
        [UIView setAnimationDelegate:self];
        //在这做一些修改，包括对视图的坐标，大小，以及颜色的修改,透明度的修改
        //这些修改将会以动画的形式显示

        if((_cardArray.count-1)*cardHeight+250*_Scale<ScreenHeight-64)
        {

            if(_cardArray.count>2)
            {
                _nextBtn.frame=CGRectMake(20, _scrollView.contentSize.height-100*_Scale, CGRectGetWidth(_nextBtn.frame), _nextBtn_height);
            }


        }else
        {
            _nextBtn.frame=CGRectMake(20, _scrollView.contentSize.height-100*_Scale, CGRectGetWidth(_nextBtn.frame), CGRectGetHeight(_nextBtn.frame));


        }

        [UIView commitAnimations];

    }
    for (NSInteger i=_index; i<_cardArray.count; i++) {
        UIView *_card=_cardArray[i];
        UIImageView *_delete=_deleteBtnArray[i];
        UIImageView *_titleimg=_titleImgArray[i];


        //        动画
        [UIView beginAnimations:@"anmationName" context:nil];
        //设置动画的时间间隔（从动画开始到结束所用时间）
        [UIView setAnimationDuration:1];
        
        //设置当前动画的代理
        [UIView setAnimationDelegate:self];
        //在这做一些修改，包括对视图的坐标，大小，以及颜色的修改,透明度的修改
        //这些修改将会以动画的形式显示
        if(i==_index)
        {

            if((_cardArray.count)*cardHeight+250*_Scale<ScreenHeight-64)
            {
                _nextBtn.frame=CGRectMake(20, _scrollView.contentSize.height-100*_Scale, CGRectGetWidth(_nextBtn.frame), _nextBtn_height);

            }else
            {
                _nextBtn.frame=CGRectMake(20, _scrollView.contentSize.height-100*_Scale, CGRectGetWidth(_nextBtn.frame), _nextBtn_height);
                
            }
        }
        _deleteAct=NO;

        _card.frame=CGRectMake(CGRectGetMinX(_card.frame), CGRectGetMinY(_card.frame)-45*_Scale-cardHeight, CGRectGetWidth(_card.frame), CGRectGetHeight(_card.frame));

        if(i==_index)
        {
             _nextBtn.frame=CGRectMake(20, _scrollView.contentSize.height-100*_Scale, CGRectGetWidth(_nextBtn.frame), CGRectGetHeight(_nextBtn.frame));

        }


        _titleimg.frame=CGRectMake(CGRectGetMinX(_titleimg.frame), CGRectGetMinY(_titleimg.frame)-45*_Scale-cardHeight, CGRectGetWidth(_titleimg.frame), CGRectGetHeight(_titleimg.frame));
        _delete.frame=CGRectMake(CGRectGetMinX(_delete.frame), CGRectGetMinY(_delete.frame)-45*_Scale-cardHeight, CGRectGetWidth(_delete.frame), CGRectGetHeight(_delete.frame));

        if(_ddd)
        {
            _bottom_view.frame=CGRectMake(CGRectGetMinX(_bottom_view.frame), CGRectGetMinY(_bottom_view.frame)-45*_Scale-cardHeight, CGRectGetWidth(_bottom_view.frame), CGRectGetHeight(_bottom_view.frame));
            _ddd=NO;

        }


        [UIView commitAnimations];
    }
    CGPoint _point=_scrollView.contentOffset;
    if(_dataArray.count>2)
    {
        [self addbtnAnimation:_point];

    }else
    {

        [UIView beginAnimations:@"anmation" context:nil];
        //设置动画的时间间隔（从动画开始到结束所用时间）
        [UIView setAnimationDuration:0.5];

        //设置当前动画的代理
        [UIView setAnimationDelegate:self];
         _nextBtn.frame=CGRectMake(20, _scrollView.contentSize.height-100*_Scale, CGRectGetWidth(_nextBtn.frame), _nextBtn_height);

        if(_dataArray.count==0)
        {
            _addbtn.frame=CGRectMake((ScreenWidth-200*_Scale)/2, (ScreenHeight-200*_Scale)/2.0f, 200*_Scale, 200*_Scale);

        }else
        {
            _addbtn.frame=CGRectMake((ScreenWidth-_addDiameter)/2, add_y_p-kTabBarHeight-50, _addDiameter, _addDiameter);

        }

        [UIView commitAnimations];


    }

}
-(void)createMiddleView:(chooseModel *)model WithCard:(UIView *)_card
{
//    140
//    card_type
    middleview=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(upview.frame), CGRectGetWidth(_card.frame), card_type)];
    [middleview setBackgroundColor:[UIColor whiteColor]];
    [_card addSubview:middleview];

    NSArray *_array_Intro=@[@"",[[NSString alloc]initWithFormat:@"%@，%@",model.cn_city,model.cn_state],model.full_address];

    CGFloat _y_p=12*_Scale;
    for (int i=0; i<_array_Intro.count; i++)
    {
        if(i==0)
        {
            UIImageView *coordIcon=[[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(upview.frame)/2)-28.5*_Scale/2, _y_p, 28.5*_Scale, 34*_Scale)];
             [coordIcon setImage:[UIImage imageNamed:@"box_choose_坐标"]];
            [middleview addSubview:coordIcon];
            _y_p+=CGRectGetMaxY(coordIcon.frame);
        }else
        {

            UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, _y_p+34*_Scale*(i-1), CGRectGetWidth(middleview.frame), 32*_Scale)];
             NSString *__font_name=i==1?(kIOSVersions>=9.0? @"":@"Helvetica Neue" ):@"Skia";
            CGFloat _font=i==1?11.0f:10.0f;
            if([__font_name isEqualToString:@""])
            {
                if(_isPad)
                {
                    label.font=[UIFont systemFontOfSize:_font+20];

                }else
                {
                    label.font=[UIFont systemFontOfSize:_font];
                }

            }else
            {
                if(_isPad)
                {
                    label.font=[UIFont fontWithName:__font_name size:_font+20];

                }else
                {
                    label.font=[UIFont fontWithName:__font_name size:_font];
                }

            }


            label.textAlignment=1;
            if(i==1)
            {
                [label setAttributedText:[regular createAttributeString:_array_Intro[i] andFloat:@(2.0)]];
            }else if(i==2)
            {
                 [label setAttributedText:[regular createAttributeString:_array_Intro[i] andFloat:@(1.0)]];

            }



            [middleview addSubview:label];
            label.textColor=_define_blue_color;
        }

    }
}
-(void)createUpView:(chooseModel *)model WithCard:(UIView *)_card
{
    upview=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_card.frame), 160*_Scale)];

    upview.backgroundColor=[UIColor whiteColor];

    CGSize _size_upview=upview.frame.size;
    NSArray *_array_Intro=@[[[NSString alloc]initWithFormat:@"%@年",model.setup_year],model.en_name,model.cn_name];
    CGFloat labelHeight=(_size_upview.height-45*_Scale)/_array_Intro.count;
    [_card addSubview:upview];
    for (int i=0; i<_array_Intro.count; i++) {
        NSString *__title=i==2?[[NSString alloc] initWithFormat:@"%@",_array_Intro[i]]:_array_Intro[i];
        CGRect _rect;
        _rect=CGRectMake(0, 30*_Scale+i*(labelHeight), _size_upview.width, labelHeight);

        UILabel *textlabel=[[UILabel alloc] initWithFrame:_rect];
        textlabel.textAlignment=1;
        textlabel.textColor=_define_blue_color;
        if(i==0)
        {
            textlabel.font=[regular get_en_Font:11.5f];
            [textlabel setAttributedText:[regular createAttributeString:__title andFloat:@(1.0)]];
        }else if(i==1)
        {
            textlabel.font=[regular get_en_Font:15.0f];
            textlabel.text=__title;
        }else if(i==2)
        {
            textlabel.font=[regular getFont:13.0f];
            [textlabel setAttributedText:[regular createAttributeString:__title andFloat:@(1.0)]];
        }
        [upview addSubview:textlabel];

        
    }
}

-(void)createScrollView
{
    [self.view addSubview:_scrollView];
    CGFloat _y_p=0;
    CGFloat _y_p1=0;
    if(isToCol)
    {
        _y_p=64;
        _y_p1=-kTabBarHeight;
    }

    _scrollView=[[UIScrollView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_scrollView];
//    CGRectMake(0, _y_p, ScreenWidth, ScreenHeight+kTabBarHeight-_y_p+_y_p1)
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    _scrollView.backgroundColor=_define_backview_color;
    _scrollView.showsVerticalScrollIndicator=YES;
    _scrollView.contentSize=CGSizeMake(ScreenWidth, ScreenHeight-64);
    _scrollView.delegate=self;
}
//根据偏移量做判断，改变addbtn的位置
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset NS_AVAILABLE_IOS(5_0)
{
    CGPoint _point=scrollView.contentOffset;
    [self addbtnAnimation:_point];
}
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    CGPoint _point=scrollView.contentOffset;
    [self addbtnAnimation:_point];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    CGPoint _point=scrollView.contentOffset;
    [self addbtnAnimation:_point];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGPoint _point=scrollView.contentOffset;
    [self addbtnAnimation:_point];
    
}
-(void)addbtnAnimation:(CGPoint )_point
{

    CGFloat _y= _nextBtn.frame.origin.y-ScreenHeight;
    if (_y<_point.y) {

        if(isanimation==YES)
        {
            isanimation=NO;
            //        动画
            [UIView beginAnimations:@"anmation" context:nil];
            //设置动画的时间间隔（从动画开始到结束所用时间）
            [UIView setAnimationDuration:0.5];
            
            //设置当前动画的代理
            [UIView setAnimationDelegate:self];
            //在这做一些修改，包括对视图的坐标，大小，以及颜色的修改,透明度的修改
            //这些修改将会以动画的形式显示
#pragma mark-动画往上
            _addbtn.frame=CGRectMake(CGRectGetMinX(_addbtn.frame), _rect_add.origin.y-100*_Scale - (kIPhoneX?34.f:0.f), CGRectGetWidth(_addbtn.frame), CGRectGetHeight(_addbtn.frame));
            if(_deleteAct)
            {
                _nextBtn.frame=CGRectMake(20, _scrollView.contentSize.height-100*_Scale, CGRectGetWidth(_nextBtn.frame), _nextBtn_height);
            }


//                if(_dataArray.count<=2)
//                {
            JXLOG(@"%d",_deleteAct);

//                }else
//                {
//
//                    _nextBtn.frame=CGRectMake(20*_Scale, _scrollView.contentSize.height-100*_Scale, _scrollView.contentSize.width-20*_Scale*2, _nextBtn_height);
//                    
//                }
            [UIView commitAnimations];
            _deleteAct=NO;
        }else
        {
            isanimation=NO;
            //        动画
            [UIView beginAnimations:@"anmation" context:nil];
            //设置动画的时间间隔（从动画开始到结束所用时间）
            [UIView setAnimationDuration:0.5];

            //设置当前动画的代理
            [UIView setAnimationDelegate:self];
            //在这做一些修改，包括对视图的坐标，大小，以及颜色的修改,透明度的修改
            //这些修改将会以动画的形式显示

            _addbtn.frame=CGRectMake(CGRectGetMinX(_addbtn.frame), _rect_add.origin.y-100*_Scale - (kIPhoneX?34.f:0.f), CGRectGetWidth(_addbtn.frame), CGRectGetHeight(_addbtn.frame));


            //                if(_dataArray.count<=2)
            //                {
            JXLOG(@"%d",_deleteAct);
            if(_deleteAct&&_dataArray.count<=3)
            {

                _nextBtn.frame=CGRectMake(20, _scrollView.contentSize.height-100*_Scale, CGRectGetWidth(_nextBtn.frame), _nextBtn_height);


            }

            [UIView commitAnimations];
            _deleteAct=NO;
        }
        
    }else
    {
        isanimation=YES;
        //        动画
        [UIView beginAnimations:@"anmation" context:nil];
        //设置动画的时间间隔（从动画开始到结束所用时间）
        [UIView setAnimationDuration:0.5];
        
        //设置当前动画的代理
        [UIView setAnimationDelegate:self];
        //在这做一些修改，包括对视图的坐标，大小，以及颜色的修改,透明度的修改
        //这些修改将会以动画的形式显示
        #pragma mark-动画往下
        _addbtn.frame=_rect_add;
        [UIView commitAnimations];
        _deleteAct=NO;

    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"ChooseSchoolController"];
    if(!isAppear)
    {
        [self prepareData];
        [self UIConfig];
    }else if(isToCol)
    {

        _alertViewArray=[[NSMutableArray alloc] init];
        _nextBtn_height=70*_Scale;
        _addDiameter=110*_Scale;
        add_y_p=ScreenHeight-26*_Scale-_addDiameter;

        isAppear=YES;
        _dataArray=[[NSMutableArray alloc] init];
        isanimation=YES;
        _deleteBtnArray=[[NSMutableArray alloc] init];
        _cardArray=[[NSMutableArray alloc] init];
        max_y=0;
        [self UIConfig];
    }
    [[CustomTabbarController sharedManager] tabbarHide];
    isToCol=NO;
}
-(void)reloadGoal
{
    _alertViewArray=[[NSMutableArray alloc] init];
            _nextBtn_height=70*_Scale;
            _addDiameter=110*_Scale;
            add_y_p=ScreenHeight-26*_Scale-_addDiameter;
    
            isAppear=YES;
            _dataArray=[[NSMutableArray alloc] init];
            isanimation=YES;
            _deleteBtnArray=[[NSMutableArray alloc] init];
            _cardArray=[[NSMutableArray alloc] init];
            max_y=0;
            [self UIConfig];
//    _scrollView.frame=CGRectMake(CGRectGetMinX(_scrollView.frame), CGRectGetMinY(_scrollView.frame)+64, CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame)-64-kTabBarHeight);

}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"ChooseSchoolController"];
    UIView *view=[self.view viewWithTag:50];
    [view removeFromSuperview];
}
@end

