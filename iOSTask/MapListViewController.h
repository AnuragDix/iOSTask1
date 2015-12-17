//
//  MapListViewController.h
//  iOSTask
//
//  Created by Anurag Dixit on 12/15/15.
//  Copyright (c) 2015 mobility2. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapListViewController : UIViewController
@property(strong, nonatomic)NSMutableArray *dataArray;
@property(strong, nonatomic)NSMutableDictionary *infoDict;
@property(strong, nonatomic)NSString *strTitleView;
- (void)reloadData;
@end
