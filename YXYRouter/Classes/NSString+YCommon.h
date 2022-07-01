//
//  NSString+YCommon.h
//  routerDemo
//
//  Created by YXY on 2022/7/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (YCommon)

/**
 *  截取URL中的参数
 *
 *  @return NSMutableDictionary parameters
 */
- (NSMutableDictionary *)y_getURLParameters;
@end

NS_ASSUME_NONNULL_END
