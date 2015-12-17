//
//  ViewController.m
//  iOSTask
//
//  Created by Anurag Dixit on 12/15/15.
//  Copyright (c) 2015 mobility2. All rights reserved.
//

#import "ViewController.h"
#import "UserLocationManager.h"
#import "WebServiceInterface.h"
#import "MapListViewController.h"
#import "Constant.h"
#import "WebServiceConstants.h"
#import "UIViewController+MMDrawerController.h"
#import "CoreDataOperations.h"
#import "UIManager.h"
#import "MBProgressHUD.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControlType;
@property (weak, nonatomic) IBOutlet UISlider *sliderRange;
@property (nonatomic, strong, readonly) UserLocationManager *userLocationManager;
@property (nonatomic, strong) CLLocation *myLocation;
@property (weak, nonatomic) IBOutlet UILabel *lblCurrentRange;
@property (nonatomic,retain) NSMutableString *strTypeName;
@property (nonatomic,retain) NSMutableArray *arrPlaceData;
@property (strong, nonatomic) NSMutableDictionary *dict;
@property (nonatomic,retain) NSArray *placeTypeArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)doGetRange:(id)sender;
- (IBAction)doSegmentValueChanged:(id)sender;
- (IBAction)doNavigate:(id)sender;
- (IBAction)doClickFavourits:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnFavourits;

@end

@implementation ViewController
@synthesize userLocationManager = _userLocationManager;
@synthesize strTypeName,arrPlaceData;

- (void)viewDidLoad {
    [super viewDidLoad];
    //Some UI cosmatic things to make coloring of View
    self.tableView.layer.cornerRadius = 5;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.barTintColor = DARK_RED_COLOR;
    self.view.backgroundColor = LIGHT_GREY_COLOR;
    self.title = @"Menu";
    
    //
    self.strTypeName = [NSMutableString new];
    self.strTypeName = [NSMutableString stringWithString:@"food"];
    // Do any additional setup after loading the view, typically from a nib.
    if (self.arrPlaceData == nil) {
        NSMutableArray *arr = [NSMutableArray new];
        self.arrPlaceData = arr;
    }
    self.placeTypeArray = [NSArray arrayWithObjects:@"Food",@"Gym",@"School",@"Hospital",@"Spa",@"Resturant", nil];
    //If location  is not valid then fetch location again
    if (!self.myLocation) {
        [self startLocatingUser];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    float value = [self.sliderRange value];
    self.lblCurrentRange.text = [NSString stringWithFormat:@"%.2f Meter",value];
}


#pragma mark - User Location Manager
- (UserLocationManager *)userLocationManager
{
    if (!_userLocationManager) {
        _userLocationManager = [[UserLocationManager alloc] init];
    }
    return _userLocationManager;
}


- (void)startLocatingUser
{
    // Show progress HUD while we find the user's location.
    MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    progressHUD.dimBackground = YES;
    progressHUD.labelText = @"Finding My Location";
    progressHUD.userInteractionEnabled = YES;
    // calling location manager to fetch current location
    [self.userLocationManager startLocatingUserWithCompletion:^(CLLocation *userLocation, NSError *error) {
        if (userLocation) {
            self.myLocation = userLocation;
        } else {
            NSLog(@"[UserLocationManager] - Error: %@", [error localizedDescription]);
        }
        [progressHUD hide:YES];
    }];
}

#pragma mark - IBAction Methods
//this method is used for fetching range from slider
- (IBAction)doGetRange:(id)sender {
    UISlider *slider = (UISlider *)sender;
    float value = [slider value];
    self.lblCurrentRange.text = [NSString stringWithFormat:@"%.2f Meter",value];
}
//this method is used for fetch for segment value
- (IBAction)doSegmentValueChanged:(id)sender {
    NSInteger idx = [self.segmentControlType selectedSegmentIndex];
    self.strTypeName = [NSMutableString stringWithString:[sender titleForSegmentAtIndex:idx]];
}

//when you click on Done this method will be called and make a request to google server
- (IBAction)doNavigate:(id)sender{
   
    
    self.dict = [NSMutableDictionary new];
    [self.dict setValue:[NSString stringWithFormat:@"%f,%f",self.myLocation.coordinate.latitude,self.myLocation.coordinate.longitude] forKey:@"location"];
    [self.dict setValue:[NSString stringWithFormat:@"%.2f",self.sliderRange.value] forKey:@"radius"];
    [self.dict setValue:[self.strTypeName lowercaseString] forKey:@"types"];
    [self.dict setValue:GOOGLE_API_KEY forKey:@"key"];
    [self.dict setValue:[NSString stringWithFormat:@"%f",self.myLocation.coordinate.latitude] forKey:@"latitude"];
    [self.dict setValue:[NSString stringWithFormat:@"%f",self.myLocation.coordinate.longitude] forKey:@"longitude"];
    if (![UserLocationManager isValidLocation:self.myLocation.coordinate]) {
        [[[UIAlertView alloc] initWithTitle:@"Invalid Location Error" message:@"Please check settings -> Privacy -> iOSTask" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        if (!self.myLocation) {
            [self startLocatingUser];
        }
    }
    
    if (![UIManager isOnline]) {
        return;
    }
    MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    progressHUD.dimBackground = YES;
    progressHUD.labelText = @"Finding Data";
    progressHUD.userInteractionEnabled = YES;
    [[WebServiceInterface sharedWebServiceInterface] getNearByPlaceList:self.dict completion:^(id resposeObject,NSError *error){
        NSLog(@"res %@",resposeObject);
        if (error == nil) {
            
            NSArray *arr = [resposeObject valueForKey:kResults];
            [self.arrPlaceData removeAllObjects];
            for (NSDictionary *dic in arr ) {
                Place *place = [[Place alloc] init];
                place.name =  [dic valueForKey:kName];
                place.logoUrl = [dic valueForKey:kIcon];
                place.vicinity = [dic valueForKey:kVicinity];
                if ([dic valueForKey:kPhotos] != nil) {
                    if ([dic valueForKeyPath:@"photos.photo_reference"] != nil) {
            
                        NSArray *arr = [dic valueForKey:kPhotos];
                        for (NSDictionary *d in arr) {
                           place.photoReference = [d valueForKey:kPhotosRef];
                        }
                        
                    }
                }
                if ([dic valueForKey:kGeometry] != nil) {
                    if ([dic valueForKeyPath:@"geometry.location"] != nil) {
                        place.location = [UserLocationManager coordinateFromProperties:[dic valueForKeyPath:@"geometry.location"]];
                    }
                }                
                [self.arrPlaceData addObject:place];
            }//sliding to center map list class
            if (self.mm_drawerController && self.mm_drawerController.centerViewController) {
                MapListViewController *vc = (MapListViewController *)[[((UINavigationController *)self.mm_drawerController.centerViewController) viewControllers] firstObject] ;
                vc.dataArray = self.arrPlaceData;
                [vc setDataArray: self.arrPlaceData];
                vc.infoDict = self.dict;
                vc.strTitleView = [NSString stringWithFormat:@"Near By %@",(NSString *)self.strTypeName];
                [vc reloadData];
                [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
            }
            
            
        }else{
            [[[UIAlertView alloc] initWithTitle:@"iOS Task Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
        
        [progressHUD hide:YES];
    }];
  
    

}
//this method is used for see all list of favourites
- (IBAction)doClickFavourits:(id)sender {
    [self.arrPlaceData removeAllObjects];
    self.arrPlaceData = [[CoreDataOperations sharedCoreDataOperations] doFetchPlaceAllObjects];
    if (self.mm_drawerController && self.mm_drawerController.centerViewController) {
        MapListViewController *vc = (MapListViewController *)[[((UINavigationController *)self.mm_drawerController.centerViewController) viewControllers] firstObject] ;
        vc.dataArray = self.arrPlaceData;
        [vc setDataArray: self.arrPlaceData];
        vc.infoDict = self.dict;
        vc.strTitleView = [NSString stringWithFormat:@"Near By %@",(NSString *)self.strTypeName];
        [vc reloadData];
        [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    }
    
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MapListViewController *vc;
    vc = segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"MapListSegue"]) {
      
        vc.dataArray = self.arrPlaceData;
        [vc setDataArray: self.arrPlaceData];
        vc.infoDict = self.dict;
        vc.strTitleView = [NSString stringWithFormat:@"Near By %@",(NSString *)self.strTypeName];
        [vc reloadData];
    }
}
#pragma mark UITableView Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.placeTypeArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlaceCell"];
    
    cell.textLabel.text = [self.placeTypeArray objectAtIndex:indexPath.row];
   
    
    if ([self.strTypeName isEqualToString:cell.textLabel.text]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    self.strTypeName = [self.placeTypeArray objectAtIndex:indexPath.row];
    [tableView reloadData];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
