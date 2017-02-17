//
//  AdmissionOfficerViewController.m
//  OneBox
//
//  Created by 谢江新 on 15/8/13.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import "AdmissionOfficerViewController.h"

#import "HttpRequestManager.h"
#import "MJRefresh.h"

#import "followerViewController.h"
#import "followingViewController.h"
#import "ChatViewController.h"

#import "UserCell.h"

#import "usermodel.h"

@interface AdmissionOfficerViewController ()<UITableViewDataSource,UITableViewDelegate, SWTableViewCellDelegate>

@end

@implementation AdmissionOfficerViewController
{
    BOOL _isguanzhu;
    BOOL _iswillapp;
    BOOL _isfirstload;
    NSMutableArray *ArrayData;
    UITableView *_tableView;
    NSInteger _page;


    NSMutableString *friend_token;
    NSMutableArray *btnarr;
    UIImageView *imageGray;
    NSInteger _rownum;
    UIView *nofollow;
}
-(void)xiaoshi
{
    [[self.view.window viewWithTag:1000] removeFromSuperview];
}
-(void)backaction:(UIGestureRecognizer *)ges
{

}
-(void)friend_list:(UIGestureRecognizer *)ges
{
    //    friend_list
    if(ges.view.tag==6000)
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"following" object:friend_token];

        [self xiaoshi];


    }else
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"follower" object:friend_token];

        [self xiaoshi];

    }
}
-(void)CreateNofollowerView
{
    nofollow=[[UIView alloc] initWithFrame:CGRectMake(0,(ScreenHeight-330*_Scale)/2.0f-kTabBarHeight-80*_Scale, ScreenWidth, 330*_Scale)];
    [self.view addSubview:nofollow];
    //    nofollow.backgroundColor=[UIColor redColor];

    UIImageView *imageview=[[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(nofollow.frame)-200*_Scale)/2.0f, 0, 200*_Scale, 233*_Scale)];
    imageview.image=[UIImage imageNamed:@"NoUser"];
    //    imageview.backgroundColor=[UIColor whiteColor];
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
#pragma mark－粉丝
- (void)viewDidLoad {
    [super viewDidLoad];
    _iswillapp=NO;
    _isfirstload=YES;
    [self PrepareData];
    [self CreateTableview];
    [self CreateNofollowerView];


    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backloginout) name:@"backloginout" object:nil];


    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshList) name:@"selectmap" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateImg) name:@"updateImg" object:nil];

    changeBlock=^(NSNumber *rownum)
    {
        //        _rownum=[rownum integerValue];
        //        [btnarr removeAllObjects];
        //        NSInteger _num=[rownum integerValue];
        //        usermodel *model=ArrayData[_num];
        //        imageGray = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"蒙板"]];
        //        imageGray.tag=1000;
        //        imageGray.userInteractionEnabled = YES;
        //        imageGray.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        //        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(xiaoshi)];
        //        [imageGray addGestureRecognizer:tap];
        //        [self.view.window addSubview:imageGray];
        //
        //        //    360 400
        //        UIImageView *backview=[[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(imageGray.frame)-180)/2.0f, (CGRectGetHeight(imageGray.frame)-250)/2.0f, 180,198)];
        //        //    backview.backgroundColor=[UIColor whiteColor];
        //        backview.image=[UIImage imageNamed:@"蒙板"];
        //        [imageGray addSubview:backview];
        //        backview.userInteractionEnabled=YES;
        //        UITapGestureRecognizer *tap1=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backaction:)];
        //        [backview addGestureRecognizer:tap1];
        //
        //        UIImageView *delete=[[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(backview.frame)-18, CGRectGetMinY(backview.frame)-10, 28, 28)];
        //        [imageGray addSubview:delete];
        //        delete.image=[UIImage imageNamed:@"found_school_2_关闭icon"];
        //        delete.userInteractionEnabled=YES;
        //        UITapGestureRecognizer *tap_delete=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(xiaoshi)];
        //        [delete addGestureRecognizer:tap_delete];
        //        [imageGray addSubview:delete];
        //
        //        UIView *upview=[[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(backview.frame), 140)];
        //        [backview addSubview:upview];
        //        upview.backgroundColor=_define_blue_color;
        //
        //        UIView *middle=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(upview.frame), CGRectGetWidth(backview.frame), 78)];
        //        middle.backgroundColor=[UIColor whiteColor];
        //        [backview addSubview:middle];
        //
        //
        ////        UIView *downview=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(middle.frame)+2, CGRectGetWidth(backview.frame), CGRectGetHeight(backview.frame)-CGRectGetMaxY(upview.frame)-80)];
        ////        //    downview.backgroundColor=[UIColor redColor];
        ////        [backview addSubview:downview];
        ////        downview.backgroundColor=[UIColor whiteColor];
        //
        //        //((usermodel *)ArrayData[_num])
        //        NSString *url = [NSString stringWithFormat:@"%@/v1/users/%@?token=%@",DNS,model.user_id,[regular getToken]];
        //        [HttpRequestManager GET:url complete:^(NSData *data) {
        //
        //            NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
        //
        //            if([[[dict objectForKey:@"data"] objectForKey:@"had_followed"] integerValue]==0)
        //            {
        //                _isguanzhu=NO;
        //            }else
        //            {
        //                _isguanzhu=YES;
        //            }
        //            //            [friend_token setString:[regular getToken]];
        //            [friend_token setString:[regular getToken]];
        //
        //
        //            CGFloat ___jiange=(CGRectGetWidth(middle.frame)-80)/3.0f;
        //            for (int i=0; i<2; i++) {
        //
        //                UIImageView *_imagev=[[UIImageView alloc] initWithFrame:CGRectMake(___jiange+(80*_Scale+___jiange)*i, 24*_Scale, 80*_Scale, 80*_Scale)];
        //                [middle addSubview:_imagev];
        //                _imagev.layer.masksToBounds=YES;
        //                _imagev.layer.cornerRadius=CGRectGetWidth(_imagev.frame)/2.0f;
        //                UITapGestureRecognizer *friend_list=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(friend_list:)];
        //                _imagev.tag=6000+i;
        //                [_imagev addGestureRecognizer:friend_list];
        //                _imagev.userInteractionEnabled=YES;
        //                _imagev.layer.borderWidth=1;
        //                _imagev.layer.borderColor=[[UIColor colorWithRed:200.0f/255.0f green:200.0f/255.0f blue:200.0f/255.0f alpha:1] CGColor];
        //                UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_imagev.frame), CGRectGetHeight(_imagev.frame))];
        //                [_imagev addSubview:label];
        //                label.textAlignment=1;
        //                label.textColor=[UIColor colorWithRed:79.0f/255.0f green:190.0f/255.0f blue:221.0f/255.0f alpha:0.8];
        //                label.font=[regular get_en_Font:15.0f];
        //                label.text=i==0?[[NSString alloc] initWithFormat:@"%ld",(long)[[[dict objectForKey:@"data"] objectForKey:@"following_count"] integerValue]]:[[NSString alloc] initWithFormat:@"%ld",(long)[[[dict objectForKey:@"data"] objectForKey:@"follows_count"] integerValue]];
        //
        //                UILabel *label1=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_imagev.frame)-15,CGRectGetMaxY(_imagev.frame),CGRectGetWidth(_imagev.frame)+30,CGRectGetHeight(middle.frame)-CGRectGetMaxY(_imagev.frame))];
        //                [middle addSubview:label1];
        //                label1.textAlignment=1;
        //                label1.font=[regular get_en_Font:10.0f];
        //                label1.text=i==0?@"Following":@"Follower";
        //                label1.textColor=[UIColor colorWithRed:200.0f/255.0f green:200.0f/255.0f blue:200.0f/255.0f alpha:1];
        //
        //
        //            }
        //
        //
        //            DBImageView * iconImage1 = [[DBImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(upview.frame)-60)/2.0f, 12, 60, 60)];
        //            [upview addSubview:iconImage1];
        //            iconImage1.userInteractionEnabled = YES;
        //            iconImage1.layer.masksToBounds = YES;
        //            iconImage1.layer.cornerRadius = iconImage1.frame.size.width/2.0;
        //
        //            if(([[dict objectForKey:@"data"] objectForKey:@"avatar"]!=[NSNull null])&&([[dict objectForKey:@"data"] objectForKey:@"avatar"]!=nil))
        //            {
        //                NSString *__url=[[dict objectForKey:@"data"] objectForKey:@"avatar"];
        //                [iconImage1 setImageWithPath:__url];
        //                iconImage1.placeHolder=[UIImage imageNamed:@"headImg_login1"];
        //            }else
        //            {
        //                iconImage1.image=[UIImage imageNamed:@"headImg_login1"];
        //            }
        //            //        NSMutableArray *arr=[[NSMutableArray alloc] init];
        //            NSArray *arrtitle=@[@"username",@"city",@"mark"];
        //            NSDictionary *__dict=[dict objectForKey:@"data"];
        //            CGFloat __y_p=CGRectGetMaxY(iconImage1.frame)+15*_Scale;
        //            CGFloat __height=(CGRectGetHeight(upview.frame)-CGRectGetMaxY(iconImage1.frame)-35*_Scale)/3.0f;
        //
        //            for (int i=0; i<3; i++) {
        //                UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, __y_p, CGRectGetWidth(upview.frame), __height)];
        //                __y_p+=__height;
        //                [upview addSubview:label];
        //                label.textColor=[UIColor whiteColor];
        //                label.textAlignment=1;
        //                CGFloat __font=i==0?13.0f:i==2?11.0f:11.0f;
        //                label.font=[regular getFont:__font];
        //                if(([__dict objectForKey:arrtitle[i]]!=[NSNull null])&&([__dict objectForKey:arrtitle[i]]!=nil))
        //                {
        //
        //                    [label setAttributedText:[regular createAttributeString:[__dict objectForKey:arrtitle[i]] andFloat:@(1.0)]];
        //                }else
        //                {
        //                    [label setAttributedText:[regular createAttributeString:@"" andFloat:@(1.0)]];
        //
        //                }
        //
        //            }
        //
        //
        ////            NSArray *arrCase = nil;
        ////
        ////            NSArray *arrLabel =nil;
        ////            if(_isguanzhu)
        ////            {
        ////                arrCase = @[@"found_school_2_关闭icon",@"message_normal"];
        ////                arrLabel = @[@"Unfollow",@"Message"];
        ////
        ////            }else
        ////            {
        ////                arrCase = @[@"box_choose_添加1",@"message_select"];
        ////                arrLabel = @[@"Follow",@"Message"];
        ////            }
        //            //90 84
        ////            CGFloat _y_p=(CGRectGetHeight(downview.frame)-42)/2.0f;
        ////            for (int i = 0 ; i < 2; i ++) {
        ////                UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        ////                btn.frame=CGRectMake((65.0f/2.0f)+(CGRectGetWidth(downview.frame)-45*2-65+45)*i, (CGRectGetHeight(downview.frame)-42)/2.0f, 45, 42);
        ////
        ////                btn.tag=10000+i;
        ////                [btn addTarget:self action:@selector(caseBtn:) forControlEvents:UIControlEventTouchUpInside];
        ////                [downview addSubview:btn];
        ////                //            btn.backgroundColor=[UIColor redColor];
        ////                UIImageView *__image=[[UIImageView alloc] initWithFrame:CGRectMake(((CGRectGetWidth(btn.frame)-25)/2.0f), 0, 25, 25)];
        ////                __image.image=[UIImage imageNamed:arrCase[i]];
        ////                //            __image.backgroundColor=[UIColor yellowColor];
        ////                [btn addSubview:__image];
        ////                UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(-10, CGRectGetMaxY(__image.frame)+3, CGRectGetWidth(btn.frame)+20, CGRectGetHeight(btn.frame)-CGRectGetMaxY(__image.frame))];
        ////                [btn addSubview:label];
        ////                label.textColor=[UIColor colorWithRed:200.0f/255.0f green:200.0f/255.0f blue:200.0f/255.0f alpha:1];
        ////                label.textAlignment=1;
        ////                //            label.backgroundColor=[UIColor greenColor];
        ////                label.font=[regular getFont:10.0f];
        ////                [label setAttributedText:[regular createAttributeString:arrLabel[i] andFloat:@(1.0)]];
        ////                [btnarr addObject:btn];
        ////
        ////            }
        //
        //        } failed:^{
        ////            JXLOG(@"失败");
        //             [[ToolManager sharedManager] alertTitle_Simple:@"Network connection error, please check your connection."];
        //        }];
    };
}
-(void)refreshList
{
    [self headerRereshing];
}
- (void)caseBtn:(UIButton *)btn
{
    JXLOG(@"%@",btnarr);

    usermodel *model=ArrayData[_rownum];
    if (btn.tag == 10000) {
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

                    _isguanzhu=YES;
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

                //                JXLOG(@"失败");
                [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
            }];



        }else
        {
            [ArrayData removeObjectAtIndex:_rownum];
            [_tableView reloadData];
            [self xiaoshi];
            //            arrCase = @[@"box_choose_添加1",@"message_select"];
            //            arrLabel = @[@"Add",@"Message"];

            arrLabel = @[@"取消关注",@"Message"];
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
                    _isguanzhu=NO;

                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

                //                JXLOG(@"失败");
                [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
            }];


        }
    }
    else
    {
        if(_isguanzhu)
        {

            [[self.view.window viewWithTag:1000] removeFromSuperview];
            //                    usermodel *model=(usermodel *)not.object;
            [[NSNotificationCenter defaultCenter ] postNotificationName:@"pushChatView1" object:(usermodel *)ArrayData[_rownum]];


            //            ChatViewController *chatVC = [[ChatViewController alloc] initWithChatter:model.ease_mob_username isGroup:NO];
            //            //    chatVC.title = model.username;
            //            [chatVC setH_title:model.username];
            //            chatVC.hidesBottomBarWhenPushed = YES;
            //            [self.navigationController pushViewController:chatVC animated:YES];
            //        ease_mob_username

        }else
        {
            [[ToolManager sharedManager] alertTitle_Simple:@"关注之后才能聊天哦～"];
        }


    }

}
-(void)updateImg
{
    [ArrayData removeAllObjects];
    [_tableView headerBeginRefreshing];
}
-(void)backloginout
{
    _page=1;
    [ArrayData removeAllObjects];
    [_tableView reloadData];

}
-(void)CreateTableview
{
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-kTabBarHeight-80*_Scale-64) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    _tableView.sectionIndexColor = self.view.backgroundColor;
    _tableView.backgroundColor=_define_backview_color;
    _tableView.showsVerticalScrollIndicator=NO;

    [self.view addSubview:_tableView];
    [self setupRefresh];

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
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//
//
//        usermodel *model=ArrayData[indexPath.section];
//        [ArrayData removeObjectAtIndex:indexPath.section];
//        [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section]  withRowAnimation:UITableViewRowAnimationFade];
//
//        NSString *str=[NSString stringWithFormat:@"%@/v1/follows/cancel?token=%@",DNS,[regular getToken]];
//
//        NSDictionary *para = @{@"locale":@"en",@"followable_id":[NSString stringWithFormat:@"%@",model.user_id],@"followable_type":@"user"};
//        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
//        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//
//        [manager POST:str parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            //                JXLOG(@"%@",responseObject);
//            [regular removeProgress];
//            id res = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//            JXLOG(@"%@",res);
//            if ([res[@"code"] integerValue] == 1) {
////                _isguanzhu=NO;
//
//            }
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//
////            JXLOG(@"失败");
//             [[ToolManager sharedManager] alertTitle_Simple:@"Network connection error, please check your connection."];
//        }];
//
//
//
//
//    }
//    else if (editingStyle == UITableViewCellEditingStyleInsert) {
//        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
//    }
//}
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
    if(ArrayData.count)
    {
        return  ArrayData.count;
    }
    return 0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    usermodel *modle =(usermodel *)ArrayData[indexPath.section];
    if(modle.is_block1==1)
    {
        [[NSNotificationCenter defaultCenter ] postNotificationName:@"pushChatView1" object:(usermodel *)ArrayData[indexPath.section]];
    }else
    {

        [[ToolManager sharedManager] alertTitle_Simple:@"您已被对方拉黑"];
    }

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160*_Scale;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(ArrayData.count)
    {
        static NSString *cellid=@"cell";
        //    UserCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid ];
        //    if(!cell)
        //    {
//        NSMutableArray *leftUtilityButtons = [NSMutableArray new];
//        NSMutableArray *rightUtilityButtons = [NSMutableArray new];
//
//        NSString *_blocktitle=nil;
//        NSInteger _is_block2=((usermodel *)ArrayData[indexPath.section]).is_block2;

//        if(_is_block2==1)
//        {
//            _blocktitle=@"拉黑";
//        }else
//        {
//            _blocktitle=@"取消拉黑";
//        }
//        BOOL is_following=((usermodel *)ArrayData[indexPath.section]).is_following;
//        NSString *is_following_str=nil;
//        if(is_following)
//        {
//            is_following_str=@"取消关注";
//        }else
//        {
//            is_following_str=@"关注";
//        }
//
//
//        [rightUtilityButtons addUtilityButtonWithColor:
//         [UIColor colorWithRed:80.0f/255.0f green:190.0f/255.0f blue:210.0f/255.0f alpha:1.0f]
//                                                 title:is_following_str];
//
//        [rightUtilityButtons addUtilityButtonWithColor:
//         [UIColor colorWithRed:95.0f/255.0f green:213.0f/255.0f blue:174.0f/255.0f alpha:1.0]
//                                                 title:_blocktitle];
//        [rightUtilityButtons addUtilityButtonWithColor:
//         [UIColor colorWithRed:242.0f/255.0f green:107.0f/255.0f blue:85.0f/255.0f alpha:1.0f]
//                                                 title:@"移除"];

        UserCell *cell = [[UserCell alloc] initWithStyle1:UITableViewCellStyleSubtitle
                                          reuseIdentifier:cellid
                                      containingTableView:_tableView // Used for row height and selection
                                       leftUtilityButtons:nil
                                      rightUtilityButtons:nil];
        cell.delegate = self;

        //    }
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
    cell.backgroundColor=self.view.backgroundColor;
    return cell;

}

- (void)swippableTableViewCell:(UserCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
        {
            NSIndexPath *indexPathAll = [_tableView indexPathForCell:cell];
            usermodel *model=ArrayData[indexPathAll.section];
            BOOL __isguanzhu;
            if(model.is_following)
            {
                __isguanzhu=YES;
            }else
            {
                __isguanzhu=NO;
            }


            if(!__isguanzhu)
            {


                model.is_following=YES;
                NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:indexPathAll.section];
                [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
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

                        model.is_following=YES;
                    }else
                    {
                        model.is_following=NO;
                    }
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

                    model.is_following=NO;
                    //                JXLOG(@"失败");
                    [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
                }];



            }else
            {
                //                [ArrayData removeObjectAtIndex:_rownum];
                //                [_tableView reloadData];
                //                [self xiaoshi];

                model.is_following=NO;
                NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:indexPathAll.section];
                [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];

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
                        model.is_following=NO;

                    }else
                    {
                        model.is_following=YES;

                    }
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    model.is_following=YES;
                    //                JXLOG(@"失败");
                    [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
                }];


            }



        }
        case 1:
        {

            NSIndexPath *indexPathAll = [_tableView indexPathForCell:cell];
            usermodel *model=ArrayData[indexPathAll.section];


            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            NSDictionary *parameters=[[NSDictionary alloc] initWithObjectsAndKeys:[regular getToken],@"token",model.user_id,@"user_id",@"user",@"followable_type",@"follower",@"block_type",nil];
            [manager POST:[[NSString alloc] initWithFormat:@"%@/v1/follows/change_block",DNS] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSString *html = operation.responseString;
                NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
                if([[dict objectForKey:@"code"] intValue]==1)
                {
                    [[EaseMob sharedInstance].chatManager removeConversationByChatter:model.ease_mob_username deleteMessages:YES append2Chat:YES];
                    if(model.is_block2==1)
                    {
                        model.is_block2=0;
                    }else
                    {
                        model.is_block2=1;
                    }
                    //                    [_tableView reloadData];
                    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:indexPathAll.section];
                    [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];

                    JXLOG(@"1111");
                }else
                {
                    [[ToolManager sharedManager] alertTitle_Simple:[dict objectForKey:@"message"]];
                }

            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
            }];


            //            [cell hideUtilityButtonsAnimated:YES];

            break;
        }
        case 2:
        {

            NSIndexPath *indexPathAll = [_tableView indexPathForCell:cell];
            usermodel *model=ArrayData[indexPathAll.section];
            [ArrayData removeObjectAtIndex:indexPathAll.section];
            [_tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPathAll.section]  withRowAnimation:UITableViewRowAnimationFade];

            if(!ArrayData.count)
            {
                nofollow.hidden=NO;

            }else
            {
                nofollow.hidden=YES;

            }

            NSString *str=[NSString stringWithFormat:@"%@/v1/follows/remove?token=%@",DNS,[regular getToken]];

            NSDictionary *para = @{@"user_id":[NSString stringWithFormat:@"%@",model.user_id],@"followable_type":@"user"};
            AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];

            [manager POST:str parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
                //                JXLOG(@"%@",responseObject);
                [regular removeProgress];
                id res = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                JXLOG(@"%@",res);
                if ([res[@"code"] integerValue] == 1) {

                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

                [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
            }];

            break;
        }
        default:
            break;
    }
}


-(void)PrepareData
{
    friend_token=[[NSMutableString alloc] init];
    btnarr=[[NSMutableArray alloc] init];
    _page=1;
    self.view.backgroundColor=_define_backview_color;
    ArrayData=[[NSMutableArray alloc] init];
}

-(void)RequestData
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters=[[NSDictionary alloc] initWithObjectsAndKeys:[regular getToken],@"token",[[NSString alloc] initWithFormat:@"%ld",(long)_page],@"page",nil];

    [manager GET:[[NSString alloc] initWithFormat:@"%@/v1/chats/servers",DNS] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *html = operation.responseString;
        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];

        if([[dict objectForKey:@"code"] integerValue]==1)
        {
            NSInteger _oldcount=ArrayData.count;
            BOOL _isshuaxin;
            if(_page==1)
            {
                [ArrayData removeAllObjects];
            }
            NSArray *getarr=[usermodel parsingData:dict];
            if(getarr.count>0)
            {
                
                if(ArrayData.count>0&&_page==1)
                {
                    
                }else
                {
                    [ArrayData addObjectsFromArray:getarr];
                    nofollow.hidden=YES;
                    
                }
            }else
            {
                
            }
            if(ArrayData.count==0)
            {
                nofollow.hidden=NO;
            }
            if(_oldcount==ArrayData.count)
            {
                _isshuaxin=NO;
            }else
            {
                _isshuaxin=YES;
            }
            
            
            if(_iswillapp&&(!_isshuaxin)&&(ArrayData.count>0))
            {
                NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
                [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
                
            }else
            {
                [_tableView reloadData];
            }
            for (int i=0; i<ArrayData.count; i++) {
                
                usermodel *model=(usermodel *)ArrayData[i];
                if(!model.is_block1||!model.is_block2)
                {
                    [[EaseMob sharedInstance].chatManager removeConversationByChatter:model.ease_mob_username deleteMessages:YES append2Chat:YES];
                }
            }
            
            
        }else
        {
            //            [[ToolManager sharedManager] alertTitle_Simple:[dict objectForKey:@"message"]];
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
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"FriendsViewController"];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"FriendsViewController"];
    nofollow.hidden=YES;
    _page=1;
    if(_isfirstload)
    {
        _isfirstload=NO;
    }else
    {
        _iswillapp=YES;
        [self RequestData];
    }
    
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
