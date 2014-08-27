//
//  StreamerView.h
//  SampleBroadcaster
//
//  Created by Rich on 27/08/2014.
//  Copyright (c) 2014 videocore. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StreamerView : UIView
@property (nonatomic, strong) void (^actionBlock)(void);
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subTitle;

@end
