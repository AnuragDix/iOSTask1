//
//  CoreDataOperations.h
//  iOSTask
//
//  Created by Anurag Dixit on 12/17/15.
//  Copyright (c) 2015 mobility2. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constant.h"
@interface CoreDataOperations : NSObject

+(CoreDataOperations*)sharedCoreDataOperations;
-(void)doSavePlaceObject:(Place *)place;
-(NSMutableArray *)doFetchPlaceAllObjects;

@end
