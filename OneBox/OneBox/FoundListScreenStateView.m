//
//  FoundListScreenStateView.m
//  OneBox
//
//  Created by yyj on 2018/4/11.
//  Copyright © 2018年 谢江新. All rights reserved.
//

#import "FoundListScreenStateView.h"

@interface FoundListScreenStateView()

@property (nonatomic, copy) NSMutableArray *stateArr;//存放州的获取数据

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIView *container;

@end

@implementation FoundListScreenStateView

#define blueColor [UIColor colorWithRed:65.0f/255.0f green:176.0f/255.0f blue:211.0f/255.0f alpha:1]

#pragma mark - --------------生命周期--------------
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self SomePrepare];
        [self UIConfig];
        [self RequestData];
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
    _stateArr = [[NSMutableArray alloc] init];
}
- (void)PrepareUI{
    self.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nullAction)];
    [self addGestureRecognizer:tap];
}

#pragma mark - --------------UIConfig----------------------
-(void)UIConfig{
    //背景upview
    UIView *upview = [UIView getCustomViewWithColor:blueColor];
    [self addSubview:upview];
    [upview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(544*_Scale);
    }];

    //创建所有州按钮
    UIButton *all_state = [UIButton getCustomTitleBtnWithAlignment:0 WithFont:12.0f WithSpacing:5.0 WithNormalTitle:@"所有州" WithNormalColor:_define_white_color WithSelectedTitle:nil WithSelectedColor:nil];
    [self addSubview:all_state];
    [all_state mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(50*_Scale);
    }];
    all_state.backgroundColor = [UIColor colorWithRed:107.0f/255.0f green:203.0f/255.0f blue:202.0f/255.0f alpha:1];;
    [all_state addTarget:self action:@selector(allStateAction:) forControlEvents:UIControlEventTouchUpInside];

    //创建scrollview
    _scrollView = [[UIScrollView alloc] init];
    [upview addSubview:_scrollView];
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
}
//置入数据
-(void)createScrollViewContent{
    //创建州的lable
    UIView *lastView = nil;
    for (int i = 0; i < _stateArr.count; i ++) {
        UIButton *stateBtn = [UIButton getCustomTitleBtnWithAlignment:0 WithFont:11.0f WithSpacing:0 WithNormalTitle:[_stateArr[i] objectForKey:@"en_name"] WithNormalColor:_define_white_color WithSelectedTitle:nil WithSelectedColor:nil];
        [_container addSubview:stateBtn];
        [stateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20*_Scale);
            make.right.mas_equalTo(-20*_Scale);
            make.height.mas_equalTo(42*_Scale);
            if(!lastView){
                make.top.mas_equalTo(0);
            }else{
                make.top.mas_equalTo(lastView.mas_bottom).with.offset(0);
            }
            if(i == _stateArr.count - 1){
                make.bottom.mas_equalTo(0);
            }
        }];
        stateBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        stateBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [stateBtn setBackgroundColor:blueColor];
        [stateBtn addTarget:self action:@selector(stateAction:) forControlEvents:UIControlEventTouchUpInside];

        UILabel *short_nameLabel = [UILabel getLabelWithAlignment:2 WithTitle:[_stateArr[i] objectForKey:@"short_name"] WithFont:12.0f WithTextColor:_define_white_color WithSpacing:1.0f];
        [stateBtn addSubview:short_nameLabel];
        [short_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.mas_equalTo(0);
            make.width.mas_equalTo(90*_Scale);
        }];
        short_nameLabel.backgroundColor = blueColor;

        UILabel *cn_nameLabel = [UILabel getLabelWithAlignment:0 WithTitle:[_stateArr[i] objectForKey:@"cn_name"] WithFont:12.0f WithTextColor:_define_white_color WithSpacing:1.0f];
        [stateBtn addSubview:cn_nameLabel];
        [cn_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(short_nameLabel.mas_right).with.offset(22*_Scale);
            make.right.top.bottom.mas_equalTo(0);
        }];
        cn_nameLabel.backgroundColor = blueColor;

        UIView *downLine = [UIView getCustomViewWithColor:[UIColor colorWithRed:134.0f/255.0f green:210.0f/255.0f blue:219.0f/255.0f alpha:1]];
        [stateBtn addSubview:downLine];
        [downLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(-5);
            make.right.mas_equalTo(5);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(1*_Scale);
        }];

        lastView = stateBtn;
    }

    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10*_Scale);
        make.right.mas_equalTo(-10*_Scale);
        make.top.mas_equalTo(30*_Scale);
        make.bottom.mas_equalTo(-30*_Scale);
    }];
}
#pragma mark - --------------RequestData----------------------
-(void)RequestData{
    //    请求
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[[NSString alloc] initWithFormat:@"%@%@",DNS,@"/v1/us_states"] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSString *html = operation.responseString;
        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
        //请求成功后
        if([[dict objectForKey:@"code"] intValue] ==1)
        {
            //过滤以获取真实数据（可用数据）
            NSArray *receiveStateData = [dict objectForKey:@"data"];
            NSArray *screenOutData = [self screenOutStateData:receiveStateData];
            [_stateArr setArray:screenOutData];
            //置入数据
            [self createScrollViewContent];
        }else
        {
            [[ToolManager sharedManager] alertTitle_Simple:[dict objectForKey:@"message"]];
        }

        [[ToolManager sharedManager] removeProgress];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
    }];
}
#pragma mark - --------------UpdateUI----------------------
-(void)updateUI{
    if(!_stateArr.count){
        [self RequestData];
    }
}
#pragma mark - --------------系统代理----------------------
#pragma mark - --------------自定义响应----------------------
//选择所有州
-(void)allStateAction:(UIButton *)btn{
    if(_screenStateViewBlock){
        _screenStateViewBlock(@"allState");
    }
}
//选择州
-(void)stateAction:(UIButton *)btn
{
    NSString *btnTitle = btn.titleLabel.text;
    //        州变化时候或者州为空的时候，将所选城市还原
    if(![btnTitle isEqualToString:_state]&&![_state isEqualToString:@""])
    {
        [self.city setString:@""];
        [self.city_id setString:@""];
    }
    //筛选出所选州和州ID
    for (NSDictionary *dict in _stateArr) {
        if([[dict objectForKey:@"en_name"] isEqualToString:btnTitle])
        {
            if([dict objectForKey:@"id"] != [NSNull null])
            {
                [self.state setString:[dict objectForKey:@"cn_name"]];
                [self.state_id setString:[[NSString alloc] initWithFormat:@"%d",[[dict objectForKey:@"id"] intValue]]];
                break;
            }
        }
    }
    //更新mainview
    if(_screenStateViewBlock){
        _screenStateViewBlock(@"selectedState");
    }
}
#pragma mark - --------------自定义方法----------------------
//获取州的真实数据，过滤一些异常数据
-(NSArray *)screenOutStateData:(NSArray *)receiveStateData{
    NSMutableArray *stateArray=[[NSMutableArray alloc] init];
    for (NSDictionary *dict in receiveStateData) {

        NSDictionary *tempDict = @{@"id":[dict objectForKey:@"id"]
                     ,@"en_name":[NSString isNilOrEmpty:[dict objectForKey:@"en_name"]]?@"":[dict objectForKey:@"en_name"]
                     ,@"cn_name":[NSString isNilOrEmpty:[dict objectForKey:@"cn_name"]]?@"":[dict objectForKey:@"cn_name"]
                     ,@"short_name":[NSString isNilOrEmpty:[dict objectForKey:@"short_name"]]?@"":[dict objectForKey:@"short_name"]
                     };
        [stateArray addObject:tempDict];
    }
    return [stateArray copy];
}
-(void)nullAction{}
#pragma mark - --------------other----------------------

@end
