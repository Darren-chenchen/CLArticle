//
//  ViewController.m
//  CLArticle
//
//  Created by darren on 16/7/15.
//  Copyright © 2016年 shanku. All rights reserved.
//

#import "ViewController.h"
#import "PublishArticleViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    [btn setTitle:@"发文章" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickPublishAticleBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}
- (IBAction)clickPublishAticleBtn:(id)sender {
    PublishArticleViewController *publish = [[PublishArticleViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:publish];
    [self presentViewController:nav animated:YES completion:nil];

}

@end
