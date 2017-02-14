//
//  schoolCommentController.m
//  OneBox
//
//  Created by 谢江新 on 15-2-2.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import "ArticleCommentController.h"

#import "MJRefresh.h"
#import "HttpRequestManager.h"

#import "followingViewController.h"
#import "followerViewController.h"
#import "ChatViewController.h"
#import "LoginViewController.h"

#import "comment_cell.h"

#import "comment_model_alter.h"
#import "Tools.h"
#import "MyInfo.h"

//评论的view的高度（发表评论）
#define commentHeight 70*_Scale

@interface ArticleCommentController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UITextFieldDelegate,UITextViewDelegate>
{
    YYAnimationIndicator *indicator;
    UIView *nocomment;

    NSMutableString *friend_token;
    NSMutableArray *btnarr;
    BOOL _isguanzhu;
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
    
//    删除时的确认视图
    UIAlertView *isdelete;
//    当登录失败时，跳出的确认视图，用于跳转到登录界面
    UIAlertView *reload_alertview;
//    评论框的背景view
    UIView *_commentview;
//    评论框
    UITextField *_commentField;
    UITextView *_commentField1;
    
    UIImageView *imageGray;

//    UIAlertView *comment_alertview;

    NSInteger _nownum;
    NSString *token;
    UIAlertView *view_guanzhu;

    
}
@end

@implementation ArticleCommentController

-(void)xiaoshi:(NSNotification *)not
{

    if([not.object isEqualToString:@"other"])
    {
        [self dismissModalViewControllerAnimated:YES];
    }
    
}
-(void)other
{
    [self dismissModalViewControllerAnimated:YES];

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

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(xiaoshi:) name:@"xiaoshi" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(other) name:@"other" object:nil];
    friend_token=[[NSMutableString alloc] init];
    btnarr=[[NSMutableArray alloc] init];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];

    UIBarButtonItem *_btn=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回箭头"] style:UIBarButtonItemStylePlain target:self action:@selector(popviewAction)];
    self.navigationItem.titleView=[regular returnNavView:@"评论" withmaxwidth:230];
    self.navigationItem.leftBarButtonItem=_btn;

    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"token"]) {
        [self prepareToken];
    }
//    准备数据
    [self prepareData];

    indicator = [[YYAnimationIndicator alloc]initWithFrame:CGRectMake(ScreenWidth/2-20*_Scale*2, ScreenHeight/2-20*_Scale*2, 40*_Scale*2, 40*_Scale*2)];
    [indicator setLoadText:@"loading..."];
    [self.view addSubview:indicator];
    [indicator startAnimation];

//    加载数据（下载评论）
    [self loadData1];
//    创建监听
    [self createNotification];
//    创建blcok
    [self my_block];
}
-(void)createNocommentview
{
    nocomment=[[UIView alloc] initWithFrame:CGRectMake((ScreenWidth-200*_Scale)/2.0f, (ScreenHeight-kTabBarHeight-64-200*_Scale)/2.0f, 200*_Scale, 200*_Scale)];
//    nocomment.backgroundColor=[UIColor redColor];
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
-(void)popviewAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)prepareToken
{
    NSString *Url = [NSString stringWithFormat:@"%@/v1/rong/get_token?token=%@",DNS,[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]];
    [HttpRequestManager GET:Url complete:^(NSData *data) {
        id res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        token = res[@"data"][@"token"];

    } failed:^{
        NSLog(@"失败");
    }];
    
}

//再创建玩ui后进行数据下载
-(void)loadData
{

    [_data_array removeAllObjects];
//    [[ToolManager sharedManager] createProgress:@"加载中"];

    NSUserDefaults *dict=[NSUserDefaults standardUserDefaults];
    NSString *_token=nil;
    if([dict objectForKey:@"token"]==nil)
    {
        _token=@"";
    }else
    {
        _token=[dict objectForKey:@"token"];
    }

    NSDictionary *parameters=@{@"token":_token,@"commentable_id":_sid,@"commentable_type":@"Post"};
#pragma mark-获得聊天列表
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[[NSString alloc] initWithFormat:@"%@%@",DNS,@"/v1/comments"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSString *html = operation.responseString;
        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
        if([[dict objectForKey:@"code"] integerValue]==1)
        {

            [_tableView headerEndRefreshing];
            _comment_count=((NSArray *)dict[@"data"]).count;

            [[NSNotificationCenter defaultCenter] postNotificationName:@"changenum" object:[NSNumber numberWithInteger:_comment_count]];
            NSArray *_return_data=[comment_model_alter parsingWithJsonDict:dict];
            if(_return_data.count==0)
            {
                //                [[ToolManager sharedManager] alertTitle_Simple:@"没有更多了"];
                UIView *headview=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 70)];
                                headview.backgroundColor=[UIColor redColor];
                UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(50, 30, ScreenWidth-100, 30)];
                                label.backgroundColor=[UIColor grayColor];

                [label setAttributedText:[regular createAttributeString:@"还没有人评论，快来抢沙发哦~" andFloat:@(2.0)]];
                label.textColor=[UIColor blueColor];
                label.textAlignment=1;
                label.font=[regular getFont:12.0f];
                [headview addSubview:label];
                _tableView.tableHeaderView=headview;

            }else
            {
                _tableView.tableHeaderView=[UIView new];
            }

            [_data_array addObjectsFromArray:_return_data];

            //            根据model返回的评论的长度，来定制各个cell的高度，并将高度以nsnumber的形式存入数组中。
            //            用于之后cell的定制（并将_height_array传入到cell中去）
            for (comment_model_alter *_model in _return_data) {

                UILabel *label=[[UILabel alloc] init];
                label.font=[regular getFont:14.0f];
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

                NSLog(@"%f %f",label.frame.size.width,label.frame.size.height);

                [_height_array addObject:[NSNumber numberWithFloat:label.frame.size.height]];

            }
            //            进行完数据准备工作后，进行ui的布局，各视图的创建
            [self UIConfig];


        }

        [[ToolManager sharedManager] removeProgress];


    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_tableView headerEndRefreshing];
        [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
        [[ToolManager sharedManager] removeProgress];
    }];
    
    
    
}
-(void)prepareData
{
    _nownum=0;
    _islogin=YES;
    alternum=0;

    _start=0;
    self.view.backgroundColor=_define_backview_color;
    _data_array=[[NSMutableArray alloc] init];
    _height_array=[[NSMutableArray alloc] init];
    
}
-(void)login_action
{
    LoginViewController*login=[[LoginViewController alloc] init];
    login.type=@"other";
    [self presentModalViewController:login animated:YES];
}

//用于方法的回调，通过点击cell中的删除或者点赞触发block
//进行cell的删除或者点赞的动作
-(void)my_block
{
    changeBlock=^(NSNumber *rownum,NSInteger type)
    {
        NSInteger _num=[rownum integerValue];
        
        if(type==0)
        {
            
            //             删除
            isdelete=[[UIAlertView alloc] initWithTitle:nil message:@"是否删除评论" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes",nil];
            [isdelete show];

            alternum=_num;

        }else if (type==4)
        {
            if([[NSUserDefaults standardUserDefaults] objectForKey:@"token"]==nil)
            {
//                UIAlertView *alertview=[[ToolManager sharedManager] alertTitle_Simple:@"You are not logged in, please login first."];
//                alertview.delegate=self;
                [self login_action];
            }else
            {
                _nownum=[rownum integerValue];
                [self iconClick:rownum];
            }
        }else if(type==10)
        {
//            UIAlertView *alertview=[[ToolManager sharedManager] alertTitle_Simple:@"用户还未登录，请先登录"];
//            alertview.delegate=self;
            [self login_action];
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

            NSUserDefaults *dict=[NSUserDefaults standardUserDefaults];
            NSString *_token=nil;
            if([dict objectForKey:@"token"]==nil)
            {
                _token=@"";
            }else
            {
                _token=[dict objectForKey:@"token"];
            }

            NSDictionary *parameters = @{@"token":_token,@"voteable_id":model.comment_id,@"voteable_type":@"comment"};

            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            [manager POST:[[NSString alloc] initWithFormat:@"%@%@",DNS,__url] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSString *html = operation.responseString;
                NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
                if([[dict objectForKey:@"code"] integerValue]==1)
                {

                    [[ToolManager sharedManager] removeProgress];

                }else
                {

                    [[ToolManager sharedManager] removeProgress];
                     [[ToolManager sharedManager] alertTitle_Simple:[dict objectForKey:@"message"]];

                }

            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
                [[ToolManager sharedManager] removeProgress];
            }];
        }
        
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:_num inSection:0];
        
        [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    };

}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    _commentField.text=_commentField1.text;
    [[self.view viewWithTag:1000] removeFromSuperview];

}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
//    if(t)
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];


}
-(void)xiaoshi
{
    [[self.view.window viewWithTag:1000] removeFromSuperview];
    _commentField.text=_commentField1.text;
}

-(void)backaction:(UIGestureRecognizer *)ges
{

}
-(void)friend_list:(UIGestureRecognizer *)ges
{
    //    friend_list
    if(ges.view.tag==6000)
    {
        followerViewController *foll=[[followerViewController alloc] init];
        foll.token=friend_token;
        [self.navigationController pushViewController:foll animated:YES];
        [self xiaoshi];

    }else
    {
        followingViewController *foll=[[followingViewController alloc] init];
        foll.token=friend_token;
        [self.navigationController pushViewController:foll animated:YES];
        [self xiaoshi];
        
    }
}
- (void)iconClick:(NSNumber *)num
{

    [btnarr removeAllObjects];
    NSInteger _num=[num integerValue];
    comment_model_alter *model=_data_array[_num];
    imageGray = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"蒙板"]];
    imageGray.tag=1000;
    imageGray.userInteractionEnabled = YES;
    imageGray.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(xiaoshi)];
    [imageGray addGestureRecognizer:tap];
    [self.view.window addSubview:imageGray];

    //    360 400
    UIImageView *backview=[[UIImageView alloc] init];
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] longValue]==[model.user_id longLongValue])
    {
        backview.frame=CGRectMake((CGRectGetWidth(imageGray.frame)-180*_Scale*2)/2.0f, (CGRectGetHeight(imageGray.frame)-156*_Scale*2)/2.0f, 180*_Scale*2,151*_Scale*2);

    }else
    {
         backview.frame=CGRectMake((CGRectGetWidth(imageGray.frame)-180*_Scale*2)/2.0f, (CGRectGetHeight(imageGray.frame)-300*_Scale*2)/2.0f, 180*_Scale*2,213*_Scale*2);

    }
    //    backview.backgroundColor=[UIColor whiteColor];
    backview.backgroundColor=[UIColor whiteColor];
    [imageGray addSubview:backview];
    backview.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap1=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backaction:)];
    [backview addGestureRecognizer:tap1];

    

    UIView *upview=[[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(backview.frame), 98*_Scale*2)];
    [backview addSubview:upview];
    upview.backgroundColor=[UIColor whiteColor];

    UIView *middle=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(upview.frame), CGRectGetWidth(backview.frame), 53*_Scale*2)];

    [backview addSubview:middle];

    UIView *downview=[[UIView alloc] init];
    UIView *view=[[UIView alloc] init];

    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] longValue]==[model.user_id longLongValue])
    {
        downview.frame=CGRectMake(0, CGRectGetMaxY(middle.frame), CGRectGetWidth(backview.frame), 0);
        view.frame=CGRectMake(10*_Scale*2, CGRectGetMaxY(middle.frame), CGRectGetWidth(middle.frame)-20*_Scale*2, 0);

    }else
    {
        view.frame=CGRectMake(20*_Scale*2, CGRectGetMaxY(middle.frame), CGRectGetWidth(backview.frame)-40*_Scale*2, 1*_Scale);
        view.backgroundColor=[UIColor colorWithRed:220.0f/255.0f green:220.0f/255.0f blue:220.0f/255.0f alpha:1];

        downview.frame=CGRectMake(0, CGRectGetMaxY(view.frame), CGRectGetWidth(backview.frame), CGRectGetHeight(backview.frame)-CGRectGetMaxY(view.frame));

        downview.backgroundColor=[UIColor whiteColor];


        [backview addSubview:downview];
        [backview addSubview:view];
    }


    NSString *url = [NSString stringWithFormat:@"%@/v1/users/%@?token=%@",DNS,model.user_id,[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]];
    [HttpRequestManager GET:url complete:^(NSData *data) {

        NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];

        if([[[dict objectForKey:@"data"] objectForKey:@"had_followed"] integerValue]==0)
        {
            _isguanzhu=NO;
        }else
        {
            _isguanzhu=YES;
        }

        [friend_token setString:[[dict objectForKey:@"data"] objectForKey:@"token"]];

        CGFloat ___jiange=(CGRectGetWidth(middle.frame)-80*_Scale*2)/3.0f;
        for (int i=0; i<2; i++) {

            UIImageView *_imagev=[[UIImageView alloc] initWithFrame:CGRectMake(___jiange+(40*_Scale*2+___jiange)*i, -5*_Scale*2, 40*_Scale*2, 40*_Scale*2)];

            [middle addSubview:_imagev];

            UITapGestureRecognizer *friend_list=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(friend_list:)];
            _imagev.tag=6000+i;
            [_imagev addGestureRecognizer:friend_list];
            _imagev.userInteractionEnabled=YES;

            UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_imagev.frame), CGRectGetHeight(_imagev.frame))];
            [_imagev addSubview:label];
            label.textAlignment=1;
            label.textColor=[UIColor colorWithRed:79.0f/255.0f green:190.0f/255.0f blue:221.0f/255.0f alpha:0.8];
            label.font=[regular get_en_Font:20.0f];
            label.text=i==0?[[NSString alloc] initWithFormat:@"%ld",(long)[[[dict objectForKey:@"data"] objectForKey:@"follows_count"] integerValue]]:[[NSString alloc] initWithFormat:@"%ld",(long)[[[dict objectForKey:@"data"] objectForKey:@"following_count"] integerValue]];

            UILabel *label1=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_imagev.frame)-15*_Scale*2,CGRectGetMaxY(_imagev.frame)-10*_Scale*2,CGRectGetWidth(_imagev.frame)+30*_Scale*2,CGRectGetHeight(middle.frame)-CGRectGetMaxY(_imagev.frame))];
            [middle addSubview:label1];
            label1.textAlignment=1;
            label1.font=[regular getFont:10.0f];
            [label1 setAttributedText:[regular createAttributeString:i==0?@"粉丝":@"关注" andFloat:@(1.0)]];
            label1.textColor=[UIColor colorWithRed:200.0f/255.0f green:200.0f/255.0f blue:200.0f/255.0f alpha:1];


        }


        DBImageView * iconImage1 = [[DBImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(upview.frame)-70*_Scale*2)/2.0f, -35*_Scale*2, 70*_Scale*2, 70*_Scale*2)];
        [upview addSubview:iconImage1];
        iconImage1.userInteractionEnabled = YES;
        iconImage1.layer.masksToBounds = YES;
        iconImage1.layer.cornerRadius = iconImage1.frame.size.width/2.0;
        UIView *zhegai=[[UIView alloc] initWithFrame:CGRectMake(-1*_Scale*2,-1*_Scale*2 , CGRectGetWidth(iconImage1.frame)+2*_Scale*2, CGRectGetWidth(iconImage1.frame)+2*_Scale*2)];
        zhegai.backgroundColor=[UIColor clearColor];
        zhegai.layer.masksToBounds=YES;
        zhegai.layer.cornerRadius=CGRectGetWidth(zhegai.frame)/2.0f;
        zhegai.layer.borderColor = [_define_head_color CGColor];
        zhegai.layer.borderWidth = 4.0f;
        [iconImage1 addSubview:zhegai];

        if(([[dict objectForKey:@"data"] objectForKey:@"avatar"]!=[NSNull null])&&([[dict objectForKey:@"data"] objectForKey:@"avatar"]!=nil))
        {
            NSString *__url=[[dict objectForKey:@"data"] objectForKey:@"avatar"];
            [iconImage1 setImageWithPath:__url];
            iconImage1.placeHolder=[UIImage imageNamed:@"headImg_login1"];
        }else
        {
            iconImage1.image=[UIImage imageNamed:@"headImg_login1"];
        }

        NSArray *arrtitle=@[@"username",@"city",@"mark"];
        NSDictionary *__dict=[dict objectForKey:@"data"];
        CGFloat __y_p=CGRectGetMaxY(iconImage1.frame)+15*_Scale;
        CGFloat __height=(CGRectGetHeight(upview.frame)-CGRectGetMaxY(iconImage1.frame)-15*_Scale)/3.0f;


        for (int i=0; i<3; i++) {
            UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, __y_p, CGRectGetWidth(upview.frame), __height)];
            __y_p+=__height;
            [upview addSubview:label];
            label.textColor=i==0?_define_blue_color:[UIColor colorWithRed:200.0f/255.0f green:200.0f/255.0f blue:200.0f/255.0f alpha:1];
//            label.backgroundColor=[UIColor redColor ];
            label.textAlignment=1;
            CGFloat __font=i==0?13.0f:i==2?11.0f:11.0f;
            label.font=[regular getFont:__font];
            if(([__dict objectForKey:arrtitle[i]]!=[NSNull null])&&([__dict objectForKey:arrtitle[i]]!=nil))
            {

                NSString *citystr=nil;
                if(i==1)
                {

                    if([[__dict objectForKey:arrtitle[i]]isEqualToString:@""])
                    {
                        citystr=@"反正不是火星";

                    }else
                    {
                        citystr=[__dict objectForKey:arrtitle[i]];
                    }
                }else
                {
                    citystr=[__dict objectForKey:arrtitle[i]];
                }
                [label setAttributedText:[regular createAttributeString:citystr andFloat:@(1.0)]];

            }else
            {
                if(i==1)
                {
                    [label setAttributedText:[regular createAttributeString:@"反正不是火星" andFloat:@(1.0)]];
                }else
                {
                    [label setAttributedText:[regular createAttributeString:@"" andFloat:@(1.0)]];
                }
            }
        }
        NSArray *arrCase = nil;

        NSArray *arrLabel =nil;
        if(_isguanzhu)
        {
            //            found_school_2_关闭icon
            arrCase = @[@"follow_select",@"message_normal"];
            arrLabel = @[@"取消关注",@"消息"];

        }else
        {
            //            box_choose_添加1
            arrCase = @[@"follow_normal",@"message_select"];
            arrLabel = @[@"关注",@"消息"];
        }
        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] longValue]==[model.user_id longLongValue])
        {
//            [downview removeFromSuperview];
//            backview.frame=CGRectMake((CGRectGetWidth(imageGray.frame)-180)/2.0f, (CGRectGetHeight(imageGray.frame)-300)/2.0f, 180,218);
//            [view removeFromSuperview];


        }else
        {
            //90 84
            if([[[dict objectForKey:@"data"] objectForKey:@"is_server"] boolValue])
            {
                _isguanzhu=YES;
                UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame=CGRectMake((CGRectGetWidth(downview.frame)-45*_Scale*2)/2.0f, (CGRectGetHeight(downview.frame)-42*_Scale*2)/2.0f, 45*_Scale*2, 42*_Scale*2);

                btn.tag=101;
                [btn addTarget:self action:@selector(caseBtn:) forControlEvents:UIControlEventTouchUpInside];
                [downview addSubview:btn];
                //            btn.backgroundColor=[UIColor redColor];
                UIImageView *__image=[[UIImageView alloc] initWithFrame:CGRectMake(((CGRectGetWidth(btn.frame)-25*_Scale*2)/2.0f), 0, 25*_Scale*2, 25*_Scale*2)];
                __image.image=[UIImage imageNamed:@"message_normal"];
                //            __image.backgroundColor=[UIColor yellowColor];
                [btn addSubview:__image];
                UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(-10*_Scale*2, CGRectGetMaxY(__image.frame)+3*_Scale*2, CGRectGetWidth(btn.frame)+20*_Scale*2, CGRectGetHeight(btn.frame)-CGRectGetMaxY(__image.frame))];
                [btn addSubview:label];
                label.textColor=[UIColor colorWithRed:200.0f/255.0f green:200.0f/255.0f blue:200.0f/255.0f alpha:1];
                label.textAlignment=1;
                //            label.backgroundColor=[UIColor greenColor];
                label.font=[regular getFont:10.0f];
                [label setAttributedText:[regular createAttributeString:@"消息" andFloat:@(1.0)]];
                [btnarr addObject:btn];
            }else
            {
                //90 84
                for (int i = 0 ; i < 2; i ++) {
                    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
                    btn.frame=CGRectMake((65.0f/2.0f)*_Scale*2+(CGRectGetWidth(downview.frame)-45*2*_Scale*2-65*_Scale*2+45*_Scale*2)*i, (CGRectGetHeight(downview.frame)-42*_Scale*2)/2.0f, 45*_Scale*2, 42*_Scale*2);

                    btn.tag=100+i;
                    [btn addTarget:self action:@selector(caseBtn:) forControlEvents:UIControlEventTouchUpInside];
                    [downview addSubview:btn];
                    //            btn.backgroundColor=[UIColor redColor];
                    UIImageView *__image=[[UIImageView alloc] initWithFrame:CGRectMake(((CGRectGetWidth(btn.frame)-25*_Scale*2)/2.0f), 0, 25*_Scale*2, 25*_Scale*2)];
                    __image.image=[UIImage imageNamed:arrCase[i]];
                    //            __image.backgroundColor=[UIColor yellowColor];
                    [btn addSubview:__image];
                    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(-10*_Scale*2, CGRectGetMaxY(__image.frame)+3*_Scale*2, CGRectGetWidth(btn.frame)+20*_Scale*2, CGRectGetHeight(btn.frame)-CGRectGetMaxY(__image.frame))];
                    [btn addSubview:label];
                    label.textColor=[UIColor colorWithRed:200.0f/255.0f green:200.0f/255.0f blue:200.0f/255.0f alpha:1];
                    label.textAlignment=1;
                    //            label.backgroundColor=[UIColor greenColor];
                    label.font=[regular getFont:10.0f];
                    [label setAttributedText:[regular createAttributeString:arrLabel[i] andFloat:@(1.0)]];
                    [btnarr addObject:btn];

                }
            }

        }

    } failed:^{
        NSLog(@"失败");
    }];



}
- (void)caseBtn:(UIButton *)btn
{
    comment_model_alter *model=_data_array[_nownum];
    if (btn.tag == 100) {
        //        NSArray *arrCase = nil;

        NSArray *arrLabel =nil;
        if(!_isguanzhu)
        {
            for (UIView *view in btn.subviews) {
                if([view isKindOfClass:[UIImageView class]])
                {

                    ((UIImageView *)view).image=[UIImage imageNamed:@"follow_select"];
                }
                if([view isKindOfClass:[UILabel class]])
                {
                    [(UILabel *)view setAttributedText:[regular createAttributeString:@"取消关注" andFloat:@(1.0)]];
                }
            }

            UIButton *btn_1=(UIButton *)btnarr[1];
            for (UIView *view in btn_1.subviews) {
                if([view isKindOfClass:[UIImageView class]])
                {

                    ((UIImageView *)view).image=[UIImage imageNamed:@"message_normal"];
                }
            }

            NSString *str=[NSString stringWithFormat:@"%@/v1/follows?token=%@",DNS,[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]];

            NSDictionary *para = @{@"followable_id":[NSString stringWithFormat:@"%@",model.user_id],@"followable_type":@"user"};
            AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];

            [manager POST:str parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
                //                NSLog(@"%@",responseObject);
                [regular removeProgress];
                id res = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"%@",res);
                if ([res[@"code"] integerValue] == 1) {

                    [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshChatList" object:nil];
                    _isguanzhu=YES;
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

                [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
                NSLog(@"失败");
            }];

        }else
        {
            //            arrCase = @[@"box_choose_添加1",@"message_select"];
            //            arrLabel = @[@"Add",@"Message"];
            arrLabel = @[@"取消关注",@"消息"];
            for (UIView *view in btn.subviews) {
                if([view isKindOfClass:[UIImageView class]])
                {

                    ((UIImageView *)view).image=[UIImage imageNamed:@"follow_normal"];
                }
                if([view isKindOfClass:[UILabel class]])
                {
                    [(UILabel *)view setAttributedText:[regular createAttributeString:@"关注" andFloat:@(1.0)]];
                }
            }

            UIButton *btn_1=(UIButton *)btnarr[1];
            for (UIView *view in btn_1.subviews) {
                if([view isKindOfClass:[UIImageView class]])
                {

                    ((UIImageView *)view).image=[UIImage imageNamed:@"message_select"];
                }
            }



            NSString *str=[NSString stringWithFormat:@"%@/v1/follows/cancel?token=%@",DNS,[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]];

            NSDictionary *para = @{@"followable_id":[NSString stringWithFormat:@"%@",model.user_id],@"followable_type":@"user"};
            AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];

            [manager POST:str parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
                //                NSLog(@"%@",responseObject);
                [regular removeProgress];
                id res = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"%@",res);
                if ([res[@"code"] integerValue] == 1) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshChatList" object:nil];
                    _isguanzhu=NO;

                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

                [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
                NSLog(@"失败");
            }];


        }



    }
    else
    {
        if(_isguanzhu)
        {

            [[self.view.window viewWithTag:1000] removeFromSuperview];

            ChatViewController *chatVC = [[ChatViewController alloc] initWithChatter:model.ease_mob_username isGroup:NO];
            [chatVC setH_title:model.user_name];
        chatVC.userinfo=@{@"cell":model.cell,@"is_server":[NSNumber numberWithBool:model.is_server],@"uid":model.user_id};

            chatVC.uid=model.user_id;
            chatVC.friend_head=model.user_avatar;
            chatVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:chatVC animated:YES];
            
        }else
        {
            [[ToolManager sharedManager] alertTitle_Simple:@"关注之后才能聊天哦～"];
        }
        
        
    }
    
}

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

//    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    if(alertView==isdelete)
    {
        if(buttonIndex==1)
        {
//            删除数据
            [self removData];
            
        }
    }else if(alertView == reload_alertview)
    {

        LoginViewController*login=[[LoginViewController alloc] init];
        login.type=@"other";
        [self presentModalViewController:login animated:YES];

    }else if(alertView==view_guanzhu)
    {

    }else
    {
        LoginViewController*login=[[LoginViewController alloc] init];
        login.type=@"other";
        [self presentModalViewController:login animated:YES];
    }
}
//进行评论内容的删除（如果是用户自己评论的内容）。
//前面已经作出判断，是否为当前用户所发表内容
//如果不是当前用户发表的评论，则不会显示删除，是则显示
-(void)removData
{

//    [regular createProgress:@"删除中"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSUserDefaults *__dict=[NSUserDefaults standardUserDefaults];
    NSString *_token=[__dict objectForKey:@"token"];
    NSDictionary *parameters = @{@"token": _token};
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

        [[ToolManager sharedManager] removeProgress];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
        [[ToolManager sharedManager] removeProgress];

    }];


}


#pragma mark 开始进入刷新状态
/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    [_tableView headerBeginRefreshing];
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [_tableView addHeaderWithTarget:self action:@selector(headerRereshing)];



    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [_tableView addFooterWithTarget:self action:@selector(footRereshing)];

}
-(void)footRereshing
{
//    [[ToolManager sharedManager] alertTitle_Simple:@"没有更多了"];


//[ToolManager sharedManager]
    [_tableView footerEndRefreshing];
}
- (void)headerRereshing
{

//    [[ToolManager sharedManager] alertTitle_Simple:@"没有更多了"];
    [_tableView headerEndRefreshing];

//    [_data_array removeAllObjects];
//    [self prepareData];

}


//
//- (void)footerRereshing
//{
//    start+=25;
//    _page++;
//    [self requestData];
//}
-(void)sendAction
{
    _commentField.text=_commentField1.text;
    NSUserDefaults *dict=[NSUserDefaults standardUserDefaults];
    if(![[dict objectForKey:@"islogin"] integerValue])
    {

        [_commentField1 resignFirstResponder];
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
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
     _commentField.text=_commentField1.text;
}
//创建各个视图
-(void)UIConfig
{

//    将_isCreate设为yes，用于controller再次出现时调整_tableview的位置
//    _isCreate=YES;
//    创建_tableView
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(_margin, 64+_margin, ScreenWidth-2*_margin, ScreenHeight-64-commentHeight) style:UITableViewStylePlain];
    _tableView.backgroundColor=self.view.backgroundColor;
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.showsVerticalScrollIndicator=YES;

//    加上tap
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(return_KeyBoard)];
    [_tableView addGestureRecognizer:tap];
_tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [self setupRefresh];

    UIView *headView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20*_Scale)];
    headView.backgroundColor=self.view.backgroundColor;
    _tableView.tableHeaderView=headView;

    [self createNocommentview];
//    创建底部发表评论的view

    _commentview=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_tableView.frame), ScreenWidth, commentHeight)];
    _commentview.backgroundColor=self.view.backgroundColor;


    [self.view addSubview:_commentview];
//    创建textfield，用于填写评论
//    并将_commentField放在_commentview上
    CGFloat _y_p=-1*_Scale+(commentHeight-52*_Scale)/2.0f;
    _commentField=[[UITextField alloc] initWithFrame:CGRectMake(10*_Scale, _y_p,ScreenWidth-20*_Scale , 52*_Scale)];
    UIView *signBoard=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 280*_Scale)];



    _commentField1=[[UITextView alloc] initWithFrame:CGRectMake(14*_Scale, 65*_Scale  ,ScreenWidth-28*_Scale , 200*_Scale)];
    _commentField1.returnKeyType=UIReturnKeyDefault;
    _commentField1.delegate=self;
    _commentField1.font=[regular getFont:14.0f];
    [signBoard addSubview:_commentField1];
    UIView *view_qufen=[[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(signBoard.frame), 1*_Scale)];
    view_qufen.backgroundColor=[UIColor colorWithRed:190.0f/255.0f green:190.0f/255.0f blue:190.0f/255.0f alpha:1];
    [signBoard addSubview:view_qufen];
    signBoard.backgroundColor=self.view.backgroundColor;

    UIButton *cancel=[UIButton buttonWithType:UIButtonTypeCustom];
    //    cancel.backgroundColor=[UIColor redColor];
    cancel.frame=CGRectMake(0, 0, 136*_Scale, 65*_Scale);
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    cancel.titleLabel.font=[regular get_en_Font:13.0f];
    [cancel setTitleColor:_define_blue_color forState:UIControlStateNormal];
    [cancel addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [signBoard addSubview:cancel];


    UIButton *send=[UIButton buttonWithType:UIButtonTypeCustom];
    send.frame=CGRectMake(CGRectGetWidth(signBoard.frame)-136*_Scale, 0,136*_Scale , 65*_Scale);
    //    send.backgroundColor=[UIColor redColor];
    [send setTitle:@"发送" forState:UIControlStateNormal];
    send.titleLabel.font=[regular get_en_Font:13.0f];
    [send setTitleColor:_define_blue_color forState:UIControlStateNormal];
    [send addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
    [signBoard addSubview:send];

#pragma mark -键盘上加view
    _commentField.inputAccessoryView = signBoard;
    _commentField.clearButtonMode = UITextFieldViewModeAlways;
    _commentField.background=[UIImage imageNamed:@""];
    _commentField.leftViewMode=UITextFieldViewModeAlways;
    _commentField.leftView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 40*_Scale, CGRectGetHeight(_commentField.frame))];
    _commentField.returnKeyType=UIReturnKeyDefault;
    _commentField.borderStyle= UITextBorderStyleNone;
    _commentField.placeholder=@"撰 写 您 的 评 论 。";
    _commentField.backgroundColor=self.view.backgroundColor;
    _commentField.delegate=self;
    _commentField.background=[UIImage imageNamed:@"comment_搜索框搜索框"];
    _commentField.font=[regular getFont:10.5f];
    [_commentview addSubview:_commentField];
}
//_tableview被tap时调用的方法，然后隐藏键盘
-(void)return_KeyBoard
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    _commentField.text=_commentField1.text;
}
#define mark - tableView代理方法
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

    cell.backgroundColor=self.view.backgroundColor;
    cell.dict=sub_dict;
    cell.block=changeBlock;
    
    return cell;
}

//键盘return的时候发送 发送评论的请求
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    NSUserDefaults *dict=[NSUserDefaults standardUserDefaults];
    if(![[dict objectForKey:@"islogin"] integerValue])
    {
//        comment_alertview=[[ToolManager sharedManager] alertTitle_Simple:@"用户还未登录，请先登录"];
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
    NSUserDefaults *dict=[NSUserDefaults standardUserDefaults];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *_token=nil;
    if([dict objectForKey:@"token"]==nil)
    {
        _token=@"";
    }else
    {
        _token=[dict objectForKey:@"token"];
    }

    NSDictionary *parameters=@{@"commentable_id":_sid,@"commentable_type":@"Post",@"content":_commentField1.text,@"token":_token};

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
            
            [[ToolManager sharedManager] removeProgress];
            [[[UIApplication sharedApplication] keyWindow] endEditing:YES];

        }else
        {
            [[ToolManager sharedManager] removeProgress];
            [[ToolManager sharedManager] alertTitle_Simple:[dict objectForKey:@"message"]];
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
        [[ToolManager sharedManager] removeProgress];
    }];

}
-(void)loadData1
{
    [_height_array removeAllObjects];
    [_data_array removeAllObjects];
//    [[ToolManager sharedManager] createProgress:@"加载中"];

    NSUserDefaults *dict=[NSUserDefaults standardUserDefaults];
    NSString *_token=nil;
    if([dict objectForKey:@"token"]==nil)
    {
        _token=@"";
    }else
    {
        _token=[dict objectForKey:@"token"];
    }

    NSDictionary *parameters=@{@"token":_token,@"commentable_id":_sid,@"commentable_type":@"Post"};

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[[NSString alloc] initWithFormat:@"%@%@",DNS,@"/v1/comments"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSString *html = operation.responseString;
        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
        if([[dict objectForKey:@"code"] integerValue]==1)
        {

            _comment_count=((NSArray *)dict[@"data"]).count;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"changenum" object:[NSNumber numberWithInteger:_comment_count]];
            NSArray *_return_data=[comment_model_alter parsingWithJsonDict:dict];

            [_data_array addObjectsFromArray:_return_data];
            if(_data_array.count>0)
            {
                nocomment.hidden=YES;
            }else
            {
                nocomment.hidden=NO;
            }

            //            根据model返回的评论的长度，来定制各个cell的高度，并将高度以nsnumber的形式存入数组中。
            //            用于之后cell的定制（并将_height_array传入到cell中去）
            for (comment_model_alter *_model in _return_data) {

                UILabel *label=[[UILabel alloc] init];
                label.font=[regular getFont:14.0f];
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

                NSLog(@"%f %f",label.frame.size.width,label.frame.size.height);
                [_height_array addObject:[NSNumber numberWithFloat:label.frame.size.height]];

            }
            //            进行完数据准备工作后，进行ui的布局，各视图的创建

            [self UIConfig];

        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_tableView headerEndRefreshing];
        [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
    }];
}
-(void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];

    [MobClick beginLogPageView:@"schoolCommentController"];
    self.tabBarController.tabBar.hidden=YES;

}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"schoolCommentController"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
@end
