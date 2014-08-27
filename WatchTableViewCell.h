//
//  WatchTableViewCell.h
//  SampleBroadcaster
//
//  Created by Mark Horgan on 01/08/2014.
//  Copyright (c) 2014 videocore. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WatchTableViewCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UIImageView *thumbnail;
@property (retain, nonatomic) IBOutlet UILabel *streamname;
@property (retain, nonatomic) IBOutlet UILabel *rating;
@property (retain, nonatomic) IBOutlet UIButton *upvote;
@property (retain, nonatomic) IBOutlet UIButton *downvote;
@end
