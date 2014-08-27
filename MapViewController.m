//
//  MapViewController.m
//  SampleBroadcaster
//
//  Created by Rich on 14/08/2014.
//  Copyright (c) 2014 videocore. All rights reserved.
//

#import "MapViewController.h"
#import "SBJsonParser.h"


@interface CustomAnnotation : NSObject <MKAnnotation> {
    CLLocationCoordinate2D _coordinate;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate;

@end

@implementation CustomAnnotation
-(id)initWithCoordinate:(CLLocationCoordinate2D)coordinate{
    self = [super init];
    if(self){
        _coordinate = coordinate;
    }
    return self;
}
@end


@interface MapViewController (){
    UIView *distanceView;
    NSTimer *hideTimer;
}
@property (atomic, strong) CLLocation *mostRecentLocation;

@end

@implementation MapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES]; //it hides the nav bar

    [self.mapView setShowsUserLocation:YES];
    [self.mapView setDelegate:self];
    // Do any additional setup after loading the view.
    
    //    //Set up swipe to go to the settings view
    //    UISwipeGestureRecognizer *rightToLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self  action:@selector(swipeToMain:)];
    //    [rightToLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    //    [self.view addGestureRecognizer:rightToLeft];
    
}

//- (void)swipeToMain:(id)sender {
//    [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"streamVC"] animated:YES];
//}
-(void)viewDidAppear:(BOOL)animated{
    
    //[self setJSONList:@"{ \"streamers\": [ { \"sname\": \"Mark Horgan\", \"uuid\": \"B86C27FA-4F8F-47CD-A8D2-FAC0BF52B91B\", \"bitrate\": \"500000\", \"fps\": \"15\", \"url\": \"rtmp://192.168.1.41:1935/live1/myStream\", \"active\": \"1\", \"rating\": \"10\", \"coords\": \"51.8742509,-8.4033225\" }, { \"sname\": \"Mark Horgan\", \"uuid\": \"3438A8A4-3CBA-48BA-B08D-716DC7892F99\", \"bitrate\": \"500000\", \"fps\": \"15\", \"url\": \"rtmp://192.168.1.115:1935/live3/myStream\", \"active\": \"1\", \"rating\": \"0\", \"coords\": \"34.3192605,-94.2763113\" } ] }"];
    //get active streams from DB
    NSUserDefaults *sURL = [NSUserDefaults standardUserDefaults];
    urlString = [sURL stringForKey:@"sURL"];
    NSString *URLString = [NSString stringWithFormat:@"http://%@:8888/project/selectActive.php", urlString];
    NSURL *urlJSON = [[NSURL alloc] initWithString:URLString];
    NSData* data = [NSData dataWithContentsOfURL:urlJSON];
    
    NSString *JSONString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [self setJSONList:JSONString];
}

-(void) viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES]; //it hides the nav bar

    NSUserDefaults *sURL = [NSUserDefaults standardUserDefaults];
    urlString = [sURL stringForKey:@"sURL"];
    NSString *URLString = [NSString stringWithFormat:@"http://%@:8888/project/selectActive.php", urlString];
    NSURL *urlJSON = [[NSURL alloc] initWithString:URLString];
    NSData* data = [NSData dataWithContentsOfURL:urlJSON];
    
    NSString *JSONString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [self setJSONList:JSONString];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setJSONList:(NSString *)JSONList{
    NSLog(@"JSONList is: %@", JSONList);
    _JSONList = JSONList;
    NSError *error = nil;
    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
    NSDictionary *dict = [jsonParser objectWithString:JSONList error:&error];
    NSArray *streams = [dict objectForKey:kSteamersKey];
    if(self.mapView.annotations){
        [_mapView removeAnnotations:self.mapView.annotations];
    }
    for(NSDictionary *stream in streams){
        NSString *coordString = [stream objectForKey:kCoordsKey];
        NSArray *coords = [coordString componentsSeparatedByString:@","];
        NSLog(@"coords: %@", coords);
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([[coords objectAtIndex:0] doubleValue], [[coords objectAtIndex:1] doubleValue]);
        CustomAnnotation *anno = [[CustomAnnotation alloc] initWithCoordinate:coord];
        [_mapView addAnnotation:anno];
    }
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    [self setMostRecentLocation:[[CLLocation alloc] initWithLatitude:userLocation.coordinate.latitude longitude:userLocation.coordinate.longitude]];
}

-(void)centreUser:(id)sender{
    if(_mostRecentLocation){
        [self.mapView setRegion:MKCoordinateRegionMake(_mostRecentLocation.coordinate, MKCoordinateSpanMake(5.0, 5.0)) animated:YES];
    }
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if(![annotation isKindOfClass:MKUserLocation.class]){
        MKAnnotationView *annotationView = [MKAnnotationView new];
        annotationView.annotation = annotation;
        [annotationView setImage:[UIImage imageNamed:@"vidIcon"]];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(anntationTapped:)];
        [annotationView addGestureRecognizer:tapGesture];
        return annotationView;
    }
    return nil;
}


#pragma mark callback methods
-(void)anntationTapped:(UITapGestureRecognizer *)tap {
    NSLog(@"annt tapped");

    MKAnnotationView *view = (MKAnnotationView *)tap.view;
    if(self.mostRecentLocation){
        CLLocationCoordinate2D coordinate = ((CustomAnnotation *)view.annotation).coordinate;
        CLLocationDistance distance = [self.mostRecentLocation distanceFromLocation:[[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude ]];
        NSString *string = [NSString stringWithFormat:@"%.2f Meters", distance];
        [self displayLocationMessage:string];
    }
}

-(void)displayLocationMessage:(NSString *)text {
    if(distanceView){
        [self hideViewWithCompletion:^{
            [self displayLocationMessage:text];
        }];
    }else{
        distanceView = [[UIView alloc] initWithFrame:CGRectMake(10, -40, self.view.frame.size.width-20, 30)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-20, 30)];
        [label setFont:[UIFont fontWithName:@"Helvetica-Light" size:15.0f]];
        [label setNumberOfLines:0];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextColor:[UIColor whiteColor]];
        [label setText:text];
        [_distanceLabel setText:text];
        [label setTextAlignment:NSTextAlignmentCenter];
        [distanceView addSubview:label];
        [distanceView.layer setOpacity:.6];
        [distanceView setBackgroundColor:[UIColor blackColor]];
        [self.view addSubview:distanceView];
        [UIView animateWithDuration:.2 animations:^{
            [distanceView setFrame:CGRectMake(10, 10, self.view.frame.size.width-20, 30)];
        }];
        hideTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(hide) userInfo:nil repeats:NO];
    }
}

-(void)hide{
    //preventing crash from completion block being set with timer selector
    [self hideViewWithCompletion:^{
        
    }];
}

-(void)hideViewWithCompletion:(void (^)())completion{
    [hideTimer invalidate];
    [UIView animateWithDuration:.2 animations:^{
        [distanceView setFrame:CGRectMake(10, -40, self.view.frame.size.width-20, 30)];
    } completion:^(BOOL finished) {
        distanceView = nil;
        if(completion != nil){
            completion();
        }
    }];
}
- (void)dealloc {
    [_distanceLabel release];
    [super dealloc];
}
@end
