//
//  MLZNetworkConfig.h
//  NetworkingTest
//
//  Created by malizhi on 16/11/7.
//  Copyright © 2016年 LzNews. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MLZNetworkConfig : NSObject

+ (NSString *)baseUrl;

+ (NSDictionary *)getHttpRequestPublicInfo;

@end
