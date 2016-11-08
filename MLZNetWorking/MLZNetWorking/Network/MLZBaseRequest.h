//
//  MLZBaseRequest.h
//  NetworkingTest
//
//  Created by malizhi on 16/11/7.
//  Copyright © 2016年 LzNews. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

static NSTimeInterval kMLZNetworkingTimeoutSeconds = 20.0f;

typedef NS_ENUM(NSInteger, MLZRequestMethod) {
    MLZRequestMethodGet = 0,
    MLZRequestMethodPost,
};

typedef NS_ENUM(NSInteger , MLZRequestSerializerType) {
    MLZRequestSerializerTypeHTTP = 0,
    MLZRequestSerializerTypeJSON,
};

typedef NS_ENUM(NSInteger, MLZNetworkReachabilityStatus) {
    MLZNetworkReachabilityStatusUnknown          = -1,
    MLZNetworkReachabilityStatusNotReachable     = 0,
    MLZNetworkReachabilityStatusReachableViaWWAN = 1,
    MLZNetworkReachabilityStatusReachableViaWiFi = 2,
};

typedef NS_ENUM(NSInteger, HttpServiceSessionType) {
    HttpServiceSessionTypeDefault,
    HttpServiceSessionTypeEphemeral,
    HttpServiceSessionTypeBackground
};

@class MLZBaseRequest;

//根据需求定位适配器
@protocol MLZBaseRequestDataReformer <NSObject>
@required
- (id)request:(MLZBaseRequest *)request reformData:(id)data;
@end

//网络Api的回调
@protocol MLZBaseRequestCallBackDelegate <NSObject>
@required
- (void)MLZBaseRequestCallAPIDidSuccess:(MLZBaseRequest *)request;
- (void)MLZBaseRequestCallAPIDidFailed:(MLZBaseRequest *)request;
@end

//让request能够获取调用API所需要的数据
@protocol MLZBaseRequestParamSource <NSObject>
@required
- (NSDictionary *)MLZBaseRequestParamsForApi:(MLZBaseRequest *)request;
@end

/*
  MLZBaseRequest的派生类必须符合这些protocal
 */
@protocol MLZRequest <NSObject>
@required
/// 请求的URL
- (NSString *)detailUrl;
/// 请求的方式
- (MLZRequestMethod)methodName;
/// NSURLSessionConfiguration类型
- (HttpServiceSessionType)serviceSessionType;
/// 请求的SerializerType
- (MLZRequestSerializerType)requestSerializerType;

@optional
/// 请求的BaseURL
- (NSString *)baseUrl;
/// 请求的连接超时时间，默认为60秒
- (NSTimeInterval)requestTimeoutInterval;
/// 请求的参数
- (id)requestParams:(NSDictionary *)params;

@end


@interface MLZBaseRequest : NSObject

@property (nonatomic, strong, readonly) id responseJSONObject;
@property (nonatomic,weak) id <MLZBaseRequestCallBackDelegate> callBackDelegate;
@property (nonatomic, weak) id <MLZBaseRequestParamSource> paramSource;
@property (nonatomic, weak) NSObject <MLZRequest> *childRequest;

//取消所有请求
- (void)cancelAllRequests;

//取消某一个请求
- (void)cancelRequestWithRequestId:(NSInteger)requestID;

- (void)removeRequestIdWithRequestID:(NSInteger)requestId;

///使用reformer实现业务的解耦
- (id)dataWithReformer:(id<MLZBaseRequestDataReformer>)reformer;

///请求返回的参数
- (NSInteger)requestLoadData;

/// 回调数据
- (void)requestCallBackResponseJSONObject:(id)responseJSONObject;

/// 是否连接网络
+ (BOOL)isNetworking;

/// 当前网络状态
- (MLZNetworkReachabilityStatus)networkReachabilityStatus;

@end
