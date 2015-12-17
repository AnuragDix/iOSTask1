//
//  PlaceObject.h
//  iOSTask
//
//  Created by Anurag Dixit on 12/17/15.
//  Copyright (c) 2015 mobility2. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PlaceObject : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * logoUrl;
@property (nonatomic, retain) NSData * icon;
@property (nonatomic, retain) NSString * photoReference;
@property (nonatomic, retain) NSString * vicinity;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * latitude;

@end
