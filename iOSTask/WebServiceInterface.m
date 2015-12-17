//
//  WebServiceInterface.m
//  iOSTask
//
//  Created by Anurag Dixit on 12/15/15.
//  Copyright (c) 2015 mobility2. All rights reserved.
//

#import "WebServiceInterface.h"
#import "ClientManager.h"
#import "WebServiceConstants.h"

@implementation WebServiceInterface


+(WebServiceInterface*)sharedWebServiceInterface
{
    static dispatch_once_t pred = 0;
    __strong static id sharedObject = nil;
    dispatch_once(&pred, ^{
        
        sharedObject = [[self alloc] init];
    });
    return sharedObject;
}
-(void)getNearByPlaceList:(NSDictionary*)data completion:(void (^)(id responseObject, NSError *error))completion
{
    NSMutableDictionary *lHeaders = [[NSMutableDictionary alloc ]init];
    [lHeaders setObject:@"application/json" forKey:@"Content-Type"];
     [lHeaders setObject:@"application/json" forKey:@"Accept"];
        
    AFJSONResponseSerializer * lResp = [AFJSONResponseSerializer serializer];
    [[ClientManager sharedClient] setResponseSerializer:lResp];
    
    [[ClientManager sharedClient] sendHTTPGet:kBaseURL withParams:data completion:^(NSDictionary *results, NSError *error) {
        
        if ([results valueForKey:kResults] != nil && [[results valueForKey:kStatus]isEqualToString:@"OK"]&& [[results valueForKey:kResults] count] > 0 ) {
            
           completion(results,nil);
        }else{
            if(![[results valueForKey:kStatus] isEqualToString:@"OK"]){
                completion(results,nil);
                if ([results valueForKey:kErrorMessage]) {
                     [[[UIAlertView alloc] initWithTitle:@"iOS Task" message:[results valueForKey:kErrorMessage] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                }else{
                    [[[UIAlertView alloc] initWithTitle:@"iOS Task" message:[results valueForKey:kStatus] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                }
            }else{
                completion(results,error);
            }
           
        }
    }];
}

-(void)getPhotoByPlace:(NSDictionary*)data completion:(void (^)(id responseObject, NSError *error))completion{

    NSMutableDictionary *lHeaders = [[NSMutableDictionary alloc ]init];
    [lHeaders setObject:@"application/json" forKey:@"Content-Type"];

    [lHeaders setObject:@"application/json" forKey:@"Accept"];
    
    AFJSONResponseSerializer * lResp = [AFJSONResponseSerializer serializer];
    [[ClientManager sharedClient] setResponseSerializer:lResp];
    
    [[ClientManager sharedClient] sendHTTPGet:kMapBaseURL withParams:data completion:^(NSDictionary *results, NSError *error) {
        
        if ([results valueForKey:kResults] != nil && [[results valueForKey:kStatus]isEqualToString:@"OK"]&& [[results valueForKey:kResults] count] > 0 ) {
            
            completion(results,nil);
        }else{
            if(![[results valueForKey:kStatus] isEqualToString:@"OK"]){
                [[[UIAlertView alloc] initWithTitle:@"iOS Task" message:[results valueForKey:kErrorMessage] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                
                completion(results,nil);
            }else{
                completion(results,error);
            }
            
        }
    }];

}


@end