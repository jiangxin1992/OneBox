//
//  followerViewController.m
//  OneBox
//
//  Created by 谢江新 on 15/9/8.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import "followerViewController.h"

#import "MJRefresh.h"
#import "HttpRequestManager.h"

#import "followingViewController.h"
#import "ChatViewController.h"
#import "CustomTabbarController.h"

#import "UserCell1.h"

#import "usermodel.h"

@interface followerViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation followerViewController
{
    UIView *nofollow;
    BOOL _isguanzhu;
    NSMutableArray *ArrayData;
    UITableView *_tableView;
    NSInteger _page;
    NSMutableString *friend_token;
    NSMutableArray *btnarr;
    UIImageView *imageGray;
    NSInteger _rownum;

}
-(void)popviewAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)backaction:(UIGestureRecognizer *)ges
{

}
#pragma mark－粉丝
- (void)viewDidLoad {
    [super viewDidLoad];

    friend_token=[[NSMutableString alloc] init];
    btnarr=[[NSMutableArray alloc] init];
    self.navigationItem.titleView=[regular returnNavView:@"粉丝" withmaxwidth:230];
    UIBarButtonItem *_btn=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回箭头"] style:UIBarButtonItemStylePlain target:self action:@selector(popviewAction)];
    self.navigationItem.leftBarButtonItem=_btn;
    [self CreateTableview];
    [self CreateNofollowerView];

    changeBlock=^(NSNumber *rownum)
    {
        _rownum=[rownum integerValue];
        [btnarr removeAllObjects];
        NSInteger _num=[rownum integerValue];
        usermodel *model=ArrayData[_num];
        imageGray = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"蒙板"]];
        imageGray.tag=1000;
        imageGray.userInteractionEnabled = YES;
        imageGray.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(xiaoshi)];
        [imageGray addGestureRecognizer:tap];
        [self.view.window addSubview:imageGray];

        //    360 400
        UIImageView *backview=[[UIImageView alloc] init];
        if([[regular getUID] longValue]==[model.user_id longLongValue])
        {
            backview.frame=CGRectMake((CGRectGetWidth(imageGray.frame)-180*2*_Scale)/2.0f, (CGRectGetHeight(imageGray.frame)-156*2*_Scale)/2.0f, 180*2*_Scale,151*2*_Scale);

        }else
        {
            backview.frame=CGRectMake((CGRectGetWidth(imageGray.frame)-180*2*_Scale)/2.0f, (CGRectGetHeight(imageGray.frame)-300*2*_Scale)/2.0f, 180*2*_Scale,213*2*_Scale);
            
        }
        //    backview.backgroundColor=[UIColor whiteColor];
        backview.backgroundColor=[UIColor whiteColor];
        [imageGray addSubview:backview];
        backview.userInteractionEnabled=YES;
        UITapGestureRecognizer *tap1=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backaction:)];
        [backview addGestureRecognizer:tap1];

        
        UIView *upview=[[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(backview.frame), 98*2*_Scale)];
        [backview addSubview:upview];
        upview.backgroundColor=[UIColor whiteColor];

        UIView *middle=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(upview.frame), CGRectGetWidth(backview.frame), 53*2*_Scale)];
        middle.backgroundColor=[UIColor whiteColor];
        [backview addSubview:middle];


        UIView *downview=[[UIView alloc] init];
        UIView *view=[[UIView alloc] init];

        if([[regular getUID] longValue]==[model.user_id longLongValue])
        {
            downview.frame=CGRectMake(0, CGRectGetMaxY(middle.frame), CGRectGetWidth(backview.frame), 0);
            view.frame=CGRectMake(10*2*_Scale, CGRectGetMaxY(middle.frame), CGRectGetWidth(middle.frame)-20*2*_Scale, 0);

        }else
        {
            view.frame=CGRectMake(20*2*_Scale, CGRectGetMaxY(middle.frame), CGRectGetWidth(backview.frame)-40*2*_Scale, 1*_Scale);
            view.backgroundColor=[UIColor colorWithRed:220.0f/255.0f green:220.0f/255.0f blue:220.0f/255.0f alpha:1];

            downview.frame=CGRectMake(0, CGRectGetMaxY(view.frame), CGRectGetWidth(backview.frame), CGRectGetHeight(backview.frame)-CGRectGetMaxY(view.frame));

            downview.backgroundColor=[UIColor whiteColor];


            [backview addSubview:downview];
            [backview addSubview:view];
        }

        NSString *url = [NSString stringWithFormat:@"%@/v1/users/%@?token=%@",DNS,model.user_id,[regular getToken]];
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


            CGFloat ___jiange=(CGRectGetWidth(middle.frame)-80*2*_Scale)/3.0f;
            for (int i=0; i<2; i++) {

               UIImageView *_imagev=[[UIImageView alloc] initWithFrame:CGRectMake(___jiange+(40*2*_Scale+___jiange)*i, -5*2*_Scale, 40*2*_Scale, 40*2*_Scale)];
                [middle addSubview:_imagev];
                _imagev.layer.masksToBounds=YES;
                _imagev.layer.cornerRadius=CGRectGetWidth(_imagev.frame)/2.0f;
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

               UILabel *label1=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_imagev.frame)-15*2*_Scale,CGRectGetMaxY(_imagev.frame)-10*2*_Scale,CGRectGetWidth(_imagev.frame)+30*2*_Scale,CGRectGetHeight(middle.frame)-CGRectGetMaxY(_imagev.frame))];
                [middle addSubview:label1];
                label1.textAlignment=1;
                label1.font=[regular getFont:10.0f];
                [label1 setAttributedText:[regular createAttributeString:i==0?@"粉丝":@"关注" andFloat:@(1.0)]];

                label1.textColor=[UIColor colorWithRed:200.0f/255.0f green:200.0f/255.0f blue:200.0f/255.0f alpha:1];


            }


             DBImageView * iconImage1 = [[DBImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(upview.frame)-70*2*_Scale)/2.0f, -35*2*_Scale, 70*2*_Scale, 70*2*_Scale)];
            [upview addSubview:iconImage1];
            iconImage1.userInteractionEnabled = YES;
            iconImage1.layer.masksToBounds = YES;
            iconImage1.layer.cornerRadius = iconImage1.frame.size.width/2.0;
            UIView *zhegai=[[UIView alloc] initWithFrame:CGRectMake(-1*2*_Scale,-1*2*_Scale , CGRectGetWidth(iconImage1.frame)+2*2*_Scale, CGRectGetWidth(iconImage1.frame)+2*2*_Scale)];
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
                arrCase = @[@"found_school_2_关闭icon",@"message_normal"];
                arrLabel = @[@"取消关注",@"消息"];

            }else
            {
                arrCase = @[@"box_choose_添加1",@"message_select"];
                arrLabel = @[@"关注",@"消息"];
            }
            if([[regular getUID] longValue]==[model.user_id longLongValue])
            {
                //            [downview removeFromSuperview];
                //            backview.frame=CGRectMake((CGRectGetWidth(imageGray.frame)-180)/2.0f, (CGRectGetHeight(imageGray.frame)-300)/2.0f, 180,218);
                //            [view removeFromSuperview];


            }else
            {

                if([[[dict objectForKey:@"data"] objectForKey:@"is_server"] boolValue])
                {
                    _isguanzhu=YES;
                    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
                    btn.frame=CGRectMake((CGRectGetWidth(downview.frame)-45*2*_Scale)/2.0f, (CGRectGetHeight(downview.frame)-42*2*_Scale)/2.0f, 45*2*_Scale, 42*2*_Scale);

                    btn.tag=101;
                    [btn addTarget:self action:@selector(caseBtn:) forControlEvents:UIControlEventTouchUpInside];
                    [downview addSubview:btn];
                    //            btn.backgroundColor=[UIColor redColor];
                    UIImageView *__image=[[UIImageView alloc] initWithFrame:CGRectMake(((CGRectGetWidth(btn.frame)-25*2*_Scale)/2.0f), 0, 25*2*_Scale, 25*2*_Scale)];
                    __image.image=[UIImage imageNamed:@"message_normal"];
                    //            __image.backgroundColor=[UIColor yellowColor];
                    [btn addSubview:__image];
                    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(-10*2*_Scale, CGRectGetMaxY(__image.frame)+3*2*_Scale, CGRectGetWidth(btn.frame)+20*2*_Scale, CGRectGetHeight(btn.frame)-CGRectGetMaxY(__image.frame))];
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
                        btn.frame=CGRectMake((65.0f/2.0f)*2*_Scale+(CGRectGetWidth(downview.frame)-45*2*2*_Scale-65*2*_Scale+45*2*_Scale)*i, (CGRectGetHeight(downview.frame)-42*2*_Scale)/2.0f, 45*2*_Scale, 42*2*_Scale);

                        btn.tag=100+i;
                        [btn addTarget:self action:@selector(caseBtn:) forControlEvents:UIControlEventTouchUpInside];
                        [downview addSubview:btn];
                        //            btn.backgroundColor=[UIColor redColor];
                        UIImageView *__image=[[UIImageView alloc] initWithFrame:CGRectMake(((CGRectGetWidth(btn.frame)-25*2*_Scale)/2.0f), 0, 25*2*_Scale, 25*2*_Scale)];
                        __image.image=[UIImage imageNamed:arrCase[i]];
                        //            __image.backgroundColor=[UIColor yellowColor];
                        [btn addSubview:__image];
                        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(-10*2*_Scale, CGRectGetMaxY(__image.frame)+3*2*_Scale, CGRectGetWidth(btn.frame)+20*2*_Scale, CGRectGetHeight(btn.frame)-CGRectGetMaxY(__image.frame))];
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
            //90 84

        } failed:^{
            JXLOG(@"失败");
        }];
    };
}

-(void)CreateNofollowerView
{
    nofollow=[[UIView alloc] initWithFrame:CGRectMake(0,(ScreenHeight-330*_Scale)/2.0f+64-kTabBarHeight, ScreenWidth, 330*_Scale)];
    [self.view addSubview:nofollow];


    UIImageView *imageview=[[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(nofollow.frame)-200*_Scale)/2.0f, 0, 200*_Scale, 233*_Scale)];
//    imageview.backgroundColor=[UIColor whiteColor];
    imageview.image=[UIImage imageNamed:@"NoUser"];
    [nofollow addSubview:imageview];

    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageview.frame), CGRectGetWidth(nofollow.frame), CGRectGetHeight(nofollow.frame)-CGRectGetMaxY(imageview.frame))];
    [nofollow addSubview:label];
//    label.backgroundColor=[UIColor yellowColor];
    label.font=[regular getFont:13.0f];
//    [label setAttributedText:[regular createAttributeString:@"没有粉丝" andFloat:@(2.0)]];
    label.textAlignment=1;
    label.textColor=[UIColor colorWithRed:150.0f/255.0f green:150.0f/255.0f  blue:150.0f/255.0f  alpha:1];
    nofollow.hidden=YES;
}

- (void)caseBtn:(UIButton *)btn
{
    usermodel *model=ArrayData[_rownum];
    if (btn.tag == 100) {
        //        NSArray *arrCase = nil;
        NSArray *arrLabel =nil;
        if(!_isguanzhu)
        {
            for (UIView *view in btn.subviews) {
                if([view isKindOfClass:[UIImageView class]])
                {

                    ((UIImageView *)view).image=[UIImage imageNamed:@"found_school_2_关闭icon"];
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

            NSString *str=[NSString stringWithFormat:@"%@/v1/follows?token=%@",DNS,[regular getToken]];

            NSDictionary *para = @{@"followable_id":[NSString stringWithFormat:@"%@",model.user_id],@"followable_type":@"user"};
            AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];

            [manager POST:str parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
                //                JXLOG(@"%@",responseObject);
                [regular removeProgress];
                id res = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                JXLOG(@"%@",res);
                if ([res[@"code"] integerValue] == 1) {

                     [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshChatList" object:nil];
                    _isguanzhu=YES;
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

//                JXLOG(@"失败");
                [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
            }];



        }else
        {
            //            arrCase = @[@"box_choose_添加1",@"message_select"];
            //            arrLabel = @[@"Add",@"Message"];
            arrLabel = @[@"取消关注",@"消息"];
            for (UIView *view in btn.subviews) {
                if([view isKindOfClass:[UIImageView class]])
                {

                    ((UIImageView *)view).image=[UIImage imageNamed:@"box_choose_添加1"];
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



            NSString *str=[NSString stringWithFormat:@"%@/v1/follows/cancel?token=%@",DNS,[regular getToken]];

            NSDictionary *para = @{@"followable_id":[NSString stringWithFormat:@"%@",model.user_id],@"followable_type":@"user"};
            AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];

            [manager POST:str parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
                //                JXLOG(@"%@",responseObject);
                [regular removeProgress];
                id res = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                JXLOG(@"%@",res);
                if ([res[@"code"] integerValue] == 1) {
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshChatList" object:nil];
                    _isguanzhu=NO;

                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

                [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
                JXLOG(@"失败");
            }];


        }



    }
    else
    {
        if(_isguanzhu)
        {

            [[self.view.window viewWithTag:1000] removeFromSuperview];
            //                    usermodel *model=(usermodel *)not.object;
            ChatViewController *chatVC = [[ChatViewController alloc] initWithChatter:model.ease_mob_username isGroup:NO];
            chatVC.userinfo=@{@"cell":model.cell,@"is_server":[NSNumber numberWithBool:model.is_server],@"uid":model.user_id};
//            chatVC.cell=model.cell;
//            chatVC.is_server=model.is_server;
            chatVC.uid=model.user_id;
            //    chatVC.title = model.username;
            [chatVC setH_title:model.username];
            chatVC.friend_head=model.avatar;
            chatVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:chatVC animated:YES];
            //        ease_mob_username
            
        }else
        {
            [[ToolManager sharedManager] alertTitle_Simple:@"关注之后才能聊天哦～"];
        }
        
        
    }
    
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
-(void)xiaoshi
{
    [[self.view.window viewWithTag:1000] removeFromSuperview];
}
-(void)setToken:(NSString *)token
{
    if (_token != token) {

        _token = [token copy];
        [self PrepareData];
        [self setupRefresh];
        
    }


}
//-(void)updateImg
//{
//    [ArrayData removeAllObjects];
//    [_tableView headerBeginRefreshing];
//}
//-(void)backloginout
//{
//    [ArrayData removeAllObjects];
//    [_tableView reloadData];
//
//}
-(void)CreateTableview
{
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight+kTabBarHeight) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    _tableView.sectionIndexColor = self.view.backgroundColor;
    _tableView.backgroundColor=_define_backview_color;
    [self.view addSubview:_tableView];


}
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [_tableView addHeaderWithTarget:self action:@selector(headerRereshing)];

    [_tableView headerBeginRefreshing];

    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [_tableView addFooterWithTarget:self action:@selector(footerRereshing)];

}
#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    nofollow.hidden=YES;
    _page=1;
    [self RequestData];
}
- (void)footerRereshing
{
    _page++;
    [self RequestData];
}

#pragma mark-tablebview代理方法
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)] ;
    [headerView setBackgroundColor:self.view.backgroundColor];
    return headerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 2*_Scale;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(ArrayData.count){
    return ArrayData.count;
    }
    return 0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //     EMConversation *conversation = [self.dataSource objectAtIndex:indexPath.row];
    //    [[NSNotificationCenter defaultCenter] postNotificationName:@"pushChatView" object:[self.dataSource objectAtIndex:indexPath.row]];
    [[NSNotificationCenter defaultCenter ] postNotificationName:@"pushChatView1" object:(usermodel *)ArrayData[indexPath.section]];

    //    ChatViewController *chatVC = [[ChatViewController alloc] initWithChatter:((usermodel *)ArrayData[indexPath.section]).ease_mob_username isGroup:NO];
    //    chatVC.title = ((usermodel *)ArrayData[indexPath.section]).username;
    //    [self.navigationController pushViewController:chatVC animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100*_Scale;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(ArrayData.count)
    {
    static NSString *cellid=@"cell";
    UserCell1 *cell=[tableView dequeueReusableCellWithIdentifier:cellid ];
    if(!cell)
    {
        cell=[[UserCell1 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];

    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
//    cell.model=ArrayData[indexPath.section];
    cell.dict=[[NSDictionary alloc] initWithObjectsAndKeys:ArrayData[indexPath.section],@"data",[NSNumber numberWithInteger:indexPath.section ],@"num",nil];
    cell.block=changeBlock;
    //    cell.textLabel.text=[[NSString alloc] initWithFormat:@"%ld",indexPath.section+1];
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
-(void)PrepareData
{
    _page=1;
    self.view.backgroundColor=_define_backview_color;
    ArrayData=[[NSMutableArray alloc] init];
}

-(void)RequestData
{

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters=[[NSDictionary alloc] initWithObjectsAndKeys:_token,@"token",[[NSString alloc] initWithFormat:@"%ld",(long)_page],@"page",nil];
    [manager GET:[[NSString alloc] initWithFormat:@"%@/v1/chats/followers",DNS] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *html = operation.responseString;
        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];

        if([[dict objectForKey:@"code"] integerValue]==1)
        {
            if(_page==1)
            {
                [ArrayData removeAllObjects];
            }
            NSArray *getarr=[usermodel parsingData:dict];
            if(getarr.count>0)
            {
                [ArrayData addObjectsFromArray:getarr];
                nofollow.hidden=YES;
            }else
            {

            }

            if(ArrayData.count==0)
            {
                nofollow.hidden=NO;
            }
            [_tableView reloadData];

        }else
        {
            [[ToolManager sharedManager] alertTitle_Simple:[dict objectForKey:@"message"]];
        }
        [_tableView headerEndRefreshing];
        [_tableView footerEndRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_tableView headerEndRefreshing];
        [_tableView footerEndRefreshing];
        [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden=YES;
    [[CustomTabbarController sharedManager] tabbarHide];
}
//-(void)viewWillDisappear:(BOOL)animated
//{
//    [[CustomTabbarController sharedManager] tabbarAppear];
//}
/*
 #pragma mark - Navigation

 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
