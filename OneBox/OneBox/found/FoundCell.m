//
//  FoundCell.m
//  OneBox
//
//  Created by 谢江新 on 15/2/6.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import "FoundCell.h"

#import "foundModel.h"

#define foundCellHeight 184*_Scale

@implementation FoundCell
{
    NSMutableArray *leftViewArray;
    NSArray *titleArr;
    NSMutableArray *rightViewArray;
    UIView *_rightView;
    UIView *_leftView;
    UIView *_middleView;
    UIView *contentview;
}

-(void)UIConfig
{
    [self createCustomView];
    [self setViewFrame];
    [self createLeftView];
    [self createMiddleView];
    [self createRightView];
}
-(void)createCustomView
{
    UIView *backView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, foundCellHeight)];
    backView.backgroundColor=_define_backview_color;
    
    contentview=[[UIView alloc] initWithFrame:CGRectMake(8*_Scale, 6*_Scale, CGRectGetWidth(backView.frame)-16*_Scale, CGRectGetHeight(backView.frame)-6*_Scale)];
    contentview.backgroundColor=[UIColor whiteColor];
    
    [backView addSubview:contentview];
    [self.contentView addSubview:backView];

}
-(void)createLeftView
{
    
    _leftView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 420*_Scale, foundCellHeight-20*_Scale)];

    [contentview addSubview:_leftView];

    leftViewArray=[[NSMutableArray alloc] init];
    CGFloat labelheight=(foundCellHeight-20*_Scale-10*_Scale)/4;
    CGFloat _y_p=10*_Scale;
    for (int i=0; i<4; i++) {

        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(10, _y_p, CGRectGetWidth(_leftView.frame)-10, labelheight)];

        label.textAlignment=NSTextAlignmentRight;

        if (i==0) {
            label.textColor=[UIColor colorWithRed:204.0f/255.0f green:204.0f/255.0f blue:204.0f/255.0f alpha:1];
            label.font=[regular get_en_Font:14.0f];


        }else if(i==1)
        {
            label.textColor=_define_bluecell_color;

            label.font=[regular getFont:13.0f];
        }else
        {
            label.textColor=[UIColor colorWithRed:204.0f/255.0f green:204.0f/255.0f blue:204.0f/255.0f alpha:1];
            if(i==2)
            {
                 label.font=[regular getFont:11.0f];
            }else if(i==3)
            {
                 label.font=[regular get_en_Font:11.0f];
            }


        }
        if(i==2)
        {
            _y_p+=labelheight-5*_Scale;
        }else
        {
            _y_p+=labelheight;
        }

        [leftViewArray addObject:label];
        [_leftView addSubview:label];
    }
}
-(void)createMiddleView
{
    _middleView=[[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_leftView.frame), 0, 40*_Scale, foundCellHeight-20*_Scale)];
//    _middleView.backgroundColor=[UIColor redColor];
    [contentview addSubview:_middleView];
    
    UIView *_divisionView=[[UIView alloc] initWithFrame:CGRectMake((CGRectGetWidth(_middleView.frame)/2)-1*_Scale, 24*_Scale, 2*_Scale,foundCellHeight-54*_Scale)];
    _divisionView.backgroundColor=_define_backview_color;
    [_middleView addSubview:_divisionView];

}
//@"建校",@"学生数",@"AP数",@"年级"
-(void)createRightView
{
    rightViewArray=[[NSMutableArray alloc] init];
    //    titlelabel
    _rightView=[[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_middleView.frame)-5, 0,ScreenWidth-CGRectGetMaxX(_middleView.frame), foundCellHeight-20*_Scale)];
    //    _rightView.backgroundColor=[UIColor redColor];
    [contentview addSubview:_rightView];
    //    _rightView.backgroundColor=[UIColor cyanColor];
    titleArr=@[@"建校",@"学生数",@"AP数",@"年级"];

    CGFloat titleWidth=_rightView.frame.size.width;
    CGFloat labelheight=(foundCellHeight-20*_Scale-10*_Scale)/4;
    //    CGFloat labelheight=(foundCellHeight-20*_Scale)/4;
    CGFloat _y_p1=10*_Scale;
    for (int i=0; i<4; i++) {
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0,_y_p1, titleWidth*2/6, labelheight)];
        label.textColor=_define_bluecell_color;
        label.font=[regular get_en_Font:11.0f];

        //        label.text=titleArr[i];

        label.textAlignment=NSTextAlignmentRight;
        _y_p1+=labelheight;
        [rightViewArray addObject:label];

        //        label.backgroundColor=[UIColor cyanColor];
        [_rightView addSubview:label];
    }

    //   contentlalbel


    CGFloat _y_p2=10*_Scale;
    for (int i=0; i<4; i++) {
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake( titleWidth*2/6+10, _y_p2, titleWidth*4/6-5, labelheight)];
        label.textAlignment=NSTextAlignmentLeft;
        label.font=[regular getFont:10.0f];
        [label setAttributedText:[regular createAttributeString:titleArr[i] andFloat:@(0.0)]];
        label.textColor=[UIColor colorWithRed:204.0f/255.0f green:204.0f/255.0f blue:204.0f/255.0f alpha:1];
        //        label.backgroundColor=[UIColor redColor];
        _y_p2+=labelheight;
        
        [_rightView addSubview:label];
    }
    
}
-(void)setModel:(foundModel *)model
{

    NSArray *contentArray1=@[model.en_name,model.cn_name,[[NSString alloc] initWithFormat:@"%@，%@",model.city,model.state],model.web];
    for (int i=0; i<contentArray1.count; i++) {
        UILabel *label=leftViewArray[i];
        ((UILabel *)leftViewArray[i]).text=contentArray1[i];
        if(i==0)
        {
        [label setAttributedText:[regular createAttributeString:contentArray1[i] andFloat:@(0)]];

        }else if(i==1||i==2)
        {

            [label setAttributedText:[regular createAttributeString:contentArray1[i] andFloat:@(1)]];
        }else
        {
            label.text=contentArray1[i];
        }
    }
    NSArray *contentArray2=@[model.setup_year,model.total_students,model.ap_count,model.grade];
    for (int i=0; i<contentArray2.count; i++) {
        if(i==0)
        {
            ((UILabel *)rightViewArray[i]).text=[[NSString alloc] initWithFormat:@"%@",contentArray2[i] ];
        }else
        {
            ((UILabel *)rightViewArray[i]).text=contentArray2[i];
        }

    }

}
-(void)setViewFrame
{
    _leftView.frame=CGRectMake(_leftView.frame.origin.x, _leftView.frame.origin.y, ScreenWidth*5/8, _leftView.frame.size.height);

    _rightView.frame=CGRectMake(_leftView.frame.origin.x+_leftView.frame.size.width+ScreenWidth*1/16, 0,ScreenWidth*5/16, 100);
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
    [self UIConfig];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
