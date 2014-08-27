//
//  SettingsViewController.h
//  SampleBroadcaster
//
//  Created by Mark Horgan on 14/08/2014.
//  Copyright (c) 2014 videocore. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController {
    NSString *urlString;
    NSMutableData *responseData;
    NSDictionary *dict;
    NSArray *jsonData;

}
@property (retain, nonatomic) IBOutlet UIButton *button;
@property (retain, nonatomic) IBOutlet UIImageView *thumbnail;
@property (retain, nonatomic) IBOutlet UITextField *streamName;
@property (retain, nonatomic) IBOutlet UISlider *bitSliderOut;
@property (retain, nonatomic) IBOutlet UISlider *fpsSliderOut;
@property (retain, nonatomic) IBOutlet UILabel *bitLabel;
@property (retain, nonatomic) IBOutlet UILabel *fpsLabel;

- (IBAction)bitSlider:(id)sender;
- (IBAction)fpsSlider:(id)sender;


@end
