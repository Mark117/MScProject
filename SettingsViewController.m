//
//  SettingsViewController.m
//  SampleBroadcaster
//
//  Created by Mark Horgan on 14/08/2014.
//  Copyright (c) 2014 videocore. All rights reserved.
//

#import "SettingsViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import "AVFoundation/AVAsset.h"
#import "CoreMedia/CMTime.h"
#import <MediaPlayer/MediaPlayer.h>
#import "SBJsonParser.h"


@interface SettingsViewController ()

@end

@implementation SettingsViewController

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
    //    _bitSliderOut.minimumValue=5;
    //    _bitSliderOut.maximumValue=45;
        _bitSliderOut.value=500000;
    //    _bitSliderOut.continuous=YES;
    //
    //    _fpsSliderOut.minimumValue=5;
    //    _fpsSliderOut.maximumValue=45;
    //    _fpsSliderOut.value=30;
    //    _fpsSliderOut.continuous=YES;
    self.navigationItem.title = @"Stream Settings";

    NSUserDefaults *sbit = [NSUserDefaults standardUserDefaults];
    [sbit setObject:@"500000" forKey:@"sBit"];
    [sbit synchronize];
    _bitLabel.text = [sbit stringForKey:@"sBit"];
    
    NSUserDefaults *sfps = [NSUserDefaults standardUserDefaults];
    [sfps setObject:@"30" forKey:@"sFps"];
    [sfps synchronize];
    _fpsLabel.text = [sbit stringForKey:@"sFps"];
    
    // Do any additional setup after loading the view.
    [self generateImage];
  //  [_streamName sizeThatFits:CGSizeMake(_streamName.frame.size.width, _streamName.frame.size.height)];
    NSUserDefaults *currName = [NSUserDefaults standardUserDefaults];
    NSString *name = [currName stringForKey:@"sName"];
    _streamName.text = name;
    
    
    [self.streamName setReturnKeyType:UIReturnKeyDone];
    [self.streamName addTarget:self
                       action:@selector(textFieldFinished:)
             forControlEvents:UIControlEventEditingDidEndOnExit];
    
    
    [_bitSliderOut addTarget:self action:@selector(continuousBitSlide:) forControlEvents:UIControlEventValueChanged];
    [_bitSliderOut addTarget:self action:@selector(stoppedBitSlide:) forControlEvents:UIControlEventTouchUpInside];
    
    [_fpsSliderOut addTarget:self action:@selector(continuousFpsSlide:) forControlEvents:UIControlEventValueChanged];
    [_fpsSliderOut addTarget:self action:@selector(stoppedFpsSlide:) forControlEvents:UIControlEventTouchUpInside];
    
    
//    NSUserDefaults *sURL = [NSUserDefaults standardUserDefaults];
//    urlString = [sURL stringForKey:@"sURL"];
//    NSString *URLString = [NSString stringWithFormat:@"http://%@:8888/project/selectActive.php", urlString];
//    //NSLog(@"URL is: %@", URLString);
//    NSURL *urlJSON = [[NSURL alloc] initWithString:URLString];
//    NSData* data = [NSData dataWithContentsOfURL:urlJSON];
//    
//    NSString *JSONString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSError *error = nil;
//    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
//    dict = [jsonParser objectWithString:JSONString error:&error];
//    jsonData = [dict valueForKeyPath:@"streamers"];
//
//
//    NSString *str = @"data:image/png;base64,";
//    str = [str stringByAppendingString:[[jsonData objectAtIndex:1]objectForKey:@"thumb"]];
//    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:str]];
//    // NSData* decodedData = [NSData dataWithContentsOfURL:url];
//    // NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:[localDict objectForKey:@"thumb"] options:0];
//    NSLog(@"String is:%@", str);
//    UIImage *image = [UIImage imageWithData:imageData];
//    [_thumbnail setImage:image];
}
- (IBAction)textFieldFinished:(id)sender
{
    NSString *newName = _streamName.text;
    NSUserDefaults *sName = [NSUserDefaults standardUserDefaults];
    [sName setObject:newName forKey:@"sName"];
    [sName synchronize];
    [sender resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)generateImage
{
    ///test
    
    NSURL *url = [NSURL URLWithString:@"http://192.168.1.16:1935/live2/myStream/playlist.m3u8"];
    //    AVURLAsset *asset=[[AVURLAsset alloc] initWithURL:url options:nil];
    //    AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    //    generator.appliesPreferredTrackTransform=TRUE;
    //    [asset release];
    //    CMTime thumbTime = CMTimeMakeWithSeconds(0,30);
    //
    //    AVAssetImageGeneratorCompletionHandler handler = ^(CMTime requestedTime, CGImageRef im, CMTime actualTime, AVAssetImageGeneratorResult result, NSError *error){
    //        if (result != AVAssetImageGeneratorSucceeded) {
    //            NSLog(@"couldn't generate thumbnail, error:%@", error);
    //        }
    //        [_button setImage:[UIImage imageWithCGImage:im] forState:UIControlStateNormal];
    //       // _thumbnail=[[UIImage imageWithCGImage:im] retain];
    //        [generator release];
    //    };
    //
    //    CGSize maxSize = CGSizeMake(320, 180);
    //    generator.maximumSize = maxSize;
    //    [generator generateCGImagesAsynchronouslyForTimes:[NSArray arrayWithObject:[NSValue valueWithCMTime:thumbTime]] completionHandler:handler];
    AVAsset *asset = [AVAsset assetWithURL:url];
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc]initWithAsset:asset];
    CMTime time = [asset duration];
    time.value = 0;
    CGImageRef imageRef = [imageGenerator copyCGImageAtTime:time actualTime:NULL error:NULL];
    UIImage *thumbnail = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);  // CGImageRef won't be released by ARC
    [_button setImage:thumbnail forState:UIControlStateNormal];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)dealloc {
    [_button release];
    [_thumbnail release];
    [_streamName release];
    [_bitSliderOut release];
    [_fpsSliderOut release];
    [_bitLabel release];
    [_fpsLabel release];
    [super dealloc];
}
- (IBAction)bitSlider:(id)sender {
    int amount = (int)(_bitSliderOut.value);
    [_bitLabel setText:[NSString stringWithFormat:@"%d",amount]];
//    int rounded = _bitSliderOut.value;
//    [sender setValue:rounded animated:NO];
    
}

- (IBAction)fpsSlider:(id)sender {
    [_fpsLabel setText:[NSString stringWithFormat:@"%.0f",roundf(_fpsSliderOut.value) ]];
}

-(IBAction)continuousBitSlide:(id)sender{
    int amount = (int)(_bitSliderOut.value);
    [_bitLabel setText:[NSString stringWithFormat:@"%d",amount]];

}
-(IBAction)stoppedBitSlide:(id)sender{
    NSLog(@"Update User Defaults");
    int amount = (int)(_bitSliderOut.value);
    NSString *bit = [NSString stringWithFormat:@"%d",amount];
    NSUserDefaults *sbit = [NSUserDefaults standardUserDefaults];
    [sbit setObject:bit forKey:@"sBit"];
    [sbit synchronize];
}
-(IBAction)continuousFpsSlide:(id)sender{
        [_fpsLabel setText:[NSString stringWithFormat:@"%.0f",roundf(_fpsSliderOut.value) ]];
}
-(IBAction)stoppedFpsSlide:(id)sender{
    NSLog(@"Update User Defaults");
    int amount = (int)(_fpsSliderOut.value);
    NSString *bit = [NSString stringWithFormat:@"%d",amount];
    NSUserDefaults *sfps = [NSUserDefaults standardUserDefaults];
    [sfps setObject:bit forKey:@"sFps"];
    [sfps synchronize];
}
@end
