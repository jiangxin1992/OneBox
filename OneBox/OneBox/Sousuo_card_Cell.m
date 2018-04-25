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

@interface Sousuo_card_Cell()

@property (nonatomic, strong) DBImageView *imagebackview;
@property (nonatomic, strong) UILabel *titlelabel;
@property (nonatomic, strong) UILabel *titlelabel_f;
@property (nonatomic, strong) UILabel *cn_name_label;
@property (nonatomic, strong) UIImageView *titleview;
@property (nonatomic, strong) NSNumber *isdonghua;//是否在动画中

@end


@implementation Sousuo_card_Cell
#pragma mark - --------------生命周期--------------
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
#pragma mark - --------------SomePrepare--------------
- (void)SomePrepare
{
    [self PrepareData];
    [self PrepareUI];
}
- (void)PrepareData{}
- (void)PrepareUI{}

#pragma mark - --------------UIConfig----------------------
-(void)UIConfig
{
    _isdonghua = @(NO);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ArticleAnimation:) name:@"SousuoAnimation" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ArticleAnimation1:) name:@"SousuoAnimation1" object:nil];

    _imagebackview = [[DBImageView alloc] init];
    _imagebackview.frame = CGRectMake(-ScreenWidth*0.03, 0, ScreenWidth*1.06,foundCellHeight);
    [self.contentView addSubview:_imagebackview];


    _titleview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 400*_Scale, ScreenWidth, 0)];
    _titleview.image = [UIImage imageNamed:@"found_card_titleview1"];

    [self.contentView addSubview:_titleview];

    _titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(40*_Scale, 30*_Scale, ScreenWidth-40*_Scale, 30*_Scale)];
    [_titleview addSubview:_titlelabel];
    _titlelabel.backgroundColor = [UIColor clearColor];
    _titlelabel.font = [regular get_en_Font:14.0f];
    _titlelabel.textAlignment = 0;
    _titlelabel.alpha = 0;
    _titlelabel.textColor = [UIColor whiteColor];

    _cn_name_label = [[UILabel alloc] initWithFrame:CGRectMake(40*_Scale, CGRectGetMaxY(_titlelabel.frame), ScreenWidth-40*_Scale, 44*_Scale)];
    [_titleview addSubview:_cn_name_label];
    _cn_name_label.backgroundColor = [UIColor clearColor];
    _cn_name_label.font = [regular getFont:14.0f];
    _cn_name_label.textAlignment = 0;
    _cn_name_label.alpha = 0;
    _cn_name_label.textColor = [UIColor whiteColor];

    _titlelabel_f = [[UILabel alloc] initWithFrame:CGRectMake(40*_Scale, CGRectGetMaxY(_cn_name_label.frame), ScreenWidth-40*_Scale, 44*_Scale)];
    [_titleview addSubview:_titlelabel_f];
    _titlelabel_f.alpha = 0;
    _titlelabel_f.backgroundColor = [UIColor clearColor];
    _titlelabel_f.font = [regular getFont:12.0f];
    _titlelabel_f.numberOfLines = 2;
    _titlelabel_f.textAlignment = 0;
    _titlelabel_f.textColor = [UIColor whiteColor];
}

#pragma mark - --------------UpdateUI----------------------
-(void)updateUI{}

#pragma mark - --------------系统代理----------------------

#pragma mark - --------------自定义响应----------------------
-(void)anmationStop
{
    [UIView beginAnimations:@"action" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDidStopSelector:@selector(anmationStop1)];
    [UIView setAnimationDelegate:self];
    _titlelabel.alpha = 1;
    _titlelabel_f.alpha = 1;
    _cn_name_label.alpha = 1;
    [UIView commitAnimations];
}
-(void)anmationStop1
{
    self.isdonghua = @(NO);
}
-(void)ArticleAnimation1:(NSNotification *)not
{
    foundModel *model = [_dict objectForKey:@"model"];
    //    监测
    if(!model.isapp && ![_isdonghua boolValue])
    {
        _titlelabel.alpha = 0;
        _titlelabel_f.alpha = 0;
        _cn_name_label.alpha = 0;
    }
}
-(void)ArticleAnimation:(NSNotification *)not
{
    id obj = not.object;
    if([_dict[@"row"] integerValue] < [obj[@"num"] integerValue] && [obj[@"key"] isEqualToString:_dict[@"char"]] && ![obj[@"suoyin"] boolValue])
    {
        [self startAnimation];
    }
}
#pragma mark - --------------自定义方法----------------------
-(void)setDict:(NSDictionary *)dict
{
    if(_dict != dict)
    {
        _dict = [dict copy];
    }

    foundModel *model = [dict objectForKey:@"model"];

    _titlelabel.text = model.en_name;

    [_cn_name_label setAttributedText:[regular createAttributeString:model.cn_name andFloat:@(2.0)]];
    [_titlelabel_f setAttributedText:[regular createAttributeString:[[NSString alloc] initWithFormat:@"%@，%@",model.city,model.state] andFloat:@(2.0)]];

    if(!model.isapp)
    {
        _imagebackview.frame = CGRectMake(-ScreenWidth*0.03, 0, ScreenWidth*1.06,foundCellHeight);
        _titlelabel.alpha = 0;
        _titlelabel_f.alpha = 0;
        _cn_name_label.alpha = 0;

        _titleview.frame = CGRectMake(0, 400*_Scale, ScreenWidth, 0);
        [UIView beginAnimations:@"action" context:nil];
        [UIView setAnimationDuration:0.6];
        [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
        if(([[_dict objectForKey:@"row"] integerValue] <= [[_dict objectForKey:@"m_row"] integerValue] && [[_dict objectForKey:@"section"] integerValue] <= [[_dict objectForKey:@"m_section"] integerValue]) || [[_dict objectForKey:@"suoyin"] boolValue])
        {
            _isdonghua = @(YES);
            [UIView setAnimationDidStopSelector:@selector(anmationStop)];
            self.block([[_dict objectForKey:@"row"] integerValue],[[_dict objectForKey:@"section"] integerValue],[_dict objectForKey:@"type"]);

        }
        [UIView setAnimationDelegate:self];
        if(([[_dict objectForKey:@"row"] integerValue] <= [[_dict objectForKey:@"m_row"] integerValue] && [[_dict objectForKey:@"section"] integerValue] <= [[_dict objectForKey:@"m_section"] integerValue]) || [[_dict objectForKey:@"suoyin"] boolValue])
        {
            _titleview.frame = CGRectMake(0, 240*_Scale, ScreenWidth, 160*_Scale);
            _imagebackview.frame = CGRectMake(0, 0, ScreenWidth,foundCellHeight);
        }


        if([NSString isNilOrEmpty:model.thumb_image_url])
        {
            _imagebackview.image = [UIImage imageNamed:@"found_sousuo_back"];
        }else
        {
            NSString *imageStr = nil;
            if(kIPhone4s)
            {
                imageStr = [NSString stringWithFormat:@"%@?imageView2/1/w/320/h/200",model.thumb_image_url];
            }else if(kIPhone5s || kIPhone6)
            {
                imageStr = [NSString stringWithFormat:@"%@?imageView2/1/w/640/h/400",model.thumb_image_url];
            }else
            {
                imageStr = [NSString stringWithFormat:@"%@?imageView2/1/w/960/h/600",model.thumb_image_url];
            }

            _imagebackview.placeHolder = [UIImage imageNamed:@"found_sousuo_back"];
            [_imagebackview setImageWithPath:imageStr];
        }
        [UIView commitAnimations];
    }else
    {
        _imagebackview.frame = CGRectMake(0, 0, ScreenWidth,foundCellHeight);
        _titlelabel.alpha = 1;
        _titlelabel_f.alpha = 1;
        _cn_name_label.alpha = 1;

        _titleview.frame = CGRectMake(0, 240*_Scale, ScreenWidth, 160*_Scale);
        if([NSString isNilOrEmpty:model.thumb_image_url])
        {
            _imagebackview.image = [UIImage imageNamed:@"found_sousuo_back"];
        }else
        {
            NSString *imageStr = nil;
            if(kIPhone4s)
            {
                imageStr = [NSString stringWithFormat:@"%@?imageView2/1/w/320/h/200",model.thumb_image_url];
            }else if(kIPhone5s || kIPhone6)
            {
                imageStr = [NSString stringWithFormat:@"%@?imageView2/1/w/640/h/400",model.thumb_image_url];
            }else
            {
                imageStr = [NSString stringWithFormat:@"%@?imageView2/1/w/960/h/600",model.thumb_image_url];
            }

            _imagebackview.placeHolder = [UIImage imageNamed:@"found_sousuo_back"];
            [_imagebackview setImageWithPath:imageStr];
        }
    }
}
-(void)startAnimation
{
    foundModel *model = [_dict objectForKey:@"model"];
    if(!model.isapp)
    {
        _titlelabel.alpha = 0;
        _titlelabel_f.alpha = 0;
        _cn_name_label.alpha = 0;
        _titleview.frame = CGRectMake(0, 400*_Scale, ScreenWidth, 0);
        _isdonghua = @(YES);

        [UIView beginAnimations:@"action" context:nil];
        [UIView setAnimationDuration:0.6];
        [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDidStopSelector:@selector(anmationStop)];
        [UIView setAnimationDelegate:self];

        _titleview.frame = CGRectMake(0, 240*_Scale, ScreenWidth, 160*_Scale);
        _imagebackview.frame = CGRectMake(0, 0, ScreenWidth,foundCellHeight);

        if([NSString isNilOrEmpty:model.thumb_image_url])
        {
            _imagebackview.image=[UIImage imageNamed:@"found_sousuo_back"];
        }else
        {
            NSString *imageStr = nil;
            if(kIPhone4s)
            {
                imageStr = [NSString stringWithFormat:@"%@?imageView2/1/w/320/h/200",model.thumb_image_url];
            }else if(kIPhone5s||kIPhone6)
            {
                imageStr = [NSString stringWithFormat:@"%@?imageView2/1/w/640/h/400",model.thumb_image_url];
            }else
            {
                imageStr = [NSString stringWithFormat:@"%@?imageView2/1/w/960/h/600",model.thumb_image_url];
            }

            _imagebackview.placeHolder = [UIImage imageNamed:@"found_sousuo_back"];
            [_imagebackview setImageWithPath:imageStr];
        }

        [UIView commitAnimations];
        self.block([_dict[@"row"] integerValue],[_dict[@"section"] integerValue],_dict[@"type"]);
    }
}

#pragma mark - --------------other----------------------


@end
