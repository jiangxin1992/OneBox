//
//  AdmissionViewController.m
//  OneBox
//
//  Created by 谢江新 on 15/11/4.
//  Copyright © 2015年 谢江新. All rights reserved.
//

#import "AdmissionViewController.h"

@interface AdmissionViewController ()
{
    UILabel  *_imgv;
    DBImageView *head;
    UILabel *username;
    UILabel *title;
}
@end

@implementation AdmissionViewController

-(void)loadView
{
    self.view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth-2*_margin, 460*_Scale)];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=_define_backview_color;
    //    24 142
    head=[[DBImageView alloc] initWithFrame:CGRectMake((ScreenWidth-2*_margin-142*_Scale)/2.0f, 40*_Scale, 142*_Scale, 142*_Scale)];
    [self.view addSubview:head];
    head.layer.masksToBounds=YES;
    head.layer.cornerRadius=142*_Scale/2.0f;

    UIView *zhegai=[[UIView alloc] initWithFrame:CGRectMake(-1,-1 , CGRectGetWidth(head.frame)+2, CGRectGetWidth(head.frame)+2)];
    zhegai.backgroundColor=[UIColor clearColor];
    zhegai.layer.masksToBounds=YES;
    zhegai.layer.cornerRadius=CGRectGetWidth(zhegai.frame)/2.0f;
    zhegai.layer.borderColor = [_define_head_color CGColor];
    zhegai.layer.borderWidth = 4.0f;
    [head addSubview:zhegai];


    //10 45

}
-(void)setCurrentPage:(NSInteger)currentPage
{
    if (currentPage<0) {
        currentPage = _maxPage;
    }
    if (currentPage > _maxPage) {
        currentPage = 0;
    }
    _currentPage = currentPage;

    NSDictionary *dict=_array[_currentPage];


    NSArray *contentarr=@[@"username",@"title"];
//    15 40
    CGFloat _y_p=CGRectGetMaxY(head.frame)+15*_Scale;
    for (int i=0; i<2; i++) {
        UILabel *label=i==0?username:title;
        label=[[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth-2*_margin-300*_Scale*2)/2.0f, _y_p, 300*_Scale*2, 40*_Scale)];
        [self.view addSubview:label];
        label.textAlignment=1;
        if([dict objectForKey:contentarr[i]]==[NSNull null])
        {
            [label setAttributedText:[regular createAttributeString:[dict objectForKey:@"招生官"] andFloat:@(3.0f)]];
        }else
        {
            if([contentarr[i] isEqualToString:@""])
            {
                [label setAttributedText:[regular createAttributeString:@"招生官" andFloat:@(3.0f)]];
            }else
            {
                [label setAttributedText:[regular createAttributeString:[dict objectForKey:contentarr[i]] andFloat:@(0)]];
                
            }
            
        }
        if(i==0)
        {

            label.font=[regular get_en_Font:13.0f];
        }else
        {
            if(_isPad)
            {
                label.font=[UIFont fontWithName:@"Skia" size:20.0f];

            }else
            {
                label.font=[UIFont fontWithName:@"Skia" size:13.0f];

            }

        }

        label.textColor=i==0?_define_blue_color:[UIColor colorWithRed:135.0f/255.0f green:135.0f/255.0f blue:135.0f/255.0f alpha:1];
        _y_p+=CGRectGetHeight(label.frame);

    }

    if([dict objectForKey:@"avatar"]==[NSNull null])
    {

        head.image=[UIImage imageNamed:@"school_Admission_Default"];
    }else
    {
        if([[dict objectForKey:@"avatar"] isEqualToString:@""])
        {
            head.image=[UIImage imageNamed:@"school_Admission_Default"];
        }else
        {
            [head setImageWithPath:[dict objectForKey:@"avatar"]];
            head.placeHolder=[UIImage imageNamed:@"school_Admission_Default"];
            
        }


    }
    CGFloat _bianju=186*_Scale;
    CGFloat _diameter=80*_Scale;
    CGFloat _jiange=ScreenWidth-2*_margin-_bianju*2-_diameter*2;
//
    _y_p+=38*_Scale;

    for (int i=0; i<2; i++) {
         UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(_bianju+i*(_jiange+_diameter), _y_p, _diameter, _diameter);
        btn.tag=2200+i;
        [btn addTarget:self action:@selector(AdmissionAction:) forControlEvents:UIControlEventTouchUpInside];
        NSString *imagename=nil;
        if(i==0)
        {
            if(([dict objectForKey:@"cell"]!=[NSNull null]))
            {
                if([[dict objectForKey:@"cell"] isEqualToString:@""])
                {
                    imagename=@"school_电话_gray";

                }else
                {
                    imagename=@"school_电话";
                }

            }else
            {
                imagename=@"school_电话_gray";
            }

        }else if(i==1)
        {
            if(([dict objectForKey:@"email"]!=[NSNull null]))
            {
                if([[dict objectForKey:@"email"] isEqualToString:@""])
                {
                    imagename=@"school_邮箱_gray";

                }else
                {
                    imagename=@"school_邮箱";
                }

            }else
            {
                imagename=@"school_邮箱_gray";
            }
        }
        [btn setBackgroundImage:[UIImage imageNamed:imagename] forState:UIControlStateNormal];

        [self.view addSubview:btn];
    }
}
-(void)AdmissionAction:(UIButton *)btn
{
    if(btn.tag-2200==0)
    {
//        NSLog(@"currentPage=%ld",(long)_currentPage);

//        NSDictionary *__dict=[_array objectAtIndex:_currentPage];
//        NSInteger _num=btn.tag-2200;
//        self.block(__dict,(btn.tag-2200));

    }else if(btn.tag-2200==1)
    {
//        NSLog(@"currentPage=%ld",(long)_currentPage);

//        NSDictionary *__dict=[_array objectAtIndex:_currentPage];
//        NSInteger _num=btn.tag-2200;
//        self.block(__dict,(btn.tag-2200));
    }
    NSDictionary *dict=[[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInteger:btn.tag-2200],@"key",[_array objectAtIndex:_currentPage],@"content",nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Admissionblock" object:dict];

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
