//
//  MLZNetworkConfi.m
//  NetworkingTest
//
//  Created by malizhi on 16/11/7.
//  Copyright © 2016年 malizhi. All rights reserved.
//
#import "MLZNetworkConfig.h"
#import "SSKeychain.h"
#import "APIConfig.pch"

NSString *const kApiMarket      = MARKET;
NSString *const kApiVercode     = VERSION_CODE;
NSString *const kApiVername     = VERSION;
NSString *const kApiFlag        = PLATFORM;

@implementation MLZNetworkConfig

+ (NSString *)baseUrl
{
    return [NSString stringWithFormat:@"%@%@", HOST, @"/api/index.php?"];
}

+ (NSDictionary *)getHttpRequestPublicInfo
{
    NSString *openUdid = API_OPENUDID;
    
    NSMutableDictionary *dictM = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  kApiMarket, @"market",
                                  kApiVercode, @"vercode",
                                  kApiVername, @"vername",
                                  kApiFlag, @"flag", nil];
    if (openUdid) {
        [dictM setValue:openUdid forKey:@"deviceid"];
    }
    
    return [dictM mutableCopy];
}

@end
