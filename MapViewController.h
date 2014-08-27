//
//  MapViewController.h
//  SampleBroadcaster
//
//  Created by Rich on 14/08/2014.
//  Copyright (c) 2014 videocore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

static const NSString *kSteamersKey = @"streamers";
static const NSString *kCoordsKey = @"coords";

/*
 {
 "streamers": [
 {
 "sname": "Mark Horgan",
 "uuid": "B86C27FA-4F8F-47CD-A8D2-FAC0BF52B91B",
 "bitrate": "500000",
 "fps": "15",
 "url": "rtmp://192.168.1.41:1935/live1/myStream",
 "active": "1",
 "rating": "10",
 "coords": "51.8742509,-8.4033225"
 },
 {
 "sname": "Mark Horgan",
 "uuid": "3438A8A4-3CBA-48BA-B08D-716DC7892F99",
 "bitrate": "500000",
 "fps": "15",
 "url": "rtmp://192.168.1.115:1935/live3/myStream",
 "active": "1",
 "rating": "0",
 "coords": "34.3192605,-94.2763113"
 }
 ]
 }
 
 */

@interface MapViewController : UIViewController <MKMapViewDelegate> {
    NSString *urlString;
    NSMutableData *responseData;
    NSDictionary *tempdict;
    NSArray *jsonData;
}
@property(nonatomic, strong) IBOutlet MKMapView *mapView;
@property(nonatomic, strong) NSString *JSONList;
@property (retain, nonatomic) IBOutlet UILabel *distanceLabel;

-(IBAction)centreUser:(id)sender;
@end