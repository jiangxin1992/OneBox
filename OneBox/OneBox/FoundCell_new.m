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

    NSLog(@"%ld",(long)[not.object integerValue]);
    if([[_dict objectForKey:@"row"] integerValue]<[not.object integerValue])
    {
        [self startAnimation];
    }
}
-(void)startAnimation
{
    foundModel_new *model=[_dict objectForKey:@"model"];
    if(!model.isapp)
    {

        titlelabel.alpha=0;
        titlelabel_f.alpha=0;
        _isdonghua=YES;
        [UIView beginAnimations:@"action" context:nil];
        [UIView setAnimationDuration:1];
        [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDidStopSelector:@selector(anmationStop)];
        [UIView setAnimationDelegate:self];
        titlelabel.alpha=1;
        titlelabel_f.alpha=1;

        imagebackview.frame=CGRectMake(0, 0, ScreenWidth,foundCellHeight);

        if(model.pic==nil)
        {
            imagebackview.image=[UIImage imageNamed:@"coffee-in_380"];
        }else
        {
            NSString *imageStr=nil;
            if(kIPhone4s)
            {
                imageStr=[NSString stringWithFormat:@"%@?imageView2/1/w/320/h/180",model.pic];
            }else if(kIPhone5s||kIiPhone6)
            {
                imageStr=[NSString stringWithFormat:@"%@?imageView2/1/w/640/h/360",model.pic];
            }else
            {
                imageStr=[NSString stringWithFormat:@"%@?imageView2/1/w/960/h/540",model.pic];
            }

            imagebackview.placeHolder=[UIImage imageNamed:@"coffee-in_380"];
            [imagebackview setImageWithPath:imageStr];
        }

        [UIView commitAnimations];
        NSInteger __ss=[[_dict objectForKey:@"row"] integerValue];
        self.block(__ss);
    }else
    {
        
    }
    
    
}
-(void)UIConfig
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(FoundAnimation:) name:@"FoundAnimation" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(FoundAnimation1:) name:@"FoundAnimation1" object:nil];

    _isdonghua=NO;
    imagebackview=[[DBImageView alloc] init];
    imagebackview.frame=CGRectMake(-ScreenWidth*0.05, 0, ScreenWidth*1.10,foundCellHeight);
    [self.contentView addSubview:imagebackview];

    titlelabel =[[UILabel alloc] init];
    [imagebackview addSubview:titlelabel];
    titlelabel.backgroundColor=[UIColor clearColor];
    titlelabel.font=[regular getFont:21.0f];
    titlelabel.alpha=0;
    titlelabel.textAlignment=1;
    titlelabel.textColor=[UIColor whiteColor];

    titlelabel_f =[[UILabel alloc] init];
    [imagebackview addSubview:titlelabel_f];
    titlelabel_f.backgroundColor=[UIColor clearColor];
    titlelabel_f.font=[regular getFont:15.0f];
    titlelabel_f.alpha=0;
    titlelabel_f.textAlignment=1;
    titlelabel_f.textColor=[UIColor whiteColor];
}
-(void)anmationStop
{
    _isdonghua=NO;

}
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


    if(!model.isapp)
    {
        imagebackview.frame=CGRectMake(-ScreenWidth*0.05, 0, ScreenWidth*1.10,foundCellHeight);
        titlelabel.alpha=0;
        titlelabel_f.alpha=0;
        [UIView beginAnimations:@"action" context:nil];
        [UIView setAnimationDuration:1];
        [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
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


        if(model.pic==nil)
        {
            imagebackview.image=[UIImage imageNamed:@"coffee-in_380"];
        }else
        {
            NSString *imageStr=nil;
            if(kIPhone4s)
            {
                imageStr=[NSString stringWithFormat:@"%@?imageView2/1/w/320/h/180",model.pic];
            }else if(kIPhone5s||kIiPhone6)
            {
                imageStr=[NSString stringWithFormat:@"%@?imageView2/1/w/640/h/360",model.pic];
            }else
            {
                imageStr=[NSString stringWithFormat:@"%@?imageView2/1/w/960/h/540",model.pic];
            }

            imagebackview.placeHolder=[UIImage imageNamed:@"coffee-in_380"];
            [imagebackview setImageWithPath:imageStr];
        }
        [UIView commitAnimations];
    }else
    {
        imagebackview.frame=CGRectMake(0, 0, ScreenWidth,foundCellHeight);
        titlelabel.alpha=1;
        titlelabel_f.alpha=1;

        if(model.pic==nil)
        {
            imagebackview.image=[UIImage imageNamed:@"coffee-in_380"];
        }else
        {
            NSString *imageStr=nil;
            if(kIPhone4s)
            {
                imageStr=[NSString stringWithFormat:@"%@?imageView2/1/w/320/h/180",model.pic];
            }else if(kIPhone5s||kIiPhone6)
            {
                imageStr=[NSString stringWithFormat:@"%@?imageView2/1/w/640/h/360",model.pic];
            }else
            {
                imageStr=[NSString stringWithFormat:@"%@?imageView2/1/w/960/h/540",model.pic];
            }

            imagebackview.placeHolder=[UIImage imageNamed:@"coffee-in_380"];
            [imagebackview setImageWithPath:imageStr];
        }
        
    }



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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
