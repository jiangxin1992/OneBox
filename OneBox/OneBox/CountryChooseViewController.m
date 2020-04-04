//
//  CountryChooseViewController.m
//  OneBox
//
//  Created by 谢江新 on 15/10/30.
//  Copyright © 2015年 谢江新. All rights reserved.
//

#import "CountryChooseViewController.h"

#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "ChineseToPinyin.h"

#import "StateChooseViewController.h"
#import "PersoninfoViewController.h"

@interface CountryChooseViewController ()<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate>

@end

@implementation CountryChooseViewController
{

    CLLocationManager *locationManager;
    NSArray *country_data_arr;
    //    这个列表中用到的数据和索引
    NSMutableDictionary *_dictPinyinAndChinese;
    NSMutableArray *_arrayChar;

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

        JXLOG( @"Starting CLLocationManager" );

        locationManager.delegate = self;

        [locationManager requestWhenInUseAuthorization];
        [locationManager requestAlwaysAuthorization];
        locationManager.distanceFilter = 200;

        locationManager.desiredAccuracy = kCLLocationAccuracyBest;

        [locationManager startUpdatingLocation];

    } else {

        JXLOG( @"Cannot Starting CLLocationManager" );
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
}
#pragma mark*创建tableview
-(void)createtableview
{
    _tableview=[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:_tableview];
    _tableview.backgroundColor = UIColor.whiteColor;
    _tableview.delegate=self;
    _tableview.dataSource=self;
    _tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableview.sectionIndexBackgroundColor = [UIColor clearColor];
    _tableview.sectionIndexColor = [UIColor colorWithRed:204.0f/255.0f green:204.0f/255.0f blue:204.0f/255.0f alpha:1];
    _tableview.backgroundColor=_define_backview_color;
    [_tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.bottom.mas_equalTo(self.mas_bottomLayoutGuideTop).with.offset(0);
    }];
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

    JXLOG(@"111");

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

#pragma mark-----------------SomeDelegate----------------
#pragma mark---CLLocationManager---

// 错误信息
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    JXLOG(@"error");

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
    return _arrayChar;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _arrayChar.count;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        if(_arrayChar.count==section)
        {
            return 0;
        }
        NSString *strKey = [_arrayChar objectAtIndex:section];
        NSInteger _count=[[_dictPinyinAndChinese objectForKey:strKey] count];
        return _count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80*_Scale;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict_data=nil;
        dict_data=[[_dictPinyinAndChinese objectForKey:[_arrayChar objectAtIndex:indexPath.section]] objectAtIndex: indexPath.row];

    if([[dict_data objectForKey:@"State"] count]==0||[dict_data objectForKey:@"State"]==nil)
    {
        NSDictionary *pushdict=@{@"country_code":[dict_data objectForKey:@"code"]};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"location_change" object:pushdict];
        [self.navigationController popToViewController:self.person animated:YES];
    }else
    {
        StateChooseViewController *state=[[StateChooseViewController alloc] init];
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
        NSDictionary *dict=[[_dictPinyinAndChinese objectForKey:[_arrayChar objectAtIndex:indexPath.section]] objectAtIndex: indexPath.row];
        if([dict objectForKey:@"name"]!=nil)
        {
            cell.textLabel.text=[dict objectForKey:@"name"];
        }else
        {
            cell.textLabel.text=@"";
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
