//
//  ClientManager.m
//  iOSTask
//
//  Created by Anurag Dixit on 12/15/15.
//  Copyright (c) 2015 mobility2. All rights reserved.
//

#import "ClientManager.h"

static NSString * const kBURL = @"https://maps.googleapis.com/maps/api/place/nearbysearch/json";

@implementation ClientManager
+ (ClientManager *)sharedClient {
    static ClientManager *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *baseURL = [NSURL URLWithString:kBURL];
        
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        NSURLCache *cache = [[NSURLCache alloc] initWithMemoryCapacity:10 * 1024 * 1024
                                                          diskCapacity:50 * 1024 * 1024
                                                              diskPath:nil];
        
        [config setURLCache:cache];
        
        _sharedClient = [[ClientManager alloc] initWithBaseURL:baseURL
                                         sessionConfiguration:config];
        _sharedClient.requestSerializer = [AFJSONRequestSerializer serializer];
        _sharedClient.responseSerializer = [AFJSONResponseSerializer serializer];
        [_sharedClient.requestSerializer setTimeoutInterval:45];
        
    });
    
    return _sharedClient;
}

//GET - JSON - REST
- (NSURLSessionDataTask *)sendHTTPGet:(NSString *)getFunctionName
                          withParams :(NSDictionary *)params
                           completion:( void (^)(id results, NSError *error))completion
{
    NSURLSessionDataTask *task = [self GET:getFunctionName
                                parameters:params
                                   success:^(NSURLSessionDataTask *task, id responseObject) {
                                       NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
                                       if (httpResponse.statusCode == 200) {
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               completion(responseObject, nil);
                                           });
                                       } else {
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               completion(nil, nil);
                                           });
                                           NSLog(@"Received: %@", responseObject);
                                           NSLog(@"Received HTTP %ld", (long)httpResponse.statusCode);
                                       }
                                       
                                   } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           completion(nil, error);
                                       });
                                   }];
    

    return task;
}


-(void) setTimeOutInterval:(NSTimeInterval) timeoutValue
{
    //timeout value interms of sec default is 60
    [self.requestSerializer setTimeoutInterval:timeoutValue];
}

-(void) setCustomHeader:(NSMutableDictionary*)headers
{
    if(headers!=nil && [headers count] !=0)
    {
        NSArray* keys = [headers allKeys];
        for( int i =0; i < [keys count]; i ++)
        {
            [self.requestSerializer setValue:[headers objectForKey:keys[i]] forHTTPHeaderField:keys[i]];
        }
    }
}
@end
