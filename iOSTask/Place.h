//
//  Place.h
//  iOSTask
//
//  Created by Anurag Dixit on 12/16/15.
//  Copyright (c) 2015 mobility2. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constant.h"

@interface Place : NSObject
@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *logoUrl;
@property(nonatomic,strong) UIImage *imgLogo;
@property(nonatomic,strong) NSString *photoReference;
@property(nonatomic,assign) CLLocationCoordinate2D location;
@property(nonatomic,strong) NSString *vicinity;

@property(nonatomic,strong) NSString *fromView;
@end
