//
//  FoundCell.m
//  OneBox
//
//  Created by 谢江新 on 15/2/6.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import "ArticleCell.h"

#import "ArticleModel.h"

#define foundCellHeight 360*_Scale

@implementation ArticleCell
{
    DBImageView *imagebackview;
    UILabel *titlelabel;
    UILabel *titlelabel_f;
    UIImageView *titleview;
    BOOL _isdonghua;//是否在动画中
}
#pragma mark - 初始化
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self UIConfig];
    }
    return  self;
}
#pragma mark - Setter
-(void)setDict:(NSDictionary *)dict
{
    if(_dict!=dict)
    {
        _dict=[dict copy];
    }
    ArticleModel *model=[dict objectForKey:@"model"];
    [titlelabel setAttributedText:[regular createAttributeString:model.title andFloat:@(1.0)]];
    [titlelabel sizeToFit];
    
    NSMutableAttributedString *attributedString =[[NSMutableAttributedString alloc] initWithString:model.desc attributes:@{NSKernAttributeName : @(1.0)}];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:1];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [model.desc length])];
    titlelabel_f.attributedText = attributedString;
    
    [titlelabel_f sizeToFit];
    titlelabel_f.frame=CGRectMake(40*_Scale, CGRectGetMaxY(titlelabel.frame), ScreenWidth-80*_Scale, CGRectGetHeight(titlelabel_f.frame));
    
    CGFloat _y=(160*_Scale-CGRectGetHeight(titlelabel.frame)-CGRectGetHeight(titlelabel_f.frame)-10*_Scale)/2.0f;
    titlelabel.frame=CGRectMake(40*_Scale, _y, ScreenWidth-80*_Scale, CGRectGetHeight(titlelabel.frame));
    titlelabel_f.frame=CGRectMake(CGRectGetMinX(titlelabel_f.frame), CGRectGetMaxY(titlelabel.frame)+10*_Scale, CGRectGetWidth(titlelabel_f.frame), CGRectGetHeight(titlelabel_f.frame));
    
    
    if(!model.isapp)
    {
        imagebackview.frame=CGRectMake(-ScreenWidth*0.03, 0, ScreenWidth*1.06,foundCellHeight);
        titlelabel.alpha=0;
        titlelabel_f.alpha=0;
        
        titleview.frame=CGRectMake(0, 360*_Scale, ScreenWidth, 0);
        [UIView beginAnimations:@"action" context:nil];
        [UIView setAnimationDuration:0.6];
        [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
        if([[_dict objectForKey:@"row"] integerValue]<2)
        {
            _isdonghua=YES;
            [UIView setAnimationDidStopSelector:@selector(anmationStop)];
            NSInteger __ss=[[_dict objectForKey:@"row"] integerValue];
            self.block(__ss);
        }
        [UIView setAnimationDelegate:self];
        if([[_dict objectForKey:@"row"] integerValue]<2)
        {
            titleview.frame=CGRectMake(0, 200*_Scale, ScreenWidth, 160*_Scale);
            imagebackview.frame=CGRectMake(0, 0, ScreenWidth,foundCellHeight);
        }
        
        
        if(model.thumb_url==nil)
        {
            imagebackview.image=[UIImage imageNamed:@"found_newsearch_back_360"];
        }else
        {
            NSString *imageStr=nil;
            if(kIPhone4s)
            {
                imageStr=[NSString stringWithFormat:@"%@?imageView2/1/w/320/h/180",model.thumb_url];
            }else if(kIPhone5s||kIPhone6)
            {
                imageStr=[NSString stringWithFormat:@"%@?imageView2/1/w/640/h/360",model.thumb_url];
            }else
            {
                imageStr=[NSString stringWithFormat:@"%@?imageView2/1/w/960/h/540",model.thumb_url];
            }
            
            imagebackview.placeHolder=[UIImage imageNamed:@"found_newsearch_back_360"];
            [imagebackview setImageWithPath:imageStr];
        }
        [UIView commitAnimations];
    }else
    {
        imagebackview.frame=CGRectMake(0, 0, ScreenWidth,foundCellHeight);
        titlelabel.alpha=1;
        titlelabel_f.alpha=1;
        titleview.frame=CGRectMake(0, 200*_Scale, ScreenWidth, 160*_Scale);
        if(model.thumb_url==nil)
        {
            imagebackview.image=[UIImage imageNamed:@"found_newsearch_back_360"];
        }else
        {
            NSString *imageStr=nil;
            if(kIPhone4s)
            {
                imageStr=[NSString stringWithFormat:@"%@?imageView2/1/w/320/h/180",model.thumb_url];
            }else if(kIPhone5s||kIPhone6)
            {
                imageStr=[NSString stringWithFormat:@"%@?imageView2/1/w/640/h/360",model.thumb_url];
            }else
            {
                imageStr=[NSString stringWithFormat:@"%@?imageView2/1/w/960/h/540",model.thumb_url];
            }
            
            imagebackview.placeHolder=[UIImage imageNamed:@"found_newsearch_back_360"];
            [imagebackview setImageWithPath:imageStr];
        }
        
    }
    
}
#pragma mark - UIConfig
-(void)UIConfig
{
    _isdonghua=NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ArticleAnimation:) name:@"ArticleAnimation" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ArticleAnimation1:) name:@"ArticleAnimation1" object:nil];
    imagebackview=[[DBImageView alloc] init];
    imagebackview.frame=CGRectMake(-ScreenWidth*0.03, 0, ScreenWidth*1.06,foundCellHeight);
    [self.contentView addSubview:imagebackview];
    
    titleview=[[UIImageView alloc] initWithFrame:CGRectMake(0, 360*_Scale, ScreenWidth, 0)];
    titleview.image=[UIImage imageNamed:@"article_back_new"];
    
    [self.contentView addSubview:titleview];
    
    titlelabel =[[UILabel alloc] initWithFrame:CGRectMake(40*_Scale, 29*_Scale, ScreenWidth-80*_Scale, 0)];
    [titleview addSubview:titlelabel];
    titlelabel.backgroundColor=[UIColor clearColor];
    titlelabel.font=[regular getFont:15.0f];
    titlelabel.textAlignment=0;
    titlelabel.alpha=0;
    titlelabel.textColor=[UIColor whiteColor];
    
    titlelabel_f =[[UILabel alloc] initWithFrame:CGRectMake(40*_Scale, CGRectGetMaxY(titlelabel.frame), ScreenWidth-80*_Scale, 0)];
    [titleview addSubview:titlelabel_f];
    titlelabel_f.alpha=0;
    titlelabel_f.backgroundColor=[UIColor clearColor];
    titlelabel_f.font=[regular getFont:10.0f];
    titlelabel_f.numberOfLines=2;
    titlelabel_f.textAlignment=0;
    titlelabel_f.textColor=[UIColor whiteColor];
}
#pragma mark - SomeAction
-(void)ArticleAnimation1:(NSNotification *)not
{
//    监测
    if(!((ArticleModel *)[_dict objectForKey:@"model"]).isapp&&!_isdonghua)
    {
        titlelabel.alpha=0;
        titlelabel_f.alpha=0;
    }
}

-(void)ArticleAnimation:(NSNotification *)not
{
    if([[_dict objectForKey:@"row"] integerValue]<[not.object integerValue])
    {
        [self startAnimation];
    }
}

-(void)startAnimation
{
    ArticleModel *model=[_dict objectForKey:@"model"];
    if(!model.isapp)
    {
        titlelabel.alpha=0;
        titlelabel_f.alpha=0;
        titleview.frame=CGRectMake(0, 360*_Scale, ScreenWidth, 0);
        _isdonghua=YES;
        [UIView beginAnimations:@"action" context:nil];
        [UIView setAnimationDuration:0.6];
        [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDidStopSelector:@selector(anmationStop)];
        [UIView setAnimationDelegate:self];

        titleview.frame=CGRectMake(0, 200*_Scale, ScreenWidth, 160*_Scale);
        imagebackview.frame=CGRectMake(0, 0, ScreenWidth,foundCellHeight);

        if(model.thumb_url==nil)
        {
            imagebackview.image=[UIImage imageNamed:@"found_newsearch_back_360"];
        }else
        {
            NSString *imageStr=nil;
            if(kIPhone4s)
            {
                imageStr=[NSString stringWithFormat:@"%@?imageView2/1/w/320/h/180",model.thumb_url];
            }else if(kIPhone5s||kIPhone6)
            {
                imageStr=[NSString stringWithFormat:@"%@?imageView2/1/w/640/h/360",model.thumb_url];
            }else
            {
                imageStr=[NSString stringWithFormat:@"%@?imageView2/1/w/960/h/540",model.thumb_url];
            }
            imagebackview.placeHolder=[UIImage imageNamed:@"found_newsearch_back_360"];
            [imagebackview setImageWithPath:imageStr];
        }

        [UIView commitAnimations];
        NSInteger __ss=[[_dict objectForKey:@"row"] integerValue];
        self.block(__ss);
    }
}

-(void)anmationStop
{
    _isdonghua=NO;
    [UIView beginAnimations:@"action" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDelegate:self];
    titlelabel.alpha=1;
    titlelabel_f.alpha=1;
    [UIView commitAnimations];
}

#pragma mark - Other
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
