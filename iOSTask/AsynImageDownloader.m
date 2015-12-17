//
//  AsynImageDownloader.m
//  iOSTask
//
//  Created by Anurag Dixit on 12/17/15.
//  Copyright (c) 2015 mobility2. All rights reserved.
//

#import "AsynImageDownloader.h"
#import "Constant.h"

@implementation AsynImageDownloader
@synthesize topDelegate;
-(void)downloadImage:(NSString *)imageUrl{
    
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig
                                                              delegate:self
                                                         delegateQueue:nil];
        NSURLSessionDownloadTask *getImageTask = [session downloadTaskWithURL:[NSURL URLWithString:imageUrl]];
        
        [getImageTask resume];
  
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location{
    // Create a NSFileManager instance
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    
    // Get the documents directory URL
    NSArray *documentURLs = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL *documentsDirectory = [documentURLs firstObject];
    
    // Get the file name and create a destination URL
    NSArray* words = [self.strName componentsSeparatedByCharactersInSet :[NSCharacterSet whitespaceAndNewlineCharacterSet]];
     NSString *sendingFileName =[words componentsJoinedByString:@""];

    NSURL *destinationUrl = [documentsDirectory URLByAppendingPathComponent:sendingFileName];
     NSLog(@"destinationUrl %@",destinationUrl);
    // Hold this file as an NSData and write it to the new location
    NSData *fileData = [NSData dataWithContentsOfURL:location];
    [fileData writeToURL:destinationUrl atomically:NO];
    
    
    [self.topDelegate didImageDowloaded:[UIImage imageWithData:fileData]];

}

-(void)URLSession:(NSURLSession *)session
     downloadTask:(NSURLSessionDownloadTask *)downloadTask
     didWriteData:(int64_t)bytesWritten
totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
   // NSLog(@"%f / %f", (double)totalBytesWritten,(double)totalBytesExpectedToWrite);
}

-(BOOL)isExistFile:(NSString *)imageUrl{
    NSArray* words = [self.strName componentsSeparatedByCharactersInSet :[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    imageUrl = [words componentsJoinedByString:@""];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:imageUrl];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSLog(@"file exists at the path %@",filePath);
        return YES;
    }else{
        NSLog(@"file doesnt exist");
        return NO;
    }
}
-(UIImage *)getImageFromName:(NSString *)imageUrl{
    NSArray* words = [self.strName componentsSeparatedByCharactersInSet :[NSCharacterSet whitespaceAndNewlineCharacterSet]];
   imageUrl = [words componentsJoinedByString:@""];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:imageUrl];
    //NSLog(@"path %@",getImagePath);

    UIImage *img = [UIImage imageWithContentsOfFile:getImagePath];
    return img;
    
}


@end
