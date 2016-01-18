//
//  SettingDetailController.h
//  StockCalculator
//
//  Created by zuohaitao on 15/12/5.
//  Copyright © 2015年 zuohaitao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StockCalculator-Swift.h"

@interface SettingDetailController : UIViewController
@property IBOutlet UITextField* edit;
@property NSString* k;
@property Rate* rate;
-(IBAction)save:(id)sender;
@property IBOutlet UILabel* instruction;
@end
