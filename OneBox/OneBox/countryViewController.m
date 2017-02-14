//
//  countryViewController.m
//  OneBox
//
//  Created by 谢江新 on 15/10/30.
//  Copyright © 2015年 谢江新. All rights reserved.
//

#import "countryViewController.h"

#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "ChineseToPinyin.h"

#import "statechooseViewController.h"
#import "personinfoViewController.h"

@interface countryViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,CLLocationManagerDelegate>

@end

@implementation countryViewController
{

    CLLocationManager *locationManager;
    NSArray *country_data_arr;
    //搜索栏
    UISearchBar *_searchBar;
    //搜索结果展示控制器 ，经常和UISearchBar配合使用
    UISearchDisplayController *_searchDC;
    //    这个列表中用到的数据和索引
    NSMutableDictionary *_dictPinyinAndChinese;
    NSMutableArray *_arrayChar;
    //    记录搜索列表中用到的数据和索引
    NSMutableDictionary *_dictPinyinAndChinese1;
    NSMutableArray *_arrayChar1;

    UITableView *_tableview;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareData];
    [self analyseData];
    [self UIConfig];
//    [self setupLocationManager];


}
#pragma mark-----------------获取地理位置----------------
- (void) setupLocationManager {

    locationManager = [[CLLocationManager alloc] init] ;

    if ([CLLocationManager locationServicesEnabled]) {

        NSLog( @"Starting CLLocationManager" );

        locationManager.delegate = self;

        [locationManager requestWhenInUseAuthorization];
        [locationManager requestAlwaysAuthorization];
        locationManager.distanceFilter = 200;

        locationManager.desiredAccuracy = kCLLocationAccuracyBest;

        [locationManager startUpdatingLocation];

    } else {

        NSLog( @"Cannot Starting CLLocationManager" );
    }
    
}
#pragma mark-----------------SomePrepare----------------
-(void)prepareData{
    UIBarButtonItem *_btn=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回箭头"] style:UIBarButtonItemStylePlain target:self action:@selector(popviewAction)];
    self.navigationItem.leftBarButtonItem=_btn;
    self.navigationItem.titleView=[regular returnNavView:@"地区" withmaxwidth:230];
    self.view.backgroundColor=_define_backview_color;

}
#pragma mark-----------------视图创建----------------
-(void)UIConfig
{
    //    创建tableview
    [self createtableview];
    //    创建搜索栏
    [self createSearchBar];
    //    创建搜索结果显示器
    [self createSearchDisplayCtrl];
}
#pragma mark*创建tableview
-(void)createtableview
{
    _tableview=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight+kTabBarHeight) style:UITableViewStylePlain];
    _tableview.delegate=self;
    _tableview.dataSource=self;
    _tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableview.sectionIndexBackgroundColor = [UIColor clearColor];
    _tableview.sectionIndexColor = [UIColor colorWithRed:204.0f/255.0f green:204.0f/255.0f blue:204.0f/255.0f alpha:1];
    _tableview.backgroundColor=_define_backview_color;
    [self.view addSubview:_tableview];

}
#pragma mark*创建SearchBar
- (void)createSearchBar
{
    _searchBar = [[UISearchBar alloc] init];
    _searchBar.backgroundColor=[UIColor clearColor];
    _searchBar.frame = CGRectMake(0, 0, ScreenWidth, 44);

    _searchBar.delegate=self;
    //    _searchBar.searc
    [_searchBar setSearchFieldBackgroundImage:[UIImage imageNamed:@"found_school_所在州所在城市筛选框"] forState:UIControlStateNormal];
    _searchBar.backgroundImage=[UIImage imageNamed:@"hehehehe"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"found_school_2_选中底图.png"]];
    imageView.frame=_searchBar.frame;
    _searchBar.placeholder=@"查找国家";
    UITextField *searchField = [_searchBar valueForKey:@"_searchField"];

    searchField.font=(kIOSVersions>=9.0? [UIFont systemFontOfSize:11.0f]:[UIFont fontWithName:@"Helvetica Neue" size:11.0f]);;
    searchField.leftView.alpha=0.5;

    [searchField setValue:[UIColor colorWithRed:220.0f/255.0f green:220.0f/255.0f blue:220.0f/255.0f alpha:1] forKeyPath:@"_placeholderLabel.textColor"];


    [_searchBar insertSubview:imageView atIndex:1];

    _searchBar.searchBarStyle=UISearchBarStyleDefault;
    //设置搜索栏取消按钮是否显示
    //        _searchBar.showsCancelButton = YES;
    //将搜索栏添加到视图控制器的主视图上
    //效果是,搜索栏不会随着表视图的滚动而滚动
    //    [self.view addSubview:_searchBar];
    //将搜索栏添加到表视图的表头视图上
    //效果是,搜索栏会随着表视图的滚动而滚动
    _tableview.tableHeaderView = _searchBar;
}
#pragma mark*创建搜索显示器
- (void)createSearchDisplayCtrl
{
    //创建搜索结果显示控制器
    //参数 1: 将控制器与参数1指定的搜索栏相关联
    //参数 2 : 指定控制器的显示位置，（当前控制器显示在哪个视图控制器上）
    //当用户点击到_searchBar时，searchDC就会显示，同时searchDC将_searchBar移到searchDC，再将_searchBar的取消按钮设为可见
    _searchDC = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];


    //设置控制器的tableview的搜索结果数据源代理
    _searchDC.searchResultsDataSource = self;
    //设置控制器的tableview的代理
    _searchDC.searchResultsDelegate = self;
    
}
#pragma mark-----------------SomePrepare----------------
#pragma mark-----------------AnalyseData----------------
-(void)analyseData
{

    NSString* path = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"json"];
    NSData *theData = [NSData dataWithContentsOfFile:path];

    NSArray *data=[[NSJSONSerialization JSONObjectWithData:theData options:NSJSONReadingMutableContainers error:nil] objectForKey:@"CountryRegion"];

    country_data_arr=[data sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [[ChineseToPinyin pinyinFromChiniseString:[obj1 objectForKey:@"name"]] compare:[ChineseToPinyin pinyinFromChiniseString:[obj2 objectForKey:@"name"]] options:NSNumericSearch];
    }];

    _dictPinyinAndChinese=[self get_country_dict:country_data_arr];
    _arrayChar = [self get_country_arr:_dictPinyinAndChinese];

    NSLog(@"111");

}
#pragma mark*进行解析数据，得到排序后的索引数组
-(NSMutableArray *)get_country_arr:(NSMutableDictionary *)dict
{
    NSMutableArray *arr=[[NSMutableArray alloc] init];
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
#pragma mark*进行解析数据，得到分类后的城市字典
-(NSMutableDictionary *)get_country_dict:(NSArray *)arr
{

    NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
    for (int i=0; i<arr.count; i++) {
        if([(NSDictionary *)(arr[i]) objectForKey:@"name"]!=[NSNull null]&&[(NSDictionary *)(arr[i]) objectForKey:@"name"]!=nil)
        {

            NSString *en_name=[ChineseToPinyin pinyinFromChiniseString:[(NSDictionary *)(arr[i]) objectForKey:@"name"]];
            NSString *charFirst = [en_name substringToIndex:1];

            if([[dict allKeys] indexOfObject:charFirst] == NSNotFound)
            {
                NSMutableArray *son_arr=[[NSMutableArray alloc] init];
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
#pragma mark*搜索出包含该字符的数据(中英文搜索)
-(NSMutableArray *)get_contain_word_arr:(NSString *)title
{
    NSMutableArray *arr=[[NSMutableArray alloc] init];

    for (NSDictionary *model in country_data_arr) {
        if(![title isEqualToString:@""])
        {
            NSRange range1 = [[ChineseToPinyin pinyinFromChiniseString:[model objectForKey:@"name"]] rangeOfString:[ChineseToPinyin pinyinFromChiniseString:title]];
            NSRange range2 = [[ChineseToPinyin pinyinFromChiniseString:[model objectForKey:@"en_name"]] rangeOfString:[ChineseToPinyin pinyinFromChiniseString:title]];

            NSString *titeeee=[model objectForKey:@"en_name"];
            NSRange range3 = [[ChineseToPinyin pinyinFromChiniseString:titeeee] rangeOfString:[ChineseToPinyin pinyinFromChiniseString:title]];

            if(((range1.location != NSNotFound)||(range2.location!=NSNotFound))&&(![[model objectForKey:@"en_name"] isEqualToString:@""])&&(![[model objectForKey:@"name"] isEqualToString:@""]))
            {
                [arr addObject:model];
            }else if(![[model objectForKey:@"name"] isEqualToString:@""])
            {
                if((range3.location!=NSNotFound))
                {
                    [arr addObject:model];
                }
            }
        }
    }
    
    return arr;
}

#pragma mark-----------------SomeDelegate----------------
#pragma mark---SearchBarDelegate---
#pragma mark*内容发生变化的时候，对国家数据进行搜索
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if(![_searchBar.text isEqualToString:@""])
    {
        //获得搜索数据
        NSArray *data_Result_arr=[[self get_contain_word_arr:_searchBar.text] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [[ChineseToPinyin pinyinFromChiniseString:[obj1 objectForKey:@"name"]] compare:[ChineseToPinyin pinyinFromChiniseString:[obj2 objectForKey:@"name"]] options:NSNumericSearch];
        }];
        _dictPinyinAndChinese1=[self get_country_dict:data_Result_arr];
        _arrayChar1=[self get_country_arr:_dictPinyinAndChinese1];

    }else
    {
        _dictPinyinAndChinese1=[[NSMutableDictionary alloc] init];
        _arrayChar1=[[NSMutableArray alloc] init];

    }
}
#pragma mark---CLLocationManager---

// 错误信息
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"error");

}

// 6.0 以上调用这个函数
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {


    CLLocation *newLocation = locations[0];
    [manager stopUpdatingLocation];

    //------------------位置反编码---5.0之后使用-----------------
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:newLocation
                   completionHandler:^(NSArray *placemarks, NSError *error){
                       //进行分析，获得当前的地理位置
                       for (CLPlacemark *place in placemarks) {

                           for (int i=0; i<country_data_arr.count; i++) {
                               NSDictionary *dict=country_data_arr[i];
                               if([dict objectForKey:@"name"])
                               {


                               }
                           }
                       }
                       
                   }];
    
}
#pragma mark---TableViewDelegate---

#pragma mark*索引
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if(tableView==_tableview)
    {
        return _arrayChar;
    }
    return _arrayChar1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(tableView==_tableview)
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

    if(tableView==_tableview)
    {
        if(_arrayChar.count==section)
        {
            return 0;
        }
        NSString *strKey = [_arrayChar objectAtIndex:section];
        NSInteger _count=[[_dictPinyinAndChinese objectForKey:strKey] count];
        return _count;

    }else
    {
        if(![_searchBar.text isEqualToString:@""])
        {
            NSString *strKey = [_arrayChar1 objectAtIndex:section];
            NSInteger _count=[[_dictPinyinAndChinese1 objectForKey:strKey] count];
            return _count;

        }
        return 1;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80*_Scale;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict_data=nil;
    if(tableView==_tableview)
    {
        dict_data=[[_dictPinyinAndChinese objectForKey:[_arrayChar objectAtIndex:indexPath.section]] objectAtIndex: indexPath.row];
    }else
    {
        dict_data=[[_dictPinyinAndChinese1 objectForKey:[_arrayChar1 objectAtIndex:indexPath.section]] objectAtIndex: indexPath.row];
    }


    if([[dict_data objectForKey:@"State"] count]==0||[dict_data objectForKey:@"State"]==nil)
    {
        NSDictionary *pushdict=@{@"country_code":[dict_data objectForKey:@"code"]};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"location_change" object:pushdict];
        [self.navigationController popToViewController:self.person animated:YES];
    }else
    {
        statechooseViewController *state=[[statechooseViewController alloc] init];
        NSDictionary *pushdata=@{@"country_code":[dict_data objectForKey:@"code"]};

        state.dict=pushdata;
        state.person=self.person;

        [self.navigationController pushViewController:state animated:YES];
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_arrayChar.count)
    {
        static NSString *cellid=@"cell";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid ];

        if(!cell)
        {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
            UILabel *lable=[[UILabel alloc] initWithFrame:CGRectMake(10,79*_Scale, ScreenWidth-10, 1*_Scale)];
            [cell addSubview:lable];
            lable.backgroundColor=[UIColor colorWithRed:200.0f/255.0f green:200.0f/255.0f blue:200.0f/255.0f alpha:1];
        }
        NSDictionary *dict=nil;
        if(tableView==_tableview)
        {
            dict=[[_dictPinyinAndChinese objectForKey:[_arrayChar objectAtIndex:indexPath.section]] objectAtIndex: indexPath.row];
            if([dict objectForKey:@"name"]!=nil)
            {
                cell.textLabel.text=[dict objectForKey:@"name"];

            }else
            {
                cell.textLabel.text=@"";
            }

        }else
        {
            if(![_searchBar.text isEqualToString:@""])
            {
                dict=[[_dictPinyinAndChinese1 objectForKey:[_arrayChar1 objectAtIndex:indexPath.section]] objectAtIndex: indexPath.row];
                if([dict objectForKey:@"name"]!=nil)
                {
                    cell.textLabel.text=[dict objectForKey:@"name"];

                }else
                {
                    cell.textLabel.text=@"";
                }
            }else
            {

            }

        }

        if([[dict objectForKey:@"State"] count]==0||[dict objectForKey:@"State"]==nil)
        {
            cell.accessoryType=UITableViewCellAccessoryNone;

        }else
        {
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.textLabel.font=[regular getFont:14.0f];

        return cell;
    }
    static NSString *cellid=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid ];
    if(!cell)
    {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    return cell;
    
}
#pragma mark-----------------Others----------------
-(void)popviewAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
