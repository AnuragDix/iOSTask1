//
//  AsynImageDownloader.h
//  iOSTask
//
//  Created by Anurag Dixit on 12/17/15.
//  Copyright (c) 2015 mobility2. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constant.h"


@protocol AsynImageDownloaderDelegate

@optional
-(void)didImageDowloaded:(UIImage *)_image;
@end



@interface AsynImageDownloader : NSObject <NSURLSessionDownloadDelegate,NSURLSessionDelegate>{
   

}
@property(strong,nonatomic) NSString *strName;
@property (retain, nonatomic) id <AsynImageDownloaderDelegate> topDelegate;
-(void)downloadImage:(NSString *)imageUrl;
-(BOOL)isExistFile:(NSString *)imageUrl;
-(UIImage *)getImageFromName:(NSString *)imageUrl;

@end
