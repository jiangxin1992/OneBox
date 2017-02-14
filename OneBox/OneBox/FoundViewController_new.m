//
//  FoundViewController_new.m
//  OneBox
//
//  Created by 谢江新 on 15/12/7.
//  Copyright © 2015年 谢江新. All rights reserved.
//

#import "OnlineProjectsViewController.h"
#import "MapViewController.h"
#import "shaiXuanViewController.h"
#import "NMRangeSlider.h"
#import "souSuoCitiesViewController.h"
#import "SchoolDetailViewController.h"
#import "souSuoViewController.h"
#import "bangdanlistViewController.h"
#import "bangdanViewController.h"
#import "FoundCell_new.h"
#import "foundModel_new.h"
#import "SchoolDetailViewController.h"
#import "MJRefresh.h"
#import "FoundViewController_new.h"
#define foundCellHeight 380*_Scale

@interface FoundViewController_new ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@end

@implementation FoundViewController_new
{

    UIButton *help_btn;
    NSInteger _Record_cell_num;
    CGFloat _min_offset;
    UIButton *rightbtn;
    NSString *headviewimage;//headview的背景图url
    DBImageView *_headview;//headview的背景图
    UIScrollView *_scrollview_city;//选择city的scrollview
    UIButton *all_city;//选择所有城市btn

    UIView *downView;//州界面背景（控制隐藏显示）
    UIImageView *backviewcity;//城市界面背景（控制隐藏显示）
    UIView *upviewcity;//城市界面scrollview的背景图
    //用于显示slider下部的数量
    UILabel *leftLabel1;
    UILabel *rightLabel1;
    UILabel *leftLabel2;
    UILabel *rightLabel2;
    UITableView *_tableView;//tableview

    BOOL bKeyBoardHide;//判断键盘显示状态
    //    开始
    NSMutableArray *cityArray;//存放真实城市数据
    NSMutableArray *stateArr;//存放州的获取数据
    NSMutableArray *cityArr;//存放城市获取数据
    NSMutableString *state_id;//当前州ID
    NSMutableString *city_id;//当前城市ID

    NSMutableArray *titleBtnArray;//存放标题按钮
    BOOL _isfirst_choose;//是否是第一次打开筛选视图
    //    滑动image
    NSArray *screen_normalImg;//记录筛选view btn normal状态下的image
    NSArray *screen_selectImg;//记录筛选view btn select状态下的image
    NSArray *screen_titleArr;//记录筛选view btn 的title
      NSMutableArray *screen_btnArr;//存放筛选界面btn的数组
    NSInteger _now_state;//记录筛选界面当前进入的层数状态，用来显示或消失相应的视图，避免重复创建
    long total_students_min;//记录学生数的最小值
    long ap_count_max;//记录ap课程数量的最大值
    long total_students_max;//记录学生数的最大值
    long ap_count_min;//记录ap课程数量的最小值

    BOOL _nav_donghua;//记录导航栏是否滑动上去（是否消失）
    CGFloat _start_y;//表示tableview开始拖动时候的起始位置
    BOOL _Dragging;//表示tableview开始拖动，记录拖动的开始
    BOOL _appear;
    NSInteger _page;//记录当前page
    NSMutableArray *_arrayData;//存放页面的数据

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(xiaoshi:) name:@"xiaoshi" object:nil];
    
//    添加键盘监控,在键盘消失或者出现时候会调用，来改变bKeyBoardHide的值，以此来判断当前键盘是否为弹出状态
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

}
-(void)xiaoshi:(NSNotification *)not
{
    if([not.object isEqualToString:@"other"])
    {
        [self dismissModalViewControllerAnimated:YES];
    }
    
}
//键盘消失时候调用
-(void)keyboardWillHide:(NSNotification *)notification
{
    bKeyBoardHide = YES;
}
//键盘出现时候调用
-(void)keyboardWillShow:(NSNotification *)notification
{
    bKeyBoardHide = NO;
}

#pragma mark*导航栏重置
-(void)navBarReset
{
//将导航栏位置复原
    self.navigationController.navigationBar.frame=CGRectMake(0, 20, [[UIScreen mainScreen]bounds].size.width, 44);
//    导航栏标题透明度还原成1，还原_Dragging，_nav_donghua
    self.navigationItem.titleView.alpha=1;
    rightbtn.alpha=1;
    _Dragging=NO;
    _nav_donghua=NO;
}
#pragma mark-----------------SomePrepare----------------
-(void)SomePrepare
{
    [self PrepareData];//一些数据的初始化
    [self initializeData];//筛选栏记录状态数据的初始化
    [self PrepareUI];//一些初始化UI的准备
    changeBlock=^(NSInteger row)
    {
        NSLog(@"%@",_arrayData);
        ((foundModel_new *)[_arrayData objectAtIndex:row]).isapp=YES;
    };


}
-(void)PrepareData
{
    _Record_cell_num=0;
    bKeyBoardHide=YES;//开始时候键盘为隐藏状态
    _appear=YES;
    _Dragging=NO;
    _nav_donghua=NO;
    _start_y=0;
    leftLabel1=[[UILabel alloc] init];
    leftLabel2=[[UILabel alloc] init];
    rightLabel1=[[UILabel alloc] init];
    rightLabel2=[[UILabel alloc] init];
    _now_state=0;
    state_id=[[NSMutableString alloc] init];
    city_id=[[NSMutableString alloc] init];
    _isfirst_choose=YES;
    _arrayData=[[NSMutableArray alloc] init];

    screen_titleArr=@[@[@"混 校",@"女 校",@"男 校",@"ESL"],@[@"走 读",@"寄 宿",@"高 中",@"初 中"]];
    screen_normalImg=@[@[@"screenShcool_混合学校未点击",@"screenShcool_女校未点击",@"screenShcool_男校未选中",@"screenShcool_无esl1"],@[@"screenShcool_走读未选中",@"screenShcool_寄宿未选中",@"screenShcool_高中未选中",@"screenShcool_初中未选中"]];
    screen_selectImg=@[@[@"screenShcool_混校",@"screenShcool_女校",@"screenShcool_男校",@"screenShcool_esl"],@[@"screenShcool_走读",@"screenShcool_寄宿",@"screenShcool_高中",@"screenShcool_初中"]];
    stateArr=[[NSMutableArray alloc] init];
    cityArr=[[NSMutableArray alloc] init];
    
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

    _city=[[NSMutableString alloc] initWithString:@""];
    _state=[[NSMutableString alloc] initWithString:@""];

}
-(void)PrepareUI
{
//    设置导航栏颜色
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:70.0f/255.0f green:195.0f/255.0f blue:247.0f/255.0f alpha:1];
//    设置背景颜色
    self.view.backgroundColor=_define_backview_color;
//    添加标题

    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 230, 40)];
    UIImageView *_icon=[[UIImageView alloc] init];
    if(_isPad)
    {
        _icon.frame=CGRectMake((CGRectGetWidth(view.frame)-32.5)/2.0f, (CGRectGetHeight(view.frame)-31.5)/2.0f-5*_Scale, 32.5, 31.5);

    }else
    {
        _icon.frame=CGRectMake((CGRectGetWidth(view.frame)-65*_Scale)/2.0f, (CGRectGetHeight(view.frame)-63*_Scale)/2.0f-5*_Scale, 65*_Scale, 63*_Scale);
    }

    [view addSubview:_icon];
    _icon.image=[UIImage imageNamed:@"login_ICON11"];
    self.navigationItem.titleView=view;

//   应对导航栏黑线问题（异常）
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

    rightbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    rightbtn.frame=CGRectMake(0, 0, 20, 20);
    [rightbtn setBackgroundImage:[UIImage imageNamed:@"found_right_btn"] forState:UIControlStateNormal];
    [rightbtn addTarget:self action:@selector(tapActionSousuo) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *bar=[[UIBarButtonItem alloc] initWithCustomView:rightbtn];
    self.navigationItem.rightBarButtonItem=bar;

}
#pragma mark-----------------UIConfig----------------
-(void)UIConfig
{
//    创建tableview
    [self createTableView];
//    创建视图下方三个按钮
    [self createHelp];
}
-(void)createHelp
{
//    70
    UIView *helpview=[[UIView alloc] initWithFrame:CGRectMake(ScreenWidth-90*_Scale-70*_Scale, ScreenHeight-160*_Scale-tabbarHeight, 90*_Scale, 150*_Scale)];
    [self.view addSubview:helpview];
    helpview.backgroundColor=[UIColor clearColor];

    help_btn=[UIButton buttonWithType:UIButtonTypeCustom];
    help_btn.frame=CGRectMake(0, 0, 90*_Scale, 90*_Scale);
    [help_btn setBackgroundImage:[UIImage imageNamed:@"found_问问"] forState:UIControlStateNormal];
    [help_btn addTarget:self action:@selector(helpAction:) forControlEvents:UIControlEventTouchUpInside];
    [helpview addSubview:help_btn];

    UILabel *label_title=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(help_btn.frame), CGRectGetMaxY(help_btn.frame)+12*_Scale, CGRectGetWidth(help_btn.frame), 34*_Scale)];
    [helpview addSubview:label_title];
    label_title.textAlignment=1;
    label_title.textColor=[UIColor whiteColor];
    label_title.font=[regular getFont:12.0f];
    [label_title setAttributedText:[regular createAttributeString:@"问问" andFloat:@(3.0)]];
}
#pragma mark*创建TableView
-(void)createTableView
{
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
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
#pragma mark*创建搜索栏
-(void)createTableHeadView
{

//    创建tableview的headview，为空的时候（即网络数据获取后创建）
    _headview=[[DBImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 420*_Scale)];
    _headview.userInteractionEnabled=YES;
//    设为headview
    _tableView.tableHeaderView=_headview;
_package
//    根据网络获取到headview图片是否为空来处理（应对DBimage 在图片地址无效时候显示灰色样式）
    if(headviewimage==nil)
    {
////        为空时候，直接设为背景图
        _headview.image=[UIImage imageNamed:@"found_newsearch_back_260"];
    }else
    {
//        不为空时候网络获取该图片，设置placeholder图片。
        _headview.placeHolder=[UIImage imageNamed:@"found_newsearch_back_260"];
        [_headview setImageWithPath:headviewimage];
    }

//    创建搜索栏
    UITextField *_textfiled=[self createSearchView];
    _textfiled.frame=CGRectMake((CGRectGetWidth(_headview.frame)-CGRectGetWidth(_textfiled.frame))/2.0f, 120*_Scale, CGRectGetWidth(_textfiled.frame), CGRectGetHeight(_textfiled.frame));
    [_headview addSubview:_textfiled];

//    给headview增加触摸（键盘消失）
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headviewAction)];
    [_headview addGestureRecognizer:tap];



    NSArray *imagename=@[@"found_bangdan_排名",@"found_bangdan_地图",@"found_bangdan_筛选"];
    NSArray *imagetitle=@[@"排名",@"地图",@"筛选"];

    CGFloat _jiange=(CGRectGetWidth(_headview.frame)-130*_Scale*2-80*_Scale*3)/2.0f;
    CGFloat _x_p=130*_Scale;
    for (int i=0; i<imagename.count; i++) {
        UIImageView *bangdanImg=[[UIImageView alloc] init];
        bangdanImg.frame=CGRectMake(_x_p, CGRectGetMaxY(_textfiled.frame)+46*_Scale, 80*_Scale, 80*_Scale);
        bangdanImg.image=[UIImage imageNamed:imagename[i]];
        bangdanImg.userInteractionEnabled=YES;
        UITapGestureRecognizer *tap=nil;

        if(i==0)
        {
            tap=[[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapActionBangdan:)];

        }else if(i==1)
        {
            tap=[[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapActionMap)];

        }else if(i==2)
        {
            tap=[[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapAction:)];
        }
        [bangdanImg addGestureRecognizer:tap];
        [_headview addSubview:bangdanImg];
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(bangdanImg.frame)-10, CGRectGetMaxY(bangdanImg.frame), CGRectGetWidth(bangdanImg.frame)+20, 70*_Scale)];
        [_headview addSubview:label];
        label.textAlignment=1;
        label.textColor=[UIColor whiteColor];
        [label setAttributedText:[regular createAttributeString:imagetitle[i] andFloat:@(2.0)]];
        label.font=[regular getFont:13.0f];
        _x_p+=80*_Scale+_jiange;
    }

    
}
-(void)helpAction:(UIButton*)btn
{

    NSString *login=nil;
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"token"]==nil)
    {
        login=@"0";
    }else
    {
        login=@"1";
    }

    OnlineProjectsViewController *online=[[OnlineProjectsViewController alloc] init];
    online.islogin=login;
    [self.navigationController pushViewController:online animated:YES];
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
//键盘消失
-(void)headviewAction
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}
#pragma mark*创建三个按钮
-(void)createThreeBtn
{


    [self createBangdanBtn];
    [self createSearchBtn];
    [self createSousuoBtn];
}
#pragma mark**榜单
-(void)createBangdanBtn
{
    UIImageView *bangdanImg=[[UIImageView alloc] initWithFrame:CGRectMake(((ScreenWidth-66*_Scale)/2.0f)-50- 66*_Scale, ScreenHeight-200*_Scale, 66*_Scale, 66*_Scale)];
    bangdanImg.image=[UIImage imageNamed:@"found_bangdan_排名"];
    bangdanImg.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapActionBangdan:)];
    [bangdanImg addGestureRecognizer:tap];
    [self.view addSubview:bangdanImg];
}
//创建点击榜单按钮后显示的榜单选择界面
-(void)tapActionBangdan:(UIGestureRecognizer *)sender
{
    if((UIView *)[self.view viewWithTag:100]==nil)
    {
//        创建背景
        UIView *backview=[self createBackView_max__2];

//        创建按钮
        for (int i=0; i<4; i++) {
            UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
            [backview addSubview:btn];
            NSString *imagename=nil;
            if(i==0||i==1)
            {
                if(i==0)
                {
                    imagename=@"bangdan_niche";

                }else
                {
                    imagename=@"bangdan_business_insider";
                }
            }else if(i==2)
            {
                imagename=@"bangdan_prep_review";
            }else if(i==3)
            {
                imagename=@"bangdan_blueribbon";
            }

            [btn setBackgroundImage:[UIImage imageNamed:imagename] forState:UIControlStateNormal];

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


#pragma mark**搜索
-(void)createSousuoBtn
{
    UIImageView *sousuoImg=[[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth-66*_Scale)/2.0f, ScreenHeight-200*_Scale, 66*_Scale, 66*_Scale)];
    sousuoImg.image=[UIImage imageNamed:@"found_bangdan_地图"];
    sousuoImg.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapActionMap)];
    [sousuoImg addGestureRecognizer:tap];
    [self.view addSubview:sousuoImg];

}
-(void)tapActionMap
{
    [self.navigationController pushViewController:[MapViewController new] animated:YES];
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
#pragma mark**筛选
-(void)createSearchBtn
{
    UIImageView *searchImg=[[UIImageView alloc] initWithFrame:CGRectMake(((ScreenWidth-66*_Scale)/2.0f)+50+66*_Scale,  ScreenHeight-200*_Scale, 66*_Scale, 66*_Scale)];
    searchImg.image=[UIImage imageNamed:@"found_bangdan_筛选"];
    searchImg.userInteractionEnabled=YES;
//    点击后网络获取学生人数和AP课程数，获取后再创建视图
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapAction:)];
    [searchImg addGestureRecognizer:tap];
    [self.view addSubview:searchImg];
}
//创建筛选视图
-(void)createchooseView
{
//    初始化该数组用来存放btn
    screen_btnArr=[[NSMutableArray alloc] init];
//    创建筛选界面背景视图
    [self createBackView_min];
//    创建州和城市选择界面
    UIView *view1=[self createdownView];
//    创建学校类型选择和学生数选择view
    UIView *view2=[self createupView:CGRectGetMaxY(view1.frame)];
//    创建ap课程数选择view
    UIImageView *view3=[self createfanweiView1:CGRectGetMaxY(view2.frame)];

    UIImageView *backview=(UIImageView *)[self.view viewWithTag:200];
    UIView *dingbu=[[UIView alloc] initWithFrame:CGRectMake(14*_Scale, CGRectGetMaxY(view3.frame), CGRectGetWidth(backview.frame)-28*_Scale, 1*_Scale)];
    [backview addSubview:dingbu];
    dingbu.backgroundColor=[UIColor colorWithRed:220.0f/255.0f green:220.0f/255.0f blue:220.0f/255.0f alpha:1];
    UIButton *subImg=[self createshaixuan_btnWithFrame:CGRectMake(0, CGRectGetMaxY(view3.frame)+1*_Scale, CGRectGetWidth(backview.frame), 60*_Scale)];
    [backview addSubview:subImg];
}
//创建筛选按钮
-(UIButton *)createshaixuan_btnWithFrame:(CGRect)_rect
{
    UIButton *subImg=[UIButton buttonWithType:UIButtonTypeCustom];
    subImg.backgroundColor=[UIColor colorWithRed:107.0f/255.0f green:203.0f/255.0f blue:202.0f/255.0f alpha:1];
    subImg.frame=_rect;
    [subImg setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [subImg setTitle:@"筛选" forState:UIControlStateNormal];
    [subImg.titleLabel setAttributedText:[regular createAttributeString:@"筛选" andFloat:@(7.0)]];
    subImg.titleLabel.font=[regular getFont:14.0f];
    [subImg addTarget:self action:@selector(subAction:) forControlEvents:UIControlEventTouchUpInside];
    return subImg;
}
//创建筛选背景view
-(void)createBackView_min
{
    CGFloat _y_p=(ScreenHeight-485*_Scale)*(2.0f/5.0f);
    CGRect rect=CGRectMake(70*_Scale, _y_p-72*_Scale,ScreenWidth-70*_Scale*2, 698*_Scale);
    UIImageView  *backview1=[[UIImageView alloc] initWithFrame:rect];
    backview1.tag=200;
    backview1.backgroundColor=[UIColor whiteColor];
    backview1.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nullAction)];
    [backview1 addGestureRecognizer:tap];
    UIImageView *view=(UIImageView *)[self.view viewWithTag:100];
    [view addSubview:backview1];
}
//创建城市州选择view
-(UIView *)createdownView
{
    UIImageView *backview=(UIImageView *)[self.view viewWithTag:200];
    downView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(backview.frame), 100*_Scale)];
    downView.backgroundColor=[UIColor whiteColor];
    [backview addSubview:downView];

//创建所在州，所在城市btn，（显示用户最后操作的btn状态）
    for (int i=0; i<2; i++) {

        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(chooseLoc:) forControlEvents:UIControlEventTouchUpInside];

        btn.frame=CGRectMake((CGRectGetWidth(backview.frame)-(18+220*2)*_Scale)/2+i*(220+18)*_Scale, (CGRectGetHeight(downView.frame)-46.0f*_Scale)/2.0f, 220*_Scale, 46*_Scale);
        btn.tag=400+i;
        [btn setBackgroundColor:[UIColor colorWithRed:246.0f/255.0f green:246.0f/255.0f blue:246.0f/255.0f alpha:1]];
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
        [btn setTitleColor:_define_blue_color forState:UIControlStateNormal];
        [btn setTitle:title forState:UIControlStateNormal];
        [downView addSubview:btn];
    }
    return downView;
}
-(UIView *)createupView:(CGFloat )__y_p
{
    UIImageView *backview=(UIImageView *)[self.view viewWithTag:200];
    UIView *dingbu=[[UIView alloc] initWithFrame:CGRectMake(14*_Scale, __y_p, CGRectGetWidth(backview.frame)-28*_Scale, 1*_Scale)];
    [backview addSubview:dingbu];
    dingbu.backgroundColor=[UIColor colorWithRed:220.0f/255.0f green:220.0f/255.0f blue:220.0f/255.0f alpha:1];

    UIView *upview=[[UIView alloc] initWithFrame:CGRectMake(0, __y_p+1*_Scale, CGRectGetWidth(backview.frame), 150*_Scale)];
    upview.backgroundColor=[UIColor whiteColor];
    [backview addSubview:upview];

    UIView *dingbu2=[[UIView alloc] initWithFrame:CGRectMake(14*_Scale, CGRectGetMaxY(upview.frame), CGRectGetWidth(backview.frame)-28*_Scale, 1*_Scale)];
    [backview addSubview:dingbu2];
    dingbu2.backgroundColor=[UIColor colorWithRed:220.0f/255.0f green:220.0f/255.0f blue:220.0f/255.0f alpha:1];

    UIView *middleView1=[[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(upview.frame), CGRectGetMaxY(upview.frame)+1*_Scale, CGRectGetWidth(upview.frame), 119*_Scale)];
    middleView1.backgroundColor=[UIColor whiteColor];
    [backview addSubview:middleView1];

    UIView *dingbu3=[[UIView alloc] initWithFrame:CGRectMake(14*_Scale, CGRectGetMaxY(middleView1.frame), CGRectGetWidth(backview.frame)-28*_Scale, 1*_Scale)];
    [backview addSubview:dingbu3];
    dingbu3.backgroundColor=[UIColor colorWithRed:220.0f/255.0f green:220.0f/255.0f blue:220.0f/255.0f alpha:1];


    UIView *middleView=[[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(middleView1.frame), CGRectGetMaxY(middleView1.frame)+1*_Scale, CGRectGetWidth(middleView1.frame), 150*_Scale)];
    middleView.backgroundColor=[UIColor whiteColor];
    [backview addSubview:middleView];
//    创建slider
_package
    NMRangeSlider *slider = [[NMRangeSlider alloc] initWithFrame:CGRectMake(30*_Scale, ((CGRectGetHeight(middleView1.frame)-25.0)/2.0f)-15*_Scale, CGRectGetWidth(middleView1.frame)-60*_Scale, 25.) ];
    [middleView1 addSubview:slider];
    slider.tag=5000;
    slider.minimumValue=total_students_min;
    slider.maximumValue=total_students_max;
    slider.lowerValue=total_students_min;
    slider.upperValue=total_students_max;
//    slider被拖动时调用(改变左右label的值)
    [slider addTarget:self action:@selector(valueChangedForDoubleSlider:) forControlEvents:UIControlEventValueChanged];
//    创建slider下部标题
    UILabel *downlabel=[[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(slider.frame)-CGRectGetHeight(slider.frame)/2.0f, CGRectGetWidth(middleView1.frame), CGRectGetHeight(middleView1.frame)-CGRectGetMaxY(slider.frame)+CGRectGetHeight(slider.frame)/2.0f)];
    [middleView1 addSubview:downlabel];
    downlabel.textAlignment=1;
    downlabel.font=[regular getFont:11.0f];
    UITapGestureRecognizer *_tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nullAction)];
    [downlabel addGestureRecognizer:_tap];
    NSString *downstr=@"学生数";
    downlabel.textColor=[UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1];
    downlabel.text=downstr;
//    创建slider下部左右label
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
_package
//   创建选择状态btn，初始化都为unselected
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

            [btn setBackgroundImage:[UIImage imageNamed:((NSArray *)screen_normalImg[i])[j]] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:((NSArray *)screen_selectImg[i])[j]] forState:UIControlStateSelected];

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

//    如果不是第一次创建,将之前记录的状态复制给当前创建的button
    if(!_isfirst_choose)
    {
        [self setBtnState];
        
    }
    return middleView;
}
//创建ap课程slider选择view
-(UIImageView *)createfanweiView1:(CGFloat )maxy
{

    UIImageView *backview=(UIImageView *)[self.view viewWithTag:200];
    UIView *dingbu=[[UIView alloc] initWithFrame:CGRectMake(14*_Scale, maxy, CGRectGetWidth(backview.frame)-28*_Scale, 1*_Scale)];
    [backview addSubview:dingbu];
    dingbu.backgroundColor=[UIColor colorWithRed:220.0f/255.0f green:220.0f/255.0f blue:220.0f/255.0f alpha:1];


    UIImageView *_downview=[[UIImageView alloc] initWithFrame:CGRectMake(0, maxy+1*_Scale, CGRectGetWidth(backview.frame), 115*_Scale)];
    _downview.userInteractionEnabled=YES;
    [backview addSubview:_downview];
    _downview.backgroundColor=[UIColor whiteColor];

    NMRangeSlider *slider = [[NMRangeSlider alloc] initWithFrame:CGRectMake(30*_Scale, ((CGRectGetHeight(_downview.frame)-25.)/2.0f)-15*_Scale, CGRectGetWidth(_downview.frame)-60*_Scale, 25.)];
    slider.minimumValue=ap_count_min;
    slider.maximumValue=ap_count_max;
    slider.lowerValue=ap_count_min;
    slider.upperValue=ap_count_max;
    [_downview addSubview:slider];
    slider.tag=5001;
    [slider addTarget:self action:@selector(valueChangedForDoubleSlider:) forControlEvents:UIControlEventValueChanged];
    UILabel *downlabel=[[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(slider.frame)-CGRectGetHeight(slider.frame)/2.0f, CGRectGetWidth(_downview.frame), CGRectGetHeight(_downview.frame)-CGRectGetMaxY(slider.frame)+CGRectGetHeight(slider.frame)/2.0f)];
    [_downview addSubview:downlabel];

    downlabel.textAlignment=1;
    downlabel.font=[regular getFont:11.0f];
    UITapGestureRecognizer *_tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nullAction)];
    [downlabel addGestureRecognizer:_tap];
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
    

    return _downview;
}

#pragma mark*背景蒙板
//背景蒙板创建1
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
//背景蒙板创建2
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

#pragma mark-----------------Refresh----------------
#pragma mark*开始进入刷新状态
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
    NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
//    添加page
    [dict setObject:[[NSString alloc] initWithFormat:@"%ld",(long)_page] forKey:@"page"];
//    添加token
    NSUserDefaults *_UserDefaults=[NSUserDefaults standardUserDefaults];
    NSString *_token=nil;
    if([[_UserDefaults objectForKey:@"islogin"] integerValue]==1)
    {
        _token=[_UserDefaults objectForKey:@"token"];
    }else
    {
        _token=@"";
    }
    [dict setObject:_token forKey:@"token"];
//请求
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[[NSString alloc] initWithFormat:@"%@%@",DNS,@"/v2/app_modules"] parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
//        请求成功后的处理
        blockSuccess(dict);
        [[ToolManager sharedManager] removeProgress];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_tableView headerEndRefreshing];
        [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
        [[ToolManager sharedManager] removeProgress];
    }];
}
#pragma mark*筛选视图
// 筛选视图请求
-(void)tapAction:(UIGestureRecognizer *)sender
{
//当背景蒙板未创建的时候创建筛选视图。（为异常处理）
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

//                请求成功将最大值和最小值赋值给相应的对象
                total_students_min=[[[dict objectForKey:@"data"] objectForKey:@"total_students_min"] longValue];
                ap_count_max=[[[dict objectForKey:@"data"] objectForKey:@"ap_count_max"] longValue];

                total_students_max=[[[dict objectForKey:@"data"] objectForKey:@"total_students_max"] longValue];
                ap_count_min=[[[dict objectForKey:@"data"] objectForKey:@"ap_count_min"] longValue];
//                记录当前的层数状态
                _now_state=1;
//再次确认蒙板是否已经被创建，如果没有被创建才创建筛选视图（应对弱网络下的显示异常）
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
#pragma mark*创建城市view
-(void)createChooseCityView
{
//    设定当前的状态为3
    _now_state=3;

    UIImageView *backview=(UIImageView *)[self.view viewWithTag:100];
    CGFloat _y_p=(ScreenHeight-485*_Scale)*(2.0f/5.0f);
//    创建州视图
    backviewcity=[[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(backview.frame)-440*_Scale)/2.0f, _y_p, 440*_Scale, 600*_Scale)];
//    防止父视图的触摸影响子视图
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nullAction)];
    [backviewcity addGestureRecognizer:tap];
    backviewcity.userInteractionEnabled=YES;
    backviewcity.tag=202;
    [backview addSubview:backviewcity];
//   背景视图
    upviewcity=[[UIView alloc] initWithFrame:CGRectMake(0, 29*_Scale, CGRectGetWidth(backviewcity.frame), 500*_Scale)];
    upviewcity.backgroundColor=[UIColor colorWithRed:65.0f/255.0f green:176.0f/255.0f blue:211.0f/255.0f alpha:1];
    [backviewcity addSubview:upviewcity];
//    所有城市按钮
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
//    设为隐藏状态，数据获取后再显示
    all_city.hidden=YES;
//创建scrollview
    _scrollview_city=[[UIScrollView alloc] initWithFrame:CGRectMake(10*_Scale, 30*_Scale, CGRectGetWidth(upviewcity.frame)-20*_Scale, CGRectGetHeight(upviewcity.frame)-60*_Scale)];
    _scrollview_city.backgroundColor=[UIColor redColor];
    _scrollview_city.contentSize=CGSizeMake(CGRectGetWidth(upviewcity.frame)-20*_Scale, CGRectGetHeight(upviewcity.frame)-60*_Scale);
    _scrollview_city.backgroundColor=upviewcity.backgroundColor;
    _scrollview_city.showsVerticalScrollIndicator=YES;
    [upviewcity addSubview:_scrollview_city];


    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[[NSString alloc] initWithFormat:@"%@%@%@",DNS,@"/v1/us_states/",state_id] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",state_id);

        NSString *html = operation.responseString;
        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];

        if([[dict objectForKey:@"code"] intValue] ==1)
        {

//           删除城市数据
            [cityArr removeAllObjects];

//            添加城市数据
            [cityArr setArray:[dict objectForKey:@"data"]];

            cityArray=[[NSMutableArray alloc] init];
//            过滤城市数据，去除一些无数据字段的城市对象，cityArray为最后获取的城市数据
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
//根据获取城市数据个数来调整scrollview的contentsize
            _scrollview_city.contentSize=CGSizeMake(CGRectGetWidth(upviewcity.frame)-20*_Scale, cityArray.count*42*_Scale);
//判断数据是否大于12个，大于12个  确定界面高度，增加contentsize的高度。反之scrollview的frame和contentsize都一样，不可滑动
            CGFloat _backheight=0;
            if(cityArray.count>12)
            {
                _backheight= 12*42*_Scale+60*_Scale+54*_Scale;

            }else
            {
                _backheight= cityArray.count*42*_Scale+60*_Scale+54*_Scale;
            }
//            增加动画
            [UIView beginAnimations:@"anmationName" context:nil];
//            动画停止后现实所有城市按钮和scrollview中lable的内容
            [UIView setAnimationDidStopSelector:@selector(anmationstop)];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
            //设置当前动画的代理
            [UIView setAnimationDelegate:self];
//            根据数据动画改变视图的大小
            backviewcity.frame=CGRectMake(CGRectGetMinX(backviewcity.frame), (ScreenHeight-_backheight)/2.0f, CGRectGetWidth(backviewcity.frame), _backheight);
            upviewcity.frame=CGRectMake(CGRectGetMinX(upviewcity.frame), 0, CGRectGetWidth(upviewcity.frame), _backheight-54*_Scale);

            _scrollview_city.frame=CGRectMake(30*_Scale, 30*_Scale, CGRectGetWidth(upviewcity.frame)-60*_Scale, CGRectGetHeight(upviewcity.frame)-60*_Scale);
            _scrollview_city.contentSize=CGSizeMake(CGRectGetWidth(upviewcity.frame)-60*_Scale, _scrollview_city.contentSize.height);
            [UIView commitAnimations];


        }else
        {
            [[ToolManager sharedManager] alertTitle_Simple:[dict objectForKey:@"message"]];
        }

        [[ToolManager sharedManager] removeProgress];


    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
    }];
    
}
//创建选择州view
-(void)createChooseStateView
{
//    设定当前的状态为2
    _now_state=2;
    UIImageView *backview=(UIImageView*)[self.view viewWithTag:100];
    CGFloat _y_p=(ScreenHeight-485*_Scale)*(2.0f/5.0f);
//创建背景视图
    UIImageView *backview1=[[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(backview.frame)-360*_Scale)/2.0f, _y_p, 360*_Scale, 600*_Scale)];

    backview1.userInteractionEnabled=YES;
//同样为了防止父视图触摸影响自视图操作
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nullAction)];
    [backview1 addGestureRecognizer:tap];
    backview1.tag=201;
    [backview addSubview:backview1];

//    背景view
    UIView *upview=[[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(backview1.frame), 544*_Scale)];
    upview.backgroundColor=[UIColor colorWithRed:65.0f/255.0f green:176.0f/255.0f blue:211.0f/255.0f alpha:1];
    [backview1 addSubview:upview];
//创建所有州按钮
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

//创建scrollview

    UIScrollView *_scrollview=[[UIScrollView alloc] initWithFrame:CGRectMake(10*_Scale, 30*_Scale, CGRectGetWidth(upview.frame)-20*_Scale, CGRectGetHeight(upview.frame)-60*_Scale)];
    _scrollview.backgroundColor=upview.backgroundColor;
    _scrollview.showsVerticalScrollIndicator=YES;
    _scrollview.contentSize=CGSizeMake(_scrollview.frame.size.width, _scrollview.frame.size.height);
    [upview addSubview:_scrollview];
//    请求

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[[NSString alloc] initWithFormat:@"%@%@",DNS,@"/v1/us_states"] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSString *html = operation.responseString;
        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
//请求成功后
        if([[dict objectForKey:@"code"] intValue] ==1)
        {
            //数据呈现
            [stateArr removeAllObjects];
            [stateArr setArray:[dict objectForKey:@"data"]];
//            获取州的真实数据，过滤一些异常数据
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
//            根据州数据的个数来调整scrollview的大小
            _scrollview.contentSize=CGSizeMake(CGRectGetWidth(_scrollview.frame), stateArray.count*42*_Scale);
//创建州的lable
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

                UILabel *label1=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 90*_Scale, CGRectGetHeight(btn.frame))];
                label1.backgroundColor=upview.backgroundColor;
                [label1 setAttributedText:[regular createAttributeString:[stateArray[i] objectForKey:@"short_name"] andFloat:@(1.0)]];
                label1.textColor=[UIColor whiteColor];
                label1.textAlignment=2;
                label1.font=[regular get_en_Font:12.0f];
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

        [[ToolManager sharedManager] removeProgress];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
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
    blockSuccess=^(NSDictionary *_dict)
    {
//        刷新动画收起
        [_tableView headerEndRefreshing];
        [_tableView footerEndRefreshing];
        if(_page==1)
        {
            [_arrayData removeAllObjects];//删除所有数据
        }
//headview背景图url
        if([[_dict objectForKey:@"data"] objectForKey:@"search_bg"]!=[NSNull null])
        {
            if([[_dict objectForKey:@"data"] objectForKey:@"search_bg"]!=nil)
            {

                headviewimage=[[_dict objectForKey:@"data"] objectForKey:@"search_bg"];
            }else
            {
                headviewimage=nil;
            }

        }else
        {
            headviewimage=nil;
        }
//        _headview为nil的时候创建_headview
        if(_headview==nil)
        {
            [self createTableHeadView];
        }

//数据处理，获取模型数组
        NSArray *getdata=[foundModel_new parsingData:_dict];
//        当获取数据count数量大于0时候，刷新tableview

        if(getdata.count>0)
        {
            [_arrayData addObjectsFromArray:getdata];
            [_tableView reloadData];

        }else
        {

            [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"没有更多了" WithImg:@"Prompt_提交成功" Withtype:1]];
        }
    };

}

#pragma mark*获取Parameters参数列表
//获取到筛选到下个界面所需的网络请求参数列表
-(NSMutableDictionary *)getParameters
{

    NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
    NSMutableArray *sexarr=[[NSMutableArray alloc] init];


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

//    total_students_min
//    ap_count_max
//    total_students_max=
//    ap_count_min
    if(total_students_min!=[leftLabel1.text integerValue]||total_students_max!=[rightLabel1.text integerValue]||ap_count_max!=[rightLabel2.text integerValue]||ap_count_min!=[leftLabel2.text integerValue])
    {
        [dict setObject:[[NSString alloc] initWithFormat:@"%@,%@",leftLabel2.text,rightLabel2.text] forKey:@"ap_count"];
        [dict setObject:[[NSString alloc] initWithFormat:@"%@,%@",leftLabel1.text,rightLabel1.text] forKey:@"total_students"];

    }

    
    return dict;
}

#pragma mark-----------------Actions----------------
#pragma mark*三个按钮
#pragma mark**榜单
-(void)bangdanAction:(UIButton *)btn
{
//    榜单跳转到下个页面，榜单的type类型区分不同的榜单
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

        }else if(btn.tag-750==3)
        {
            bangdan.type=4;
        }

        [self.navigationController pushViewController:bangdan animated:YES];
    }
    UIView *backview=[self.view viewWithTag:100];
    [backview removeFromSuperview];
}
#pragma mark*筛选
-(void)subAction:(UIButton *)btn
{
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

//当没有选择筛选条件时，不给予跳转，提示请选择筛选条件。没有选择时，key count为2
    NSArray *keyarr=[_dict allKeys];


    if(keyarr.count>2)
    {
//设定为不是第一次选择，展示选择的内容
        if(_isfirst_choose)
        {
            _isfirst_choose=NO;
        }
        shaiXuanViewController *shaixuan=[[shaiXuanViewController alloc] init];
        shaixuan.data_dict=_dict;
        [self.navigationController pushViewController:shaixuan animated:YES];
    }else
    {
        [[ToolManager sharedManager] alertTitle_Simple:@"请选择筛选条件"];
    }
}
//点击选择城市或州
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
//城市展示动画结束后调用的方法
-(void)anmationstop
{
//    现实选择所有城市btn
    all_city.frame=CGRectMake(0, CGRectGetHeight(backviewcity.frame)-50*_Scale, CGRectGetWidth(backviewcity.frame), 50*_Scale);
    all_city.hidden=NO;
//现实label 的内容
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

        label1.backgroundColor=upviewcity.backgroundColor;

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
//点击所有城市
-(void)cityAction:(UIButton *)btn
{
    if([btn.titleLabel.text isEqualToString:@"所有市"])
    {

        [_city setString:@""];//将记录当前城市的字段置空
        [city_id setString:@""];//将记录当前城市id的字段置空
//        筛选界面城市btn内容改变
        UIButton *_btn=(UIButton *)[self.view viewWithTag:401];
        [_btn setTitle:@"所在市" forState:UIControlStateNormal];
//        设定当前状态为1
        _now_state=1;
//        隐藏城市选择视图
        [[self.view viewWithTag:202] removeFromSuperview];
//        现实筛选视图
        ((UIView *)[self.view viewWithTag:200]).hidden=NO;
    }else
    {
//        当选择城市的时候
//筛选出所选城市和城市ID
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
//        删除原来城市btn
        [[self.view viewWithTag:401] removeFromSuperview];
//在筛选界面添加城市btn（处理异常）
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(chooseLoc:) forControlEvents:UIControlEventTouchUpInside];

        btn.frame=CGRectMake((CGRectGetWidth(downView.frame)-(18+220*2)*_Scale)/2+1*(220+18)*_Scale, (CGRectGetHeight(downView.frame)-46.0f*_Scale)/2.0f, 220*_Scale, 46*_Scale);
        btn.tag=401;
        

        [btn setBackgroundColor:[UIColor colorWithRed:246.0f/255.0f green:246.0f/255.0f blue:246.0f/255.0f alpha:1]];
        btn.titleLabel.font=[regular getFont:11.0f];
        [btn setTitleColor:_define_blue_color forState:UIControlStateNormal];
        [btn setTitle:_city forState:UIControlStateNormal];
        [downView addSubview:btn];
//设定当前状态为1
        _now_state=1;
//删除城市选择view
        [[self.view viewWithTag:202] removeFromSuperview];
//        显示筛选界面
        ((UIView *)[self.view viewWithTag:200]).hidden=NO;

    }

}
-(void)stateAction:(UIButton *)btn
{
    if([btn.titleLabel.text isEqualToString:@"所有州"])
    {
        _now_state=1;
        [_state setString:@""];//将记录当前州的字段置空
        [state_id setString:@""];//将记录当前州id的字段置空
        [_city setString:@""];
        [city_id setString:@""];

        UIButton *_btn=(UIButton *)[self.view viewWithTag:400];
        [_btn setTitle:@"所在州" forState:UIControlStateNormal];
        UIButton *_btn1=(UIButton *)[self.view viewWithTag:401];
        [_btn1 setTitle:@"所在城市" forState:UIControlStateNormal];
//州视图删除
        [[self.view viewWithTag:201] removeFromSuperview];
//        筛选视图显示
        ((UIView *)[self.view viewWithTag:200]).hidden=NO;
    }else
    {
//        州变化时候或者州为空的时候，将所选城市还原
        if(![btn.titleLabel.text isEqualToString:_state]&&![_state isEqualToString:@""])
        {
            UIButton *_btn1=(UIButton *)[self.view viewWithTag:401];
            [_btn1 setTitle:@"所在城市" forState:UIControlStateNormal];
            [_city setString:@""];
            [city_id setString:@""];
        }
//筛选出所选州和州ID
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
//删除原来州btn
        [[self.view viewWithTag:400] removeFromSuperview];
//在筛选界面添加州btn（处理异常）
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(chooseLoc:) forControlEvents:UIControlEventTouchUpInside];

        btn.frame=CGRectMake((CGRectGetWidth(downView.frame)-(18+220*2)*_Scale)/2, (CGRectGetHeight(downView.frame)-46.0f*_Scale)/2.0f, 220*_Scale, 46*_Scale);
        btn.tag=400;

        [btn setBackgroundColor:[UIColor colorWithRed:246.0f/255.0f green:246.0f/255.0f blue:246.0f/255.0f alpha:1]];
        btn.titleLabel.font=[regular getFont:11.0f];
        [btn setTitleColor:_define_blue_color forState:UIControlStateNormal];
        [btn setTitle:_state forState:UIControlStateNormal];
        [downView addSubview:btn];
//将当前状态变为1
        _now_state=1;
//        删除选择州view
        [[self.view viewWithTag:201] removeFromSuperview];
//        显示筛选视图view
        ((UIView *)[self.view viewWithTag:200]).hidden=NO;
    }
}
//将btn的selected状态设为之前保存的状态,1表示selected状态，0反之
-(void)setBtnState
{
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

#pragma mark*设置btn的状态
//btn点击时出发的selected方法
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
#pragma mark*空
//一些空action，处理一些异常
-(void)nullAction{}
#pragma mark*Slider
//slider滑动时候触发的方法，改变下面label的值
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
#pragma mark*蒙板的消失于隐藏
-(void)backview1Action
{
    UIView *backview=nil;
//各种状态的消失与隐藏
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
//删除背景蒙板
-(void)backview1Action__2
{
    [[self.view viewWithTag:100] removeFromSuperview];
}


#pragma mark-----------------SomeDelegate----------------

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


    NSLog(@"%f",scrollView.contentOffset.y);
    CGFloat _height=scrollView.contentOffset.y+CGRectGetHeight(_tableView.frame)-_min_offset-tabbarHeight-420*_Scale;
    NSInteger now_cell=0;
    if(_isPad)
    {
        now_cell=(NSInteger)(_height/((NSInteger)380*_Scale));

    }else
    {
        now_cell=(NSInteger)(_height/190);

    }


    if(now_cell!=_Record_cell_num)
    {
        _Record_cell_num=now_cell;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FoundAnimation" object:[NSNumber numberWithLong:_Record_cell_num]];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FoundAnimation1" object:nil];




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
    self.navigationController.navigationBar.frame=CGRectMake(0, 20, [[UIScreen mainScreen]bounds].size.width, 44);
    rightbtn.alpha=1;
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
    self.navigationController.navigationBar.frame=CGRectMake(0, -24, [[UIScreen mainScreen]bounds].size.width, 44);
    self.navigationItem.titleView.alpha=0;
    rightbtn.alpha=0;
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
    self.navigationController.navigationBar.frame=CGRectMake(0, 20, [[UIScreen mainScreen]bounds].size.width, 44);
    self.navigationItem.titleView.alpha=1;
    _nav_donghua=NO;

    return YES;
}
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
//跳转到搜索页面
        souSuoViewController *sousuo= [[souSuoViewController alloc] init];
        sousuo.keystring=textField.text;
        [self.navigationController pushViewController:sousuo animated:YES];
    }

    return YES;
}
#pragma mark*TableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return foundCellHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if(!bKeyBoardHide)
    {
//        当键盘为出现状态时，触发 键盘消失方法
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];

    }else
    {
//键盘没有出现时候调用
        foundModel_new *model=[_arrayData objectAtIndex:indexPath.row];
        if(model.m_type!=nil)
        {

            if([model.m_type isEqualToString:@"rank"])
            {
//                当cell类型为榜单时候
                if([model.data objectForKey:@"rank_name"]!=nil)
                {
//                    判断点击cell榜单类型
                    if([[model.data objectForKey:@"rank_name"] isKindOfClass:[NSString class]])
                    {

                        if([[model.data objectForKey:@"rank_name"] isEqualToString:@"niche"])
                        {
                            bangdanViewController *bangdan=[[bangdanViewController alloc] init];
                            bangdan.type=1;
                            [self.navigationController pushViewController:bangdan animated:YES];
                        }else if([[model.data objectForKey:@"rank_name"] isEqualToString:@"insider"])
                        {
                            bangdanViewController *bangdan=[[bangdanViewController alloc] init];
                            bangdan.type=2;
                            [self.navigationController pushViewController:bangdan animated:YES];
                        }else if([[model.data objectForKey:@"rank_name"] isEqualToString:@"blue_ribbon"])
                        {
                            bangdanViewController *bangdan=[[bangdanViewController alloc] init];
                            bangdan.type=4;
                            [self.navigationController pushViewController:bangdan animated:YES];
                        }else if([[model.data objectForKey:@"rank_name"] isEqualToString:@"day"]||[[model.data objectForKey:@"rank_name"] isEqualToString:@"boarding"])

                        {
                            [self.navigationController pushViewController:[bangdanlistViewController new] animated:YES];
                        }
                    }
                }

            }else if([model.m_type isEqualToString:@"school"])
            {
//当当前cell类型为school时候
                BOOL _canpush=NO;//判断当前时候满足跳转条件（及schoolID不为空）
                NSString *schoolname=nil;
                NSString *schoolid=nil;

                if([model.data objectForKey:@"school_name_cn"]!=[NSNull null])
                {
                    if([model.data objectForKey:@"school_name_cn"]!=nil)
                    {
                        schoolname=[model.data objectForKey:@"school_name_cn"];
                    }else
                    {
                        schoolname=@"";
                    }
                }else
                {
                    schoolname=@"";
                }

                if([model.data objectForKey:@"school_id"]!=[NSNull null])
                {
                    if([model.data objectForKey:@"school_id"]!=nil)
                    {
                        schoolid=[[NSString alloc] initWithFormat:@"%ld",[[model.data objectForKey:@"school_id"] longValue]];
                        _canpush=YES;
                    }else
                    {
                        schoolid=@"";
                    }
                }else
                {
                    schoolid=@"";
                }

                if(_canpush)
                {

                    SchoolDetailViewController *schoolView=[[SchoolDetailViewController alloc] init];
                    schoolView.data_dict=[[NSDictionary alloc] initWithObjectsAndKeys:schoolname,@"schoolName",schoolid,@"schoolID",nil];

                    [self.navigationController pushViewController:schoolView animated:YES];
                }

            }if([model.m_type isEqualToString:@"city"])
            {
//当前cell为city类型时,当数据类型正确并且城市多余0个的时候允许跳转。
                if([model.data objectForKey:@"city_names"]!=[NSNull null])
                {
                    if([model.data objectForKey:@"city_names"]!=nil)
                    {
                        if([[model.data objectForKey:@"city_names"]isKindOfClass:[NSArray class]])
                        {
                            if([[model.data objectForKey:@"city_names"] count]>0)
                            {
                                 souSuoCitiesViewController *pushctn=[[souSuoCitiesViewController alloc] init];
                                
                                pushctn.cityNameDict=[[NSDictionary alloc] initWithObjectsAndKeys:[model.data objectForKey:@"city_names"],@"city_names",model.title,@"title",nil];
                                [self.navigationController pushViewController:pushctn animated:YES];
                            }
                        }
                        
                    }
                }
            }
            
        }

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
        UITableViewCell *cell=[tableView dequeueReusableHeaderFooterViewWithIdentifier:cellid];
        if(!cell)
        {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
//获取到数据以后
    static NSString *cellid=@"cell_found";
    FoundCell_new *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
    if(!cell)
    {
        cell=[[FoundCell_new alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
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
    [[CustomTabbarController sharedManager] tabbarAppear];
//    友盟页面监控（登出）
    [MobClick beginLogPageView:@"FoundViewController"];

}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    导航栏还原
    _appear=NO;
    _Dragging=NO;
    rightbtn.alpha=1;
    self.navigationController.navigationBar.frame=CGRectMake(0, 20, [[UIScreen mainScreen]bounds].size.width, 44);
    self.navigationItem.titleView.alpha=1;
    _nav_donghua=NO;
//    友盟页面监控（进入）
    [MobClick endLogPageView:@"FoundViewController"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
