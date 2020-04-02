//
//  FoundListTableHeaderView.m
//  OneBox
//
//  Created by yyj on 2018/4/8.
//  Copyright © 2018年 谢江新. All rights reserved.
//

#import "FoundListTableHeaderView.h"

#import "DBImageView.h"

@interface FoundListTableHeaderView()<UITextFieldDelegate>

@property (nonatomic, strong) DBImageView *backViewImg;
@property (nonatomic, strong) UITextField *textFiled;

@end

@implementation FoundListTableHeaderView

#pragma mark - --------------生命周期--------------
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self SomePrepare];
        [self UIConfig];
    }
    return self;
}

#pragma mark - --------------SomePrepare--------------
- (void)SomePrepare
{
    [self PrepareData];
    [self PrepareUI];
}
- (void)PrepareData{

}
- (void)PrepareUI{
    self.userInteractionEnabled = YES;
    //    给headview增加触摸（键盘消失）
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headviewAction)];
    [self addGestureRecognizer:tap];
}

#pragma mark - --------------UIConfig----------------------
-(void)UIConfig{

    //创建背景
    [self createBackView];
    //创建搜索栏
    [self createSearchView];
    //创建筛选按钮
    [self createScreenView];

}
//创建背景
-(void)createBackView{
    _backViewImg = [[DBImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 420*_Scale)];
    [self addSubview:_backViewImg];
}
//创建搜索栏
-(void)createSearchView
{
    UIView *leftView = [UIView getCustomViewWithColor:nil];
    leftView.frame = CGRectMake(0, 0, 77*_Scale, 72*_Scale);

    UIImageView *img = [UIImageView getImgWithImageStr:@"found_newsearch"];
    [leftView addSubview:img];
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(34*_Scale);
        make.centerY.mas_equalTo(leftView);
        make.left.mas_equalTo(20*_Scale);
    }];

    _textFiled = [UITextField getTextFieldWithPlaceHolder:@"试试学校或城市名称吧" WithAlignment:0 WithFont:13.0f WithTextColor:[UIColor colorWithRed:160.0f/255.0f green:160.0f/255.0f blue:160.0f/255.0f alpha:1] WithLeftView:leftView WithRightView:nil WithSecureTextEntry:NO];
    [self addSubview:_textFiled];
    [_textFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(460*_Scale);
        make.height.mas_equalTo(72*_Scale);
        make.top.mas_equalTo(120*_Scale);
        make.centerX.mas_equalTo(self);
    }];
    _textFiled.delegate = self;
    _textFiled.backgroundColor = _define_white_color;
    _textFiled.alpha = 0.9;
    _textFiled.layer.masksToBounds = YES;
    _textFiled.layer.cornerRadius = 36*_Scale;

    //    clear类型
    _textFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    //    设置return类型
    _textFiled.returnKeyType = UIReturnKeySearch;
}
//创建筛选按钮
-(void)createScreenView{

    NSArray *imageNameArr = @[@"found_bangdan_排名",@"found_bangdan_地图",@"found_bangdan_筛选"];
    NSArray *imageTitleArr = @[@"排名",@"地图",@"筛选"];

    CGFloat jiange = (CGRectGetWidth(self.frame) - 130*_Scale*2 - 80*_Scale*3)/(imageNameArr.count - 1);

    UIView *lastView = nil;
    for (int i = 0; i < imageNameArr.count; i++) {

        UIImageView *screenImg = [UIImageView getImgWithImageStr:imageNameArr[i]];
        [self addSubview:screenImg];
        [screenImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_textFiled.mas_bottom).with.offset(46*_Scale);
            make.width.height.mas_equalTo(80*_Scale);
            if(!lastView){
                make.left.mas_equalTo(130*_Scale);
            }else{
                make.left.mas_equalTo(lastView.mas_right).with.offset(jiange);
            }
        }];
        screenImg.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = nil;
        if(i == 0){
            //榜单
            tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapActionBangdan:)];
        }else if(i == 1){
            //地图
            tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapActionMap:)];
        }else if(i == 2){
            //筛选
            tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapActionScreen:)];
        }
        [screenImg addGestureRecognizer:tap];

        UILabel *titleLabel = [UILabel getLabelWithAlignment:1 WithTitle:imageTitleArr[i] WithFont:13.0f WithTextColor:_define_white_color WithSpacing:2.0];
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(100*_Scale);
            make.height.mas_equalTo(70*_Scale);
            make.top.mas_equalTo(screenImg.mas_bottom).with.offset(0);
            make.centerX.mas_equalTo(screenImg);
        }];

        lastView = screenImg;
    }
}
#pragma mark - --------------UpdateUI----------------------
-(void)updateUI{

    //    根据网络获取到headview图片是否为空来处理（应对DBimage 在图片地址无效时候显示灰色样式）
    if([NSString isNilOrEmpty:_backViewImagePath])
    {
        //        为空时候，直接设为背景图
        _backViewImg.image = [UIImage imageNamed:@"found_newsearch_back_260"];
    }else
    {
        //        不为空时候网络获取该图片，设置placeholder图片。
        _backViewImg.placeHolder = [UIImage imageNamed:@"found_newsearch_back_260"];
        [_backViewImg setImageWithPath:_backViewImagePath];
    }
}

#pragma mark - --------------系统代理----------------------
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //结束编辑点击键盘上的return键执行动画效果使视图回落
    [textField resignFirstResponder];
    if([textField.text isEqualToString:@""])
    {
        [[ToolManager sharedManager] alertTitle_Simple:@"请输入关键字"];
    }else
    {
        //跳转到搜索页面
        if(_headViewBlock){
            _headViewBlock(@"gotoSouSuoView",textField.text);
        }
    }

    return YES;
}
#pragma mark - --------------自定义响应----------------------
//榜单
-(void)tapActionBangdan:(UIGestureRecognizer *)sender{
    if(_headViewBlock){
        _headViewBlock(@"tapActionBangdan",nil);
    }
}
//地图
-(void)tapActionMap:(UIGestureRecognizer *)sender{
    if(_headViewBlock){
        _headViewBlock(@"tapActionMap",nil);
    }
}
//筛选
-(void)tapActionScreen:(UIGestureRecognizer *)sender{
    if(_headViewBlock){
        _headViewBlock(@"tapActionScreen",nil);
    }
}
//键盘消失
-(void)headviewAction
{
    [regular dismissKeyborad];
}

#pragma mark - --------------自定义方法----------------------


#pragma mark - --------------other----------------------


@end
