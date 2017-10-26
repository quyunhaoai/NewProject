//
//  ThreeViewController.m
//  NewCloudApp
//
//  Created by hao on 15/12/19.
//
//
#define screenW   [[UIScreen mainScreen] bounds].size.width

#define screenH  [[UIScreen mainScreen] bounds].size.height

#import "ThreeViewController.h"

@interface ThreeViewController ()
{
    double w;
    double h;
}
@end

@implementation ThreeViewController
@synthesize delegate;
-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:YES];
    self.view.alpha = 1;
//    self.view.frame = CGRectMake(200, 200, screenW, screenH);
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    w= 1;
    h= 0.5;
//    self.view.alpha = 0.0001;
//    self.webView.alpha = 0.4;
//    self.view.frame = CGRectMake(0, 0, screenW*w, screenH*h);
//    self.view.center = CGPointMake(0, 0);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    
    if (self.url.length > 0) {
        if (self.webView) {
            [self.webView loadRequest:request];
        }
    }
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(returnPath:)];
    
    [self.view addGestureRecognizer:pan];
    
    
    
    
}
-(void)returnPath:(UIPanGestureRecognizer *)pan
{
    
    NSLog(@"---%@",pan);
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelButtonClicked:)]) {
        NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:@"AnimationType"];
        self.outType = array[1] ;
        [self.delegate cancelButtonClicked:self.outType];
    }
    
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
