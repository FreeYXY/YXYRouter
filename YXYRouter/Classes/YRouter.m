//
//  YRouter.m
//  routerDemo
//
//  Created by YXY on 2022/7/1.
//

#import "YRouter.h"


static NSString * const Y_ROUTER_WILDCARD_CHARACTER = @"~";
static NSString *specialCharacters = @"/?&.";

NSString *const YRouterParameterURL = @"YRouterParameterURL";
NSString *const YRouterParameterCompletion = @"YRouterParameterCompletion";
NSString *const YRouterParameterUserInfo = @"YRouterParameterUserInfo";

@interface YRouter ()

/**
 *  保存了所有已注册的 URL
 *  结构类似 @{@"beauty": @{@":id": {@"_", [block copy]}}}
 */
@property (nonatomic, strong) NSMutableDictionary *routes;

@end

@implementation YRouter

+ (instancetype)sharedInstance {
    
    static YRouter *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

#pragma mark - 注册
+ (void)y_registerURLPattern:(NSString *)URLPattern toHandler:(YRouterHandler)handler {
    
    [[self sharedInstance] y_addURLPattern:URLPattern andHandler:handler];
}

+ (void)y_registerURLPattern:(NSString *)URLPattern toObjectHandler:(YRouterObjectHandler)handler {
    
    [[self sharedInstance] y_addURLPattern:URLPattern andObjectHandler:handler];
}

+ (void)y_deregisterURLPattern:(NSString *)URLPattern {
    
    [[self sharedInstance] y_removeURLPattern:URLPattern];
}

- (void)y_addURLPattern:(NSString *)URLPattern andHandler:(YRouterHandler)handler {
    NSMutableDictionary *subRoutes = [self y_addURLPattern:URLPattern];
    if (handler && subRoutes) {
        subRoutes[@"_"] = [handler copy];
    }
}

- (void)y_addURLPattern:(NSString *)URLPattern andObjectHandler:(YRouterObjectHandler)handler {
    NSMutableDictionary *subRoutes = [self y_addURLPattern:URLPattern];
    if (handler && subRoutes) {
        subRoutes[@"_"] = [handler copy];
    }
}

- (NSMutableDictionary *)y_addURLPattern:(NSString *)URLPattern {
    NSArray *pathComponents = [self y_pathComponentsFromURL:URLPattern];

    NSMutableDictionary* subRoutes = self.routes;
    
    for (NSString* pathComponent in pathComponents) {
        if (![subRoutes objectForKey:pathComponent]) {
            subRoutes[pathComponent] = [[NSMutableDictionary alloc] init];
        }
        subRoutes = subRoutes[pathComponent];
    }
    return subRoutes;
}


#pragma mark - 打开url
+ (void)y_openURL:(NSString *)URL {
    [self y_openURL:URL completion:nil];
}

+ (void)y_openURL:(NSString *)URL completion:(nullable void (^)(id result))completion {
    [self y_openURL:URL withUserInfo:nil completion:completion];
}

+ (void)y_openURL:(NSString *)URL withUserInfo:(NSDictionary *)userInfo completion:(void (^)(id result))completion {

    URL = [URL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSMutableDictionary *parameters = [[self sharedInstance] y_extractParametersFromURL:URL matchExactly:NO];
    
    [parameters enumerateKeysAndObjectsUsingBlock:^(id key, NSString *obj, BOOL *stop) {
        if ([obj isKindOfClass:[NSString class]]) {
            parameters[key] = [obj stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        }
    }];
    
    if (parameters) {
        YRouterHandler handler = parameters[@"block"];
        if (completion) {
            parameters[YRouterParameterCompletion] = completion;
        }
        if (userInfo) {
            parameters[YRouterParameterUserInfo] = userInfo;
        }
        if (handler) {
            [parameters removeObjectForKey:@"block"];
            handler(parameters);
        }
    }
}

+ (BOOL)y_canOpenURL:(NSString *)URL {
    return [[self sharedInstance] y_extractParametersFromURL:URL matchExactly:NO] ? YES : NO;
}

+ (BOOL)y_canOpenURL:(NSString *)URL matchExactly:(BOOL)exactly {
    return [[self sharedInstance] y_extractParametersFromURL:URL matchExactly:YES] ? YES : NO;
}

+ (NSString *)y_generateURLWithPattern:(NSString *)pattern parameters:(NSArray *)parameters {
    NSInteger startIndexOfColon = 0;
    
    NSMutableArray *placeholders = [NSMutableArray array];
    
    for (int i = 0; i < pattern.length; i++) {
        NSString *character = [NSString stringWithFormat:@"%c", [pattern characterAtIndex:i]];
        if ([character isEqualToString:@":"]) {
            startIndexOfColon = i;
        }
        if ([specialCharacters rangeOfString:character].location != NSNotFound && i > (startIndexOfColon + 1) && startIndexOfColon) {
            NSRange range = NSMakeRange(startIndexOfColon, i - startIndexOfColon);
            NSString *placeholder = [pattern substringWithRange:range];
            if (![self y_checkIfContainsSpecialCharacter:placeholder]) {
                [placeholders addObject:placeholder];
                startIndexOfColon = 0;
            }
        }
        if (i == pattern.length - 1 && startIndexOfColon) {
            NSRange range = NSMakeRange(startIndexOfColon, i - startIndexOfColon + 1);
            NSString *placeholder = [pattern substringWithRange:range];
            if (![self y_checkIfContainsSpecialCharacter:placeholder]) {
                [placeholders addObject:placeholder];
            }
        }
    }
    
    __block NSString *parsedResult = pattern;
    
    [placeholders enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        idx = parameters.count > idx ? idx : parameters.count - 1;
        parsedResult = [parsedResult stringByReplacingOccurrencesOfString:obj withString:parameters[idx]];
    }];
    
    return parsedResult;
}

+ (id)y_objectForURL:(NSString *)URL {
    
    return [self y_objectForURL:URL withUserInfo:nil];
}


+ (id)y_objectForURL:(NSString *)URL withUserInfo:(NSDictionary *)userInfo {
    YRouter *router = [YRouter sharedInstance];
    
    URL = [URL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSMutableDictionary *parameters = [router y_extractParametersFromURL:URL matchExactly:NO];
    YRouterObjectHandler handler = parameters[@"block"];
    
    if (handler) {
        if (userInfo) {
            parameters[YRouterParameterUserInfo] = userInfo;
        }
        [parameters removeObjectForKey:@"block"];
        return handler(parameters);
    }
    return nil;
}


#pragma mark - Utils

- (NSMutableDictionary *)y_extractParametersFromURL:(NSString *)url matchExactly:(BOOL)exactly {
    
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    
    parameters[YRouterParameterURL] = url;
    
    NSMutableDictionary* subRoutes = self.routes;
    NSArray* pathComponents = [self y_pathComponentsFromURL:url];
    
    BOOL found = NO;

    for (NSString* pathComponent in pathComponents) {
        
        // 对 key 进行排序，这样可以把 ~ 放到最后
        NSArray *subRoutesKeys =[subRoutes.allKeys sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
            return [obj1 compare:obj2];
        }];
        
        for (NSString* key in subRoutesKeys) {
            if ([key isEqualToString:pathComponent] || [key isEqualToString:Y_ROUTER_WILDCARD_CHARACTER]) {
                found = YES;
                subRoutes = subRoutes[key];
                break;
            } else if ([key hasPrefix:@":"]) {
                found = YES;
                subRoutes = subRoutes[key];
                NSString *newKey = [key substringFromIndex:1];
                NSString *newPathComponent = pathComponent;
                // 再做一下特殊处理，比如 :id.html -> :id
                if ([self.class y_checkIfContainsSpecialCharacter:key]) {
                    NSCharacterSet *specialCharacterSet = [NSCharacterSet characterSetWithCharactersInString:specialCharacters];
                    NSRange range = [key rangeOfCharacterFromSet:specialCharacterSet];
                    if (range.location != NSNotFound) {
                        // 把 pathComponent 后面的部分也去掉
                        newKey = [newKey substringToIndex:range.location - 1];
                        NSString *suffixToStrip = [key substringFromIndex:range.location];
                        newPathComponent = [newPathComponent stringByReplacingOccurrencesOfString:suffixToStrip withString:@""];
                    }
                }
                parameters[newKey] = newPathComponent;
                break;
            } else if (exactly) {
                found = NO;
            }
        }
        
        // 如果没有找到该 pathComponent 对应的 handler，则以上一层的 handler 作为 fallback
        if (!found && !subRoutes[@"_"]) {
            return nil;
        }
    }
    
    // Extract Params From Query.
    NSArray<NSURLQueryItem *> *queryItems = [[NSURLComponents alloc] initWithURL:[[NSURL alloc] initWithString:url] resolvingAgainstBaseURL:false].queryItems;
    
    for (NSURLQueryItem *item in queryItems) {
        parameters[item.name] = item.value;
    }

    if (subRoutes[@"_"]) {
        parameters[@"block"] = [subRoutes[@"_"] copy];
    }
    
    return parameters;
}

- (void)y_removeURLPattern:(NSString *)URLPattern {
    NSMutableArray *pathComponents = [NSMutableArray arrayWithArray:[self y_pathComponentsFromURL:URLPattern]];
    
    // 只删除该 pattern 的最后一级
    if (pathComponents.count >= 1) {
        // 假如 URLPattern 为 a/b/c, components 就是 @"a.b.c" 正好可以作为 KVC 的 key
        NSString *components = [pathComponents componentsJoinedByString:@"."];
        NSMutableDictionary *route = [self.routes valueForKeyPath:components];
        
        if (route.count >= 1) {
            NSString *lastComponent = [pathComponents lastObject];
            [pathComponents removeLastObject];
            
            // 有可能是根 key，这样就是 self.routes 了
            route = self.routes;
            if (pathComponents.count) {
                NSString *componentsWithoutLast = [pathComponents componentsJoinedByString:@"."];
                route = [self.routes valueForKeyPath:componentsWithoutLast];
            }
            [route removeObjectForKey:lastComponent];
        }
    }
}

- (NSArray*)y_pathComponentsFromURL:(NSString*)URL {

    NSMutableArray *pathComponents = [NSMutableArray array];
    if ([URL rangeOfString:@"://"].location != NSNotFound) {
        NSArray *pathSegments = [URL componentsSeparatedByString:@"://"];
        // 如果 URL 包含协议，那么把协议作为第一个元素放进去
        [pathComponents addObject:pathSegments[0]];
        
        // 如果只有协议，那么放一个占位符
        URL = pathSegments.lastObject;
        if (!URL.length) {
            [pathComponents addObject:Y_ROUTER_WILDCARD_CHARACTER];
        }
    }

    for (NSString *pathComponent in [[NSURL URLWithString:URL] pathComponents]) {
        if ([pathComponent isEqualToString:@"/"]) continue;
        if ([[pathComponent substringToIndex:1] isEqualToString:@"?"]) break;
        [pathComponents addObject:pathComponent];
    }
    return [pathComponents copy];
}

- (NSMutableDictionary *)routes {
    if (!_routes) {
        _routes = [[NSMutableDictionary alloc] init];
    }
    return _routes;
}

#pragma mark - Utils

+ (BOOL)y_checkIfContainsSpecialCharacter:(NSString *)checkedString {
    NSCharacterSet *specialCharactersSet = [NSCharacterSet characterSetWithCharactersInString:specialCharacters];
    return [checkedString rangeOfCharacterFromSet:specialCharactersSet].location != NSNotFound;
}

@end
