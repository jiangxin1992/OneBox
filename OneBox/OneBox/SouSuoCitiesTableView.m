//
//  SouSuoCitiesTableView.m
//  OneBox
//
//  Created by yyj on 2018/4/23.
//  Copyright © 2018年 谢江新. All rights reserved.
//

#import "SouSuoCitiesTableView.h"

#import "FoundCell.h"
#import "sousuo_card_Cell.h"

#import "TableViewSliderParameterModel.h"

#define foundCellHeight 184*_Scale
#define foundCellHeight_card 400*_Scale

@interface SouSuoCitiesTableView()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSNumber *record_cell_num;//NSInteger
@property (nonatomic, strong) NSNumber *start_y;//表示tableview开始拖动时候的起始位置 CGFloat
@property (nonatomic, strong) NSNumber *is_suoyin;//是否点击索引 BOOL

@end

@implementation SouSuoCitiesTableView

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
}

#pragma mark - --------------UpdateUI----------------------
-(void)updateUI{}

#pragma mark - --------------系统代理----------------------
#pragma mark - UIScrollViewDelegate
//导航栏的动画显示与隐藏
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if([_parameterModel.isappear boolValue])
    {
        //记录开始滑动时候tableview的偏移量
        self.start_y = @(scrollView.contentOffset.y);
        //开始滑动
        _parameterModel.isdragging = @(YES);
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    if([_parameterModel.iscard boolValue])
    {
        CGFloat height = scrollView.contentOffset.y + ScreenHeight;
        //    JXLOG(@"contentOffset = %f",scrollView.contentOffset.y);
        //    JXLOG(@"height = %f",height);
        //    JXLOG(@"foundCellHeight = %f",380*_Scale);
        NSInteger now_cell = (NSInteger)(((CGFloat )height)/((CGFloat)foundCellHeight_card));

        if(now_cell != [_record_cell_num integerValue])
        {
            _record_cell_num = @(now_cell);
            NSDictionary *pushnum = [self getnumWithChar:_arrayChar WithPinyin:_dictPinyinAndChinese];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SousuoAnimation" object:pushnum];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SousuoAnimation1" object:nil];
    }

    if([_parameterModel.isdragging boolValue] && [_parameterModel.isappear boolValue] && ![_parameterModel.isNavAnimation boolValue])
    {
        JXLOG(@"滚动视图正在滚动=%f",scrollView.contentOffset.y);
        if([_start_y floatValue] < 0.f && scrollView.contentOffset.y > 0.f)
        {

            //当起始位置小于0，并且当前位置大于0时，开始消失动画
            if([_parameterModel.isNavShow boolValue]){
                if(_souSuoCitiesTableViewBlock){
                    _souSuoCitiesTableViewBlock(@"navHideAction",nil);
                }
            }
        }else
        {
            if(scrollView.contentOffset.y < 0.f)
            {
                //当tableview刚好到顶部时，开始出现动画
                if(![_parameterModel.isNavShow boolValue]){
                    if(_souSuoCitiesTableViewBlock){
                        _souSuoCitiesTableViewBlock(@"navShowAction",nil);
                    }
                }
            }else
            {
                if(([_start_y floatValue] - scrollView.contentOffset.y) > (ScreenHeight/4.0f) && ![_parameterModel.isNavShow boolValue]){
                    //当导航栏为隐藏状态；并且整体偏移量大于1/4屏时，开始出现动画
                    if(_souSuoCitiesTableViewBlock){
                        _souSuoCitiesTableViewBlock(@"navShowAction",nil);
                    }
                }else if((scrollView.contentOffset.y - [_start_y floatValue]) > (ScreenHeight/4.0f) && [_parameterModel.isNavShow boolValue]){
                    //当导航栏为出现状态；并且整体偏移量大于1/4屏时，开始消失动画
                    if(_souSuoCitiesTableViewBlock){
                        _souSuoCitiesTableViewBlock(@"navHideAction",nil);
                    }
                }
            }
        }
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if([_parameterModel.isappear boolValue])
    {
        _parameterModel.isdragging = @(NO);
    }
    self.is_suoyin = @(NO);
}
- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    //导航栏恢复
    if(_souSuoCitiesTableViewBlock){
        _souSuoCitiesTableViewBlock(@"scrollViewShouldScrollToTop",nil);
    }

    return YES;
}
#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_arrayData.count == indexPath.section)
    {
        if([_parameterModel.iscard boolValue])
        {
            return foundCellHeight_card;
        }
        return foundCellHeight;
    }else
    {
        if([_parameterModel.iscard boolValue])
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
    if(_souSuoCitiesTableViewBlock){
        _souSuoCitiesTableViewBlock(@"cellClick_schooldetail",indexPath);
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger _count = _arrayChar.count;
    return _count;

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
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }

    if([_parameterModel.iscard boolValue])
    {
        WeakSelf(ws);
        static NSString *cellid = @"sousuo_card_Cell";
        sousuo_card_Cell *cell_card = [tableView dequeueReusableCellWithIdentifier:cellid ];
        if(!cell_card)
        {
            cell_card = [[sousuo_card_Cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
            cell_card.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell_card setBlock:^(NSInteger row, NSInteger section, NSString *type) {
                if([type isEqualToString:@"1"]){
                    if(ws.souSuoCitiesTableViewBlock){
                        ws.souSuoCitiesTableViewBlock(@"isapp",[NSIndexPath indexPathForRow:row inSection:section]);
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
-(NSDictionary *)getnumWithChar:(NSArray *)arrayChar WithPinyin:(NSDictionary *)dictPinyinAndChinese
{
    NSDictionary *returndata = 0;
    NSInteger count = 0;
    for (int i = 0; i < [arrayChar count]; i++) {
        for (int j = 0; j < [[dictPinyinAndChinese objectForKey:[arrayChar objectAtIndex:i]] count]; j++) {
            count++;
            if(count == [_record_cell_num integerValue])
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

#pragma mark - --------------other----------------------

@end
