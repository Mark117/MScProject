//
//  VenueViewController.h
//  SampleBroadcaster
//
//  Created by Rich on 27/08/2014.
//  Copyright (c) 2014 videocore. All rights reserved.
//

#import <UIKit/UIKit.h>

static const int kRandNum = 10;

@interface VenueViewController : UIViewController<UIScrollViewDelegate>
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@end
