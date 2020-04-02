//
//  FoundListScreenCityView.m
//  OneBox
//
//  Created by yyj on 2018/4/12.
//  Copyright © 2018年 谢江新. All rights reserved.
//

#import "FoundListScreenCityView.h"

@interface FoundListScreenCityView()

@property (nonatomic, copy) NSMutableArray *cityArr;//存放城市的获取数据

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIView *container;
@property (nonatomic,strong) UIView *upview;
@property (nonatomic,strong) UIButton *all_city;
@property (nonatomic,strong) NSMutableArray *btnArr;

@end

@implementation FoundListScreenCityView

#define blueColor [UIColor colorWithRed:65.0f/255.0f green:176.0f/255.0f blue:211.0f/255.0f alpha:1]

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
    _cityArr = [[NSMutableArray alloc] init];
    _btnArr = [[NSMutableArray alloc] init];
}
- (void)PrepareUI{
    self.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nullAction)];
    [self addGestureRecognizer:tap];
}
#pragma mark - --------------UIConfig----------------------
-(void)UIConfig{
    //背景upview
    _upview = [UIView getCustomViewWithColor:blueColor];
    [self addSubview:_upview];
    [_upview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(29*_Scale);
        make.height.mas_equalTo(500*_Scale);
    }];

    //创建所有城市按钮
    _all_city = [UIButton getCustomTitleBtnWithAlignment:0 WithFont:12.0f WithSpacing:5.0 WithNormalTitle:@"所有市" WithNormalColor:_define_white_color WithSelectedTitle:nil WithSelectedColor:nil];
    [self addSubview:_all_city];
    [_all_city mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_upview.mas_bottom).with.offset(4);
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(50*_Scale);
    }];
    _all_city.backgroundColor=[UIColor colorWithRed:107.0f/255.0f green:203.0f/255.0f blue:202.0f/255.0f alpha:1];
    [_all_city addTarget:self action:@selector(allCityAction:) forControlEvents:UIControlEventTouchUpInside];
    //    设为隐藏状态，数据获取后再显示
    _all_city.hidden=YES;


    //创建scrollview
    _scrollView = [[UIScrollView alloc] init];
    [_upview addSubview:_scrollView];
    _container = [UIView new];
    [_scrollView addSubview:_container];
    [_container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_scrollView);
        make.width.equalTo(_scrollView);
    }];
    // 禁止弹簧效果
    _scrollView.bounces = NO;
    _scrollView.backgroundColor = blueColor;
    _scrollView.showsVerticalScrollIndicator=YES;

    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10*_Scale);
        make.right.mas_equalTo(-10*_Scale);
        make.top.mas_equalTo(30*_Scale);
        make.bottom.mas_equalTo(-30*_Scale);
    }];
}
-(void)createScrollViewContent{
    UIView *lastView = nil;
    for (int i = 0; i < _cityArr.count; i++) {
        UIButton *cityBtn = [UIButton getCustomTitleBtnWithAlignment:0 WithFont:11.0f WithSpacing:0 WithNormalTitle:[_cityArr[i] objectForKey:@"en_name"] WithNormalColor:_define_white_color WithSelectedTitle:nil WithSelectedColor:nil];
        [_container addSubview:cityBtn];
        [cityBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(42*_Scale);
            if(!lastView){
                make.top.mas_equalTo(0);
            }else{
                make.top.mas_equalTo(lastView.mas_bottom).with.offset(0);
            }
            if(i == _cityArr.count - 1){
                make.bottom.mas_equalTo(0);
            }
        }];
        cityBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [cityBtn addTarget:self action:@selector(cityAction:) forControlEvents:UIControlEventTouchUpInside];
        [cityBtn setBackgroundColor:blueColor];


        UILabel *en_nameLabel = [UILabel getLabelWithAlignment:2 WithTitle:[_cityArr[i] objectForKey:@"en_name"] WithFont:12.0f WithTextColor:_define_white_color WithSpacing:1.0];
        [cityBtn addSubview:en_nameLabel];
        [en_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.mas_equalTo(0);
        }];
        en_nameLabel.backgroundColor = blueColor;


        UILabel *cn_nameLabel = [UILabel getLabelWithAlignment:0 WithTitle:[_cityArr[i] objectForKey:@"cn_name"] WithFont:12.0f WithTextColor:_define_white_color WithSpacing:1.0f];
        [cityBtn addSubview:cn_nameLabel];
        [cn_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.mas_equalTo(0);
            make.width.mas_equalTo(en_nameLabel);
            make.left.mas_equalTo(en_nameLabel.mas_right).with.offset(22*_Scale);
        }];
        cn_nameLabel.backgroundColor = blueColor;


        UIView *downLine = [UIView getCustomViewWithColor:[UIColor colorWithRed:134.0f/255.0f green:210.0f/255.0f blue:219.0f/255.0f alpha:1]];
        [cityBtn addSubview:downLine];
        [downLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(-5);
            make.right.mas_equalTo(5);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(1*_Scale);
        }];

        [_btnArr addObject:cityBtn];
        lastView = cityBtn;
    }
}
#pragma mark - --------------RequestData----------------------
-(void)RequestData{
    //    请求
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[[NSString alloc] initWithFormat:@"%@%@%@",DNS,@"/v1/us_states/",_state_id] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        JXLOG(@"%@",_state_id);

        NSString *html = operation.responseString;
        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];

        if([[dict objectForKey:@"code"] intValue] ==1)
        {
            //过滤以获取真实数据（可用数据）
            NSArray *receiveCityData = [dict objectForKey:@"data"];
            NSArray *screenOutData = [self screenOutCityData:receiveCityData];
            [_cityArr setArray:screenOutData];
            //置入数据
            [self startAnimationBeforeReloadUI];
        }else
        {
            [[ToolManager sharedManager] alertTitle_Simple:[dict objectForKey:@"message"]];
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
    }];
}
#pragma mark - --------------UpdateUI----------------------
-(void)updateUI{
    [self initializationData];
    [self RequestData];
}

#pragma mark - --------------系统代理----------------------

#pragma mark - --------------自定义响应----------------------
-(void)allCityAction:(UIButton *)btn{
    if(_screenCityViewBlock){
        _screenCityViewBlock(@"allCity");
    }
}
-(void)cityAction:(UIButton *)btn{
    //筛选出所选城市和城市ID
    for (NSDictionary *dict in _cityArr) {
        if(![NSString isNilOrEmpty:[dict objectForKey:@"en_name"]])
        {
            if([[dict objectForKey:@"en_name"] isEqualToString:btn.titleLabel.text])
            {
                [_city_id setString:[[NSString alloc] initWithFormat:@"%ld",[[dict objectForKey:@"id"] longValue]]];
                if(![NSString isNilOrEmpty:[dict objectForKey:@"cn_name"]])
                {
                    [_city setString:[dict objectForKey:@"cn_name"]];
                }else
                {
                    [_city setString:@""];
                }
                break;
            }
        }
    }

    //更新mainview
    if(_screenCityViewBlock){
        _screenCityViewBlock(@"selectedCity");
    }
}
//城市展示动画结束后调用的方法
-(void)anmationstop
{
    //    现实选择所有城市btn
    _all_city.hidden = NO;

    [self createScrollViewContent];
}

#pragma mark - --------------自定义方法----------------------
-(void)initializationData{
    _all_city.hidden = YES;
    for (UIButton *obj in _btnArr) {
        [obj removeFromSuperview];
    }
    [_btnArr removeAllObjects];
    [_cityArr removeAllObjects];
    [_upview mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(500*_Scale);
    }];
}
//获取城市的真实数据，过滤一些异常数据
-(NSArray *)screenOutCityData:(NSArray *)receiveCityData{
    NSMutableArray *cityArray = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in receiveCityData) {

        NSDictionary *tempDict = @{@"id":[dict objectForKey:@"id"]
                                   ,@"en_name":[NSString isNilOrEmpty:[dict objectForKey:@"en_name"]]?@"":[dict objectForKey:@"en_name"]
                                   ,@"cn_name":[NSString isNilOrEmpty:[dict objectForKey:@"cn_name"]]?@"":[dict objectForKey:@"cn_name"]
                                   ,@"short_name":[NSString isNilOrEmpty:[dict objectForKey:@"short_name"]]?@"":[dict objectForKey:@"short_name"]
                                   };
        [cityArray addObject:tempDict];
    }
    return cityArray;
}
-(void)startAnimationBeforeReloadUI{

    if(_upview){
        //根据获取城市数据个数来调整scrollview的contentsize
        //判断数据是否大于12个，大于12个  确定界面高度，增加contentsize的高度。反之scrollview的frame和contentsize都一样，不可滑动
        CGFloat backheight = 0;
        if(_cityArr.count > 12)
        {
            backheight = 12*42*_Scale + 60*_Scale;

        }else
        {
            backheight = _cityArr.count*42*_Scale + 60*_Scale;
        }
        //            增加动画
        [UIView beginAnimations:@"anmationName" context:nil];
        //            动画停止后现实所有城市按钮和scrollview中lable的内容
        [UIView setAnimationDidStopSelector:@selector(anmationstop)];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
        //设置当前动画的代理
        [UIView setAnimationDelegate:self];
        //            根据数据动画改变视图的大小
        [_upview mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(backheight);
        }];
        [_upview layoutIfNeeded];
        [UIView commitAnimations];
    }
}
-(void)nullAction{}

#pragma mark - --------------other----------------------


@end
