//
//  CountryCodeViewController.m
//  OneBox
//
//  Created by 谢江新 on 15/11/6.
//  Copyright © 2015年 谢江新. All rights reserved.
//
#import "CountryCodeCell.h"
#define foundCellHeight 80*_Scale
#import "CountryCodeViewController.h"

@interface CountryCodeViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation CountryCodeViewController
{
    UITableView *_tableview;
    CGFloat statusBarHeight;

    NSMutableDictionary *countrydict;
    NSMutableArray *_arrayChar;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepare];
    [self UIConfig];
}
-(void)UIConfig
{
    [self CreateTableView];
//    [self CreateSearchBar];
//    [self createSearchDisplayCtrl];

}
#pragma mark-tableviewdelegate
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return _arrayChar;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return foundCellHeight;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict=[[countrydict objectForKey:[_arrayChar objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    self.block([dict objectForKey:@"code"]);
    [self.navigationController popViewControllerAnimated:YES];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

        NSInteger _count=_arrayChar.count;
        return _count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    NSString *strKey = [_arrayChar objectAtIndex:section];
    NSInteger _count=[[countrydict objectForKey:strKey] count];
    return _count;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid=@"cell";
    CountryCodeCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid ];


    if(!cell)
    {
        cell=[[CountryCodeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
       
    }
    cell.dict=[[countrydict objectForKey:[_arrayChar objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;

    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return  50*_Scale;
}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section; 
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section

{

    CGRect frameRect = CGRectMake(0, 0, 50, 50*_Scale);
    UILabel *label = [[UILabel alloc] initWithFrame:frameRect] ;
    label.text=[_arrayChar objectAtIndex:section];
    label.textAlignment=0;
    return label;

}
-(void)CreateTableView
{
    _tableview=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight+kTabBarHeight) style:UITableViewStylePlain];
    _tableview.delegate=self;
    _tableview.dataSource=self;

    _tableview.sectionIndexBackgroundColor = [UIColor clearColor];
    _tableview.sectionIndexColor = self.view.backgroundColor;
    _tableview.backgroundColor=_define_backview_color;
    [self.view addSubview:_tableview];
}

-(void)prepare
{
    countrydict=[[NSMutableDictionary alloc] init];
    _arrayChar=[[NSMutableArray alloc] init];
    UIBarButtonItem *_btn=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回箭头"] style:UIBarButtonItemStylePlain target:self action:@selector(popviewAction)];
    self.navigationItem.leftBarButtonItem=_btn;

    self.view.backgroundColor=[UIColor colorWithRed:230.0f/255.0f green:230.0f/255.0f blue:230.0f/255.0f alpha:1];

    self.navigationItem.titleView=[regular returnNavView:@"选择国家" withmaxwidth:230];

    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"country_code" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    NSMutableDictionary *data1=[[NSMutableDictionary alloc] init];

    NSArray *keyarr=[data allKeys];

    for (int i=0; i<keyarr.count; i++) {
        NSArray *arr=[data objectForKey:[keyarr objectAtIndex:i]];
        if(arr.count>0)
        {

            NSMutableArray *mutablearr=[[NSMutableArray alloc] init];
            for (NSString *content in arr) {
                NSArray *array = [content componentsSeparatedByString:@"+"];

                if(array.count==2)
                {
                    NSDictionary *dict___t=@{@"country":[array objectAtIndex:0],@"code":[array objectAtIndex:1]};
                    [mutablearr addObject:dict___t];

                }
            }
            [data1 setObject:mutablearr forKey:[keyarr objectAtIndex:i]];
        }
    }


    for (int i=0; i<keyarr.count; i++) {
        NSArray *arr=[data1 objectForKey:[keyarr objectAtIndex:i]];
        if(arr.count>0)
        {
            [countrydict setObject:arr forKey:[keyarr objectAtIndex:i]];
        }
    }

    for (int i = 0; i < 26; i++) {
        NSString *str = [NSString stringWithFormat:@"%c", 'A' + i];
        for (NSString *key in [countrydict allKeys]) {
            if ([str isEqualToString:key]) {
                [_arrayChar addObject:str];
            }
        }
    }



}

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
