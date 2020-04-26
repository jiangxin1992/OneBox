//
//  FoundTableView.m
//  OneBox
//
//  Created by yyj on 2018/4/18.
//  Copyright © 2018年 谢江新. All rights reserved.
//

#import "FoundTableView.h"

// c文件 —> 系统文件（c文件在前）

// 控制器

// 自定义视图
#import "FoundCell_new.h"

// 接口

// 分类

// 自定义类和三方类（ cocoapods类 > model > 工具类 > 其他）
#import "FoundModel_new.h"
#import "TableViewSliderParameterModel.h"

#define foundCellHeight 380*_Scale

@interface FoundTableView()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSNumber *record_cell_num;//NSInteger
@property (nonatomic, strong) NSNumber *start_y;//表示tableview开始拖动时候的起始位置 CGFloat

@end

@implementation FoundTableView

#pragma mark - --------------生命周期--------------
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if(self){
        [self SomePrepare];
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
}
- (void)PrepareUI{
    self.delegate = self;
    self.dataSource = self;
    //    水平方向滑条显示
    self.showsVerticalScrollIndicator = YES;
    self.backgroundColor = _define_backview_color;
    //    消除分割线
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - --------------UIConfig----------------------

#pragma mark - --------------UpdateUI----------------------
-(void)updateUI{}

#pragma mark - --------------系统代理----------------------
#pragma mark - ScrollViewDelegate
//导航栏的动画显示与隐藏
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if([_parameterModel.isAppear boolValue])
    {
        //        记录开始滑动时候tableview的偏移量
        self.start_y = @(scrollView.contentOffset.y);
        //        开始滑动
        _parameterModel.isDragging = @(YES);
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat height = scrollView.contentOffset.y + ScreenHeight - (kIPhoneX?kTabBarHeight:kStatusBarAndNavigationBarHeight) - 420*_Scale;
//    JXLOG(@"contentOffset = %f",scrollView.contentOffset.y);
//    JXLOG(@"height = %f",height);
//    JXLOG(@"foundCellHeight = %f",380*_Scale);
    NSInteger now_cell = (NSInteger)(((CGFloat )height)/((CGFloat)foundCellHeight));

    if(now_cell != [_record_cell_num integerValue])
    {
        _record_cell_num = @(now_cell);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FoundAnimation" object:_record_cell_num];
    }
    //条件 （在拖动中 && 界面在出现状态 && 导航栏动画结束）
    if([_parameterModel.isDragging boolValue] && [_parameterModel.isAppear boolValue] && ![_parameterModel.isNavAnimation boolValue])
    {

        if([_start_y floatValue] < 0.f && scrollView.contentOffset.y > 0.f)
        {
            //当起始位置小于0，并且当前位置大于0时，开始消失动画
            if([_parameterModel.isNavShow boolValue]){
                if(_foundTableViewBlock){
                    _foundTableViewBlock(@"navHideAction",nil);
                }
            }
        }else
        {
            if(scrollView.contentOffset.y < 0.f)
            {
                //当tableview刚好到顶部时，开始出现动画
                if(![_parameterModel.isNavShow boolValue]){
                    if(_foundTableViewBlock){
                        _foundTableViewBlock(@"navShowAction",nil);
                    }
                }
            }else
            {
                if(([_start_y floatValue] - scrollView.contentOffset.y) > (ScreenHeight/4.0f) && ![_parameterModel.isNavShow boolValue]){
                    //当导航栏为隐藏状态；并且整体偏移量大于1/4屏时，开始出现动画
                    if(_foundTableViewBlock){
                        _foundTableViewBlock(@"navShowAction",nil);
                    }
                }else if((scrollView.contentOffset.y - [_start_y floatValue]) > (ScreenHeight/4.0f) && [_parameterModel.isNavShow boolValue]){
                    //当导航栏为出现状态；并且整体偏移量大于1/4屏时，开始消失动画
                    if(_foundTableViewBlock){
                        _foundTableViewBlock(@"navHideAction",nil);
                    }
                }
            }
        }
    }
}
//滑动结束时候调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if([_parameterModel.isAppear boolValue])
    {
        _parameterModel.isDragging = @(NO);
    }
}
// 回到最顶部
- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    //导航栏恢复
    if(_foundTableViewBlock){
        _foundTableViewBlock(@"scrollViewShouldScrollToTop",nil);
    }

    return YES;
}
#pragma mark - TableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return foundCellHeight;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrayData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //数据还未获取时候
    if(!_arrayData.count)
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

    //获取到数据以后
    static NSString *cellid = @"FoundCell_new";
    FoundCell_new *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if(!cell)
    {
        cell = [[FoundCell_new alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.indexPath = indexPath;
    cell.foundModel = [_arrayData objectAtIndex:indexPath.row];
    [cell updateUI];

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if(![_parameterModel.bKeyBoardHide boolValue])
    {
        //        当键盘为出现状态时，触发 键盘消失方法
        [regular dismissKeyborad];

    }else
    {
        //键盘没有出现时候调用
        FoundModel_new *model = [_arrayData objectAtIndex:indexPath.row];
        if(model.m_type != nil)
        {
            if([model.m_type isEqualToString:@"rank"])
            {
                //当cell类型为榜单时候
                if(![NSString isNilOrEmpty:[model.data objectForKey:@"rank_name"]])
                {
                    //判断点击cell榜单类型
                    if([[model.data objectForKey:@"rank_name"] isKindOfClass:[NSString class]])
                    {

                        if(_foundTableViewBlock){
                            _foundTableViewBlock(@"cellClick_rank",indexPath);
                        }
                    }
                }

            }else if([model.m_type isEqualToString:@"school"])
            {
                //当当前cell类型为school时候
                BOOL _canpush = NO;//判断当前时候满足跳转条件（及schoolID不为空）
                NSString *schoolname = nil;
                NSString *schoolid = nil;
                if(![NSString isNilOrEmpty:[model.data objectForKey:@"school_name_cn"]])
                {
                    schoolname = [model.data objectForKey:@"school_name_cn"];
                }else
                {
                    schoolname = @"";
                }

                if(![NSString isNilOrEmpty:[model.data objectForKey:@"school_id"]])
                {
                    schoolid = [[NSString alloc] initWithFormat:@"%ld",[[model.data objectForKey:@"school_id"] longValue]];
                    _canpush = YES;
                }else
                {
                    schoolid = @"";
                }

                if(_canpush)
                {
                    if(_foundTableViewBlock){
                        _foundTableViewBlock(@"cellClick_schooldetail",indexPath);
                    }
                }

            }else if([model.m_type isEqualToString:@"city"])
            {
                //当前cell为city类型时,当数据类型正确并且城市多余0个的时候允许跳转。
                if([model.data objectForKey:@"city_names"] != [NSNull null])
                {
                    if([model.data objectForKey:@"city_names"] != nil)
                    {
                        if([[model.data objectForKey:@"city_names"] isKindOfClass:[NSArray class]])
                        {
                            if([[model.data objectForKey:@"city_names"] count] > 0)
                            {
                                if(_foundTableViewBlock){
                                    _foundTableViewBlock(@"cellClick_sousuo",indexPath);
                                }
                            }
                        }
                    }
                }
            }else if([model.m_type isEqualToString:@"post"]){
                if (_foundTableViewBlock) {
                    _foundTableViewBlock(@"post",indexPath);
                }
            }
        }
    }
}
#pragma mark - --------------自定义响应----------------------

#pragma mark - --------------自定义方法----------------------


#pragma mark - --------------other----------------------

@end
