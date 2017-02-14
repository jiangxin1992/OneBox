//
//  collectionCell.m
//  OneBox
//
//  Created by 谢江新 on 15/3/11.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import "collectionCell.h"

#import "foundModel.h"

#define foundCellHeight 200*_Scale
#define labelHight 40*_Scale

@implementation collectionCell
{
    NSMutableArray *leftViewArray;
    NSArray *titleArr;
    NSMutableArray *rightViewArray;
    
    UIView *_backView;
    UIView *_rightView;
    UIView *_leftView;
    UIView *_middleView;
    UIButton *_deleteBtn;
    foundModel *model;
    NSInteger is_order_school;
}
-(void)UIConfig
{
    self.contentView.userInteractionEnabled=YES;
    [self createBackView];
    [self createLeftView];
    [self createMiddleView];
//    [self createRightView];
    [self createDeleteBtn];
}
-(void)createDeleteBtn
{
    _deleteBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat diameter=40;
    _deleteBtn.frame=CGRectMake(CGRectGetMaxX(_middleView.frame)+17.5,(CGRectGetHeight(_backView.frame)-diameter)/2.0f,diameter,diameter);
   
    [_deleteBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:_deleteBtn];
}
-(void)createBackView
{
    _backView=[[UIView alloc] initWithFrame:CGRectMake(3, 3, ScreenWidth-6, foundCellHeight-3)];
    _backView.userInteractionEnabled=YES;
    _backView.backgroundColor=[UIColor whiteColor];
    [self.contentView addSubview:_backView];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1)
    {
        NSNumber *n_rownum= _dict[@"rownum"];
        self.block([n_rownum integerValue]);

    }
}
-(void)deleteAction:(UIButton *)btn
{
    NSString *__type=self.dict[@"type"];
    //    block回调，删除

    if([__type isEqualToString:@"delete"])
    {
        UIAlertView *isdelete=[[UIAlertView alloc] initWithTitle:nil message:@"从心愿单移除该学校？" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];

        [isdelete show];

    }else
    {
        foundModel *model=self.dict[@"model"];
        if(_deleteBtn.selected)
        {
            _deleteBtn.selected=NO;

            [self.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"已取消目标" WithImg:@"Prompt_取消目标" Withtype:1]];
#pragma mark-删除目标学校
//            删除
            NSUserDefaults *dict=[NSUserDefaults standardUserDefaults];
            //    删除

            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

            NSString *_token=nil;
            if([dict objectForKey:@"token"]==nil)
            {
                _token=@"";
            }else
            {
                _token=[dict objectForKey:@"token"];
            }

            NSDictionary *parameters=@{@"token":_token};
            NSString *url=[[NSString alloc] initWithFormat:@"%@%@%ld",DNS,@"/v1/order_schools/",(long)is_order_school];
            [manager DELETE:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {

                NSString *html = operation.responseString;
                NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
                if([[dict objectForKey:@"code"] integerValue]==1)
                {

                }

                [[ToolManager sharedManager] removeProgress];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];
                [[ToolManager sharedManager] removeProgress];
            }];


        }else
        {
            [self.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"添加成功" WithImg:@"Prompt_成功添加目标" Withtype:1]];
            _deleteBtn.selected=YES;
//            添加目标学校

#pragma mark-添加目标学校
            NSString *str=[NSString stringWithFormat:@"%@/v1/order_schools",DNS];
            NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            //    创建可变request
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5];
            //    设定请求类型未post
            [request setHTTPMethod:@"POST"];
            //    创建包体
            NSUserDefaults *dict=[NSUserDefaults standardUserDefaults];
            NSString *_token=nil;
            if([dict objectForKey:@"token"]==nil)
            {
                _token=@"";
            }else
            {
                _token=[dict objectForKey:@"token"];
            }

            NSString *bodyStr=[[NSString alloc] initWithFormat:@"school_id=%@&token=%@",model.sid,_token];
            //    加入包体
            request.HTTPBody=[bodyStr dataUsingEncoding:NSUTF8StringEncoding];

            AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];

            //    进行网络请求（AF框架）
            [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {

                    NSString *html = operation.responseString;
                    NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
                    NSDictionary *dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];

                    //        进行解析以后的操作
//                    [self login_praise:data];

                if([[dict objectForKey:@"code"] intValue]==1)
                {
                    is_order_school=[[[dict objectForKey:@"data"] objectForKey:@"id"] integerValue];


                }else
                {
                     [[ToolManager sharedManager] alertTitle_Simple:[dict objectForKey:@"message"]];
                }



            }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self.window addSubview:[[ToolManager sharedManager] showSuccessfulOperationViewWithTitle:@"网络连接错误，请检查网络" WithImg:@"Prompt_网络出错白色" Withtype:1]];

                JXLOG(@"发生错误！%@",error);

            }];
            
            NSOperationQueue *queue = [[NSOperationQueue alloc] init];
            [queue addOperation:operation];

        }
    }
    
    
}
-(void)createLeftView
{
    if(_isPad)
    {
        _leftView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 543*_Scale, foundCellHeight-3)];

    }else
    {
        _leftView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 425*_Scale, foundCellHeight-3)];
    }

//    _leftView.backgroundColor=[UIColor blueColor];

    [_backView addSubview:_leftView];

    leftViewArray=[[NSMutableArray alloc] init];
    CGFloat labelheight=(foundCellHeight-10-5)/4;
    CGFloat _y_p=5;


    for (int i=0; i<4; i++) {

        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, _y_p, CGRectGetWidth(_leftView.frame), labelheight)];

        label.textAlignment=NSTextAlignmentRight;

        if (i==0) {
            label.textColor=[UIColor colorWithRed:204.0f/255.0f green:204.0f/255.0f blue:204.0f/255.0f alpha:1];

            label.font=[regular get_en_Font:14.0f];

        }else if(i==1)
        {
            label.textColor=_define_bluecell_color;

            label.font=[regular getFont:13.0f];
        }else
        {
            label.textColor=[UIColor colorWithRed:204.0f/255.0f green:204.0f/255.0f blue:204.0f/255.0f alpha:1];
            if(i==3)
            {
                label.font=[regular get_en_Font:11.0f];
            }else
            {
                label.font=[regular getFont:11.0f];
            }


        }
        if(i==2)
        {
            _y_p+=labelheight-5*_Scale;
        }else
        {
            _y_p+=labelheight;
        }
        
        [leftViewArray addObject:label];
        [_leftView addSubview:label];
    }

}
-(void)createMiddleView
{
    _middleView=[[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_leftView.frame), 0, 25, foundCellHeight-3)];
//        _middleView.backgroundColor=[UIColor redColor];
    [_backView addSubview:_middleView];

    UIView *_divisionView=[[UIView alloc] initWithFrame:CGRectMake((CGRectGetWidth(_middleView.frame)/2)-0.5, 5, 1,CGRectGetHeight(_middleView.frame)-10)];
    _divisionView.backgroundColor=_define_backview_color;
    [_middleView addSubview:_divisionView];

    
}
-(void)createRightView
{

    //    titlelabel
    _rightView=[[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_middleView.frame), 0,CGRectGetWidth(_backView.frame)-CGRectGetMaxX(_middleView.frame), foundCellHeight-20*_Scale)];
//    _rightView.backgroundColor=[UIColor redColor];
    [_backView addSubview:_rightView];
    //    _rightView.backgroundColor=[UIColor cyanColor];
    titleArr=@[@"建校",@"学生数",@"AP数",@"年级"];

    CGFloat titleWidth=_rightView.frame.size.width;
    CGFloat labelheight=(foundCellHeight-20*_Scale-10*_Scale)/4;
    //    CGFloat labelheight=(foundCellHeight-20*_Scale)/4;
    CGFloat _y_p1=10*_Scale;
    rightViewArray=[[NSMutableArray alloc] init];

    for (int i=0; i<4; i++) {
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0,_y_p1, titleWidth*1/3, labelheight)];
//label.backgroundColor=[UIColor cyanColor];
        label.textAlignment=2;
        label.font=[regular get_en_Font:11.0f];
        label.textColor=_define_bluecell_color;
        _y_p1+=labelheight;
        //        label.backgroundColor=[UIColor redColor];
       [rightViewArray addObject:label];
        [_rightView addSubview:label];



    }

    //   contentlalbel


    CGFloat _y_p2=10*_Scale;
    for (int i=0; i<4; i++) {
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake( titleWidth*1/3+5, _y_p2, titleWidth*2/3-5, labelheight)];
        label.textColor=[UIColor colorWithRed:204.0f/255.0f green:204.0f/255.0f blue:204.0f/255.0f alpha:1];
        label.font=[regular getFont:11.0f];

        label.text=titleArr[i];
        label.textAlignment=0;
        _y_p2+=labelheight;

//                label.backgroundColor=[UIColor cyanColor];
        [_rightView addSubview:label];

    }
}
-(void)change_num:(NSNotification *)not
{
    if([not.object integerValue]<[_dict[@"rownum"] integerValue])
    {
        NSInteger n_rownum= [_dict[@"rownum"] integerValue];

        n_rownum--;


        [_dict setObject:[NSNumber numberWithInteger:n_rownum] forKey:@"rownum"];

    }

}
-(void)setDict:(NSMutableDictionary *)dict
{

    if (_dict != dict) {
        _dict = [dict mutableCopy];

    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(change_num:) name:@"change_num" object:nil];
    model=dict[@"model"];
    is_order_school=model.is_order_school;
    
    NSArray *contentArray1=@[model.en_name,model.cn_name,model.city,model.web];
    for (int i=0; i<contentArray1.count; i++) {
        ((UILabel *)leftViewArray[i]).text=contentArray1[i];
    }
    NSArray *contentArray2=@[model.setup_year,model.total_students,model.ap_count,model.grade];
    for (int i=0; i<contentArray2.count; i++) {
        ((UILabel *)rightViewArray[i]).text=contentArray2[i];
    }

    if(model.if_order_school)
    {
        _deleteBtn.selected=YES;
//        _deleteBtn.userInteractionEnabled=NO;
    }else
    {
        _deleteBtn.selected=NO;
    }
    NSString *btnStr=nil;
    NSString *__type=self.dict[@"type"];
    if([__type isEqualToString:@"delete"])
    {
        btnStr=@"box_choose_关闭按钮";
        [_deleteBtn setBackgroundImage:[UIImage imageNamed:btnStr] forState:UIControlStateNormal];

    }else
    {

        [_deleteBtn setBackgroundImage:[UIImage imageNamed:@"box_choose_绿色圆点"] forState:UIControlStateSelected];
        btnStr=@"box_choose_添加";

        [_deleteBtn setBackgroundImage:[UIImage imageNamed:btnStr] forState:UIControlStateNormal];
        
    }
    
}

-(void)setViewFrame
{
    _leftView.frame=CGRectMake(_leftView.frame.origin.x, _leftView.frame.origin.y, ScreenWidth*5/8, _leftView.frame.size.height);

    _rightView.frame=CGRectMake(_leftView.frame.origin.x+_leftView.frame.size.width+ScreenWidth*1/16, 0,ScreenWidth*5/16, 100);
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self UIConfig];

    }
    return  self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
