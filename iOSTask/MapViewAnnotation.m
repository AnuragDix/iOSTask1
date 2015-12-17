//
//  MapViewAnnotation.m
//  iOSTask
//
//  Created by Anurag Dixit on 12/17/15.
//  Copyright (c) 2015 mobility2. All rights reserved.
//

#import "MapViewAnnotation.h"

@implementation MapViewAnnotation

@synthesize coordinate=_coordinate;
@synthesize title=_title;
@synthesize subtitle=_subtitle;

-(id) initWithTitle:(NSString *)title subTitle:(NSString *)subtitle AndCoordinate:(CLLocationCoordinate2D)coordinate
{
    self =  [super init];
    _title = title;
    _subtitle = subtitle;
    _coordinate = coordinate;
    return self;
}

@end
