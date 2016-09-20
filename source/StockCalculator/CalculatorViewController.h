//
//  CalculatorViewController.h
//  cnstockcalculator
//
//  Created by zuohaitao on 15/10/13.
//  Copyright © 2015年 zuohaitao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimulateActionSheetDelegate.h"
@interface CalculatorViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIPickerViewDataSource, SimulateActionSheetDelegate>
@property(nonatomic, weak) IBOutlet UITableView* layout;
@property(nonatomic, weak) IBOutlet UISegmentedControl* segment;
- (IBAction)selectCalculateType:(id)sender;
@end
