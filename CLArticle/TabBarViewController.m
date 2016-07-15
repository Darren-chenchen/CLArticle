//
//  TabBarViewController.m
//  CLArticle
//
//  Created by darren on 16/7/15.
//  Copyright © 2016年 shanku. All rights reserved.
//

#import "TabBarViewController.h"
#import "ViewController.h"
#import "UIImageView+WebCache.h"
#import "firstViewController.h"

#define CLScreenH [UIScreen mainScreen].bounds.size.height
#define CLScreenW [UIScreen mainScreen].bounds.size.width

@interface TabBarViewController ()
/**标记是否是第一次启动*/
@property (nonatomic,assign) NSInteger index;

@property (nonatomic,weak) UIView *launchView;
/**跳过*/
@property (nonatomic,weak) UIButton *jumpBtn;
@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     ViewController *headPage = [[ViewController alloc] init];
    UINavigationController *navHead = [[UINavigationController alloc] initWithRootViewController:headPage];
    [self addChildViewController:navHead];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.index == 0) {
        UIViewController *viewController = [[firstViewController alloc] init];
        UIView *launchView = viewController.view;
        self.launchView = launchView;
        UIWindow *mainWindow = [UIApplication sharedApplication].keyWindow;
        launchView.frame = CGRectMake(0, 0, CLScreenW, CLScreenH);
        [mainWindow addSubview:launchView];
        
        UIImageView *Img1 = [[UIImageView alloc] initWithFrame:CGRectMake(0,  0, CLScreenW, CLScreenH-115)];
        [Img1 sd_setImageWithURL:[NSURL URLWithString:@"http://zuiyouimage.b0.upaiyun.com/2016/7/21467785051.jpg"] placeholderImage:[UIImage imageNamed:@""] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self clickJump];
            });
        }];
        [launchView addSubview:Img1];
        
        UIImageView *Img2 = [[UIImageView alloc] initWithFrame:CGRectMake(0,  CLScreenH-115, CLScreenW, 115)];
        Img2.image = [UIImage imageNamed:@"first-1.jpg"];
        [launchView addSubview:Img2];
        
        // 跳过
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(CLScreenW-70, 20, 50, 30)];
        [btn setTitle:@"跳过" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        btn.layer.cornerRadius = 5;
        btn.layer.masksToBounds = YES;
        [btn setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:0.8]];
        [btn addTarget:self action:@selector(clickJump) forControlEvents:UIControlEventTouchUpInside];
        [mainWindow addSubview:btn];
        self.jumpBtn = btn;
        
        [UIView animateWithDuration:0.5 delay:3 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            CGRect frame = launchView.frame;
            frame.origin.y = CLScreenH;
            launchView.frame = frame;
            [self.jumpBtn removeFromSuperview];
            self.jumpBtn = nil;
        } completion:^(BOOL finished) {
            [launchView removeFromSuperview];
        }];
    }
    self.index ++;
}
- (void)clickJump
{
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.launchView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.launchView removeFromSuperview];
    }];
    [self.jumpBtn removeFromSuperview];
    self.jumpBtn = nil;
}
@end
