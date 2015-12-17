//
//  CellLogoDownloader.m
//  iOSTask
//
//  Created by Anurag Dixit on 12/15/15.
//  Copyright (c) 2015 mobility2. All rights reserved.
//
#import "CellLogoDownloader.h"
#import "Place.h"
#import "Constant.h"

#define kAppIconSize 50


@interface CellLogoDownloader ()

@property (nonatomic, strong) NSURLSessionDataTask *sessionTask;

@end


#pragma mark -

@implementation CellLogoDownloader


//start Download
- (void)startDownload
{
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.place.logoUrl]];

    // create an session data task
    _sessionTask = [[NSURLSession sharedSession] dataTaskWithRequest:request
                                                   completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
       
                                                       
        [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
            
            // Set appIcon and clear temporary data/image
             UIImage *image = [[UIImage alloc] initWithData:data];
            
            if (image.size.width != kAppIconSize || image.size.height != kAppIconSize)
            {
                CGSize itemSize = CGSizeMake(kAppIconSize, kAppIconSize);
                UIGraphicsBeginImageContextWithOptions(itemSize, NO, 0.0f);
                CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
                [image drawInRect:imageRect];
                self.place.imgLogo = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
            }
            else
            {
                self.place.imgLogo = image;
            }
            
            if (self.completionHandler != nil)
            {
                self.completionHandler();
            }
        }];
    }];
    
    [self.sessionTask resume];
}

//Cancel Downlaod
- (void)cancelDownload
{
    [self.sessionTask cancel];
    _sessionTask = nil;
}

@end

