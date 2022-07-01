//
//  YControllerFactory.h
//  routerDemo
//
//  Created by YXY on 2022/7/1.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YControllerFactory : NSObject

+ (UIViewController *)y_VCFromHost:(NSString *)host;
+ (UIViewController *)y_VCFromHost:(NSString *)host info:(NSDictionary *__nullable)info;
+ (UIViewController *)y_VCFromClassName:(NSString *)host info:(NSDictionary *__nullable)info;

@end

NS_ASSUME_NONNULL_END
