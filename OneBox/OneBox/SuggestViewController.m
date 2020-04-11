//
//  SuggestViewController.m
//  OneBox
//
//  Created by 谢江新 on 15/7/22.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import "SuggestViewController.h"

#import "CustomTabbarController.h"

@interface SuggestViewController ()<UITextViewDelegate>

@end

@implementation SuggestViewController
{
    UITextView *textView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self uiconfig];
}
-(void)uiconfig
{
    UIButton*btn1=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44*2*_Scale, 44*_Scale)];
    [btn1 setTitle:@"取消" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn1.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    [btn1 addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    btn1.titleLabel.font=(kIOSVersions>=9.0? [UIFont systemFontOfSize:13.0f]:[UIFont fontWithName:@"Helvetica Neue" size:13.0f]);
    UIBarButtonItem *barleft=[[UIBarButtonItem alloc] initWithCustomView:btn1];
    self.navigationItem.leftBarButtonItem=barleft;

    UIButton*btn2=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44*2*_Scale, 44*_Scale)];
    [btn2 setTitle:@"发送" forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn2.titleLabel.font=(kIOSVersions>=9.0? [UIFont systemFontOfSize:13.0f]:[UIFont fontWithName:@"Helvetica Neue" size:13.0f]);
    btn2.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
    [btn2 addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barright=[[UIBarButtonItem alloc] initWithCustomView:btn2];
    self.navigationItem.rightBarButtonItem=barright;

    self.navigationItem.titleView=[regular returnNavView:@"给我们发信吧" withmaxwidth:180];

    self.view.backgroundColor=_define_backview_color;
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(10*2*_Scale, 64*2*_Scale+10*2*_Scale, ScreenWidth-20*2*_Scale, 200*2*_Scale)];
    [self.view addSubview:view];

    textView = [[UITextView alloc] initWithFrame:CGRectMake(20, 40, [UIScreen mainScreen].bounds.size.width - 40, 300)];

    textView.font = [UIFont systemFontOfSize:14];
    textView.textColor = [UIColor blackColor];
    textView.backgroundColor = [UIColor clearColor];
    textView.textAlignment = NSTextAlignmentLeft;
    textView.delegate = self;
    textView.returnKeyType = UIReturnKeyDefault;//返回键的类型
    textView.keyboardType = UIKeyboardTypeDefault;//键盘类型
    [view addSubview: textView];//加入到整个页面中
    [textView becomeFirstResponder];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [regular dismissKeyborad];
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
     [regular dismissKeyborad];
}
-(void)sendAction
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *Url = [NSString stringWithFormat:@"%@/v1/reports?token=%@",DNS,[regular getToken]];
    NSDictionary *dict = @{@"content":textView.text};
    [manager POST:Url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *html = operation.responseString;
        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
        if([[dict objectForKey:@"code"] integerValue]==1)
        {
            [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"提交成功" WithImg:@"Prompt_提交成功" Withtype:1]];
        }else
        {
             [[ToolManager sharedManager] alertTitle_Simple:[dict objectForKey:@"message"]];
        }

        [self.navigationController popViewControllerAnimated:YES];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       [self.view.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
        JXLOG(@"失败");
    }];
}
-(void)cancelAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"SuggestViewController"];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"SuggestViewController"];
    [[CustomTabbarController sharedManager] tabbarHide];
}

@end
