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
}

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
- (void)PrepareData{

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(FoundAnimation:) name:@"FoundAnimation" object:nil];
}
- (void)PrepareUI{}

#pragma mark - --------------UIConfig----------------------
-(void)UIConfig
{
    imagebackview = [[DBImageView alloc] init];
    [self.contentView addSubview:imagebackview];
    imagebackview.backgroundColor = _define_white_color;
    imagebackview.frame=CGRectMake(-ScreenWidth*0.05, 0, ScreenWidth*1.10,foundCellHeight);
    imagebackview.image = [UIImage imageNamed:@"coffee-in_380"];

    titlelabel = [UILabel getLabelWithAlignment:1 WithTitle:nil WithFont:21.0f WithTextColor:[UIColor whiteColor] WithSpacing:0];;
    [imagebackview addSubview:titlelabel];
    titlelabel.backgroundColor = [UIColor clearColor];
    titlelabel.alpha = 0;

    titlelabel_f = [UILabel getLabelWithAlignment:1 WithTitle:nil WithFont:15.0f WithTextColor:[UIColor whiteColor] WithSpacing:0];
    [imagebackview addSubview:titlelabel_f];
    titlelabel_f.backgroundColor = [UIColor clearColor];
    titlelabel_f.alpha = 0;
}
#pragma mark - --------------UpdateUI----------------------
-(void)updateUI{
    //取消所有动画
    [titlelabel.layer removeAllAnimations];
    [titlelabel_f.layer removeAllAnimations];
    [imagebackview.layer removeAllAnimations];

    [titlelabel setAttributedText:[regular createAttributeString:_foundModel.title andFloat:@(4.0)]];
    [titlelabel sizeToFit];
    titlelabel.frame = CGRectMake((ScreenWidth-CGRectGetWidth(titlelabel.frame))/2.0f, (CGRectGetHeight(imagebackview.frame)-CGRectGetHeight(titlelabel.frame))/2.0f,CGRectGetWidth(titlelabel.frame) ,CGRectGetHeight(titlelabel.frame));

    [titlelabel_f setAttributedText:[regular createAttributeString:_foundModel.f_title andFloat:@(2.0)]];
    [titlelabel_f sizeToFit];
    titlelabel_f.frame = CGRectMake(0, CGRectGetMaxY(titlelabel.frame)+10,ScreenWidth,CGRectGetHeight(titlelabel.frame));

    if([NSString isNilOrEmpty:_foundModel.pic])
    {
        imagebackview.image = [UIImage imageNamed:@"coffee-in_380"];
    }else
    {
        NSString *imageStr = [self getBackViewImg:_foundModel.pic];
        [imagebackview setImageWithPath:imageStr];
        imagebackview.placeHolder = [UIImage imageNamed:@"coffee-in_380"];
    }

    if(![_foundModel.isAppear boolValue])
    {
        imagebackview.frame = CGRectMake(-ScreenWidth*0.05, 0, ScreenWidth*1.10, foundCellHeight);
        titlelabel.alpha = 0;
        titlelabel_f.alpha = 0;

        if(_indexPath.row < 1){
            [self startAnimation];
        }
    }else
    {
        imagebackview.frame = CGRectMake(0, 0, ScreenWidth,foundCellHeight);
        titlelabel.alpha = 1;
        titlelabel_f.alpha = 1;
    }
}
#pragma mark - --------------系统代理----------------------

#pragma mark - --------------自定义响应----------------------
-(void)FoundAnimation:(NSNotification *)not
{
    JXLOG(@"%ld",(long)[not.object integerValue]);
    NSInteger record_cell_num = [not.object integerValue];
    if(_indexPath.row < record_cell_num)
    {
        if(![_foundModel.isAppear boolValue])
        {
            [self startAnimation];
        }
    }
}

#pragma mark - --------------自定义方法----------------------
-(void)startAnimation
{
    _foundModel.isAppear = @(YES);
    
    [UIView animateWithDuration:1 animations:^{

        imagebackview.frame = CGRectMake(0, 0, ScreenWidth,foundCellHeight);
        titlelabel.alpha = 1;
        titlelabel_f.alpha = 1;

    } completion:nil];
}

-(NSString *)getBackViewImg:(NSString *)pic{
    NSString *imageStr = nil;
    if(kIPhone4s)
    {
        imageStr = [NSString stringWithFormat:@"%@?imageView2/1/w/320/h/180",pic];
    }else if(kIPhone5s||kIPhone6)
    {
        imageStr = [NSString stringWithFormat:@"%@?imageView2/1/w/640/h/360",pic];
    }else
    {
        imageStr = [NSString stringWithFormat:@"%@?imageView2/1/w/960/h/540",pic];
    }
    return imageStr;
}
#pragma mark - --------------other----------------------


@end
