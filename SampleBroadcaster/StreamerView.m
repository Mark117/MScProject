//
//  StreamerView.m
//  SampleBroadcaster
//
//  Created by Rich on 27/08/2014.
//  Copyright (c) 2014 videocore. All rights reserved.
//

#import "StreamerView.h"

@implementation StreamerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selected)];
        [self addGestureRecognizer:tapGestureRecognizer];
        UIImageView *iv = [[UIImageView alloc] initWithFrame:self.bounds];
        [iv setImage:[UIImage imageNamed:@"vidIcon"]];
        [self addSubview:iv];
    }
    return self;
}

-(void)selected{
    if(self.actionBlock){
        self.actionBlock();
    }
}


@end
