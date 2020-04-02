//
//  NotificationCell.m
//  OneBox
//
//  Created by 谢江新 on 15/8/27.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import "NotificationCell.h"

#import "notificationModel.h"

@implementation NotificationCell
{
    DBImageView *icon;
    UILabel *timelabel;
    NSMutableArray *labelarr;
    UIImageView *_isreadimg;
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        labelarr=[[NSMutableArray alloc] init];
        [self UIConfig];
    }
    return  self;
}
-(void)UIConfig
{
    icon=[[DBImageView alloc] initWithFrame:CGRectMake(40*_Scale, 12*_Scale, 76*_Scale , 76*_Scale)];
    icon.placeHolder=[UIImage imageNamed:@"headImg_login1"];
    icon.layer.masksToBounds=YES;
    icon.layer.cornerRadius=CGRectGetWidth(icon.frame)/2.0f;
    [self.contentView addSubview:icon];
    UIView *zhegai=[[UIView alloc] initWithFrame:CGRectMake(-1,-1 , CGRectGetWidth(icon.frame)+2, CGRectGetWidth(icon.frame)+2)];
    zhegai.backgroundColor=[UIColor clearColor];
    zhegai.layer.masksToBounds=YES;
    zhegai.layer.cornerRadius=CGRectGetWidth(zhegai.frame)/2.0f;
    zhegai.layer.borderColor = [_define_head_color CGColor];
    zhegai.layer.borderWidth = 2.0f;
    [icon addSubview:zhegai];





    _isreadimg=[[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(icon.frame)-22*_Scale , CGRectGetMinY(icon.frame), 20*_Scale, 20*_Scale)];
    _isreadimg.layer.masksToBounds=YES;
    _isreadimg.layer.cornerRadius=CGRectGetWidth(_isreadimg.frame)/2.0f;
    _isreadimg.backgroundColor=[UIColor clearColor];
    [self.contentView addSubview:_isreadimg];

    CGFloat _max_x=0;
    for (int i=0; i<2; i++) {
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(icon.frame)+40*_Scale, 10*_Scale+50*_Scale*i, 400*_Scale, 50*_Scale)];
        [self.contentView addSubview:label];
        label.textColor=i==0?_define_blue_color:[UIColor colorWithRed:200.0f/255.0f green:200.0f/255.0f blue:200.0f/255.0f alpha:1];
        label.textAlignment=0;
        label.font=[regular getFont:12.0f];
//        label.backgroundColor=[UIColor brownColor];
        [labelarr addObject:label];
        if(!_max_x)
            _max_x=CGRectGetMaxX(label.frame);
    }

    timelabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(icon.frame)+40*_Scale+400*_Scale, 10*_Scale, ScreenWidth-_max_x-10*_Scale, 46*_Scale)];

//    timelabel.backgroundColor=[UIColor grayColor];
    timelabel.textAlignment=0;
    timelabel.textColor=[UIColor colorWithRed:200.0f/255.0f green:200.0f/255.0f blue:200.0f/255.0f alpha:1];
    timelabel.font=[regular get_en_Font:9.0f];
    [self.contentView addSubview:timelabel];

}
-(void)setModel:(notificationModel *)model
{
    if(!model.is_readed)
    {
        _isreadimg.backgroundColor=[UIColor colorWithRed:1 green:102.0f/255.0f blue:0 alpha:1];
    }else
    {
        _isreadimg.backgroundColor=[UIColor clearColor];
    }

    for (int i=0; i<labelarr.count; i++) {
        NSString *title=nil;
        if(i==0)
        {
            if(([model.extra_info objectForKey:@"title"]==nil)||([model.extra_info objectForKey:@"title"]==[NSNull null]))
            {
                title=@"";
            }else
            {
                title=[model.extra_info objectForKey:@"title"];
            }
        }else
        {
            title=model.body;
        }
        [(UILabel *)labelarr[i] setAttributedText:[regular createAttributeString:title andFloat:@(1.0)]];
    }

    [timelabel setAttributedText:[regular createAttributeString:model.created_at andFloat:@(1.0)]];
    [icon setImageWithPath:model.send_avatar];

}
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
