//
//  UserLocationManager.h
//  iOSTask
//
//  Created by Anurag Dixit on 12/15/15.
//  Copyright (c) 2015 mobility2. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

//Call back to fetching user location
typedef void (^UserLocationCallback) (CLLocation *userLocation, NSError *error);


@interface UserLocationManager : NSObject <CLLocationManagerDelegate>

//Start Location manager to fetch new location
- (void)startLocatingUserWithCompletion:(UserLocationCallback)completion;

//Stop location manager
- (void)stopLocatingUser;
+ (CLLocationCoordinate2D)coordinateFromProperties:(NSDictionary *)properties;
+ (NSString *)stringFromCoordinate:(CLLocationCoordinate2D)coordinate;
+(BOOL)isValidLocation:(CLLocationCoordinate2D)coordinate;

@end
