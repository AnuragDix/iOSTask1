//
//  UIManager.m
//  iOSTask
//
//  Created by Anurag Dixit on 12/17/15.
//  Copyright (c) 2015 mobility2. All rights reserved.
//


#import "UIManager.h"
#import "Reachability.h"
#import "Constant.h"
@implementation UIManager
//this method is used for checking for internet availability
+(BOOL)isOnline
{
    Reachability *r = [Reachability reachabilityWithHostName:@"www.google.com"];
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN)){
        [self showAlert:NETWORK_ERR];
        return NO;
    }else{
        return YES;
    }
    
}
//this method is used for showing alert view
+(void)showAlert:(NSString *)strMessage{
    [[[UIAlertView alloc] initWithTitle:@"iOS Task Error" message:strMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

@end
