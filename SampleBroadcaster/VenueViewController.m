//
//  VenueViewController.m
//  SampleBroadcaster
//
//  Created by Rich on 27/08/2014.
//  Copyright (c) 2014 videocore. All rights reserved.
//

#import "VenueViewController.h"
#import "StreamerView.h"

@interface VenueViewController ()
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation VenueViewController{
    UILabel *titleLabel;
    UILabel *subtitle;
    UIView *popView;
}

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
    self.title = @"Venue";
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mapView"]];
    [self.scrollView addSubview:self.imageView];
    [self.scrollView setContentSize:self.imageView.frame.size];
    [self addPointsForStreamers];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addPointsForStreamers{
    float height = self.imageView.frame.size.height - 200;
    float width = self.imageView.frame.size.width - 200;
    
    for(int i = 0; i <= kRandNum; i ++) {
        float x = fmodf(rand(), width);
        float y = fmodf(rand(), height);
        StreamerView *v = [[StreamerView alloc] initWithFrame:CGRectMake(x, y, 40, 40)];
        v.title = @"Title";
        v.subTitle = @"Subtitle";
        [self.scrollView addSubview:v];
        [v setActionBlock:^{
            [self.scrollView setContentOffset:CGPointMake(v.frame.origin.x-(self.scrollView.frame.size.width/2), v.frame.origin.y-(self.scrollView.frame.size.height/2)) animated:YES];
            [self displayPopoverWithTitle:v.title andSubTitle:v.subTitle];
        }];
        
    }
}

-(void)displayPopoverWithTitle:(NSString *)title andSubTitle:(NSString *)subTitle{
    if(popView){
       [UIView animateWithDuration:.4 animations:^{
           [popView setAlpha:0.0];
       } completion:^(BOOL finished) {
           [popView removeFromSuperview];
           popView = nil;
           [self displayPopoverWithTitle:title andSubTitle:subTitle];
       }];
    }else{
        popView = [[UIView alloc] initWithFrame:CGRectMake((self.scrollView.frame.size.width/2)-100,(self.scrollView.frame.size.height/2)-100, 200, 100)];
        [popView setBackgroundColor:[UIColor darkGrayColor]];
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 180, 50)];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setTextColor:[UIColor whiteColor]];
        [titleLabel setText:title];
        subtitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, 180, 50)];
        [subtitle setText:subTitle];
        [subtitle setBackgroundColor:[UIColor clearColor]];
        [subtitle setTextColor:[UIColor whiteColor]];
        [popView addSubview:subtitle];
        [popView addSubview:titleLabel];
        [popView setAlpha:0.0];
        UIButton *pushButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
        [pushButton setFrame:CGRectMake(160, 30, 40, 40)];
        [pushButton addTarget:self action:@selector(pushViewController) forControlEvents:UIControlEventTouchDown];
        [popView addSubview:pushButton];
        [self.view addSubview:popView];
        [UIView animateWithDuration:.4 animations:^{
            [popView setAlpha:0.9];
        }];
    }
}

-(void)pushViewController{
    //PUT VIEW CONTROLLER CODE PUSHING HERE
}
@end
