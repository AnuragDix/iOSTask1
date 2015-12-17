
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/**
 * Simple class to show a transparent view as a overlay for presenting another view on it. It also used to block the user's interaction behind the presented view, so that works as model view. 
 */
@interface BusyView : NSObject {
	UIView* view; // A UIView object to present obverlay
	
}



+ (BusyView*)defaultAgent;
- (void)addBusyView;
- (void)removeBusyView;
@end
