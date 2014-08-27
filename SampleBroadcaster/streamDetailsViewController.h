//
//  streamDetailsViewController.h
//  SampleBroadcaster
//
//  Created by Mark Horgan on 26/08/2014.
//  Copyright (c) 2014 videocore. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface streamDetailsViewController : UIViewController

@property (strong, nonatomic) NSString *sname;
@property (strong, nonatomic) NSString *uuid;
@property (strong, nonatomic) NSString *bitrate;
@property (strong, nonatomic) NSString *fps;
@property (strong, nonatomic) NSString *urlString;
@property (strong, nonatomic) NSString *rating;
@property (retain, nonatomic) IBOutlet UILabel *snameOut;
@property (retain, nonatomic) IBOutlet UILabel *uuidOut;
@property (retain, nonatomic) IBOutlet UILabel *bitrateOut;
@property (retain, nonatomic) IBOutlet UILabel *fpsOut;
@property (retain, nonatomic) IBOutlet UILabel *urlOu;
@property (retain, nonatomic) IBOutlet UILabel *ratingOut;

@end
