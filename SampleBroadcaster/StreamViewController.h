//
//  StreamViewController.h
//  SampleBroadcaster
//
//  Created by Mark Horgan on 20/08/2014.
//  Copyright (c) 2014 videocore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface StreamViewController : UIViewController

@property (strong, nonatomic) NSString *urlString;
@property (strong, nonatomic) MPMoviePlayerController *mvpc;
@end
