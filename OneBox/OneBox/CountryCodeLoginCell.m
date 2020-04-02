//
//  CountryCodeCell.m
//  OneBox
//
//  Created by 谢江新 on 15/11/6.
//  Copyright © 2015年 谢江新. All rights reserved.
//

#import "CountryCodeLoginCell.h"

@implementation CountryCodeLoginCell
{
    UILabel *country;
    UILabel *code;
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.contentView.backgroundColor=_define_blue_color;
        country=[[UILabel alloc] init];
        code=[[UILabel alloc] init];

    }
    return  self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
}
-(void)setDict:(NSDictionary *)dict
{
    CGFloat _width=0;
    for (int i=0; i<2; i++) {

        _width=i==0?(ScreenWidth-30)/2.0f:((ScreenWidth-30)/2.0f)-20;

        UILabel *label=i==0?country:code;
        label.frame=CGRectMake(15+i*(ScreenWidth-200-30)/2.0f,0, _width, 60*_Scale);
        [self addSubview:label];

        label.text=i==0?[dict objectForKey:@"country"]:[[NSString alloc] initWithFormat:@"+%@",[dict objectForKey:@"code"]];
        label.textAlignment=i==0?0:2;

        label.textColor=[UIColor whiteColor];
        if(i==0)
        {
            label.font=[regular getFont:14.0f];

        }else
        {
            label.font=[regular get_en_Font:14.0f];

        }
    }


}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
