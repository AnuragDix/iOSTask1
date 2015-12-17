//
//  Constant.h
//  iOSTask
//
//  Created by Anurag Dixit on 12/15/15.
//  Copyright (c) 2015 mobility2. All rights reserved.
//

#ifndef iOSTask_Constant_h
#define iOSTask_Constant_h

#import <CoreLocation/CoreLocation.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "AFNetworking.h"
#import "BusyView.h"
#import "WebServiceConstants.h"
#import "Place.h"

#define GOOGLE_API_KEY @"AIzaSyA_YxpUHN2TZ-rdSzHsyTpjeLGUXbNqywA"
#define LIGHT_GREY_COLOR [UIColor colorWithRed:238.0f/255.0f green:238.0f/255.0f blue:238.0f/255.0f alpha:1.0];
#define DARK_RED_COLOR [UIColor colorWithRed:206.0f/255.0f green:17.0f/255.0f blue:38.0f/255.0f alpha:1.0];

#define FONT_NAVIGATIONBAR @"Roboto-Bold"

#define METERS_PER_MILE 1609.344

#define DEVICE_SIZE_HEIGHT [[[[UIApplication sharedApplication] keyWindow] rootViewController].view convertRect:[[UIScreen mainScreen] bounds] fromView:nil].size.height
#define DEVICE_SIZE_WIDHT [[[[UIApplication sharedApplication] keyWindow] rootViewController].view convertRect:[[UIScreen mainScreen] bounds] fromView:nil].size.width

#endif
