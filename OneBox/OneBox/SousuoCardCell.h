//

//  OneBox
//
//  Created by 谢江新 on 15/12/18.
//  Copyright © 2015年 谢江新. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SousuoCardCell : UITableViewCell

@property (nonatomic, copy) void (^block)(NSInteger row,NSInteger section,NSString *type);
@property (nonatomic, copy) NSDictionary *dict;

@end
