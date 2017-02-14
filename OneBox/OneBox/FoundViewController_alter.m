//
//  FoundViewController_alter.m
//  OneBox
//
//  Created by 谢江新 on 15/4/20.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import "FoundViewController_alter.h"

#import "MJRefresh.h"

#import "bangdanlistViewController.h"
#import "SchoolDetailViewController.h"
#import "souSuoViewController.h"
#import "shaiXuanViewController.h"
#import "bangdanViewController.h"
#import "userInfoViewController.h"
#import "LoginViewController.h"
#import "CustomTabbarController.h"

#import "NMRangeSlider.h"
#import "FoundCell.h"

#import "ChineseToPinyin.h"
#import "foundModel.h"

#define foundCellHeight 184*_Scale

@interface FoundViewController_alter ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation FoundViewController_alter
{

    BOOL _nav_donghua;
    CGFloat _start_y;
    BOOL _Dragging;
    BOOL _appear;

    UILabel *leftLabel1;
    UILabel *rightLabel1;
    UILabel *leftLabel2;
    UILabel *rightLabel2;

    long total_students_min;
    long ap_count_max;
    long total_students_max;
    long ap_count_min;


    NSMutableArray *cityArray;
    UIScrollView *_scrollview_city;
    UIButton *all_city;
    UIView *upviewcity;
    UIImageView *backviewcity;

    NSInteger _now_state;
    UITextField *screachText;
    UIView *searchview;

    NSDictionary *_dictPinyinAndChinese;
    NSMutableArray *_arrayChar;

//    存放标题按钮
    NSMutableArray *titleBtnArray;
//    阴影
    UIImageView *yinying;
//    滑动image
    UIImageView *huadong;

//    开始
    NSInteger start;
//    数量
    NSInteger count;
//    data
    NSMutableData *_receiveData;
    //搜索栏
    UISearchBar *_searchBar;
    //搜索结果展示控制器 ，经常和UISearchBar配合使用
    UISearchDisplayController *_searchDC;
//    筛选按钮
    UIImageView *searchImg;
    UIImageView *bangdanImg;
    UIImageView *sousuoImg;
    //搜索结果数据
    NSMutableArray *_arrayResult;

    NSMutableArray *_arrayData;


    NSInteger _page;

    NSArray *screen_titleArr;
    NSArray *screen_normalImg;
    NSArray *screen_selectImg;
    NSMutableArray *screen_btnArr;

    NSMutableArray *stateArr;
    NSMutableArray *cityArr;

    NSMutableString *state_id;
    NSMutableString *city_id;
    UIView *downView;

    BOOL _isfirst_choose;

    void (^blockSuccess)(NSDictionary *dict);
    void (^blockFailure)(NSError *error);
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    _appear=YES;
    _Dragging=NO;
    _nav_donghua=NO;
    _start_y=0;
    [self createTableView];
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        NSArray *list=self.navigationController.navigationBar.subviews;
        for (id obj in list) {
            if ([obj isKindOfClass:[UIImageView class]]) {
                UIImageView *imageView=(UIImageView *)obj;
                NSArray *list2=imageView.subviews;
                for (id obj2 in list2) {
                    if ([obj2 isKindOfClass:[UIImageView class]]) {
                        UIImageView *imageView2=(UIImageView *)obj2;
                        imageView2.hidden=YES;
                    }
                }
            }
        }
    }
//    准备数据
    [self prepareData];
//    准备ui
    [self preUIConfig];
//   创建视图
    [self UIConfig];
//   数据下载

    blockSuccess=^(NSDictionary *_dict)
    {
        if(((NSArray *)[_dict objectForKey:@"data"]).count==0)
        {

            if(_page>1)
            {
                [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"没有更多了" WithImg:@"Prompt_提交成功" Withtype:1]];

            }else
            {
                [_arrayChar removeAllObjects];
                [_tableView reloadData];
            }

        }else
        {

            [_arrayData addObjectsFromArray:[foundModel parsingData:_dict]];
_dictPinyinAndChinese = [[NSMutableDictionary alloc] init];
            
            //name = “关羽”
            for (foundModel *model in _arrayData) {
                //‘GUANYU’
                NSString *pinyin = [ChineseToPinyin pinyinFromChiniseString:model.en_name];
                
                //“G”
                NSString *charFirst = [pinyin substringToIndex:1];
                //从字典中招关于G的键值对
                NSMutableArray *charArray  = [_dictPinyinAndChinese objectForKey:charFirst];
                //没有找到
                if (charArray == nil) {
                    NSMutableArray *subArray = [[NSMutableArray alloc] init];
                    //“关羽”
                    [subArray addObject:model];
                    // dict   key = "G"  value = subArray -> "关羽"
                    [_dictPinyinAndChinese setValue:subArray forKey:charFirst];
                }
                else
                {
                    [charArray addObject:model];
                }
                
            }
            
            for (NSString *keys in [_dictPinyinAndChinese allKeys]) {
                //        NSLog(@"%@", [_dictPinyinAndChinese objectForKey:keys]);
                NSLog(@"%@", keys);
                for (NSString *str in [_dictPinyinAndChinese objectForKey:keys]) {
                    NSLog(@"%@", str);
                }
            }
            
            _arrayChar = [[NSMutableArray alloc] init];
            for (int i = 0; i < 26; i++) {
                NSString *str = [NSString stringWithFormat:@"%c", 'A' + i];
                for (NSString *key in [_dictPinyinAndChinese allKeys]) {
                    if ([str isEqualToString:key]) {
                        [_arrayChar addObject:str];
                    }
                }
            }

            [_tableView reloadData];
        }
        
        
        if(start==0)
        {
                        if(_dict[@"count"]!=[NSNull null])
                        {
            NSString *countStr=(NSString *)_dict[@"count"];
            count=[countStr intValue];
            [_tableView headerEndRefreshing];
                        }else
                        {
                            count=0;
                            [_arrayData removeAllObjects];
                            [_arrayChar removeAllObjects];
                            [_arrayResult removeAllObjects];
                            [_tableView headerEndRefreshing];
            
                        }

            
        }else
        {
            [_tableView footerEndRefreshing];
        }
        [[ToolManager sharedManager] removeProgress];
        
        
    };
    blockFailure=^(NSError *_error)
    {
        [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
        NSLog(@"发生错误！%@",_error);
        if(start==0)
        {
            [_tableView headerEndRefreshing];
            
        }else
        {
            [_tableView footerEndRefreshing];
        }
    };
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(navBarReset) name:@"navBarReset" object:nil];

}
#pragma mark-点击状态栏时de导航栏重置
- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    _Dragging=NO;
    self.navigationController.navigationBar.frame=CGRectMake(0, 20, [[UIScreen mainScreen]bounds].size.width, 44);
    self.navigationItem.titleView.alpha=1;
    _nav_donghua=NO;

    // Do your action here
    return YES;
}
#pragma mark-导航栏重置
-(void)navBarReset
{
    _Dragging=NO;
    self.navigationController.navigationBar.frame=CGRectMake(0, 20, [[UIScreen mainScreen]bounds].size.width, 44);
    self.navigationItem.titleView.alpha=1;
    _nav_donghua=NO;
}
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSLog(@"%@",_arrayChar);

    return _arrayChar;
}
#pragma mark 开始进入刷新状态
/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [_tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    
    [_tableView headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [_tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
}
- (void)headerRereshing
{
    count=0;
    start=0;
    _page=1;
    [_arrayData removeAllObjects];
    [self initializeData];
    [self requestData];

}
/**
 为了保证内部不泄露，在dealloc中释放占用的内存
 */
- (void)dealloc
{
    NSLog(@"MJTableViewController--dealloc---");
}

- (void)footerRereshing
{
    start+=100;
    _page++;
    [self requestData];
}
#pragma mark-获取Parameters参数列表
-(NSMutableDictionary *)getParameters
{

    NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
    NSMutableArray *sexarr=[[NSMutableArray alloc] init];

//sexarr
    if(((UIButton *)screen_btnArr[1]).selected)
    {
        [sexarr addObject:@"0"];
    }
    if(((UIButton *)screen_btnArr[2]).selected)
    {
        [sexarr addObject:@"1"];
    }
    if(((UIButton *)screen_btnArr[0]).selected)
    {
        [sexarr addObject:@"2"];
    }else if((((UIButton *)screen_btnArr[0]).selected)&&(((UIButton *)screen_btnArr[1]).selected)&&(((UIButton *)screen_btnArr[2]).selected))
    {
        [sexarr addObject:@"2"];
        [sexarr addObject:@"1"];
        [sexarr addObject:@"0"];

    }


    if(!(!(((UIButton *)screen_btnArr[0]).selected)&&(!((UIButton *)screen_btnArr[1]).selected)&&(!((UIButton *)screen_btnArr[2]).selected)))
    {
        [dict setObject:sexarr forKey:@"student_sex_limit"];
    }

    if(((UIButton *)screen_btnArr[3]).selected)
    {
    [dict setObject:@"1" forKey:@"isesl"];
    }



    NSMutableArray *schoolStyle=[[NSMutableArray alloc] init];
    if(((UIButton *)screen_btnArr[7]).selected)
    {
        [schoolStyle addObject:@"junior"];
    }
    if(((UIButton *)screen_btnArr[6]).selected)
    {
        [schoolStyle addObject:@"senior"];
    }else if ((((UIButton *)screen_btnArr[7]).selected)&&(((UIButton *)screen_btnArr[6]).selected))
    {

        [schoolStyle addObject:@"junior"];
        [schoolStyle addObject:@"senior"];

    }

    if(!(!(((UIButton *)screen_btnArr[6]).selected)&&(!((UIButton *)screen_btnArr[7]).selected)))
    {
        [dict setObject:schoolStyle forKey:@"branch_type"];
    }


    NSMutableArray *schoolStyle2=[[NSMutableArray alloc] init];

    if(((UIButton *)screen_btnArr[5]).selected)
    {
        [schoolStyle2 addObject:@"boarding"];
    }
    if(((UIButton *)screen_btnArr[4]).selected)
    {
        [schoolStyle2 addObject:@"day"];
    }else if((((UIButton *)screen_btnArr[4]).selected)&&(((UIButton *)screen_btnArr[5]).selected))
    {
        [schoolStyle2 addObject:@"boarding"];
        [schoolStyle2 addObject:@"day"];
    }


    if(!(!(((UIButton *)screen_btnArr[4]).selected)&&(!((UIButton *)screen_btnArr[5]).selected)))
    {
        [dict setObject:schoolStyle2 forKey:@"boarding_day"];
    }





    if((![_state isEqualToString:@""])&&(![_state isEqualToString:@"所在州"])&&((_state!=nil)))
    {
        [dict setObject:[[NSString alloc] initWithFormat:@"%@",state_id] forKey:@"us_state_id"];
    }
    if((![_city isEqualToString:@""])&&(![_city isEqualToString:@"所在城市"])&&(_city!=nil))
    {
        [dict setObject:[[NSString alloc] initWithFormat:@"%@",city_id] forKey:@"us_city_id"];
    }



    if(_page>0)
    {
        [dict setObject:[[NSString alloc] initWithFormat:@"%ld",(long)_page] forKey:@"page"];
    }

    NSUserDefaults *____dict=[NSUserDefaults standardUserDefaults];
    NSString *_token=nil;
    if([[____dict objectForKey:@"islogin"] integerValue]==1)
    {
        _token=[____dict objectForKey:@"token"];
    }else
    {
        _token=@"";
    }
    [dict setObject:_token forKey:@"token"];

    [dict setObject:[[NSString alloc] initWithFormat:@"%@,%@",leftLabel2.text,rightLabel2.text] forKey:@"ap_count"];
    [dict setObject:[[NSString alloc] initWithFormat:@"%@,%@",leftLabel1.text,rightLabel1.text] forKey:@"total_students"];

    return dict;
}
-(void)requestData
{

    NSArray *arr1=@[_ismixed,_isfemale,_ismale,_isESL,_isday,_isboardind,_issenior,_isjunior];
    for (int i=0; i<screen_btnArr.count; i++) {

        UIButton *btn=nil;

        btn=(UIButton *)screen_btnArr[i];
        if(!btn.selected)
        {
            [(NSMutableString *)arr1[i] setString:@"0"];
        }else
        {
            [(NSMutableString *)arr1[i] setString:@"1"];
        }
    }



    NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
    if(_page>0)
    {
        [dict setObject:[[NSString alloc] initWithFormat:@"%ld",(long)_page] forKey:@"page"];
    }
    NSUserDefaults *____dict=[NSUserDefaults standardUserDefaults];
    NSString *_token=nil;
    if([[____dict objectForKey:@"islogin"] integerValue]==1)
    {
        _token=[____dict objectForKey:@"token"];
    }else
    {
        _token=@"";
    }
    [dict setObject:_token forKey:@"token"];

//    [[ToolManager sharedManager] createProgress:@"加载中"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    NSLog(@"%@",dict);
    [manager GET:[[NSString alloc] initWithFormat:@"%@%@",DNS,@"/v1/schools"] parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSString *html = operation.responseString;
        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
        blockSuccess(dict);
        [[ToolManager sharedManager] removeProgress];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_tableView headerEndRefreshing];
       [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
        [[ToolManager sharedManager] removeProgress];
    }];
}


-(void)prepareData
{
//    _firstRequest=YES;
    leftLabel1=[[UILabel alloc] init];
    leftLabel2=[[UILabel alloc] init];
    rightLabel1=[[UILabel alloc] init];
    rightLabel2=[[UILabel alloc] init];
    _now_state=0;
    state_id=[[NSMutableString alloc] init];
    city_id=[[NSMutableString alloc] init];

    _isfirst_choose=YES;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeFound) name:@"changeFound" object:nil];
    _receiveData=[[NSMutableData alloc] init];
    _arrayData=[[NSMutableArray alloc] init];
    [self initializeData];
    _arrayResult = [[NSMutableArray alloc] init];
    screen_titleArr=@[@[@"混 校",@"女 校",@"男 校",@"ESL"],@[@"走 读",@"寄 宿",@"高 中",@"初 中"]];
    screen_normalImg=@[@[@"screenShcool_混合学校未点击",@"screenShcool_女校未点击",@"screenShcool_男校未选中",@"screenShcool_无esl1"],@[@"screenShcool_走读未选中",@"screenShcool_寄宿未选中",@"screenShcool_高中未选中",@"screenShcool_初中未选中"]];
    screen_selectImg=@[@[@"screenShcool_混校",@"screenShcool_女校",@"screenShcool_男校",@"screenShcool_esl"],@[@"screenShcool_走读",@"screenShcool_寄宿",@"screenShcool_高中",@"screenShcool_初中"]];

    stateArr=[[NSMutableArray alloc] init];
    cityArr=[[NSMutableArray alloc] init];
}
-(void)changeFound
{
    [self headerRereshing];
}
-(void)initializeData
{
    _page=1;

    _ismixed=[[NSMutableString alloc] initWithString:@"1"];
    _ismale=[[NSMutableString alloc] initWithString:@"1"];
    _isfemale=[[NSMutableString alloc] initWithString:@"1"];
    _isday=[[NSMutableString alloc] initWithString:@"1"];
    _isboardind=[[NSMutableString alloc] initWithString:@"1"];
    _isjunior=[[NSMutableString alloc] initWithString:@"1"];
    _issenior=[[NSMutableString alloc] initWithString:@"1"];
    _isESL=[[NSMutableString alloc] initWithString:@"0"];
//    _is_identification=[[NSMutableString alloc] initWithString:@"0"];
    start=0;
    _city=[[NSMutableString alloc] initWithString:@""];
    _state=[[NSMutableString alloc] initWithString:@""];

}
#pragma mark-tableview

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_arrayData.count==indexPath.section)
    {
        return foundCellHeight;
    }
    return foundCellHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    SchoolDetailViewController *schoolView=[[SchoolDetailViewController alloc] init];

    NSInteger _section=indexPath.section;
    NSString *strKey  = [_arrayChar objectAtIndex:_section];
    NSMutableArray  *__arr=[[NSMutableArray alloc] initWithArray:[_dictPinyinAndChinese objectForKey:strKey]];
    NSInteger num=indexPath.row;
    foundModel *model=__arr[num];
    schoolView.data_dict=[[NSDictionary alloc] initWithObjectsAndKeys:model.cn_name,@"schoolName",model.sid,@"schoolID",nil];

    [self.navigationController pushViewController:schoolView animated:YES];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(tableView==_tableView)
    {
        NSInteger _count=_arrayChar.count;
        return _count;
    }else
    {
        //因为在searchDC上的_searchBar就是创建searchDC时，由第一个参数指定的_searchBar
        //        NSString *searchCon = _searchBar.text;
        //        NSLog(@"%@", searchCon);

        [_arrayResult removeAllObjects];
         NSString *title=_searchBar.text;

        //遍历数据源数据，找到与当前搜索内容相匹配的数据
//        NSLog(@"%@",_dictPinyinAndChinese);

            for (foundModel *model in _arrayData) {

                if(![title isEqualToString:@""])
                {

                    NSRange range1 = [[ChineseToPinyin pinyinFromChiniseString:model.cn_name] rangeOfString:[ChineseToPinyin pinyinFromChiniseString:title]];
                    NSRange range2 = [[ChineseToPinyin pinyinFromChiniseString:model.en_name] rangeOfString:[ChineseToPinyin pinyinFromChiniseString:title]];
//                    NSLog(@"1111%@",model.city);
                    NSString *titeeee=model.city;
                    NSRange range3 = [[ChineseToPinyin pinyinFromChiniseString:titeeee] rangeOfString:[ChineseToPinyin pinyinFromChiniseString:title]];

                        if((range1.location != NSNotFound)||(range2.location!=NSNotFound))
                        {
                            [_arrayResult addObject:model];
                        }else if(![model.city isEqualToString:@""])
                        {
                            if((range3.location!=NSNotFound))
                            {
                            [_arrayResult addObject:model];
                            }
                        }
                }
            }
//        NSLog(@"%@",_arrayResult);
        return 1;
    }

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView==_tableView)
    {
        if(_arrayData.count==section)
        {
            return 0;

        }
        NSString *strKey = [_arrayChar objectAtIndex:section];
        NSInteger _count=[[_dictPinyinAndChinese objectForKey:strKey] count];
        return _count;
        //    return _arrayData.count;

    }else
    {
//        NSLog(@"%d",_arrayResult.count);
        return _arrayResult.count;
    }


}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if(_arrayData.count==indexPath.section)
//    {
//        static NSString *cellid=@"cellid";
//        UITableViewCell *cell=[tableView dequeueReusableHeaderFooterViewWithIdentifier:cellid];
//        if(!cell)
//        {
//            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
//        }
//        cell.selectionStyle=UITableViewCellSelectionStyleNone;
//        return cell;
//    }

    static NSString *cellid=@"cell";
    FoundCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid ];
    if(!cell)
    {
        cell=[[FoundCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if(tableView==_tableView)
    {
        NSInteger _section=indexPath.section;
//        NSLog(@"%@",_arrayChar);
        NSString *strKey  = [_arrayChar objectAtIndex:_section];
        NSMutableArray  *__arr=[[NSMutableArray alloc] initWithArray:[_dictPinyinAndChinese objectForKey:strKey]];
        NSInteger num=indexPath.row;
        foundModel *model=__arr[num];


        cell.model =model;
        //    cell.model=_arrayData[indexPath.row];
    }else
    {
         cell.model = [_arrayResult objectAtIndex:indexPath.row];
    }
    return cell;
}




-(void)UIConfig
{
//    创建榜单
//    [self createTitleView];
//    创建tableview

//    创建搜索栏
//    [self createSearchBar];
//    创建搜索结果显示器
//    [self createSearchDisplayCtrl];
    [self createThreeBtn];
//    _tableView.contentOffset

}

-(void)createThreeBtn
{

    [self createBangdanBtn];
    [self createSearchBtn];
    [self createSousuoBtn];

}
-(void)createSousuoBtn
{
//    sousuoImg
    sousuoImg=[[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth-66*_Scale)/2.0f, ScreenHeight-200*_Scale, 66*_Scale, 66*_Scale)];
    sousuoImg.image=[UIImage imageNamed:@"found_bangdan_地图"];
    sousuoImg.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapActionSousuo:)];
    [sousuoImg addGestureRecognizer:tap];
    [self.view addSubview:sousuoImg];

}

-(void)createSearchBtn
{
    searchImg=[[UIImageView alloc] initWithFrame:CGRectMake(((ScreenWidth-66*_Scale)/2.0f)+50+66*_Scale,  ScreenHeight-200*_Scale, 66*_Scale, 66*_Scale)];
    searchImg.image=[UIImage imageNamed:@"found_bangdan_筛选"];
    searchImg.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapAction:)];
    [searchImg addGestureRecognizer:tap];
    [self.view addSubview:searchImg];

}
-(void)tapActionSousuo:(UIGestureRecognizer *)sender
{
//        NSDictionary *userInfo = [not userInfo];
//        NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
//        CGRect keyboardRect = [aValue CGRectValue];

    if((UIView *)[self.view viewWithTag:100]==nil)
    {
        //    创建背景
        UIView *backview=[self createBackView_max__2];
        searchview=[[UIView alloc] initWithFrame:CGRectMake(40*_Scale,-100*_Scale+( ScreenHeight-65*_Scale)/2.0f, ScreenWidth-80*_Scale, 70*_Scale)];
        searchview.backgroundColor=[UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
        [backview addSubview:searchview];
        screachText=[[UITextField alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(searchview.frame)-120*_Scale, CGRectGetHeight(searchview.frame))];
        screachText.textColor=[UIColor whiteColor];
        screachText.font=[regular getFont:13.0f];
        screachText.placeholder=@"城市或学校关键字 中英文都试试吧";
        [screachText setValue:[UIColor colorWithRed:1 green:220.0f/1 blue:1 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
        screachText.leftViewMode=UITextFieldViewModeAlways;
        screachText.leftView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, CGRectGetHeight(screachText.frame))];
        [searchview addSubview:screachText];
        UIButton *searchBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        searchBtn.frame=CGRectMake(CGRectGetMaxX(screachText.frame), 0, CGRectGetWidth(searchview.frame)-CGRectGetMaxX(screachText.frame), CGRectGetHeight(searchview.frame));
        searchBtn.backgroundColor=[UIColor colorWithRed:107.0f/255.0f green:203.0f/255.0f blue:202.0f/255.0f alpha:1];;
        [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
        [searchBtn.titleLabel setAttributedText:[regular createAttributeString:@"搜索" andFloat:@(5.0)]];
        searchBtn.titleLabel.font=[regular getFont:12.0f];
        [searchBtn addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [searchview addSubview:searchBtn];

    }
}
#pragma mark-对学校进行关键字搜索
-(void)searchAction:(UIButton *)btn
{
    NSString *title=screachText.text;
    if([title isEqualToString:@""])
    {
        [[ToolManager sharedManager] alertTitle_Simple:@"请输入关键字"];
    }else
    {
        souSuoViewController *sousuo= [[souSuoViewController alloc] init];
        sousuo.keystring=title;
        [self.navigationController pushViewController:sousuo animated:YES];

    }
//    query

}
-(void)createBangdanBtn
{
    bangdanImg=[[UIImageView alloc] initWithFrame:CGRectMake(((ScreenWidth-66*_Scale)/2.0f)-50- 66*_Scale, ScreenHeight-200*_Scale, 66*_Scale, 66*_Scale)];
    bangdanImg.image=[UIImage imageNamed:@"found_bangdan_排名"];
//    bangdanImg.backgroundColor=[UIColor redColor];
    bangdanImg.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapActionBangdan:)];
    [bangdanImg addGestureRecognizer:tap];
    [self.view addSubview:bangdanImg];
}
-(void)tapActionBangdan:(UIGestureRecognizer *)sender
{
//    [@[@"Prep Review",@"走读榜"],@[@"Prep Review",@"寄宿榜"],@[@"Business Insider",@"寄宿榜"],@[@"Niche",@"私立榜"]]
    if((UIView *)[self.view viewWithTag:100]==nil)
    {
        UIView *backview=[self createBackView_max__2];
        for (int i=0; i<4; i++) {
            UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
            [backview addSubview:btn];
            NSString *imagename=nil;
            if(i==0||i==1)
            {

                if(i==0)
                {
//                    bangdan_title=@"Niche 榜";

                    imagename=@"bangdan_niche";

                }else
                {
//                    bangdan_title=@"Business Insider 榜";
                imagename=@"bangdan_business_insider";
                }
            }else if(i==2)
            {

//                bangdan_title=@"Prep Review 榜";

                imagename=@"bangdan_prep_review";
            }else if(i==3)
            {

//                bangdan_title=@"Blue Ribbon 榜";
                imagename=@"bangdan_blueribbon";
            }

            [btn setBackgroundImage:[UIImage imageNamed:imagename] forState:UIControlStateNormal];
//            btn.backgroundColor=[UIColor redColor];

//            450 450
//            190  380
            CGFloat _width=380*_Scale;
            CGFloat _jiange=450*_Scale-_width;
            CGFloat _x_p=(ScreenWidth-450*_Scale)/2.0f;
            CGFloat _y_p=(ScreenHeight-450*_Scale)/2.0f;
            btn.frame=CGRectMake(_x_p+(i%2)*(_width/2.0f+_jiange), _y_p+(i/2)*(_width/2.0f+_jiange), 190*_Scale, 190*_Scale);

            btn.layer.masksToBounds=YES;
            btn.layer.cornerRadius=5.0f;

            [btn addTarget:self action:@selector(bangdanAction:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag=750+i;
        }
    }
}
-(UIView *)createBackView_max__2
{

    UIImageView  *backView=[[UIImageView alloc] initWithFrame:self.view.frame];
    backView.image=[UIImage imageNamed:@"蒙板"];
    backView.tag=100;
    //    backView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backview1Action__2)];
    backView.userInteractionEnabled=YES;
    [backView addGestureRecognizer:tap];
    [self.view addSubview:backView];
    return backView;

}
-(void)backview1Action__2
{

    [[self.view viewWithTag:100] removeFromSuperview];
}
-(void)bangdanAction:(UIButton *)btn
{

    bangdanViewController *bangdan=[[bangdanViewController alloc] init];

    if(btn.tag-750==2)
    {
        [self.navigationController pushViewController:[bangdanlistViewController new] animated:YES];
        

    }else
    {
        if(btn.tag-750==0)
        {

            bangdan.type=1;
        }else if(btn.tag-750==1)
        {

            bangdan.type=2;

            //        [self bangdanDataRequest:@"2"];
        }else if(btn.tag-750==3)
        {
            
            bangdan.type=4;
            
            //        [self bangdanDataRequest:@"4"];
        }
        
        [self.navigationController pushViewController:bangdan animated:YES];


    }
    UIView *backview=[self.view viewWithTag:100];
    [backview removeFromSuperview];
}

#pragma mark-筛选
-(void)tapAction:(UIGestureRecognizer *)sender
{

    if((UIView *)[self.view viewWithTag:100]==nil)
    {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:[[NSString alloc] initWithFormat:@"%@/v1/schools/pre_search",DNS] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *html = operation.responseString;
            NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
            //        进行解析以后的操作
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            if([[dict objectForKey:@"code"] integerValue]==1)
            {
                NSString *html = operation.responseString;
                NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
                //        进行解析以后的操作
                NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

                total_students_min=[[[dict objectForKey:@"data"] objectForKey:@"total_students_min"] longValue];
                ap_count_max=[[[dict objectForKey:@"data"] objectForKey:@"ap_count_max"] longValue];

                total_students_max=[[[dict objectForKey:@"data"] objectForKey:@"total_students_max"] longValue];
                ap_count_min=[[[dict objectForKey:@"data"] objectForKey:@"ap_count_min"] longValue];
                _now_state=1;

                //            UIView *view=(UIView *)[self.view viewWithTag:100];
                if((UIView *)[self.view viewWithTag:100]==nil)
                {
                    [self createBackView_max];
                    [self createchooseView];

                }


            }else
            {
                 [[ToolManager sharedManager] alertTitle_Simple:[dict objectForKey:@"message"]];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
        }];
    }
}
-(UIImageView *)createfanweiView1:(CGFloat )maxy
{

    UIImageView *backview=(UIImageView *)[self.view viewWithTag:200];

    UIImageView *_downview=[[UIImageView alloc] initWithFrame:CGRectMake(0, maxy+1*_Scale, CGRectGetWidth(backview.frame), 115*_Scale)];

    //    [_downview addGestureRecognizer:_tap];
    _downview.userInteractionEnabled=YES;
    [backview addSubview:_downview];
    _downview.backgroundColor=[UIColor whiteColor];

    //    CGFloat __width=(CGRectGetWidth(backview.frame)-90.0f*_Scale)/2.0f;

    //    for (int i=0; i<2; i++) {


    //        long _min=ap_count_min;
    //        long _max=ap_count_max;
     NMRangeSlider *slider = [[NMRangeSlider alloc] initWithFrame:CGRectMake(30*_Scale, ((CGRectGetHeight(_downview.frame)-25.)/2.0f)-15*_Scale, CGRectGetWidth(_downview.frame)-60*_Scale, 25.)];
    slider.minimumValue=ap_count_min;
    slider.maximumValue=ap_count_max;
    slider.lowerValue=ap_count_min;
    slider.upperValue=ap_count_max;
//    slider.backgroundColor=[UIColor grayColor];
    [_downview addSubview:slider];
    slider.tag=5001;
    [slider addTarget:self action:@selector(valueChangedForDoubleSlider:) forControlEvents:UIControlEventValueChanged];
    //        [self valueChangedForDoubleSlider:slider];
    UILabel *downlabel=[[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(slider.frame)-CGRectGetHeight(slider.frame)/2.0f, CGRectGetWidth(_downview.frame), CGRectGetHeight(_downview.frame)-CGRectGetMaxY(slider.frame)+CGRectGetHeight(slider.frame)/2.0f)];
//    downlabel.backgroundColor=[UIColor redColor];
    [_downview addSubview:downlabel];

    downlabel.textAlignment=1;
    downlabel.font=[regular getFont:11.0f];
    UITapGestureRecognizer *_tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fangantap)];
    [downlabel addGestureRecognizer:_tap];
    //        downlabel.userInteractionEnabled=YES;
    NSString *downstr=@"AP 课程数";
    downlabel.textColor=[UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1];
    downlabel.text=downstr;

    long __min=ap_count_min;
    long __max=ap_count_max;
    UILabel *_left=leftLabel2;
    UILabel *_right=rightLabel2;
    CGFloat _qishi=(CGRectGetMinX(slider.frame)+CGRectGetHeight(slider.frame)/2.0f);
    for (int j=0; j<2; j++) {
        long _str=j==0?__min:__max;
        UILabel *label=j==0?_left:_right;
//                    label.backgroundColor=[UIColor redColor];
        label.text=[[NSString alloc] initWithFormat:@"%ld",_str];
        label.frame=CGRectMake(_qishi+(CGRectGetWidth(_downview.frame)-2*_qishi-80*_Scale)*j,CGRectGetMinY(downlabel.frame), 80*_Scale, CGRectGetHeight(downlabel.frame));
        if(j==0)
        {
            label.textAlignment=0;
        }else
        {

            label.textAlignment=2;
        }
        label.font=[regular get_en_Font:12.0f];
        label.textColor=_define_blue_color;
        [_downview addSubview:label];
    }


    //    }
    return _downview;
}
#pragma mark-创建筛选view
-(void)createchooseView
{
    screen_btnArr=[[NSMutableArray alloc] init];
    [self createBackView_min];
    UIView *view1=[self createdownView];
    UIView *view2=[self createupView:CGRectGetMaxY(view1.frame)];
    UIImageView *view3=[self createfanweiView1:CGRectGetMaxY(view2.frame)];


    UIButton *subImg=[UIButton buttonWithType:UIButtonTypeCustom];

    UIImageView *backview=(UIImageView *)[self.view viewWithTag:200];

    subImg.frame=CGRectMake(0, CGRectGetMaxY(view3.frame)+1*_Scale, CGRectGetWidth(backview.frame), 60*_Scale);
    subImg.backgroundColor=[UIColor colorWithRed:107.0f/255.0f green:203.0f/255.0f blue:202.0f/255.0f alpha:1];
    [subImg setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [subImg setTitle:@"筛选" forState:UIControlStateNormal];
    [subImg.titleLabel setAttributedText:[regular createAttributeString:@"筛选" andFloat:@(7.0)]];
    subImg.titleLabel.font=[regular getFont:14.0f];
    [subImg addTarget:self action:@selector(subAction:) forControlEvents:UIControlEventTouchUpInside];
    [backview addSubview:subImg];

}
-(void)createBackView_min
{

    CGFloat _y_p=(ScreenHeight-485*_Scale)*(2.0f/5.0f);
    CGRect rect=CGRectMake(70*_Scale, _y_p-72*_Scale,ScreenWidth-70*_Scale*2, 698*_Scale);
    UIImageView  *backview1=[[UIImageView alloc] initWithFrame:rect];
    backview1.tag=200;
    backview1.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backview2Action)];
    [backview1 addGestureRecognizer:tap];
//    backview1.backgroundColor=[UIColor redColor];
    UIImageView *view=(UIImageView *)[self.view viewWithTag:100];
    [view addSubview:backview1];


}
-(void)backview2Action
{

}
-(void)backview1Action
{
    UIView *backview=nil;

    if(_now_state==1)
    {
        _now_state=0;
        [[self.view viewWithTag:100] removeFromSuperview];
    }else if(_now_state==2)
    {
        _now_state=1;
        backview=[self.view viewWithTag:201];
        ((UIView *)[self.view viewWithTag:200]).hidden=NO;
        [backview removeFromSuperview];

    }else if(_now_state==3)
    {
        _now_state=1;
        backview=[self.view viewWithTag:202];
        ((UIView *)[self.view viewWithTag:200]).hidden=NO;
        [backview removeFromSuperview];
    }


}
-(void)valueChangedForDoubleSlider:(NMRangeSlider *)slider
{
    NSLog(@"up=%f,down=%f",slider.upperValue,slider.lowerValue);
    if(slider.tag==5000)
    {

        leftLabel1.text=[[NSString alloc] initWithFormat:@"%.f",slider.lowerValue];
        rightLabel1.text=[[NSString alloc] initWithFormat:@"%.f",slider.upperValue];

    }else
    {
        leftLabel2.text=[[NSString alloc] initWithFormat:@"%.f",slider.lowerValue];
        rightLabel2.text=[[NSString alloc] initWithFormat:@"%.f",slider.upperValue];
        
    }
}
-(void)fangantap
{

}
-(UIView *)createupView:(CGFloat )__y_p
{
    UIImageView *backview=(UIImageView *)[self.view viewWithTag:200];
    UIView *upview=[[UIView alloc] initWithFrame:CGRectMake(0, __y_p, CGRectGetWidth(backview.frame), 150*_Scale)];
    upview.backgroundColor=[UIColor whiteColor];
    [backview addSubview:upview];

    UIView *middleView1=[[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(upview.frame), CGRectGetMaxY(upview.frame)+1*_Scale, CGRectGetWidth(upview.frame), 119*_Scale)];
    middleView1.backgroundColor=[UIColor whiteColor];
    [backview addSubview:middleView1];


    UIView *middleView=[[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(middleView1.frame), CGRectGetMaxY(middleView1.frame)+1*_Scale, CGRectGetWidth(middleView1.frame), 150*_Scale)];
    middleView.backgroundColor=[UIColor whiteColor];
    [backview addSubview:middleView];



    NMRangeSlider *slider = [[NMRangeSlider alloc] initWithFrame:CGRectMake(30*_Scale, ((CGRectGetHeight(middleView1.frame)-25.0)/2.0f)-15*_Scale, CGRectGetWidth(middleView1.frame)-60*_Scale, 25.) ];
    [middleView1 addSubview:slider];
    slider.tag=5000;
    slider.minimumValue=total_students_min;
    slider.maximumValue=total_students_max;
    slider.lowerValue=total_students_min;
    slider.upperValue=total_students_max;
    [slider addTarget:self action:@selector(valueChangedForDoubleSlider:) forControlEvents:UIControlEventValueChanged];
    [self valueChangedForDoubleSlider:slider];
    UILabel *downlabel=[[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(slider.frame)-CGRectGetHeight(slider.frame)/2.0f, CGRectGetWidth(middleView1.frame), CGRectGetHeight(middleView1.frame)-CGRectGetMaxY(slider.frame)+CGRectGetHeight(slider.frame)/2.0f)];
//    downlabel.backgroundColor=[UIColor blueColor];
    [middleView1 addSubview:downlabel];

    downlabel.textAlignment=1;
    downlabel.font=[regular getFont:11.0f];
    UITapGestureRecognizer *_tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fangantap)];
    [downlabel addGestureRecognizer:_tap];
    NSString *downstr=@"学生数";
    downlabel.textColor=[UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1];
    downlabel.text=downstr;

    long __min=total_students_min;
    long __max=total_students_max;
    UILabel *_left=leftLabel1;
    UILabel *_right=rightLabel1;

    CGFloat _qishi=(CGRectGetMinX(slider.frame)+CGRectGetHeight(slider.frame)/2.0f);
    for (int j=0; j<2; j++) {
        long _str=j==0?__min:__max;
        UILabel *label=j==0?_left:_right;
        label.text=[[NSString alloc] initWithFormat:@"%ld",_str];
        label.frame=CGRectMake(_qishi+(CGRectGetWidth(middleView1.frame)-2*_qishi-80*_Scale)*j,CGRectGetMinY(downlabel.frame), 80*_Scale, CGRectGetHeight(downlabel.frame));
//        label.backgroundColor=[UIColor redColor];
        if(j==0)
        {
            label.textAlignment=0;
        }else
        {
            label.textAlignment=2;
        }
        label.font=[regular get_en_Font:12.0f];
        label.textColor=_define_blue_color;
        [middleView1 addSubview:label];
    }
    



    CGFloat jiange=0;
    CGFloat _jiange1=0;
    CGFloat _jiange2=0;
    CGFloat _jiange3=0;
    CGFloat _radius=60*_Scale;
    CGFloat _y_p=0;
    CGFloat _x_p=0;
    for (int i=0; i<screen_titleArr.count; i++) {

        _jiange2=44*_Scale;
        _jiange3=70*_Scale;
        _jiange1=(CGRectGetWidth(upview.frame)-_radius*4-_jiange3-_jiange2*2)/2.0f;
        _x_p=_jiange1;
        _y_p=28*_Scale;

        for (int j=0; j<((NSArray *)screen_titleArr[i]).count; j++) {

            NSInteger middle_num=i==0?2:1;

            if(j==middle_num)
            {
                jiange=_jiange3;
            }else
            {
                jiange=_jiange2;
            }

            UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame=CGRectMake(_x_p, _y_p, _radius, _radius);
            [btn setImage:[UIImage imageNamed:((NSArray *)screen_normalImg[i])[j]] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:((NSArray *)screen_selectImg[i])[j]] forState:UIControlStateSelected];
            btn.tag=500+i*10+j;
            [btn addTarget:self  action:@selector(screenAction:) forControlEvents:UIControlEventTouchUpInside];
            [screen_btnArr addObject:btn];
            CGFloat __y_p=i==0?(CGRectGetHeight(upview.frame)-CGRectGetMaxY(btn.frame)-20*_Scale):(CGRectGetHeight(middleView.frame)-CGRectGetMaxY(btn.frame)-10*_Scale);

            UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(btn.frame)-5*_Scale, CGRectGetMaxY(btn.frame), CGRectGetWidth(btn.frame)+10*_Scale, __y_p)];
            label.text=((NSArray *)screen_titleArr[i])[j];
            label.textColor=[UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1];
            label.textAlignment=1;
            label.font=[regular getFont:12.0f];
            if(i==0)
            {
                [upview addSubview:btn];
                [upview addSubview:label];
            }else
            {
                [middleView addSubview:btn];
                [middleView addSubview:label];
            }

            if(i==0&&j==2)
            {
                UIView *view=[[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btn.frame)+jiange/2.0f, 10*_Scale, 1*_Scale, CGRectGetHeight(upview.frame)-20*_Scale)];
                view.backgroundColor=_define_backview_color;
                [upview addSubview:view];


            }else if(i==1&&j==1)
            {
                UIView *view=[[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btn.frame)+jiange/2.0f, 10*_Scale, 1*_Scale, CGRectGetHeight(middleView.frame)-20*_Scale)];
                view.backgroundColor=_define_backview_color;
                [middleView addSubview:view];
                
            }

            _x_p+=_radius+jiange;
        }
    }

    if(!_isfirst_choose)
    {
        [self setBtnState];

    }
    return middleView;
}

-(void)screenAction:(UIButton *)btn
{

    if(btn.selected)
    {
        btn.selected=NO;
    }else
    {
        btn.selected=YES;
    }

}
#pragma mark-设置btn的状态
-(void)setBtnState
{
//screen_btnArr
    NSArray *array=@[_ismixed,_isfemale,_ismale,_isESL,_isday,_isboardind,_issenior,_isjunior];
    for (int i=0; i<array.count; i++) {
        NSString *value=array[i];
        UIButton *btn=screen_btnArr[i];
        if([value isEqualToString:@"1"])
        {
            btn.selected=YES;
        }else
        {
            btn.selected=NO;
        }
    }

}

//-(void)deleteAction:(UIButton *)btn
//{
//    UIView *backview=nil;
//    if(btn.tag-10==0)
//    {
//        backview=[self.view viewWithTag:100];
//    }else if(btn.tag-10==1)
//    {
//        backview=[self.view viewWithTag:201];
//        ((UIView *)[self.view viewWithTag:200]).hidden=NO;
//    }else if(btn.tag-10==2)
//    {
//        backview=[self.view viewWithTag:202];
//        ((UIView *)[self.view viewWithTag:200]).hidden=NO;
//    }
//    [backview removeFromSuperview];
//}

-(UIView *)createdownView
{
    UIImageView *backview=(UIImageView *)[self.view viewWithTag:200];
    downView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(backview.frame), 100*_Scale)];
    downView.backgroundColor=[UIColor colorWithRed:65.0f/255.0f green:176.0f/255.0f blue:211.0f/255.0f alpha:1];
    [backview addSubview:downView];


    for (int i=0; i<2; i++) {

        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(chooseLoc:) forControlEvents:UIControlEventTouchUpInside];

        btn.frame=CGRectMake((CGRectGetWidth(backview.frame)-(18+220*2)*_Scale)/2+i*(220+18)*_Scale, (CGRectGetHeight(downView.frame)-46.0f*_Scale)/2.0f, 220*_Scale, 46*_Scale);
        btn.tag=400+i;
        [btn setBackgroundColor:[UIColor colorWithRed:116.0f/255.0f green:199.0f/255.0f blue:223.0f/255.0f alpha:1]];
        NSString *title=nil;
        if(i==0)
        {
            if([_state isEqualToString:@""])
            {
                title=@"所在州";
            }else
            {
                title=_state;
            }
        }else
        {
            if([_city isEqualToString:@""])
            {
                title=@"所在城市";
            }else
            {
                title=_city;
            }

        }

        btn.titleLabel.font=[regular getFont:11.0f];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitle:title forState:UIControlStateNormal];
        [downView addSubview:btn];
    }



    return downView;
}
-(void)chooseLoc:(UIButton *)btn
{

    if(btn.tag-400==0)
    {
//        所在州
        [self createChooseStateView];
        UIView *backView=[self.view viewWithTag:200];
        backView.hidden=YES;

    }else if(btn.tag-400==1)
    {
//        所在城市
        if([_state isEqualToString:@""])
        {
            [[ToolManager sharedManager] alertTitle_Simple:@"请先选择州"];
        }else
        {
            [self createChooseCityView];
            UIView *backView=[self.view viewWithTag:200];
            backView.hidden=YES;
        }

    }
}

-(void)createChooseCityView
{
    _now_state=3;
    UIImageView *backview=(UIImageView *)[self.view viewWithTag:100];
    CGFloat _y_p=(ScreenHeight-485*_Scale)*(2.0f/5.0f);
    backviewcity=[[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(backview.frame)-440*_Scale)/2.0f, _y_p, 440*_Scale, 600*_Scale)];
//    backview1.backgroundColor=[UIColor redColor];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backview2Action)];
    [backviewcity addGestureRecognizer:tap];
    backviewcity.userInteractionEnabled=YES;
    backviewcity.tag=202;
    [backview addSubview:backviewcity];

    upviewcity=[[UIView alloc] initWithFrame:CGRectMake(0, 29*_Scale, CGRectGetWidth(backviewcity.frame), 500*_Scale)];
    upviewcity.backgroundColor=[UIColor colorWithRed:65.0f/255.0f green:176.0f/255.0f blue:211.0f/255.0f alpha:1];
    [backviewcity addSubview:upviewcity];

//    all_state.frame=CGRectMake(0, CGRectGetHeight(backview1.frame)-50*_Scale, CGRectGetWidth(backview1.frame), 50*_Scale);
    all_city=[UIButton buttonWithType:UIButtonTypeCustom];
    all_city.frame=CGRectMake(0, CGRectGetMaxY(upviewcity.frame)+4, CGRectGetWidth(backviewcity.frame), 50*_Scale);
    all_city.backgroundColor=[UIColor colorWithRed:107.0f/255.0f green:203.0f/255.0f blue:202.0f/255.0f alpha:1];
    all_city.titleLabel.textAlignment=1;
    [all_city setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    all_city.titleLabel.font=[regular getFont:12.0f];
    [all_city setTitle:@"所有市" forState:UIControlStateNormal];
    [all_city.titleLabel setAttributedText:[regular createAttributeString:@"所有市" andFloat:@(5.0)]];
    [all_city addTarget:self action:@selector(cityAction:) forControlEvents:UIControlEventTouchUpInside];
    [backviewcity addSubview:all_city];
    all_city.hidden=YES;




    _scrollview_city=[[UIScrollView alloc] initWithFrame:CGRectMake(10*_Scale, 30*_Scale, CGRectGetWidth(upviewcity.frame)-20*_Scale, CGRectGetHeight(upviewcity.frame)-60*_Scale)];
    _scrollview_city.backgroundColor=[UIColor redColor];
    _scrollview_city.contentSize=CGSizeMake(CGRectGetWidth(upviewcity.frame)-20*_Scale, CGRectGetHeight(upviewcity.frame)-60*_Scale);
    _scrollview_city.backgroundColor=upviewcity.backgroundColor;
    _scrollview_city.showsVerticalScrollIndicator=YES;
    [upviewcity addSubview:_scrollview_city];
    NSLog(@"%@",state_id);


    //    [[ToolManager sharedManager] createProgress:@"加载中"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[[NSString alloc] initWithFormat:@"%@%@%@",DNS,@"/v1/us_states/",state_id] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",state_id);

        NSString *html = operation.responseString;
        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];

        if([[dict objectForKey:@"code"] intValue] ==1)
        {
            [cityArr removeAllObjects];
            [cityArr setArray:[dict objectForKey:@"data"]];

            cityArray=[[NSMutableArray alloc] init];
            for (NSDictionary *___dict in cityArr) {
                NSString *en_name=nil;
                NSDictionary *dict=nil;
                if([___dict objectForKey:@"en_name"]==[NSNull null])
                {
                    en_name=@"";
                }else
                {
                    en_name=[___dict objectForKey:@"en_name"];
                }
                if([___dict objectForKey:@"cn_name"]==[NSNull null])
                {
                    dict=[[NSDictionary alloc] initWithObjectsAndKeys:[___dict objectForKey:@"en_name"],@"en_name", @"",@"cn_name",nil];

                }else
                {
                    dict=[[NSDictionary alloc] initWithObjectsAndKeys:[___dict objectForKey:@"en_name"],@"en_name", [___dict objectForKey:@"cn_name"],@"cn_name",nil];
                }


                [cityArray addObject:dict];
            }

            _scrollview_city.contentSize=CGSizeMake(CGRectGetWidth(upviewcity.frame)-20*_Scale, cityArray.count*42*_Scale);
            CGFloat _backheight=0;
            if(cityArray.count>12)
            {
                _backheight= 12*42*_Scale+60*_Scale+54*_Scale;

            }else
            {
                _backheight= cityArray.count*42*_Scale+60*_Scale+54*_Scale;
            }
            [UIView beginAnimations:@"anmationName" context:nil];
            [UIView setAnimationDidStopSelector:@selector(anmationstop)];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
            //设置当前动画的代理
            [UIView setAnimationDelegate:self];
            backviewcity.frame=CGRectMake(CGRectGetMinX(backviewcity.frame), (ScreenHeight-_backheight)/2.0f, CGRectGetWidth(backviewcity.frame), _backheight);
            upviewcity.frame=CGRectMake(CGRectGetMinX(upviewcity.frame), 0, CGRectGetWidth(upviewcity.frame), _backheight-54*_Scale);

            _scrollview_city.frame=CGRectMake(30*_Scale, 30*_Scale, CGRectGetWidth(upviewcity.frame)-60*_Scale, CGRectGetHeight(upviewcity.frame)-60*_Scale);
            _scrollview_city.contentSize=CGSizeMake(CGRectGetWidth(upviewcity.frame)-60*_Scale, _scrollview_city.contentSize.height);
            
            [UIView commitAnimations];


        }else
        {
             [[ToolManager sharedManager] alertTitle_Simple:[dict objectForKey:@"message"]];
        }
        //        blockSuccess(dict);
        [[ToolManager sharedManager] removeProgress];


    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
    }];

}
-(void)anmationstop
{
    all_city.frame=CGRectMake(0, CGRectGetHeight(backviewcity.frame)-50*_Scale, CGRectGetWidth(backviewcity.frame), 50*_Scale);
    all_city.hidden=NO;

    CGFloat _width=(CGRectGetWidth(_scrollview_city.frame)-22*_Scale)/2.0f;
    for (int i=0; i<cityArray.count; i++) {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(0,i*42*_Scale,CGRectGetWidth(_scrollview_city.frame),42*_Scale);
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font=[regular get_en_Font:11.0f];
        btn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
        btn.titleLabel.textAlignment=0;
        [btn addTarget:self action:@selector(cityAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:[cityArray[i] objectForKey:@"en_name"] forState:UIControlStateNormal];
        [btn setBackgroundColor:upviewcity.backgroundColor];
        [_scrollview_city addSubview:btn];
        UILabel *label1=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, _width, CGRectGetHeight(btn.frame))];
//                label1.backgroundColor=upviewcity.backgroundColor;
        label1.backgroundColor=upviewcity.backgroundColor;
//                label1.backgroundColor=[UIColor redColor];
//                label1.text=[[NSString alloc] initWithFormat:@"%@",[stateArray[i] objectForKey:@"name"]];
        [label1 setAttributedText:[regular createAttributeString:[[NSString alloc] initWithFormat:@"%@",[cityArray[i] objectForKey:@"en_name"]] andFloat:@(1.0)]];
        label1.textColor=[UIColor whiteColor];
        label1.textAlignment=2;
        label1.font=[regular get_en_Font:12.0f];
        [btn addSubview:label1];
        UILabel *label3=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label1.frame), 0, 22*_Scale, CGRectGetHeight(label1.frame))];
        label3.backgroundColor=upviewcity.backgroundColor;

        [btn addSubview:label3];

        UILabel *label2=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label1.frame)+22*_Scale, 0, _width, CGRectGetHeight(btn.frame))];
        label2.backgroundColor=upviewcity.backgroundColor;

        [label2 setAttributedText:[regular createAttributeString:[[NSString alloc] initWithFormat:@"%@",[cityArray[i] objectForKey:@"cn_name"]] andFloat:@(1.0)]];
        label2.textColor=[UIColor whiteColor];
        label2.textAlignment=0;
        label2.font=[regular getFont:12.0f];
//                 label2.backgroundColor=[UIColor redColor];
        [btn addSubview:label2];
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(-5, CGRectGetHeight(btn.frame)-1*_Scale,CGRectGetWidth(btn.frame)+10 , 1*_Scale)];
        [btn addSubview:view];
        view.backgroundColor=[UIColor colorWithRed:134.0f/255.0f green:210.0f/255.0f blue:219.0f/255.0f alpha:1];
    }

}
-(void)cityAction:(UIButton *)btn
{
    if([btn.titleLabel.text isEqualToString:@"所有市"])
    {

        [_city setString:@""];
        UIButton *_btn=(UIButton *)[self.view viewWithTag:401];

        [city_id setString:@""];
        [_btn setTitle:@"所在市" forState:UIControlStateNormal];
        _now_state=1;
        [[self.view viewWithTag:202] removeFromSuperview];
        ((UIView *)[self.view viewWithTag:200]).hidden=NO;
    }else
    {


//        UIButton *_btn=(UIButton *)[self.view viewWithTag:401];
        for (NSDictionary *__dict in cityArr) {
            if(([__dict objectForKey:@"en_name"]!=[NSNull null])&&([__dict objectForKey:@"en_name"]!=nil))
            {
                if([[__dict objectForKey:@"en_name"]isEqualToString:btn.titleLabel.text])
                {
                    [city_id setString:[[NSString alloc] initWithFormat:@"%ld",[[__dict objectForKey:@"id"] longValue]]];
                    if([__dict objectForKey:@"cn_name"]!=[NSNull null])
                    {
                        [_city setString:[__dict objectForKey:@"cn_name"]];
                    }else
                    {
                        [_city setString:@""];
                    }

                    break;
                }
            }

        }
        [[self.view viewWithTag:401] removeFromSuperview];

//        [((UIButton *)[self.view viewWithTag:401]) setTitle:_city forState:UIControlStateNormal];
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(chooseLoc:) forControlEvents:UIControlEventTouchUpInside];

        btn.frame=CGRectMake((CGRectGetWidth(downView.frame)-(18+220*2)*_Scale)/2+1*(220+18)*_Scale, (CGRectGetHeight(downView.frame)-46.0f*_Scale)/2.0f, 220*_Scale, 46*_Scale);
        btn.tag=401;
        [btn setBackgroundColor:[UIColor colorWithRed:116.0f/255.0f green:199.0f/255.0f blue:223.0f/255.0f alpha:1]];
        btn.titleLabel.font=[regular getFont:11.0f];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitle:_city forState:UIControlStateNormal];
        [downView addSubview:btn];

        _now_state=1;
        [[self.view viewWithTag:202] removeFromSuperview];
        ((UIView *)[self.view viewWithTag:200]).hidden=NO;

    }

}
-(void)createChooseStateView
{
    _now_state=2;
    UIImageView *backview=(UIImageView*)[self.view viewWithTag:100];
    CGFloat _y_p=(ScreenHeight-485*_Scale)*(2.0f/5.0f);
    //    180  310
    UIImageView *backview1=[[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(backview.frame)-360*_Scale)/2.0f, _y_p, 360*_Scale, 600*_Scale)];
    //    backview1.backgroundColor=[UIColor redColor];
    backview1.userInteractionEnabled=YES;

    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backview2Action)];
    [backview1 addGestureRecognizer:tap];
    //    backview1.backgroundColor=[UIColor blueColor];
    backview1.tag=201;
    [backview addSubview:backview1];

    UIView *upview=[[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(backview1.frame), 544*_Scale)];
    upview.backgroundColor=[UIColor colorWithRed:65.0f/255.0f green:176.0f/255.0f blue:211.0f/255.0f alpha:1];
    [backview1 addSubview:upview];

    UIButton *all_state=[UIButton buttonWithType:UIButtonTypeCustom];
    all_state.frame=CGRectMake(0, CGRectGetHeight(backview1.frame)-50*_Scale, CGRectGetWidth(backview1.frame), 50*_Scale);
    all_state.backgroundColor=[UIColor colorWithRed:107.0f/255.0f green:203.0f/255.0f blue:202.0f/255.0f alpha:1];;
    all_state.titleLabel.textAlignment=1;
    [all_state setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    all_state.titleLabel.font=[regular getFont:12.0f];
    [all_state setTitle:@"所有州" forState:UIControlStateNormal];
    [all_state.titleLabel setAttributedText:[regular createAttributeString:@"所有州" andFloat:@(5.0)]];

    [all_state addTarget:self action:@selector(stateAction:) forControlEvents:UIControlEventTouchUpInside];
    [backview1 addSubview:all_state];



    UIScrollView *_scrollview=[[UIScrollView alloc] initWithFrame:CGRectMake(10*_Scale, 30*_Scale, CGRectGetWidth(upview.frame)-20*_Scale, CGRectGetHeight(upview.frame)-60*_Scale)];
    _scrollview.backgroundColor=upview.backgroundColor;
    _scrollview.showsVerticalScrollIndicator=YES;
    _scrollview.contentSize=CGSizeMake(_scrollview.frame.size.width, _scrollview.frame.size.height);
    [upview addSubview:_scrollview];



    //    [[ToolManager sharedManager] createProgress:@"加载中"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[[NSString alloc] initWithFormat:@"%@%@",DNS,@"/v1/us_states"] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSString *html = operation.responseString;
        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];

        if([[dict objectForKey:@"code"] intValue] ==1)
        {
            //数据呈现
            [stateArr removeAllObjects];
            [stateArr setArray:[dict objectForKey:@"data"]];
            //            stateArr=[dict objectForKey:@"data"];

            NSMutableArray *stateArray=[[NSMutableArray alloc] init];
            for (NSDictionary *___dict in stateArr) {
                NSString *en_name=nil;
                NSDictionary *dict=nil;
                if([___dict objectForKey:@"en_name"]!=[NSNull null])
                {

                    en_name=[___dict objectForKey:@"en_name"];


                }else
                {
                    en_name=@"";
                }
                dict=[[NSDictionary alloc] initWithObjectsAndKeys:[___dict objectForKey:@"en_name"],@"name", [___dict objectForKey:@"short_name"],@"short_name",[___dict objectForKey:@"cn_name"],@"cn_name",nil];
                [stateArray addObject:dict];
            }
            _scrollview.contentSize=CGSizeMake(CGRectGetWidth(_scrollview.frame), stateArray.count*42*_Scale);

            for (int i=0; i<stateArray.count; i++) {
                UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame=CGRectMake(20*_Scale,i*42*_Scale,CGRectGetWidth(_scrollview.frame)-40*_Scale,42*_Scale);

                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                btn.titleLabel.font=[regular getFont:11.0f];
                btn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
                [btn addTarget:self action:@selector(stateAction:) forControlEvents:UIControlEventTouchUpInside];
                [btn setTitle:[stateArray[i] objectForKey:@"name"] forState:UIControlStateNormal];
                btn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
                [btn setBackgroundColor:upview.backgroundColor];
//                btn.backgroundColor=[UIColor blueColor];
//                UILabel *backv=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(btn.frame), CGRectGetHeight(btn.frame))];
//                backv.userInteractionEnabled=YES;
//                backv.backgroundColor=upview.backgroundColor;
//                [btn addSubview:backv];
                UILabel *label1=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 90*_Scale, CGRectGetHeight(btn.frame))];
                label1.backgroundColor=upview.backgroundColor;
//                label1.text=[stateArray[i] objectForKey:@"short_name"];
                [label1 setAttributedText:[regular createAttributeString:[stateArray[i] objectForKey:@"short_name"] andFloat:@(1.0)]];
                label1.textColor=[UIColor whiteColor];
                label1.textAlignment=2;
                label1.font=[regular get_en_Font:12.0f];
//                label1.backgroundColor=[UIColor redColor];
                [btn addSubview:label1];


                UILabel *label3=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label1.frame), 0, 22*_Scale, CGRectGetHeight(label1.frame))];
                label3.backgroundColor=upview.backgroundColor;
                [btn addSubview:label3];


                UILabel *label2=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label1.frame)+22*_Scale, 0,CGRectGetWidth(btn.frame)-CGRectGetMaxX(label1.frame)-22*_Scale, CGRectGetHeight(btn.frame))];
                label2.backgroundColor=upview.backgroundColor;
//                label2.text=[stateArray[i] objectForKey:@"cn_name"];
                [label2 setAttributedText:[regular createAttributeString:[stateArray[i] objectForKey:@"cn_name"] andFloat:@(1.0)]];
                label2.textColor=[UIColor whiteColor];
                label2.textAlignment=0;
                label2.font=[regular getFont:12.0f];
                [btn addSubview:label2];
//                label2.backgroundColor=[UIColor redColor];



                //                btn.tag=200+i;
                [_scrollview addSubview:btn];
                UIView *view=[[UIView alloc] initWithFrame:CGRectMake(-5, CGRectGetHeight(btn.frame)-1*_Scale,CGRectGetWidth(btn.frame)+10 , 1*_Scale)];
                [btn addSubview:view];
                view.backgroundColor=[UIColor colorWithRed:134.0f/255.0f green:210.0f/255.0f blue:219.0f/255.0f alpha:1];

            }
        }else
        {
             [[ToolManager sharedManager] alertTitle_Simple:[dict objectForKey:@"message"]];
        }
        //        blockSuccess(dict);
        [[ToolManager sharedManager] removeProgress];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
    }];
    

}
-(void)stateAction:(UIButton *)btn
{
    if([btn.titleLabel.text isEqualToString:@"所有州"])
    {

        [_state setString:@""];
        UIButton *_btn=(UIButton *)[self.view viewWithTag:400];
        [_btn setTitle:@"所在州" forState:UIControlStateNormal];
        UIButton *_btn1=(UIButton *)[self.view viewWithTag:401];
        [_btn1 setTitle:@"所在城市" forState:UIControlStateNormal];
        [_city setString:@""];
        _now_state=1;
        [[self.view viewWithTag:201] removeFromSuperview];
        ((UIView *)[self.view viewWithTag:200]).hidden=NO;


    }else
    {
        if(![btn.titleLabel.text isEqualToString:_state]&&![_state isEqualToString:@""])
        {
            UIButton *_btn1=(UIButton *)[self.view viewWithTag:401];
            [_btn1 setTitle:@"所在城市" forState:UIControlStateNormal];
            [_city setString:@""];
            [city_id setString:@""];
        }


        for (NSDictionary *_dict in stateArr) {
            if([[_dict objectForKey:@"en_name"]isEqualToString:btn.titleLabel.text])
            {
                if([_dict objectForKey:@"id"]!=[NSNull null])
                {
                    [state_id setString:[[NSString alloc] initWithFormat:@"%d",[[_dict objectForKey:@"id"] intValue]]];
                    [_state setString:[_dict objectForKey:@"cn_name"]];
                    break;
                }

            }
        }
        [[self.view viewWithTag:400] removeFromSuperview];

        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(chooseLoc:) forControlEvents:UIControlEventTouchUpInside];

        btn.frame=CGRectMake((CGRectGetWidth(downView.frame)-(18+220*2)*_Scale)/2, (CGRectGetHeight(downView.frame)-46.0f*_Scale)/2.0f, 220*_Scale, 46*_Scale);
        btn.tag=400;
        [btn setBackgroundColor:[UIColor colorWithRed:116.0f/255.0f green:199.0f/255.0f blue:223.0f/255.0f alpha:1]];
        btn.titleLabel.font=[regular getFont:11.0f];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitle:_state forState:UIControlStateNormal];
        [downView addSubview:btn];

        _now_state=1;
        [[self.view viewWithTag:201] removeFromSuperview];
        ((UIView *)[self.view viewWithTag:200]).hidden=NO;


    }
   }
#pragma mark-筛选
-(void)subAction:(UIButton *)btn
{
    [_arrayData removeAllObjects];
    //    selected
    for (UIButton *_btn in titleBtnArray) {
        _btn.selected=NO;
    }
    huadong.hidden=YES;


    if(_isfirst_choose)
    {
        _isfirst_choose=NO;
    }

//    [self headerRereshing];
    count=0;
    start=0;
    _page=1;

    NSArray *arr1=@[_ismixed,_isfemale,_ismale,_isESL,_isday,_isboardind,_issenior,_isjunior];
    for (int i=0; i<screen_btnArr.count; i++) {

        UIButton *btn=nil;

        btn=(UIButton *)screen_btnArr[i];
        if(!btn.selected)
        {
            [(NSMutableString *)arr1[i] setString:@"0"];
        }else
        {
            [(NSMutableString *)arr1[i] setString:@"1"];
        }
    }
     NSMutableDictionary *_dict=[self getParameters];
    NSLog(@"%@",_dict);
    NSArray *keyarr=[_dict allKeys];
    if(keyarr.count>2)
    {
        shaiXuanViewController *shaixuan=[[shaiXuanViewController alloc] init];
        shaixuan.data_dict=_dict;
        [self.navigationController pushViewController:shaixuan animated:YES];
//        [[self.view viewWithTag:100] removeFromSuperview];

    }else
    {
        [[ToolManager sharedManager] alertTitle_Simple:@"请输入筛选条件"];
    }


//    [self requestData];
}
-(UIView *)createBackView_max
{
    UIImageView  *backView=[[UIImageView alloc] initWithFrame:self.view.frame];
    backView.image=[UIImage imageNamed:@"蒙板"];
    backView.tag=100;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backview1Action)];
    backView.userInteractionEnabled=YES;
    [backView addGestureRecognizer:tap];
    [self.view addSubview:backView];
    return backView;

}

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

- (void)createSearchBar
{

    _searchBar = [[UISearchBar alloc] init];
    _searchBar.backgroundColor=[UIColor clearColor];
    _searchBar.frame = CGRectMake(0, 0, ScreenWidth, 44);
//    _searchBar.searc
        [_searchBar setSearchFieldBackgroundImage:[UIImage imageNamed:@"found_school_所在州所在城市筛选框"] forState:UIControlStateNormal];
    _searchBar.backgroundImage=[UIImage imageNamed:@"hehehehe"];


//    [_searchBar setImage:[UIImage imageNamed:@"found_school_所在州所在城市筛选框"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
//     UITextField *searchField = [_searchBar valueForKey:@"_searchField"];
//     searchField.textColor = [UIColor blackColor];
//    [searchField setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
//    [[_searchBar.subviews objectAtIndex:0]removeFromSuperview];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"found_school_2_选中底图.png"]];
    imageView.frame=_searchBar.frame;
    _searchBar.placeholder=@"输入城市或者学校名字 试试吧";
    UITextField *searchField = [_searchBar valueForKey:@"_searchField"];

    searchField.font=(kIOSVersions>=9.0? [UIFont systemFontOfSize:11.0f]:[UIFont fontWithName:@"Helvetica Neue" size:11.0f]);
    searchField.leftView.alpha=0.5;

    [searchField setValue:[UIColor colorWithRed:220.0f/255.0f green:220.0f/255.0f blue:220.0f/255.0f alpha:1] forKeyPath:@"_placeholderLabel.textColor"];

//    [[_searchBar.subviews objectAtIndex:0]removeFromSuperview];

//_searchBar.textInputMode
//    _searchBar.
//     [_searchBar setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
//[_searchBar set]
    [_searchBar insertSubview:imageView atIndex:1];


    //    _searchBar.delegate = self;
    _searchBar.searchBarStyle=UISearchBarStyleDefault;
    //设置搜索栏取消按钮是否显示
//        _searchBar.showsCancelButton = YES;
    //将搜索栏添加到视图控制器的主视图上
    //效果是,搜索栏不会随着表视图的滚动而滚动
    //    [self.view addSubview:_searchBar];
    //将搜索栏添加到表视图的表头视图上
    //效果是,搜索栏会随着表视图的滚动而滚动
    _tableView.tableHeaderView = _searchBar;

}

#pragma mark-检测当前偏移量

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{


    if(_appear&&scrollView==_tableView)
    {
        _start_y=scrollView.contentOffset.y;
        NSLog(@"滚动视图即将开始拖动=%f",scrollView.contentOffset.y);
        _Dragging=YES;
    }


}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    if(_Dragging)
    {
        if(_appear&&scrollView==_tableView)
        {
            NSLog(@"滚动视图正在滚动=%f",scrollView.contentOffset.y);
            if(_start_y<20&&scrollView.contentOffset.y>20)
            {
                [UIView beginAnimations:@"anmationAppear" context:nil];
                [UIView setAnimationDuration:0.2];
                [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
                [UIView setAnimationDelegate:self];
                self.navigationController.navigationBar.frame=CGRectMake(0, -24, [[UIScreen mainScreen]bounds].size.width, 44);
                self.navigationItem.titleView.alpha=0;
                [UIView commitAnimations];
                _nav_donghua=NO;
            }else
            {
                if(scrollView.contentOffset.y<20)
                {
                    [UIView beginAnimations:@"anmationAppear" context:nil];
                    [UIView setAnimationDuration:0.2];
                    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
                    [UIView setAnimationDelegate:self];
                    self.navigationController.navigationBar.frame=CGRectMake(0, 20, [[UIScreen mainScreen]bounds].size.width, 44);
                    self.navigationItem.titleView.alpha=1;
                    [UIView commitAnimations];
                    _nav_donghua=NO;
                }else

                {
                    if(!_nav_donghua&&((scrollView.contentOffset.y-_start_y)>(ScreenHeight/4.0f)))
                    {
                        //        动画显示
                        [UIView beginAnimations:@"anmationAppear" context:nil];
                        [UIView setAnimationDuration:0.2];
                        [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
                        [UIView setAnimationDelegate:self];
                        self.navigationController.navigationBar.frame=CGRectMake(0, -24, [[UIScreen mainScreen]bounds].size.width, 44);
                        self.navigationItem.titleView.alpha=0;
                        [UIView commitAnimations];

                        _nav_donghua=YES;
                    }else if(_nav_donghua&&((_start_y-scrollView.contentOffset.y)>(ScreenHeight/4.0f)))
                    {
                        [UIView beginAnimations:@"anmationAppear" context:nil];
                        [UIView setAnimationDuration:0.2];
                        [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
                        [UIView setAnimationDelegate:self];
                        self.navigationController.navigationBar.frame=CGRectMake(0, 20, [[UIScreen mainScreen]bounds].size.width, 44);
                        self.navigationItem.titleView.alpha=1;
                        [UIView commitAnimations];
                        _nav_donghua=NO;
                        
                    }
                }
                
                
            }
            
        }


    }


}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{

    if(_appear&&scrollView==_tableView)
    {
        NSLog(@"滚动视图结束减速=%f",scrollView.contentOffset.y);
        _Dragging=NO;
    }
}



-(void)createTableView
{
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];

    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.showsVerticalScrollIndicator=YES;
     _tableView.backgroundColor=_define_backview_color;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    _tableView.sectionIndexColor = [UIColor colorWithRed:204.0f/255.0f green:204.0f/255.0f blue:204.0f/255.0f alpha:1];
    [self.view addSubview:_tableView];
//    _tableView.userInteractionEnabled=YES;
    [self setupRefresh];
}

-(void)titleBtnAction:(UIButton *)btn
{
    NSInteger __tag=20;
    for (UIButton *_btn in titleBtnArray) {
        if(_btn.selected==YES)
        {
            __tag=_btn.tag;
            break;
        }
    }
    if(btn.tag==__tag)
    {

        btn.selected=NO;
        huadong.hidden=YES;
//        [self requestData];
        [self headerRereshing];
    }else
    {
        if(huadong.hidden)
        {

            huadong.frame=CGRectMake(CGRectGetMinX(btn.frame), CGRectGetMinY(btn.frame), CGRectGetWidth(btn.frame), CGRectGetHeight(huadong.frame));
            huadong.hidden=NO;
            for (UIButton *_btn in titleBtnArray) {
                _btn.selected=NO;
            }
            btn.selected=YES;

        }else
        {
            //    selected
            for (UIButton *_btn in titleBtnArray) {
                _btn.selected=NO;
            }
            btn.selected=YES;
            //    选中动画
            [UIView beginAnimations:@"anmation" context:nil];
            [UIView setAnimationDuration:0.5f];
            [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
            [UIView setAnimationDelegate:self];
            huadong.frame=CGRectMake(btn.tag*CGRectGetWidth(huadong.frame), 0, CGRectGetWidth(huadong.frame), CGRectGetHeight(huadong.frame));
            [UIView commitAnimations];
            //    选中后的处理(刷新)

        }
        //    寄宿榜前30
        //    key=&ismixed=1&ismale=1&isfemale=1&isday_junior=1&isday_senior=1&isboarding_junior=1&isboarding_senior=1&min_price=0&max_price=9999999999&min_ap=0&max_ap=999999&min_total=0&max_total=99999999&isESL=0&c1=0&c2=1&c3=0&start=0&show=100
        //    走读榜前30
        //    key=&ismixed=1&ismale=1&isfemale=1&isday_junior=1&isday_senior=1&isboarding_junior=1&isboarding_senior=1&min_price=0&max_price=9999999999&min_ap=0&max_ap=999999&min_total=0&max_total=99999999&isESL=0&c1=0&c2=0&c3=1&start=0&show=100
        NSString *zoudu=@"key=&ismixed=1&ismale=1&isfemale=1&isday_junior=1&isday_senior=1&isboarding_junior=1&isboarding_senior=1&min_price=0&max_price=9999999999&min_ap=0&max_ap=999999&min_total=0&max_total=99999999&isESL=0&c1=0&c2=0&c3=1&start=0&show=10";
        NSString *jisu=@"key=&ismixed=1&ismale=1&isfemale=1&isday_junior=1&isday_senior=1&isboarding_junior=1&isboarding_senior=1&min_price=0&max_price=9999999999&min_ap=0&max_ap=999999&min_total=0&max_total=99999999&isESL=0&c1=0&c2=1&c3=0&start=0&show=10";
        if(btn.tag==1)
        {
            [self bangdanDataRequest:zoudu];
        }else
        {
            [self bangdanDataRequest:jisu];
        }

    }


}
-(void)bangdanDataRequest:(NSString *)type
{

//    [[ToolManager sharedManager] createProgress:@"加载中"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *_parameters=nil;
    if([type isEqualToString:@"1"])
    {
        _parameters=@{@"mark":@"day"};
    }else if([type isEqualToString:@"2"])
    {
        _parameters=@{@"mark":@"boarding"};
    }
    else if([type isEqualToString:@"3"])
    {
        _parameters=@{@"mark":@"insider"};
    }else if([type isEqualToString:@"4"])
    {
        _parameters=@{@"mark":@"niche"};
    }
    [manager GET:[[NSString alloc] initWithFormat:@"%@%@",DNS,@"/v1/rank_schools"] parameters:_parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSString *html = operation.responseString;
        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
        [_arrayData removeAllObjects];
        blockSuccess(dict);
        [[ToolManager sharedManager] removeProgress];


    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
    }];



}
-(void)preUIConfig
{
    //设置导航栏颜色
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:70.0f/255.0f green:195.0f/255.0f blue:247.0f/255.0f alpha:1];
    //    设置背景颜色
    self.view.backgroundColor=_define_backview_color;
    //    添加左按钮

    self.navigationItem.titleView=[regular returnNavView:@"发现美校" withmaxwidth:230];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];
    _appear=YES;
    [[CustomTabbarController sharedManager] tabbarAppear];
    [MobClick beginLogPageView:@"FoundViewController"];

}
-(void)viewWillDisappear:(BOOL)animated
{
    _appear=NO;
    _Dragging=NO;

    [super viewWillDisappear:animated];

    self.navigationController.navigationBar.frame=CGRectMake(0, 20, [[UIScreen mainScreen]bounds].size.width, 44);
    self.navigationItem.titleView.alpha=1;
    _nav_donghua=NO;

    [MobClick endLogPageView:@"FoundViewController"];
}

@end
