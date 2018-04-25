//
//  bangdanCell.m
//  OneBox
//
//  Created by 谢江新 on 15/7/15.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import "bangdanCell.h"

#import "foundModel.h"

#define foundCellHeight 200*_Scale

@implementation bangdanCell
{
    NSMutableArray *leftViewArray;

    NSMutableArray *rightViewArray;
    UIView *_rightView;
    UIView *_leftView;
    UIView *_middleView;
    UIView *contentview;
    UILabel *ranklabel;
}
-(void)UIConfig
{

    rightViewArray=[[NSMutableArray alloc] init];
    leftViewArray=[[NSMutableArray alloc] init];
    [self createCustomView];
    ranklabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_leftView.frame), CGRectGetHeight(_leftView.frame))];
    [_leftView addSubview:ranklabel];

    ranklabel.textAlignment=1;
    ranklabel.textColor=[UIColor colorWithRed:255.0f/255.0f green:204.0f/255.0f blue:0 alpha:1];
    ranklabel.font=[regular get_en_Font:19.0f];
//    ranklabel.backgroundColor=[UIColor redColor];

    CGFloat _y_p=22*_Scale;
    for (int i=0; i<3; i++) {
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, _y_p, CGRectGetWidth(_rightView.frame), 40*_Scale)];
        CGFloat _font=0;
        NSString *_ziti=nil;
        UIColor *_color=nil;
        if(i==0)
        {
            _color=[UIColor colorWithRed:204.0f/255.0f green:204.0f/255.0f blue:204.0f/255.0f alpha:1];
            _font=14.0f;
            _ziti=@"Skia";
        }else if(i==1)
        {
            _color=_define_bluecell_color;
            _font=12.0f;
            _ziti=(kIOSVersions>=9.0? @"":@"Helvetica Neue" );

        }else if(i==2)
        {
            _color=[UIColor colorWithRed:204.0f/255.0f green:204.0f/255.0f blue:204.0f/255.0f alpha:1];
            _font=11.0f;
            _ziti=(kIOSVersions>=9.0? @"":@"Helvetica Neue" );

        }
        if([_ziti isEqualToString:@""])
        {
            if(_isPad)
            {
                label.font=[UIFont systemFontOfSize:_font+20];

            }else
            {
                label.font=[UIFont systemFontOfSize:_font];
            }

        }else
        {
            if(_isPad)
            {
                label.font=[UIFont fontWithName:_ziti size:_font+20];

            }else
            {
                label.font=[UIFont fontWithName:_ziti size:_font];
            }

        }
        [_rightView addSubview:label];
        label.textColor=_color;
        _y_p+=40*_Scale;
        label.textAlignment=0;
        [leftViewArray addObject:label];
    }

     CGFloat _x_p=CGRectGetMinX(_rightView.frame);
    CGFloat _width=0;
    for (int i=0; i<4; i++) {

        UILabel *label1=[[UILabel alloc] init];

        _width=i==0?125*_Scale:i==1?146*_Scale:i==2?105*_Scale:160*_Scale;
        label1.frame=CGRectMake(_x_p, _y_p, _width, 30*_Scale);
        _x_p+=_width;

        [contentview addSubview:label1];
        label1.textAlignment=0;

        label1.font=[regular get_en_Font:10.0f];;
        label1.textColor=[UIColor colorWithRed:204.0f/255.0f green:204.0f/255.0f blue:204.0f/255.0f alpha:1];


        [rightViewArray addObject:label1];
        
        
    }


}
-(void)createCustomView
{
    UIView *backView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, foundCellHeight)];
    backView.backgroundColor=_define_backview_color;

    contentview=[[UIView alloc] initWithFrame:CGRectMake(8*_Scale, 6*_Scale, CGRectGetWidth(backView.frame)-16*_Scale, CGRectGetHeight(backView.frame)-6*_Scale)];
    contentview.backgroundColor=[UIColor whiteColor];

    [backView addSubview:contentview];
    [self.contentView addSubview:backView];
    _leftView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 94*_Scale, CGRectGetHeight(contentview.frame))];
     _rightView=[[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_leftView.frame), 0, CGRectGetWidth(contentview.frame)-CGRectGetMaxX(_leftView.frame), CGRectGetHeight(contentview.frame))];


    [contentview addSubview:_leftView];
    [contentview addSubview:_rightView];

}

-(void)setModel:(foundModel *)model
{


    ranklabel.text=[[NSString alloc] initWithFormat:@"#%@",model.rank];
    NSArray *contentArray1=@[model.en_name,model.cn_name,[[NSString alloc] initWithFormat:@"%@ %@",model.city,model.state]];



    for (int i=0; i<leftViewArray.count; i++) {
        UILabel *label=(UILabel *)leftViewArray[i];
        if(i==1)
        {
            [label setAttributedText:[regular createAttributeString:contentArray1[i] andFloat:@(2.0)]];


        }else
        {
            [label setAttributedText:[regular createAttributeString:contentArray1[i] andFloat:@(1.0)]];

            
        }

        }


NSArray *contentArray2=@[model.setup_year,model.total_students,model.ap_count,model.grade];
    for (int i=0; i<rightViewArray.count; i++) {
         UILabel *label2=(UILabel *)rightViewArray[i];

        NSString *title=i==0?@"建校":i==1?@"学生数":i==2?@"AP数":@"年级";
        UIColor *_color=nil;
        _color=i==0?[UIColor redColor]:i==1?[UIColor grayColor]:i==2?[UIColor cyanColor]:[UIColor orangeColor];
        if([contentArray2[i] isEqualToString:@""])
        {
             [label2 setAttributedText:[regular createAttributeString:[[NSString alloc] initWithFormat:@"%@ -",title] andFloat:@(0.5f)]];

        }else
        {
            [label2 setAttributedText:[regular createAttributeString:[[NSString alloc] initWithFormat:@"%@ %@",title,contentArray2[i]] andFloat:@(0.5f)]];

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
    [super awakeFromNib];
    [self UIConfig];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
