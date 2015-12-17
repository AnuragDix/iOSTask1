//
//  WebServiceInterface.h
//  iOSTask
//
//  Created by Anurag Dixit on 12/15/15.
//  Copyright (c) 2015 mobility2. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "ViewController.h"
#import "AFURLSessionManager.h"
#import "Constant.h"
@interface WebServiceInterface : NSObject
{
    NSURLSessionDownloadTask *downloadTask;
    AFURLSessionManager *manager;
}

+(WebServiceInterface*)sharedWebServiceInterface;
-(void)getNearByPlaceList:(NSDictionary*)data completion:(void (^)(id responseObject, NSError *error))completion;
-(void)getPhotoByPlace:(NSDictionary*)data completion:(void (^)(id responseObject, NSError *error))completion;

@end

