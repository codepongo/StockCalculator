//
//  CalculatorViewController.m
//  cnstockcalculator
//
//  Created by zuohaitao on 15/10/13.
//  Copyright © 2015-2016 zuohaitao. All rights reserved.
//

#import "CalculatorViewController.h"
#import "StockCalculator-Swift.h"
#import "InputCell.h"
#import "InputCellWithUnit.h"
#import "OutputCell.h"
#import "ButtonCell.h"
#import "CalculateFooter.h"
#import "SimulateActionSheet.h"
#import "SaveFooter.h"
#import "SimulateActionSheet.h"
#import "InputAccessory.h"
#import "Record.h"
#import "public.h"

@interface CalculatorViewController ()
@property NSArray* all;
@property NSMutableArray* cur;
@property NSArray* pickerData;
@property(nonatomic, strong) SimulateActionSheet *sheet;
@property(nonatomic, strong) CalculateBrain* brain;
@property id value;
@property (nonatomic, weak) UIButton* marketOfStock;
@property (nonatomic) NSInteger selectedIndexInSheet;
@end

@implementation CalculatorViewController
@synthesize sheet;

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self.view name:@"rateChanged" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self.layout selector:@selector(reloadData) name:@"rateChanged" object:nil];
    self.selectedIndexInSheet = 1;
    self.brain = [[CalculateBrain alloc] init];
    // Do any additional setup after loading the view, typically from a nib.
    [self.layout registerNib:[UINib nibWithNibName:@"InputCell" bundle:nil]forCellReuseIdentifier:@"InputCell"];
    [self.layout registerNib:[UINib nibWithNibName:@"InputCellWithUnit" bundle:nil] forCellReuseIdentifier:@"InputCellWithUnit"];
    [self.layout registerNib:[UINib nibWithNibName:@"OutputCell" bundle:nil] forCellReuseIdentifier:@"OutputCell"];
    
    [self.layout registerNib:[UINib nibWithNibName:@"ButtonCell" bundle:nil] forCellReuseIdentifier:@"ButtonCell"];
    [self.layout registerNib:[UINib nibWithNibName:@"CalculateFooter" bundle:nil] forHeaderFooterViewReuseIdentifier:@"CalculateFooter"];
    [self.layout registerNib:[UINib nibWithNibName:@"SaveFooter" bundle:nil] forHeaderFooterViewReuseIdentifier:@"SaveFooter"];
    self.pickerData = @[@"上海A股", @"深圳A股"];
    self.all = @[
                 @[
                     @{
                         @"cellReuseIdentifier":@"InputCell"
                         ,@"title":@"股票代码"
                         ,@"placeholder":@"代码"
                         ,@"inputtype":[NSNumber numberWithInt:UIKeyboardTypeNumberPad]
                         ,@"value":@"code"
                         }
                     ,@{
                         @"cellReuseIdentifier":@"ButtonCell"
                         ,@"title":@"股票类型"
                         ,@"value":@"inSZ"
                         }
                     ,@{
                         @"cellReuseIdentifier":@"InputCell"
                         ,@"title":@"买入价格"
                         ,@"placeholder":@"0.00 元／股"
                         ,@"unit":@"元／股"
                         ,@"inputtype":[NSNumber numberWithInt:UIKeyboardTypeDecimalPad]
                         ,@"value":@"purchase.price"
                         }
                     ,@{
                         @"cellReuseIdentifier":@"InputCell"
                         ,@"title":@"买入数量"
                         ,@"placeholder":@"0 股"
                         ,@"unit":@"股"
                         ,@"inputtype":[NSNumber numberWithInt:UIKeyboardTypeNumberPad]
                         ,@"value":@"purchase.quantity"
                         }
                     ,@{
                         @"cellReuseIdentifier":@"InputCell"
                         ,@"title":@"卖出价格"
                         ,@"placeholder":@"0.00 元／股"
                         ,@"unit":@"元／股"
                         ,@"inputtype":[NSNumber numberWithInt:UIKeyboardTypeDecimalPad]
                         ,@"value":@"sale.price"
                         }
                     ,@{
                         @"cellReuseIdentifier":@"InputCell"
                         ,@"title":@"卖出数量"
                         ,@"placeholder":@"0 股"
                         ,@"unit":@"股"
                         ,@"inputtype":[NSNumber numberWithInt:UIKeyboardTypeNumberPad]
                         ,@"value":@"sale.quantity"
                         }
                     ,@{
                         @"cellReuseIdentifier":@"InputCell"
                         ,@"title":@"佣金比率"
                         ,@"placeholder":@"0‰（不足5元，按5元收取）"
                         ,@"unit":@"‰"
                         ,@"inputtype":[NSNumber numberWithInt:UIKeyboardTypeDecimalPad]
                         ,@"value":@"rate.commission"
                         },@{
                         @"cellReuseIdentifier":@"InputCell"
                         ,@"title":@"印花税率"
                         ,@"placeholder":@"（仅在卖出征收1‰）"
                         ,@"unit":@"‰"
                         ,@"inputtype":[NSNumber numberWithInt:UIKeyboardTypeDecimalPad]
                         ,@"value":@"rate.stamp"
                         },
                     @{
                         @"cellReuseIdentifier":@"InputCell"
                         ,@"title":@"过户费率"
                         ,@"placeholder":@"（0.02 ‰）"
                         ,@"unit":@"‰"
                         ,@"inputtype":[NSNumber numberWithInt:UIKeyboardTypeDecimalPad]
                         ,@"value":@"rate.transfer"
                         }
                     ]
                 ,@[
                     [NSMutableDictionary dictionaryWithDictionary:@{
                                                                     @"cellReuseIdentifier":@"OutputCell"
                                                                     ,@"title": @"过户费"
                                                                     ,@"value": @"0.00"
                                                                     ,@"unit":@"元"                                                                              ,@"instruction":@"过户费属于登记结算机构的收入。买入、卖出双向收取。"
                                                                     }]
                     ,[NSMutableDictionary dictionaryWithDictionary:@{
                                                                      @"cellReuseIdentifier":@"OutputCell"
                                                                      ,@"title": @"印花税"
                                                                      ,@"value": @"0.00"
                                                                      ,@"unit":@"元"
                                                                      ,@"instruction":@"由政府收取。卖出单边征收。"
                                                                      }]
                     ,[NSMutableDictionary dictionaryWithDictionary:@{
                                                                      @"cellReuseIdentifier":@"OutputCell"
                                                                      ,@"title": @"券商佣金"
                                                                      ,@"value": @"0.00"
                                                                      ,@"unit":@"元"
                                                                      ,@"instruction":@"属于券商的收入。买入、卖出双向收取。"
                                                                      }]
                     ,[NSMutableDictionary dictionaryWithDictionary:@{
                                                                      @"cellReuseIdentifier":@"OutputCell"
                                                                      ,@"title": @"税费合计"
                                                                      ,@"value": @"0.00"
                                                                      ,@"unit":@"元"
                                                                      }]
                     ,[NSMutableDictionary dictionaryWithDictionary:@{
                                                                      @"cellReuseIdentifier":@"OutputCell"
                                                                      ,@"titleForGainOrLoss": @"投资损益"
                                                                      ,@"titleForBreakevenPrice": @"保本价格"
                                                                      ,@"titleForPurchase": @"支出"
                                                                      ,@"titleForSale": @"收入"
                                                                      ,@"value": @"0.00"
                                                                      ,@"unitForPrice": @"元/股"
                                                                      ,@"unitForTotal": @"元"
                                                                       }]
                     ]
                 ];
    self.cur = [NSMutableArray array];
    [self.cur addObject:[NSMutableArray arrayWithArray:[self.all objectAtIndex:0]]];
    [self.cur[0] removeLastObject];
    self.selectedIndexInSheet = 0;
    [self actionDone ];

}


#pragma mark -
#pragma mark KeyBoard Methods

-(void)hideKeyBoard {
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    UIView *firstResponder = [keyWindow performSelector:@selector(firstResponder)];
#pragma clang diagnostic pop
    [firstResponder resignFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void) keyboardWillShow:(NSNotification *)note
{
#define _UIKeyboardFrameEndUserInfoKey (&UIKeyboardFrameEndUserInfoKey != NULL ? UIKeyboardFrameEndUserInfoKey : @"UIKeyboardBoundsUserInfoKey")
    CGRect keyboardRect = [self.view convertRect:[[[note userInfo] objectForKey:_UIKeyboardFrameEndUserInfoKey] CGRectValue] fromView:nil];
    if (CGRectIsEmpty(keyboardRect)) {
        return;
    }
    
    self.layout.contentInset = UIEdgeInsetsMake(self.layout.contentInset.top, 0, keyboardRect.size.height, 0);
    
}

- (void)keyboardWillHide:(NSNotification*)note {
    
    CGRect keyboardRect = [self.view convertRect:[[[note userInfo] objectForKey:_UIKeyboardFrameEndUserInfoKey] CGRectValue] fromView:nil];
    if (CGRectIsEmpty(keyboardRect)) {
        return;
    }
    self.layout.contentInset = UIEdgeInsetsMake(self.layout.contentInset.top, 0, 0, 0);    
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark -
#pragma mark Table View Data Source Methods

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return self.cur.count;
}

- (NSInteger)tableView:(UITableView * _Nonnull)tableView
 numberOfRowsInSection:(NSInteger)section {
    return [self.cur[section] count];
}

#pragma mark -
#pragma mark Table View Delegate Methods


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary* item = self.cur[indexPath.section][indexPath.row];
    NSString* cellId = item[@"cellReuseIdentifier"];
    if (cellId == nil) {
        return nil;
    }
    if ([cellId  isEqual: @"InputCell"]) {
        InputCell* c = [tableView dequeueReusableCellWithIdentifier:cellId];
        c.title.text = self.cur[indexPath.section][indexPath.row][@"title"];
        c.input.delegate = self;

        id v = [self.brain valueForKeyPath:item[@"value"]];
        
        if (v != nil && [v floatValue] != 0) {
            if (nil == item[@"unit"]) {
                c.input.text = [[v class] isEqual: @"NSNumber"] ? ((NSNumber*)v).stringValue : v;
            }
            else {
                c.input.text = [NSString stringWithFormat:@"%g %@",[v floatValue], item[@"unit"]];
            }
        }
        else {
            c.input.text = @"";
        }
        c.input.placeholder = item[@"placeholder"];
        c.input.keyboardType = [item[@"inputtype"] integerValue];
        
        InputAccessory* a = [[[NSBundle mainBundle]loadNibNamed:@"InputAccessory" owner:nil options:nil] objectAtIndex:0];
        a.done.action = @selector(hideKeyBoard);
        c.input.inputAccessoryView = a;
        return c;
    }

    if ([cellId  isEqual: @"ButtonCell"]) {
        ButtonCell* c = [tableView dequeueReusableCellWithIdentifier:cellId];
        c.title.text = self.cur[indexPath.section][indexPath.row][@"title"];
        self.marketOfStock = c.button;
        [c.button addTarget:self action:@selector(selectMarketOfStock:) forControlEvents:UIControlEventTouchUpInside];
        [c.button setTitle:self.pickerData[self.selectedIndexInSheet] forState:UIControlStateNormal];
        
        return c;
    }
    if ([cellId  isEqual: @"OutputCell"]) {
        OutputCell* c = [tableView dequeueReusableCellWithIdentifier:@"OutputCell"];
        NSString* title = self.cur[indexPath.section][indexPath.row][@"title"];
        if (nil != title) {
            c.title.text = title;
            
            NSString* instruction = self.cur[indexPath.section][indexPath.row][@"instruction"];
            if (instruction != nil) {
                UIImage* image = [UIImage imageNamed:@"instruction"];
                UIButton *b = [[UIButton alloc]init];//WithFrame:CGRectMake(0, 0, 32,c.contentView.frame.size.height)];
                [c addSubview:b];
                [b setImage:image forState:UIControlStateNormal];
                [b addTarget:self action:@selector(showInstruction:) forControlEvents:UIControlEventTouchUpInside];
                c.accessoryView = b;
                c.accessoryView.autoresizingMask = NO;
                c.accessoryView.translatesAutoresizingMaskIntoConstraints = NO;
                [c.accessoryView.topAnchor constraintEqualToAnchor:c.contentView.topAnchor].active = YES;
                [c.accessoryView.bottomAnchor constraintEqualToAnchor:c.contentView.bottomAnchor].active = YES;
                [c.accessoryView.leadingAnchor constraintEqualToAnchor:c.contentView.trailingAnchor].active = YES;
                [c.accessoryView.trailingAnchor constraintEqualToAnchor:c.trailingAnchor].active = YES;
                
            }
            else {
                UIView* v = [[UIView alloc]initWithFrame:CGRectMake(0,0,32,c.contentView.frame.size.height)];
                c.accessoryView = v;
            }
        }
        else {
            switch (self->_segment.selectedSegmentIndex) {
                case 0:
                    c.title.text = self.cur[indexPath.section][indexPath.row][@"titleForGainOrLoss"];
                    break;
                case 1:
                    c.title.text = self.cur[indexPath.section][indexPath.row][@"titleForBreakevenPrice"];
                    break;
                case 2:
                    c.title.text = self.cur[indexPath.section][indexPath.row][@"titleForPurchase"];

                    break;
                case 3:
                    c.title.text = self.cur[indexPath.section][indexPath.row][@"titleForSale"];

                    break;
                default:
                    break;
            }

            
            float r = self.brain.result;
            if (r < 0) {
                c.result.textColor = DOWN_COLOR;
            }
            else {
                c.result.textColor = UP_COLOR;
            }
            UIView* v = [[UIView alloc]initWithFrame:CGRectMake(0,0,32,c.contentView.frame.size.height)];
            c.accessoryView = v;

        }
        c.result.text = self.cur[indexPath.section][indexPath.row][@"value"];
        return c;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001;

}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"CalculateFooter"].frame.size.height;
}

-(UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        CalculateFooter* footer = (CalculateFooter*)[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"CalculateFooter"];
        [footer.contentView setFrame:CGRectMake(0, 0, footer.frame.size.width, 44)];
        
        footer.reset.layer.cornerRadius = 5.0; //设置矩形四个圆角半径
        footer.reset.layer.borderWidth = 1.0; //边框宽度
        footer.reset.layer.borderColor = footer.reset.titleLabel.textColor.CGColor;
        [footer.reset addTarget:self action:@selector(reset) forControlEvents:UIControlEventTouchUpInside];
        
        footer.calculate.layer.cornerRadius = 5.0; //设置矩形四个圆角半径
        footer.calculate.layer.borderWidth = 1.0; //边框宽度
        
        footer.calculate.layer.borderColor = footer.calculate.backgroundColor.CGColor;
        [footer.calculate addTarget:self action:@selector(calculate:) forControlEvents:UIControlEventTouchUpInside];
        [footer.calculate setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        
        
        return (UIView*)footer;
    }
    if (section == 1) {
        SaveFooter* footer = (SaveFooter*)[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"SaveFooter"];
        footer.save.layer.cornerRadius = 5.0; //设置矩形四个圆角半径
        footer.save.layer.borderWidth = 1.0; //边框宽度
        footer.save.layer.borderColor = footer.save.backgroundColor.CGColor;
        [footer.save addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
        return (UIView*)footer;
    }
    return tableView.tableFooterView;
}

-(void)detail {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:self.cur[1][1][@"title"] message:self.cur[1][1][@"instruction"] preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];

}
-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:self.cur[indexPath.section][indexPath.row][@"title"] message:self.cur[indexPath.section][indexPath.row][@"instruction"] preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
    
}

#pragma mark -
#pragma mark Outlet Action Methods

-(void) showInstruction:(id)sender {
    UIButton* b = sender;
    NSIndexPath* path = [self.layout indexPathForCell:(UITableViewCell*)b.superview];
    [self tableView:self.layout accessoryButtonTappedForRowWithIndexPath:path];
}
-(void) selectMarketOfStock:(id)sender{
    [self hideKeyBoard];
    UIButton* button = sender;
    if (self.sheet == nil) {
        self.sheet = [SimulateActionSheet styleDefault];
    }
    [self.sheet.pickerView selectRow:self.selectedIndexInSheet inComponent:0 animated:NO];
    
    self.sheet.delegate = self;
    //必须在设置delegate之后调用，否则无法选中指定的行
    if (button.currentTitle == [self.pickerData objectAtIndex:0]) {
        [self.sheet selectRow:0 inComponent:0 animated:YES];
    }
    else {
        [self.sheet selectRow:1 inComponent:0 animated:YES];
    }
    [self.sheet show:self];
}

-(void) calculate:(id)sender{
    [self hideKeyBoard];
    if ([self.brain.code isEqualToString: @""]) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"股票代码不能为空" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;
        
    }
    if (self.brain.buy != nil) {
        if (self.brain.buy.price == 0) {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"买入价格不能为0元／股" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
            return;
        }
        
        if (self.brain.buy.quantity == 0) {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"买入数量不能为0股" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
            return;
        }
    }
    if (self.brain.sell != nil) {
        if (self.brain.sell.price == 0) {
            
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"卖出价格不能为0元／股" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
            
            return;
        }
        
        if (self.brain.sell.quantity == 0) {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"卖出数量不能为0股" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
            
            return;
        }
    }

    if (self.brain.rate.commission == 0) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"佣金比率不能为0" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    if (self.brain.rate.stamp == 0) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"印花税率不能为0" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    if (!self.brain.inSZ && self.brain.rate.transfer == 0){
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"过户费率不能为0" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }

    switch (self->_segment.selectedSegmentIndex) {
        case 0:
            [self.brain calculateForGainOrLoss];
            break;
        case 1:
            [self.brain calculateForBreakevenPrice];
            break;
        case 2:
            [self.brain calculateForPurchase];
            break;
        case 3:
            [self.brain calculateForSale];
            break;
        default:
            break;
    }
    //brain calculates.
    float transfer = [self.brain transferAsFloat];//[self.brain transferOfTrade];
    float stamp = self.brain.stamp;//[self.brain stampOfTrade];
    float commission = self.brain.commission;//[self.brain commissionOfTrade];
    float taxesAndDuties = self.brain.fee;//[self.brain taxesAndDutiesOfTrade];
    float result = self.brain.result;//[self.brain resultOfTrade];
    if (self.cur.count == 1) {
        [self.cur addObject:[self.all objectAtIndex:1]];
    }
    else {
        OutputCell* c = [self.layout cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:1]];
        
        if (self->_segment.selectedSegmentIndex == 0 && result < 0) {
            c.result.textColor = [UIColor greenColor];
        }
        if (self->_segment.selectedSegmentIndex == 0 && result > 0) {
            c.result.textColor = [UIColor redColor];
        }
    }

    [self.cur[1][0] setObject:[NSString stringWithFormat:@"%.2f %@", transfer, self.cur[1][0][@"unit"]] forKey:@"value"];
    self.cur[1][1][@"value"] = [NSString stringWithFormat:@"%.2f %@", stamp, self.cur[1][1][@"unit"]];
    self.cur[1][2][@"value"] = [NSString stringWithFormat:@"%.2f %@", commission, self.cur[1][2][@"unit"]];
    self.cur[1][3][@"value"] = [NSString stringWithFormat:@"%.2f %@", taxesAndDuties, self.cur[1][3][@"unit"]];

    if (self->_segment.selectedSegmentIndex == 1) {
        self.cur[1][4][@"value"] = [NSString stringWithFormat:@"%.2f %@", result, self.cur[1][4][@"unitForPrice"]];
    }
    else {
        self.cur[1][4][@"value"] = [NSString stringWithFormat:@"%.2f %@", result, self.cur[1][4][@"unitForTotal"]];
    }
 
    [self.layout reloadData];

    NSIndexPath* path = [NSIndexPath indexPathForRow:0 inSection:1];
    [self.layout scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

-(void) reset {
    if (self.cur.count == 2) {
        [self.cur removeObjectAtIndex:1];
    }
    [self.brain reset];
    [self.layout reloadData];
    NSIndexPath* path = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.layout scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

-(void) save:(id)sender{
    NSMutableDictionary* r = [NSMutableDictionary dictionaryWithDictionary:[self.brain dictionaryWithValuesForKeys:@[@"code", @"stamp", @"commission", @"result"]]];

    switch (self->_segment.selectedSegmentIndex) {
        case 0:
            r[@"buy.price"] = [NSNumber numberWithFloat:self.brain.buy.price];
            r[@"buy.quantity"] = [NSNumber numberWithInteger:self.brain.buy.quantity];
            r[@"sell.price"] = [NSNumber numberWithFloat:self.brain.sell.price];
            r[@"sell.quantity"] = [NSNumber numberWithInteger:self.brain.sell.quantity];
            break;
        case 1:
            r[@"buy.price"] = [NSNumber numberWithFloat:self.brain.buy.price];
            r[@"buy.quantity"] = [NSNumber numberWithInteger:self.brain.buy.quantity];
            break;
        case 2:
            r[@"buy.price"] = [NSNumber numberWithFloat:self.brain.buy.price];
            r[@"buy.quantity"] = [NSNumber numberWithInteger:self.brain.buy.quantity];
            break;
        case 3:
            r[@"sell.price"] = [NSNumber numberWithFloat:self.brain.sell.price];
            r[@"sell.quantity"] = [NSNumber numberWithInteger:self.brain.sell.quantity];
            break;
        default:
            break;
    }
    
    r[@"rate.commission"] = [NSNumber numberWithFloat:self.brain.rate.commission];
    r[@"rate.stamp"] = [NSNumber numberWithFloat:self.brain.rate.stamp];
    if (!self.brain.inSZ) {
        r[@"transfer"] = [NSNumber numberWithFloat:[self.brain transferAsFloat]];
        r[@"rate.transfer"] = [NSNumber numberWithFloat:self.brain.rate.transfer];
    }

    [[Record sharedRecord] add:r];
    
    // Get the views to animate.
    UIView * fromView = self.tabBarController.selectedViewController.view;
    UIView * toView = [[self.tabBarController.viewControllers objectAtIndex:0] view];
    
    // Get the size of the view.
    CGRect viewSize = fromView.frame;
    
    // Add the view that we want to display to superview of currently visible view.
    [fromView.superview addSubview:toView];
    
    // Position it off screen. We will animate it left to right slide.
    toView.frame = CGRectMake(-self.view.bounds.size.width, viewSize.origin.y, toView.bounds.size.width, viewSize.size.height);
    
    // Animate transition
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
        // Animate the views with slide.
        fromView.frame = CGRectMake(self.view.bounds.size.width, viewSize.origin.y, toView.bounds.size.width, viewSize.size.height);
        toView.frame = CGRectMake(0, viewSize.origin.y, toView.bounds.size.width, viewSize.size.height);
    } completion:^(BOOL finished) {
        if (finished)
        {
            // Remove the old view.
            [fromView removeFromSuperview];
            self.tabBarController.selectedIndex = 0;
            [self.tabBarController.selectedViewController popToRootViewControllerAnimated:NO];
            UITableView* tbl = (UITableView*)[self.tabBarController.selectedViewController topViewController].view;
           if ([tbl numberOfRowsInSection:0] > 0) {
                [tbl selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
            }
        }
    }];
}

- (IBAction)selectCalculateType:(id)sender {
    [self hideKeyBoard];
    [self.cur[0] removeAllObjects];
    [self.cur[0] addObjectsFromArray:self.all[0]];

    switch ([sender selectedSegmentIndex]) {
        case 0://GainOrLoss
            break;
        case 1://BreakEvenPrice
            [self.cur[0] removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(4,2)]];
            break;
        case 2://Purchase
            [self.cur[0] removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(4,2)]];
            break;
        case 3://Sale
            [self.cur[0] removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(2,2)]];
        default:
            //it never can be executed!
            break;
    }
    [self.layout reloadData];
    
}

#pragma mark -
#pragma mark Text Field Delegate Methods

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    textField.text = @"";
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSIndexPath* path = [self.layout indexPathForCell:(UITableViewCell*)textField.superview.superview];
    if ([self.cur[path.section] count] <= path.row) {
        return;
    }
    
    [self.brain setValue:[self.cur[path.section][path.row][@"value"]  isEqual: @"code"] ? textField.text:[NSNumber numberWithFloat:textField.text.floatValue] forKeyPath:self.cur[path.section][path.row][@"value"]];
    if (![textField.text  isEqual: @""]) {
        NSString* unit = self.cur[path.section][path.row][@"unit"];
        if (unit != nil) {
            textField.text = [NSString stringWithFormat:@"%@ %@",textField.text, unit];
        }
    }
}

- (BOOL)textFieldShouldClear:(UITextField * _Nonnull)textField {
    return YES;
}


#pragma mark -
#pragma mark Picker Data Source Methods

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.pickerData.count;
}

#pragma mark -
#pragma mark Picker Delegate Methods

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.pickerData objectAtIndex:row];
}

#pragma mark -
#pragma mark Picker Outlet Action Methods

-(void)actionCancle{
    [sheet dismiss:self];
}

-(void)actionDone{
    [sheet dismiss:self];
    
    self.selectedIndexInSheet = [sheet selectedRowInComponent:0];
    [self.marketOfStock setTitle:self.pickerData[self.selectedIndexInSheet] forState:UIControlStateNormal];
    
    self.brain.inSZ = self.selectedIndexInSheet == 0 ? NO:YES;
    
    if (self.brain.inSZ) {
        [self.cur[0] removeLastObject];
    }
    else {
        [self.cur[0] addObject:self.all[0][[self.all[0] count]-1]];
    }
    [self.layout reloadData];
}
@end
