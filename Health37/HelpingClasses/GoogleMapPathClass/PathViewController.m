//
//  ViewController.m
//  MapTest
//
//  Created by Manish on 04/10/13.
//  Copyright (c) 2013 Self. All rights reserved.
//

#import "PathViewController.h"
#import <CoreLocation/CoreLocation.h>


@interface PathViewController ()

@end

@implementation PathViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //[self getDirections];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) centerMapForCoordinateArray:(CLLocationCoordinate2D *)routes andCount:(int)count{
	MKCoordinateRegion region;
    
	CLLocationDegrees maxLat = -90;
	CLLocationDegrees maxLon = -180;
	CLLocationDegrees minLat = 90;
	CLLocationDegrees minLon = 180;
	for(int idx = 0; idx <count; idx++)
	{
		CLLocationCoordinate2D currentLocation = routes[idx];
		if(currentLocation.latitude > maxLat)
			maxLat = currentLocation.latitude;
		if(currentLocation.latitude < minLat)
			minLat = currentLocation.latitude;
		if(currentLocation.longitude > maxLon)
			maxLon = currentLocation.longitude;
		if(currentLocation.longitude < minLon)
			minLon = currentLocation.longitude;
	}
    

	region.center.latitude     = (maxLat + minLat) / 2;
	region.center.longitude    = (maxLon + minLon) / 2;
	region.span.latitudeDelta  = maxLat - minLat;
	region.span.longitudeDelta = maxLon - minLon;
	
	[self.mapView setRegion:region animated:YES];
}

+ (MKPolyline *)polylineWithEncodedString:(NSString *)encodedString {
    const char *bytes = [encodedString UTF8String];
    NSUInteger length = [encodedString lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    NSUInteger idx = 0;
    
    NSUInteger count = length / 4;
    CLLocationCoordinate2D *coords = calloc(count, sizeof(CLLocationCoordinate2D));
    NSUInteger coordIdx = 0;
    
    float latitude = 0;
    float longitude = 0;
    while (idx < length) {
        char byte = 0;
        int res = 0;
        char shift = 0;
        
        do {
            byte = bytes[idx++] - 63;
            res |= (byte & 0x1F) << shift;
            shift += 5;
        } while (byte >= 0x20);
        
        float deltaLat = ((res & 1) ? ~(res >> 1) : (res >> 1));
        latitude += deltaLat;
        
        shift = 0;
        res = 0;
        
        do {
            byte = bytes[idx++] - 0x3F;
            res |= (byte & 0x1F) << shift;
            shift += 5;
        } while (byte >= 0x20);
        
        float deltaLon = ((res & 1) ? ~(res >> 1) : (res >> 1));
        longitude += deltaLon;
        
        float finalLat = latitude * 1E-5;
        float finalLon = longitude * 1E-5;
        
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(finalLat, finalLon);
        coords[coordIdx++] = coord;
        
        if (coordIdx == count) {
            NSUInteger newCount = count + 10;
            coords = realloc(coords, newCount * sizeof(CLLocationCoordinate2D));
            count = newCount;
        }
    }
    
    MKPolyline *polyline = [MKPolyline polylineWithCoordinates:coords count:coordIdx];
    free(coords);
    
    return polyline;
}

+(NSString *)getCountry:(CLLocationCoordinate2D )loc
{
  __block  NSString *strCountry = @"";
    
//    [[GMSGeocoder geocoder]reverseGeocodeCoordinate:loc completionHandler:^(GMSAddress *response, NSError *error) {
//        if (error) {
//            NSLog(@"%@",[error description]);
//        }
//        
//        strCountry=GMSAddress;
//        NSLog(@"%f",loc.latitude);
//        NSLog(@"%f",loc.longitude);
//
//    }];
    return strCountry;
}

+ (NSDictionary *)getDirectionsstartLoc:(CLLocationCoordinate2D)strtloc endLoc:(CLLocationCoordinate2D)endLoc
{
    //Cross country
    //37.705553,-122.372074 to 25.883937,-80.223026
    
    MKPolyline *polyLine;
    //Home to work
    //37.7577,-122.4376 to 37.764473,-122.399639
    NSDictionary *responseDict;
    CLLocation *newLocation = [[CLLocation alloc] initWithLatitude:strtloc.latitude longitude:strtloc.longitude];
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = CLLocationCoordinate2DMake(newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    annotation.title = @"You";
    //[self.mapView addAnnotation:annotation];

    CLLocation *keyPlace = [[CLLocation alloc] initWithLatitude:endLoc.latitude longitude:endLoc.longitude];
    MKPointAnnotation *endannotation = [[MKPointAnnotation alloc] init];
    endannotation.coordinate = CLLocationCoordinate2DMake(keyPlace.coordinate.latitude, keyPlace.coordinate.longitude);
    endannotation.title = @"End";
    
   // [self.mapView addAnnotation:endannotation];
    
    CLLocationCoordinate2D endCoordinate;
   // https://maps.googleapis.com/maps/api/directions/json?origin=0.0,75.7567467&destination=0.0,0.0&key=AIzaSyBELxwjVq9-sdoIkAUI-taRF1MM34NWPSU&sensor=false&mode=driving&alternatives=true

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/directions/json?origin=%f,%f&destination=%f,%f&sensor=false&mode=driving&alternatives=true", newLocation.coordinate.latitude, newLocation.coordinate.longitude, keyPlace.coordinate.latitude, keyPlace.coordinate.longitude]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *responseData =  [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if (!error) {
        
        responseDict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
        
        if ([[responseDict valueForKey:@"status"] isEqualToString:@"ZERO_RESULTS"]) {
            [[[UIAlertView alloc] initWithTitle:@"Error"
                                         message:@"Could not route path from your current location"
                                        delegate:nil
                               cancelButtonTitle:@"Close"
                               otherButtonTitles:nil, nil] show];
            return [[NSDictionary alloc]init];
            
        }
        int points_count = 0;
        if ([[responseDict objectForKey:@"routes"] count])
        {

            
            float distanceSelected = 0.0;
            int selectedRoute = 0;
            for (int i =0 ; i < [[responseDict objectForKey:@"routes"] count]; i++) {
                
                if (i == 0) {
                    
          distanceSelected  =   [[[[[[[responseDict objectForKey:@"routes"] objectAtIndex:0] objectForKey:@"legs"] objectAtIndex:0] objectForKey:@"distance"] objectForKey:@"value"] floatValue];
                }
                else
                {
                    if (distanceSelected >  [[[[[[[responseDict objectForKey:@"routes"] objectAtIndex:i] objectForKey:@"legs"] objectAtIndex:0] objectForKey:@"distance"] objectForKey:@"value"] floatValue]) {
                        selectedRoute = i ;
                        distanceSelected = [[[[[[[responseDict objectForKey:@"routes"] objectAtIndex:i] objectForKey:@"legs"] objectAtIndex:0] objectForKey:@"distance"] objectForKey:@"value"] floatValue];
                    }
                }
                
            }
            
            
            NSArray *arr = [NSArray arrayWithObject:[[responseDict objectForKey:@"routes"] objectAtIndex:selectedRoute]];
            
            NSDictionary *resultDict = [NSDictionary dictionaryWithObject:arr forKey:@"routes"];
            
         
        
            
          // AppDelegate * appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
//
            float distance  =   [[[[[[[resultDict objectForKey:@"routes"] objectAtIndex:0] objectForKey:@"legs"] objectAtIndex:0] objectForKey:@"distance"] objectForKey:@"value"] floatValue]/1000;
            
    
         if (distance < 1.0) {
             
        //     appDelegate.strDistance = [NSString stringWithFormat:@"1.0"];
             return resultDict;

         }
           else
           {
          //  appDelegate.strDistance = [NSString stringWithFormat:@"%.2f",distance];
               return resultDict;
           }

        }
        if (!points_count) {
            [[[UIAlertView alloc] initWithTitle:@"Error"
                                         message:@"Could not route path from your current location"
                                        delegate:nil
                               cancelButtonTitle:@"Close"
                               otherButtonTitles:nil, nil] show];
            return [[NSDictionary alloc]init];
        }
     //   CLLocationCoordinate2D points[points_count];
    //    NSLog(@"routes %@", [[[[responseDict objectForKey:@"routes"] objectAtIndex:0]objectForKey:@"overview_polyline"] objectForKey:@"points"]
//);
      
    }
    //MKPolyline *polyline = [PathViewController polylineWithEncodedString:[[[[responseDict objectForKey:@"routes"] objectAtIndex:0]objectForKey:@"overview_polyline"] objectForKey:@"points"]];
    
    return [[NSDictionary alloc]init];

}



#pragma mark - MapKit
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    MKPinAnnotationView *annView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"currentloc"];
    annView.canShowCallout = YES;
    annView.animatesDrop = YES;
    return annView;
}

- (MKOverlayView *)mapView:(MKMapView *)mapView
            viewForOverlay:(id<MKOverlay>)overlay {
    MKPolylineView *overlayView = [[MKPolylineView alloc] initWithOverlay:overlay];
    
    overlayView.lineWidth = 5;
    overlayView.strokeColor = [UIColor purpleColor];
    overlayView.fillColor = [[UIColor purpleColor] colorWithAlphaComponent:0.5f];
    return overlayView;
}
@end
