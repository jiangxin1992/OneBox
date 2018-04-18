//
//  FoundViewController.m
//  OneBox
//
//  Created by 谢江新 on 15/12/7.
//  Copyright © 2015年 谢江新. All rights reserved.
//
#import "ArticleDetailViewController.h"

#import "MJRefresh.h"

#import "ArticleColViewController.h"
#import "CustomTabbarController.h"

#import "ArticleCell.h"

#import "ArticleModel.h"

#define foundCellHeight 360*_Scale

@interface ArticleColViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic ,strong) UIButton *leftBarbtn;
@property (nonatomic ,assign) NSInteger Record_cell_num;
@property (nonatomic ,assign) CGFloat min_offset;
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) UIView *nofollow;

//    开始
@property (nonatomic ,assign) BOOL isfirst_choose;//是否是第一次打开筛选视图
//    滑动image
@property (nonatomic ,assign) BOOL nav_donghua;//记录导航栏是否滑动上去（是否消失）
@property (nonatomic ,assign) CGFloat start_y;//表示tableview开始拖动时候的起始位置
@property (nonatomic ,assign) BOOL Dragging;//表示tableview开始拖动，记录拖动的开始
@property (nonatomic ,assign) BOOL appear;
@property (nonatomic ,assign) NSInteger page;//记录当前page
@property (nonatomic ,strong) NSMutableArray *arrayData;//存放页面的数据

@property (nonatomic ,assign) BOOL bKeyBoardHide;//判断键盘显示状态

@end

@implementation ArticleColViewController
{
    void (^blockSuccess)(NSDictionary *dict);//主界面数据请求成功后调用
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNotication];
    [self SomePrepare];
    [self UIConfig];
    [self setupRefresh];
    [self createBlock];
}
#pragma mark-----------------Notications----------------
//创建该界面中的Notication
-(void)createNotication
{
//    将导航栏的位置还原（应对 app推出后台时候导航栏异常情况）
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(navBarReset) name:@"navBarReset" object:nil];
//    添加键盘监控,在键盘消失或者出现时候会调用，来改变bKeyBoardHide的值，以此来判断当前键盘是否为弹出状态
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

}
//键盘消失时候调用
-(void)keyboardWillHide:(NSNotification *)notification
{
    self.bKeyBoardHide = YES;
}
//键盘出现时候调用
-(void)keyboardWillShow:(NSNotification *)notification
{
    self.bKeyBoardHide = NO;
}

#pragma mark*导航栏重置
-(void)navBarReset
{
//将导航栏位置复原
    self.navigationController.navigationBar.frame=CGRectMake(0, kStatusBarHeight, [[UIScreen mainScreen]bounds].size.width, kNavigationBarHeight);
//    导航栏标题透明度还原成1，还原_Dragging，_nav_donghua
    self.navigationItem.titleView.alpha=1;
    _leftBarbtn.alpha=1;
    _Dragging=NO;
    _nav_donghua=NO;
}
#pragma mark-----------------SomePrepare----------------
-(void)SomePrepare
{
    [self PrepareData];//一些数据的初始化
    [self PrepareUI];//一些初始化UI的准备
    WeakSelf(ws);
    changeBlock=^(NSInteger row)
    {
        JXLOG(@"%@",ws.arrayData);
        ((ArticleModel *)[ws.arrayData objectAtIndex:row]).isapp=YES;
    };
    alterBlock=^(ArticleModel *model,BOOL isdelete)
    {
        JXLOG(@"111");
        if(isdelete)
        {
//            删除
            BOOL _in_here=NO;
            NSInteger _index=0;

            for (int i=0; i<ws.arrayData.count; i++) {
                ArticleModel *_model=[ws.arrayData objectAtIndex:i];
                if([_model.m_id isEqualToString:model.m_id])
                {
                    _in_here=YES;
                    _index=i;
                }
            }
            if(_in_here)
            {
                [ws.arrayData removeObjectAtIndex:_index];
            }

        }else
        {
//            增加
            [ws.arrayData insertObject:model atIndex:0];
        }
        [ws.tableView reloadData];

    };
}
-(void)PrepareData
{
    _Record_cell_num=0;
    _page=1;
    self.bKeyBoardHide=YES;//开始时候键盘为隐藏状态
    _appear=YES;
    _Dragging=NO;
    _nav_donghua=NO;
    _start_y=0;
    _isfirst_choose=YES;
    _arrayData=[[NSMutableArray alloc] init];
}
-(void)popviewAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)PrepareUI
{
    _leftBarbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [_leftBarbtn setImage:[UIImage imageNamed:@"返回箭头"] forState:UIControlStateNormal];
    _leftBarbtn.frame=CGRectMake(0, 0, 22, 22);
    [_leftBarbtn addTarget:self action:@selector(popviewAction) forControlEvents:UIControlEventTouchUpInside];
    [_leftBarbtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    UIBarButtonItem *_btn=[[UIBarButtonItem alloc] initWithCustomView:_leftBarbtn];
    self.navigationItem.leftBarButtonItem=_btn;

//    设置导航栏颜色
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:70.0f/255.0f green:195.0f/255.0f blue:247.0f/255.0f alpha:1];
//    设置背景颜色
    self.view.backgroundColor=_define_backview_color;
//    添加标题

    self.navigationItem.titleView=[regular returnNavView:@"收藏的文章"  withmaxwidth:200];

}
#pragma mark-----------------UIConfig----------------
-(void)UIConfig
{
//    创建tableview
    [self createTableView];
    [self CreateNofollowerView];
}
-(void)CreateNofollowerView
{
    self.nofollow=[[UIView alloc] initWithFrame:CGRectMake(0,(ScreenHeight-330*_Scale)/2.0f-kTabBarHeight-70*_Scale, ScreenWidth, 330*_Scale)];
    [self.view addSubview:_nofollow];

    UIImageView *imageview=[[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(_nofollow.frame)-105*_Scale)/2.0f, 105*_Scale, 105*_Scale, 105*_Scale)];
    imageview.image=[UIImage imageNamed:@"article_no_文章"];
    [_nofollow addSubview:imageview];

    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageview.frame), CGRectGetWidth(_nofollow.frame), CGRectGetHeight(_nofollow.frame)-CGRectGetMaxY(imageview.frame))];
    [_nofollow addSubview:label];
    label.font=[regular getFont:13.0f];
        [label setAttributedText:[regular createAttributeString:@"还没有收藏哦" andFloat:@(3.0)]];
    label.textAlignment=1;
    label.textColor=[UIColor colorWithRed:150.0f/255.0f green:150.0f/255.0f  blue:150.0f/255.0f  alpha:1];
    _nofollow.hidden=YES;
}
#pragma mark*创建TableView
-(void)createTableView
{
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight+64) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
//    水平方向滑条显示
    _tableView.showsVerticalScrollIndicator=YES;
    _tableView.backgroundColor=_define_backview_color;
//    消除分割线
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    _min_offset=_tableView.contentOffset.y;
    
}

//创建搜索view
-(UITextField *)createSearchView
{
    UITextField *_textfiled=[[UITextField alloc] initWithFrame:CGRectMake((ScreenWidth-460*_Scale)/2.0f, 190*_Scale, 460*_Scale, 72*_Scale)];
    _textfiled.backgroundColor=[UIColor whiteColor];
    _textfiled.alpha=0.9;
    _textfiled.placeholder=@"试试学校或城市名称吧";
    _textfiled.layer.masksToBounds=YES;
    _textfiled.layer.cornerRadius=CGRectGetHeight(_textfiled.frame)/2.0f;
    _textfiled.textColor=[UIColor colorWithRed:160.0f/255.0f green:160.0f/255.0f blue:160.0f/255.0f alpha:1];
    _textfiled.textAlignment=0;
    _textfiled.delegate=self;
    _textfiled.font=[regular getFont:13.0f];
    //    设置placeholder字体颜色
    [_textfiled setValue:[UIColor colorWithRed:160.0f/255.0f green:160.0f/255.0f blue:160.0f/255.0f alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
//    clear类型
     _textfiled.clearButtonMode=UITextFieldViewModeWhileEditing;
    _textfiled.leftViewMode=UITextFieldViewModeAlways;
//    设置return类型
    _textfiled.returnKeyType=UIReturnKeySearch;

    UIView *leftview=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 77*_Scale, CGRectGetHeight(_textfiled.frame))];
    _textfiled.leftView=leftview;
    UIImageView *img=[[UIImageView alloc] initWithFrame:CGRectMake(20*_Scale, (CGRectGetHeight(leftview.frame)-34*_Scale)/2.0f, 34*_Scale, 34*_Scale)];
    img.image=[UIImage imageNamed:@"found_newsearch"];
    [leftview addSubview:img];
    return _textfiled;
}

#pragma mark**搜索
-(void)createSousuoBtn
{
    UIImageView *sousuoImg=[[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth-66*_Scale)/2.0f, ScreenHeight-200*_Scale, 66*_Scale, 66*_Scale)];
    sousuoImg.image=[UIImage imageNamed:@"found_school_2_搜索icon"];
    sousuoImg.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapActionSousuo)];
    [sousuoImg addGestureRecognizer:tap];
    [self.view addSubview:sousuoImg];
}

// 创建搜索视图
-(void)tapActionSousuo
{
    if((UIView *)[self.view viewWithTag:100]==nil)
    {
        //    创建背景
        UIView *backview=[self createBackView_max__2];

        UITextField *_textfield=[self createSearchView];
        _textfield.frame=CGRectMake(CGRectGetMinX(_textfield.frame),(ScreenHeight-kTabBarHeight- CGRectGetHeight(_textfield.frame))/2.0f, CGRectGetWidth(_textfield.frame), CGRectGetHeight(_textfield.frame));
        [backview addSubview:_textfield];

    }
}

#pragma mark*背景蒙板
//背景蒙板创建1
-(UIView *)createBackView_max__2
{
    UIImageView  *backView=[[UIImageView alloc] initWithFrame:self.view.frame];
    backView.image=[UIImage imageNamed:@"蒙板"];
    backView.tag=100;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backview1Action__2)];
    backView.userInteractionEnabled=YES;
    [backView addGestureRecognizer:tap];
    [self.view addSubview:backView];
    return backView;
}

#pragma mark-----------------Refresh----------------
#pragma mark*开始进入刷新状态
/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    WeakSelf(ws);
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [ws headerRereshing];
    }];
    _tableView.mj_header = header;
    _tableView.mj_header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;

    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [ws footerRereshing];
    }];

    [_tableView.mj_header beginRefreshing];
}
- (void)headerRereshing
{
    _page=1;//page初始化
    [self requestData];//请求列表
}
-(void)footerRereshing
{
    _page++;//下一页
    [self requestData];//请求下一页列表
}
#pragma mark-----------------Requests----------------
#pragma mark*主界面
//主界面列表数据的请求
-(void)requestData
{
//    创建参数列表
    NSDictionary *_parameters=@{
                                @"page":@(_page)
                                ,@"token":[regular getToken]
                                };
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[[NSString alloc] initWithFormat:@"%@/v1/posts/user_follow_posts",DNS] parameters:_parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *html = operation.responseString;
        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
        blockSuccess(dict);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_tableView.mj_header endRefreshing];
        [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
    }];
}

#pragma mark-----------------AnalyseData----------------
#pragma mark*主界面数据处理
-(void)createBlock
{
    [self SuccessBlock];
}
-(void)SuccessBlock
{
    WeakSelf(ws);
    blockSuccess=^(NSDictionary *_dict)
    {
//        刷新动画收起
        [ws.tableView.mj_header endRefreshing];
        [ws.tableView.mj_footer endRefreshing];
        if(ws.page==1)
        {
            [ws.arrayData removeAllObjects];
        }

//数据处理，获取模型数组
        NSArray *getdata=[ArticleModel parsingData:_dict];
//        当获取数据count数量大于0时候，刷新tableview

        if(getdata.count>0)
        {
            [ws.arrayData addObjectsFromArray:getdata];
            [ws.tableView reloadData];
            
        }else
        {
            [ws.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"没有更多了" WithImg:@"Prompt_提交成功" Withtype:1]];
        }
        if(ws.arrayData.count)
        {
            ws.nofollow.hidden=YES;
        }else
        {
            ws.nofollow.hidden=NO;
        }
    };

}

#pragma mark-----------------Actions----------------
#pragma mark*空
//一些空action，处理一些异常
-(void)nullAction{}


//删除背景蒙板
-(void)backview1Action__2
{
    [[self.view viewWithTag:100] removeFromSuperview];
}


#pragma mark-----------------SomeDelegate----------------

#pragma mark*TextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //结束编辑点击键盘上的return键执行动画效果使视图回落
    [textField resignFirstResponder];
    if([textField.text isEqualToString:@""])
    {
        [[ToolManager sharedManager] alertTitle_Simple:@"请输入关键字"];
    }else
    {
//        //跳转到搜索页面
//        souSuoViewController *sousuo= [[souSuoViewController alloc] init];
//        sousuo.keystring=textField.text;
//        [self.navigationController pushViewController:sousuo animated:YES];
    }

    return YES;
}


#pragma mark*ScrollViewDelegate
//导航栏的动画显示与隐藏
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if(_appear&&scrollView==_tableView)
    {
//        记录开始滑动时候tableview的偏移量
        _start_y=scrollView.contentOffset.y;
//        开始滑动
        _Dragging=YES;
    }

}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{


    JXLOG(@"%f",scrollView.contentOffset.y);
    CGFloat _height=scrollView.contentOffset.y+CGRectGetHeight(_tableView.frame)-_min_offset-kTabBarHeight;
    NSInteger now_cell=0;
    if(_isPad)
    {
        now_cell=(NSInteger)(_height/((NSInteger)360*_Scale));

    }else
    {
        now_cell=(NSInteger)(_height/180);

    }

    if(now_cell!=_Record_cell_num)
    {
        _Record_cell_num=now_cell;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ArticleAnimation" object:[NSNumber numberWithLong:_Record_cell_num]];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ArticleAnimation1" object:nil];

    if(_Dragging)
    {
//        当导航栏已经消失
        if(_appear&&scrollView==_tableView)
        {
            if(_start_y<20&&scrollView.contentOffset.y>20)
            {
//            当开始时偏移量小于20并且当前偏移量大于20，开始上滑动画
                [self SlideUpAction];
            }else
            {
                if(scrollView.contentOffset.y<20)
                {
                    [self SlideDownAction];
                }else
                {
                    if(!_nav_donghua&&((scrollView.contentOffset.y-_start_y)>(ScreenHeight/4.0f)))
                    {

                        [self SlideUpAction];
                    }else if(_nav_donghua&&((_start_y-scrollView.contentOffset.y)>(ScreenHeight/4.0f)))
                    {

                        [self SlideDownAction];

                    }
                }
            }
        }
    }
}
//导航栏恢复动画
-(void)SlideDownAction
{
    [UIView beginAnimations:@"SlideDownAction" context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDelegate:self];
    self.navigationController.navigationBar.frame=CGRectMake(0, kStatusBarHeight, [[UIScreen mainScreen]bounds].size.width, kNavigationBarHeight);
    _leftBarbtn.alpha=1;
    self.navigationItem.titleView.alpha=1;
    [UIView commitAnimations];
    _nav_donghua=NO;
}
//导航栏上滑动画
-(void)SlideUpAction
{
    [UIView beginAnimations:@"SlideUpAction" context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDelegate:self];
    self.navigationController.navigationBar.frame=CGRectMake(0, kStatusBarHeight - kStatusBarAndNavigationBarHeight, [[UIScreen mainScreen]bounds].size.width, kNavigationBarHeight);
    _leftBarbtn.alpha=0;
    self.navigationItem.titleView.alpha=0;
    [UIView commitAnimations];
    _nav_donghua=NO;

}
//滑动结束时候调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{

    if(_appear&&scrollView==_tableView)
    {
        _Dragging=NO;
    }
}
// 回到最顶部
- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
//导航栏恢复
    _Dragging=NO;
    self.navigationController.navigationBar.frame=CGRectMake(0, kStatusBarHeight, [[UIScreen mainScreen]bounds].size.width, kNavigationBarHeight);
    self.navigationItem.titleView.alpha=1;
    _leftBarbtn.alpha=1;
    _nav_donghua=NO;

    return YES;
}
#pragma mark*TableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return foundCellHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if(!_bKeyBoardHide)
    {
//        当键盘为出现状态时，触发 键盘消失方法
        [regular dismissKeyborad];

    }else
    {
//键盘没有出现时候调用
        ArticleDetailViewController *Article=[[ArticleDetailViewController alloc] init];
        Article.ArticleID=[[NSString alloc] initWithFormat:@"%lld",[((ArticleModel *)[_arrayData objectAtIndex:indexPath.row]).m_id longLongValue]];
        Article.model=[_arrayData objectAtIndex:indexPath.row];
        Article.block=alterBlock;
        [self.navigationController pushViewController:Article animated:YES];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if(_arrayData.count==section)
    {
        return 0;
    }
    return _arrayData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    数据还未获取时候
    if(_arrayData.count==indexPath.section)
    {
        static NSString *cellid=@"cellid";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
        if(!cell)
        {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
//获取到数据以后
    static NSString *cellid=@"ArticleCell";
    ArticleCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
    if(!cell)
    {
        cell=[[ArticleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
//6 3
    NSDictionary *dict=[[NSDictionary alloc] initWithObjectsAndKeys:[_arrayData objectAtIndex:indexPath.row],@"model",[NSNumber numberWithInteger:indexPath.row],@"row",[NSNumber numberWithInteger:[_arrayData count]],@"num",nil];
    cell.block=changeBlock;
    cell.dict=dict;
    return cell;
}

#pragma mark-----------------Others----------------

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    _appear=YES;
//    tabbar设为出现
    [[CustomTabbarController sharedManager] tabbarHide];
//    友盟页面监控（登出）
    [MobClick beginLogPageView:@"FoundViewController"];

}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    导航栏还原
    _appear=NO;
    _Dragging=NO;
    self.navigationController.navigationBar.frame=CGRectMake(0, kStatusBarHeight, [[UIScreen mainScreen]bounds].size.width, kNavigationBarHeight);
    self.navigationItem.titleView.alpha=1;
    _leftBarbtn.alpha=1;
    _nav_donghua=NO;
//    友盟页面监控（进入）
    [MobClick endLogPageView:@"FoundViewController"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
