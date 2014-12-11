//
//  PlacesIterator.h
//  ObjcRestaurant
//
//  Created by Taylor Lehman on 11/4/14.
//  Copyright (c) 2014 Taylor Lehman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface PlacesIterator : NSObject

@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *address;
@property (nonatomic,strong) CLLocation *locations;
@property (nonatomic,strong) NSString *placeID;
@property (nonatomic,strong) UIImage *placePhoto;


@end
