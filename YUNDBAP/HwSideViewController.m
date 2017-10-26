//
//  HwSideViewController.m
//  CloudApp
//
//  Created by 9vs on 15/1/14.
//
//
#import "UMMobClick/MobClick.h"
#import "HwSideViewController.h"
#import "AboutViewController.h"
#import "AppDelegate.h"
#import "UIViewController+MMDrawerController.h"
#import "HwTools.h"
#import "HwReaderViewController.h"
#import "CustomNavigationController.h"
#import "HwYDBPageViewController.h"
#define ONE                     1.0f
#define SEPERATOR_LINE_RECT     CGRectMake(0, 55 - 0.3, self.view.frame.size.width, 0.8)

@interface HwSideViewController () <UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) IBOutlet UITableView *tableView;
@property (nonatomic , strong) NSMutableArray *strDataArray;
@property (nonatomic , strong) NSMutableArray *imgDataArray;
@property (nonatomic , strong) StringsXmlBase *sBase;
@end

@implementation HwSideViewController

- (NSMutableArray *)strDataArray {
    if (!_strDataArray) {
        _strDataArray = [NSMutableArray array];
    }
    return _strDataArray;
}
- (NSMutableArray *)imgDataArray {
    if (!_imgDataArray) {
        _imgDataArray = [NSMutableArray array];
    }
    return _imgDataArray;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
     [self getCacheSize];
    [MobClick beginLogPageView:@"ToolsView"];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [MobClick endLogPageView:@"ToolsView"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.sBase = [StringsXML getStringXmlBase];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sz_bj"]];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    
    NSMutableArray *array = [[UXml shareUxml] jiexiXML:@"topmenu" two:@"menu"];
    for (int i = 0 ;i < array.count; i++) {
        NSDictionary *dic = array[i];
        TopMenuXmlBase *base = [TopMenuXmlBase modelObjectWithDictionary:dic];
        [self.imgDataArray addObject:[NSString stringWithFormat:@"db_%da",i+12]];
        [self.strDataArray addObject:base.name];
      
    }

    
    
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    return self.strDataArray.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [HwTools hexStringToColor:self.sBase.rightMenuFontColor];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    if( [tableView numberOfRowsInSection:indexPath.section] > ONE )
    {
        [self addSeparatorImageToCell:cell];
    }
    
    cell.imageView.image = [UIImage imageNamed:self.imgDataArray[indexPath.row]];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@",self.strDataArray[indexPath.row]];
    
    return cell;
    
}



#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    NSMutableArray *array = [[UXml shareUxml] jiexiXML:@"topmenu" two:@"menu"];
    NSDictionary *dic = array[indexPath.row];
    TopMenuXmlBase *base = [TopMenuXmlBase modelObjectWithDictionary:dic];
    
//    NSString *selectStr = self.strDataArray[indexPath.row];
    if ([base.type isEqualToString:@"1"]) {
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        AboutViewController *aboutVC = [[AboutViewController alloc] init];
        CustomNavigationController *nav = [[CustomNavigationController alloc] initWithRootViewController:aboutVC];

        [delegate.drawerController setCenterViewController:nav withCloseAnimation:YES completion:nil];
        
        
    }else if ([base.type isEqualToString:@"2"]) {
        
//        [[HwTools shareTools] checkIfUpdateIsHud:YES];
//        [self goalipay];

    }else if ([base.type isEqualToString:@"3"]) {
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        UIView *vi = [[UIView alloc] init];
        vi.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
        vi.bounds = CGRectMake(0, 0, 0, 0);
        [self.view addSubview:vi];
        [[HwTools shareTools] shareAllButtonClickHandler:vi shareModel:delegate.sModel];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"sharecallback" object:self userInfo:nil];
        
        
    }else if ([base.type isEqualToString:@"4"]) {
       
        
        HwReaderViewController *readerVC = [[HwReaderViewController alloc] init];
        CustomNavigationController *nav = [[CustomNavigationController alloc] initWithRootViewController:readerVC];
        
        [self.mm_drawerController setCenterViewController:nav withCloseAnimation:YES completion:nil];
        
        
    }else if([base.type isEqualToString:@"5"]){
        [[HwTools shareTools] clearCache:^{
            [self getCacheSize];
        }];
        
    }else if([base.type isEqualToString:@"6"]){
        NSMutableArray *array = [[UXml shareUxml] jiexiXML:@"topmenu" two:@"menu"];
        NSDictionary *dic = array[indexPath.row];
        TopMenuXmlBase *base = [TopMenuXmlBase modelObjectWithDictionary:dic];
        NSRange httpRange=[base.weburl rangeOfString:@"http://"];
        NSRange httpsRange=[base.weburl rangeOfString:@"https://"];
        if(httpRange.location != NSNotFound||httpsRange.location != NSNotFound){
            HwYDBPageViewController *readerVC = [[HwYDBPageViewController alloc] initWithNibName:@"HwOnePageViewController" bundle:nil];
            readerVC.currentUrlStr = base.weburl;
            CustomNavigationController *nav = [[CustomNavigationController alloc] initWithRootViewController:readerVC];
            
            NSMutableArray *array = [[UXml shareUxml] jiexiXML:@"myxml" two:@"daohang"];
            AppDelegate *delegate  = (AppDelegate *)[UIApplication sharedApplication].delegate;
            if (array.count == 1) {
                delegate.currentVC = nav;
            }else{
                [[NSNotificationCenter defaultCenter]postNotificationName:@"toTwoview" object:self userInfo:@{@"url":base.weburl}];
            }
            [self.mm_drawerController setCenterViewController:delegate.currentVC withCloseAnimation:YES completion:nil];
        }
    }
    
    
    
    
    
    
}

- (void)getCacheSize {
    [[HwTools shareTools] getCacheSizeCompletion:^(float size) {
        
        [self.strDataArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
            NSRange cacheRange=[obj rangeOfString:NSLocalizedString(@"cache", nil)];
            if(cacheRange.location != NSNotFound){
                [self.strDataArray removeObjectAtIndex:idx];
                [self.strDataArray insertObject:[NSString stringWithFormat:@"%@(%.2fM)",NSLocalizedString(@"clearCache", nil),size] atIndex:idx];
                [self.tableView reloadData];
                *stop = YES;
            }
        }];
        
        
        
    }];
}


#pragma mark -
#pragma mark Separator Methods

- (void)addSeparatorImageToCell:(UITableViewCell *)cell
{
    UIImageView *separatorImageView = [[UIImageView alloc] initWithFrame:SEPERATOR_LINE_RECT];
    //    [separatorImageView setImage:[UIImage imageNamed:@"DefaultLine"]];
    separatorImageView.backgroundColor = [UIColor grayColor];
    separatorImageView.opaque = YES;
    [cell.contentView addSubview:separatorImageView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
