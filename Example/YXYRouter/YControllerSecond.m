//
//  YControllerSecond.m
//  YXYRouter_Example
//
//  Created by YXY on 2022/7/1.
//  Copyright © 2022 YXY. All rights reserved.
//

#import "YControllerSecond.h"

@interface YControllerSecond ()
@property (nonatomic, copy) void (^completion)(id result);
@end

@implementation YControllerSecond

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
    
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.completion(@"向前传递");
    
}
@end
