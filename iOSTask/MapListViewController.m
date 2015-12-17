//
//  MapListViewController.m
//  iOSTask
//
//  Created by Anurag Dixit on 12/15/15.
//  Copyright (c) 2015 mobility2. All rights reserved.
//

#import "MapListViewController.h"
#import "ListCell.h"
#import "Place.h"
#import "CellLogoDownloader.h"
#import "WebServiceInterface.h"
#import "MapDetailViewController.h"
#import "MMDrawerBarButtonItem.h"
#import "MMDrawerController.h"
#import "UIViewController+MMDrawerController.h"
#import <MapKit/MapKit.h>
#import "MapViewAnnotation.h"

@interface MapListViewController () <UIScrollViewDelegate>

// the set of IconDownloader objects for each app
@property (nonatomic, strong) NSMutableDictionary *imageDownloadsInProgress;
@property (weak, nonatomic) IBOutlet UITableView *tblView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControlListMap;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
- (IBAction)doClickSegmentControl:(id)sender;

@end
@implementation MapListViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    self.tblView.layer.cornerRadius = 5;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.barTintColor = DARK_RED_COLOR;
    self.view.backgroundColor = LIGHT_GREY_COLOR;
  
    [self setupLeftMenuButton];

    // Do any additional setup after loading the view, typically from a nib.
      _imageDownloadsInProgress = [NSMutableDictionary dictionary];
   
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

#pragma mark IBAction Methods
//this method is used for Map / list segment control
- (IBAction)doClickSegmentControl:(id)sender {
    UISegmentedControl *seg = (UISegmentedControl *)sender;
    self.mapView.hidden = YES;
    self.tblView.hidden = YES;
    if (seg.selectedSegmentIndex == 0) {
        self.tblView.hidden = NO;
    }else  if (seg.selectedSegmentIndex == 1) {
        self.mapView.hidden = NO;
        [self doLoadMapView];
    }
}

#pragma mark Map View Methods
//this method is used for preparing and adding annotation to mapview
-(void)doLoadMapView{
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = [[self.infoDict valueForKey:@"latitude"] doubleValue];
    zoomLocation.longitude= [[self.infoDict valueForKey:@"longitude"] doubleValue];
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
    [_mapView setRegion:viewRegion animated:YES];
    
    [self.mapView clearsContextBeforeDrawing];
     [self.mapView removeAnnotations:[self.mapView annotations]];
    [self.mapView addAnnotations:[self createAnnotations]];
}
//this method is used to create annotation and return array of annotations
- (NSMutableArray *)createAnnotations
{
    NSMutableArray *annotations = [[NSMutableArray alloc] init];
    
    for (Place *place in self.dataArray) {
         MapViewAnnotation *annotation = [[MapViewAnnotation alloc] initWithTitle:place.name subTitle:place.vicinity AndCoordinate:place.location];
        [annotations addObject:annotation];
    }
    return annotations;
}


#pragma marl - UITableView Data Source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 105;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(void)viewDidLayoutSubviews
{
    if ([self.tblView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tblView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tblView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tblView setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ListCell *cell = (ListCell *)[tableView dequeueReusableCellWithIdentifier:@"ListCell"];
    Place *pl = [self.dataArray objectAtIndex:indexPath.row];
    cell.imgLogo.layer.cornerRadius = 5;
    // Only load cached images; defer new downloads until scrolling ends
    if (!pl.imgLogo)
    {
        if (self.tblView.dragging == NO && self.tblView.decelerating == NO)
        {
            [self startIconDownload:pl forIndexPath:indexPath];
        }
        // if a download is deferred or in progress, return a placeholder image
       cell.imgLogo.image = [UIImage imageNamed:@"Placeholder.png"];
    }
    else
    {
        cell.imgLogo.image = pl.imgLogo;
    }

   cell.lblName.text = pl.name;
   
    return cell;
}
NSInteger selectedIndex;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    selectedIndex = indexPath.row;
    [self performSegueWithIdentifier:@"MapDetailSegue" sender:self];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



- (void)terminateAllDownloads
{
    // terminate all pending download connections
    NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
    
    [self.imageDownloadsInProgress removeAllObjects];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // terminate all pending download connections
    [self terminateAllDownloads];
}
#pragma mark - Table cell

//start Download
- (void)startIconDownload:(Place *)pl forIndexPath:(NSIndexPath *)indexPath
{
    CellLogoDownloader *iconDownloader = (self.imageDownloadsInProgress)[indexPath];
    if (iconDownloader == nil)
    {
        iconDownloader = [[CellLogoDownloader alloc] init];
        iconDownloader.place = pl;
        [iconDownloader setCompletionHandler:^{
            
            ListCell *cell = (ListCell *) [self.tblView cellForRowAtIndexPath:indexPath];
            
            cell.imgLogo.image = pl.imgLogo;
            [self.imageDownloadsInProgress removeObjectForKey:indexPath];
            
        }];
        (self.imageDownloadsInProgress)[indexPath] = iconDownloader;
        [iconDownloader startDownload];
    }
}

//  This method is used in case the user scrolled into a set of cells
- (void)loadImagesForOnscreenRows
{
    if (self.dataArray.count > 0)
    {
        NSArray *visiblePaths = [self.tblView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            Place *pl = (self.dataArray)[indexPath.row];
            if (!pl.imgLogo){
                [self startIconDownload:pl forIndexPath:indexPath];
            }
        }
    }
}


#pragma mark - UIScrollViewDelegate


//  Load images for all onscreen rows when scrolling is finished.
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        [self loadImagesForOnscreenRows];
    }
}

//  When scrolling stops, proceed to load the app icons that are on screen.
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
  MapDetailViewController* controller =  (MapDetailViewController *)[segue destinationViewController];
    controller.place = [self.dataArray objectAtIndex:selectedIndex];
   
}

//this method is used for reloaddata when you are coming from another viewcontroller
- (void)reloadData {
    self.mapView.hidden = YES;
    self.tblView.hidden = YES;
    if (self.segmentControlListMap.selectedSegmentIndex == 0) {
        self.tblView.hidden = NO;
    }else  if (self.segmentControlListMap.selectedSegmentIndex == 1) {
        self.mapView.hidden = NO;
        [self doLoadMapView];
    }
      self.title = self.strTitleView;
    [self.tblView reloadData];
}

-(void)setupLeftMenuButton{
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
}

-(void)setupRightMenuButton{
    MMDrawerBarButtonItem * rightDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(rightDrawerButtonPress:)];
    [self.navigationItem setRightBarButtonItem:rightDrawerButton animated:YES];
}


#pragma mark - Button Handlers
-(void)leftDrawerButtonPress:(id)sender{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

-(void)rightDrawerButtonPress:(id)sender{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
}

-(void)doubleTap:(UITapGestureRecognizer*)gesture{
    [self.mm_drawerController bouncePreviewForDrawerSide:MMDrawerSideLeft completion:nil];
}

-(void)twoFingerDoubleTap:(UITapGestureRecognizer*)gesture{
    [self.mm_drawerController bouncePreviewForDrawerSide:MMDrawerSideRight completion:nil];
}


@end
