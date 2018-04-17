//
//  FoundCell.h
//  OneBox
//
//  Created by 谢江新 on 15/2/6.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import <UIKit/UIKit.h>

@class foundModel_new;

@interface FoundCell_new : UITableViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) foundModel_new *foundModel;

-(void)updateUI;

@end
