//
//  UIManager.h
//  iOSTask
//
//  Created by Anurag Dixit on 12/17/15.
//  Copyright (c) 2015 mobility2. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface UIManager : NSObject

+(BOOL)isOnline;
+(void)showAlert:(NSString *)strMessage;

@end
