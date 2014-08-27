//
//  streamDetailsViewController.m
//  SampleBroadcaster
//
//  Created by Mark Horgan on 26/08/2014.
//  Copyright (c) 2014 videocore. All rights reserved.
//

#import "streamDetailsViewController.h"

@interface streamDetailsViewController ()

@end

@implementation streamDetailsViewController

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
    self.navigationItem.title = @"Stream Details";
    // Do any additional setup after loading the view.
    //labels set here
    _snameOut.text = _sname;
    _uuidOut.text = _uuid;
    _bitrateOut.text = _bitrate;
    _fpsOut.text = _fps;
    _urlOu.text = _urlString;
    _ratingOut.text = _rating;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [_snameOut release];
    [_uuidOut release];
    [_bitrateOut release];
    [_fpsOut release];
    [_urlOu release];
    [_ratingOut release];
    [super dealloc];
}
@end
