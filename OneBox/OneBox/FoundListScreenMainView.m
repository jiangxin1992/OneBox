//
//  FoundListScreenMainView.m
//  OneBox
//
//  Created by yyj on 2018/4/9.
//  Copyright © 2018年 谢江新. All rights reserved.
//

#import "FoundListScreenMainView.h"

#import "NMRangeSlider.h"

@interface FoundListScreenMainView()

@property (nonatomic, copy) NSMutableArray *screen_btnArr;

@property (nonatomic, strong) UIView *locationChooseView;
@property (nonatomic, strong) UIView *schoolSexTypeView;
@property (nonatomic, strong) UIView *chooseStudentNumView;
@property (nonatomic, strong) UIView *schoolSeniorTypeView;
@property (nonatomic, strong) UIView *chooseAPCourseNumView;

@property (nonatomic, copy) NSMutableString* ismixed;//是否是混校
@property (nonatomic, copy) NSMutableString* ismale;//是否是男校
@property (nonatomic, copy) NSMutableString* isfemale;//是否是女校
@property (nonatomic, copy) NSMutableString* isday;//是否是走读学校
@property (nonatomic, copy) NSMutableString* isboardind;//是否是寄宿学校
@property (nonatomic, copy) NSMutableString* isjunior;//是否是初中
@property (nonatomic, copy) NSMutableString* issenior;//是否是高中
@property (nonatomic, copy) NSMutableString* isESL;//是否ESL

@property (nonatomic, copy) NSArray *screen_normalImg;//记录筛选view btn normal状态下的image
@property (nonatomic, copy) NSArray *screen_selectImg;//记录筛选view btn select状态下的image
@property (nonatomic, copy) NSArray *screen_titleArr;//记录筛选view btn 的title

@property (nonatomic, strong) UIButton *stateLocationBtn;
@property (nonatomic, strong) UIButton *cityLocationBtn;

//slider相关
@property (nonatomic, strong) NMRangeSlider *studentNumSlider;
@property (nonatomic, strong) NMRangeSlider *apCourseNumSlider;
@property (nonatomic, strong) UILabel *studentNumLeftLabel;
@property (nonatomic, strong) UILabel *studentNumRightLabel;
@property (nonatomic, strong) UILabel *apCourseNumLeftLabel;
@property (nonatomic, strong) UILabel *apCourseNumRightLabel;

@end

@implementation FoundListScreenMainView

#pragma mark - --------------生命周期--------------
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

    _stateLocationBtn = [UIButton getCustomTitleBtnWithAlignment:0 WithFont:11.0f WithSpacing:0 WithNormalTitle:nil WithNormalColor:_define_blue_color WithSelectedTitle:nil WithSelectedColor:nil];
    _cityLocationBtn = [UIButton getCustomTitleBtnWithAlignment:0 WithFont:11.0f WithSpacing:0 WithNormalTitle:nil WithNormalColor:_define_blue_color WithSelectedTitle:nil WithSelectedColor:nil];

    _studentNumLeftLabel = [UILabel getLabelWithAlignment:0 WithTitle:nil WithFont:12.0f WithTextColor:_define_blue_color WithSpacing:0];
    _studentNumRightLabel = [UILabel getLabelWithAlignment:2 WithTitle:nil WithFont:12.0f WithTextColor:_define_blue_color WithSpacing:0];

    _apCourseNumLeftLabel = [UILabel getLabelWithAlignment:0 WithTitle:nil WithFont:12.0f WithTextColor:_define_blue_color WithSpacing:0];
    _apCourseNumRightLabel = [UILabel getLabelWithAlignment:2 WithTitle:nil WithFont:12.0f WithTextColor:_define_blue_color WithSpacing:0];


    _screen_titleArr=@[@[@"混 校",@"女 校",@"男 校",@"ESL"],@[@"走 读",@"寄 宿",@"高 中",@"初 中"]];
    _screen_normalImg=@[@[@"screenShcool_混合学校未点击",@"screenShcool_女校未点击",@"screenShcool_男校未选中",@"screenShcool_无esl1"],@[@"screenShcool_走读未选中",@"screenShcool_寄宿未选中",@"screenShcool_高中未选中",@"screenShcool_初中未选中"]];
    _screen_selectImg=@[@[@"screenShcool_混校",@"screenShcool_女校",@"screenShcool_男校",@"screenShcool_esl"],@[@"screenShcool_走读",@"screenShcool_寄宿",@"screenShcool_高中",@"screenShcool_初中"]];

    _ismixed = [[NSMutableString alloc] initWithString:@"0"];
    _ismale = [[NSMutableString alloc] initWithString:@"0"];
    _isfemale = [[NSMutableString alloc] initWithString:@"0"];
    _isday = [[NSMutableString alloc] initWithString:@"0"];
    _isboardind = [[NSMutableString alloc] initWithString:@"0"];
    _isjunior = [[NSMutableString alloc] initWithString:@"0"];
    _issenior = [[NSMutableString alloc] initWithString:@"0"];
    _isESL = [[NSMutableString alloc] initWithString:@"0"];

    //    初始化该数组用来存放btn
    _screen_btnArr=[[NSMutableArray alloc] init];
}
- (void)PrepareUI{
    self.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nullAction)];
    [self addGestureRecognizer:tap];

    self.backgroundColor = _define_white_color;
}

#pragma mark - --------------UIConfig----------------------
-(void)UIConfig{
    //    创建州和城市选择视图
    [self createLocationChooseView];
    //    创建学校类型(性别)视图
    [self createSchoolSexTypeView];
    //    创建选择学生人数视图
    [self createChooseStudentNumView];
    //    创建学校类型(年级)视图
    [self createSchoolSeniorTypeView];
    //    创建选择ap课程数视图
    [self createChooseAPCourseNumView];
    //    创建筛选按钮
    [self createScreenBtn];
}
//    创建州和城市选择界面
-(void)createLocationChooseView
{
    _locationChooseView = [UIView getCustomViewWithColor:_define_white_color];
    [self addSubview:_locationChooseView];
    [_locationChooseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(100*_Scale);
    }];

    UIView *lastView = nil;
    //创建所在州，所在城市btn，（显示用户最后操作的btn状态）
    for (int i = 0; i < 2; i++) {

        UIButton *locationBtn = i==0?_stateLocationBtn:_cityLocationBtn;
        [_locationChooseView addSubview:locationBtn];
        [locationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(46*_Scale);
            make.centerY.mas_equalTo(_locationChooseView);
            if(!lastView){
                make.left.mas_equalTo(18*_Scale);
            }else{
                make.right.mas_equalTo(-18*_Scale);
                make.left.mas_equalTo(lastView.mas_right).with.offset(18*_Scale);
                make.width.mas_equalTo(lastView);
            }
        }];
        [locationBtn setBackgroundColor:[UIColor colorWithRed:246.0f/255.0f green:246.0f/255.0f blue:246.0f/255.0f alpha:1]];
        [locationBtn addTarget:self action:@selector(chooseLoc:) forControlEvents:UIControlEventTouchUpInside];
        lastView = locationBtn;
    }
}
//    创建学校类型(性别)
-(void)createSchoolSexTypeView
{
    _schoolSexTypeView = [UIView getCustomViewWithColor:_define_white_color];
    [self addSubview:_schoolSexTypeView];
    [_schoolSexTypeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_locationChooseView.mas_bottom).with.offset(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(150*_Scale);
    }];

    UIView *upLine = [UIView getCustomViewWithColor:[UIColor colorWithRed:220.0f/255.0f green:220.0f/255.0f blue:220.0f/255.0f alpha:1]];
    [_schoolSexTypeView addSubview:upLine];
    [upLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(14*_Scale);
        make.right.mas_equalTo(-14*_Scale);
        make.height.mas_equalTo(1*_Scale);
    }];

    UIView *downLine = [UIView getCustomViewWithColor:[UIColor colorWithRed:220.0f/255.0f green:220.0f/255.0f blue:220.0f/255.0f alpha:1]];
    [_schoolSexTypeView addSubview:downLine];
    [downLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(14*_Scale);
        make.right.mas_equalTo(-14*_Scale);
        make.height.mas_equalTo(1*_Scale);
    }];

    NSArray *temp_titleArr = _screen_titleArr[0];
    NSArray *temp_normalImg = _screen_normalImg[0];
    NSArray *temp_selectImg = _screen_selectImg[0];

    CGFloat radius = 60*_Scale;
    CGFloat jiange_min = 44*_Scale;
    CGFloat jiange_max = 70*_Scale;
    CGFloat bianju = (ScreenWidth - 140*_Scale - radius*4 - jiange_min*2 - jiange_max)/2.f;
    UIView *lastView = nil;
    for (int i = 0; i < temp_titleArr.count; i++) {
        UIButton *typeBtn = [UIButton getCustomBackImgBtnWithImageStr:temp_normalImg[i] WithSelectedImageStr:temp_selectImg[i]];
        [_schoolSexTypeView addSubview:typeBtn];
        [typeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            if(!lastView){
                make.top.mas_equalTo(upLine.mas_bottom).with.offset(28*_Scale);
                make.left.mas_equalTo(bianju);
            }else{
                make.top.mas_equalTo(lastView);
                make.left.mas_equalTo(lastView.mas_right).with.offset(i==3?jiange_max:jiange_min);
            }
            make.width.height.mas_equalTo(radius);
        }];
        typeBtn.tag = 500 + 0*10 + i;
        [typeBtn addTarget:self action:@selector(screenAction:) forControlEvents:UIControlEventTouchUpInside];
        [_screen_btnArr addObject:typeBtn];

        if(i == 2){
            UIView *middleLine = [UIView getCustomViewWithColor:_define_backview_color];
            [_schoolSexTypeView addSubview:middleLine];
            [middleLine mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(10*_Scale);
                make.bottom.mas_equalTo(-10*_Scale);
                make.width.mas_equalTo(1*_Scale);
                make.left.mas_equalTo(typeBtn.mas_right).with.offset(34*_Scale);
            }];
        }

        UILabel *typeLabel = [UILabel getLabelWithAlignment:1 WithTitle:temp_titleArr[i] WithFont:12.0f WithTextColor:[UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1] WithSpacing:0];
        [_schoolSexTypeView addSubview:typeLabel];
        [typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(typeBtn.mas_bottom).with.offset(0);
            make.width.mas_equalTo(70*_Scale);
            make.centerX.mas_equalTo(typeBtn);
            make.bottom.mas_equalTo(-20*_Scale);
        }];


        lastView = typeBtn;
    }
}
//    创建选择学生人数视图
-(void)createChooseStudentNumView{
    _chooseStudentNumView = [UIView getCustomViewWithColor:_define_white_color];
    [self addSubview:_chooseStudentNumView];
    [_chooseStudentNumView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_schoolSexTypeView.mas_bottom).with.offset(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(119*_Scale);
    }];

    //    创建slider
    _studentNumSlider = [[NMRangeSlider alloc] initWithFrame:CGRectZero];
    [_chooseStudentNumView addSubview:_studentNumSlider];
    [_studentNumSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30*_Scale);
        make.right.mas_equalTo(-30*_Scale);
        make.height.mas_equalTo(25);
        make.centerY.mas_equalTo(_chooseStudentNumView).with.offset(-15*_Scale);
    }];

    //    slider被拖动时调用(改变左右label的值)
    [_studentNumSlider addTarget:self action:@selector(valueChangedForDoubleSlider:) forControlEvents:UIControlEventValueChanged];


    //    创建slider下部标题
    UILabel *sliderTitlelabel = [UILabel getLabelWithAlignment:1 WithTitle:@"学生数" WithFont:11.f WithTextColor:[UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1] WithSpacing:0];
    [_chooseStudentNumView addSubview:sliderTitlelabel];
    [sliderTitlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(_studentNumSlider.mas_centerY).with.offset(0);
    }];

    //    创建slider下部左右label
    for (int i = 0; i < 2; i++) {

        UILabel *label=i==0?_studentNumLeftLabel:_studentNumRightLabel;;
        [_chooseStudentNumView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            if(i==0){
                make.left.mas_equalTo(30*_Scale);
            }else{
                make.right.mas_equalTo(-30*_Scale);
            }
            make.height.mas_equalTo(sliderTitlelabel);
            make.width.mas_equalTo(80*_Scale);
            make.top.mas_equalTo(sliderTitlelabel);
        }];


        label.font=[regular get_en_Font:12.0f];
    }
}
//    创建学校类型(年级)视图
-(void)createSchoolSeniorTypeView{
    _schoolSeniorTypeView = [UIView getCustomViewWithColor:_define_white_color];
    [self addSubview:_schoolSeniorTypeView];
    [_schoolSeniorTypeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(_chooseStudentNumView.mas_bottom).with.offset(0);;
        make.height.mas_equalTo(150*_Scale);
    }];

    UIView *upLine = [UIView getCustomViewWithColor:[UIColor colorWithRed:220.0f/255.0f green:220.0f/255.0f blue:220.0f/255.0f alpha:1]];
    [_schoolSeniorTypeView addSubview:upLine];
    [upLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(14*_Scale);
        make.right.mas_equalTo(-14*_Scale);
        make.height.mas_equalTo(1*_Scale);
    }];

    UIView *downLine = [UIView getCustomViewWithColor:[UIColor colorWithRed:220.0f/255.0f green:220.0f/255.0f blue:220.0f/255.0f alpha:1]];
    [_schoolSeniorTypeView addSubview:downLine];
    [downLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(14*_Scale);
        make.right.mas_equalTo(-14*_Scale);
        make.height.mas_equalTo(1*_Scale);
    }];

    NSArray *temp_titleArr = _screen_titleArr[1];
    NSArray *temp_normalImg = _screen_normalImg[1];
    NSArray *temp_selectImg = _screen_selectImg[1];

    CGFloat radius = 60*_Scale;
    CGFloat jiange_min = 44*_Scale;
    CGFloat jiange_max = 70*_Scale;
    CGFloat bianju = (ScreenWidth - 140*_Scale - radius*4 - jiange_min*2 - jiange_max)/2.f;
    UIView *lastView = nil;
    for (int i = 0; i < temp_titleArr.count; i++) {
        UIButton *typeBtn = [UIButton getCustomBackImgBtnWithImageStr:temp_normalImg[i] WithSelectedImageStr:temp_selectImg[i]];
        [_schoolSeniorTypeView addSubview:typeBtn];
        [typeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            if(!lastView){
                make.top.mas_equalTo(upLine.mas_bottom).with.offset(28*_Scale);
                make.left.mas_equalTo(bianju);
            }else{
                make.top.mas_equalTo(lastView);
                make.left.mas_equalTo(lastView.mas_right).with.offset(i==2?jiange_max:jiange_min);
            }
            make.width.height.mas_equalTo(radius);
        }];
        typeBtn.tag = 500 + 1*10 + i;
        [typeBtn addTarget:self action:@selector(screenAction:) forControlEvents:UIControlEventTouchUpInside];
        [_screen_btnArr addObject:typeBtn];

        if(i == 1){
            UIView *middleLine = [UIView getCustomViewWithColor:_define_backview_color];
            [_schoolSeniorTypeView addSubview:middleLine];
            [middleLine mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(10*_Scale);
                make.bottom.mas_equalTo(-10*_Scale);
                make.width.mas_equalTo(1*_Scale);
                make.left.mas_equalTo(typeBtn.mas_right).with.offset(34*_Scale);
            }];
        }

        UILabel *typeLabel = [UILabel getLabelWithAlignment:1 WithTitle:temp_titleArr[i] WithFont:12.0f WithTextColor:[UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1] WithSpacing:0];
        [_schoolSeniorTypeView addSubview:typeLabel];
        [typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(typeBtn.mas_bottom).with.offset(0);
            make.width.mas_equalTo(70*_Scale);
            make.centerX.mas_equalTo(typeBtn);
            make.bottom.mas_equalTo(-20*_Scale);
        }];

        lastView = typeBtn;
    }
}
//    创建选择ap课程数视图
-(void)createChooseAPCourseNumView{
    _chooseAPCourseNumView = [UIView getCustomViewWithColor:_define_white_color];
    [self addSubview:_chooseAPCourseNumView];
    [_chooseAPCourseNumView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_schoolSeniorTypeView.mas_bottom).with.offset(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(119*_Scale);
    }];

    _apCourseNumSlider = [[NMRangeSlider alloc] initWithFrame:CGRectZero];
    [_chooseAPCourseNumView addSubview:_apCourseNumSlider];
    [_apCourseNumSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30*_Scale);
        make.right.mas_equalTo(-30*_Scale);
        make.height.mas_equalTo(25);
        make.centerY.mas_equalTo(_chooseAPCourseNumView).with.offset(-15*_Scale);
    }];

    //    slider被拖动时调用(改变左右label的值)
    [_apCourseNumSlider addTarget:self action:@selector(valueChangedForDoubleSlider:) forControlEvents:UIControlEventValueChanged];

    //    创建slider下部标题
    UILabel *sliderTitlelabel = [UILabel getLabelWithAlignment:1 WithTitle:@"AP数" WithFont:11.f WithTextColor:[UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1] WithSpacing:0];
    [_chooseAPCourseNumView addSubview:sliderTitlelabel];
    [sliderTitlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(_apCourseNumSlider.mas_centerY).with.offset(0);
    }];

    //    创建slider下部左右label
    for (int i = 0; i < 2; i++) {

        UILabel *label=i==0?_apCourseNumLeftLabel:_apCourseNumRightLabel;
        [_chooseAPCourseNumView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            if(i==0){
                make.left.mas_equalTo(30*_Scale);
            }else{
                make.right.mas_equalTo(-30*_Scale);
            }
            make.height.mas_equalTo(sliderTitlelabel);
            make.width.mas_equalTo(80*_Scale);
            make.top.mas_equalTo(sliderTitlelabel);
        }];


        label.font=[regular get_en_Font:12.0f];
    }
}
//    创建筛选按钮
-(void)createScreenBtn{
    UIButton *screenBtn=[UIButton getCustomTitleBtnWithAlignment:0 WithFont:14.0f WithSpacing:7.0 WithNormalTitle:@"筛选" WithNormalColor:_define_white_color WithSelectedTitle:nil WithSelectedColor:nil];
    [self addSubview:screenBtn];
    [screenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(_chooseAPCourseNumView.mas_bottom).with.offset(0);
        make.height.mas_equalTo(60*_Scale);
    }];
    screenBtn.backgroundColor=[UIColor colorWithRed:107.0f/255.0f green:203.0f/255.0f blue:202.0f/255.0f alpha:1];
    [screenBtn addTarget:self action:@selector(screenBtnAction:) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark - --------------UpdateUI----------------------
-(void)updateUI{

    [_stateLocationBtn setTitle:[self getStateName] forState:UIControlStateNormal];
    [_cityLocationBtn setTitle:[self getCityName] forState:UIControlStateNormal];

//    设置slider
    if(_total_students_min < _total_students_max){
        _studentNumSlider.minimumValue = [_total_students_min longValue];
        _studentNumSlider.maximumValue = [_total_students_max longValue];
        _studentNumSlider.lowerValue = [_total_students_min longValue];
        _studentNumSlider.upperValue = [_total_students_max longValue];
    }

    _studentNumLeftLabel.text = [[NSString alloc] initWithFormat:@"%ld",[_total_students_min longValue]];
    _studentNumRightLabel.text = [[NSString alloc] initWithFormat:@"%ld",[_total_students_max longValue]];

    if(_ap_count_min < _ap_count_max){
        _apCourseNumSlider.minimumValue = [_ap_count_min longValue];
        _apCourseNumSlider.maximumValue = [_ap_count_max longValue];
        _apCourseNumSlider.lowerValue = [_ap_count_min longValue];
        _apCourseNumSlider.upperValue = [_ap_count_max longValue];
    }

    _apCourseNumLeftLabel.text = [[NSString alloc] initWithFormat:@"%ld",[_ap_count_min longValue]];
    _apCourseNumRightLabel.text = [[NSString alloc] initWithFormat:@"%ld",[_ap_count_max longValue]];

    [self setBtnState];
}

#pragma mark - --------------系统代理----------------------
//slider滑动时候触发的方法，改变下面label的值
-(void)valueChangedForDoubleSlider:(NMRangeSlider *)slider
{
    JXLOG(@"up=%f,down=%f",slider.upperValue,slider.lowerValue);
    if(slider == _studentNumSlider)
    {
        _studentNumLeftLabel.text = [[NSString alloc] initWithFormat:@"%.f",slider.lowerValue];
        _studentNumRightLabel.text = [[NSString alloc] initWithFormat:@"%.f",slider.upperValue];
    }else if(slider == _apCourseNumSlider)
    {
        _apCourseNumLeftLabel.text = [[NSString alloc] initWithFormat:@"%.f",slider.lowerValue];
        _apCourseNumRightLabel.text = [[NSString alloc] initWithFormat:@"%.f",slider.upperValue];
    }
}
#pragma mark - --------------自定义响应----------------------
//选择loc
-(void)chooseLoc:(UIButton *)sender{
    if(_screenMainViewBlock){
        if(sender == _stateLocationBtn){
            //选择所在州
            _screenMainViewBlock(@"chooseState");
        }else if(sender == _cityLocationBtn){
            //选择所在城市
            _screenMainViewBlock(@"chooseCity");
            //            //        所在城市
            //            if([_state isEqualToString:@""])
            //            {
            //                [[ToolManager sharedManager] alertTitle_Simple:@"请先选择州"];
            //            }else
            //            {
            //                [self createChooseCityView];
            //                UIView *backView=[self.view viewWithTag:200];
            //                backView.hidden=YES;
            //            }
        }
    }
}
//筛选
-(void)screenBtnAction:(UIButton *)btn{
    if(_screenMainViewBlock){
        _screenMainViewBlock(@"screen");
    }
}
//btn点击时出发的selected方法
-(void)screenAction:(UIButton *)btn
{
    if(btn.selected)
    {
        btn.selected=NO;
    }else
    {
        btn.selected=YES;
    }
}
-(void)nullAction{}

#pragma mark - --------------自定义方法----------------------
-(NSMutableDictionary *)getParameters{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    if(self){
        NSArray *stateArr = @[_ismixed,_isfemale,_ismale,_isESL,_isday,_isboardind,_issenior,_isjunior];
        for (int i = 0; i < _screen_btnArr.count; i ++) {
            UIButton *btn = (UIButton *)_screen_btnArr[i];
            if(!btn.selected)
            {
                [(NSMutableString *)stateArr[i] setString:@"0"];
            }else
            {
                [(NSMutableString *)stateArr[i] setString:@"1"];
            }
        }

        NSMutableArray *sexarr = [[NSMutableArray alloc] init];

        if(((UIButton *)_screen_btnArr[1]).selected)
        {
            [sexarr addObject:@"0"];
        }
        if(((UIButton *)_screen_btnArr[2]).selected)
        {
            [sexarr addObject:@"1"];
        }
        if(((UIButton *)_screen_btnArr[0]).selected)
        {
            [sexarr addObject:@"2"];
        }else if((((UIButton *)_screen_btnArr[0]).selected)&&(((UIButton *)_screen_btnArr[1]).selected)&&(((UIButton *)_screen_btnArr[2]).selected))
        {
            [sexarr addObject:@"2"];
            [sexarr addObject:@"1"];
            [sexarr addObject:@"0"];
        }
        if(!(!(((UIButton *)_screen_btnArr[0]).selected)&&(!((UIButton *)_screen_btnArr[1]).selected)&&(!((UIButton *)_screen_btnArr[2]).selected)))
        {
            [parameters setObject:sexarr forKey:@"student_sex_limit"];
        }

        if(((UIButton *)_screen_btnArr[3]).selected)
        {
            [parameters setObject:@"1" forKey:@"isesl"];
        }

        NSMutableArray *schoolStyle=[[NSMutableArray alloc] init];
        if(((UIButton *)_screen_btnArr[7]).selected)
        {
            [schoolStyle addObject:@"junior"];
        }
        if(((UIButton *)_screen_btnArr[6]).selected)
        {
            [schoolStyle addObject:@"senior"];
        }else if ((((UIButton *)_screen_btnArr[7]).selected)&&(((UIButton *)_screen_btnArr[6]).selected))
        {
            [schoolStyle addObject:@"junior"];
            [schoolStyle addObject:@"senior"];
        }

        if(!(!(((UIButton *)_screen_btnArr[6]).selected)&&(!((UIButton *)_screen_btnArr[7]).selected)))
        {
            [parameters setObject:schoolStyle forKey:@"branch_type"];
        }

        NSMutableArray *schoolStyle2=[[NSMutableArray alloc] init];

        if(((UIButton *)_screen_btnArr[5]).selected)
        {
            [schoolStyle2 addObject:@"boarding"];
        }
        if(((UIButton *)_screen_btnArr[4]).selected)
        {
            [schoolStyle2 addObject:@"day"];
        }else if((((UIButton *)_screen_btnArr[4]).selected)&&(((UIButton *)_screen_btnArr[5]).selected))
        {
            [schoolStyle2 addObject:@"boarding"];
            [schoolStyle2 addObject:@"day"];
        }

        if(!(!(((UIButton *)_screen_btnArr[4]).selected)&&(!((UIButton *)_screen_btnArr[5]).selected)))
        {
            [parameters setObject:schoolStyle2 forKey:@"boarding_day"];
        }

        if((![_state isEqualToString:@""])&&(![_state isEqualToString:@"所在州"])&&((_state!=nil)))
        {
            [parameters setObject:[[NSString alloc] initWithFormat:@"%@",_state_id] forKey:@"us_state_id"];
        }
        if((![_city isEqualToString:@""])&&(![_city isEqualToString:@"所在城市"])&&(_city!=nil))
        {
            [parameters setObject:[[NSString alloc] initWithFormat:@"%@",_city_id] forKey:@"us_city_id"];
        }

        //    if(_page>0)
        //    {
        //        [dict setObject:[[NSString alloc] initWithFormat:@"%ld",(long)_page] forKey:@"page"];
        //    }

        [parameters setObject:[regular getToken] forKey:@"token"];

        if([_total_students_min longValue]!=[_studentNumLeftLabel.text integerValue] || [_total_students_max longValue]!=[_studentNumRightLabel.text integerValue] || [_ap_count_max longValue]!=[_apCourseNumRightLabel.text integerValue] || [_ap_count_min longValue]!=[_apCourseNumLeftLabel.text integerValue])
        {
            [parameters setObject:[[NSString alloc] initWithFormat:@"%@,%@",_apCourseNumLeftLabel.text,_apCourseNumRightLabel.text] forKey:@"ap_count"];
            [parameters setObject:[[NSString alloc] initWithFormat:@"%@,%@",_studentNumLeftLabel.text,_studentNumRightLabel.text] forKey:@"total_students"];
        }
    }

    return parameters;
}
-(void)initializeUI{
    [self updateUI];
}
//将btn的selected状态设为之前保存的状态,1表示selected状态，0反之
-(void)setBtnState
{
    NSArray *array = @[_ismixed,_isfemale,_ismale,_isESL,_isday,_isboardind,_issenior,_isjunior];
    if(array.count == _screen_btnArr.count){
        for (int i = 0; i < array.count; i ++) {
            NSString *value = array[i];
            UIButton *btn = _screen_btnArr[i];
            if([value isEqualToString:@"1"])
            {
                btn.selected=YES;
            }else
            {
                btn.selected=NO;
            }
        }
    }
}
-(NSString *)getStateName{
    NSString *title = nil;
    if([NSString isNilOrEmpty:_state]){
        title = @"所在州";
    }else{
        title = _state;
    }
    return title;
}
-(NSString *)getCityName{
    NSString *title = nil;
    if([NSString isNilOrEmpty:_city]){
        title = @"所在城市";
    }else{
        title = _city;
    }
    return title;
}
#pragma mark - --------------other----------------------


@end
