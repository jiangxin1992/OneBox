//
//  collection_del_Cell.m
//  OneBox
//
//  Created by 谢江新 on 15/12/1.
//  Copyright © 2015年 谢江新. All rights reserved.
//

#import "collection_del_Cell.h"

#import "foundModel.h"

#define foundCellHeight 200*_Scale
#define labelHight 40*_Scale

@implementation collection_del_Cell
{
    NSMutableArray *leftViewArray;
    NSArray *titleArr;
    NSMutableArray *rightViewArray;

    UIView *_backView;
    UIView *_rightView;
    UIView *_leftView;
    UIView *_middleView;
    foundModel *model;

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
-(void)setDict:(NSMutableDictionary *)dict
{

    if (_dict != dict) {
        _dict = [dict mutableCopy];

    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(change_num:) name:@"change_num" object:nil];
    model=dict[@"model"];

    NSArray *contentArray1=@[model.en_name,model.cn_name,model.city,model.web];
    for (int i=0; i<contentArray1.count; i++) {
        ((UILabel *)leftViewArray[i]).text=contentArray1[i];
    }
    NSArray *contentArray2=@[model.setup_year,model.total_students,model.ap_count,model.grade];
    for (int i=0; i<contentArray2.count; i++) {
        ((UILabel *)rightViewArray[i]).text=contentArray2[i];
    }
}
-(void)change_num:(NSNotification *)not
{
    if([not.object integerValue]<[_dict[@"rownum"] integerValue])
    {
        NSInteger n_rownum= [_dict[@"rownum"] integerValue];

        n_rownum--;


        [_dict setObject:[NSNumber numberWithInteger:n_rownum] forKey:@"rownum"];
        
    }
    
}
-(void)UIConfig
{
    self.contentView.userInteractionEnabled=YES;
    [self createBackView];
    [self createLeftView];
    [self createMiddleView];
    [self createRightView];
}
-(void)createRightView
{

    //    titlelabel
    _rightView=[[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_middleView.frame), 0,CGRectGetWidth(_backView.frame)-CGRectGetMaxX(_middleView.frame), foundCellHeight)];
//        _rightView.backgroundColor=[UIColor redColor];
    [_backView addSubview:_rightView];
    //    _rightView.backgroundColor=[UIColor cyanColor];
    titleArr=@[@"建校",@"学生数",@"AP数",@"年级"];

    CGFloat titleWidth=_rightView.frame.size.width;
    CGFloat labelheight=(foundCellHeight-20*_Scale)/4;
    //    CGFloat labelheight=(foundCellHeight-20*_Scale)/4;
    CGFloat _y_p1=10*_Scale;
    rightViewArray=[[NSMutableArray alloc] init];

    for (int i=0; i<4; i++) {
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0,_y_p1, titleWidth*1/3, labelheight)];
//        label.backgroundColor=[UIColor redColor];
        label.textAlignment=2;

        label.font=[regular get_en_Font:11.0f];
        label.textColor=_define_bluecell_color;
        _y_p1+=labelheight;
        //        label.backgroundColor=[UIColor redColor];
        [rightViewArray addObject:label];
        [_rightView addSubview:label];



    }

    //   contentlalbel


    CGFloat _y_p2=10*_Scale;
    for (int i=0; i<4; i++) {
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake( titleWidth*1/3+5, _y_p2, titleWidth*2/3-5, labelheight)];
        label.textColor=[UIColor colorWithRed:204.0f/255.0f green:204.0f/255.0f blue:204.0f/255.0f alpha:1];
        label.font=[regular getFont:11.0f];

        label.text=titleArr[i];
        label.textAlignment=0;
        _y_p2+=labelheight;

        //                label.backgroundColor=[UIColor cyanColor];
        [_rightView addSubview:label];
        
    }
}
-(void)createMiddleView
{
    _middleView=[[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_leftView.frame), 0, 50*_Scale, foundCellHeight)];
//        _middleView.backgroundColor=[UIColor redColor];
    [_backView addSubview:_middleView];

    UIView *_divisionView=[[UIView alloc] initWithFrame:CGRectMake((CGRectGetWidth(_middleView.frame)/2)-1*_Scale, 10*_Scale, 2*_Scale,foundCellHeight-20*_Scale)];
    _divisionView.backgroundColor=_define_backview_color;
    [_middleView addSubview:_divisionView];

    
}
-(void)createBackView
{
    _backView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, foundCellHeight)];
    _backView.userInteractionEnabled=YES;
    _backView.backgroundColor=[UIColor whiteColor];
    [self.contentView addSubview:_backView];
}
-(void)createLeftView
{
    _leftView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 425*_Scale, foundCellHeight)];
//    _leftView.backgroundColor=[UIColor cyanColor];
    [_backView addSubview:_leftView];

    leftViewArray=[[NSMutableArray alloc] init];
    CGFloat labelheight=(foundCellHeight-20*_Scale)/4;
    CGFloat _y_p=10*_Scale;


    for (int i=0; i<4; i++) {

        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, _y_p, CGRectGetWidth(_leftView.frame), labelheight)];

//        label.backgroundColor=[UIColor redColor];
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
            if(i==3)
            {
                label.font=[regular get_en_Font:11.0f];
            }else
            {
                label.font=[regular getFont:11.0f];
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
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
