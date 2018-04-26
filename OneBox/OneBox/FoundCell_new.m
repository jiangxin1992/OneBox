//
//  FoundCell.m
//  OneBox
//
//  Created by 谢江新 on 15/2/6.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import "FoundCell_new.h"

// c文件 —> 系统文件（c文件在前）

// 控制器

// 自定义视图

// 接口

// 分类

// 自定义类和三方类（ cocoapods类 > model > 工具类 > 其他）

#import "FoundModel_new.h"

#define foundCellHeight 380*_Scale

@interface FoundCell_new()

@property (nonatomic, strong) DBImageView *imagebackview;

@property (nonatomic, strong) UILabel *titlelabel;

@property (nonatomic, strong) UILabel *titlelabel_f;

@end

@implementation FoundCell_new

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
    _imagebackview = [[DBImageView alloc] init];
    [self.contentView addSubview:_imagebackview];
    _imagebackview.backgroundColor = _define_white_color;
    _imagebackview.frame = CGRectMake(-ScreenWidth*0.05, 0, ScreenWidth*1.10,foundCellHeight);
    _imagebackview.image = [UIImage imageNamed:@"coffee-in_380"];

    _titlelabel = [UILabel getLabelWithAlignment:1 WithTitle:nil WithFont:21.0f WithTextColor:[UIColor whiteColor] WithSpacing:0];;
    [_imagebackview addSubview:_titlelabel];
    _titlelabel.backgroundColor = [UIColor clearColor];
    _titlelabel.alpha = 0;

    _titlelabel_f = [UILabel getLabelWithAlignment:1 WithTitle:nil WithFont:15.0f WithTextColor:[UIColor whiteColor] WithSpacing:0];
    [_imagebackview addSubview:_titlelabel_f];
    _titlelabel_f.backgroundColor = [UIColor clearColor];
    _titlelabel_f.alpha = 0;
}
#pragma mark - --------------UpdateUI----------------------
-(void)updateUI{
    //取消所有动画
    [_titlelabel.layer removeAllAnimations];
    [_titlelabel_f.layer removeAllAnimations];
    [_imagebackview.layer removeAllAnimations];

    [_titlelabel setAttributedText:[regular createAttributeString:_foundModel.title andFloat:@(4.0)]];
    [_titlelabel sizeToFit];
    _titlelabel.frame = CGRectMake((ScreenWidth-CGRectGetWidth(_titlelabel.frame))/2.0f, (CGRectGetHeight(_imagebackview.frame)-CGRectGetHeight(_titlelabel.frame))/2.0f,CGRectGetWidth(_titlelabel.frame) ,CGRectGetHeight(_titlelabel.frame));

    [_titlelabel_f setAttributedText:[regular createAttributeString:_foundModel.f_title andFloat:@(2.0)]];
    [_titlelabel_f sizeToFit];
    _titlelabel_f.frame = CGRectMake(0, CGRectGetMaxY(_titlelabel.frame)+10,ScreenWidth,CGRectGetHeight(_titlelabel.frame));

    if([NSString isNilOrEmpty:_foundModel.pic])
    {
        _imagebackview.image = [UIImage imageNamed:@"coffee-in_380"];
    }else
    {
        NSString *imageStr = [self getBackViewImg:_foundModel.pic];
        [_imagebackview setImageWithPath:imageStr];
        _imagebackview.placeHolder = [UIImage imageNamed:@"coffee-in_380"];
    }

    if(![_foundModel.isAppear boolValue])
    {
        _imagebackview.frame = CGRectMake(-ScreenWidth*0.05, 0, ScreenWidth*1.10, foundCellHeight);
        _titlelabel.alpha = 0;
        _titlelabel_f.alpha = 0;

        if(_indexPath.row < 1){
            [self startAnimation];
        }
    }else
    {
        _imagebackview.frame = CGRectMake(0, 0, ScreenWidth,foundCellHeight);
        _titlelabel.alpha = 1;
        _titlelabel_f.alpha = 1;
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
    WeakSelf(ws);
    [UIView animateWithDuration:1 animations:^{

        ws.imagebackview.frame = CGRectMake(0, 0, ScreenWidth,foundCellHeight);
        ws.titlelabel.alpha = 1;
        ws.titlelabel_f.alpha = 1;

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
