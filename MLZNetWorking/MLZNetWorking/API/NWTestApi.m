//
//  NWTestApi.m
//  NetworkingTest
//
//  Created by malizhi on 16/11/7.
//  Copyright © 2016年 LzNews. All rights reserved.
//

#import "NWTestApi.h"

@implementation NWTestApi

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (MLZRequestMethod)methodName
{
    return MLZRequestMethodGet;
}

- (NSString *)baseUrl
{
   return @"";
}

- (NSString *)detailUrl
{
   return @"";
}

- (MLZRequestSerializerType)requestSerializerType
{
    return MLZRequestSerializerTypeHTTP;
}

- (HttpServiceSessionType)serviceSessionType
{
    return HttpServiceSessionTypeDefault;
}

@end



@implementation NWTestApi1

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (NSString *)detailUrl
{
    return @"";
}

- (MLZRequestMethod)methodName
{
    return MLZRequestMethodGet;
}

- (MLZRequestSerializerType)requestSerializerType
{
    return MLZRequestSerializerTypeHTTP;
}

- (HttpServiceSessionType)serviceSessionType
{
    return HttpServiceSessionTypeDefault;
}

- (id)requestParams:(NSDictionary *)params
{
    //根据需要对请求的参数做出处理
    NSMutableDictionary *paraDicM = [NSMutableDictionary dictionaryWithDictionary:params];
    return paraDicM;
}

@end



@implementation NWTestApi2

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (MLZRequestMethod)methodName
{
    return MLZRequestMethodGet;
}

- (NSString *)detailUrl
{
    return @"";
}

- (MLZRequestSerializerType)requestSerializerType
{
    return MLZRequestSerializerTypeHTTP;
}

- (HttpServiceSessionType)serviceSessionType
{
    return HttpServiceSessionTypeDefault;
}

@end


