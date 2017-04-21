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

@interface TabBarViewController ()

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
}
@end
