//
//  submitSchoolController.m
//  OneBox
//
//  Created by 谢江新 on 15/3/9.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import "submitSchoolController.h"

#import "OnlineProjectsViewController.h"
#import "CustomTabbarController.h"

#import "chooseModel.h"

#define color_gray [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1]

@interface submitSchoolController ()

@end

@implementation submitSchoolController
{
    NSMutableDictionary *data_dict_must;
    NSArray *titleArr;

    YYAnimationIndicator *indicator;
    CGFloat _scroll_height;
    UIView *colview;
    NSInteger *follow_schools_count;
    NSMutableArray *cardArray;
    UIButton *open_manage_btn;
    BOOL _isopen;
    NSMutableArray *AdmitCoutArr;
    UIView *headview;
    UIScrollView *_scrollView;
    UIButton *_nextBtn;
    NSInteger admit_cout;

    NSMutableArray *dataArray;
    NSArray *titleArray;
    NSMutableArray *_btnArray;
    NSDictionary *data_dict;
    CGFloat interval_max;
    CGFloat radius;

    CGFloat __y_p;
     void (^block)();
    NSInteger request_count;
    BOOL isshow;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareData];
    [self createScrollView];
    
    if(!indicator){
        indicator = [[YYAnimationIndicator alloc] initWithFrame:CGRectZero];
        [self.view addSubview:indicator];
        [indicator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.view);
            make.width.height.mas_equalTo(40*_Scale*2);
        }];
        [indicator setLoadText:@"loading..."];
    }
    [indicator startAnimation];
    [self getData];
    [self getmustData];

    // Do any additional setup after loading the view from its nib.
}
-(void)getmustData
{

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameters=@{@"token":[regular getToken]};
    [manager GET:[[NSString alloc] initWithFormat:@"%@%@",DNS,@"/v1/users/show_apply_documents"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *html = operation.responseString;
        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
        if([[dict objectForKey:@"code"] integerValue]==1)
        {
            request_count++;

            [data_dict_must setDictionary:[[dict objectForKey:@"data"] objectForKey:@"documents"]];

            if([[data_dict_must objectForKey:@"is_open"] integerValue]==1)
            {
                _isopen=YES;
            }else
            {
                _isopen=NO;
            }

            if(request_count==2)
            {
                 [indicator stopAnimationWithLoadText:@"loading..." withType:YES];
                [self UIConfig];
            }
        }else
        {
             [indicator stopAnimationWithLoadText:@"loading..." withType:YES];
             [[ToolManager sharedManager] alertTitle_Simple:[dict objectForKey:@"message"]];
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(isshow==NO)
        {
            [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
            isshow=YES;

        }
         [indicator stopAnimationWithLoadText:@"loading..." withType:YES];
    }];
}
-(void)getData
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameters=@{@"token":[regular getToken]};
    NSString *str=[NSString stringWithFormat:@"%@/v1/order_schools",DNS];

    [manager GET:str parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSString *html = operation.responseString;
        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
        data_dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];

        if([[data_dict objectForKey:@"code"] integerValue]==1)
        {

            request_count++;
            [dataArray setArray:[chooseModel parsingWithJsonDataForModel:data_dict]];
            follow_schools_count=[[[data_dict objectForKey:@"data"] objectForKey:@"follow_schools_count"] integerValue];
            [self getAdmitCout];
            if(request_count==2)
            {
                [self UIConfig];
                [indicator stopAnimationWithLoadText:@"loading..." withType:YES];
            }
        }else
        {
             [indicator stopAnimationWithLoadText:@"loading..." withType:YES];
             [[ToolManager sharedManager] alertTitle_Simple:[data_dict objectForKey:@"message"]];
        }



    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(isshow==NO)
        {
            [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
            isshow=YES;

        }
         [indicator stopAnimationWithLoadText:@"loading..." withType:YES];
    }];
    
}
//返回录取数量
-(void)getAdmitCout
{
//    NSArray *array=[[data_dict objectForKey:@"data"] ]
    for (chooseModel *model in dataArray) {
        if(model.step_no>=2)
        {
            admit_cout++;
        }
        [AdmitCoutArr addObject:[NSNumber numberWithInteger:model.step_no]];
    }
}
-(void)prepareData
{
    isshow=NO;
    _scroll_height=0;
    cardArray=[[NSMutableArray alloc] init];
    _isopen=NO;
    data_dict_must=[[NSMutableDictionary alloc] init];

//
    titleArr=@[@"school_apply_table",@"passport",@"diploma",@"test_report",@"school_reports",@"study_reports",@"bank_savings",@"is_reading",@"recommend_letter"];



    request_count=0;
    AdmitCoutArr=[[NSMutableArray alloc] init];
    admit_cout=0;
    _btnArray=[[NSMutableArray alloc] init];

    titleArray=@[@"递申",@"面试",@"录取",@"缴费",@"I20"];

    self.view.backgroundColor=_define_backview_color;
    dataArray=[[NSMutableArray alloc] init];
}


-(void)openManageAct:(UIButton *)btn
{
    JXLOG(@"%d",_isopen);
    if(!_isopen)
    {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        NSMutableDictionary *parameters=[[NSMutableDictionary alloc] init];
        [parameters setObject:[regular getToken] forKey:@"token"];
        JXLOG(@"titleArr=%@",titleArr);
        for (int i=0; i<titleArr.count; i++) {

                [parameters setObject:[data_dict_must objectForKey:titleArr[i]] forKey:titleArr[i]];

        }
        [parameters setObject:@"1" forKey:@"is_open"];
        [manager PUT:[[NSString alloc] initWithFormat:@"%@%@",DNS,@"/v1/users/update_apply_documents"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *html = operation.responseString;
            NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
            if([[dict objectForKey:@"code"] integerValue]==1)
            {


                _isopen=YES;
//                if(!_isopen)
                    colview.hidden=NO;
//                }else
//                {
//                    colview.hidden=NO;
//
//                }
                _scrollView.contentSize=CGSizeMake(ScreenWidth, _scroll_height+100*_Scale-170*_Scale);
                [self createNextBtn];

                [UIView beginAnimations:@"anmationName" context:nil];
                //设置动画的时间间隔（从动画开始到结束所用时间）
                [UIView setAnimationDuration:1];
                //设置当前动画的代理
                [UIView setAnimationDelegate:self];
                //        [UIView setAnimationDidStopSelector:@selector(anmationStop)];

                open_manage_btn.frame=CGRectMake(CGRectGetMinX(open_manage_btn.frame), CGRectGetMinY(open_manage_btn.frame), CGRectGetWidth(open_manage_btn.frame), 0);
                [open_manage_btn.titleLabel setFont:[regular getFont:0.0f]];
                [open_manage_btn setTitle:@"" forState:UIControlStateNormal];
                for (int i=0; i<cardArray.count; i++) {
                    UIView *card=cardArray[i];
                    card.hidden=NO;
                    card.frame=CGRectMake(CGRectGetMinX(card.frame), CGRectGetMinY(card.frame)-170*_Scale, CGRectGetWidth(card.frame), CGRectGetHeight(card.frame));

                }
                colview.frame=CGRectMake(CGRectGetMinX(colview.frame), CGRectGetMinY(colview.frame)-170*_Scale, CGRectGetWidth(colview.frame), CGRectGetHeight(colview.frame));


                [UIView commitAnimations];
                

            }else
            {
               [[ToolManager sharedManager] alertTitle_Simple:[dict objectForKey:@"message"]];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
        }];


    }

}
//-(void)anmationStop
//{
//    [UIView beginAnimations:@"anmationName" context:nil];
//    //设置动画的时间间隔（从动画开始到结束所用时间）
//    [UIView setAnimationDuration:1];
//    //设置当前动画的代理
//    [UIView setAnimationDelegate:self];
//    [UIView setAnimationDidStopSelector:@selector(anmationStop)];
//    [open_manage_btn removeFromSuperview];

//    [UIView commitAnimations];

//}
-(UIView *)createOpenManageBtn
{
    open_manage_btn=[UIButton buttonWithType:UIButtonTypeCustom];
    [_scrollView addSubview:open_manage_btn];

    [open_manage_btn.titleLabel setFont:[regular getFont:17.0f]];
    open_manage_btn.backgroundColor=[UIColor whiteColor];
    [open_manage_btn addTarget:self action:@selector(openManageAct:) forControlEvents:UIControlEventTouchUpInside];
    [open_manage_btn setTitleColor:_define_blue_color forState:UIControlStateNormal];

    if(!_isopen)
    {

        open_manage_btn.frame=CGRectMake(8*_Scale, 10*_Scale, CGRectGetWidth(_scrollView.frame)-8*_Scale*2, 160*_Scale);
        [open_manage_btn setTitle:@"开启申请状态自我管理" forState:UIControlStateNormal];
        [open_manage_btn.titleLabel setAttributedText:[regular createAttributeString:@"开启申请状态自我管理" andFloat:@(6.0)]];
    }else
    {
        open_manage_btn.frame=CGRectMake(8*_Scale, 10*_Scale, CGRectGetWidth(_scrollView.frame)-8*_Scale*2, 0);

    }
    
    return open_manage_btn;
}
-(UIView *)createcolnumView:(UIView *)view
{
    colview=[[UIView alloc] initWithFrame:CGRectMake(8*_Scale, CGRectGetMaxY(view.frame)+10*_Scale, CGRectGetWidth(_scrollView.frame)-16*_Scale, 242*_Scale)];
    colview.backgroundColor=[UIColor whiteColor];
    [_scrollView addSubview:colview];
    if(!_isopen)
    {
        colview.hidden=YES;
    }else
    {
        colview.hidden=NO;

    }

// r 144 i 70 y_p 30
    CGFloat interval=(CGRectGetWidth(colview.frame)-120*_Scale*3-70*_Scale*2)/2.0f;
    NSArray *arr_title=@[@"心愿",@"目标",@"录取"];
    NSArray *arr_num=@[
                       [[NSString alloc] initWithFormat:@"%lu",(unsigned long)follow_schools_count],
                       [[NSString alloc] initWithFormat:@"%lu",(unsigned long)dataArray.count],
                       [[NSString alloc] initWithFormat:@"%ld",(long)admit_cout]];

    for (int i=0; i<arr_num.count; i++) {

        UIImageView *titleImage=[[UIImageView alloc] initWithFrame:CGRectMake(70*_Scale+(120*_Scale+interval)*i, 30*_Scale, 120*_Scale, 120*_Scale)];
//        titleImage.backgroundColor=[UIColor redColor];
        titleImage.image=[UIImage imageNamed:@"user_info_黑色圆圈"];
        //    [_view_StuGrade addSubview:titleImage];

        UILabel *labelImage=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120*_Scale, 120*_Scale)];
        if(i==arr_num.count-1)
        {
            labelImage.tag=200;

        }

        labelImage.text=arr_num[i];
        labelImage.textAlignment=1;
        labelImage.font=[regular get_en_Font:29.0f];
        labelImage.textColor=_define_blue_color;
        [titleImage addSubview:labelImage];
        [colview addSubview:titleImage];
        UILabel *labeltitle=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(titleImage.frame)+3, CGRectGetMaxY(titleImage.frame), CGRectGetWidth(titleImage.frame), CGRectGetHeight(colview.frame)-CGRectGetMaxY(titleImage.frame))];
        [labeltitle setAttributedText:[regular createAttributeString:arr_title[i] andFloat:@(6.0)]];
//        labeltitle.backgroundColor=[UIColor redColor];

        labeltitle.textColor=[UIColor colorWithRed:222.0f/255.0f green:222.0f/255.0f blue:222.0f/255.0f alpha:1];
        labeltitle.textAlignment=1;
        labeltitle.font=[regular getFont:17.0f];
        [colview addSubview:labeltitle];
    }
    JXLOG(@"111");
    return colview;

}
-(void)UIConfig
{

    UIView *view1=[self createOpenManageBtn];
    UIView *view2=[self createcolnumView:view1];
    _scroll_height=[self createCard:CGRectGetMaxY(view2.frame)+55*_Scale];

    if(_isopen)
    {
        _scrollView.contentSize=CGSizeMake(ScreenWidth, _scroll_height+100*_Scale);
    }else
    {
        _scrollView.contentSize=CGSizeMake(ScreenWidth, CGRectGetMaxY(view1.frame));
    }

    if(dataArray.count==0)
    {

        if(_isopen)
        {
            [self createNextBtn];

        }else
        {
            _scrollView.contentSize=CGSizeMake(ScreenWidth, ScreenHeight-64);
        }

    }else
    {

        if(_isopen)
        {
            [self createNextBtn];

        }
    }
}


-(void)createNextBtn
{


    _nextBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    CGRect _rect;
    if(dataArray.count==0)
    {

//        _scrollView.contentSize=CGSizeMake(ScreenWidth, ScreenHeight-64);
        _rect=CGRectMake(8*_Scale, _scrollView.contentSize.height-100*_Scale, _scrollView.contentSize.width-8*_Scale*2, 70*_Scale);

    }else
    {
        _rect=CGRectMake(8*_Scale, _scrollView.contentSize.height-100*_Scale, _scrollView.contentSize.width-8*_Scale*2, 70*_Scale);
    }
    _nextBtn.frame=_rect;
    NSString *nexttitle=nil;
    UIColor *nextcolor=nil;
    if(self.step>=2)
    {
        nexttitle=@"取消完成";
        nextcolor=[UIColor colorWithRed:242/255.0 green:107/255.0 blue:85/255.0 alpha:1.0];

        //
    }else
    {
        nexttitle=@"确认完成";
        nextcolor=[UIColor colorWithRed:51.0f/255.0f green:204.0f/255.0f blue:204.0f/255.0f alpha:1];
    }
    [_nextBtn setBackgroundColor:nextcolor];
    JXLOG(@"%f %f",_nextBtn.frame.origin.y,ScreenHeight);
    [_nextBtn setTitle:nexttitle forState:UIControlStateNormal];
    _nextBtn.titleLabel.font=[regular getFont:12.0f];
    [_nextBtn.titleLabel setAttributedText:[regular createAttributeString:nexttitle andFloat:@(3)]];
    [_nextBtn addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
    [_nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_scrollView addSubview:_nextBtn];
//    _scrollView.contentSize=CGSizeMake(_scrollView.contentSize.width, CGRectGetMaxY(_nextBtn.frame));

}
-(void)nextAction:(UIButton *)btn
{



    if(self.step>=2)
    {
        //        取消
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSString *Url = [NSString stringWithFormat:@"%@/v1/user_boxes/cancel?token=%@",DNS,[regular getToken]];
        NSDictionary *dict=@{@"name":@"apply_school"};
        [manager POST:Url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *html = operation.responseString;
            NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
            //        进行解析以后的操作
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            if([[dict objectForKey:@"code"] integerValue]==1)
            {

                self.block(@"submit",NO);
                [[NSNotificationCenter defaultCenter] postNotificationName:@"updataBox" object:nil];

            }else
            {
                 [[ToolManager sharedManager] alertTitle_Simple:[dict objectForKey:@"message"]];
            }


        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
            JXLOG(@"失败");
        }];



    }else
    {
        //        完成
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSString *Url = [NSString stringWithFormat:@"%@/v1/user_boxes/%@?token=%@",DNS,[regular getUID],[regular getToken]];
        NSDictionary *dict=@{@"name":@"apply_school"};
        [manager PUT:Url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *html = operation.responseString;
            NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
            //        进行解析以后的操作
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            if([[dict objectForKey:@"code"] integerValue]==1)
            {

                self.block(@"submit",YES);
                [[NSNotificationCenter defaultCenter] postNotificationName:@"updataBox" object:nil];

            }else
            {
                 [[ToolManager sharedManager] alertTitle_Simple:[dict objectForKey:@"message"]];
            }

            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
            JXLOG(@"失败");
        }];
        
    }

}
-(CGFloat)createCard:(CGFloat )_y_p
{
    
    for (int i=0; i<dataArray.count; i++) {
        UIView *__view=[self customCard:dataArray[i] WithYp:_y_p WithIndex:i];
        _y_p+=CGRectGetHeight(__view.frame)+55*_Scale;
        [cardArray addObject:__view];
        [_scrollView addSubview:__view];
    }

    return _y_p;

}
-(UIView *)customCard:(chooseModel *)model WithYp:(CGFloat )ypoint WithIndex:(NSInteger )index
{
    
    UIView *_card=[[UIView alloc] initWithFrame:CGRectMake(8*_Scale, ypoint, ScreenWidth-16*_Scale, 307*_Scale)];
    _card.backgroundColor=self.view.backgroundColor;
    if(!_isopen)
    {
        _card.hidden=YES;
    }else
    {
        _card.hidden=NO;
    }

    UIView *_upview=[[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_card.frame), 200*_Scale)];
    _upview.backgroundColor=[UIColor whiteColor];
    [_card addSubview:_upview];
    UIImageView *imageview=[[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(_card.frame)-65*_Scale)/2.0f, -65*_Scale/2.0f, 65*_Scale, 65*_Scale)];
    imageview.image=[UIImage imageNamed:@"box_choose_圆点"];
    UILabel *labelcon=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(imageview.frame), CGRectGetHeight(imageview.frame)-5*_Scale)];
    labelcon.textAlignment=1;
    labelcon.textColor=[UIColor whiteColor];
    labelcon.font=[regular get_en_Font:25.0f];
    labelcon.text=[[NSString alloc] initWithFormat:@"%ld",index+1];
    [imageview addSubview:labelcon];
    [_upview addSubview:imageview];
    
    CGFloat _height=(CGRectGetHeight(_upview.frame)-50*_Scale)/3;
    CGFloat _y_p=40*_Scale;
    for (int i=0; i<3; i++) {
        NSString *title=i==0?model.en_name:i==1?model.cn_name:[[NSString alloc] initWithFormat:@"%@年",model.setup_year];
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0,_y_p, CGRectGetWidth(_upview.frame), _height)];
        if(i==0)
        {
            label.font=[regular get_en_Font:15.0f];
            [label setAttributedText:[regular createAttributeString:title andFloat:@(1.0)]];
        }else if(i==1)
        {
            label.font=[regular getFont:13.0f];
            label.text=title;
        }else
        {
             label.font=[regular get_en_Font:11.5f];
            [label setAttributedText:[regular createAttributeString:title andFloat:@(1.0)]];
        }


//        label.text=title;
        label.textAlignment=1;
        label.textColor=_define_blue_color;
        _y_p+=_height;
        [_upview addSubview:label];
    }

    
    UIView *_downView=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_upview.frame)+1, CGRectGetWidth(_card.frame), CGRectGetHeight(_card.frame)-CGRectGetMaxY(_upview.frame))];
    _downView.backgroundColor=[UIColor whiteColor];
    [_card addSubview:_downView];
    

    
    radius=CGRectGetWidth(_card.frame)/5;
//    interval_max=(CGRectGetWidth(_card.frame)-radius*5)/6;

//    __y_p=(CGRectGetHeight(_downView.frame)-radius)/2;
    NSMutableArray *btnArray=[[NSMutableArray alloc] init];
    CGFloat _x_p=0;

    for (int i=0; i<5; i++) {


        
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];

        btn.tag=index*10+i;
        
        btn.frame=CGRectMake(i*radius, 0, radius, CGRectGetHeight(_downView.frame));

        btn.titleLabel.font=[regular getFont:14.0f];


        [btn setTitle:titleArray[i] forState:UIControlStateNormal];


        UIColor *_color=nil;



        [btn setTitleColor:[UIColor colorWithRed:248.0f/255.0f green:195.0f/255.0f blue:70.0f/255.0f alpha:1] forState:UIControlStateSelected];

        [btn setBackgroundImage:[UIImage imageNamed:@"box_progress_select"] forState:UIControlStateSelected];
        if(model.step_no==-1)
        {
            _color=color_gray;
            [btn setBackgroundImage:[UIImage imageNamed:@"box_progress_gray"] forState:UIControlStateNormal];
//            imageName=@"box_ progress_灰色圆点";
        }else
        {
            if(i==model.step_no)
            {
                btn.selected=YES;
                _color=_define_blue_color;
                [btn setBackgroundImage:[UIImage imageNamed:@"box_progress_gray"] forState:UIControlStateNormal];


//                imageName=@"box_ progress_红色圆点";

            }else if(i<model.step_no)
            {

                _color=_define_blue_color;
                [btn setBackgroundImage:[UIImage imageNamed:@"box_progress_normal"] forState:UIControlStateNormal];
//                imageName=@"box_ progress_绿色圆点";
            }else
            {
               _color=color_gray;
                [btn setBackgroundImage:[UIImage imageNamed:@"box_progress_gray"] forState:UIControlStateNormal];
            }
        }
        [btn setTitleColor:_color forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_downView addSubview:btn];
        [btnArray addObject:btn];
        _x_p+=radius;
        
    }
    [_btnArray addObject:btnArray];
    
    
    return _card;
}
-(void)btnAction:(UIButton *)btn
{
    NSInteger _index=btn.tag/10;
    NSInteger _num=btn.tag%10;

    chooseModel *model=dataArray[_index];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameters=@{@"token":[regular getToken],@"step_no":[NSNumber numberWithInteger:_num]};

    [manager PUT:[[NSString alloc] initWithFormat:@"%@%@%@",DNS,@"/v1/order_schools/",model.goal_id] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *html = operation.responseString;
        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
        if([[dict objectForKey:@"code"] integerValue]==1)
        {
            NSArray *_array=(NSArray *)_btnArray[_index];
            for (UIButton *btn in _array) {
                btn.selected=NO;
            }

            for (int i=0; i<_array.count; i++) {

                UIButton *btn=_array[i];

//                NSString *imageName=nil;
                UIColor *_color=nil;
                if(i==_num)
                {
                    _color=_define_blue_color;
                    btn.selected=YES;
                    [btn setBackgroundImage:[UIImage imageNamed:@"box_progress_gray"] forState:UIControlStateNormal];
//                    imageName=@"box_ progress_红色圆点";

                }else if(i<_num)
                {
                    _color=_define_blue_color;
                    [btn setBackgroundImage:[UIImage imageNamed:@"box_progress_normal"] forState:UIControlStateNormal];

//                    imageName=@"box_ progress_绿色圆点";
                }else
                {
                    _color=color_gray;
                    [btn setBackgroundImage:[UIImage imageNamed:@"box_progress_gray"] forState:UIControlStateNormal];
//                    imageName=@"box_ progress_灰色圆点";
                }

                [btn setTitleColor:_color forState:UIControlStateNormal];
//                [btn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];

            }

            UILabel *label=(UILabel *)[self.view viewWithTag:200];
            NSInteger _stepnum=[AdmitCoutArr[_index]integerValue];
            if(!((_num==2)&&(_stepnum==2)))
            {
                if((_num>1)&&(_stepnum<2))
                {
//                    JXLOG(@"_num=%d",_num);
//                     JXLOG(@"_stepnum=%d",_stepnum);

                    admit_cout++;
                    AdmitCoutArr[_index]=[NSNumber numberWithInteger:_num];

                }else if((_num<2)&&(_stepnum>1))
                {
//                    JXLOG(@"_num=%d",_num);
//                    JXLOG(@"_stepnum=%d",_stepnum);
                    admit_cout--;
                    AdmitCoutArr[_index]=[NSNumber numberWithInteger:_num];
                }

            }else
            {

            }
           label.text=[[NSString alloc] initWithFormat:@"%ld",(long)admit_cout];

        }else
        {
             [[ToolManager sharedManager] alertTitle_Simple:[dict objectForKey:@"message"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
    }];

    
}
-(void)createScrollView
{
    _scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64-100*_Scale)];
    _scrollView.contentSize=CGSizeMake(ScreenWidth, ScreenHeight);
    _scrollView.backgroundColor=self.view.backgroundColor;
    
    _scrollView.showsVerticalScrollIndicator=YES;
    [self.view addSubview:_scrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"submitSchoolController"];

}
-(void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"submitSchoolController"];

     [[CustomTabbarController sharedManager] tabbarHide];
}

@end
