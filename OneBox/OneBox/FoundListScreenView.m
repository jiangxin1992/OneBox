//
//  FoundListScreenView.m
//  OneBox
//
//  Created by yyj on 2018/4/9.
//  Copyright © 2018年 谢江新. All rights reserved.
//

#import "FoundListScreenView.h"

#import "FoundListScreenMainView.h"
#import "FoundListScreenStateView.h"
#import "FoundListScreenCityView.h"

@interface FoundListScreenView()

@property (nonatomic, strong) FoundListScreenMainView *screenMainView;
@property (nonatomic, strong) FoundListScreenStateView *screenStateView;
@property (nonatomic, strong) FoundListScreenCityView *screenCityView;

@property (nonatomic, strong) UIImageView *backImgView;

@property (nonatomic, strong) NSMutableString *state;//当前州名
@property (nonatomic, strong) NSMutableString *city;//当前城市名
@property (nonatomic, strong) NSMutableString *state_id;//当前州ID
@property (nonatomic, strong) NSMutableString *city_id;//当前城市ID

@end

@implementation FoundListScreenView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
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
    self.city = [[NSMutableString alloc] initWithString:@""];
    self.state = [[NSMutableString alloc] initWithString:@""];
    self.state_id = [[NSMutableString alloc] initWithString:@""];
    self.city_id = [[NSMutableString alloc] initWithString:@""];
}
- (void)PrepareUI{
    self.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backAction)];
    [self addGestureRecognizer:tap];
}

#pragma mark - --------------UIConfig----------------------
-(void)UIConfig{
    //创建背景
    [self createBackView];
    //创建筛选主视图
    [self createScreenMainView];
}
//创建背景
-(void)createBackView{
    _backImgView = [UIImageView getImgWithImageStr:@"蒙板"];
    [self addSubview:_backImgView];
    [_backImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    _backImgView.contentMode = UIViewContentModeScaleToFill;
}
//创建筛选主视图
-(void)createScreenMainView{
    [self showSpecifiedView:_screenMainView];
    if(!_screenMainView){
        WeakSelf(ws);
        _screenMainView = [[FoundListScreenMainView alloc] initWithFrame:CGRectZero];
        [_backImgView addSubview:_screenMainView];
        [_screenMainView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(70*_Scale);
            make.right.mas_equalTo(-70*_Scale);
            make.centerY.mas_equalTo(_backImgView);
        }];
        [_screenMainView setScreenMainViewBlock:^(NSString *type) {
            if([type isEqualToString:@"chooseState"]){
                //选择所在州
                [ws createChooseStateView];
            }else if([type isEqualToString:@"chooseCity"]){
                //选择所在城市
                [ws tryToCreateChooseCityView];
            }else if([type isEqualToString:@"screen"]){
                //筛选
                [ws screenAction];
            }
        }];
    }else{
        _screenMainView.hidden = NO;
    }
}
//创建选择城市view
-(void)createChooseCityView{
    [self showSpecifiedView:_screenCityView];
    if(!_screenCityView){
        WeakSelf(ws);
        CGFloat y_p=(ScreenHeight-485*_Scale)*(2.0f/5.0f);
        _screenCityView = [[FoundListScreenCityView alloc] initWithFrame:CGRectZero];
        [_backImgView addSubview:_screenCityView];
        [_screenCityView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(y_p);
            make.width.mas_equalTo(440*_Scale);
            make.centerX.mas_equalTo(_backImgView);
        }];
        [_screenCityView setScreenCityViewBlock:^(NSString *type) {
            if([type isEqualToString:@"allCity"]){
                [ws setAllCity];
            }else if([type isEqualToString:@"selectedCity"]){
                [ws selectedCity];
            }
        }];
        _screenCityView.city = _city;
        _screenCityView.city_id = _city_id;
        _screenCityView.state = _state;
        _screenCityView.state_id = _state_id;
        [_screenCityView updateUI];
    }else{
        _screenCityView.hidden = NO;
        [_screenCityView updateUI];
    }
}
//创建选择州view
-(void)createChooseStateView{
    [self showSpecifiedView:_screenStateView];
    if(!_screenStateView){
        WeakSelf(ws);
        CGFloat y_p=(ScreenHeight-485*_Scale)*(2.0f/5.0f);
        _screenStateView = [[FoundListScreenStateView alloc] initWithFrame:CGRectZero];
        [_backImgView addSubview:_screenStateView];
        [_screenStateView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(y_p);
            make.width.mas_equalTo(360*_Scale);
            make.height.mas_equalTo(600*_Scale);
            make.centerX.mas_equalTo(_backImgView);
        }];
        [_screenStateView setScreenStateViewBlock:^(NSString *type) {
            if([type isEqualToString:@"allState"]){
                [ws setAllState];
            }else if([type isEqualToString:@"selectedState"]){
                [ws selectedState];
            }
        }];
        _screenStateView.city = _city;
        _screenStateView.city_id = _city_id;
        _screenStateView.state = _state;
        _screenStateView.state_id = _state_id;
    }else{
        _screenStateView.hidden = NO;
        [_screenStateView updateUI];
    }
}
#pragma mark - --------------UpdateUI----------------------
-(void)updateUI{
    [self updateScreenMainView];
}
-(void)updateScreenMainView{
    _screenMainView.state = _state;
    _screenMainView.city = _city;
    _screenMainView.state_id = _state_id;
    _screenMainView.city_id = _city_id;
    _screenMainView.total_students_min = _total_students_min;
    _screenMainView.ap_count_max = _ap_count_max;
    _screenMainView.total_students_max = _total_students_max;
    _screenMainView.ap_count_min = _ap_count_min;

    [_screenMainView updateUI];
}
#pragma mark - --------------系统代理----------------------

#pragma mark - --------------自定义响应----------------------
//筛选
-(void)screenAction{
    if(_screenViewBlock){
        _screenViewBlock(@"screen");
    }
}
-(void)selectedState{
    if(_screenMainView){
        [_screenMainView updateUI];
        [self backAction];
    }
}
-(void)selectedCity{
    if(_screenMainView){
        [_screenMainView updateUI];
        [self backAction];
    }
}
-(void)backAction{
    if(_screenCityView && !_screenCityView.hidden){
        //城市视图时蒙版被点击
        [self showSpecifiedView:_screenMainView];
        if(_screenMainView){
            _screenMainView.hidden = NO;
        }
    }else if(_screenStateView && !_screenStateView.hidden){
        //州视图时蒙版被点击
        [self showSpecifiedView:_screenMainView];
        if(_screenMainView){
            _screenMainView.hidden = NO;
        }
    }else if(_screenMainView && !_screenMainView.hidden){
        //首视图是蒙版被点击
        if(_screenViewBlock){
            _screenViewBlock(@"hideAll");
        }
    }
}
-(void)setAllState{
    if(_screenMainView){
        [_city setString:@""];
        [_city_id setString:@""];
        [_state setString:@""];
        [_state_id setString:@""];
        [_screenMainView updateUI];
        [self backAction];
    }
}
-(void)setAllCity{
    if(_screenMainView){
        [_city setString:@""];
        [_city_id setString:@""];
        [_screenMainView updateUI];
        [self backAction];
    }
}
#pragma mark - --------------自定义方法----------------------
-(NSMutableDictionary *)getParameters{
    return [_screenMainView getParameters];
}
//创建选择城市view
-(void)tryToCreateChooseCityView{
    //        所在城市
    if([NSString isNilOrEmpty:_state])
    {
        [[ToolManager sharedManager] alertTitle_Simple:@"请先选择州"];
    }else
    {
        [self createChooseCityView];
    }
}
-(void)initializeUI{
    if(_screenMainView){
        [_screenMainView initializeUI];
    }
}
-(void)showSpecifiedView:(UIView *)view{
    if(view == _screenCityView){
        //展示选城市视图
        if(_screenMainView){
            _screenMainView.hidden = YES;
        }
        if(_screenStateView){
            _screenStateView.hidden = YES;
        }
    }else if(view == _screenStateView){
        //展示选州视图
        if(_screenMainView){
            _screenMainView.hidden = YES;
        }
        if(_screenCityView){
            _screenCityView.hidden = YES;
        }
    }else if(view == _screenMainView){
        //展示首视图
        if(_screenStateView){
            _screenStateView.hidden = YES;
        }
        if(_screenCityView){
            _screenCityView.hidden = YES;
        }
    }
}

#pragma mark - --------------other----------------------


@end
