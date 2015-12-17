//
//  MapDetailViewController.h
//  iOSTask
//
//  Created by Anurag Dixit on 12/16/15.
//  Copyright (c) 2015 mobility2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constant.h"
#import "AsynImageDownloader.h"
@interface MapDetailViewController : UIViewController <AsynImageDownloaderDelegate>

@property(nonatomic,strong)Place *place;

@end
