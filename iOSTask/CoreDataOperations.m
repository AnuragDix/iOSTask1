//
//  CoreDataOperations.m
//  iOSTask
//
//  Created by Anurag Dixit on 12/17/15.
//  Copyright (c) 2015 mobility2. All rights reserved.
//

#import "CoreDataOperations.h"
#import "PlaceObject.h"
#import "AppDelegate.h"
#import "Place.h"

@implementation CoreDataOperations

+(CoreDataOperations*)sharedCoreDataOperations
{
    static dispatch_once_t pred = 0;
    __strong static id sharedObject = nil;
    dispatch_once(&pred, ^{
        
        sharedObject = [[self alloc] init];
    });
    return sharedObject;
}

//This method is used for saving the data in core data
-(void)doSavePlaceObject:(Place *)place{

    NSManagedObjectContext * context = [[AppDelegate sharedInstance] managedObjectContext];
    PlaceObject *newDevice = [NSEntityDescription insertNewObjectForEntityForName:@"PlaceObject" inManagedObjectContext:context];
    [newDevice setValue:place.name forKey:@"name"];
    [newDevice setValue:place.logoUrl forKey:@"logoUrl"];
    [newDevice setValue:UIImagePNGRepresentation(place.imgLogo) forKey:@"icon"];
    [newDevice setValue:place.photoReference forKey:@"photoReference"];
    [newDevice setValue:place.vicinity forKey:@"vicinity"];
    [newDevice setValue:[NSNumber numberWithDouble:place.location.latitude] forKey:@"latitude"];
    [newDevice setValue:[NSNumber numberWithDouble:place.location.longitude] forKey:@"longitude"];
    [newDevice setValue:UIImagePNGRepresentation(place.imgLogo) forKey:@"icon"];
    
    NSError *error = nil;
    // Save the object to persistent store
    if (![[AppDelegate sharedInstance].managedObjectContext save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }else {
        [[[UIAlertView alloc] initWithTitle:@"iOS Task" message:@"Data successfully saved" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }

}

//this method is used for fetching all the data for Placeobject Entity.
-(NSMutableArray *)doFetchPlaceAllObjects{
    NSManagedObjectContext *moc = [AppDelegate sharedInstance].managedObjectContext;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"PlaceObject"];
    
    NSError *error = nil;
    NSArray *results = [moc executeFetchRequest:request error:&error];
    
    if (!results) {
        NSLog(@"Error fetching Employee objects: %@\n%@", [error localizedDescription], [error userInfo]);
        abort();
    }
    NSMutableArray *arr = [NSMutableArray new];
    for (PlaceObject *div in results) {
        Place *place = [Place new];
        place.name =  div.name;
        place.logoUrl = div.logoUrl;
        place.vicinity = div.vicinity;
        place.photoReference = div.photoReference;
        place.imgLogo = [UIImage imageWithData:div.icon];
        place.location = CLLocationCoordinate2DMake(div.latitude.doubleValue, div.longitude.doubleValue);
        place.fromView = @"Fav";
        [arr addObject:place];
    }
    return arr;
}

@end
