//
//  Sousuo_card_Cell.m
//  OneBox
//
//  Created by 谢江新 on 15/12/18.
//  Copyright © 2015年 谢江新. All rights reserved.
//

#import "Sousuo_card_Cell.h"

#import "foundModel.h"

#define foundCellHeight 400*_Scale

@implementation Sousuo_card_Cell
{
    DBImageView *imagebackview;
    UILabel *titlelabel;
    UILabel *titlelabel_f;
    UILabel *cn_name_label;
    UIImageView *titleview;
    BOOL _isdonghua;//是否在动画中

}
-(void)ArticleAnimation1:(NSNotification *)not
{
    //    监测
    if(!((foundModel *)[_dict objectForKey:@"model"]).isapp&&!_isdonghua)
    {
        titlelabel.alpha=0;
        titlelabel_f.alpha=0;
        cn_name_label.alpha=0;
    }
}
-(void)ArticleAnimation:(NSNotification *)not
{
    if([[_dict objectForKey:@"row"] integerValue]<[[not.object objectForKey:@"num"] integerValue]&&[[not.object objectForKey:@"key"] isEqualToString:[_dict objectForKey:@"char"]]&&![[not.object objectForKey:@"suoyin"] boolValue])
    {
        [self startAnimation];
    }
}

-(void)startAnimation
{
    foundModel *model=[_dict objectForKey:@"model"];
    if(!model.isapp)
    {
        titlelabel.alpha=0;
        titlelabel_f.alpha=0;
        cn_name_label.alpha=0;
        titleview.frame=CGRectMake(0, 400*_Scale, ScreenWidth, 0);
        _isdonghua=YES;
        [UIView beginAnimations:@"action" context:nil];
        [UIView setAnimationDuration:0.6];
        [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDidStopSelector:@selector(anmationStop)];
        [UIView setAnimationDelegate:self];

        titleview.frame=CGRectMake(0, 240*_Scale, ScreenWidth, 160*_Scale);
        imagebackview.frame=CGRectMake(0, 0, ScreenWidth,foundCellHeight);

        if(model.thumb_image_url==nil)
        {
            imagebackview.image=[UIImage imageNamed:@"found_sousuo_back"];
        }else
        {
            NSString *imageStr=nil;
            if(kIPhone4s)
            {
                imageStr=[NSString stringWithFormat:@"%@?imageView2/1/w/320/h/200",model.thumb_image_url];
            }else if(kIPhone5s||kIPhone6)
            {
                imageStr=[NSString stringWithFormat:@"%@?imageView2/1/w/640/h/400",model.thumb_image_url];
            }else
            {
                imageStr=[NSString stringWithFormat:@"%@?imageView2/1/w/960/h/600",model.thumb_image_url];
            }

            imagebackview.placeHolder=[UIImage imageNamed:@"found_sousuo_back"];
            [imagebackview setImageWithPath:imageStr];
        }

        [UIView commitAnimations];
        self.block([[_dict objectForKey:@"row"] integerValue],[[_dict objectForKey:@"section"] integerValue],[_dict objectForKey:@"type"]);
    }
}
-(void)UIConfig
{
    _isdonghua=NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ArticleAnimation:) name:@"SousuoAnimation" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ArticleAnimation1:) name:@"SousuoAnimation1" object:nil];

    imagebackview=[[DBImageView alloc] init];
    imagebackview.frame=CGRectMake(-ScreenWidth*0.03, 0, ScreenWidth*1.06,foundCellHeight);
    [self.contentView addSubview:imagebackview];


    titleview=[[UIImageView alloc] initWithFrame:CGRectMake(0, 400*_Scale, ScreenWidth, 0)];
    titleview.image=[UIImage imageNamed:@"found_card_titleview1"];

    [self.contentView addSubview:titleview];
    //30
    // 30 44 44
    titlelabel =[[UILabel alloc] initWithFrame:CGRectMake(40*_Scale, 30*_Scale, ScreenWidth-40*_Scale, 30*_Scale)];
    [titleview addSubview:titlelabel];
    titlelabel.backgroundColor=[UIColor clearColor];
    titlelabel.font=[regular get_en_Font:14.0f];
    titlelabel.textAlignment=0;
    titlelabel.alpha=0;
    titlelabel.textColor=[UIColor whiteColor];


    cn_name_label =[[UILabel alloc] initWithFrame:CGRectMake(40*_Scale, CGRectGetMaxY(titlelabel.frame), ScreenWidth-40*_Scale, 44*_Scale)];
    [titleview addSubview:cn_name_label];
    cn_name_label.backgroundColor=[UIColor clearColor];
    cn_name_label.font=[regular getFont:14.0f];
    cn_name_label.textAlignment=0;
    cn_name_label.alpha=0;
    cn_name_label.textColor=[UIColor whiteColor];



    titlelabel_f =[[UILabel alloc] initWithFrame:CGRectMake(40*_Scale, CGRectGetMaxY(cn_name_label.frame), ScreenWidth-40*_Scale, 44*_Scale)];
    [titleview addSubview:titlelabel_f];
    titlelabel_f.alpha=0;
    titlelabel_f.backgroundColor=[UIColor clearColor];
    titlelabel_f.font=[regular getFont:12.0f];
    titlelabel_f.numberOfLines=2;
    titlelabel_f.textAlignment=0;
    titlelabel_f.textColor=[UIColor whiteColor];
}
-(void)setDict:(NSDictionary *)dict
{
    if(_dict!=dict)
    {
        _dict=[dict copy];
    }

    foundModel *model=[dict objectForKey:@"model"];
    titlelabel.text=model.en_name;

    [cn_name_label setAttributedText:[regular createAttributeString:model.cn_name andFloat:@(2.0)]];
    [titlelabel_f setAttributedText:[regular createAttributeString:[[NSString alloc] initWithFormat:@"%@，%@",model.city,model.state] andFloat:@(2.0)]];
    if(!model.isapp)
    {
        imagebackview.frame=CGRectMake(-ScreenWidth*0.03, 0, ScreenWidth*1.06,foundCellHeight);
        titlelabel.alpha=0;
        titlelabel_f.alpha=0;
        cn_name_label.alpha=0;

        titleview.frame=CGRectMake(0, 400*_Scale, ScreenWidth, 0);
        [UIView beginAnimations:@"action" context:nil];
        [UIView setAnimationDuration:0.6];
        [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
        if(([[_dict objectForKey:@"row"] integerValue] <= [[_dict objectForKey:@"m_row"] integerValue] && [[_dict objectForKey:@"section"] integerValue] <= [[_dict objectForKey:@"m_section"] integerValue]) || [[_dict objectForKey:@"suoyin"] boolValue])
        {
            _isdonghua=YES;
            [UIView setAnimationDidStopSelector:@selector(anmationStop)];
            self.block([[_dict objectForKey:@"row"] integerValue],[[_dict objectForKey:@"section"] integerValue],[_dict objectForKey:@"type"]);

        }
        [UIView setAnimationDelegate:self];
        if(([[_dict objectForKey:@"row"] integerValue] <= [[_dict objectForKey:@"m_row"] integerValue] && [[_dict objectForKey:@"section"] integerValue] <= [[_dict objectForKey:@"m_section"] integerValue]) || [[_dict objectForKey:@"suoyin"] boolValue])
        {
            titleview.frame=CGRectMake(0, 240*_Scale, ScreenWidth, 160*_Scale);
            imagebackview.frame=CGRectMake(0, 0, ScreenWidth,foundCellHeight);
        }


        if(model.thumb_image_url==nil)
        {
            imagebackview.image=[UIImage imageNamed:@"found_sousuo_back"];
        }else
        {
            NSString *imageStr=nil;
            if(kIPhone4s)
            {
                imageStr=[NSString stringWithFormat:@"%@?imageView2/1/w/320/h/200",model.thumb_image_url];
            }else if(kIPhone5s||kIPhone6)
            {
                imageStr=[NSString stringWithFormat:@"%@?imageView2/1/w/640/h/400",model.thumb_image_url];
            }else
            {
                imageStr=[NSString stringWithFormat:@"%@?imageView2/1/w/960/h/600",model.thumb_image_url];
            }

            imagebackview.placeHolder=[UIImage imageNamed:@"found_sousuo_back"];
            [imagebackview setImageWithPath:imageStr];
        }
        [UIView commitAnimations];
    }else
    {
        imagebackview.frame=CGRectMake(0, 0, ScreenWidth,foundCellHeight);
        titlelabel.alpha=1;
        titlelabel_f.alpha=1;
        cn_name_label.alpha=1;

        titleview.frame=CGRectMake(0, 240*_Scale, ScreenWidth, 160*_Scale);
        if(model.thumb_image_url==nil)
        {
            imagebackview.image=[UIImage imageNamed:@"found_sousuo_back"];
        }else
        {
            NSString *imageStr=nil;
            if(kIPhone4s)
            {
                imageStr=[NSString stringWithFormat:@"%@?imageView2/1/w/320/h/200",model.thumb_image_url];
            }else if(kIPhone5s||kIPhone6)
            {
                imageStr=[NSString stringWithFormat:@"%@?imageView2/1/w/640/h/400",model.thumb_image_url];
            }else
            {
                imageStr=[NSString stringWithFormat:@"%@?imageView2/1/w/960/h/600",model.thumb_image_url];
            }

            imagebackview.placeHolder=[UIImage imageNamed:@"found_sousuo_back"];
            [imagebackview setImageWithPath:imageStr];
        }

    }
    

}

-(void)anmationStop
{

    [UIView beginAnimations:@"action" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDidStopSelector:@selector(anmationStop1)];
    [UIView setAnimationDelegate:self];
    titlelabel.alpha=1;
    titlelabel_f.alpha=1;
    cn_name_label.alpha=1;
    [UIView commitAnimations];
}
-(void)anmationStop1
{
    _isdonghua=NO;
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
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

@end
