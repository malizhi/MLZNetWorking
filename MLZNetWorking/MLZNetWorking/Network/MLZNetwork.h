//
//  MLZNetwork.h
//  NetworkingTest
//
//  Created by malizhi on 16/11/7.
//  Copyright © 2016年 LzNews. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MLZBaseRequest.h"

@interface MLZNetwork : NSObject

+ (instancetype)sharedInstance;

- (BOOL)isNetworking;
- (MLZNetworkReachabilityStatus)reachabilityStatus;
- (NSNumber *)sendRequest:(MLZBaseRequest *)request;
- (void)cancelRequestWithRequestID:(NSNumber *)requestID;
- (void)cancelRequestWithRequestIDList:(NSArray *)requestIDList;

@end
