#import <UIKit/UIKit.h>
#import "SimulateActionSheetDelegate.h"
@interface SimulateActionSheet : UIView
+(instancetype)styleDefault;
-(instancetype)initWithFrame:(CGRect)frame;
-(void)setupInitPostion:(UIViewController *)controller;
-(void)show:(UIViewController *)controlßler;
-(void)dismiss:(UIViewController *)controller;
-(UIView *)actionToolBar;
-(UIPickerView *)actionPicker;
-(void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)anime;
-(NSInteger)selectedRowInComponent:(NSInteger)component;
-(void)actionDone;
-(void)actionCancle;
-(void)setDelegate:(id<SimulateActionSheetDelegate>)delegate;
@property(nonatomic, weak) id<SimulateActionSheetDelegate> delegate;
@property(nonatomic, strong) UIPickerView* pickerView;
@end

