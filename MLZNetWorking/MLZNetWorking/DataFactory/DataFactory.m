//
//  DataFactory.m
//  NetworkingTest
//
//  Created by malizhi on 16/11/8.
//  Copyright © 2016年 LzNews. All rights reserved.
//

#import "DataFactory.h"
#import "NWTestApi.h"

#import "MLZBaseRequest.h"


@implementation DataFactory
//把来源不同的数据拼接在一起
- (id)request:(MLZBaseRequest *)request reformData:(id)data
{
    if ([request isKindOfClass:[NWTestApi class]]) {
      return   [self testApiActionWithData:data];
    }
    
    if ([request isKindOfClass:[NWTestApi1 class]]) {
        return [self testApi2ActionWithData:data];
    }
    
    if ([request isKindOfClass:[NWTestApi2 class]]) {
        return [self testApi3ActionWithData:data];
    }
    
    return data;

}

- (id)testApiActionWithData:(id)data
{
    return nil;
}

- (id)testApi2ActionWithData:(id)data
{
    return nil;
}

- (id)testApi3ActionWithData:(id)data
{
    return nil;
}

@end


@implementation DataFactory2

//把来源不同的数据拼接在一起
- (id)request:(MLZBaseRequest *)request reformData:(id)data
{
    if ([request isKindOfClass:[NWTestApi class]]) {
        return   [self testApiActionWithData:data];
    }
    
    if ([request isKindOfClass:[NWTestApi1 class]]) {
        return [self testApi2ActionWithData:data];
    }
    
    if ([request isKindOfClass:[NWTestApi2 class]]) {
        return [self testApi3ActionWithData:data];
    }
    
    return data;
    
}

- (id)testApiActionWithData:(id)data
{
    return nil;
}

- (id)testApi2ActionWithData:(id)data
{
    return nil;
}

- (id)testApi3ActionWithData:(id)data
{
    return nil;
}

@end


@implementation DataFactory3

//把来源不同的数据拼接在一起
- (id)request:(MLZBaseRequest *)request reformData:(id)data
{
    if ([request isKindOfClass:[NWTestApi class]]) {
        return   [self testApiActionWithData:data];
    }
    
    if ([request isKindOfClass:[NWTestApi1 class]]) {
        return [self testApi2ActionWithData:data];
    }
    
    if ([request isKindOfClass:[NWTestApi2 class]]) {
        return [self testApi3ActionWithData:data];
    }
    
    return data;
    
}

- (id)testApiActionWithData:(id)data
{
    return nil;
}

- (id)testApi2ActionWithData:(id)data
{
    return nil;
}

- (id)testApi3ActionWithData:(id)data
{
    return nil;
}

@end
