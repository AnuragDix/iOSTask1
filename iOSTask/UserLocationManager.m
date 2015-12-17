
//
//  UserLocationManager.m
//  iOSTask
//
//  Created by Anurag Dixit on 12/15/15.
//  Copyright (c) 2015 mobility2. All rights reserved.
//

#import "UserLocationManager.h"
#import "BusyView.h"
@interface UserLocationManager ()

@property (nonatomic, strong, readonly) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *myLocation;
@property (nonatomic, copy) UserLocationCallback completionBlock;

@end

@implementation UserLocationManager

@synthesize locationManager = _locationManager;

#pragma mark - Location Services

- (CLLocationManager *)locationManager
{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];        
    }
    return _locationManager;
}

- (void)startLocatingUserWithCompletion:(UserLocationCallback)completion
{
    self.completionBlock = completion;
    
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        {
            [self.locationManager requestWhenInUseAuthorization];
        }
    }
    [self.locationManager startUpdatingLocation];
}

- (void)stopLocatingUser
{    
    [self.locationManager stopUpdatingLocation];
    self.locationManager.delegate = nil;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *newLocation = [locations lastObject];
    
    //Do not save location if it is old
    NSTimeInterval locationAge = fabs([newLocation.timestamp timeIntervalSinceNow]);
    if (locationAge > 15.0f) { return; }
    

    if (newLocation.horizontalAccuracy < 0)
    {
        return;
    }
    
    // Only save the new location if it is new than previous locations.
    if (nil == self.myLocation || self.myLocation.horizontalAccuracy > newLocation.horizontalAccuracy) {
        self.myLocation = newLocation;
        
        if (newLocation.horizontalAccuracy <= self.locationManager.desiredAccuracy) {
            [self stopLocatingUser];
            
            self.completionBlock(self.myLocation, nil);
            self.completionBlock = nil;
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
     //[[BusyView defaultAgent] removeBusyView];
    if ([error code] != kCLErrorLocationUnknown) {
        self.completionBlock(nil, error);
        self.completionBlock = nil;
    }
}


#pragma mark Utility methods for location manager
+ (CLLocationCoordinate2D)coordinateFromProperties:(NSDictionary *)properties
{
    if (!properties) { return kCLLocationCoordinate2DInvalid; }
    
    CLLocationDegrees latitude = [properties[@"lat"] doubleValue];
    CLLocationDegrees longitude = [properties[@"lng"] doubleValue];
    return CLLocationCoordinate2DMake(latitude, longitude);
}

+ (NSString *)stringFromCoordinate:(CLLocationCoordinate2D)coordinate
{
    // Returns nil on invalid coordinates.
    if (!CLLocationCoordinate2DIsValid(coordinate)) {
        return nil;
    }
    
    NSString *latitudeString = [@(coordinate.latitude) stringValue];
    NSString *longitudeString = [@(coordinate.longitude) stringValue];
    return [NSString stringWithFormat:@"%@,%@", latitudeString, longitudeString];
}

+(BOOL)isValidLocation:(CLLocationCoordinate2D)coordinate{
    if (!CLLocationCoordinate2DIsValid(coordinate)) {
        return NO;
    }else{
        return YES;
    }
}


@end
