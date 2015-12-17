//
//  MapViewController.m
//  iOSTask
//
//  Created by Anurag Dixit on 12/17/15.
//  Copyright (c) 2015 mobility2. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import "UserLocationManager.h"
#import "MapViewAnnotation.h"
#import "Constant.h"
#import "MBProgressHUD.h"

@interface MapViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong, readonly) UserLocationManager *userLocationManager;
@property (nonatomic, strong) CLLocation *myLocation;

@end


@implementation MapViewController
@synthesize userLocationManager = _userLocationManager;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = LIGHT_GREY_COLOR;
    self.title = @"Map";
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont fontWithName:FONT_NAVIGATIONBAR size:18.0]
       }forState:UIControlStateNormal];
    
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //code for viewing region and zoom
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = self.place.location.latitude;
    zoomLocation.longitude= self.place.location.longitude;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
    [_mapView setRegion:viewRegion animated:YES];
    
    //adding annotation to map view
    MapViewAnnotation *annotation = [[MapViewAnnotation alloc] initWithTitle:self.place.name subTitle:self.place.vicinity AndCoordinate:self.place.location];
    [self.mapView addAnnotation:annotation];
    
    //updating current location
    if (!self.myLocation) {
        [self startLocatingUser];
    }
}


#pragma mark Location manager
- (UserLocationManager *)userLocationManager
{
    if (!_userLocationManager) {
        _userLocationManager = [[UserLocationManager alloc] init];
    }
    return _userLocationManager;
}

- (void)startLocatingUser
{
    MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    progressHUD.dimBackground = YES;
    progressHUD.labelText = @"Finding My Location";
    progressHUD.userInteractionEnabled = YES;
    
    // calling location manager to fetch current location
    [self.userLocationManager startLocatingUserWithCompletion:^(CLLocation *userLocation, NSError *error) {
        if (userLocation) {
            self.myLocation = userLocation;
        } else {
            NSLog(@"[UserLocationManager] - Error: %@", [error localizedDescription]);
        }
        [progressHUD hide:YES];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
