//
//  YControllerFirst.m
//  YXYRouter_Example
//
//  Created by YXY on 2022/7/1.
//  Copyright © 2022 YXY. All rights reserved.
//

#import "YControllerFirst.h"

@interface YControllerFirst ()
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *tip;

@end

@implementation YControllerFirst

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
    NSLog(@"name:%@,tip:%@",self.name,self.tip);

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
