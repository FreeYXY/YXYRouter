//
//  YMatchProperty.h
//
//
//  Created by YXY on 2022/7/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YMatchProperty : NSObject
/// 运行时匹配属性并赋值
/// @param obj 对该对象进行属性赋值
/// @param params 要赋值的参数
+ (void)y_matchProperty:(id)obj params:(NSDictionary *)params;

@end

NS_ASSUME_NONNULL_END
