//
//  InputCell.h
//  cnstockcalculator
//
//  Created by zuohaitao on 15/10/14.
//  Copyright © 2015年 zuohaitao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ButtonCell : UITableViewCell

@property(nonatomic, weak) IBOutlet UILabel* title;
@property (weak, nonatomic) IBOutlet UIButton *button;
@end
