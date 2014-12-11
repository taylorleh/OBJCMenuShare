//
//  PlaceDetailView.h
//  ObjcRestaurant
//
//  Created by Taylor Lehman on 11/4/14.
//  Copyright (c) 2014 Taylor Lehman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "PlacesIterator.h"

@interface PlaceDetailView : UITableViewController <UITableViewDelegate,MKMapViewDelegate>

@property (strong, nonatomic) PlacesIterator *placeDetail;
@property (strong, nonatomic) IBOutlet MKMapView *myMapView;
@property (strong, nonatomic) IBOutlet UIImageView *placeImage;
@property (strong, nonatomic) IBOutlet UILabel *primaryPlaceLabel;

@end
