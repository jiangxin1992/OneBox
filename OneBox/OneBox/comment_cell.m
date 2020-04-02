//
//  comment_cell.m
//  OneBox
//
//  Created by 谢江新 on 15/2/25.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import "comment_cell.h"

#import "Tools.h"

#import "comment_model_alter.h"

@implementation comment_cell
{
    DBImageView *headImg;
    UILabel *_content;
    UIView *_footView;
    NSMutableArray *_view_array;
    
    comment_model_alter *cell_model;
    NSNumber *cell_height;
    BOOL islast;
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
-(void)UIConfig
{
    islast=NO;
    self.backgroundColor=[UIColor clearColor];

    headImg=[[DBImageView alloc] initWithFrame:CGRectMake(36*_Scale, 14*_Scale, 80*_Scale, 80*_Scale)];
    headImg.userInteractionEnabled=YES;

    headImg.layer.masksToBounds=YES;
    headImg.layer.cornerRadius=80*_Scale/2;
//    headImg.layer.borderWidth=1;
//    headImg.layer.borderColor=[[UIColor whiteColor]CGColor];
    headImg.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [headImg addGestureRecognizer:tap];
    [self.contentView addSubview:headImg];
    UIView *zhegai=[[UIView alloc] initWithFrame:CGRectMake(-1,-1 , CGRectGetWidth(headImg.frame)+2, CGRectGetWidth(headImg.frame)+2)];
    zhegai.backgroundColor=[UIColor clearColor];
    zhegai.layer.masksToBounds=YES;
    zhegai.layer.cornerRadius=CGRectGetWidth(zhegai.frame)/2.0f;
    zhegai.layer.borderColor = [_define_head_color CGColor];
    zhegai.layer.borderWidth = 2.0f;
    [headImg addSubview:zhegai];

//
    _content=[[UILabel alloc] init];
    _content.text=cell_model.content;
    _content.textColor=[UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1];
    _content.textAlignment=0;
    _content.numberOfLines=0;
//    _content.backgroundColor=[UIColor redColor];
    _content.font=[regular getFont:14.0f];
    [self.contentView addSubview:_content];
    
    
    _view_array=[[NSMutableArray alloc] init];
    CGFloat _width=0;
    CGFloat _x_p=CGRectGetMaxX(headImg.frame)+20*_Scale;
    CGFloat _y_p=self.frame.size.height-10*_Scale-30*_Scale;
    for (int i=0; i<4; i++) {

_width=i==0?170*_Scale:i==1?25*_Scale*17/15:i==2?200*_Scale:(ScreenWidth-_x_p-40*_Scale);

        CGRect _rect=CGRectMake(_x_p, _y_p, _width, 30*_Scale);
        if(i==1||i==3)
        {
            UIButton *_btn=[UIButton buttonWithType:UIButtonTypeCustom];

            if(i==1)
            {
                _btn.frame=CGRectMake(_x_p, _y_p, _width, 25*_Scale);
                [_btn setBackgroundImage:[UIImage imageNamed:@"comment_赞"] forState:UIControlStateNormal];

                [_btn setBackgroundImage:[UIImage imageNamed:@"comment_赞点击"] forState:UIControlStateSelected];
            }else
            {
                _btn.frame=_rect;
                [_btn setTitle:@"删 除" forState:UIControlStateNormal];

                _btn.titleLabel.font=[regular getFont:9.0f];

                [_btn setTitleColor:[UIColor colorWithRed:255.0f/255.0f green:102.0f/255.0f blue:0 alpha:1] forState:UIControlStateNormal];
                [_btn setTitle:@"" forState:UIControlStateSelected];
            }
            
            _btn.tag=50+i;
            [_btn addTarget:self action:@selector(praise_action:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:_btn];
            [_view_array addObject:_btn];
            
            
        }else
        {
            CGFloat _font=i==0?12.0f:14.0f;
            UILabel *_label=[[UILabel alloc] initWithFrame:_rect];
            _label.font=[regular get_en_Font:_font];
            UIColor *_color=i==0?[UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1]:i==2?[UIColor colorWithRed:255.0f/255.0f green:153.0f/255.0f blue:0 alpha:1]:[UIColor colorWithRed:255.0f/255.0f green:102.0f/255.0f blue:0 alpha:1];
            _label.textColor=_color;

            [self.contentView addSubview:_label];
            [_view_array addObject:_label];
        }
        _x_p+=_width;
    }

    
}
-(void)tapAction:(UIGestureRecognizer *)sender
{
    
//        NSInteger _num=[_dict[@"rownum"] integerValue];
        self.block(_dict[@"rownum"],4);


}

-(void)praise_action:(UIButton *)btn
{
    NSInteger _type=0;
    if(btn.tag-50==1)
    {
        
        if([regular isLogin])
        {
            if(btn.selected==YES)
            {
                btn.selected=NO;
                _type=1;
            }else
            {
                btn.selected=YES;
                _type=2;
            }
        }else
        {
            _type=10;
        }

        
        
    }else if(btn.tag-50==3)
    {
//        删除



    }
//     NSInteger _num=[_dict[@"rownum"] integerValue];
    self.block(_dict[@"rownum"],_type);
}
-(void)setDict:(NSDictionary *)dict
{

    if (_dict != dict) {
        _dict = [dict copy];
    }
    islast=[dict[@"islast"] boolValue];
    cell_model=dict[@"cellmodel"];
    cell_height=dict[@"cellheight"];
//    时间戳转换
    
    [self setdata];
}

-(void)setdata
{


    [self setHeadImg];

    CGFloat _height=0;
    if(islast)
    {
        _height=[cell_height floatValue]-CGRectGetMaxY(headImg.frame)-26*_Scale-20*_Scale;
    }else
    {
        _height=[cell_height floatValue]-CGRectGetMaxY(headImg.frame)-26*_Scale;
    }
    UIView *_fuck=[[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(headImg.frame)+CGRectGetWidth(headImg.frame)/2.0f, CGRectGetMaxY(headImg.frame)+10*_Scale, 1*_Scale,_height)];

    _fuck.backgroundColor=[UIColor colorWithRed:204.0f/255.0f green:204.0f/255.0f blue:204.0f/255.0f alpha:1];
    [self.contentView addSubview:_fuck];

    [self setRightView];
    
}
-(void)setRightView
{
    [self upPart];
    [self downPart];
}
-(void)downPart
{
    
    
    for (int i=0; i<_view_array.count; i++) {
        if(i==1||i==3)
        {
        
            UIButton *_btn=_view_array[i];
            _btn.frame=CGRectMake(_btn.frame.origin.x, CGRectGetMaxY(_content.frame)+10*_Scale, _btn.frame.size.width, _btn.frame.size.height);
            if(i==3)
            {

                NSString *_uid=[[NSString alloc] initWithFormat:@"%ld",(long)[[regular getUID] integerValue]];
                if(![_uid isEqualToString:cell_model.user_id])
                {
                    _btn.selected=YES;
                    _btn.userInteractionEnabled=NO;
                }else
                {
                    _btn.selected=NO;
                    _btn.userInteractionEnabled=YES;

                }
            }else if(i==1)
            {
                BOOL is_p=cell_model.had_voted;
                if(is_p)
                {
                    _btn.selected=YES;
                }else
                {
                    _btn.selected=NO;
                }
            }
        }else
        {
            UILabel *_label=_view_array[i];
            _label.frame=CGRectMake(_label.frame.origin.x, CGRectGetMaxY(_content.frame)+10*_Scale, _label.frame.size.width, _label.frame.size.height);

            if(i==2)
            {
                _label.text=[[NSString alloc] initWithFormat:@"  %ld",(long)cell_model.votes_count ];
                 _label.font=[regular get_en_Font:10.0f];
                
            }else if(i==0)
            {
                NSString *title=cell_model.created_at;

                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                [dateFormat setDateFormat:@"YYYY-MM-dd HH:mm:SS"];
                //    [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
                NSDate *date = [dateFormat dateFromString:title];
                JXLOG(@"Nsdate=%@",date);

                 [dateFormat setDateFormat:@"MM/dd HH:mm"];
                NSString *dateTime = [dateFormat stringFromDate:date];

                _label.textColor=_define_blue_color;
                _label.text=dateTime;
                _label.font=[regular get_en_Font:9.0f];
            }
 
        }
        
        
    }
}
-(void)upPart
{
    CGRect _rect_content;
    if(islast)
    {
        _rect_content=CGRectMake(CGRectGetMaxX(headImg.frame)+20*_Scale, 20*_Scale, ScreenWidth-36*_Scale-80*_Scale-20*_Scale-54*_Scale, [cell_height floatValue]-102*_Scale-150*_Scale);
    }else
    {
        _rect_content=CGRectMake(CGRectGetMaxX(headImg.frame)+20*_Scale, 20*_Scale, ScreenWidth-36*_Scale-80*_Scale-20*_Scale-54*_Scale, [cell_height floatValue]-102*_Scale);
    }

    _content.frame=_rect_content;
    NSMutableAttributedString *attributedString =[[NSMutableAttributedString alloc] initWithString:cell_model.content attributes:@{NSKernAttributeName : @(1.0)}];

    //设置行间距


    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];

    [paragraphStyle setLineSpacing:2];//调整行间距

    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [cell_model.content length])];
    _content.textColor=[UIColor colorWithRed:150.0f/255.0f green:150.0f/255.0f blue:150.0f/255.0f alpha:1];
    _content.attributedText = attributedString;
    [_content sizeToFit];

//    _content.text=cell_model.content;

}
-(void)setHeadImg
{
   
    if(![cell_model.user_avatar isEqualToString:@"headImg_login1"])
    {

        NSString *_img_url=[[NSString alloc] initWithFormat:@"%@",cell_model.user_avatar];
        [headImg setPlaceHolder:[UIImage imageNamed:@"headImg_login1"]];
        
        [headImg setImageWithPath:_img_url];
    }else
    {
        [headImg setImage:[UIImage imageNamed:cell_model.user_avatar]];
    }

}
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
