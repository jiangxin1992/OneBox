//
//  UIView+Frame.m
//  百思不得姐
//
//  Created by qianfeng on 16/3/9.
//  Copyright (c) 2016年 谢翼华. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)

-(void)setFr_width:(CGFloat)fr_width{

    CGRect frame = self.frame;
    frame.size.width  = fr_width;
    self.frame  = frame;
}

-(CGFloat)fr_width{

    return self.frame.size.width;
}

-(void)setFr_height:(CGFloat)fr_height{
    
    CGRect frame = self.frame;
    frame.size.height  = fr_height;
    self.frame  = frame;
}

-(CGFloat)fr_height{

    return self.frame.size.height;
}

-(void)setFr_x:(CGFloat)fr_x{

    CGRect frame = self.frame;
    frame.origin.x = fr_x;
    self.frame  = frame;
    
}

-(CGFloat)fr_x{

    return self.frame.origin.x;
}

-(void)setFr_y:(CGFloat)fr_y{
    
    CGRect frame = self.frame;
    frame.origin.y = fr_y;
    self.frame  = frame;
    
}

-(CGFloat)fr_y{
    
    return self.frame.origin.y;
}
@end
