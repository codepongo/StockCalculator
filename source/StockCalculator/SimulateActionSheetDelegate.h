#import <UIKit/UIKit.h>

@protocol SimulateActionSheetDelegate<UIPickerViewDelegate>
@required
-(void)actionDone;
@required
-(void)actionCancle;

@end
