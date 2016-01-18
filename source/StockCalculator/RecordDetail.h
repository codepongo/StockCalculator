//
//  RecordDetail.h
//  StockCalculator
//
//  Created by zuohaitao on 15/11/29.
//  Copyright © 2015年 zuohaitao. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface RecordDetail : UIViewController
@property IBOutlet UILabel* buyprice;
@property IBOutlet UILabel* buyquantity;
@property IBOutlet UILabel* sellprice;
@property IBOutlet UILabel* sellquantity;
@property IBOutlet UILabel* stamp;
@property IBOutlet UILabel* commission;
@property IBOutlet UIStackView* transferContainer;
@property IBOutlet UILabel* transfer;
@property IBOutlet UILabel* type;
@property IBOutlet UILabel* result;
@property IBOutlet UIStackView* layout;
@property IBOutlet UIStackView* sellPriceLayout;
@property IBOutlet UIStackView* sellQuantityLayout;
@property(strong) NSDictionary* data;

@end
