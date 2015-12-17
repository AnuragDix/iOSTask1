#import "BusyView.h"
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import "Constant.h"


static BusyView* agent;

@implementation BusyView

- (id)init{
    if( (self = [super init])){
        // change by RapidSoft
		view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_SIZE_WIDHT, DEVICE_SIZE_HEIGHT)]; //[keywindow frame]];
		view.backgroundColor = [UIColor clearColor];
        UIView *viewLoader=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 75, 75)];
        CGSize boundsSize = view.bounds.size;
        CGRect frameToCenter = viewLoader.frame;
        
        // center horizontally
        if (frameToCenter.size.width < boundsSize.width)
            frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
        else
            frameToCenter.origin.x = 0;
        
        // center vertically
        if (frameToCenter.size.height < boundsSize.height){
            frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
        }
        else
            frameToCenter.origin.y = 0;
        
        viewLoader.frame = frameToCenter;

        viewLoader.backgroundColor = [UIColor blackColor];
		viewLoader.alpha = 0.80;
		viewLoader.opaque = YES;
		viewLoader.layer.cornerRadius = 8;
        
        
        
        
        UIActivityIndicatorView *loader=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        CGRect frame=[loader frame];
        [loader setFrame:CGRectMake(18, 19, frame.size.width, frame.size.height)];
        [loader startAnimating];
        [loader hidesWhenStopped];
        [viewLoader addSubview:loader];
       
        loader=nil;
        [view addSubview:viewLoader];
      
        viewLoader=nil;
        
	}
	return self;

}


- (void)addBusyView{
    // NSLog(@"addBusyView");
    //UIWindow *window=[UIApplication sharedApplication].keyWindow;
    UINavigationController *window = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    [window.view addSubview:view];
}
- (void)removeBusyView{
   // NSLog(@"removeBusyView");
    [view removeFromSuperview];

}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return NO;
}

+ (BusyView*)defaultAgent{
	if(!agent){
		agent = [[BusyView alloc] init] ;
	}
	return agent;
}

@end
