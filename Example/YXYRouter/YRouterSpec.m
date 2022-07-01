//
//  YRouterSpec.m
//  YXYRouter_Example
//
//  Created by YXY on 2022/7/1.
//  Copyright © 2022 YXY. All rights reserved.
//

#import "YRouterSpec.h"
#import "YRouterConst.h"
#import "NSObject+YCommon.h"
#import <YRouter.h>
#import <YControllerFactory.h>

@implementation YRouterSpec

+ (void)load {
    
    [YRouter y_registerURLPattern:KUrlHome toHandler:^(NSDictionary * _Nonnull routerParams) {
        //        NSDictionary *info = routerParameters[ANRouterParameterUserInfo];
        
        NSMutableDictionary *info = [routerParams[YRouterParameterUserInfo] mutableCopy];
        //[info setObject:routerParameters[ANRouterParameterCompletion] forKey:@"completion"];
        
        UIViewController *vc = [YControllerFactory y_VCFromClassName:@"YControllerFirst" info:info];
        [[self y_currentActiveController].navigationController pushViewController:vc animated:YES];
        
//        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
//        nav.modalPresentationStyle = UIModalPresentationFullScreen;
//        [[NSObject y_currentActiveController] presentViewController:nav animated:YES completion:nil];
    }];
    
    [YRouter y_registerURLPattern:KUrlHomeV2 toHandler:^(NSDictionary * _Nonnull routerParams) {
        //        NSDictionary *info = routerParameters[ANRouterParameterUserInfo];
        
        NSMutableDictionary *info = [routerParams[YRouterParameterUserInfo] mutableCopy];
        [info setObject:routerParams[YRouterParameterCompletion] forKey:@"completion"];
        UIViewController *vc = [YControllerFactory y_VCFromClassName:@"YControllerSecond" info:info];
//        UIViewController *vc = [YControllerFactory y_VCFromHost:@"Course" info:info];
        [[self y_currentActiveController].navigationController pushViewController:vc animated:YES];
//        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        //nav.modalPresentationStyle = UIModalPresentationFullScreen;
        //[[NSObject y_currentActiveController] presentViewController:nav animated:YES completion:nil];
    }];
    
}


@end
