//
//  YControllerFactory.m
//  routerDemo
//
//  Created by YXY on 2022/7/1.
//

#import "YControllerFactory.h"
#import "YMatchProperty.h"

@implementation YControllerFactory

+ (UIViewController *)y_VCFromHost:(NSString *)host {
    return [[self class] y_VCFromHost:host info:nil];
}

+ (UIViewController *)y_VCFromHost:(NSString *)host info:(NSDictionary *)info {
    if (![host isKindOfClass:[NSString class]] || host.length == 0) {
        return nil;
    }
    /// 首字母大写
    NSString *className = [NSString stringWithFormat:@"%@%@ViewController", [[host substringToIndex:1] uppercaseString], [host substringFromIndex:1]];
    return [[self class] y_VCFromClassName:className info:info];
}

+ (UIViewController *)y_VCFromClassName:(NSString *)className info:(NSDictionary *)info {
    if (![className isKindOfClass:[NSString class]] || [className length] == 0) {
        return nil;
    }
    Class vcClass = NSClassFromString(className);
    if (![vcClass isSubclassOfClass:[UIViewController class]]) {
        return nil;
    }
    UIViewController *vc = [vcClass new];
    [[self class] y_configViper:vc info:info];
    return vc;
}

+ (void)y_configViper:(UIViewController *)vc info:(NSDictionary *)info {
    if (![vc isKindOfClass:[UIViewController class]]) {
        return;
    }
//    BaseViewController *viperVC = (BaseViewController *)vc;
  
    [YMatchProperty y_matchProperty:vc params:info];
}

@end
