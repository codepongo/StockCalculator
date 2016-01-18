//
//  RecordViewController.h
//  cnstockcalculator
//
//  Created by zuohaitao on 15/10/13.
//  Copyright © 2015年 zuohaitao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordViewController : UITableViewController<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchControllerDelegate>
@property IBOutlet UIBarButtonItem* edit;
-(IBAction)edit:(id)sender;

//@property IBOutlet UISearchBar* searchbar;

@property IBOutlet UIBarButtonItem* search;

-(IBAction)select:(id)sender;

@property (nonatomic, strong) UISearchController *searcher;

@end

@interface Searcher : UITableViewController<UITableViewDataSource, UISearchResultsUpdating>

@property NSMutableArray* result;

@end

