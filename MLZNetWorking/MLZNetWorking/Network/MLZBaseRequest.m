//
//  MLZBaseRequest.m
//  NetworkingTest
//
//  Created by malizhi on 16/11/7.
//  Copyright © 2016年 malizhi. All rights reserved.
//
#import "MLZBaseRequest.h"
#import "MLZNetwork.h"


@interface MLZBaseRequest ()

@property (nonatomic, strong) id response;
@property (nonatomic, strong) NSMutableArray *requestIdList;

@end

@implementation MLZBaseRequest

- (instancetype)init
{
    self = [super init];
    if (self) {
        if ([self conformsToProtocol:@protocol(MLZRequest)]) {
            self.childRequest = (id<MLZRequest>)self;
        } else {
            //不遵循RXRequest抛出异常
            NSException *exception = [[NSException alloc] init];
            @throw exception;
        }
    }
    return self;
}

- (void)dealloc
{
    _callBackDelegate = nil;
}

- (id)dataWithReformer:(id<MLZBaseRequestDataReformer>)reformer
{
    id resultData = nil;
    if (reformer && [reformer respondsToSelector:@selector(request:reformData:)]) {
        resultData = [reformer request:self reformData:self.responseJSONObject];
    } else {
        resultData = [self.responseJSONObject mutableCopy];
    }
    return resultData;
}

-(NSInteger)requestLoadData
{
    NSNumber *requestID =   [[MLZNetwork sharedInstance] sendRequest:self];
    [self.requestIdList addObject:requestID];
    return [requestID integerValue];
}

- (void)requestCallBackResponseJSONObject:(id)responseJSONObject
{
    self.response = responseJSONObject;
}

- (id)responseJSONObject
{
    return self.response;
}

+ (BOOL)isNetworking
{
    return [[MLZNetwork sharedInstance] isNetworking];
}

- (MLZNetworkReachabilityStatus)networkReachabilityStatus
{
    return [[MLZNetwork sharedInstance] reachabilityStatus];
}

- (void)cancelAllRequests
{
    [[MLZNetwork sharedInstance] cancelRequestWithRequestIDList:self.requestIdList];
    [self.requestIdList removeAllObjects];
}

- (void)cancelRequestWithRequestId:(NSInteger)requestID
{
    [self removeRequestIdWithRequestID:requestID];
    [[MLZNetwork sharedInstance] cancelRequestWithRequestID:@(requestID)];
}

- (void)removeRequestIdWithRequestID:(NSInteger)requestId
{
    NSNumber *requestIDToRemove = nil;
    for (NSNumber *storedRequestId in self.requestIdList) {
        if ([storedRequestId integerValue] == requestId) {
            requestIDToRemove = storedRequestId;
        }
    }
    if (requestIDToRemove) {
        [self.requestIdList removeObject:requestIDToRemove];
    }
}

- (NSMutableArray *)requestIdList
{
    if (_requestIdList == nil) {
        _requestIdList = [[NSMutableArray alloc] init];
    }
    return _requestIdList;
}

@end
