//
//  UserCell1.m
//  OneBox
//
//  Created by 谢江新 on 15/9/2.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import "UserCell1.h"

#import "usermodel.h"

@implementation UserCell1
{
    NSMutableArray *labelarr;
    DBImageView *icon;
    NSInteger _num;
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
-(void)setDict:(NSDictionary *)dict
{
    usermodel *model=[dict objectForKey:@"data"];
    [icon setImageWithPath:model.avatar];

    for (int i=0; i<labelarr.count; i++) {
        UILabel *label=(UILabel *)labelarr[i];
        NSString *str=i==0?model.username:model.mark;
        [label setAttributedText:[regular createAttributeString:str andFloat:@(1.0)]];
    }
    _num=[[dict objectForKey:@"num"] integerValue];


}
//-(void)setModel:(usermodel *)model
//{
////    usermodel *
//
//    [icon setImageWithPath:model.avatar];
//
//    for (int i=0; i<labelarr.count; i++) {
//        UILabel *label=(UILabel *)labelarr[i];
//        NSString *str=i==0?model.username:model.mark;
//        [label setAttributedText:[regular createAttributeString:str andFloat:@(1.0)]];
//    }
//
//
//}
-(void)taphead:(UIGestureRecognizer *)ges
{
    //    bl(_num);
    //    JXLOG(@"%d",_num);
    self.block([NSNumber numberWithInteger:_num]);
}
-(void)UIConfig
{

    icon=[[DBImageView alloc] initWithFrame:CGRectMake(40*_Scale, 12*_Scale, 76*_Scale , 76*_Scale)];
    icon.layer.masksToBounds=YES;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(taphead:)];
    [icon addGestureRecognizer:tap];
    //    icon.image=[UIImage imageNamed:@"notification_head"];
    icon.placeHolder=[UIImage imageNamed:@"headImg_login1"];
    icon.layer.cornerRadius=CGRectGetWidth(icon.frame)/2.0f;
    //    icon.backgroundColor=[UIColor greenColor];
    [self.contentView addSubview:icon];

    UIView *zhegai=[[UIView alloc] initWithFrame:CGRectMake(-1,-1 , CGRectGetWidth(icon.frame)+2, CGRectGetWidth(icon.frame)+2)];
    zhegai.backgroundColor=[UIColor clearColor];
    zhegai.layer.masksToBounds=YES;
    zhegai.layer.cornerRadius=CGRectGetWidth(zhegai.frame)/2.0f;
    zhegai.layer.borderColor =[_define_head_color CGColor];
    zhegai.layer.borderWidth = 2.0f;
    [icon addSubview:zhegai];



    //    _isreadimg=[[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(icon.frame)-22*_Scale , CGRectGetMinY(icon.frame), 20*_Scale, 20*_Scale)];
    //    _isreadimg.layer.masksToBounds=YES;
    //    _isreadimg.layer.cornerRadius=CGRectGetWidth(_isreadimg.frame)/2.0f;
    //    _isreadimg.backgroundColor=[UIColor clearColor];
    //    [self.contentView addSubview:_isreadimg];

    CGFloat _max_x=0;
    for (int i=0; i<2; i++) {
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(icon.frame)+40*_Scale, 10*_Scale+40*_Scale*i, 400*_Scale, 40*_Scale)];
        [self.contentView addSubview:label];
//        label.textColor=[UIColor colorWithRed:200.0f/255.0f green:200.0f/255.0f blue:200.0f/255.0f alpha:1];
        label.textAlignment=0;
        UIColor *_color=nil;
        if(i==0)
        {
            label.font=[regular getFont:13.0f];
            _color=[UIColor colorWithRed:155.0f/255.0f green:155.0f/255.0f blue:155.0f/255.0f alpha:1];


        }else
        {
            label.font=[regular getFont:11.0f];
            _color=[UIColor colorWithRed:200.0f/255.0f green:200.0f/255.0f blue:200.0f/255.0f alpha:1];

        }
        label.textColor=_color;

        //        label.backgroundColor=[UIColor brownColor];
        [labelarr addObject:label];
        if(!_max_x)
            _max_x=CGRectGetMaxX(label.frame);
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
