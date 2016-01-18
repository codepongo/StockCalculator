//
//  AboutController.h
//  StockCalculator
//
//  Created by zuohaitao on 15/12/5.
//  Copyright © 2015年 zuohaitao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutController : UIViewController<UIWebViewDelegate>
@property IBOutlet UIWebView* webView;
@property IBOutlet UIActivityIndicatorView* indicator;
@end
