//
//  suggestViewController.m
//  OneBox
//
//  Created by 谢江新 on 15/7/22.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import "suggestViewController.h"

#import "CustomTabbarController.h"

@interface suggestViewController ()<UITextViewDelegate>

@end

@implementation suggestViewController
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
//    btn1.backgroundColor=[UIColor redColor];
    btn1.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    [btn1 addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    btn1.titleLabel.font=(kIOSVersions>=9.0? [UIFont systemFontOfSize:13.0f]:[UIFont fontWithName:@"Helvetica Neue" size:13.0f]);
    UIBarButtonItem *barleft=[[UIBarButtonItem alloc] initWithCustomView:btn1];
    self.navigationItem.leftBarButtonItem=barleft;

    UIButton*btn2=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44*2*_Scale, 44*_Scale)];
    [btn2 setTitle:@"发送" forState:UIControlStateNormal];
//    btn2.backgroundColor=[UIColor redColor];
    [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn2.titleLabel.font=(kIOSVersions>=9.0? [UIFont systemFontOfSize:13.0f]:[UIFont fontWithName:@"Helvetica Neue" size:13.0f]);
    btn2.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
    [btn2 addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barright=[[UIBarButtonItem alloc] initWithCustomView:btn2];
    self.navigationItem.rightBarButtonItem=barright;

    self.navigationItem.titleView=[regular returnNavView:@"给我们发信吧" withmaxwidth:180];

    self.view.backgroundColor=_define_backview_color;
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(10*2*_Scale, 64*2*_Scale+10*2*_Scale, ScreenWidth-20*2*_Scale, 200*2*_Scale)];
//    view.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:view];

    textView = [[UITextView alloc] initWithFrame:CGRectMake(0,-140*_Scale, ScreenWidth-20*2*_Scale, 200*2*_Scale)] ; //初始化大小并自动释放
    textView.contentSize=CGSizeMake( ScreenWidth-20*2*_Scale, 100*_Scale);
    textView.textColor = [UIColor blackColor];//设置textview里面的字体颜色

    textView.font = [regular getFont:14.0f];//设置字体名字和字体大小

    textView.delegate = self;//设置它的委托方法
    textView.textAlignment=0;
    textView.backgroundColor = [UIColor clearColor];//设置它的背景颜色


//    self.textView.text = @"Now is the time for all good developers to come to serve their country.\n\nNow is the time for all good developers to come to serve their country.";//设置它显示的内容

    textView.returnKeyType = UIReturnKeyDefault;//返回键的类型

    textView.keyboardType = UIKeyboardTypeDefault;//键盘类型

//    textView.scrollEnabled = YES;//是否可以拖动



//    textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应高度

    [view addSubview: textView];//加入到整个页面中
    [textView becomeFirstResponder];

}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];

}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
     [[[UIApplication sharedApplication] keyWindow] endEditing:YES];

}
-(void)sendAction
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *Url = [NSString stringWithFormat:@"%@/v1/reports?token=%@",DNS,[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]];
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
    // Dispose of any resources that can be recreated.
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"suggestViewController"];

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"suggestViewController"];
    [[CustomTabbarController sharedManager] tabbarHide];
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
