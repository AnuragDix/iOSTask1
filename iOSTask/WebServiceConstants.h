//
//  WebServiceConstants.h
//  iOSTask
//
//  Created by Anurag Dixit on 12/15/15.
//  Copyright (c) 2015 mobility2. All rights reserved.
//

#ifndef WEB_SERVICE_CONSTANTS_H
#define WEB_SERVICE_CONSTANTS_H

#define NETWORK_ERR @"Network is not reachable, Please try again later"

static NSString * const kBaseURL = @"https://maps.googleapis.com/maps/api/place/nearbysearch/json";
static NSString * const kMapBaseURL = @"https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=";

//string constants for collection view keys
static NSString* const kResults = @"results";
static NSString* const kHTMLAttributions = @"html_attributions";
static NSString* const kStatus = @"status";
static NSString* const kErrorMessage = @"error_message";

static NSString* const kName = @"name";
static NSString* const kIcon = @"icon";
static NSString* const kGeometry = @"geometry";
static NSString* const kLocation = @"location";
static NSString* const kPhotos = @"photos";
static NSString* const kPhotosRef = @"photo_reference";
static NSString* const kVicinity = @"vicinity";
static NSString* const kLatitude = @"latitude";
static NSString* const kLongitude = @"longitude";


#endif
