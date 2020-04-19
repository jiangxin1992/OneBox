//
//  SchoolCommentController.m
//  OneBox
//
//  Created by 谢江新 on 15-2-2.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import "SchoolCommentController.h"

#import "HttpRequestManager.h"

#import "LoginViewController.h"

#import "comment_cell.h"

#import "Tools.h"
#import "MyInfo.h"
#import "comment_model_alter.h"

#import <objc/runtime.h>
static void *EOCAlertViewKey = "EOCAlertViewKey";

//评论的view的高度（发表评论）
#define commentHeight 70*_Scale

@interface SchoolCommentController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UITextFieldDelegate,UITextViewDelegate>
{

    UIView *nocomment;

    YYAnimationIndicator *indicator;

//     用于获得评论请求时。表示从哪个评论开始
    NSInteger _start;
//    该学校被评论的数量
    NSInteger _comment_count;
    
//    用于存放model的数组（为cell的model）
    NSMutableArray *_data_array;
//    用于存放各个cell高度的始祖
    NSMutableArray *_height_array;

//    存放赞按钮的数组
    NSMutableArray *_praise_array;

//    用户block回调时。表示当前触发的cell
    NSInteger alternum;
//    判断是否是第一次出现
//    BOOL _isCreate;
    
//    tableview

//    评论框的背景view
    UIView *_commentview;
//    评论框
    UITextField *_commentField;
    UITextView *_commentField1;
    
    UIImageView *imageGray;

    NSInteger _nownum;

}
@end

@implementation SchoolCommentController

-(void)createNocommentview
{
    nocomment=[[UIView alloc] initWithFrame:CGRectMake((ScreenWidth-200*_Scale)/2.0f, (ScreenHeight-kTabBarHeight-64-200*_Scale)/2.0f, 200*_Scale, 200*_Scale)];

    [_tableView addSubview:nocomment];
    UIImageView *img=[[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(nocomment.frame)-110*_Scale)/2.0f, 0, 110*_Scale, 107*_Scale)];
    img.image=[UIImage imageNamed:@"comment_nocomment"];
    [nocomment addSubview:img];
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(img.frame), CGRectGetWidth(nocomment.frame), CGRectGetHeight(nocomment.frame)-CGRectGetMaxY(img.frame))];
    //    label.backgroundColor=[UIColor cyanColor];
    [nocomment addSubview:label];
    label.textAlignment=1;
    label.font=[regular getFont:13.0f];
    label.textColor=[UIColor colorWithRed:204.0f/255.0f green:204.0f/255.0f blue:204.0f/255.0f alpha:1];
    label.text=@"还没有评论";
    if(_data_array.count>0)
    {
        nocomment.hidden=YES;
    }else
    {
        nocomment.hidden=NO;
    }
}
- (void)handleSwipes:(UISwipeGestureRecognizer *)sender
{
    if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    self.rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:self.rightSwipeGestureRecognizer];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(other) name:@"other" object:nil];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    UIBarButtonItem *_btn=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回箭头"] style:UIBarButtonItemStylePlain target:self action:@selector(popviewAction)];
    self.navigationItem.titleView=[regular returnNavView:@"评论" withmaxwidth:230];
    self.navigationItem.leftBarButtonItem=_btn;
//    准备数据
    [self prepareData];
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
//    加载数据（下载评论）
    [self loadData1];
//    创建监听
    [self createNotification];
//    创建blcok
    [self my_block];
}
-(void)other
{
    [self dismissModalViewControllerAnimated:YES];
}
-(void)popviewAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)prepareData
{
    _nownum=0;
    _islogin=YES;
    alternum=0;

    _start=0;
    self.view.backgroundColor=_define_white_color;
    _data_array=[[NSMutableArray alloc] init];
    _height_array=[[NSMutableArray alloc] init];
    
}
-(void)login_action
{
    LoginViewController*login=[[LoginViewController alloc] init];
    login.type=@"other";
    [self.navigationController pushViewController:login animated:YES];
}

//用于方法的回调，通过点击cell中的删除或者点赞触发block
//进行cell的删除或者点赞的动作
-(void)my_block
{
    WeakSelf(ws);
    changeBlock=^(NSNumber *rownum,NSInteger type)
    {
        NSInteger _num=[rownum integerValue];
        
        if(type==0)
        {
            //             删除
            UIAlertView *isdelete=[[UIAlertView alloc] initWithTitle:nil message:@"是否删除评论" delegate:ws cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes",nil];
            isdelete.delegate = ws;
            void (^alertViewBlock)(NSInteger) = ^(NSInteger buttonIndex){
                if(buttonIndex==1)
                {
                    //            删除数据
                    [ws removData];
                }
            };
            objc_setAssociatedObject(isdelete, EOCAlertViewKey, alertViewBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
            [isdelete show];
            alternum=_num;

        }else if (type==4)
        {
            if(![regular isLogin])
            {
                [ws login_action];

            }else
            {
                _nownum=[rownum integerValue];
            }

        }else if(type==10)
        {
            [ws login_action];
        }
        else
        {
            comment_model_alter *model=_data_array[_num];
            NSInteger _parise_n=model.votes_count ;
            BOOL isparise=NO;
            NSString *__url=nil;
            NSString *alterTitle=nil;
            NSString *showtitle=nil;
            NSString *showimg=nil;
            if(type==1)
            {
                __url=@"/v1/votes/cancel";
                alterTitle=@"取消赞中";
                _parise_n--;
                //                取消赞
                isparise=NO;
                showtitle=@"已取消点赞";
                showimg=@"Prompt_已取消点赞";
            }else
            {
                __url=@"/v1/votes";
                alterTitle=@"点赞中";
                //                点赞
                _parise_n++;
                isparise=YES;
                showtitle=@"已点赞";
                showimg=@"Prompt_已点赞";
            }

            [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:showtitle WithImg:showimg Withtype:1]];

            model.votes_count=_parise_n;
            model.had_voted=isparise;

            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            NSDictionary *parameters = @{@"token":[regular getToken],@"voteable_id":model.comment_id,@"voteable_type":@"comment"};
            [manager POST:[[NSString alloc] initWithFormat:@"%@%@",DNS,__url] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSString *html = operation.responseString;
                NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
                if([[dict objectForKey:@"code"] integerValue]==1)
                {
                    JXLOG(@"111");
                }else
                {
                     [[ToolManager sharedManager] alertTitle_Simple:[dict objectForKey:@"message"]];
                }

            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
            }];
        }
        
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:_num inSection:0];
        
        [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    };

}
-(void)backaction:(UIGestureRecognizer *)ges{}

-(void)closeBtn:(UIButton *)btn
{
    [imageGray removeFromSuperview];
}
//给键盘加上监听，捕获他的隐藏和显示
- (void)createNotification
{
//    UIKeyboardWillShowNotification这个通知在软键盘弹出时由系统发送
//    UIKeyboardWillShowNotification 通知：键盘将要显示的通知
//    在通知中心中添加监测对象，当该对象受到UIKeyboardWillShowNotification的通知时，会调用参数二所代表的方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
//键盘将要隐藏时调用的方法
//将底部的评论 view，根据键盘的变化而变化
- (void)keyboardWillHide:(NSNotification *)not
{
    [_commentField1 resignFirstResponder];
}
//键盘将要出现时调用的方法
//将底部的评论 view，根据键盘的变化而变化
- (void)keyboardWillShow:(NSNotification *)not
{
    [_commentField1 becomeFirstResponder];
}

#pragma mark-alertView代理方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    void (^alertViewBlock)(NSInteger) = objc_getAssociatedObject(alertView, EOCAlertViewKey);
    alertViewBlock(buttonIndex);
}
//进行评论内容的删除（如果是用户自己评论的内容）。
//前面已经作出判断，是否为当前用户所发表内容
//如果不是当前用户发表的评论，则不会显示删除，是则显示
-(void)removData
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"token": [regular getToken]};
    comment_model_alter *model= _data_array[alternum];
    NSString *_id=model.comment_id ;

    [manager DELETE:[[NSString alloc] initWithFormat:@"%@%@%@",DNS,@"/v1/comments/",_id] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *html = operation.responseString;
        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *_dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
        if([[_dict objectForKey:@"code"] integerValue]==1)
        {
            [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"删除成功" WithImg:@"Prompt_删除" Withtype:1]];
            _comment_count--;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"changenum" object:[NSNumber numberWithInteger:_comment_count]];
            //            进行完数据准备工作后，进行ui的布局，各视图的创建
            [self loadData1];
        }else
        {
             [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:[_dict objectForKey:@"message"] WithImg:@"Prompt_网络出错白色" Withtype:1]];
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
    }];


}

//创建各个视图
-(void)UIConfig
{
    //    创建底部发表评论的view
    _commentview=[UIView getCustomViewWithColor:_define_backview_color];
    [self.view addSubview:_commentview];
    [_commentview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(commentHeight);
        make.bottom.mas_equalTo(self.mas_bottomLayoutGuideTop).with.offset(0);
    }];

    //    创建textfield，用于填写评论
    //    并将_commentField放在_commentview上
    CGFloat _y_p=-1*_Scale+(commentHeight-52*_Scale)/2.0f;
    _commentField=[[UITextField alloc] initWithFrame:CGRectMake(10*_Scale, _y_p,ScreenWidth-20*_Scale , 52*_Scale)];
    UIView *signBoard=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 280*_Scale + (kIPhoneX?34.f:0.f))];

    //200  65 14
    _commentField1=[[UITextView alloc] initWithFrame:CGRectMake(14*_Scale, 65*_Scale  ,ScreenWidth-28*_Scale , 200*_Scale)];
    _commentField1.returnKeyType=UIReturnKeyDefault;
    _commentField1.delegate=self;
    _commentField1.font=[regular getFont:14.0f];
    _commentField1.textColor=[UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1];
    [signBoard addSubview:_commentField1];
    signBoard.backgroundColor=_define_backview_color;
    UIButton *cancel=[UIButton buttonWithType:UIButtonTypeCustom];
    //    cancel.backgroundColor=[UIColor redColor];
    cancel.frame=CGRectMake(0, 0, 136*_Scale, 65*_Scale);
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    cancel.titleLabel.font=[regular getFont:13.0f];
    [cancel setTitleColor:_define_blue_color forState:UIControlStateNormal];
    [cancel addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [signBoard addSubview:cancel];


    UIButton *send=[UIButton buttonWithType:UIButtonTypeCustom];
    send.frame=CGRectMake(CGRectGetWidth(signBoard.frame)-136*_Scale, 0,136*_Scale , 65*_Scale);
    //    send.backgroundColor=[UIColor redColor];
    [send setTitle:@"发送" forState:UIControlStateNormal];
    send.titleLabel.font=[regular getFont:13.0f];
    [send setTitleColor:_define_blue_color forState:UIControlStateNormal];
    [send addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
    [signBoard addSubview:send];

#pragma mark -键盘上加view
    _commentField.inputAccessoryView = signBoard;
    _commentField.clearButtonMode = UITextFieldViewModeAlways;
    _commentField.leftViewMode=UITextFieldViewModeAlways;
    _commentField.leftView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 40*_Scale, CGRectGetHeight(_commentField.frame))];
    _commentField.returnKeyType=UIReturnKeyDefault;
    _commentField.borderStyle= UITextBorderStyleNone;

    _commentField.placeholder=@"撰 写 您 的 评 论 。";
    _commentField.delegate=self;
    _commentField.background=[UIImage imageNamed:@"comment_搜索框搜索框"];
    _commentField.font=[regular getFont:10.5f];
    [_commentview addSubview:_commentField];
    //    _commentview.backgroundColor=[UIColor redColor];
    UIView *view_qufen=[[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(signBoard.frame), 1*_Scale)];
    view_qufen.backgroundColor=[UIColor colorWithRed:190.0f/255.0f green:190.0f/255.0f blue:190.0f/255.0f alpha:1];
    [signBoard addSubview:view_qufen];
    //    _commentField.backgroundColor=[UIColor whiteColor];

//    将_isCreate设为yes，用于controller再次出现时调整_tableview的位置
//    _isCreate=YES;
//    创建_tableView
    _tableView=[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.bottom.mas_equalTo(_commentview.mas_top).with.offset(0);
    }];
    _tableView.backgroundColor=_define_backview_color;
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.showsVerticalScrollIndicator=YES;

//    加上tap
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(return_KeyBoard)];
    [_tableView addGestureRecognizer:tap];
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;

    UIView *headView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20*_Scale)];
    headView.backgroundColor=_define_backview_color;
    _tableView.tableHeaderView=headView;

    [self createNocommentview];
}
-(void)sendAction
{
    _commentField.text=_commentField1.text;

    if(![regular isLogin])
    {
//        comment_alertview=[[ToolManager sharedManager] alertTitle_Simple:@"You are not logged in, please login first."];
//        comment_alertview.delegate=self;
        [self login_action];
    }else if([_commentField1.text isEqualToString:@""])
    {
        [[ToolManager sharedManager] alertTitle_Simple:@"请输入评论内容"];
    }else
    {
        //发送评论
        [self sendComment];


    }

    [_commentField1 resignFirstResponder];

}
-(void)cancelAction
{
    [regular dismissKeyborad];
    _commentField.text=_commentField1.text;
}
//_tableview被tap时调用的方法，然后隐藏键盘
-(void)return_KeyBoard
{
    [regular dismissKeyborad];
    _commentField.text=_commentField1.text;
    
}
#pragma mark - tableView代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_data_array.count==section)
    {
        return 0;
    }
    return _data_array.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_data_array.count==indexPath.row)
    {
        return 0;
    }
    CGFloat _content_height=[_height_array[indexPath.row] floatValue];
    CGFloat _height=0;
    if((_height_array.count)==indexPath.row+1)
    {
        _height=_content_height+32*_Scale+50*_Scale+150*_Scale;
    }else
    {
        _height=_content_height+32*_Scale+50*_Scale;
    }

//    自定义
    return _height;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_data_array.count==indexPath.row)
    {
        static NSString *cellid=@"cell";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
        if(!cell)
        {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        }
        return cell;
    }
    comment_cell *cell=nil;
        NSNumber *height_num=nil;
    BOOL islast=NO;
    if((indexPath.row+1)==_height_array.count)
    {
        cell=[[comment_cell alloc] init];
        height_num=[NSNumber numberWithFloat:([(NSNumber *)_height_array[indexPath.row] floatValue]+52*_Scale+50*_Scale+150*_Scale)];
        islast=YES;
    }else
    {
        static NSString *cellid=@"cell";
        cell=[tableView dequeueReusableCellWithIdentifier:cellid];
        if(!cell)
        {
            cell=[[comment_cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        }

        height_num=[NSNumber numberWithFloat:([(NSNumber *)_height_array[indexPath.row] floatValue]+52*_Scale+50*_Scale)];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    NSDictionary *sub_dict=[[NSDictionary alloc] initWithObjectsAndKeys:height_num,@"cellheight",_data_array[indexPath.row],@"cellmodel",[NSNumber numberWithInteger:indexPath.row],@"rownum",[NSNumber numberWithBool:islast],@"islast",nil];

    cell.backgroundColor=_define_backview_color;
    cell.dict=sub_dict;
    cell.block=changeBlock;
    
    return cell;
}
-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    return YES;
}

//键盘return的时候发送 发送评论的请求
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if(![regular isLogin])
    {
//        comment_alertview=[[ToolManager sharedManager] alertTitle_Simple:@"You are not logged in, please login first."];
//        comment_alertview.delegate=self;
        [self login_action];
    }else if([_commentField1.text isEqualToString:@""])
    {
        [[ToolManager sharedManager] alertTitle_Simple:@"请输入评论内容"];
    }else
    {
        //发送评论
        [self sendComment];
    }
    [theTextField resignFirstResponder];
    return YES;
}
//发送评论
-(void)sendComment
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    NSDictionary *parameters=@{@"commentable_id":_sid,@"commentable_type":@"school",@"content":_commentField1.text,@"token":[regular getToken]};

    [manager POST:[[NSString alloc] initWithFormat:@"%@%@",DNS,@"/v1/comments"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSString *html = operation.responseString;
        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
        if([[dict objectForKey:@"code"] intValue]==1)
        {
            _commentField.text=@"";
            _comment_count++;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"changenum" object:[NSNumber numberWithInteger:_comment_count]];
            _commentField1.text=@"";
            [self loadData1];
            [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"提交成功" WithImg:@"Prompt_提交成功" Withtype:1]];

            [regular dismissKeyborad];

        }else
        {
            [[ToolManager sharedManager] alertTitle_Simple:[dict objectForKey:@"message"]];
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
    }];

}
-(void)loadData1
{
    [_height_array removeAllObjects];
    [_data_array removeAllObjects];
    
    NSDictionary *parameters=@{@"token":[regular getToken],@"commentable_id":_sid,@"commentable_type":@"school"};

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[[NSString alloc] initWithFormat:@"%@%@",DNS,@"/v1/comments"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSString *html = operation.responseString;
        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
        [indicator stopAnimationWithLoadText:@"loading..." withType:YES];
        if([[dict objectForKey:@"code"] integerValue]==1)
        {

            _comment_count=((NSArray *)dict[@"data"]).count;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"changenum" object:[NSNumber numberWithInteger:_comment_count]];
            NSArray *_return_data=[comment_model_alter parsingWithJsonDict:dict];

            [_data_array addObjectsFromArray:_return_data];

            //            根据model返回的评论的长度，来定制各个cell的高度，并将高度以nsnumber的形式存入数组中。
            //            用于之后cell的定制（并将_height_array传入到cell中去）
            for (comment_model_alter *_model in _return_data) {

                UILabel *label=[[UILabel alloc] init];
                label.font=[regular get_en_Font:14.0f];
                label.frame=CGRectMake(0, 0,ScreenWidth-36*_Scale-80*_Scale-20*_Scale-54*_Scale, 0);
                label.numberOfLines=0;
                //                label.text=_model.content;
                NSMutableAttributedString *attributedString =[[NSMutableAttributedString alloc] initWithString:_model.content attributes:@{NSKernAttributeName : @(1.0)}];

                //设置行间距


                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];

                [paragraphStyle setLineSpacing:2];//调整行间距

                [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_model.content length])];
                label.textColor=[UIColor colorWithRed:150.0f/255.0f green:150.0f/255.0f blue:150.0f/255.0f alpha:1];
                label.attributedText = attributedString;
                [label sizeToFit];
                [_height_array addObject:[NSNumber numberWithFloat:label.frame.size.height]];
            }
            //            进行完数据准备工作后，进行ui的布局，各视图的创建

            [self UIConfig];

        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [indicator stopAnimationWithLoadText:@"loading..." withType:YES];
        [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];

    }];
}
//通过_isCreate判断是否是第一次出现，如果是第一次出现则不做动作，如果不是，在试图出现的时候重新适应_tableView的位置
//并设置_isCreate为no，防止下次视图Appear的时候再次调整位置
//-(void)viewWillAppear:(BOOL)animated
//{
//
//    self.block(@"评论");
//}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"SchoolCommentController"];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"SchoolCommentController"];
    self.tabBarController.tabBar.hidden=YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
