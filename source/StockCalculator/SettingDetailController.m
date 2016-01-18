//
//  SettingDetailController.m
//  StockCalculator
//
//  Created by zuohaitao on 15/12/5.
//  Copyright © 2015年 zuohaitao. All rights reserved.
//

#import "SettingDetailController.h"

@interface SettingDetailController ()

@end

@implementation SettingDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.rate = [[Rate alloc] init];
    //iOS BUG:when UITextBorderStyleNone, UITextField' text dismiss after app resign active.
    //this is a dirt fix for the bug above
    self.edit.borderStyle = UITextBorderStyleLine;
    self.edit.layer.cornerRadius= 0;
    self.edit.layer.masksToBounds = YES;
    self.edit.layer.borderColor = self.edit.superview.backgroundColor.CGColor;
    self.edit.layer.borderWidth = 1.0f;
    
    // Do any additional setup after loading the view.
    self.edit.text = [NSString stringWithFormat:@"%.2f", ((NSNumber*)[self.rate valueForKey:self.k]).floatValue];
    [self.edit becomeFirstResponder];
    
    NSMutableDictionary *descriptions = [[NSMutableDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"RateDescription" ofType:@"plist"]];
    self.instruction.text = descriptions[self.k];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)save:(id)sender {
    [self.rate setValue:[NSNumber numberWithFloat:self.edit.text.floatValue ] forKey:self.k];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"rateChanged" object:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

@end
