//
//  YViewController.m
//  YXYRouter
//
//  Created by YXY on 07/01/2022.
//  Copyright (c) 2022 YXY. All rights reserved.
//

#import "YViewController.h"
#import "YRouter.h"
#import "YRouterConst.h"
@interface YViewController ()


@end

@implementation YViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
 
    UIButton *btnVC1 = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btnVC1.frame = CGRectMake(50, 100, 300, 60);
    [btnVC1 setTitle:@"跳转YControllerFirst传递参数" forState:(UIControlStateNormal)];
    [btnVC1 setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [btnVC1 addTarget:self action:@selector(action) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btnVC1];
    
    UIButton *btnVC2 = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btnVC2.frame = CGRectMake(50, 160, 300, 60);
    [btnVC2 setTitle:@"跳转YControllerSecond回传数据" forState:(UIControlStateNormal)];
    [btnVC2 setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [btnVC2 addTarget:self action:@selector(actionV2) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btnVC2];
 
}
-(void)action{
    /// 路由
    [YRouter y_openURL:KUrlHome withUserInfo:@{@"name":@"success",@"tip":@"I‘m happy"} completion:^(id  _Nonnull result) {
        NSLog(@"%@",result);
    }];
}

-(void)actionV2{
    /// 路由
    [YRouter y_openURL:KUrlHomeV2 withUserInfo:@{} completion:^(id  _Nonnull result) {
        NSLog(@"%@",result);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
