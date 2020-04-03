//
//  ScreenTableView.m
//  OneBox
//
//  Created by yyj on 2018/5/14.
//  Copyright © 2018年 谢江新. All rights reserved.
//

#import "ScreenTableView.h"

// c文件 —> 系统文件（c文件在前）

// 控制器
#import "ScreenViewController.h"

// 自定义视图
#import "FoundCell.h"
#import "SousuoCardCell.h"
#import "SouSuoHeaderView.h"

// 接口

// 分类

// 自定义类和三方类（ cocoapods类 > model > 工具类 > 其他）
#import "MJRefresh.h"

#import "FoundModel.h"
#import "TableViewSliderParameterModel.h"

#import "ChineseToPinyin.h"

#define foundCellHeight 184*_Scale
#define foundCellHeight_card 400*_Scale

@interface ScreenTableView()<UITableViewDataSource,UITableViewDelegate,UISearchResultsUpdating>

//外界传入
@property (nonatomic, strong) TableViewSliderParameterModel *parameterModel;
@property (nonatomic, strong) NSMutableArray *arrayData;//存放页面的数据
@property (nonatomic, strong) NSMutableDictionary *dictPinyinAndChinese;
@property (nonatomic, strong) NSMutableArray *arrayChar;
@property (nonatomic, strong) NSMutableDictionary *dictPinyinAndChinese1;
@property (nonatomic, strong) NSMutableArray *arrayChar1;
@property (nonatomic, strong) NSNumber *isFirstRequest;//Bool
@property (nonatomic, strong) ScreenViewController *controller;

@property (nonatomic, copy) void (^sreenTableViewBlock)(NSString *type,NSIndexPath *indexPath);

@property (nonatomic, strong) UISearchController *searchController;//搜索结果展示控制器 ，经常和UISearchBar配合使用

@property (nonatomic, strong) SouSuoHeaderView *headerView;

@property (nonatomic, strong) NSNumber *record_cell_num;//NSInteger
@property (nonatomic, strong) NSNumber *start_y;//表示tableview开始拖动时候的起始位置 CGFloat
@property (nonatomic, strong) NSNumber *is_suoyin;//是否点击索引 BOOL

@end


@implementation ScreenTableView

#pragma mark - --------------生命周期--------------
- (instancetype)initWithFrame:(CGRect)frame
                        style:(UITableViewStyle)style
               parameterModel:(TableViewSliderParameterModel *)parameterModel
                    arrayData:(NSMutableArray *)arrayData
         dictPinyinAndChinese:(NSMutableDictionary *)dictPinyinAndChinese
                    arrayChar:(NSMutableArray *)arrayChar
        dictPinyinAndChinese1:(NSMutableDictionary *)dictPinyinAndChinese1
                   arrayChar1:(NSMutableArray *)arrayChar1
               isFirstRequest:(NSNumber *)isFirstRequest
                   controller:(ScreenViewController *)controller
          sreenTableViewBlock:(void (^)(NSString *type,NSIndexPath *indexPath))sreenTableViewBlock{
    self = [super initWithFrame:frame style:style];
    if(self){
        _parameterModel = parameterModel;
        _arrayData = arrayData;
        _dictPinyinAndChinese = dictPinyinAndChinese;
        _arrayChar = arrayChar;
        _dictPinyinAndChinese1 = dictPinyinAndChinese1;
        _arrayChar1 = arrayChar1;
        _isFirstRequest = isFirstRequest;
        _controller = controller;
        _sreenTableViewBlock = sreenTableViewBlock;
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
    self.backgroundColor = _define_backview_color;
    self.delegate = self;
    self.dataSource = self;
    self.showsVerticalScrollIndicator = YES;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.sectionIndexBackgroundColor = [UIColor clearColor];
    self.sectionIndexColor = [UIColor colorWithRed:204.0f/255.0f green:204.0f/255.0f blue:204.0f/255.0f alpha:1];
}

#pragma mark - --------------UIConfig----------------------
-(void)UIConfig{
    [self createSearchController];//创建搜索器
    [self createTableFooterView];
}
- (void)createSearchController{
    if(!_searchController){
        _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
        _searchController.searchResultsUpdater = self;
        _searchController.dimsBackgroundDuringPresentation = NO;
        _searchController.hidesNavigationBarDuringPresentation = NO;
        _searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 56.f);
        [_searchController.searchBar setSearchFieldBackgroundImage:[UIImage imageNamed:@"found_school_所在州所在城市筛选框"] forState:UIControlStateNormal];
        _searchController.searchBar.backgroundImage = [UIImage imageNamed:@"found_card_titleview"];

        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"found_school_2_选中底图.png"]];
        imageView.frame = _searchController.searchBar.frame;
        _searchController.searchBar.placeholder = @"输入城市或者学校名字 试试吧";
        if (@available(iOS 13.0, *)) {
            UITextField *searchField = _searchController.searchBar.searchTextField;

            searchField.font = (kIOSVersions>=9.0? [UIFont systemFontOfSize:11.0f]:[UIFont fontWithName:@"Helvetica Neue" size:11.0f]);
            searchField.leftView.alpha = 0.5;
        } else {
            // Fallback on earlier versions
        }

        [_searchController.searchBar insertSubview:imageView atIndex:1];

        _searchController.searchBar.searchBarStyle = UISearchBarStyleDefault;
    }
    self.tableHeaderView = _searchController.searchBar;
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
-(void)createHeaderViewWhenNoData{

    if(!_headerView){
        WeakSelf(ws);
        _headerView = [[SouSuoHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 300)];
        [_headerView setSouSuoCitiesViewBlock:^(NSString *type) {
            if([type isEqualToString:@"saysomething_to_us"]){
                if(ws.sreenTableViewBlock){
                    ws.sreenTableViewBlock(type,nil);
                }
            }
        }];
    }

    self.tableHeaderView = _headerView;
}
- (void)removeSearchController{
    _searchController.active = NO;
}
#pragma mark - --------------UpdateUI----------------------
-(void)updateUI{}

#pragma mark - --------------系统代理----------------------
#pragma mark - TableViewDelegate
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if(!self.searchController.active)
    {
        return _arrayChar;
    }
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = _define_backview_color;

    return _arrayChar1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(!self.searchController.active)
    {
        return _arrayChar.count;
    }else
    {
        //因为在searchDC上的_searchBar就是创建searchDC时，由第一个参数指定的_searchBar
        if(![NSString isNilOrEmpty:_searchController.searchBar.text])
        {
            tableView.sectionIndexBackgroundColor = [UIColor clearColor];
            tableView.sectionIndexColor = [UIColor colorWithRed:204.0f/255.0f green:204.0f/255.0f blue:204.0f/255.0f alpha:1];

            return _arrayChar1.count;
        }else
        {
            return 1;
        }
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if(!self.searchController.active)
    {
        if(_arrayChar.count == section)
        {
            return 0;
        }
        NSString *strKey = _arrayChar[section];
        NSInteger count = [_dictPinyinAndChinese[strKey] count];
        return count;

    }else
    {
        if(![NSString isNilOrEmpty:_searchController.searchBar.text])
        {
            NSString *strKey = _arrayChar1[section];
            NSInteger count = [_dictPinyinAndChinese1[strKey] count];
            return count;

        }
        return 1;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_sreenTableViewBlock){
        if(!self.searchController.active)
        {
            _sreenTableViewBlock(@"cellClick_schooldetail1",indexPath);
        }else
        {
            _sreenTableViewBlock(@"cellClick_schooldetail2",indexPath);
        }
    }
}
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
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL isNoData = NO;
    if(self.searchController.active){
        if(!_arrayChar1.count){
            isNoData = YES;
        }
    }else{
        if(_arrayData.count == indexPath.section){
            isNoData = YES;
        }
    }
    if(isNoData)
    {
        static NSString *cellid = @"cellid";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if(!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.contentView.backgroundColor = [UIColor clearColor];
        }
        return cell;
    }else{
        if([_parameterModel.isCard boolValue])
        {
            static NSString *cellid = @"cell_card";
            SousuoCardCell *cell_card = [tableView dequeueReusableCellWithIdentifier:cellid ];
            if(!cell_card)
            {
                WeakSelf(ws);
                cell_card = [[SousuoCardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
                cell_card.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell_card setBlock:^(NSInteger row, NSInteger section, NSString *type) {
                    if([type isEqualToString:@"1"]){
                        if(ws.sreenTableViewBlock){
                            ws.sreenTableViewBlock(@"isapp1",[NSIndexPath indexPathForRow:row inSection:section]);
                        }
                    }else if([type isEqualToString:@"2"]){
                        if(ws.sreenTableViewBlock){
                            ws.sreenTableViewBlock(@"isapp2",[NSIndexPath indexPathForRow:row inSection:section]);
                        }
                    }
                }];
            }
            if(!self.searchController.active)
            {
                JXLOG(@"%@",_dictPinyinAndChinese);
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
            }else
            {
                tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
                if(![NSString isNilOrEmpty:_searchController.searchBar.text])
                {
                    NSDictionary *tempDict = @{
                                               @"model":(_dictPinyinAndChinese1[_arrayChar1[indexPath.section]])[indexPath.row]
                                               ,@"row":@(indexPath.row)
                                               ,@"section":@(indexPath.section)
                                               ,@"type":@"2"
                                               ,@"char":_arrayChar1[indexPath.section]
                                               ,@"suoyin":_is_suoyin
                                               ,@"m_row":_parameterModel.m_row1
                                               ,@"m_section":_parameterModel.m_section1
                                               };
                    cell_card.dict = tempDict;
                }
            }
            return cell_card;

        }else
        {
            static NSString *cellid = @"cell";
            FoundCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid ];
            if(!cell)
            {
                cell = [[FoundCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            if(!self.searchController.active)
            {
                cell.model = (_dictPinyinAndChinese[_arrayChar[indexPath.section]])[indexPath.row];
            }else
            {

                if(![NSString isNilOrEmpty:_searchController.searchBar.text])
                {
                    cell.model = (_dictPinyinAndChinese1[_arrayChar1[indexPath.section]])[indexPath.row];
                }
            }
            return cell;

        }
    }
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
        count++;
    }
    return 0;
}
#pragma mark - UIScrollViewDelegate
- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    //导航栏恢复
    if(_sreenTableViewBlock){
        _sreenTableViewBlock(@"scrollViewShouldScrollToTop",nil);
    }

    return YES;
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if(scrollView == self && [_parameterModel.isAppear boolValue])
    {
        _start_y = @(scrollView.contentOffset.y);
        JXLOG(@"滚动视图即将开始拖动=%f",scrollView.contentOffset.y);
        _parameterModel.isDragging = @(YES);
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self animationNotification];

    if([_parameterModel.isDragging boolValue] && [_parameterModel.isAppear boolValue] && ![_parameterModel.isNavAnimation boolValue])
    {
        if(scrollView == self && [_parameterModel.isAppear boolValue])
        {

            JXLOG(@"滚动视图正在滚动=%f",scrollView.contentOffset.y);
            if([_start_y floatValue] < self.tableHeaderView.frame.size.height && scrollView.contentOffset.y > self.tableHeaderView.frame.size.height)
            {
                //当起始位置小于0，并且当前位置大于0时，开始消失动画
                if([_parameterModel.isNavShow boolValue]){
                    if(_sreenTableViewBlock){
                        _sreenTableViewBlock(@"navHideAction",nil);
                    }
                }

            }else
            {
                if(scrollView.contentOffset.y < self.tableHeaderView.frame.size.height)
                {
                    //当tableview刚好到顶部时，开始出现动画
                    if(![_parameterModel.isNavShow boolValue]){
                        if(_sreenTableViewBlock){
                            _sreenTableViewBlock(@"navShowAction",nil);
                        }
                    }
                }else
                {
                    if(([_start_y floatValue] - scrollView.contentOffset.y) > (ScreenHeight/4.0f) && ![_parameterModel.isNavShow boolValue]){
                        //当导航栏为隐藏状态；并且整体偏移量大于1/4屏时，开始出现动画
                        if(_sreenTableViewBlock){
                            _sreenTableViewBlock(@"navShowAction",nil);
                        }
                    }else if((scrollView.contentOffset.y - [_start_y floatValue]) > (ScreenHeight/4.0f) && [_parameterModel.isNavShow boolValue]){
                        //当导航栏为出现状态；并且整体偏移量大于1/4屏时，开始消失动画
                        if(_sreenTableViewBlock){
                            _sreenTableViewBlock(@"navHideAction",nil);
                        }
                    }
                }
            }
        }
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(scrollView == self && [_parameterModel.isAppear boolValue])
    {
        _parameterModel.isDragging = @(NO);
    }
    self.is_suoyin = @(NO);
}
#pragma mark - SearchBarDelegate
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {

    //    把cancle按钮改为中文取消
    searchController.searchBar.showsCancelButton = YES;

    for(id cc in [searchController.searchBar.subviews[0] subviews])
    {
        if([cc isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton *)cc;
            [btn setTitle:@"取消" forState:UIControlStateNormal];
        }
    }
    if(![NSString isNilOrEmpty:_searchController.searchBar.text])
    {
        NSArray *containArray = [self get_contain_word_arr:_searchController.searchBar.text];
        NSArray *data_Result_arr = [containArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSString *obj1_en_name = ((FoundModel *)obj1).en_name;
            NSString *obj2_en_name = ((FoundModel *)obj2).en_name;
            return [obj1_en_name compare:obj2_en_name options:NSNumericSearch];
        }];

        //获得搜索数据
        JXLOG(@"111");
        [_dictPinyinAndChinese1 setDictionary:[[self get_country_dict:data_Result_arr] copy]];
        [_arrayChar1 setArray:[[self get_country_arr:_dictPinyinAndChinese1] copy]];
        _parameterModel.m_row1 = @(0);
        _parameterModel.m_section1 = @(0);
        NSInteger _count = 0;
        for (int i = 0; i < _arrayChar1.count; i++) {
            for (int j = 0; j < [(_dictPinyinAndChinese1[_arrayChar1[i]]) count]; j++) {
                _count++;
                if(_count <= 2)
                {
                    _parameterModel.m_row1 = @(j);
                    _parameterModel.m_section1 = @(i);
                }
                if(_count == 2)
                {
                    break;
                }
            }
        }

    }else
    {
        [_dictPinyinAndChinese1 removeAllObjects];
        [_arrayChar1 removeAllObjects];
    }

    //刷新表格
    [self reloadData];
}

#pragma mark - --------------自定义响应----------------------


#pragma mark - --------------自定义方法----------------------
-(NSDictionary *)getnumWithChar:(NSArray *)arrayChar WithPinyin:(NSDictionary *)dictPinyinAndChinese nowCell:(NSInteger )now_cell
{
    NSDictionary *returndata = nil;
    NSInteger _count = 0;
    for (NSInteger i = 0; i < [arrayChar count]; i++) {
        for (NSInteger j = 0; j < [[dictPinyinAndChinese objectForKey:[arrayChar objectAtIndex:i]] count]; j++) {

            _count++;
            if(_count == now_cell)
            {
                returndata = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInteger:j+1],@"num",[arrayChar objectAtIndex:i],@"key",_is_suoyin,@"suoyin",nil];
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
        CGFloat height = self.contentOffset.y + ScreenHeight - self.tableHeaderView.frame.size.height;
        //        JXLOG(@"contentOffset = %f",scrollView.contentOffset.y);
        //        JXLOG(@"height = %f",height);
        //        JXLOG(@"foundCellHeight = %f",foundCellHeight_card);
        NSInteger now_cell = (NSInteger)(((CGFloat )height)/((CGFloat)foundCellHeight_card));

        //先看看有没有数据
        NSDictionary *pushData = nil;
        if(!_searchController.active)
        {
            pushData = [self getnumWithChar:_arrayChar WithPinyin:_dictPinyinAndChinese nowCell:now_cell];
        }else
        {
            pushData = [self getnumWithChar:_arrayChar1 WithPinyin:_dictPinyinAndChinese1 nowCell:now_cell];
        }

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
//进行解析数据，得到排序后的索引数组
-(NSMutableArray *)get_country_arr:(NSMutableDictionary *)dict
{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (int i = 0; i < 26; i++) {
        NSString *str = [NSString stringWithFormat:@"%c", 'A' + i];
        for (NSString *key in [dict allKeys]) {
            if ([str isEqualToString:key]) {
                [arr addObject:str];
            }
        }
    }
    return arr;
}
//进行解析数据，得到分类后的城市字典
-(NSMutableDictionary *)get_country_dict:(NSArray *)arr
{

    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    for (int i = 0; i < arr.count; i++) {
        FoundModel *model = arr[i];
        if(model.en_name != nil)
        {

            NSString *en_name = [ChineseToPinyin pinyinFromChiniseString:model.en_name];
            NSString *charFirst = [en_name substringToIndex:1];

            if([[dict allKeys] indexOfObject:charFirst] == NSNotFound)
            {
                NSMutableArray *son_arr = [[NSMutableArray alloc] init];
                [son_arr addObject:arr[i]];
                //                没找到
                [dict setObject:son_arr forKey:charFirst];
            }else
            {
                //                找到了
                [((NSMutableArray *)[dict objectForKey:charFirst]) addObject:arr[i]];
            }

        }
    }
    return dict;
}
//搜索出包含该字符的数据(中英文搜索)
-(NSArray *)get_contain_word_arr:(NSString *)title
{
    NSMutableArray *arr = [[NSMutableArray alloc] init];

    for (FoundModel *model in _arrayData) {
        if(![NSString isNilOrEmpty:title] && ![NSString isNilOrEmpty:model.cn_name])
        {
            BOOL isContain = NO;

            NSRange range_cn_name = [[ChineseToPinyin pinyinFromChiniseString:model.cn_name] rangeOfString:[ChineseToPinyin pinyinFromChiniseString:title]];
            if(range_cn_name.location != NSNotFound){
                isContain = YES;
            }

            if(!isContain && ![NSString isNilOrEmpty:model.en_name]){
                NSRange range_en_name = [[ChineseToPinyin pinyinFromChiniseString:model.en_name] rangeOfString:[ChineseToPinyin pinyinFromChiniseString:title]];
                if(range_en_name.location != NSNotFound){
                    isContain = YES;
                }
            }

            if(!isContain && ![NSString isNilOrEmpty:model.city]){
                NSRange range_city = [[ChineseToPinyin pinyinFromChiniseString:model.city] rangeOfString:[ChineseToPinyin pinyinFromChiniseString:title]];
                if(range_city.location != NSNotFound){
                    isContain = YES;
                }
            }

            if(!isContain && ![NSString isNilOrEmpty:model.state]){
                NSRange range_state = [[ChineseToPinyin pinyinFromChiniseString:model.state] rangeOfString:[ChineseToPinyin pinyinFromChiniseString:title]];
                if(range_state.location != NSNotFound){
                    isContain = YES;
                }
            }

            if(isContain){
                [arr addObject:model];
            }
        }
    }
    return [arr copy];

}
#pragma mark - --------------other----------------------



@end
