//
//  StateChooseViewController.m
//  OneBox
//
//  Created by 谢江新 on 15/10/30.
//  Copyright © 2015年 谢江新. All rights reserved.
//

#import "StateChooseViewController.h"

#import "ChineseToPinyin.h"

#import "CityChooseViewController.h"
#import "PersoninfoViewController.h"

@interface StateChooseViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation StateChooseViewController
{

    NSArray *state_data_arr;

    //    这个列表中用到的数据和索引
    NSMutableDictionary *_dictPinyinAndChinese;
    NSMutableArray *_arrayChar;

    UITableView *_tableview;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareData];
}
#pragma mark-----------------SomePrepare----------------
-(void)prepareData
{
    UIBarButtonItem *_btn=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回箭头"] style:UIBarButtonItemStylePlain target:self action:@selector(popviewAction)];
    self.navigationItem.leftBarButtonItem=_btn;
    self.navigationItem.titleView=[regular returnNavView:@"地区" withmaxwidth:230];
    self.view.backgroundColor=_define_backview_color;
}
#pragma mark-----------------AnalyseData----------------

-(void)setDict:(NSDictionary *)dict
{
    if (_dict != dict) {
        _dict = [dict copy];
        [self analyseData];
        [self UIConfig];
    }
}
-(void)analyseData
{
    state_data_arr= [[self getStates] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [[ChineseToPinyin pinyinFromChiniseString:[obj1 objectForKey:@"name"]] compare:[ChineseToPinyin pinyinFromChiniseString:[obj2 objectForKey:@"name"]] options:NSNumericSearch];
    }];


    _dictPinyinAndChinese=[self get_country_dict:state_data_arr];
    _arrayChar = [self get_country_arr:_dictPinyinAndChinese];
}
#pragma mark*获得州信息
-(NSMutableArray *)getStates
{
    NSString* path = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"json"];

    NSData *theData = [NSData dataWithContentsOfFile:path];
    NSArray *cityarr = [[NSJSONSerialization JSONObjectWithData:theData options:NSJSONReadingMutableContainers error:nil] objectForKey:@"CountryRegion"];
    NSMutableArray *countryArr1=[[NSMutableArray alloc] init];
    for (NSDictionary *__dict in cityarr) {

        NSString *coucode=nil;
        NSString *coucode1=nil;
        if([[__dict objectForKey:@"code"] isKindOfClass:[NSNumber class]])
        {
            coucode=[[NSString alloc] initWithFormat:@"%ld",[[__dict objectForKey:@"code"] longValue]];
        }else
        {
            coucode=[__dict objectForKey:@"code"];
        }

        if([[_dict objectForKey:@"country_code"] isKindOfClass:[NSNumber class]])
        {
            coucode1=[[NSString alloc] initWithFormat:@"%ld",[[_dict objectForKey:@"country_code"] longValue]];
        }else
        {
            coucode1=[_dict objectForKey:@"country_code"];
        }



        if([coucode isEqualToString:coucode1])
        {
            if([[__dict objectForKey:@"State"] isKindOfClass:[NSArray class]])
            {
                if([[__dict objectForKey:@"State"] count])
                {
                    if([[[__dict objectForKey:@"State"] objectAtIndex:0] isKindOfClass:[NSDictionary class]])
                    {
                        NSArray *keya=[[[__dict objectForKey:@"State"] objectAtIndex:0] allKeys];
                        if(keya.count>1)
                        {
                            countryArr1=[__dict objectForKey:@"State"];

                        }else
                        {
                            countryArr1=[[[__dict objectForKey:@"State"] objectAtIndex:0] objectForKey:@"City"];
                        }



                    }else
                    {
                        countryArr1=[__dict objectForKey:@"State"];

                    }

                }else
                {
                    countryArr1=[__dict objectForKey:@"State"];

                }


            }else
            {
                if([[__dict objectForKey:@"City"]  isKindOfClass:[NSArray class]])
                {
                    countryArr1=[__dict objectForKey:@"City"];
                }else
                {
                    countryArr1=[[NSMutableArray alloc] init];
                }


            }

            break;
        }
    }
    NSMutableArray *arr=[[NSMutableArray alloc] init];

    for (int i=0; i<countryArr1.count; i++) {
        NSDictionary *dict=countryArr1[i];
        if([dict objectForKey:@"name"]!=[NSNull null]&&[dict objectForKey:@"name"]!=nil)
        {
            if(![[dict objectForKey:@"name"] isEqualToString:@""])
            {
                [arr addObject:dict];
            }
        }
    }
    return arr;
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

#pragma mark-----------------SomeDelegate----------------

#pragma mark---TableViewDelegate---
#pragma mark*索引
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
        return _arrayChar;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
        return _arrayChar.count+1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        if(_arrayChar.count==0)
        {
            return 0;
        }else if(section>=[[_dictPinyinAndChinese allKeys] count])
        {
            return 1;
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
    if([[_dictPinyinAndChinese allKeys] count] ==indexPath.section&&indexPath.section>0)
    {
        NSDictionary *pushdict=@{@"country_code":[_dict objectForKey:@"country_code"]};

        [[NSNotificationCenter defaultCenter] postNotificationName:@"location_change" object:pushdict];
        [self.navigationController popToViewController:self.person animated:YES];
    }else
    {
        NSDictionary *dict_data=nil;

            dict_data=[[_dictPinyinAndChinese objectForKey:[_arrayChar objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];


        if([[dict_data allKeys] count]==3)
        {


            NSDictionary *pushdict=@{@"country_code":[_dict objectForKey:@"country_code"],@"state_code":[dict_data objectForKey:@"code"]};

            [[NSNotificationCenter defaultCenter] postNotificationName:@"location_change" object:pushdict];
            [self.navigationController popToViewController:self.person animated:YES];
        }else
        {
            if([dict_data objectForKey:@"City"]!=nil)
            {
                if([[dict_data objectForKey:@"City"] isKindOfClass:[NSArray class]])
                {
                    if([[dict_data objectForKey:@"City"] count]>0)
                    {
                        CityChooseViewController *state=[[CityChooseViewController alloc] init];


                        state.person=self.person;
                        state.dict=@{@"country_code":[_dict objectForKey:@"country_code"],@"state_code":[dict_data objectForKey:@"code"]};
                        [self.navigationController pushViewController:state animated:YES];
                    }else
                    {

                        NSDictionary *pushdict=@{@"country_code":[_dict objectForKey:@"country_code"],@"state_code":[dict_data objectForKey:@"code"]};

                        [[NSNotificationCenter defaultCenter] postNotificationName:@"location_change" object:pushdict];
                        [self.navigationController popToViewController:self.person animated:YES];
                    }

                }else
                {

                    NSDictionary *pushdict=@{@"country_code":[_dict objectForKey:@"country_code"],@"state_code":[dict_data objectForKey:@"code"]};

                    [[NSNotificationCenter defaultCenter] postNotificationName:@"location_change" object:pushdict];
                    [self.navigationController popToViewController:self.person animated:YES];
                }

            }else
            {

                NSDictionary *pushdict=@{@"country_code":[_dict objectForKey:@"country_code"],@"state_code":[dict_data objectForKey:@"code"]};

                [[NSNotificationCenter defaultCenter] postNotificationName:@"location_change" object:pushdict];
                [self.navigationController popToViewController:self.person animated:YES];
            }
        }


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


        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.textLabel.font=[regular getFont:14.0f];
        NSString *content=nil;

        NSDictionary *dict=nil;
            if((indexPath.section==[[_dictPinyinAndChinese allKeys] count])&&[[_dictPinyinAndChinese allKeys] count]>0)
            {
                cell.accessoryType=UITableViewCellAccessoryNone;
                content=@"其他";


            }else
            {

                dict=[[_dictPinyinAndChinese objectForKey:[_arrayChar objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
                if([[dict allKeys] count]==3)
                {
                    cell.accessoryType=UITableViewCellAccessoryNone;

                }else
                {
                    if([dict objectForKey:@"City"]!=nil)
                    {
                        if([[dict objectForKey:@"City"] isKindOfClass:[NSArray class]])
                        {
                            if([[dict objectForKey:@"City"] count]>0)
                            {
                                cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                            }else
                            {
                                cell.accessoryType=UITableViewCellAccessoryNone;
                            }

                        }else
                        {
                            cell.accessoryType=UITableViewCellAccessoryNone;
                        }

                    }else
                    {
                        cell.accessoryType=UITableViewCellAccessoryNone;
                    }
                }

                if([dict objectForKey:@"name"]==nil)
                {
                    content=@"";

                }else
                {
                    content=[dict objectForKey:@"name"];

                }


            }


        
        cell.textLabel.text=content;
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

@end
