//
//  ViewController.h
//  ObjcRestaurant
//
//  Created by Taylor Lehman on 11/4/14.
//  Copyright (c) 2014 Taylor Lehman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UITableViewController <CLLocationManagerDelegate, UITableViewDelegate, UISearchBarDelegate>


@property (strong,nonatomic) NSMutableArray *places;

@property (strong, nonatomic) IBOutlet UISearchBar *concreteSearchBar;
@end

