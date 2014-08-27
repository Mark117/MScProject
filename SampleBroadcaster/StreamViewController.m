//
//  StreamViewController.m
//  SampleBroadcaster
//
//  Created by Mark Horgan on 20/08/2014.
//  Copyright (c) 2014 videocore. All rights reserved.
//

#import "StreamViewController.h"

@interface StreamViewController ()

@end

@implementation StreamViewController

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
    // Do any additional setup after loading the view.
    NSLog(@"url STring is: %@", _urlString);
    self.mvpc = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:_urlString]];
    self.mvpc.shouldAutoplay = YES; //Optional
    self.mvpc.controlStyle = MPMovieControlStyleEmbedded;
    [self.mvpc prepareToPlay];
    [self.mvpc.view setFrame:self.view.bounds];
    [self.view addSubview:self.mvpc.view];
    [self.mvpc play];
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

}
*/

@end
