//
//  chooseForgetViewController.m
//  OneBox
//
//  Created by 谢江新 on 15/11/20.
//  Copyright © 2015年 谢江新. All rights reserved.
//

#import "chooseForgetViewController.h"

#import "resetPasswordemialViewController.h"
#import "RetrievePasswordController.h"

@interface chooseForgetViewController ()

@end

@implementation chooseForgetViewController
{

    UIImageView *backgroundImg;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareData];
    [self UIConfig];
    resetpasswordBlock=^()
    {
        [self dismissModalViewControllerAnimated:YES];
    };
    resetpasswordBlock2=^()
    {
        self.block();
    };


}
-(void)prepareData
{

    backgroundImg=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    if(_isPad)
    {
        backgroundImg.backgroundColor=_define_login_background;

    }else
    {
        backgroundImg.image=[UIImage imageNamed:@"login_背景层"];
    }
    [self.view addSubview:backgroundImg];

}
-(void)UIConfig
{
    self.view.backgroundColor=[UIColor colorWithRed:86.0f/255.0f green:190.0f/255.0f blue:215.0f/255.0f alpha:1];

    UIButton *back_btn=[UIButton getCustomImgBtnWithImageStr:@"login_返回" WithSelectedImageStr:nil];
    [self.view addSubview:back_btn];
    [back_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(50*_Scale);
        make.top.mas_equalTo(self.mas_topLayoutGuideBottom).with.offset(20*_Scale);
        make.right.mas_equalTo(-55*_Scale);
    }];
    [back_btn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    back_btn.imageEdgeInsets = UIEdgeInsetsMake(12.5*_Scale, 12.5*_Scale, 12.5*_Scale, 12.5*_Scale);

    for (int i=0; i<2; i++) {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        if(_isPad)
        {
            btn.frame=CGRectMake((ScreenWidth-100*2*_Scale)/2.0f, (ScreenHeight-100*2*_Scale)/2.0f+50*2*_Scale*i, 100*2*_Scale, 50*2*_Scale);

        }else
        {
            btn.frame=CGRectMake((ScreenWidth-100*2*_Scale)/2.0f, 200*2*_Scale+50*2*_Scale*i, 100*2*_Scale, 50*2*_Scale);
        }

        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitle:i==0?@"手 机 找 回":@"邮 箱 找 回" forState:UIControlStateNormal];
        [self.view addSubview:btn];
        btn.titleLabel.font=[regular getFont:11.0f];
        btn.tag=100+i;
        [btn addTarget:self action:@selector(BtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
}
-(void)BtnAction:(UIButton *)btn
{
    if(btn.tag==100)
    {

//        手机找回
        RetrievePasswordController *ret=[[RetrievePasswordController alloc] init];
        ret.type=self.type;
        ret.type1=@"forget";
        ret.block2=resetpasswordBlock2;
        ret.block=resetpasswordBlock;
        [self presentModalViewController:ret animated:YES];

    }else
    {
//        密码找回
        resetPasswordemialViewController *ret=[[resetPasswordemialViewController alloc] init];
        ret.type=self.type;
        ret.block2=resetpasswordBlock2;
        ret.block=resetpasswordBlock;
        [self presentModalViewController:ret animated:YES];

    }
}
-(void)backAction:(UIButton *)btn
{
    self.block();
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
