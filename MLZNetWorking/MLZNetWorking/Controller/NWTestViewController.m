//
//  NWTestViewController.m
//  NetworkingTest
//
//  Created by malizhi on 16/11/8.
//  Copyright © 2016年 LzNews. All rights reserved.
//

#import "NWTestViewController.h"
#import "NWTestApi.h"
#import "DataFactory.h"

@interface NWTestViewController () <MLZBaseRequestParamSource, MLZBaseRequestCallBackDelegate>

@property (nonatomic, strong) NWTestApi *testAPI;
@property (nonatomic, strong) NWTestApi1 *testApi1;
@property (nonatomic, strong) NWTestApi2 *testApi2;

@property (nonatomic, strong) id <MLZBaseRequestDataReformer>reformer1;
@property (nonatomic, strong) id <MLZBaseRequestDataReformer>reformer2;
@property (nonatomic, strong) id <MLZBaseRequestDataReformer>reformer3;

@end

@implementation NWTestViewController
#pragma mark - lifeCycle                    - Method -
- (void)dealloc
{

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.testAPI requestLoadData];
    [self.testApi1 requestLoadData];
    [self.testApi2 requestLoadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - eventResponse                - Method -

#pragma mark - customDelegate               - Method -

#pragma mark - MLZBaseRequestParamSource
- (NSDictionary *)MLZBaseRequestParamsForApi:(MLZBaseRequest *)request
{
    if (request == _testAPI) {
        //配置自己需要请求的参数
    }
    
    if (request == _testApi1) {
        
    }
    
    if (request == _testApi2) {
        
    }
    
    return nil;
}

#pragma mark - MLZBaseRequestCallBackDelegate
- (void)MLZBaseRequestCallAPIDidSuccess:(MLZBaseRequest *)request
{
    if (request == _testAPI) {
         _reformer1 = [[DataFactory alloc]init];
         _reformer2 = [[DataFactory2 alloc]init];
        
      //获取请求成功的组装后的数据
        [request dataWithReformer:_reformer1];
        [request dataWithReformer:_reformer2];
    }
    
    if (request == _testApi1) {
        
        _reformer2 = [[DataFactory2 alloc]init];
        _reformer3 = [[DataFactory3 alloc]init];
        
        //获取请求成功的组装后的数据
        [request dataWithReformer:_reformer2];
        [request dataWithReformer:_reformer3];
        
    }
    
    if (request == _testApi2) {
        _reformer1 = [[DataFactory alloc]init];
        _reformer3 = [[DataFactory3 alloc]init];
        
        //获取请求成功的组装后的数据
        [request dataWithReformer:_reformer1];
        [request dataWithReformer:_reformer3];
    }
}

- (void)MLZBaseRequestCallAPIDidFailed:(MLZBaseRequest *)request
{
    //获取请求失败失败的组装后的数据
    if (request == _testAPI) {
      
        _reformer1 = [[DataFactory alloc]init];
        _reformer2 = [[DataFactory2 alloc]init];
        
        [request dataWithReformer:_reformer1];
        [request dataWithReformer:_reformer2];
     }
    
    if (request == _testApi1) {
        _reformer2 = [[DataFactory2 alloc]init];
        _reformer3 = [[DataFactory3 alloc]init];
        
        [request dataWithReformer:_reformer2];
        [request dataWithReformer:_reformer3];
     }
    
    if (request == _testApi2) {
        _reformer1 = [[DataFactory alloc]init];
        _reformer3 = [[DataFactory3 alloc]init];
        
        [request dataWithReformer:_reformer1];
        [request dataWithReformer:_reformer3];
        
     }
}

#pragma mark - notification                 - Method -

#pragma mark - privateMethods               - Method -

#pragma mark - objective-cDelegate          - Method -

#pragma mark - getters and setters          - Method -

- (NWTestApi *)testAPI
{
    if (!_testAPI) {
        _testAPI = [[NWTestApi alloc] init];
        _testAPI.callBackDelegate = self;
        _testAPI.paramSource = self;
    }
    return _testAPI;
}

- (NWTestApi1 *)testApi1
{
    if (!_testApi1) {
        _testApi1 = [[NWTestApi1 alloc] init];
        _testApi1.callBackDelegate = self;
        _testApi1.paramSource = self;
    }
    return _testApi1;
}

- (NWTestApi2 *)testApi2
{
    if (!_testApi2) {
        _testApi2 = [[NWTestApi2 alloc] init];
        _testApi2.callBackDelegate = self;
        _testApi2.paramSource = self;
    }
    return _testApi2;
}

@end
