/*
 
 Video Core
 Copyright (c) 2014 James G. Hurley
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 
 */

#import "ViewController.h"
#import "VCSimpleSession.h"
#import <CoreLocation/CoreLocation.h>
#import "SBJsonParser.h"

@interface ViewController () <VCSessionDelegate> {
    CLLocationManager *locationManager;
}
@property (nonatomic, retain) VCSimpleSession* session;
@end

@implementation ViewController

-(void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES]; //it hides the nav bar
    [[self.navigationController viewControllers] indexOfObject:self];
    NSMutableArray *vcArray = [[NSMutableArray alloc] initWithArray:[self.navigationController viewControllers]];
    [vcArray insertObject:[self.storyboard instantiateViewControllerWithIdentifier:@"mapViewController"] atIndex:[[self.navigationController viewControllers] indexOfObject:self]];
    self.navigationController.viewControllers = vcArray;
    NSUserDefaults *sBit = [NSUserDefaults standardUserDefaults];
    bitUserDef = [sBit stringForKey:@"sBit"];
    
    NSUserDefaults *sFps = [NSUserDefaults standardUserDefaults];
    bitUserDef = [sFps stringForKey:@"sFps"];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

   // _session = [[VCSimpleSession alloc] initWithVideoSize:CGSizeMake(1280, 720) frameRate:bitUserDef.intValue bitrate:bitUserDef.intValue useInterfaceOrientation:NO];
    NSUserDefaults *sBits = [NSUserDefaults standardUserDefaults];
    bitUserDef = [sBits stringForKey:@"sBit"];
    
    NSUserDefaults *Fps = [NSUserDefaults standardUserDefaults];
    bitUserDef = [Fps stringForKey:@"sFps"];
    
    _session = [[VCSimpleSession alloc] initWithVideoSize:CGSizeMake(1280, 1300) frameRate:bitUserDef.intValue bitrate:bitUserDef.intValue];
    
    [self.previewView addSubview:_session.previewView];
    _session.previewView.frame = self.previewView.bounds;
    _session.delegate = self;
    
    //OLD PROJECT CODE:

    NSUserDefaults *sURL = [NSUserDefaults standardUserDefaults];
    [sURL setObject:@"192.168.1.115" forKey:@"sURL"];
    [sURL synchronize];
    
    NSUserDefaults *sBit = [NSUserDefaults standardUserDefaults];
    [sBit setObject:@"500000" forKey:@"sBit"];
    [sBit synchronize];
    
    NSUserDefaults *sFps = [NSUserDefaults standardUserDefaults];
    [sFps setObject:@"15" forKey:@"sFps"];
    [sFps synchronize];
    
    NSUserDefaults *sname = [NSUserDefaults standardUserDefaults];
    [sname setObject:@"Mark Horgan" forKey:@"sname"];
    [sname synchronize];
    deviceUUID = [UIDevice currentDevice].identifierForVendor.UUIDString;
    
    NSUserDefaults *sName = [NSUserDefaults standardUserDefaults];
    [sName setObject:deviceUUID forKey:@"sName"];
    [sName synchronize];

    //UNCOMMENT THIS FOR THE FINAL DEMO
//    if ([[sname stringForKey:@"sName"]isEqualToString:[NSString stringWithFormat:@"%@", deviceUUID]]) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Default name" message:@"Go to settings to change name" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
//        [alert show];
//    }
    locationManager = [[CLLocationManager alloc] init];
    locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    locationManager.desiredAccuracy = kCLLocationAccuracyBest; // 100 m
    [locationManager startUpdatingLocation];
    NSLog(@"lon: %f and Lat: %f", locationManager.location.coordinate.longitude, locationManager.location.coordinate.latitude);
    
    
    //set up the swipe to the map
    UISwipeGestureRecognizer *rightToLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeToMap:)];
    [rightToLeft setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:rightToLeft];
    
    //Set up swipe to go to the tableview
    UISwipeGestureRecognizer *leftToRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeToTable:)];
    [leftToRight setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:leftToRight];

}
- (void)swipeToMap:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)swipeToTable:(id)sender {
    [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"watch"] animated:YES];
}
- (NSString *)deviceLocation {
    return [NSString stringWithFormat:@"%f,%f", locationManager.location.coordinate.latitude, locationManager.location.coordinate.longitude];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];    // it shows the nav bar
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_btnConnect release];
    [_previewView release];
    [_session release];
    
    [_swapCamera release];
    [_swapFront release];
    [_swapBack release];
    [super dealloc];
}

- (IBAction)btnConnectTouch:(id)sender {
    NSUserDefaults *sURL = [NSUserDefaults standardUserDefaults];
    urlString = [sURL stringForKey:@"sURL"];
    
    NSUserDefaults *sName = [NSUserDefaults standardUserDefaults];
    nameString = [sName stringForKey:@"sName"];
    
    NSUserDefaults *sBit = [NSUserDefaults standardUserDefaults];
    bitString = [sBit stringForKey:@"sBit"];
    
    NSUserDefaults *sFps = [NSUserDefaults standardUserDefaults];
    fpsString = [sFps stringForKey:@"sFps"];
    


    switch(_session.rtmpSessionState) {
        case VCSessionStateNone:
        case VCSessionStatePreviewStarted:
        case VCSessionStateEnded:
        case VCSessionStateError: {
            [_btnConnect setImage:[UIImage imageNamed:@"recording.png"] forState:UIControlStateNormal];
            NSString *URLString = [NSString stringWithFormat:@"http://%@:8888/project/select.php", urlString];
            NSURL *urlJSON = [[NSURL alloc] initWithString:URLString];
            NSData* data = [NSData dataWithContentsOfURL:urlJSON];
            
            NSString *JSONString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
            NSError *error = nil;
            dict = [jsonParser objectWithString:JSONString error:&error];
            jsonData = [dict valueForKeyPath:@"streamers"];
            
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for(NSDictionary *data in jsonData){
                [array addObject:[data objectForKey:@"url"]];
            }
            NSString * result = [array componentsJoinedByString:@""];
            // NSLog(@"jsonData is: %@", array);
            
            //cycle through the urls in the DB, find the range of string live part. if range of string is live, use live 2, if live2 use live 3 etc
            NSRegularExpression *regex =[NSRegularExpression regularExpressionWithPattern:@"\\w\\w\\w\\w\\d" options:0 error:NULL];
            NSArray *arrayOfAllMatches = [regex matchesInString:result options:0 range:NSMakeRange(0, [result length])];
            
            NSMutableArray *arrayOfURLs = [[NSMutableArray alloc] init];
            
            for (NSTextCheckingResult *match in arrayOfAllMatches) {
                NSString* substringForMatch = [result substringWithRange:match.range];
                // NSLog(@"Extracted URL: %@",substringForMatch);
                
                [arrayOfURLs addObject:substringForMatch];
            }
            
            // return non-mutable version of the array
            //live array is the array of available streams
            NSMutableArray *liveArray = [[NSMutableArray alloc] init];
            [liveArray addObject:@"live1"];
            [liveArray addObject:@"live2"];
            [liveArray addObject:@"live3"];
            [liveArray addObject:@"live4"];
            [liveArray addObject:@"live5"];
            
            //the result of the below line of code is the streams available
            [liveArray removeObjectsInArray:[NSArray arrayWithArray:arrayOfURLs]];
            
            NSLog(@"STREAMS AVAILABLE FOR USE: %@", liveArray);
            
            ////////////END DATABASE WORK
            
            //select object at index 0 for the url of the stream and Connect to the stream
            NSString* rtmpUrl = [NSString stringWithFormat:@"rtmp://%@:1935/live2/myStream", urlString ];//, [liveArray objectAtIndex:0]];
            NSLog(@"CONNECTED TO: %@ on %@", rtmpUrl, [liveArray objectAtIndex:0]);
    
            
            [_session startRtmpSessionWithURL:@"rtmp://192.168.1.115/live2" andStreamKey:@"myStream"];
            
            ////////DO DATABASE WORK -> upload the sname, uuid, bitrate, fps, url, active, rating
            int active = 1;
            int rating = 0;
            NSUserDefaults *sname = [NSUserDefaults standardUserDefaults];
            strname = [sname stringForKey:@"sname"];
            
            //GET DEVICE COORDS
            NSString *coords = [self deviceLocation];
            NSLog(@"D location is: %@", [self deviceLocation]);
            
            //TAKE SCREEN SNAPCHOT FOR THUMBNAIL
            // [self screenshot]; OLD CODE with OLD METHOD. doesn't work
        
            UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, 1);
            
            [self.view drawViewHierarchyInRect:self.view.bounds afterScreenUpdates:YES];
            
            UIImage *copied = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            NSLog(@"image is: %@", copied);
            [_imageView setImage:copied];
            //converting image to data for DB upload
            NSData *imagedata = UIImageJPEGRepresentation(copied,1.0 /*compressionQuality*/);
           //NSData *imagedata = UIImagePNGRepresentation(copied);
            NSString *base64String = [imagedata base64EncodedStringWithOptions:0];
            //upload base64String to DB
            
           // NSLog(@"base64 is: %@", imagedata);
            //Read db and store string in decodedData
            NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:base64String options:0];
            
            //select image data from DB and covert to an image
            UIImage *image = [UIImage imageWithData:decodedData];
            NSLog(@"data image is: %lu", (unsigned long)base64String.length);
            [_imageView setImage:image];
            
            
            //add the coords here
            NSString *regString = [NSString stringWithFormat:@"http://%@:8888/project/register.php?sname=%@&uuid=%@&bitrate=%@&fps=%@&url=%@&active=%d&rating=%d&coords=%@", urlString, nameString, [UIDevice currentDevice].identifierForVendor.UUIDString, bitString,fpsString, rtmpUrl, active, rating, coords];
            regString = [regString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSLog(@"regString: %@", regString);
            
            NSURL *url = [NSURL URLWithString:regString];
            NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
            NSData *urlData;
            NSURLResponse *response;
            urlData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:nil];
            
//            NSString *post =[[NSString alloc] initWithFormat:@"sname=%@&uuid=%@&bitrate=%@&fps=%@&url=%@&active=%d&rating=%d&coords=%@&thumb=%@", nameString, [UIDevice currentDevice].identifierForVendor.UUIDString, bitString,fpsString,rtmpUrl, active, rating, coords, imagedata];
//            
//            NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"http://%@:8888/project/thumbReg.php?", urlString]];
//            
//            NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
//            
//            NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
//           // NSLog(@"postData: %@", postData);
//            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
//            [request setURL:url];
//            [request setHTTPMethod:@"POST"];
//            [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
//            [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//            [request setHTTPBody:postData];
//            
//            NSError *error2;
//            NSURLResponse *response2;
//            NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response2 error:&error2];
//            
//            NSString *data2=[[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
//            NSLog(@"TESTSSS: %@",data2);
            //////END DB REGISTRATION

            break;
        }default:
            [_session endRtmpSession];
            [_btnConnect setImage:[UIImage imageNamed:@"camera.png"] forState:UIControlStateNormal];
            NSLog(@"Stream ended");
            NSUserDefaults *sname = [NSUserDefaults standardUserDefaults];
            strname = [sname stringForKey:@"sname"];
            
            ////////DO DATABASE WORK -> drop from DB so user is no longer active
            NSString *regString = [NSString stringWithFormat:@"http://%@:8888/project/changeActive.php?uuid=%@", urlString, [UIDevice currentDevice].identifierForVendor.UUIDString];
            regString = [regString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL *url = [NSURL URLWithString:regString];
            // NSLog(@"drop string is: %@", url);
            NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
            NSData *urlData;
            NSURLResponse *response;
            urlData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:nil];
            //////END DB STREAM ACTIVITY CHANGE
            break;
    }
}

- (void) connectionStatusChanged:(VCSessionState) state
{
    switch(state) {
        case VCSessionStateStarting:
            [self.btnConnect setTitle:@"Connecting" forState:UIControlStateNormal];
            break;
        case VCSessionStateStarted:
            [self.btnConnect setTitle:@"Disconnect" forState:UIControlStateNormal];
            break;
        default:
            [self.btnConnect setTitle:@"Connect" forState:UIControlStateNormal];
            break;
    }
}

- (IBAction)swapToFront:(id)sender {
    [_swapBack setHidden:NO];
    [_swapFront setHidden:YES];
    [_session setCameraState:VCCameraStateBack];
    
}
- (IBAction)swapToBack:(id)sender {
    [_swapBack setHidden:YES];
    [_swapFront setHidden:NO];
    [_session setCameraState:VCCameraStateFront];
}
- (IBAction)btnToMap:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
