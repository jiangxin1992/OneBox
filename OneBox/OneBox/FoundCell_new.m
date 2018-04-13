//
//  FoundCell.m
//  OneBox
//
//  Created by 谢江新 on 15/2/6.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import "FoundCell_new.h"

#import "foundModel_new.h"

#define foundCellHeight 380*_Scale

@implementation FoundCell_new
{
    DBImageView *imagebackview;
    UILabel *titlelabel;
    UILabel *titlelabel_f;
    BOOL _isdonghua;//是否在动画中
}

#pragma mark - --------------生命周期--------------
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self SomePrepare];
        [self UIConfig];
    }
    return  self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
#pragma mark - --------------SomePrepare--------------
- (void)SomePrepare
{
    [self PrepareData];
    [self PrepareUI];
}
- (void)PrepareData{

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(FoundAnimation:) name:@"FoundAnimation" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(FoundAnimation1:) name:@"FoundAnimation1" object:nil];

    _isdonghua=NO;
}
- (void)PrepareUI{}

#pragma mark - --------------UIConfig----------------------
-(void)UIConfig
{
    imagebackview=[[DBImageView alloc] init];
    [self.contentView addSubview:imagebackview];
    imagebackview.frame=CGRectMake(-ScreenWidth*0.05, 0, ScreenWidth*1.10,foundCellHeight);

    titlelabel =[UILabel getLabelWithAlignment:1 WithTitle:nil WithFont:21.0f WithTextColor:[UIColor whiteColor] WithSpacing:0];;
    [imagebackview addSubview:titlelabel];
    titlelabel.backgroundColor=[UIColor clearColor];
    titlelabel.alpha=0;

    titlelabel_f =[UILabel getLabelWithAlignment:1 WithTitle:nil WithFont:15.0f WithTextColor:[UIColor whiteColor] WithSpacing:0];
    [imagebackview addSubview:titlelabel_f];
    titlelabel_f.backgroundColor=[UIColor clearColor];
    titlelabel_f.alpha=0;
}
#pragma mark - --------------UpdateUI----------------------
-(void)setDict:(NSDictionary *)dict
{
    if(_dict!=dict)
    {
        _dict=[dict copy];
    }
    foundModel_new *model=[_dict objectForKey:@"model"];

    [titlelabel setAttributedText:[regular createAttributeString:model.title andFloat:@(4.0)]];
    [titlelabel sizeToFit];
    titlelabel.frame=CGRectMake((ScreenWidth-CGRectGetWidth(titlelabel.frame))/2.0f, (CGRectGetHeight(imagebackview.frame)-CGRectGetHeight(titlelabel.frame))/2.0f,CGRectGetWidth(titlelabel.frame) ,CGRectGetHeight(titlelabel.frame));

    [titlelabel_f setAttributedText:[regular createAttributeString:model.f_title andFloat:@(2.0)]];
    [titlelabel_f sizeToFit];
    titlelabel_f.frame=CGRectMake(0, CGRectGetMaxY(titlelabel.frame)+10,ScreenWidth,CGRectGetHeight(titlelabel.frame));

    if([NSString isNilOrEmpty:model.pic])
    {
        imagebackview.image=[UIImage imageNamed:@"coffee-in_380"];
    }else
    {
        NSString *imageStr=nil;
        if(kIPhone4s)
        {
            imageStr=[NSString stringWithFormat:@"%@?imageView2/1/w/320/h/180",model.pic];
        }else if(kIPhone5s||kIPhone6)
        {
            imageStr=[NSString stringWithFormat:@"%@?imageView2/1/w/640/h/360",model.pic];
        }else
        {
            imageStr=[NSString stringWithFormat:@"%@?imageView2/1/w/960/h/540",model.pic];
        }

        imagebackview.placeHolder=[UIImage imageNamed:@"coffee-in_380"];
        [imagebackview setImageWithPath:imageStr];
    }

    if(!model.isapp)
    {
        imagebackview.frame=CGRectMake(-ScreenWidth*0.05, 0, ScreenWidth*1.10,foundCellHeight);
        titlelabel.alpha=0;
        titlelabel_f.alpha=0;

        [UIView beginAnimations:@"action" context:nil];
        [UIView setAnimationDuration:1];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        if([[_dict objectForKey:@"row"] integerValue]<1)
        {
            _isdonghua=YES;
            [UIView setAnimationDidStopSelector:@selector(anmationStop)];
            NSInteger __ss=[[_dict objectForKey:@"row"] integerValue];
            self.block(__ss);
        }
        [UIView setAnimationDelegate:self];
        if([[_dict objectForKey:@"row"] integerValue]<1)
        {
            imagebackview.frame=CGRectMake(0, 0, ScreenWidth,foundCellHeight);
            titlelabel.alpha=1;
            titlelabel_f.alpha=1;
        }
        [UIView commitAnimations];

    }else
    {
        imagebackview.frame=CGRectMake(0, 0, ScreenWidth,foundCellHeight);
        titlelabel.alpha=1;
        titlelabel_f.alpha=1;
    }
}

#pragma mark - --------------系统代理----------------------

#pragma mark - --------------自定义响应----------------------
-(void)FoundAnimation1:(NSNotification *)not
{
    //    监测
    if(!((foundModel_new *)[_dict objectForKey:@"model"]).isapp&&!_isdonghua)
    {
        titlelabel.alpha=0;
        titlelabel_f.alpha=0;
    }
}
-(void)FoundAnimation:(NSNotification *)not
{
    JXLOG(@"%ld",(long)[not.object integerValue]);
    if([[_dict objectForKey:@"row"] integerValue]<[not.object integerValue])
    {
        [self startAnimation];
    }
}

#pragma mark - --------------自定义方法----------------------
-(void)startAnimation
{
    foundModel_new *model=[_dict objectForKey:@"model"];
    if(!model.isapp)
    {

        titlelabel.alpha=0;
        titlelabel_f.alpha=0;
        _isdonghua=YES;

        if(model.pic==nil)
        {
            imagebackview.image=[UIImage imageNamed:@"coffee-in_380"];
        }else
        {
            NSString *imageStr=nil;
            if(kIPhone4s)
            {
                imageStr=[NSString stringWithFormat:@"%@?imageView2/1/w/320/h/180",model.pic];
            }else if(kIPhone5s||kIPhone6)
            {
                imageStr=[NSString stringWithFormat:@"%@?imageView2/1/w/640/h/360",model.pic];
            }else
            {
                imageStr=[NSString stringWithFormat:@"%@?imageView2/1/w/960/h/540",model.pic];
            }

            imagebackview.placeHolder=[UIImage imageNamed:@"coffee-in_380"];
            [imagebackview setImageWithPath:imageStr];
        }

        [UIView beginAnimations:@"action" context:nil];
        [UIView setAnimationDuration:1];
        [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDidStopSelector:@selector(anmationStop)];
        [UIView setAnimationDelegate:self];
        titlelabel.alpha=1;
        titlelabel_f.alpha=1;

        imagebackview.frame=CGRectMake(0, 0, ScreenWidth,foundCellHeight);

        [UIView commitAnimations];
        NSInteger __ss=[[_dict objectForKey:@"row"] integerValue];
        self.block(__ss);
    }
}
-(void)anmationStop
{
    _isdonghua=NO;
}

#pragma mark - --------------other----------------------


@end
