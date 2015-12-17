//
//  MapViewController.h
//  iOSTask
//
//  Created by Anurag Dixit on 12/17/15.
//  Copyright (c) 2015 mobility2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Place.h"

@interface MapViewController : UIViewController <CLLocationManagerDelegate>
@property(nonatomic,strong)Place *place;

@end
