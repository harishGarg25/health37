//
//  ViewController.h
//  MapTest
//
//  Created by Manish on 04/10/13.
//  Copyright (c) 2013 Self. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface PathViewController : UIViewController
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
+ (NSDictionary *)getDirectionsstartLoc:(CLLocationCoordinate2D)strtloc endLoc:(CLLocationCoordinate2D)endLoc;

+(NSString *)getCountry:(CLLocationCoordinate2D )loc;

@end
