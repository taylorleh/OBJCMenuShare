//
//  PlaceDetailView.m
//  ObjcRestaurant
//
//  Created by Taylor Lehman on 11/4/14.
//  Copyright (c) 2014 Taylor Lehman. All rights reserved.
//

#import "PlaceDetailView.h"

@interface PlaceDetailView ()
-(void)downloadPlacePhoto;
-(void)setupBackgroundMap;
@end



@implementation PlaceDetailView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.myMapView.delegate = self;
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    MKCoordinateSpan span = MKCoordinateSpanMake(0.02, 0.02);
    MKCoordinateRegion reg = MKCoordinateRegionMake(self.placeDetail.locations.coordinate, span);
    
    self.myMapView.region = reg;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self downloadPlacePhoto];
}

-(void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self setupBackgroundMap];
}

-(void)downloadPlacePhoto {
    if (self.placeDetail.placeID) {
        NSString *ul = [[NSString alloc]initWithFormat:@"https://maps.googleapis.com/maps/api/place/photo?key=AIzaSyDHVIpiAU-ulb_R5fGkrtFIjwXEFlI9xA0&maxwidth=150&photoreference=%@",self.placeDetail.placeID];
        NSURL *url = [[NSURL alloc]initWithString:ul];
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
        NSURLSessionDownloadTask *task = [session downloadTaskWithURL:url completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
            if (!error) {
                NSLog(@"no error from image donload");
                self.placeDetail.placePhoto = [[UIImage alloc]initWithData:[NSData dataWithContentsOfURL:location]];
            }
        }];
        [task resume];
        
    }
}

-(void)setupBackgroundMap {
    __weak UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *visualEffect = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
    visualEffect.frame = CGRectMake(0, 0, self.view.frame.size.width, 165.0);
    [self.myMapView addSubview:visualEffect];
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"memory warning message received");
}



@end
