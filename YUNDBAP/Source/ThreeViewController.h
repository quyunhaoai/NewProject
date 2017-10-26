//
//  ThreeViewController.h
//  NewCloudApp
//
//  Created by hao on 15/12/19.
//
//

#import "HwOnePageViewController.h"
@protocol MJSecondPopupDelegate;
@interface ThreeViewController : HwOnePageViewController

@property (nonatomic,copy)NSString *url;
@property (nonatomic,copy)NSString *alpha;
@property (nonatomic,copy)NSString *x;
@property (nonatomic,copy)NSString *y;
@property (nonatomic,copy)NSString *Width;
@property (nonatomic,copy)NSString *hgiht;
@property (nonatomic,strong)NSString *outType;

@property (nonatomic,assign)id<MJSecondPopupDelegate>delegate;
@end



@protocol MJSecondPopupDelegate<NSObject>
@optional
- (void)cancelButtonClicked:(NSString *)secondDetailViewController;
@end