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

// 接口

// 分类

// 自定义类和三方类（ cocoapods类 > model > 工具类 > 其他）
#import "MJRefresh.h"

#import "FoundModel.h"
#import "TableViewSliderParameterModel.h"

#import "ChineseToPinyin.h"

#define foundCellHeight 184*_Scale
#define foundCellHeight_card 400*_Scale

@interface ScreenTableView()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;//搜索栏
@property (nonatomic, strong) UISearchDisplayController *searchDC;//搜索结果展示控制器 ，经常和UISearchBar配合使用

@property (nonatomic, strong) NSNumber *record_cell_num;//NSInteger
@property (nonatomic, strong) NSNumber *start_y;//表示tableview开始拖动时候的起始位置 CGFloat
@property (nonatomic, strong) NSNumber *is_suoyin;//是否点击索引 BOOL

@end


@implementation ScreenTableView

#pragma mark - --------------生命周期--------------
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style controller:(ScreenViewController *)controller{
    self = [super initWithFrame:frame style:style];
    if(self){
        _controller = controller;
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
    [self createSearchBar];//创建搜索栏
    [self createSearchDisplayCtrl];//创建搜索结果显示器
}
- (void)createSearchBar
{
    if(!_searchBar){
        _searchBar = [[UISearchBar alloc] init];
        _searchBar.backgroundColor = [UIColor clearColor];
        _searchBar.frame = CGRectMake(0, 0, ScreenWidth, 56.f);
        _searchBar.delegate = self;

        [_searchBar setSearchFieldBackgroundImage:[UIImage imageNamed:@"found_school_所在州所在城市筛选框"] forState:UIControlStateNormal];
        _searchBar.backgroundImage = [UIImage imageNamed:@"found_card_titleview"];

        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"found_school_2_选中底图.png"]];
        imageView.frame = _searchBar.frame;
        _searchBar.placeholder = @"输入城市或者学校名字 试试吧";
        UITextField *searchField = [_searchBar valueForKey:@"_searchField"];

        searchField.font=(kIOSVersions>=9.0? [UIFont systemFontOfSize:11.0f]:[UIFont fontWithName:@"Helvetica Neue" size:11.0f]);
        searchField.leftView.alpha = 0.5;

        [searchField setValue:[UIColor colorWithRed:220.0f/255.0f green:220.0f/255.0f blue:220.0f/255.0f alpha:1] forKeyPath:@"_placeholderLabel.textColor"];

        [_searchBar insertSubview:imageView atIndex:1];

        _searchBar.searchBarStyle = UISearchBarStyleDefault;
        //设置搜索栏取消按钮是否显示
        //        _searchBar.showsCancelButton = YES;
        //将搜索栏添加到视图控制器的主视图上
        //效果是,搜索栏不会随着表视图的滚动而滚动
        //    [self.view addSubview:_searchBar];
        //将搜索栏添加到表视图的表头视图上
        //效果是,搜索栏会随着表视图的滚动而滚动
    }
    self.tableHeaderView = _searchBar;

}
- (void)createSearchDisplayCtrl
{
    //创建搜索结果显示控制器
    //参数 1: 将控制器与参数1指定的搜索栏相关联
    //参数 2 : 指定控制器的显示位置，（当前控制器显示在哪个视图控制器上）
    //当用户点击到_searchBar时，searchDC就会显示，同时searchDC将_searchBar移到searchDC，再将_searchBar的取消按钮设为可见
    //    UISearchController
    _searchDC = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:_controller];
    //设置控制器的tableview的搜索结果数据源代理
    _searchDC.searchResultsDataSource = self;
    //设置控制器的tableview的代理
    _searchDC.searchResultsDelegate = self;

}
#pragma mark - --------------UpdateUI----------------------
-(void)updateUI{}

#pragma mark - --------------系统代理----------------------
#pragma mark - TableViewDelegate
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if(tableView == self)
    {
        return _arrayChar;
    }
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = _define_backview_color;

    return _arrayChar1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(tableView == self)
    {
        return _arrayChar.count;
    }else
    {
        //因为在searchDC上的_searchBar就是创建searchDC时，由第一个参数指定的_searchBar
        if(![_searchBar.text isEqualToString:@""])
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

    if(tableView == self)
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
        if(![_searchBar.text isEqualToString:@""])
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
    if(_SreenTableViewBlock){
        if(tableView == self)
        {
            _SreenTableViewBlock(@"cellClick_schooldetail1",indexPath);
        }else
        {
            _SreenTableViewBlock(@"cellClick_schooldetail2",indexPath);
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
        static NSString *cellid = @"cell_card";
        SousuoCardCell *cell_card = [tableView dequeueReusableCellWithIdentifier:cellid ];
        if(!cell_card)
        {
            WeakSelf(ws);
            cell_card = [[SousuoCardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
            cell_card.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell_card setBlock:^(NSInteger row, NSInteger section, NSString *type) {
                if([type isEqualToString:@"1"]){
                    if(ws.SreenTableViewBlock){
                        ws.SreenTableViewBlock(@"isapp1",[NSIndexPath indexPathForRow:row inSection:section]);
                    }
                }else if([type isEqualToString:@"2"]){
                    if(ws.SreenTableViewBlock){
                        ws.SreenTableViewBlock(@"isapp2",[NSIndexPath indexPathForRow:row inSection:section]);
                    }
                }
            }];
        }
        if(tableView == self)
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
            if(![_searchBar.text isEqualToString:@""])
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
        if(tableView == self)
        {
            cell.model = (_dictPinyinAndChinese[_arrayChar[indexPath.section]])[indexPath.row];
        }else
        {

            if(![_searchBar.text isEqualToString:@""])
            {
                cell.model = (_dictPinyinAndChinese1[_arrayChar1[indexPath.section]])[indexPath.row];
            }
        }
        return cell;

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
        count ++;
    }
    return 0;
}
#pragma mark - UIScrollViewDelegate
- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    //导航栏恢复
    if(_SreenTableViewBlock){
        _SreenTableViewBlock(@"scrollViewShouldScrollToTop",nil);
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
    if([_parameterModel.isCard boolValue])
    {
        NSLog(@"ssss= %lf",self.tableHeaderView.frame.size.height);
        CGFloat height = scrollView.contentOffset.y + ScreenHeight - self.tableHeaderView.frame.size.height;
        JXLOG(@"contentOffset = %f",scrollView.contentOffset.y);
        JXLOG(@"height = %f",height);
        JXLOG(@"foundCellHeight = %f",foundCellHeight_card);
        NSInteger now_cell = (NSInteger)(((CGFloat )height)/((CGFloat)foundCellHeight_card));

        if(now_cell != [_record_cell_num integerValue])
        {
            _record_cell_num = @(now_cell);
            NSDictionary *pushnum = 0;
            if(scrollView == self)
            {
                pushnum = [self getnumWithChar:_arrayChar WithPinyin:_dictPinyinAndChinese];
            }else
            {
                pushnum = [self getnumWithChar:_arrayChar1 WithPinyin:_dictPinyinAndChinese1];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SousuoAnimation" object:pushnum];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SousuoAnimation1" object:nil];
    }
    if([_parameterModel.isDragging boolValue] && [_parameterModel.isAppear boolValue] && ![_parameterModel.isNavAnimation boolValue])
    {
        if(scrollView == self && [_parameterModel.isAppear boolValue])
        {

            JXLOG(@"滚动视图正在滚动=%f",scrollView.contentOffset.y);
            if([_start_y floatValue] < 0.f && scrollView.contentOffset.y > 0.f)
            {
                //当起始位置小于0，并且当前位置大于0时，开始消失动画
                if([_parameterModel.isNavShow boolValue]){
                    if(_SreenTableViewBlock){
                        _SreenTableViewBlock(@"navHideAction",nil);
                    }
                }

            }else
            {
                if(scrollView.contentOffset.y < 0.f)
                {
                    //当tableview刚好到顶部时，开始出现动画
                    if(![_parameterModel.isNavShow boolValue]){
                        if(_SreenTableViewBlock){
                            _SreenTableViewBlock(@"navShowAction",nil);
                        }
                    }
                }else
                {
                    if(([_start_y floatValue] - scrollView.contentOffset.y) > (ScreenHeight/4.0f) && ![_parameterModel.isNavShow boolValue]){
                        //当导航栏为隐藏状态；并且整体偏移量大于1/4屏时，开始出现动画
                        if(_SreenTableViewBlock){
                            _SreenTableViewBlock(@"navShowAction",nil);
                        }
                    }else if((scrollView.contentOffset.y - [_start_y floatValue]) > (ScreenHeight/4.0f) && [_parameterModel.isNavShow boolValue]){
                        //当导航栏为出现状态；并且整体偏移量大于1/4屏时，开始消失动画
                        if(_SreenTableViewBlock){
                            _SreenTableViewBlock(@"navHideAction",nil);
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
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if(![_searchBar.text isEqualToString:@""])
    {
        NSArray *data_Result_arr = [[self get_contain_word_arr:_searchBar.text] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [((FoundModel *)obj1).en_name compare:((FoundModel *)obj2).en_name options:NSNumericSearch];
        }];

        //获得搜索数据
        JXLOG(@"111");
        [_dictPinyinAndChinese1 setDictionary:[[self get_country_dict:data_Result_arr] copy]];
        [_arrayChar1 setArray:[[self get_country_arr:_dictPinyinAndChinese1] copy]];
        _parameterModel.m_row1 = @(0);
        _parameterModel.m_section1 = @(0);
        NSInteger _count = 0;
        for (int i = 0; i < _arrayChar1.count; i ++) {
            for (int j = 0; j < [(_dictPinyinAndChinese1[_arrayChar1[i]]) count]; j ++) {
                _count ++;
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
}
#pragma mark - --------------自定义响应----------------------


#pragma mark - --------------自定义方法----------------------
-(NSDictionary *)getnumWithChar:(NSArray *)arrayChar WithPinyin:(NSDictionary *)dictPinyinAndChinese
{
    NSDictionary *returndata = 0;
    NSInteger _count = 0;
    for (NSInteger i = 0; i < [arrayChar count]; i ++) {
        for (NSInteger j = 0; j < [[dictPinyinAndChinese objectForKey:[arrayChar objectAtIndex:i]] count]; j ++) {

            _count ++;
            if(_count == [_record_cell_num integerValue])
            {
                returndata = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInteger:j+1],@"num",[arrayChar objectAtIndex:i],@"key",_is_suoyin,@"suoyin",nil];
                break;
            }
        }
    }
    return returndata;
}
//进行解析数据，得到排序后的索引数组
-(NSMutableArray *)get_country_arr:(NSMutableDictionary *)dict
{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (int i = 0; i < 26; i ++) {
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
    for (int i = 0; i < arr.count; i ++) {
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
-(NSMutableArray *)get_contain_word_arr:(NSString *)title
{
    NSMutableArray *arr = [[NSMutableArray alloc] init];

    for (FoundModel *model in _arrayData) {
        if(![title isEqualToString:@""])
        {
            NSRange range1 = [[ChineseToPinyin pinyinFromChiniseString:model.cn_name] rangeOfString:[ChineseToPinyin pinyinFromChiniseString:title]];
            NSRange range2 = [[ChineseToPinyin pinyinFromChiniseString:model.en_name] rangeOfString:[ChineseToPinyin pinyinFromChiniseString:title]];

            NSRange range3 = [[ChineseToPinyin pinyinFromChiniseString:model.en_name] rangeOfString:[ChineseToPinyin pinyinFromChiniseString:title]];

            NSRange range4 = [[ChineseToPinyin pinyinFromChiniseString:model.city] rangeOfString:[ChineseToPinyin pinyinFromChiniseString:title]];

            NSRange range5 = [[ChineseToPinyin pinyinFromChiniseString:model.state] rangeOfString:[ChineseToPinyin pinyinFromChiniseString:title]];

            if(((range1.location != NSNotFound)||(range2.location!=NSNotFound))&&(![model.en_name isEqualToString:@""])&&(![model.cn_name isEqualToString:@""]))
            {
                [arr addObject:model];
            }else if(![model.cn_name isEqualToString:@""])
            {
                if(range3.location!=NSNotFound||range4.location!=NSNotFound||range5.location!=NSNotFound)
                {
                    [arr addObject:model];
                }
            }
        }
    }
    return arr;

}
#pragma mark - --------------other----------------------



@end
