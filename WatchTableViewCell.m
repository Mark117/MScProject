//
//  WatchTableViewCell.m
//  SampleBroadcaster
//
//  Created by Mark Horgan on 01/08/2014.
//  Copyright (c) 2014 videocore. All rights reserved.
//

#import "WatchTableViewCell.h"

@implementation WatchTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
