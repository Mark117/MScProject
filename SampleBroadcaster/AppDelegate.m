//
//  AppDelegate.m
//  SampleBroadcaster
//
//  Created by James Hurley on 5/6/14.
//  Copyright (c) 2014 videocore. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    ////////DO DATABASE WORK -> drop from DB so user is no longer active
    
    NSUserDefaults *sURL = [NSUserDefaults standardUserDefaults];
    urlString = [sURL stringForKey:@"sURL"];
    
    NSString *regString = [NSString stringWithFormat:@"http://%@:8888/project/changeActive.php?uuid=%@", urlString, [UIDevice currentDevice].identifierForVendor.UUIDString];
    regString = [regString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:regString];
    NSLog(@"drop string is: %@", url);
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    NSData *urlData;
    NSURLResponse *response;
    urlData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:nil];
    //////END DB STREAM ACTIVITY CHANGE
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    ////////DO DATABASE WORK -> drop from DB so user is no longer active
    
    NSUserDefaults *sURL = [NSUserDefaults standardUserDefaults];
    urlString = [sURL stringForKey:@"sURL"];
    
    NSString *regString = [NSString stringWithFormat:@"http://%@:8888/project/changeActive.php?uuid=%@", urlString, [UIDevice currentDevice].identifierForVendor.UUIDString];
    regString = [regString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:regString];
    NSLog(@"drop string is: %@", url);
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    NSData *urlData;
    NSURLResponse *response;
    urlData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:nil];
    //////END DB STREAM ACTIVITY CHANGE
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    //update the DB, so the streamer's activity is set to false (i.e. streaming stopped)
    //update DB Set isActive ="false" where UUID == device.UUID
    
    ////////DO DATABASE WORK -> drop from DB so user is no longer active
    
    NSUserDefaults *sURL = [NSUserDefaults standardUserDefaults];
    urlString = [sURL stringForKey:@"sURL"];
    
    NSString *regString = [NSString stringWithFormat:@"http://%@:8888/project/changeActive.php?uuid=%@", urlString, [UIDevice currentDevice].identifierForVendor.UUIDString];
    regString = [regString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:regString];
    NSLog(@"drop string is: %@", url);
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    NSData *urlData;
    NSURLResponse *response;
    urlData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:nil];
    //////END DB STREAM ACTIVITY CHANGE
    
}

@end
