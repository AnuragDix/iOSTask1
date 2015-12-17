//
//  ClientManager.h
//  iOSTask
//
//  Created by Anurag Dixit on 12/15/15.
//  Copyright (c) 2015 mobility2. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import "Constant.h"
@interface ClientManager : AFHTTPSessionManager

+ (ClientManager *)sharedClient;

- (NSURLSessionDataTask *)sendHTTPGet:(NSString *)getFunctionName
                          withParams :(NSDictionary *)params
                           completion:( void (^)(id results, NSError *error))completion;
-(void) setTimeOutInterval:(NSTimeInterval) timeoutValue;
-(void) setCustomHeader:(NSMutableDictionary*)headers;

@end
