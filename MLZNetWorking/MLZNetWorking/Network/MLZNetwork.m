//
//  MLZNetwork.m
//  NetworkingTest
//
//  Created by malizhi on 16/11/7.
//  Copyright © 2016年 malizhi. All rights reserved.
//
#import "MLZNetwork.h"
#import "AFNetworking.h"
#import "MLZNetworkConfig.h"
#import "Reachability.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "APIConfig.pch"

/** 系统判断 */
#define IOS7                    [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0
#define IOS8                    [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0

@interface MLZNetwork ()

{
    AFHTTPSessionManager *_sessionManager;
    AFHTTPSessionManager *_defaultSessionManager;
    AFHTTPSessionManager *_ephemeralSessionManager;
    AFHTTPSessionManager *_backgroundSessionManager;
    AFNetworkReachabilityManager *_reachabilityManager;
}

@property (nonatomic, strong) NSMutableDictionary *dispatchTable;

@end

@implementation MLZNetwork

#pragma mark - lifeCycle                    - Method -

+ (instancetype)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        
        [self config];
    }
    return self;
}

- (void)config
{
    [self configureDefaultSessionManager];
    [self configureEphemeralSessionManager];
    [self configureBackgroundSessionManager];
    [self configureReachabilityManager];
}

- (void)configureDefaultSessionManager
{
    NSURLSessionConfiguration *defaultConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    _defaultSessionManager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:defaultConfig];
    [self setupResponseSerializerContentTypeForManager:_defaultSessionManager];
}

- (void)configureEphemeralSessionManager
{
    NSURLSessionConfiguration *ephemeralConfig = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    _ephemeralSessionManager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:ephemeralConfig];
    [self setupResponseSerializerContentTypeForManager:_ephemeralSessionManager];
}

- (void)configureBackgroundSessionManager
{
    if (IOS8) {
        NSURLSessionConfiguration *backgroundConfig = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"background"];
        _backgroundSessionManager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:backgroundConfig];
        [self setupResponseSerializerContentTypeForManager:_backgroundSessionManager];
    }
    
}

- (void)configureReachabilityManager
{
    _reachabilityManager = [AFNetworkReachabilityManager sharedManager];
    [_reachabilityManager startMonitoring];
    [_reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未识别的网络");
                break;
                
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"不可达的网络(未连接)");
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"2G,3G,4G...的网络");
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"wifi的网络");
                break;
            default:
                break;
        }
        
    }];
}

#pragma mark - Networking                    - Method -

- (BOOL)isNetworking
{
    return _reachabilityManager.isReachable;
}

- (MLZNetworkReachabilityStatus)reachabilityStatus
{
    MLZNetworkReachabilityStatus status;
    
    switch (_reachabilityManager.networkReachabilityStatus) {
        case AFNetworkReachabilityStatusUnknown:
            status = MLZNetworkReachabilityStatusUnknown;
            break;
            
        case AFNetworkReachabilityStatusNotReachable:
            status = MLZNetworkReachabilityStatusNotReachable;
            break;
            
        case AFNetworkReachabilityStatusReachableViaWWAN:
            status = MLZNetworkReachabilityStatusReachableViaWWAN;
            break;
            
        case AFNetworkReachabilityStatusReachableViaWiFi:
            status = MLZNetworkReachabilityStatusReachableViaWiFi;
            break;
        default:
            break;
    }
    
    return status;
}

#pragma mark - request                    - Method -

- (NSNumber *)sendRequest:(MLZBaseRequest *)request
{
    MLZRequestMethod method = [request.childRequest methodName];
    NSString *url = [self buildRequestUrl:request];
    id param = [self buildRequestParam:request];
    
    _sessionManager = [self getProperlyManager:[request.childRequest serviceSessionType]];
    [_sessionManager setSecurityPolicy:[self customSecurityPolicy]];
    if (request.childRequest && [request.childRequest respondsToSelector:@selector(requestTimeoutInterval)]) {
       _sessionManager.requestSerializer.timeoutInterval = [request.childRequest requestTimeoutInterval];
    }
    
    if (request.childRequest.requestSerializerType == MLZRequestSerializerTypeHTTP) {
        _sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    } else if (request.childRequest.requestSerializerType == MLZRequestSerializerTypeJSON) {
        _sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    
    __block NSURLSessionDataTask *dataTask = nil;
    
    /// request
    if (method == MLZRequestMethodGet) {
        
      dataTask = [_sessionManager GET:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self buildCallBackResult:request responseObject:responseObject error:nil requestId:[[dataTask taskDescription] integerValue]];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self buildCallBackResult:request responseObject:nil error:error requestId:[[dataTask taskDescription] integerValue]];
        }];
        
    } else if (method == MLZRequestMethodGet) {
        
         dataTask =   [_sessionManager POST:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [self buildCallBackResult:request responseObject:responseObject error:nil requestId:[[dataTask taskDescription] integerValue]];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self buildCallBackResult:request responseObject:nil error:error requestId:[[dataTask taskDescription] integerValue]];
            }];
    }
    
    NSNumber *requestId = @([dataTask taskIdentifier]);
    self.dispatchTable[requestId] = dataTask;
    [dataTask resume];
    _sessionManager = nil;
    
    return requestId;
}

- (void)buildCallBackResult:(MLZBaseRequest *)request responseObject:(id)responseObject error:(NSError *)error requestId:(NSInteger)requestId
{
    if (responseObject) {
        
        if ([self checkResult:responseObject]) {
            /// 返回的状态吗是否为0
            NSString *errorCode = responseObject[@"error"];
            if ([errorCode integerValue] != 0) {
                NSString *message = responseObject[@"msg"];
                if (message && message.length > 0) {
                   //提示错误信息
                }
            }
            
            if ((request.callBackDelegate && request) && [request.callBackDelegate respondsToSelector:@selector(MLZBaseRequestCallAPIDidSuccess:)]) {
                [request requestCallBackResponseJSONObject:responseObject];
                [request.callBackDelegate MLZBaseRequestCallAPIDidSuccess:request];
            }
        }
    }
    if (error) {
        /**
         *  如果是网络超时会给出系统提示，其他错误情况都按照无网络情况处理,failureCompletionBlock回调之后按照无网络处理就可以
         */
        if (error.code == NSURLErrorTimedOut) {
            //连接超时
        }
        
        NSURLSessionDataTask *requestDask = self.dispatchTable[[NSNumber numberWithInteger:requestId]];
        
        /** 请求错误或服务器错误,只给提示@"连接失败" */
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)requestDask.response;
        NSInteger responseStatusCode = [httpResponse statusCode];
        //        NSLog(@"%d", responseStatusCode);
        
        if (responseStatusCode >= 400 && responseStatusCode <= 599) {
            //连接失败
        }
        if ((request.callBackDelegate && request) && [request.callBackDelegate respondsToSelector:@selector(MLZBaseRequestCallAPIDidFailed:)]) {
            [request.callBackDelegate MLZBaseRequestCallAPIDidFailed:request];
        }
    }
    
    [request removeRequestIdWithRequestID:requestId];
}

#pragma mark - privateMethods               - Method -

/// 构建url
- (NSString *)buildRequestUrl:(MLZBaseRequest *)request
{
    NSString *detailUrl = [request.childRequest detailUrl];
    if ([detailUrl hasPrefix:@"http"]) {
        return detailUrl;
    }
    
    NSString *baseUrl;
    if (request.childRequest && [request.childRequest respondsToSelector:@selector(baseUrl)]) {
        baseUrl = [request.childRequest baseUrl];
        if ([request.childRequest baseUrl].length > 0) {
            baseUrl = [request.childRequest baseUrl];
        } else {
            baseUrl = [MLZNetworkConfig baseUrl];
        }
    }
    
    /** 由于api接口不标准，这里先简单对post请求做个处理 */
    NSString *postParam;
    if (request.childRequest.methodName == MLZRequestMethodGet) {
        postParam = [NSString stringWithFormat:@"%@%@&flag=ios%@", baseUrl, detailUrl, FinalStr];
        return postParam;
    }
    
    return [NSString stringWithFormat:@"%@%@", baseUrl, detailUrl];
}

/// 构建参数
- (id)buildRequestParam:(MLZBaseRequest *)request
{
    NSDictionary *publicInfo = [MLZNetworkConfig getHttpRequestPublicInfo];
    
    if (request) {
        if (request.paramSource && [request.paramSource respondsToSelector:@selector(MLZBaseRequestParamsForApi:)]) {
            NSMutableDictionary *componentParameters = [NSMutableDictionary dictionary];
            if (request.childRequest && [request.childRequest
                                         respondsToSelector:@selector(requestParams:)]) {
                [componentParameters addEntriesFromDictionary:[request.childRequest requestParams:[request.paramSource MLZBaseRequestParamsForApi:request]]];
                
            } else {
               [componentParameters addEntriesFromDictionary:[request.paramSource MLZBaseRequestParamsForApi:request]];
            }
            /** 由于api接口不标准，这里先简单对post请求做个处理 */
            if (request.childRequest.methodName == MLZRequestMethodGet) [componentParameters addEntriesFromDictionary:publicInfo];
            return componentParameters;
         }
        
       }

    return publicInfo;
}

/// 检测返回数据是否合法
- (BOOL)checkResult:(id)result
{
    if (!result) {
        return NO;
    }
    if (![result isKindOfClass:[NSDictionary class]]) {
        return NO;
    }
    /// 返回的是否包含“error” “result”
    if (![[result allKeys] containsObject:@"error"] && ![[result allKeys] containsObject:@"result"]) {
        return NO;
    }
    
    return YES;
}

- (AFHTTPSessionManager *)getProperlyManager:(HttpServiceSessionType)type
{
    AFHTTPSessionManager *manager = _defaultSessionManager;
    switch (type) {
        case HttpServiceSessionTypeDefault:
            manager = _defaultSessionManager;
            break;
        case HttpServiceSessionTypeEphemeral:
            manager = _ephemeralSessionManager;
            break;
        case HttpServiceSessionTypeBackground:
            manager = _backgroundSessionManager;
            break;
        default:
            break;
    }
    return manager;
}

- (void)setupResponseSerializerContentTypeForManager:(id)manager
{
    if (manager && [manager respondsToSelector:@selector(responseSerializer)]) {
        id serializer = [manager performSelector:@selector(responseSerializer) withObject:nil];
        if (serializer) {
            AFHTTPResponseSerializer *ser = (AFHTTPResponseSerializer *)serializer;
            ser.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
        }
    }
}

- (void)cancelRequestWithRequestID:(NSNumber *)requestID
{
    NSURLSessionDataTask *requestOperation = self.dispatchTable[requestID];
    [requestOperation cancel];
    [self.dispatchTable removeObjectForKey:requestID];
}

- (void)cancelRequestWithRequestIDList:(NSArray *)requestIDList
{
    for (NSNumber *requestId in requestIDList) {
        [self cancelRequestWithRequestID:requestId];
    }
}

- (AFSecurityPolicy*)customSecurityPolicy
{
    // /先导入证书
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"https" ofType:@"cer"];//证书的路径
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    
    // AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    
    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    // 如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = NO;
    
    //validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = YES;
    
    securityPolicy.pinnedCertificates = [NSSet setWithObject:certData];
    return securityPolicy;
}

- (NSMutableDictionary *)dispatchTable
{
    if (!_dispatchTable) {
        _dispatchTable = [[NSMutableDictionary alloc] init];
    }
    return _dispatchTable;
}

@end
