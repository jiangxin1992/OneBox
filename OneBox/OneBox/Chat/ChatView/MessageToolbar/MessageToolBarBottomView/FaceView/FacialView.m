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

#import "FacialView.h"
#import "Emoji.h"

@interface FacialView ()

@end

@implementation FacialView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _faces = [Emoji allEmoji];
    }
    return self;
}


//给faces设置位置
-(void)loadFacialView:(int)page size:(CGSize)size
{
	int maxRow = 4;
    int maxCol = 8;
    CGFloat itemWidth = self.frame.size.width / maxCol;
    CGFloat itemHeight = self.frame.size.height / maxRow;
    
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteButton setBackgroundColor:[UIColor clearColor]];
//    162 110
//    h/itemWidth=

//    [deleteButton setFrame:CGRectMake((maxCol - 2) * itemWidth+itemWidth*(1.0f/10.0f), (maxRow - 1) * itemHeight+(itemHeight-(110.0f/162.0f)*itemWidth*(4.0f/5.0f))/2.0f, itemWidth*(4.0f/5.0f), (110.0f/162.0f)*itemWidth*(4.0f/5.0f))];
    [deleteButton setFrame:CGRectMake((maxCol - 2) * itemWidth -5-((itemWidth + 10)*(4.0f/5.0f)/2.0), (maxRow - 1) * itemHeight + 2+(itemWidth + 10)*(1.0f/10.0f), (itemWidth + 10)*(4.0f/5.0f), (124.0f/200.0f)*(itemWidth + 10)*(4.0f/5.0f)+3)];
    [deleteButton setImage:[UIImage imageNamed:@"faceDelete1"] forState:UIControlStateNormal];
    deleteButton.tag = 10000;
    [deleteButton addTarget:self action:@selector(selected:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:deleteButton];
//    self.backgroundColor=[UIColor]

    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [sendButton setTitle:NSLocalizedString(@"send", @"Send") forState:UIControlStateNormal];
    [sendButton setTitle:@"" forState:UIControlStateNormal];

//    [sendButton setFrame:CGRectMake((maxCol - 1) * itemWidth - 10, (maxRow - 1) * itemHeight + 5, itemWidth + 10, itemHeight - 10)];

    [sendButton setFrame:CGRectMake((maxCol - 1) * itemWidth-2-((itemWidth + 10)*(4.0f/5.0f)/2.0 ), (maxRow - 1) * itemHeight + 2+(itemWidth + 10)*(1.0f/10.0f), -4+(((itemWidth + 10)*(4.0f/5.0f))+(itemWidth + 10)*(4.0f/5.0f)/2.0), (124.0f/200.0f)*(itemWidth + 10)*(4.0f/5.0f)+3)];

    [sendButton addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
//    [sendButton setBackgroundColor:[UIColor colorWithRed:10 / 255.0 green:82 / 255.0 blue:104 / 255.0 alpha:1.0]];
    [sendButton setBackgroundImage:[UIImage imageNamed:@"chatBar_send"] forState:UIControlStateNormal];
    [self addSubview:sendButton];
    
    for (int row = 0; row < maxRow; row++) {
        for (int col = 0; col < maxCol; col++) {
            int index = row * maxCol + col;
            if (index < [_faces count]) {
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                [button setBackgroundColor:[UIColor clearColor]];
                [button setFrame:CGRectMake(col * itemWidth, row * itemHeight, itemWidth, itemHeight)];
                [button.titleLabel setFont:[UIFont fontWithName:@"AppleColorEmoji" size:29.0]];
                [button setTitle: [_faces objectAtIndex:(row * maxCol + col)] forState:UIControlStateNormal];
                button.tag = row * maxCol + col;
                [button addTarget:self action:@selector(selected:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:button];
            }
            else{
                break;
            }
        }
    }
}


-(void)selected:(UIButton*)bt
{
    if (bt.tag == 10000 && _delegate) {
        [_delegate deleteSelected:nil];
    }else{
        NSString *str = [_faces objectAtIndex:bt.tag];
        if (_delegate) {
            [_delegate selectedFacialView:str];
        }
    }
}

- (void)sendAction:(id)sender
{
    if (_delegate) {
        [_delegate sendFace];
    }
}

@end
