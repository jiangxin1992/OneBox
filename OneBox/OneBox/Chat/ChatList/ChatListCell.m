/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */


#import "UIImageView+EMWebCache.h"

#import "ChatListCell.h"

@interface ChatListCell (){
    UILabel *_timeLabel;
    UILabel *_unreadLabel;
    UILabel *_detailLabel;
    UIView *_lineView;
}

@end

@implementation ChatListCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(440*_Scale, 14*_Scale, 200*_Scale, 32*_Scale)];
        _timeLabel.textColor=[UIColor colorWithRed:200.0f/255.0f green:200.0f/255.0f blue:200.0f/255.0f alpha:1];
        _timeLabel.font = [regular get_en_Font:11.0f];
        _timeLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_timeLabel];
        
        _unreadLabel = [[UILabel alloc] initWithFrame:CGRectMake(86*_Scale, 7*_Scale,36*_Scale, 36*_Scale)];
        _unreadLabel.backgroundColor = [UIColor redColor];
        _unreadLabel.textColor = [UIColor whiteColor];

        _unreadLabel.textAlignment = NSTextAlignmentCenter;
        _unreadLabel.font = [regular get_en_Font:11.0f];
        _unreadLabel.layer.cornerRadius = 9;
        _unreadLabel.clipsToBounds = YES;
        [self.contentView addSubview:_unreadLabel];
        
        _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(130*_Scale, 60*_Scale, 350*_Scale, 40*_Scale)];
        _detailLabel.backgroundColor = [UIColor clearColor];

        _detailLabel.font = [regular get_en_Font:12.0f];
        _detailLabel.textColor = [UIColor colorWithRed:200.0f/255.0f green:200.0f/255.0f blue:200.0f/255.0f alpha:1];
        [self.contentView addSubview:_detailLabel];
        
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.textColor=[UIColor colorWithRed:159.0f/255.0f green:159.0f/255.0f blue:159.0f/255.0f alpha:1];
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, 1)];
        _lineView.backgroundColor = _define_backview_color;
        [self.contentView addSubview:_lineView];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (![_unreadLabel isHidden]) {
        _unreadLabel.backgroundColor = [UIColor redColor];
    }
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    if (![_unreadLabel isHidden]) {
        _unreadLabel.backgroundColor = [UIColor redColor];
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    CGRect frame = self.imageView.frame;
    
    [self.imageView sd_setImageWithURL:_imageURL placeholderImage:_placeholderImage];
    self.imageView.frame = CGRectMake(20*_Scale, 14*_Scale, 90*_Scale, 90*_Scale);
    self.imageView.layer.masksToBounds=YES;
    self.imageView.layer.cornerRadius=CGRectGetWidth(self.imageView.frame)/2.0f;

    UIView *zhegai=[[UIView alloc] initWithFrame:CGRectMake(-1,-1 , CGRectGetWidth(self.imageView.frame)+2, CGRectGetWidth(self.imageView.frame)+2)];
    zhegai.backgroundColor=[UIColor clearColor];
    zhegai.layer.masksToBounds=YES;
    zhegai.layer.cornerRadius=CGRectGetWidth(zhegai.frame)/2.0f;
    zhegai.layer.borderColor = [_define_head_color CGColor];
    zhegai.layer.borderWidth = 2.0f;
    [self.imageView addSubview:zhegai];


    self.textLabel.text = _name;
    self.textLabel.frame = CGRectMake(130*_Scale, 14*_Scale, 350*_Scale, 40*_Scale);
    
    _detailLabel.text = _detailMsg;
    _timeLabel.text = _time;
    [self setImageURL:[NSURL URLWithString:_imagename]];
    if (_unreadCount > 0) {
        if (_unreadCount < 9) {
            _unreadLabel.font =[regular get_en_Font:13];
        }else if(_unreadCount > 9 && _unreadCount < 99){
            _unreadLabel.font = [regular get_en_Font:12];
        }else{
            _unreadLabel.font = [regular get_en_Font:10];
        }
        [_unreadLabel setHidden:NO];
        [self.contentView bringSubviewToFront:_unreadLabel];
        _unreadLabel.text = [NSString stringWithFormat:@"%ld",(long)_unreadCount];
    }else{
        [_unreadLabel setHidden:YES];
    }
    
    frame = _lineView.frame;
    frame.origin.y = self.contentView.frame.size.height - 1;
    _lineView.frame = frame;
}
-(void)setImagename:(NSString *)imagename
{
    [self setImageURL:[NSURL URLWithString:imagename]];
}
-(void)setName:(NSString *)name{
    _name = name;

    self.textLabel.text = name;
    self.textLabel.font=[regular get_en_Font:13.0f];
}

+(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120*_Scale;
}
@end
