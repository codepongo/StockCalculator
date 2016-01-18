//
//  RecordViewController.m
//  cnstockcalculator
//
//  Created by zuohaitao on 15/10/13.
//  Copyright © 2015年 zuohaitao. All rights reserved.
//

#import "RecordViewController.h"
#import "Record.h"
#import "RecordCell.h"
#import "public.h"
#import "RecordDetail.h"


#pragma mark -

@implementation Searcher
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [(UITableView*)self.view registerNib:[UINib nibWithNibName:@"RecordCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    

}

#pragma mark UISearchResultsUpdating

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    switch (searchController.searchBar.selectedScopeButtonIndex) {
        case 1: {
            self.result = [NSMutableArray arrayWithArray:[[Record sharedRecord] recordsAtTime:searchController.searchBar.text]];
            break;
        }
//        case 2: {
//            self.result = [NSMutableArray arrayWithArray:[[Record sharedRecord] recordsForPrice:searchController.searchBar.text]];
//            break;
//            
//        }
//        case 3: {
//            self.result = [NSMutableArray arrayWithArray:[[Record sharedRecord] recordsForQuantity:searchController.searchBar.text]];
//            break;
//            
//        }
        default:
            self.result = [NSMutableArray arrayWithArray:[[Record sharedRecord] recordsForCode:searchController.searchBar.text]];
            break;
    }

    [self.tableView reloadData];
}

#pragma mark -
#pragma mark Table View Data Source Methods
	
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView * _Nonnull)tableView
 numberOfRowsInSection:(NSInteger)section {
    return self.result.count;
}

@end

@interface RecordViewController ()
//@property NSMutableDictionary* cache;
//@property NSUInteger defaultLength;

@property Searcher* sr;
@end

@implementation RecordViewController

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self.view name:@"recordChanged" object:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [[NSNotificationCenter defaultCenter] addObserver: self.view selector: @selector(reloadData) name: @"recordChanged" object: nil];
    
     [(UITableView*)self.view registerNib:[UINib nibWithNibName:@"RecordCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    
    self.sr = [[Searcher alloc] init ];
    self.sr.tableView.rowHeight = self.tableView.rowHeight;
    self.sr.tableView.delegate = self;
    self.sr.tableView.dataSource = self;
    self.searcher = [[UISearchController alloc] initWithSearchResultsController:self.sr];
    
    self.searcher.delegate = self;
    
    self.searcher.searchResultsUpdater = self.sr;
    
    self.searcher.dimsBackgroundDuringPresentation = YES;
    
    self.searcher.hidesNavigationBarDuringPresentation = YES;
    self.searcher.searchBar.delegate = self;
    self.searcher.searchBar.scopeButtonTitles = @[@"代码", @"时间"];//, @"买入价格", @"买入数量"];
    self.definesPresentationContext = YES;
    
    //self.tableView.tableHeaderView = self.searchController.searchBar;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Table View Data Source Methods

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView * _Nonnull)tableView
 numberOfRowsInSection:(NSInteger)section {
    if (tableView != self.tableView) {
        return self.sr.result.count;
    }
    
    NSInteger count = [[Record sharedRecord]count];
    if (count == 0) {
        self.navigationItem.rightBarButtonItem = nil;
        self.navigationItem.leftBarButtonItem = nil;
    }
    else {
        self.navigationItem.rightBarButtonItem = self.edit;
        self.navigationItem.leftBarButtonItem = self.search;
    }
    return count;
}

- (BOOL)tableView:(UITableView * _Nonnull)tableView canEditRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath {
    return YES;
}

- (void)tableView:(UITableView * _Nonnull)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath {
    [[Record sharedRecord] removeAtIndex:[(UITableView*)self.view cellForRowAtIndexPath:indexPath].tag];
}

#pragma mark -
#pragma mark Table View Delegate Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RecordCell* c = (RecordCell*)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (c == nil) {
        c =(RecordCell*)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"Cell"];
    }
    NSDictionary* r = nil;
    if (tableView != self.tableView) {
         r = self.sr.result[indexPath.row];
    }
    else {
        r = [[Record sharedRecord] recordForIndexPath:indexPath.row];
    }
    if (r[@"sell.price"] != [NSNull null]) {
        c.image.image = [UIImage imageNamed:@"gainorloss"];
    }
    else {
        c.image.image = [UIImage imageNamed:@"breakeven"];
        
    }
    
    c.trade.text = [NSString stringWithFormat: @"[%@] - 单价为%.2f元时，买入%@股。", r[@"code"],((NSNumber*)r[@"buy.price"]).floatValue, r[@"buy.quantity"]];
    if (r[@"sell.price"] != [NSNull null]) {
        c.trade.text = [NSString stringWithFormat:@"%@ 单价为%.2f元时，卖出%@股。", c.trade.text, ((NSNumber*)r[@"sell.price"]).floatValue, r[@"sell.quantity"]];
    }
    
    if (((NSNumber*)r[@"result"]).floatValue < 0) {
        c.result.textColor = DOWN_COLOR;
    }
    else {
        c.result.textColor = UP_COLOR;
    }
    
    c.result.text = [NSString stringWithFormat:@"%@： %.2f %@", r[@"sell.price"] != [NSNull null] ? @"交易损益" : @"保本价格",((NSNumber*)r[@"result"]).floatValue,r[@"sell.price"] != [NSNull null] ? @"元" : @"元／股"];
    c.datetime.text = r[@"time"];
    //c.textLabel.text = [NSString stringWithFormat:@"[%@] 买入 %@ 元／股 × %@ 股", r[@"code"], r[@"buy.price"], r[@"buy.quantity"]];
    //c.detailTextLabel.text = r[@"time"];
    c.tag = ((NSNumber*)r[@"rowid"]).intValue;
    return c;
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle: indexPath.description message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView * _Nonnull)tableView editingStyleForRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    RecordDetail *d = [self.storyboard instantiateViewControllerWithIdentifier: @"detail"];
    NSDictionary* r = [[Record sharedRecord] recordForIndexPath:indexPath.row];
    if (tableView == self.tableView) {
        d.data = r;
    }
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem
                                              alloc]
                                             initWithTitle:@"返回"
                                             style:UIBarButtonItemStylePlain
                                             target:nil
                                             action:nil];
    [self.navigationController pushViewController:d animated:YES];

    
}

#pragma mark - action

-(IBAction)edit:(id)sender {
    [(UITableView*)self.view setEditing:!((UITableView*)self.view).editing animated:YES];
    if (((UITableView*)self.view).editing)
    {
        self.edit.title = @"完成";
    }
    else {
        self.edit.title = @"编辑";
    }
}

-(IBAction) select:(id)sender {
    if (((UITableView*)self.view).tableHeaderView == nil) {
        ((UITableView*)self.view).tableHeaderView = self.searcher.searchBar;
    //if (((UITableView*)self.view).tableHeaderView.hidden) {
        //((UITableView*)self.view).tableHeaderView.hidden = NO;
        self.edit.customView.hidden = YES;
        self.navigationItem.rightBarButtonItem = nil;
        self.navigationItem.leftBarButtonItem = nil;
        [self.searcher.searchBar becomeFirstResponder];
    }
    
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.tableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar * _Nonnull)searchBar {
    self.navigationItem.leftBarButtonItem = self.search;
    self.navigationItem.rightBarButtonItem = self.edit;
    ((UITableView*)self.view).tableHeaderView = nil;//.hidden = YES;
}

- (void)searchBar:(UISearchBar *)searchBar
selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
    [self.sr updateSearchResultsForSearchController:self.searcher];
}

#pragma mark - UISearchControllerDelegate

- (void)didDismissSearchController:(UISearchController *)searchController {
    self.navigationItem.leftBarButtonItem = self.search;
    self.navigationItem.rightBarButtonItem = self.edit;
    ((UITableView*)self.view).tableHeaderView = nil;//.hidden = YES;
}


@end
