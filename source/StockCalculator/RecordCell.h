//
//  RecordCell.h
//  StockCalculator
//
//  Created by zuohaitao on 15/11/26.
//  Copyright © 2015年 zuohaitao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordCell : UITableViewCell
@property IBOutlet UILabel* trade;
@property IBOutlet UILabel* result;
@property IBOutlet UILabel* datetime;
@property IBOutlet UIImageView* image;
@end
