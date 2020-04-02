//
//  SouSuoTableView.m
//  OneBox
//
//  Created by yyj on 2018/4/23.
//  Copyright © 2018年 谢江新. All rights reserved.
//

#import "SouSuoTableView.h"

// c文件 —> 系统文件（c文件在前）

// 控制器

// 自定义视图
#import "FoundCell.h"
#import "SousuoCardCell.h"
#import "SouSuoHeaderView.h"

// 接口

// 分类

// 自定义类和三方类（ cocoapods类 > model > 工具类 > 其他）

#import "TableViewSliderParameterModel.h"

#define foundCellHeight 184*_Scale
#define foundCellHeight_card 400*_Scale

@interface SouSuoTableView()<UITableViewDataSource,UITableViewDelegate>

//外界传入
@property (nonatomic, strong) TableViewSliderParameterModel *parameterModel;
@property (nonatomic, strong) NSMutableArray *arrayData;//存放页面的数据
@property (nonatomic, strong) NSDictionary *dictPinyinAndChinese;
@property (nonatomic, strong) NSMutableArray *arrayChar;
@property (nonatomic, strong) NSNumber *isFirstRequest;//Bool

@property (nonatomic, copy) void (^souSuoTableViewBlock)(NSString *type,NSIndexPath *indexPath);

@property (nonatomic, strong) SouSuoHeaderView *headerView;

@property (nonatomic, strong) NSNumber *record_cell_num;//NSInteger
@property (nonatomic, strong) NSNumber *start_y;//表示tableview开始拖动时候的起始位置 CGFloat
@property (nonatomic, strong) NSNumber *is_suoyin;//是否点击索引 BOOL

@end

@implementation SouSuoTableView

#pragma mark - --------------生命周期--------------
- (instancetype)initWithFrame:(CGRect)frame
                        style:(UITableViewStyle)style
               parameterModel:(TableViewSliderParameterModel *)parameterModel
                    arrayData:(NSMutableArray *)arrayData
         dictPinyinAndChinese:(NSDictionary *)dictPinyinAndChinese
                    arrayChar:(NSMutableArray *)arrayChar
               isFirstRequest:(NSNumber *)isFirstRequest
         souSuoTableViewBlock:(void (^)(NSString *type,NSIndexPath *indexPath))souSuoTableViewBlock{

    self = [super initWithFrame:frame style:style];
    if(self){
        _parameterModel = parameterModel;
        _arrayData = arrayData;
        _dictPinyinAndChinese = dictPinyinAndChinese;
        _arrayChar = arrayChar;
        _isFirstRequest = isFirstRequest;
        _souSuoTableViewBlock = souSuoTableViewBlock;
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
    self.start_y = @(0.f);
    self.record_cell_num = @(0);
    self.is_suoyin = @(NO);
}
- (void)PrepareUI{
    self.delegate = self;
    self.dataSource = self;
    self.showsVerticalScrollIndicator = YES;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.sectionIndexBackgroundColor = [UIColor clearColor];
    self.sectionIndexColor = [UIColor colorWithRed:204.0f/255.0f green:204.0f/255.0f blue:204.0f/255.0f alpha:1];
}

#pragma mark - --------------UIConfig----------------------
-(void)UIConfig{
    [self createTableFooterView];
}
-(void)createTableFooterView{
    if(!_footerView){
        _footerView = [UIView getCustomViewWithColor:_define_backview_color];
        _footerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), 100);
        _footerView.hidden = YES;

        [self createVersionView];
    }
    self.tableFooterView = _footerView;
}
-(void)createHeaderViewWhenNoData{

    if(!_headerView){
        WeakSelf(ws);
        _headerView = [[SouSuoHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 300)];
        [_headerView setSouSuoCitiesViewBlock:^(NSString *type) {
            if([type isEqualToString:@"saysomething_to_us"]){
                if(ws.souSuoTableViewBlock){
                    ws.souSuoTableViewBlock(type,nil);
                }
            }
        }];
    }

    self.tableHeaderView = _headerView;
}
-(void)createVersionView
{
    _banbenView = [UIImageView getImgWithImageStr:@"版本_v1.0"];
    [_footerView addSubview:_banbenView];
    [_banbenView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.footerView);
        make.width.mas_equalTo(25);
        make.height.mas_equalTo(50*_Scale);
        make.top.mas_equalTo(50*_Scale);
    }];
    _banbenView.hidden = YES;
}
#pragma mark - --------------UpdateUI----------------------
-(void)updateUI{}

#pragma mark - --------------系统代理----------------------
#pragma mark - UIScrollViewDelegate
//导航栏的动画显示与隐藏
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if([_parameterModel.isAppear boolValue])
    {
        //记录开始滑动时候tableview的偏移量
        self.start_y = @(scrollView.contentOffset.y);
        //开始滑动
        _parameterModel.isDragging = @(YES);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self animationNotification];

    if([_parameterModel.isDragging boolValue] && [_parameterModel.isAppear boolValue] && ![_parameterModel.isNavAnimation boolValue])
    {
        JXLOG(@"滚动视图正在滚动=%f",scrollView.contentOffset.y);
        if([_start_y floatValue] < 0.f && scrollView.contentOffset.y > 0.f)
        {

            //当起始位置小于0，并且当前位置大于0时，开始消失动画
            if([_parameterModel.isNavShow boolValue]){
                if(_souSuoTableViewBlock){
                    _souSuoTableViewBlock(@"navHideAction",nil);
                }
            }
        }else
        {
            if(scrollView.contentOffset.y < 0.f)
            {
                //当tableview刚好到顶部时，开始出现动画
                if(![_parameterModel.isNavShow boolValue]){
                    if(_souSuoTableViewBlock){
                        _souSuoTableViewBlock(@"navShowAction",nil);
                    }
                }
            }else
            {
                if(([_start_y floatValue] - scrollView.contentOffset.y) > (ScreenHeight/4.0f) && ![_parameterModel.isNavShow boolValue]){
                    //当导航栏为隐藏状态；并且整体偏移量大于1/4屏时，开始出现动画
                    if(_souSuoTableViewBlock){
                        _souSuoTableViewBlock(@"navShowAction",nil);
                    }
                }else if((scrollView.contentOffset.y - [_start_y floatValue]) > (ScreenHeight/4.0f) && [_parameterModel.isNavShow boolValue]){
                    //当导航栏为出现状态；并且整体偏移量大于1/4屏时，开始消失动画
                    if(_souSuoTableViewBlock){
                        _souSuoTableViewBlock(@"navHideAction",nil);
                    }
                }
            }
        }
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if([_parameterModel.isAppear boolValue])
    {
        _parameterModel.isDragging = @(NO);
    }
    self.is_suoyin = @(NO);
}
- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    //导航栏恢复
    if(_souSuoTableViewBlock){
        _souSuoTableViewBlock(@"scrollViewShouldScrollToTop",nil);
    }

    return YES;
}
#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_arrayData.count == indexPath.section)
    {
        if([_parameterModel.isCard boolValue])
        {
            return foundCellHeight_card;
        }
        return foundCellHeight;
    }else
    {
        if([_parameterModel.isCard boolValue])
        {
            return foundCellHeight_card;
        }
        return foundCellHeight;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_arrayData.count == section)
    {
        return 0;

    }
    NSString *strKey = [_arrayChar objectAtIndex:section];
    NSInteger count = [_dictPinyinAndChinese[strKey] count];
    return count;
}
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    NSInteger count = 0;

    self.is_suoyin = @(YES);
    for(NSString *character in _arrayChar)
    {
        if([character isEqualToString:title])
        {
            return count;
        }
        count ++;
    }
    return 0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_souSuoTableViewBlock){
        _souSuoTableViewBlock(@"cellClick_schooldetail",indexPath);
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger count = _arrayChar.count;
    return count;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_arrayData.count == indexPath.section)
    {
        static NSString *cellid = @"cellid";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if(!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }

    if([_parameterModel.isCard boolValue])
    {
        WeakSelf(ws);
        static NSString *cellid = @"SousuoCardCell";
        SousuoCardCell *cell_card = [tableView dequeueReusableCellWithIdentifier:cellid ];
        if(!cell_card)
        {
            cell_card = [[SousuoCardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
            cell_card.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell_card setBlock:^(NSInteger row, NSInteger section, NSString *type) {
                if([type isEqualToString:@"1"]){
                    if(ws.souSuoTableViewBlock){
                        ws.souSuoTableViewBlock(@"isapp",[NSIndexPath indexPathForRow:row inSection:section]);
                    }
                }
            }];
        }
        NSDictionary *tempDict = @{
                                   @"model":(_dictPinyinAndChinese[_arrayChar[indexPath.section]])[indexPath.row]
                                   ,@"row":@(indexPath.row)
                                   ,@"section":@(indexPath.section)
                                   ,@"type":@"1"
                                   ,@"char":_arrayChar[indexPath.section]
                                   ,@"suoyin":_is_suoyin
                                   ,@"m_row":_parameterModel.m_row
                                   ,@"m_section":_parameterModel.m_section
                                   };
        cell_card.dict = tempDict;
        return cell_card;

    }else
    {
        static NSString *cellid = @"FoundCell";
        FoundCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid ];
        if(!cell)
        {
            cell = [[FoundCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.model = (_dictPinyinAndChinese[_arrayChar[indexPath.section]])[indexPath.row];
        return cell;

    }
}
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    JXLOG(@"%@",_arrayChar);
    JXLOG(@"111");
    return _arrayChar;
}

#pragma mark - --------------自定义响应----------------------


#pragma mark - --------------自定义方法----------------------
-(NSDictionary *)getnumWithChar:(NSArray *)arrayChar WithPinyin:(NSDictionary *)dictPinyinAndChinese nowCell:(NSInteger )now_cell
{
    NSDictionary *returndata = nil;
    NSInteger count = 0;
    for (int i = 0; i < [arrayChar count]; i++) {
        for (int j = 0; j < [[dictPinyinAndChinese objectForKey:[arrayChar objectAtIndex:i]] count]; j++) {
            count++;
            if(count == now_cell)
            {
                returndata = @{
                                @"num":[NSNumber numberWithInteger:j+1]
                               ,@"key":[arrayChar objectAtIndex:i]
                               ,@"suoyin":_is_suoyin
                               };
                break;
            }
        }
    }
    return returndata;
}
- (void)animationNotification{
    if([_parameterModel.isCard boolValue])
    {
        JXLOG(@"foundCellHeight = %f",foundCellHeight_card);
        JXLOG(@"contentOffset = %f",self.contentOffset.y);
        JXLOG(@"ScreenHeight = %lf",ScreenHeight);
        CGFloat height = self.contentOffset.y + ScreenHeight;
        //    JXLOG(@"contentOffset = %f",scrollView.contentOffset.y);
        //    JXLOG(@"height = %f",height);
        //    JXLOG(@"foundCellHeight = %f",foundCellHeight_card);
        NSInteger now_cell = (NSInteger)(((CGFloat )height)/((CGFloat)foundCellHeight_card));

        //先看看有没有数据
        NSDictionary *pushData = [self getnumWithChar:_arrayChar WithPinyin:_dictPinyinAndChinese nowCell:now_cell];
        if(now_cell != [_record_cell_num integerValue] && pushData)
        {
            _record_cell_num = @(now_cell);
            if([_isFirstRequest boolValue]){
                self.isFirstRequest = @(NO);
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"SousuoAnimation" object:pushData];
                });
            }else{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"SousuoAnimation" object:pushData];
            }
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SousuoAnimation1" object:nil];
    }
}

#pragma mark - --------------other----------------------

@end
