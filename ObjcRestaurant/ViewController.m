//
//  ViewController.m
//  ObjcRestaurant
//
//  Created by Taylor Lehman on 11/4/14.
//  Copyright (c) 2014 Taylor Lehman. All rights reserved.
//

#import "ViewController.h"
#import "PlacesIterator.h"
#import "PlaceDetailView.h"


static NSString *const googleKey = @"https://maps.googleapis.com/maps/api/place/nearbysearch/json?radius=150&types=restaurant&key=AIzaSyDHVIpiAU-ulb_R5fGkrtFIjwXEFlI9xA0";

@interface ViewController ()


@property (nonatomic) CLLocationManager *locManager;
@property (nonatomic) CLLocation *userLocation;


-(void)startSearchWithText:(NSString*)text;
-(void)extractJSONResults:(NSDictionary*)response;

@end



@implementation ViewController



-(NSMutableArray *)places {
    if (!_places) {
        _places = [[NSMutableArray alloc]init];
    }
    return _places;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.locManager = [[CLLocationManager alloc]init];
    self.locManager.delegate = self;
    self.concreteSearchBar.delegate = self;
    
    self.tableView.delegate = self;
    
    
    switch ([CLLocationManager authorizationStatus]) {
        case kCLAuthorizationStatusAuthorizedAlways:
            [self.locManager startUpdatingLocation];
            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            [self.locManager startUpdatingLocation];
            break;
        case kCLAuthorizationStatusNotDetermined:
            [self.locManager requestWhenInUseAuthorization];
            [self.locManager startUpdatingLocation];
            break;
        case kCLAuthorizationStatusDenied:
            [self.locManager requestAlwaysAuthorization];
            break;
        default:
            break;
    }
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier  isEqual: @"placeDetailSegue"]) {
        
        [segue.destinationViewController setPlaceDetail:[self.places objectAtIndex:[self.tableView indexPathForSelectedRow].row]];
    }
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Location Delegates
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    self.userLocation = [locations firstObject];
    NSLog(@"current location: %@",self.userLocation);
    
    [manager stopUpdatingLocation];
    
}



-(void)extractJSONResults:(NSDictionary *)response {
    
    for (NSString *place in response[@"results"]) {
        PlacesIterator *newItem = [[PlacesIterator alloc]init];
        newItem.name = [place valueForKey:@"name"];
        newItem.address = [place valueForKey:@"vicinity"];
        newItem.placeID = [[[place valueForKey:@"photos"]objectAtIndex:0] valueForKey:@"photo_reference"];
        NSLog(@"the photo reference is: %@",newItem);
        
//        NSNumber *longi = [place valueForKeyPath:@"geometry.location.lng"];
//        NSNumber *lat = [place valueForKeyPath:@"geometry.location.lat"];
        
        
        newItem.locations = [[CLLocation alloc]initWithLatitude:[[place valueForKeyPath:@"geometry.location.lat"] floatValue]
                                                      longitude:[[place valueForKeyPath:@"geometry.location.lng"] floatValue]];
        
        NSLog(@"new item location value: %@",newItem.locations);
        [self.places addObject:newItem];
        
        
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    
}

-(void)startSearchWithText:(NSString *)text {
    
    NSLog(@"search text: %@", text);
    
    if (self.userLocation != nil) {
        NSNumber *longi = [[NSNumber alloc]initWithDouble:self.userLocation.coordinate.longitude];
        NSNumber *lat = [[NSNumber alloc]initWithDouble:self.userLocation.coordinate.latitude];
        NSURLSession *session = [NSURLSession sharedSession];
        NSString *dy = [googleKey stringByAppendingFormat:@"&keyword=%@&location=%@,%@",text,[lat stringValue], [longi stringValue]];
        NSURL *url = [NSURL URLWithString:dy];
        
        NSURLSessionDataTask * task;
        task = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (!error) {
                NSLog(@"no errors. results");
                NSMutableDictionary *results = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                [self extractJSONResults:results];
            }
            
        }];
        [task resume];
        
    }
    
}

#pragma mark - SearchBar Delegates

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    
    if ([searchText isEqualToString:@""] && [[self places]count] > 0) {
        NSLog(@"yes it changed");
        [searchBar resignFirstResponder];
    }
    
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    if (self.userLocation != nil) {
        
        [self startSearchWithText:searchBar.text];
    }
    
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    
}



#pragma mark - Table View Delegates


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell) {
        
        cell.textLabel.text = [[self.places objectAtIndex:indexPath.row] name];
        
    }
    
    return cell;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.places.count;
}













@end
