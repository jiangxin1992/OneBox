//
//  OnlineProjectsViewController.m
//  OneBox
//
//  Created by 谢江新 on 15/6/9.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import "OnlineProjectsViewController.h"

#import "suggestViewController.h"
#import "ChatViewController.h"
#import "CustomTabbarController.h"
#import "LoginViewController.h"

#import "usermodel.h"

@interface OnlineProjectsViewController ()<UIActionSheetDelegate>

@end

@implementation OnlineProjectsViewController
{
    UIView *_noFollowsView;
    UIScrollView *_scrollview;
    NSMutableArray *dataArr;
    NSMutableString *phone_num;
    UIView *backview;

}
-(void)setIslogin:(NSString *)islogin
{
    if(_islogin!=islogin)
    {
        _islogin=[islogin copy];
        if([self.islogin isEqualToString:@"1"])
        {
            [self loginConfig];
            [self RequestData];
            backview.hidden=YES;
            _scrollview.hidden=NO;
        }else
        {
            [self UnloginConfig];
            _scrollview.hidden=YES;
            backview.hidden=NO;
        }
    }
}
-(void)xiaoshi:(NSNotification *)not
{
    if([not.object isEqualToString:@"other"])
    {
        [self dismissModalViewControllerAnimated:YES];
    }
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    [self prepare];

}



-(void)RequestData
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    [manager GET:[[NSString alloc] initWithFormat:@"%@%@%@",DNS,@"/v1/users/online_servers?token=",[regular getToken]] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSString *html = operation.responseString;
        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];

        if([[dict objectForKey:@"code"] integerValue]==1)
        {
            [dataArr removeAllObjects];
            if([[dict objectForKey:@"data"] count])
            {
                [dataArr addObjectsFromArray:[usermodel parsingData:dict]];

                    _noFollowsView.hidden=YES;
                    _scrollview.contentSize=CGSizeMake(CGRectGetWidth(_scrollview.frame), 526*_Scale*dataArr.count+10*_Scale);
                    CGFloat _y_p=10*_Scale;
                    for (int i=0; i<dataArr.count; i++) {
                        UIView *card=[self createCardView:dataArr[i] WithTag:i];
                        card.frame=CGRectMake(16*_Scale, _y_p, CGRectGetWidth(card.frame), CGRectGetHeight(card.frame));
                        [_scrollview addSubview:card];
                        _y_p+=526*_Scale;
                    }
            }else
            {
                 _noFollowsView.hidden=NO;
            }

        }else
        {
            [[ToolManager sharedManager] alertTitle_Simple:[dict objectForKey:@"message"]];
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
        [[ToolManager sharedManager] removeProgress];
    }];
}
-(UIView *)createCardView:(usermodel *)model WithTag:(NSInteger )tag
{
//    10 16
    UIView *card=[[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_scrollview.frame)-16*_Scale*2, 516*_Scale)];
    card.backgroundColor=[UIColor whiteColor];

//    50 180
//    UIImageView *head
    DBImageView *headview=[[DBImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(card.frame)-180*_Scale)/2.0f, 50*_Scale, 180*_Scale, 180*_Scale)];
    headview.layer.masksToBounds=YES;
    headview.layer.cornerRadius=CGRectGetWidth(headview.frame)/2.0f;
    UIView *zhegai=[[UIView alloc] initWithFrame:CGRectMake(-1,-1 , CGRectGetWidth(headview.frame)+2, CGRectGetWidth(headview.frame)+2)];
    zhegai.backgroundColor=[UIColor clearColor];
    zhegai.layer.masksToBounds=YES;
    zhegai.layer.cornerRadius=CGRectGetWidth(zhegai.frame)/2.0f;
    zhegai.layer.borderColor = [_define_head_color CGColor];
    zhegai.layer.borderWidth = 4.0f;
    [headview addSubview:zhegai];

    if([model.avatar isEqualToString:@""])
    {
        headview.image=[UIImage imageNamed:@"headImg_login1"];
    }else
    {
        [headview setPlaceHolder:[UIImage imageNamed:@"headImg_login1"]];
        [headview setImageWithPath:model.avatar];
    }
    [card addSubview:headview];
//    34 56 60
    NSArray *arrcontent=@[model.username,model.title];
    CGFloat _y_p=CGRectGetMaxY(headview.frame)+30*_Scale;
    for (NSUInteger i=0; i<arrcontent.count; i++) {
        CGFloat _height=i==0?50*_Scale:50*_Scale;
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, _y_p, CGRectGetWidth(card.frame), _height)];
        label.textAlignment=1;
        label.font=i==0?[regular get_en_Font:18.0f]:[regular getFont:13.0f];
        label.textColor=i==0?_define_blue_color:[UIColor colorWithRed:135.0f/255.0f green:135.0f/255.0f blue:135.0f/255.0f alpha:1];
        [label setAttributedText:[regular createAttributeString:arrcontent[i] andFloat:i==0?@(2.0):@(5.0f)]];

        _y_p+=_height;
        [card addSubview:label];
    }

    _y_p+=30*_Scale;
    CGFloat _jiange=CGRectGetWidth(card.frame)-155*_Scale*2-80*_Scale*2;
//    34  155 80

    for (int i=0; i<2; i++) {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        [card addSubview:btn];
        btn.frame=CGRectMake(155*_Scale+i*(80*_Scale+_jiange),_y_p , 80*_Scale, 80*_Scale);
        NSString *imagename=i==0?@"school_电话":@"school_信息";
        [btn setBackgroundImage:[UIImage imageNamed:imagename] forState:UIControlStateNormal];
        btn.tag=i==0?(tag+1000):(tag+100);
        if(i==0)
        {
            [btn setBackgroundImage:[UIImage imageNamed:@"school_电话_gray"] forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(callAction:) forControlEvents:UIControlEventTouchUpInside];
            if([model.cell isEqualToString:@""])
            {
                btn.selected=YES;

            }else
            {
                btn.selected=NO;
            }

        }else
        {
            [btn addTarget:self action:@selector(chatAction:) forControlEvents:UIControlEventTouchUpInside];
        }

    }


    return card;
}

-(void)callAction:(UIButton *)btn
{
    if(!btn.selected)
    {
        usermodel *model=dataArr[btn.tag-1000];
        [phone_num setString:model.cell];


        UIActionSheet *phoneSheet=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:model.cell otherButtonTitles: nil];
        phoneSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [phoneSheet showInView:self.view];
    }
}
-(void)chatAction:(UIButton *)btn
{
    usermodel *model=dataArr[btn.tag-100];
    ChatViewController *chatVC = [[ChatViewController alloc] initWithChatter:model.ease_mob_username isGroup:NO];
    [chatVC setH_title:model.username];
    chatVC.userinfo=@{@"cell":model.cell,@"is_server":[NSNumber numberWithBool:model.is_server],@"uid":model.user_id};
    chatVC.uid=model.user_id;
    chatVC.friend_head=model.avatar;
    chatVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatVC animated:YES];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[[NSString alloc] initWithFormat:@"tel://%@",phone_num]]];
    }
}

-(void)UnloginConfig
{
    if(backview==nil)
    {
        backview=[[UIView alloc] initWithFrame:CGRectMake(0, (ScreenHeight-700*_Scale)/2.0f, ScreenWidth,700*_Scale)];
        backview.backgroundColor=[UIColor clearColor];
        [self.view addSubview:backview];

        UIButton *login_btn=[UIButton buttonWithType:UIButtonTypeCustom];
        login_btn.frame=CGRectMake((CGRectGetWidth(backview.frame)-400*_Scale)/2.0f, 0, 400*_Scale, 380*_Scale);
        [backview addSubview:login_btn];
        login_btn.backgroundColor=[UIColor clearColor];
        [login_btn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
        for (int i=0; i<2; i++) {

            if(i==0)
            {
                UIView *view_back=[[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(login_btn.frame), 320*_Scale)];
                UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(login)];
                [view_back addGestureRecognizer:tap];
                view_back.userInteractionEnabled=YES;
                [login_btn addSubview:view_back];
                view_back.backgroundColor=[UIColor whiteColor];
                CGFloat _y_p=78*_Scale;
                for (int j=0; j<3; j++) {
                    if(j==0)
                    {
                        UIImageView *imageview=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"head_未登陆"]];
                        imageview.frame=CGRectMake((CGRectGetWidth(view_back.frame)-115*_Scale)/2.0f, _y_p, 115*_Scale, 115*_Scale);
                        [view_back addSubview:imageview];
                        _y_p+=CGRectGetHeight(imageview.frame)+20*_Scale;
                        imageview.userInteractionEnabled=YES;
                    }else
                    {
                        UILabel *_label=[[UILabel alloc] initWithFrame:CGRectMake(0, _y_p, CGRectGetWidth(view_back.frame), 40*_Scale)];
                        [view_back addSubview:_label];
                        _label.textAlignment=1;
                         [_label setAttributedText:[regular createAttributeString:j==1?@"登录后":@"与在线专案直聊" andFloat:@(2.0)]];
                        _label.textColor=_define_blue_color;
                        _label.font=[regular getFont:12.0f];
                        _y_p+=CGRectGetHeight(_label.frame);
                    }
                }


            }else if(i==1)
            {
                UILabel *_label=[[UILabel alloc] initWithFrame:CGRectMake(0,320*_Scale+2 , CGRectGetWidth(login_btn.frame), CGRectGetHeight(login_btn.frame)-320*_Scale-2)];
                [login_btn addSubview:_label];
                [_label setAttributedText:[regular createAttributeString:@"登陆" andFloat:@(3.0)]];
                _label.textColor=[UIColor whiteColor];
                _label.font=[regular getFont:13.0f];
                _label.textAlignment=1;
                _label.backgroundColor=_define_blue_color;
            }
        }


        //    55 55 115 55 55
        NSArray *content=@[@"或",@"留下您的联系方式和问题",@"我们稍后致电给您"];
        CGFloat _y_p=CGRectGetMaxY(login_btn.frame);
        for (int i=0; i<content.count; i++) {
            CGFloat _width=i==0?200*_Scale:ScreenWidth;
            CGFloat _height=i==0?115*_Scale:55*_Scale;
            CGFloat _jianju=3.0f;
            NSString *_content_str=content[i];
            CGRect _rect=CGRectMake((ScreenWidth-_width)/2.0f, _y_p, _width, _height);

                UILabel *label=[[UILabel alloc] initWithFrame:_rect];
                [backview addSubview:label];
                label.textAlignment=1;
                label.textColor=_define_blue_color;
                label.font=[regular getFont:13.0f];
                [label setAttributedText:[regular createAttributeString:_content_str andFloat:@(_jianju)]];

            _y_p+=_height;
        }
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake((CGRectGetWidth(backview.frame)-60*_Scale)/2.0f, _y_p+10*_Scale, 60*_Scale, 60*_Scale);
        [backview addSubview:btn];
        [btn addTarget:self action:@selector(suggest) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundImage:[UIImage imageNamed:@"setting_意见"] forState:UIControlStateNormal];
    }
}
-(void)suggest
{
    [self.navigationController pushViewController:[suggestViewController new] animated:YES];
}
-(void)login
{
    LoginViewController*login=[[LoginViewController alloc] init];
    login.type=@"other";
    [self presentModalViewController:login animated:YES];
}

-(void)loginConfig
{
    [self CreateScrollView];
    [self NoProjectsView];
}

-(void)NoProjectsView
{
    if(_noFollowsView==nil)
    {
        _noFollowsView=[[UIView alloc] initWithFrame:CGRectMake(0, (ScreenHeight-300*_Scale-164)/2.0f, CGRectGetWidth(_scrollview.frame), 300*_Scale)];
        [_scrollview addSubview:_noFollowsView];
        //    _noFollowsView.backgroundColor=[UIColor redColor];
        //    90 300 130
        UIButton *suggestBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        suggestBtn.frame=CGRectMake((CGRectGetWidth(_noFollowsView.frame)-300*_Scale)/2.0f, 70*_Scale, 300*_Scale, 130*_Scale);
        //    suggestBtn.backgroundColor=[UIColor yellowColor];
        [suggestBtn addTarget:self action:@selector(suggestionAction:) forControlEvents:UIControlEventTouchUpInside];
        [_noFollowsView addSubview:suggestBtn];

        //    13 62 62
        UIImageView *imageview=[[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(suggestBtn.frame)-62*_Scale)/2.0f, 13*_Scale, 62*_Scale, 62*_Scale)];
        imageview.image=[UIImage imageNamed:@"setting_意见"];
        [suggestBtn addSubview:imageview];

        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageview.frame)+10*_Scale, CGRectGetWidth(suggestBtn.frame), CGRectGetHeight(suggestBtn.frame)-CGRectGetMaxY(imageview.frame)-10*_Scale)];
        //    label.backgroundColor=[UIColor blueColor];
        [suggestBtn addSubview:label];
        label.textColor=[UIColor colorWithRed:150.0f/255.0f green:150.0f/255.0f blue:150.0f/255.0f alpha:1];
        label.textAlignment=1;
        label.font=[regular getFont:11.0f];
        [label setAttributedText:[regular createAttributeString:@"没有在线的专案?" andFloat:@(3.0)]];
        NSArray *titleArr=@[@"留下您的联系方式和问题",@"我们会第一时间联系你"];
        //    18 80
        for (int i=0; i<titleArr.count; i++) {
            UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(suggestBtn.frame)+18*_Scale+34*_Scale*i, CGRectGetWidth(_noFollowsView.frame), 34*_Scale)];
            [_noFollowsView addSubview:label];
            label.textAlignment=1;
            label.textColor=_define_blue_color;
            label.font=[regular getFont:12.0f];
            [label setAttributedText:[regular createAttributeString:titleArr[i] andFloat:@(2.0)]];
        }
        
        _noFollowsView.hidden=YES;
    }

}
-(void)suggestionAction:(UIButton *)btn
{
    [self.navigationController pushViewController:[suggestViewController new] animated:YES];

}
-(void)CreateScrollView
{
    if(_scrollview==nil)
    {
        _scrollview=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight+kTabBarHeight)];
        [self.view addSubview:_scrollview];
        _scrollview.contentSize=CGSizeMake(ScreenWidth, ScreenHeight-64);
    }
}
-(void)reload
{
    [self loginConfig];
    [self RequestData];
    backview.hidden=YES;
    _scrollview.hidden=NO;
    _scrollview.frame=CGRectMake(0, 64, ScreenWidth, ScreenHeight-64);
}
-(void)prepare
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload) name:@"reload" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(xiaoshi:) name:@"xiaoshi" object:nil];
    phone_num=[[NSMutableString alloc] init];
    dataArr=[[NSMutableArray alloc] init];
    self.view.backgroundColor= _define_backview_color;
    self.navigationItem.titleView=[regular returnNavView:@"推荐专案" withmaxwidth:230];
    UIButton *_leftBarbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [_leftBarbtn setImage:[UIImage imageNamed:@"返回箭头"] forState:UIControlStateNormal];
    _leftBarbtn.frame=CGRectMake(0, 0, 22, 22);
    [_leftBarbtn addTarget:self action:@selector(popviewAction) forControlEvents:UIControlEventTouchUpInside];
    [_leftBarbtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    UIBarButtonItem *_btn=[[UIBarButtonItem alloc] initWithCustomView:_leftBarbtn];
    self.navigationItem.leftBarButtonItem=_btn;
}
-(void)popviewAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"OnlineProjectsViewController"];
}
-(void)viewWillAppear:(BOOL)animated
{
//    self.tabBarController.tabBar.hidden=YES;
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"OnlineProjectsViewController"];

    [[CustomTabbarController sharedManager] tabbarHide];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end
