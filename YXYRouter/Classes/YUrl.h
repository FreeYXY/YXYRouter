//
//  YUrl.h
//  routerDemo
//
//  Created by YXY on 2022/7/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YUrl : NSURL

@property (nonatomic, copy, readonly) NSString *y_urlString;   /**< URL字符串 */
@property (nonatomic, copy) NSString *yScheme;                /**< 协议 */
@property (nonatomic, copy) NSString *yHost;                  /**< 域 */
@property (nonatomic, copy) NSString *yPath;                  /**< 地址 */
@property (nonatomic, copy) NSDictionary *yQuery;             /**< 参数列表 */

/// 初始化url
- (instancetype)initWithString:(NSString *)string;

- (NSArray *)y_queryparams;

@end

NS_ASSUME_NONNULL_END
