//
//  goalViewController.m
//  OneBox
//
//  Created by 谢江新 on 15/6/25.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import "goalViewController.h"

#import "CustomTabbarController.h"
#import "SchoolDetailViewController.h"

#import "Tools.h"
#import "chooseModel.h"

#define card_type 140*_Scale
#define cardHeight 440*_Scale

@interface goalViewController ()

@end

@implementation goalViewController
{
    NSMutableArray *_dataArray;
    UIScrollView *_scrollView;
    UIView *upview;
    UIView *middleview;
    CGFloat max_y;
    UIView *downview;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createScrollView];
}
-(void)setType:(NSString *)type
{
    if(_type!=type)
    {
        _type=[type copy];
        [self prepareData];
        [self requestData];
    }


}

-(void)createMiddleView:(chooseModel *)model WithCard:(UIView *)_card
{
    //    140
    //    card_type
    middleview=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(upview.frame), CGRectGetWidth(_card.frame), card_type)];
    [middleview setBackgroundColor:[UIColor whiteColor]];
    [_card addSubview:middleview];



    CGFloat _interval_side=20*_Scale;
    CGFloat _interval_min=20*_Scale;
    CGFloat _interval_middle=50*_Scale;
    CGFloat _diameter=(CGRectGetWidth(_card.frame)-_interval_side*2-_interval_middle-_interval_min*4)/6;
    CGFloat _y_p=25*_Scale;
    CGFloat _x_p=_interval_side;
    CGFloat _interval=0;
    NSArray *_left_array=@[
                           [[NSDictionary alloc] initWithObjectsAndKeys:@"screenShcool_混校",@"混校",@"screenShcool_男校",@"男校",@"screenShcool_女校",@"女校", nil],
                           [[NSDictionary alloc] initWithObjectsAndKeys:@"screenShcool_走读",@"走读",@"screenShcool_寄宿",@"寄宿", nil],
                           [[NSDictionary alloc] initWithObjectsAndKeys:@"screenShcool_esl",@"ESL",@"screenShcool_无esl1",@"无ESL", nil]
                           ];


    NSArray *dataArr=@[model.total_students,model.ap_count,model.sat_avg];
    NSInteger categorytype=[model.student_sex_limit integerValue];
    NSString *category=categorytype==0?@"女校":categorytype==1?@"男校":@"混校";
    NSString *isday=nil;
    if([model.boarding_day isEqualToString:@"boarding"])
    {
        isday=@"寄宿";
    }else if(([model.boarding_day isEqualToString:@"day"]))
    {
        isday=@"走读";
    }else if([model.boarding_day isEqualToString:@"all"])
    {

        isday=@"寄宿";
    }else
    {
        isday=@"";
    }
    NSString *isESL=[model.isesl integerValue]==1?@"ESL":@"无ESL";
    NSArray *titleArr=@[category,isday,isESL,@"学生数",@"AP",@"SAT"];
    for (int i=0; i<titleArr.count; i++) {
        _interval=i==2?_interval_middle:_interval_min;
        CGRect _rectImg=CGRectMake(_x_p, _y_p, _diameter, _diameter);
        UIImageView *imageview=nil;
        if(i>2)
        {

            NSString *imgstr=(i-3)==0?@"schoolCard_学生数":(i-3)==1?@"schoolCard_AP":@"schoolCard_SAT";

            imageview=[[UIImageView alloc] initWithFrame:_rectImg];
            imageview.image=[UIImage imageNamed:imgstr];
            UILabel *labelImage=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(imageview.frame), CGRectGetHeight(imageview.frame))];

            labelImage.text=dataArr[i-3];
            labelImage.textAlignment=1;
            labelImage.textColor=[UIColor whiteColor];
            labelImage.font=[regular get_en_Font:12.5f];

            [imageview addSubview:labelImage];

        }else
        {
            imageview=[[UIImageView alloc] initWithFrame:_rectImg];
            imageview.image=[UIImage imageNamed:((NSDictionary *)_left_array[i])[titleArr[i]]];


        }
        [middleview addSubview:imageview];
        CGRect _rectLabel=CGRectMake(_x_p-20*_Scale, CGRectGetMaxY(imageview.frame), _diameter+40*_Scale, CGRectGetHeight(middleview.frame)-CGRectGetMaxY(imageview.frame));
        UILabel *label=[[ToolManager sharedManager] createLabelView:titleArr[i] Withrect:_rectLabel WithTextColor:[UIColor colorWithRed:136.0f/255.0f green:136.0f/255.0f blue:136.0f/255.0f alpha:1] WithTextAlignment:1 WithFont:12.0f];

        label.font=[regular getFont:10.0f];

        if([titleArr[i] isEqualToString:@"ESL"]||[titleArr[i] isEqualToString:@"无ESL"])
        {
            [label setAttributedText:[regular createAttributeString:@"ESL" andFloat:@(1.0)]];
        }else
        {
            [label setAttributedText:[regular createAttributeString:titleArr[i] andFloat:@(1.0)]];
        }
        [middleview addSubview:label];
        _x_p+=_diameter+_interval;
    }

    UIView *segmentation_view=[[UIView alloc] initWithFrame:CGRectMake((CGRectGetWidth(middleview.frame)/2)-2*_Scale, _y_p, 2*_Scale, _diameter)];
    segmentation_view.backgroundColor=_define_backview_color;
    [middleview addSubview:segmentation_view];
}

-(void)createUpView:(chooseModel *)model WithCard:(UIView *)_card
{
    upview=[[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_card.frame), 300*_Scale)];
    upview.backgroundColor=[UIColor whiteColor];
    CGSize _size_upview=upview.frame.size;
    NSArray *_array_Intro=@[[[NSString alloc]initWithFormat:@"%@年",model.setup_year],model.en_name,model.cn_name,@"",model.cn_city,model.full_address];
    UIView *dibu=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(upview.frame)-2*_Scale, CGRectGetWidth(upview.frame), 2*_Scale)];
    dibu.backgroundColor=_define_backview_color;
    [upview addSubview:dibu];
//    upview.backgroundColor=[UIColor cyanColor];
//    upview.alpha=0.2;
    CGFloat labelHeight=(_size_upview.height-60*_Scale)/6;
    CGFloat img_height=(labelHeight)*4/5;
    CGFloat img_width=img_height*13.0f/15.0f;
    [_card addSubview:upview];
    for (int i=0; i<_array_Intro.count; i++) {

        if(i==3)
        {
            UIImageView *coordIcon=[[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(upview.frame)/2)-img_width/2, 35*_Scale+i*labelHeight+(labelHeight-img_height)+6*_Scale, img_width, img_height)];
            [coordIcon setImage:[UIImage imageNamed:@"box_choose_坐标"]];

            [upview addSubview:coordIcon];

        }else
        {
            NSString *__title=i==2?[[NSString alloc] initWithFormat:@"%@",_array_Intro[i]]:_array_Intro[i];
            CGRect _rect;
            if(i==3)
            {
                _rect=CGRectMake(0, 45*_Scale+i*labelHeight, _size_upview.width, labelHeight);
            }else if(i<3)
            {
                _rect=CGRectMake(0, 45*_Scale+i*(labelHeight-2), _size_upview.width, labelHeight);

            }else
            {
                _rect=CGRectMake(0, 2+45*_Scale+4*labelHeight+(i-4)*(labelHeight-6), _size_upview.width, labelHeight);
            }

            UILabel *textlabel=[[UILabel alloc] initWithFrame:_rect];

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
                textlabel.font=[regular get_en_Font:12.0f];
                [textlabel setAttributedText:[regular createAttributeString:__title andFloat:@(1.0)]];
            }else if(i==4)
            {
                textlabel.font=[regular get_en_Font:11.0f];
                [textlabel setAttributedText:[regular createAttributeString:__title andFloat:@(1.0)]];
            }else if(i==5)
            {
                textlabel.font=[regular get_en_Font:10.0f];
                [textlabel setAttributedText:[regular createAttributeString:__title andFloat:@(-0.5)]];
            }

            textlabel.textAlignment=1;
            [upview addSubview:textlabel];
            
        }
    }
    
}
-(void)school_detail:(UIGestureRecognizer *)ges
{
    chooseModel *model=_dataArray[ges.view.tag-100];
    SchoolDetailViewController *school=[[SchoolDetailViewController alloc] init];
    school.data_dict=[[NSDictionary alloc] initWithObjectsAndKeys:model.cn_name,@"schoolName",[[NSString alloc] initWithFormat:@"%ld",(long)model.sid],@"schoolID",[NSNumber numberWithInteger:1],@"is_order_school",nil];

    [self.navigationController pushViewController:school animated:YES];
}

-(void)customCard:(chooseModel *)model WithIndex:(NSInteger )index
{

    UIView *_card=[[UIView alloc] initWithFrame:CGRectMake(20*_Scale, max_y, ScreenWidth-40*_Scale,cardHeight)];
    _card.backgroundColor=[UIColor colorWithRed:234.0f/255.0f green:234.0f/255.0f blue:234.0f/255.0f alpha:1];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(school_detail:)];
    _card.tag=100+index;
    [_card addGestureRecognizer:tap];

    [_scrollView addSubview:_card];

    _scrollView.contentSize=CGSizeMake(ScreenWidth, CGRectGetMaxY(_card.frame));

    max_y=CGRectGetMaxY(_card.frame)+44*_Scale;

    UIImageView *deleteImg=[[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth-54*_Scale)/2, CGRectGetMinY(_card.frame)-54*_Scale/2, 54*_Scale, 54*_Scale)];


    deleteImg.image=[UIImage imageNamed:@"box_choose_圆点"];
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(deleteImg.frame), CGRectGetHeight(deleteImg.frame))];
    label.textColor=[UIColor whiteColor];
    label.text=[[NSString alloc] initWithFormat:@"%ld",(index+1)];
//    label.backgroundColor=[UIColor redColor];
//    label.alpha=0.5;
    label.textAlignment=1;

    label.font=[regular get_en_Font:22.0f];
    [deleteImg addSubview:label];
    [_scrollView addSubview:deleteImg];

    [self createUpView:model WithCard:_card];
    [self createMiddleView:model WithCard:_card];
}

-(void)UIConfig
{



    for (int i=0; i<_dataArray.count; i++) {
        [self customCard:_dataArray[i] WithIndex:i];
    }
    if(_dataArray.count>0)
    {
        _scrollView.contentSize=CGSizeMake(ScreenWidth, _scrollView.contentSize.height+20);

    }

}
-(void)requestData
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameters=@{@"token":[regular getToken]};
    NSString *str=[NSString stringWithFormat:@"%@/v1/order_schools",DNS];
    [manager GET:str parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSString *html = operation.responseString;
        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *data_dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];

        if([[data_dict objectForKey:@"code"] intValue]==1)
        {
            NSArray *array=[chooseModel parsingWithJsonDataForModel:data_dict];
            if([_type isEqualToString:@"goal"])
            {
                [_dataArray addObjectsFromArray:array];
            }else if([_type isEqualToString:@"admit"])
            {
                for (chooseModel *model in array) {
                    if(model.step_no>=2)
                    {
                        [_dataArray addObject:model];
                    }
                }
                
            }

            [self UIConfig];
            if(_dataArray.count==0)
            {
                UIView *headview=[[UIView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, 70)];
                //                headview.backgroundColor=[UIColor redColor];
                UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, 30, ScreenWidth, 30)];
                //                label.backgroundColor=[UIColor grayColor];
                NSString *title=nil;
                if([_type isEqualToString:@"admit"])
                {
                    title=@"还没有录取学校，加油吧";
                }else
                {
                    title=@"还没有学校，快来添加吧";
                }
                [label setAttributedText:[regular createAttributeString:title andFloat:@(2.0)]];
                label.textColor=[UIColor lightGrayColor];
                label.textAlignment=1;
                label.font=[regular getFont:12.0f];
                [headview addSubview:label];
                [_scrollView addSubview:headview];
            }
        }else
        {
             [[ToolManager sharedManager] alertTitle_Simple:[data_dict objectForKey:@"message"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
    }];
}
-(void)popviewAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)prepareData
{
    if([_type isEqualToString:@"goal"])
    {
        self.navigationItem.titleView=[regular returnNavView:@"目标学校" withmaxwidth:230];
    }else if([_type isEqualToString:@"admit"])
    {
        self.navigationItem.titleView=[regular returnNavView:@"录取学校" withmaxwidth:230];

    }
//    _islogin=YES;
    _dataArray=[[NSMutableArray alloc] init];
    self.view.backgroundColor=_define_backview_color;
    max_y=44*_Scale;
    UIBarButtonItem *_btn=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回箭头"] style:UIBarButtonItemStylePlain target:self action:@selector(popviewAction)];
    self.navigationItem.leftBarButtonItem=_btn;
}

-(void)createScrollView
{
    _scrollView=[[UIScrollView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_scrollView];
    _scrollView.contentSize=CGSizeMake(CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame));
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     [[CustomTabbarController sharedManager] tabbarHide];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
