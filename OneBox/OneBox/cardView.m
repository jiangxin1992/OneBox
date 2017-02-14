//
//  cardView.m
//  map!!!
//
//  Created by 谢江新 on 15/3/4.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import "cardView.h"

#import "surveyModel.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define _Scale [UIScreen mainScreen].bounds.size.width/640.0f

@implementation cardView
{
    UIView *upView;
    UIView *downView;
    NSMutableArray *upViewArray;
    NSMutableArray *downViewImgArray;
    NSMutableArray *downViewTitleArray;
    NSMutableArray *downViewRightTitleArray;
}
static cardView *_m = nil;
+(id)sharedManager
{
    dispatch_once_t once = 0;
    dispatch_once(&once, ^{
        if (!_m) {
            _m = [[cardView alloc]init];
        }
    });
    
    return _m;
}
+(id)allocWithZone:(struct _NSZone *)zone
{
    if (!_m) {
        _m = [super allocWithZone:zone];
    }
    return _m;
}
-(id)init
{
    if(self=[super init])
    {


        upViewArray=[[NSMutableArray alloc] init];
        downViewImgArray=[[NSMutableArray alloc] init];
        downViewTitleArray=[[NSMutableArray alloc] init];
        downViewRightTitleArray=[[NSMutableArray alloc] init];
        


        [self setFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];

        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backViewtouch:)];
        [self addGestureRecognizer:tap];
        self.userInteractionEnabled=YES;
        self.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.63];
        _card=[[UIView alloc] initWithFrame:CGRectMake(42*_Scale,-80*_Scale+(CGRectGetHeight(self.frame)/2)-(310*_Scale)/2, CGRectGetWidth(self.frame)-(42+46)*_Scale, 310*_Scale)];
        UITapGestureRecognizer *tap1=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(card_action:)];
        [_card addGestureRecognizer:tap1];
        [self addSubview:_card];
        _card.userInteractionEnabled=YES;
        _card.backgroundColor=[UIColor whiteColor];
        
        
        upView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_card.frame), 175*_Scale)];
        upView.backgroundColor=[UIColor colorWithRed:82.0f/255.0f green:190.0f/255.0f blue:215.0f/255.0f alpha:1];;
        [_card addSubview:upView];
        
        downView=[[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(upView.frame), CGRectGetMaxY(upView.frame), CGRectGetWidth(upView.frame), CGRectGetHeight(_card.frame)-CGRectGetHeight(upView.frame))];
        downView.backgroundColor=[UIColor whiteColor];
        [_card addSubview:downView];


        [self upViewConfig];
        [self downViewConfig];
    }
    return self;
}
-(void)backViewtouch:(UIGestureRecognizer *)sender
{
    
    [self removeView:YES];
}
-(void)upViewConfig
{
    
    CGFloat _y_p=30*_Scale;
    for (int i=0;i<4; i++) {
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(20*_Scale, _y_p, CGRectGetWidth(upView.frame)-20*_Scale, (CGRectGetHeight(upView.frame)-36*_Scale)/4)];



        _y_p=CGRectGetMaxY(label.frame);
        [upViewArray addObject:label];
        label.textAlignment=0;
        label.textColor=[UIColor whiteColor];
        [upView addSubview:label];
    }
    
//    schoolCard_图标@x
    UIImageView *coordImage=[[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(upView.frame)/2)-66*_Scale*80/(92*2), -30*_Scale,66*_Scale*80/92 , 66*_Scale)];
    coordImage.image=[UIImage imageNamed:@"schoolCard_图标"];
    [upView addSubview:coordImage];
    
    
//    for (int i=0; i<1; i++) {
//        NSString *imageName=i==0?@"schoolCard_关闭icon":@"schoolCard_向右icon";
//        UIImageView *rightImage=[[UIImageView alloc] initWithFrame:(CGRectMake(CGRectGetMaxX(_card.frame)-35*_Scale, CGRectGetMinY(_card.frame)-46*_Scale/2+i*(26+58)*_Scale, 58*_Scale, 58*_Scale))];
//
//        rightImage.tag=100+i;
//        rightImage.userInteractionEnabled=YES;
//
//        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(card_action:)];
//        
//        [rightImage addGestureRecognizer:tap];
//        rightImage.image=[UIImage imageNamed:imageName];
//        [self addSubview:rightImage];
//       
//    }

    
}
-(void)removeView:(BOOL)isHide
{
    if(isHide)
    {
        self.hidden=YES;
    }else
    {
        self.hidden=NO;
    }
}
-(void)card_action:(UIGestureRecognizer *)sender
{
    
    if(sender.view.tag==100)
    {
//        [self removeView:YES];
    }else
    {
        self.block();
    }
}
-(void)downViewConfig
{
    
    CGFloat _distance=0;
    
    CGFloat _y_min=26*_Scale;
    
    CGFloat _diameter=(CGRectGetWidth(_card.frame)-30*_Scale*4-48*_Scale-2*18*_Scale)/6.0f;
    CGFloat _x_p=30*_Scale;
    for (int i=0; i<6; i++) {
        if(i<2)
        {
            _distance=30*_Scale;
        }else if(i==2)
        {
            _distance=48*_Scale;
        }else
        {
            _distance=18*_Scale;
        }

        UIImageView *_imageview=[[UIImageView alloc] initWithFrame:CGRectMake(_x_p, _y_min, _diameter, _diameter)];
//        if(i<3)
//        {
            _imageview.tag=500+i;
//        }
        _x_p+=_diameter+_distance;

        [downView addSubview:_imageview];
        [downViewImgArray addObject:_imageview];
        if(i==2)
        {
            UIView *_middleView=[[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_imageview.frame)+24*_Scale-1*_Scale, 26*_Scale, 2*_Scale, _diameter)];
            _middleView.backgroundColor=_define_backview_color;
            
            [downView addSubview:_middleView];
        }
        
        UILabel *_label=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_imageview.frame)-10, CGRectGetMaxY(_imageview.frame), CGRectGetWidth(_imageview.frame)+20, CGRectGetHeight(downView.frame)-CGRectGetMaxY(_imageview.frame))];


        if(i>2)
        {
            NSString *_imageName=i==3?@"schoolCard_学生数":i==4?@"schoolCard_AP":@"schoolCard_SAT";
            _imageview.image=[UIImage imageNamed:_imageName];
            NSString *_content=i==3?@"学生数":i==4?@"AP数":@"SAT均分";

            _label.text=_content;
        }
       
        _label.textAlignment=1;
        _label.textColor=[UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1];
        _label.font=[regular getFont:9.5f];


        [downView addSubview:_label];
        [downViewTitleArray addObject:_label];
        if(i>2)
        {
            UILabel *__label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_imageview.frame), CGRectGetHeight(_imageview.frame))];
            __label.textAlignment=1;
            __label.textColor=[UIColor whiteColor];
            __label.font=[regular get_en_Font:12.0f];

            [_imageview addSubview:__label];
            [downViewRightTitleArray addObject:__label];

        }
        
    }
    
    
    
}
-(void)setdata:(surveyModel *)model
{
    for (int i=0; i<upViewArray.count; i++) {
        NSString *_content=i==0?[[NSString alloc] initWithFormat:@"%@年",model.setup_year]:i==1?model.en_name:i==2?model.cn_name:model.full_address;
    
        UILabel *_label=(UILabel *)upViewArray[i];
        if(i==0)
        {
             [_label setAttributedText:[regular createAttributeString:_content andFloat:@(1.0)]];
        }else if(i==2)
        {
            [_label setAttributedText:[regular createAttributeString:_content andFloat:@(2.0)]];
        }else
        {
             _label.text=_content;

        }

        CGFloat _font=i==0?11.0f:i==1?15.0f:i==2?12.0f:10.0f;
        if(i==2)
        {

            _label.font= [regular getFont:_font];

        }else
        {
            _label.font= [regular get_en_Font:_font];

        }


    }
    for (int i=0; i<downViewRightTitleArray.count; i++) {
        UILabel *_label=downViewRightTitleArray[i];

        NSString *_content=i==0?model.total_students:i==1?model.ap_count:model.sat_avg;
        _label.text=_content;
        UIImageView *imageview=(UIImageView *)[self viewWithTag:503+i];
        if([_content isEqualToString:@""])
        {
            imageview.image=[UIImage imageNamed:@"schoolCard_ap灰色"];

        }else
        {
            if(i==0)
            {

             imageview.image=[UIImage imageNamed:@"schoolCard_学生数"];

            }else if(i==1)
            {
             imageview.image=[UIImage imageNamed:@"schoolCard_AP"];

            }else if(i==2)
            {
             imageview.image=[UIImage imageNamed:@"schoolCard_SAT"];

            }


        }

        
    }
    
    NSString *_category=nil;
    NSString *_categoryImgName=nil;
    NSString *_isboardind=nil;
    NSString *_isboardindImgName=nil;
    NSString *_isESL=nil;
    NSString *_isESLImgName=nil;
    NSString *_categoryNum=model.student_sex_limit;
    if([_categoryNum isEqualToString:@"2"])
    {
        _category=@"混 校";
        _categoryImgName=@"screenShcool_混校";
    }else if([_categoryNum isEqualToString:@"1"])
    {
        _category=@"男 校";
        _categoryImgName=@"screenShcool_男校";
    }else if([_categoryNum isEqualToString:@"0"])
    {
        _category=@"女 校";
        _categoryImgName=@"screenShcool_女校";
    }else
    {
        UIImageView *imageview=(UIImageView *)[self viewWithTag:500];
        imageview.backgroundColor=[UIColor whiteColor];
        [imageview setImage:[UIImage imageNamed:@""]];
        _category=@"";
        _categoryImgName=@"";
    }

    
    if([model.boarding_day isEqualToString:@"boarding"])
    {
        _isboardind=@"寄 宿";
        _isboardindImgName=@"screenShcool_寄宿";
    }else if([model.boarding_day isEqualToString:@"day"])
    {
        _isboardind=@"走 读";
        _isboardindImgName=@"screenShcool_走读";
    }else if([model.boarding_day isEqualToString:@"all"])
    {
        _isboardind=@"寄 宿";
        _isboardindImgName=@"screenShcool_寄宿";

    }
    else
    {
        UIImageView *imageview=(UIImageView *)[self viewWithTag:501];
        imageview.backgroundColor=[UIColor whiteColor];
        [imageview setImage:[UIImage imageNamed:@""]];
        _isboardind=@"";
        _isboardindImgName=@"";
    }

    if ([model.isesl isEqualToString:@"1"]) {
        _isESL=@"ESL";
        _isESLImgName=@"screenShcool_esl";
    }else if([model.isesl isEqualToString:@"0"])
    {
        _isESL=@"无ESL";
        _isESLImgName=@"screenShcool_无esl1";
    }else
    {
        UIImageView *imageview=(UIImageView *)[self viewWithTag:502];
        imageview.backgroundColor=[UIColor whiteColor];
        [imageview setImage:[UIImage imageNamed:@""]];
        _isESL=@"";
        _isESLImgName=@"";

    }
//    __string(total_students);
    //ap课程数量(int)
//    __string(ap_count);
    //sat平均分double
//    __string(sat_avg);


    NSArray *title_array=@[_category,_isboardind,_isESL];
    NSArray *img_array=@[_categoryImgName,_isboardindImgName,_isESLImgName];
    for (int i=0; i<3; i++) {

        UIImageView *_imageview=downViewImgArray[i];
        UILabel *_label=downViewTitleArray[i];

        if([title_array[i] isEqualToString:@""])
        {
            if(i<3)
            {
                _imageview.backgroundColor=[UIColor whiteColor];

            }

        }else
        {
            _imageview.image=[UIImage imageNamed:img_array[i]];
        }

        if([title_array[i] isEqualToString:@"无ESL"]||[title_array[i] isEqualToString:@"ESL"])
        {
            _label.text=@"ESL";

        }else
        {
            _label.text=title_array[i];
        }
    }
    
    
    
}
@end
