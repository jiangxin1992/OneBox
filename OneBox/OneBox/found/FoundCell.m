//
//  FoundCell.m
//  OneBox
//
//  Created by 谢江新 on 15/2/6.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import "FoundCell.h"

#import "FoundModel.h"

#define foundCellHeight 184*_Scale

@interface FoundCell()

@property (nonatomic, strong) NSMutableArray *leftViewArray;
@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) NSMutableArray *rightViewArray;

@property (nonatomic, strong) UIView *contentBackView;

@property (nonatomic, strong) UIView *rightView;
@property (nonatomic, strong) UIView *leftView;
@property (nonatomic, strong) UIView *middleView;

@end

@implementation FoundCell

#pragma mark - --------------生命周期--------------
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
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
- (void)PrepareData{}
- (void)PrepareUI{}

#pragma mark - --------------UIConfig----------------------
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
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, foundCellHeight)];
    [self.contentView addSubview:backView];
    backView.backgroundColor = _define_backview_color;

    _contentBackView = [[UIView alloc] initWithFrame:CGRectMake(8*_Scale, 6*_Scale, CGRectGetWidth(backView.frame) - 16*_Scale, CGRectGetHeight(backView.frame) - 6*_Scale)];
    [backView addSubview:_contentBackView];
    _contentBackView.backgroundColor = [UIColor whiteColor];

}
-(void)setViewFrame
{
    _leftView.frame = CGRectMake(_leftView.frame.origin.x, _leftView.frame.origin.y, ScreenWidth*5/8, _leftView.frame.size.height);

    _rightView.frame = CGRectMake(_leftView.frame.origin.x + _leftView.frame.size.width + ScreenWidth*1/16, 0,ScreenWidth*5/16, 100);
}
-(void)createLeftView
{

    _leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 420*_Scale, foundCellHeight-20*_Scale)];

    [_contentBackView addSubview:_leftView];

    _leftViewArray = [[NSMutableArray alloc] init];
    CGFloat labelheight = (foundCellHeight-20*_Scale-10*_Scale)/4;
    CGFloat _y_p = 10*_Scale;
    for (int i = 0; i < 4; i++) {

        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, _y_p, CGRectGetWidth(_leftView.frame)-10, labelheight)];

        label.textAlignment = NSTextAlignmentRight;

        if (i == 0) {

            label.textColor = [UIColor colorWithRed:204.0f/255.0f green:204.0f/255.0f blue:204.0f/255.0f alpha:1];
            label.font = [regular get_en_Font:14.0f];

        }else if(i == 1)
        {
            label.textColor = _define_bluecell_color;

            label.font = [regular getFont:13.0f];
        }else
        {
            label.textColor = [UIColor colorWithRed:204.0f/255.0f green:204.0f/255.0f blue:204.0f/255.0f alpha:1];
            if(i == 2)
            {
                label.font = [regular getFont:11.0f];
            }else if(i == 3)
            {
                label.font = [regular get_en_Font:11.0f];
            }
        }
        if(i == 2)
        {
            _y_p += labelheight - 5*_Scale;
        }else
        {
            _y_p += labelheight;
        }

        [_leftViewArray addObject:label];
        [_leftView addSubview:label];
    }
}
-(void)createMiddleView
{
    _middleView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_leftView.frame), 0, 40*_Scale, foundCellHeight-20*_Scale)];
    [_contentBackView addSubview:_middleView];

    UIView *divisionView = [[UIView alloc] initWithFrame:CGRectMake((CGRectGetWidth(_middleView.frame)/2)-1*_Scale, 24*_Scale, 2*_Scale,foundCellHeight-54*_Scale)];
    divisionView.backgroundColor = _define_backview_color;
    [_middleView addSubview:divisionView];

}
//@"建校",@"学生数",@"AP数",@"年级"
-(void)createRightView
{
    _rightViewArray = [[NSMutableArray alloc] init];

    _rightView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_middleView.frame)-5, 0,ScreenWidth-CGRectGetMaxX(_middleView.frame),  foundCellHeight-20*_Scale)];
    [_contentBackView addSubview:_rightView];
    _titleArr = @[@"建校",@"学生数",@"AP数",@"年级"];

    CGFloat titleWidth = _rightView.frame.size.width;
    CGFloat labelheight = (foundCellHeight - 20*_Scale - 10*_Scale)/4;
    CGFloat _y_p1 = 10*_Scale;
    for (int i = 0; i < 4; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,_y_p1, titleWidth*2/6, labelheight)];
        label.textColor = _define_bluecell_color;
        label.font = [regular get_en_Font:11.0f];
        label.textAlignment = NSTextAlignmentRight;
        _y_p1 += labelheight;
        [_rightViewArray addObject:label];
        [_rightView addSubview:label];
    }

    CGFloat _y_p2 = 10*_Scale;
    for (int i = 0; i < 4; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake( titleWidth*2/6+10, _y_p2, titleWidth*4/6-5, labelheight)];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [regular getFont:10.0f];
        [label setAttributedText:[regular createAttributeString:_titleArr[i] andFloat:@(0.0)]];
        label.textColor = [UIColor colorWithRed:204.0f/255.0f green:204.0f/255.0f blue:204.0f/255.0f alpha:1];
        _y_p2 += labelheight;

        [_rightView addSubview:label];
    }

}

#pragma mark - --------------UpdateUI----------------------
-(void)updateUI{}
-(void)setModel:(FoundModel *)model
{
    NSArray *contentArray1 = @[model.en_name,model.cn_name,[[NSString alloc] initWithFormat:@"%@，%@",model.city,model.state],model.web];
    for (int i = 0; i < contentArray1.count; i++) {
        UILabel *label = _leftViewArray[i];
        ((UILabel *)_leftViewArray[i]).text = contentArray1[i];
        if(i == 0)
        {
            [label setAttributedText:[regular createAttributeString:contentArray1[i] andFloat:@(0)]];

        }else if(i == 1 || i == 2)
        {
            [label setAttributedText:[regular createAttributeString:contentArray1[i] andFloat:@(1)]];
        }else
        {
            label.text = contentArray1[i];
        }
    }
    NSArray *contentArray2 = @[model.setup_year,model.total_students,[model.ap_count isEqualToString:@"0"]?@"N/A":model.ap_count,model.grade];
    for (int i = 0; i < contentArray2.count; i++) {
        if(i == 0)
        {
            ((UILabel *)_rightViewArray[i]).text = [[NSString alloc] initWithFormat:@"%@",contentArray2[i]];
        }else
        {
            ((UILabel *)_rightViewArray[i]).text = contentArray2[i];
        }
    }
}

#pragma mark - --------------系统代理----------------------

#pragma mark - --------------自定义响应----------------------


#pragma mark - --------------自定义方法----------------------


#pragma mark - --------------other----------------------

@end
