//
//  CellLogoDownloader.h
//  iOSTask
//
//  Created by Anurag Dixit on 12/15/15.
//  Copyright (c) 2015 mobility2. All rights reserved.
//
@class Place;
#import <Foundation/Foundation.h>

@interface CellLogoDownloader : NSObject

@property (nonatomic, strong) Place *place;
@property (nonatomic, copy) void (^completionHandler)(void);

- (void)startDownload;
- (void)cancelDownload;

@end
