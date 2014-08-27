//
//  MainTableViewController.m
//  SampleBroadcaster
//
//  Created by Mark Horgan on 29/07/2014.
//  Copyright (c) 2014 videocore. All rights reserved.
//

#import "MainTableViewController.h"
#import "SBJsonParser.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import "AVFoundation/AVAsset.h"
#import "CoreMedia/CMTime.h"
#import "StreamViewController.h"
#import "streamDetailsViewController.h"

@interface MainTableViewController ()

@end

@implementation MainTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void) viewWillAppear{
    //get active streams from DB
    NSUserDefaults *sURL = [NSUserDefaults standardUserDefaults];
    urlString = [sURL stringForKey:@"sURL"];
    NSString *URLString = [NSString stringWithFormat:@"http://%@:8888/project/selectActive.php", urlString];
    //NSLog(@"URL is: %@", URLString);
    NSURL *urlJSON = [[NSURL alloc] initWithString:URLString];
    NSData* data = [NSData dataWithContentsOfURL:urlJSON];
    
    NSString *JSONString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSError *error = nil;
    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
    dict = [jsonParser objectWithString:JSONString error:&error];
    jsonData = [dict valueForKeyPath:@"streamers"];
   // NSLog(@"JSON DATA IS: %@", jsonData);
    [self.tb reloadData];
    //streams have been returned
    
    [self fetchedData];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO];

    //get active streams from DB
    NSUserDefaults *sURL = [NSUserDefaults standardUserDefaults];
    urlString = [sURL stringForKey:@"sURL"];
    NSString *URLString = [NSString stringWithFormat:@"http://%@:8888/project/selectActive.php", urlString];
    //NSLog(@"URL is: %@", URLString);
    NSURL *urlJSON = [[NSURL alloc] initWithString:URLString];
    NSLog(@"data is: %@", urlJSON);

    NSData* data = [NSData dataWithContentsOfURL:urlJSON];
    NSString *JSONString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSError *error = nil;
    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
    dict = [jsonParser objectWithString:JSONString error:&error];
    jsonData = [dict valueForKeyPath:@"streamers"];
   // NSLog(@"Loading tableview with data %@", jsonData);

    //NSLog(@"JSON DATA IS: %@", jsonData);
    [self.tb reloadData];
    //streams have been returned
}


-(void)fetchedData {
    //get active streams from DB
    NSUserDefaults *sURL = [NSUserDefaults standardUserDefaults];
    urlString = [sURL stringForKey:@"sURL"];
    NSString *URLString = [NSString stringWithFormat:@"http://%@:8888/project/selectActive.php", urlString];
   // NSLog(@"URL is: %@", URLString);
    NSURL *urlJSON = [[NSURL alloc] initWithString:URLString];
    NSData* data = [NSData dataWithContentsOfURL:urlJSON];
    
    NSString *JSONString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSError *error = nil;
    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
    dict = [jsonParser objectWithString:JSONString error:&error];
    jsonData = [dict valueForKeyPath:@"streamers"];
  //  NSLog(@"JSON DATA IS: %@", jsonData);
    [self.tb reloadData];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [jsonData count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier" forIndexPath:indexPath];
    
    // Configure the cell...
    NSDictionary *localDict=  [jsonData objectAtIndex:indexPath.row];
    
    //cell.textLabel.text = person.name;
    //cell.imageView.image = [UIImage imageNamed:person.image];
    
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:101];
    nameLabel.text = [localDict objectForKey:@"sname"];
    
    UILabel *ratingLabel = (UILabel *)[cell viewWithTag:105];
    //get rating for stream named person.name from DB
    ratingLabel.text = [localDict objectForKey:@"rating"];
    
    UIImageView *ratingImageView = (UIImageView *)[cell viewWithTag:102];
    //connect to stream, download frame every 10 seconds, add as user pref?
    
  //  NSURL *url = [NSURL URLWithString:[localDict objectForKey:@"thumb"]];
//    NSString *str = @"data:image/png;base64,";
//    str = [str stringByAppendingString:[localDict objectForKey:@"thumb"]];
//    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:str]];
//   // NSData* decodedData = [NSData dataWithContentsOfURL:url];
//   // NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:[localDict objectForKey:@"thumb"] options:0];
//    UIImage *image = [UIImage imageWithData:imageData];
//    //NSString *sURL = [NSString stringWithFormat:@"%@", str];
//    NSLog(@"data image is: %@", str);
//   // [_imageView setImage:image];
    ratingImageView.image = [UIImage imageNamed:@"vidIcon.png"];
    
    UIButton *upvote = (UIButton *)[cell viewWithTag:103];
    [upvote setTitle:[NSString stringWithFormat:@"%@",[localDict objectForKey:@"uuid"]] forState:UIControlStateDisabled];
    [upvote addTarget:self action:@selector(upvoteButtonClicked:)forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *downvote = (UIButton *)[cell viewWithTag:104];
    [downvote setTitle:[NSString stringWithFormat:@"%@",[localDict objectForKey:@"uuid"]] forState:UIControlStateDisabled];
    [downvote addTarget:self action:@selector(downvoteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *morebtn = (UIButton *)[cell viewWithTag:106];
    [morebtn addTarget:self action:@selector(moreButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    //[self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"streamView"] animated:YES];

    NSLog(@"more button");
}
//-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"Accessory tapped on index: %ld", (long)indexPath.row);
//    NSUserDefaults *sURL = [NSUserDefaults standardUserDefaults];
//    urlString = [sURL stringForKey:@"sURL"];
//    NSString *URLString = [NSString stringWithFormat:@"http://%@:8888/project/selectActive.php", urlString];
//    // NSLog(@"URL is: %@", URLString);
//    NSURL *urlJSON = [[NSURL alloc] initWithString:URLString];
//    NSData* data = [NSData dataWithContentsOfURL:urlJSON];
//    
//    NSString *JSONString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSError *error = nil;
//    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
//    dict = [jsonParser objectWithString:JSONString error:&error];
//    jsonData = [dict valueForKeyPath:@"streamers"];
//    
//    StreamViewController *svc = (StreamViewController *)[segue destinationViewController];
//    
//    NSString *str = [[jsonData objectAtIndex:indexPath.row]objectForKey:@"url"];
//    NSRegularExpression *regex =[NSRegularExpression regularExpressionWithPattern:@"\\w\\w\\w\\w\\d" options:0 error:NULL];
//    // NSArray *arrayOfAllMatches = [regex matchesInString:[[jsonData objectAtIndex:indexPath.row]objectForKey:@"url"] options:0 range:NSMakeRange(0, [[[jsonData objectAtIndex:indexPath.row]objectForKey:@"url"] length])];
//    NSTextCheckingResult *match = [regex firstMatchInString:str options:0 range:NSMakeRange(0, [str length])];
//    
//    NSString *playlistString = [NSString stringWithFormat:@"http://%@:1935/%@/myStream/playlist.m3u8", urlString, [str substringWithRange:[match rangeAtIndex:0]]];
//    svc.urlString = playlistString;
//    
//    NSLog(@"Cell clicked: %@", playlistString);
//
//}

-(IBAction)upvoteButtonClicked:(id)sender {
    /*
     Connect to DB, upload the user's preference, along with their device ID, so they can't
     spam votes. Also increment the rating value by 1
     */
    UIButton* b = (UIButton*) sender;
    //Below line will got indexpath in string format
    NSString *suuid = [b titleForState:UIControlStateDisabled];
    NSString *muuid = [UIDevice currentDevice].identifierForVendor.UUIDString;
    
    NSString *URLString = [NSString stringWithFormat:@"http://%@:8888/project/voteTypeSelect.php?muuid=%@&suuid=%@", urlString, muuid, suuid];
    NSURL *urlJSON = [[NSURL alloc] initWithString:URLString];
    NSData* data = [NSData dataWithContentsOfURL:urlJSON];
    
    NSString *JSONString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSError *error = nil;
    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
    voteDict = [jsonParser objectWithString:JSONString error:&error];
    jsonVoteData = [voteDict valueForKeyPath:@"voter"];
    
    if (jsonVoteData  == nil || [jsonVoteData count] ==0) {
        NSLog(@"NO vote present - upvote stream");
        NSString *regString = [NSString stringWithFormat:@"http://%@:8888/project/voteType.php?muuid=%@&suuid=%@&vote=upvote", urlString, muuid, suuid];
        regString = [regString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSURL *url = [NSURL URLWithString:regString];
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
        NSData *urlData;
        NSURLResponse *response;
        urlData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:nil];
        
        //rating +1
        //connect to vote.php with suuid and increment the rating by the amount and vote (incr or decr)
        NSString *ratingString = [NSString stringWithFormat:@"http://%@:8888/project/vote.php?suuid=%@&amount=1&vote=upvote",urlString, suuid];
        ratingString = [ratingString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSURL *rurl = [NSURL URLWithString:ratingString];
        NSURLRequest *rurlRequest = [NSURLRequest requestWithURL:rurl];
        NSData *rurlData;
        NSURLResponse *rresponse;
        rurlData = [NSURLConnection sendSynchronousRequest:rurlRequest returningResponse:&rresponse error:nil];
        
    } else{
        NSLog(@"Vote present, perform change if necessary");
        NSString *mDBuuid = [[jsonVoteData objectAtIndex:0]objectForKey:@"muuid"];
        NSString *mDBvote = [[jsonVoteData objectAtIndex:0]objectForKey:@"vote"];
        
        if ([mDBuuid length] != 0 && [mDBvote isEqualToString:@"none"]) {
            NSLog(@"ALLOW UPVOTE - string is none");
            NSString *regString = [NSString stringWithFormat:@"http://%@:8888/project/voteUpdate.php?muuid=%@&suuid=%@&vote=upvote", urlString, muuid, suuid];
            regString = [regString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            NSURL *url = [NSURL URLWithString:regString];
            NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
            NSData *urlData;
            NSURLResponse *response;
            urlData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:nil];
            
            //rating +1
            //connect to vote.php with suuid and increment the rating by the amount and vote (incr or decr)
            NSString *ratingString = [NSString stringWithFormat:@"http://%@:8888/project/vote.php?suuid=%@&amount=1&vote=upvote",urlString, suuid];
            ratingString = [ratingString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSLog(@"rating URLS is :%@", ratingString);
            NSURL *rurl = [NSURL URLWithString:ratingString];
            NSURLRequest *rurlRequest = [NSURLRequest requestWithURL:rurl];
            NSData *rurlData;
            NSURLResponse *rresponse;
            rurlData = [NSURLConnection sendSynchronousRequest:rurlRequest returningResponse:&rresponse error:nil];

        } else if ([mDBuuid length] != 0 && [mDBvote isEqualToString:@"downvote"]) {
            NSLog(@"ALLOW UPVOTE - string is downvote");
            NSString *regString = [NSString stringWithFormat:@"http://%@:8888/project/voteUpdate.php?muuid=%@&suuid=%@&vote=upvote", urlString, muuid, suuid];
            regString = [regString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            NSURL *url = [NSURL URLWithString:regString];
            NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
            NSData *urlData;
            NSURLResponse *response;
            urlData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:nil];
            //rating +2
            //connect to vote.php with suuid and increment the rating by the amount and vote (incr or decr)
            NSString *ratingString = [NSString stringWithFormat:@"http://%@:8888/project/vote.php?suuid=%@&amount=2&vote=upvote",urlString, suuid];
            ratingString = [ratingString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            NSURL *rurl = [NSURL URLWithString:ratingString];
            NSURLRequest *rurlRequest = [NSURLRequest requestWithURL:rurl];
            NSData *rurlData;
            NSURLResponse *rresponse;
            rurlData = [NSURLConnection sendSynchronousRequest:rurlRequest returningResponse:&rresponse error:nil];

        } else if ([mDBuuid length] != 0 && [mDBvote isEqualToString:@"upvote"]) {
            NSString *regString = [NSString stringWithFormat:@"http://%@:8888/project/voteUpdate.php?muuid=%@&suuid=%@&vote=none", urlString, muuid, suuid];
            regString = [regString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSLog(@"CHANGE TO NONE - string is upvote");
            
            NSURL *url = [NSURL URLWithString:regString];
            NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
            NSData *urlData;
            NSURLResponse *response;
            urlData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:nil];
            //rating -1
            //connect to vote.php with suuid and increment the rating by the amount and vote (incr or decr)
            NSString *ratingString = [NSString stringWithFormat:@"http://%@:8888/project/vote.php?suuid=%@&amount=1&vote=downvote",urlString, suuid];
            ratingString = [ratingString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            NSURL *rurl = [NSURL URLWithString:ratingString];
            NSURLRequest *rurlRequest = [NSURLRequest requestWithURL:rurl];
            NSData *rurlData;
            NSURLResponse *rresponse;
            rurlData = [NSURLConnection sendSynchronousRequest:rurlRequest returningResponse:&rresponse error:nil];

        }
    }
    [self fetchedData];
}


-(IBAction)downvoteButtonClicked:(id)sender {
    /*
     Connect to DB, upload the user's preference, along with their device ID, so they can't
     spam votes. Also decrement the rating value by 1
     
     */
    UIButton* b = (UIButton*) sender;
    //Below line will got indexpath in string format
    NSString *suuid = [b titleForState:UIControlStateDisabled];
    NSString *muuid = [UIDevice currentDevice].identifierForVendor.UUIDString;
    
    NSString *URLString = [NSString stringWithFormat:@"http://%@:8888/project/voteTypeSelect.php?muuid=%@&suuid=%@", urlString, muuid, suuid];
    NSURL *urlJSON = [[NSURL alloc] initWithString:URLString];
    NSData* data = [NSData dataWithContentsOfURL:urlJSON];
    
    NSString *JSONString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSError *error = nil;
    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
    voteDict = [jsonParser objectWithString:JSONString error:&error];
    jsonVoteData = [voteDict valueForKeyPath:@"voter"];
    
    if (jsonVoteData  == nil || [jsonVoteData count] ==0) {
        NSLog(@"NO vote present - downvote stream");
        NSString *regString = [NSString stringWithFormat:@"http://%@:8888/project/voteType.php?muuid=%@&suuid=%@&vote=downvote", urlString, muuid, suuid];
        regString = [regString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSURL *url = [NSURL URLWithString:regString];
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
        NSData *urlData;
        NSURLResponse *response;
        urlData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:nil];
        //rating -1
        //connect to vote.php with suuid and increment the rating by the amount and vote (incr or decr)
        NSString *ratingString = [NSString stringWithFormat:@"http://%@:8888/project/vote.php?suuid=%@&amount=1&vote=downvote",urlString, suuid];
        ratingString = [ratingString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSURL *rurl = [NSURL URLWithString:ratingString];
        NSURLRequest *rurlRequest = [NSURLRequest requestWithURL:rurl];
        NSData *rurlData;
        NSURLResponse *rresponse;
        rurlData = [NSURLConnection sendSynchronousRequest:rurlRequest returningResponse:&rresponse error:nil];

    } else{
        NSLog(@"Vote present, perform change if necessary");
        NSString *mDBuuid = [[jsonVoteData objectAtIndex:0]objectForKey:@"muuid"];
        NSString *mDBvote = [[jsonVoteData objectAtIndex:0]objectForKey:@"vote"];
        
        if ([mDBuuid length] != 0 && [mDBvote isEqualToString:@"none"]) {
            NSLog(@"ALLOW DOWNVOTE - string is none");
            NSString *regString = [NSString stringWithFormat:@"http://%@:8888/project/voteUpdate.php?muuid=%@&suuid=%@&vote=downvote", urlString, muuid, suuid];
            regString = [regString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            NSURL *url = [NSURL URLWithString:regString];
            NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
            NSData *urlData;
            NSURLResponse *response;
            urlData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:nil];
            //rating -1
            //connect to vote.php with suuid and increment the rating by the amount and vote (incr or decr)
            NSString *ratingString = [NSString stringWithFormat:@"http://%@:8888/project/vote.php?suuid=%@&amount=1&vote=downvote",urlString, suuid];
            ratingString = [ratingString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            NSURL *rurl = [NSURL URLWithString:ratingString];
            NSURLRequest *rurlRequest = [NSURLRequest requestWithURL:rurl];
            NSData *rurlData;
            NSURLResponse *rresponse;
            rurlData = [NSURLConnection sendSynchronousRequest:rurlRequest returningResponse:&rresponse error:nil];
        } else if ([mDBuuid length] != 0 && [mDBvote isEqualToString:@"upvote"]) {
            NSLog(@"ALLOW DOWNVOTE - string is upvote");
            NSString *regString = [NSString stringWithFormat:@"http://%@:8888/project/voteUpdate.php?muuid=%@&suuid=%@&vote=downvote", urlString, muuid, suuid];
            regString = [regString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            NSURL *url = [NSURL URLWithString:regString];
            NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
            NSData *urlData;
            NSURLResponse *response;
            urlData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:nil];
            //rating -2
            //connect to vote.php with suuid and increment the rating by the amount and vote (incr or decr)
            NSString *ratingString = [NSString stringWithFormat:@"http://%@:8888/project/vote.php?suuid=%@&amount=2&vote=downvote",urlString, suuid];
            ratingString = [ratingString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            NSURL *rurl = [NSURL URLWithString:ratingString];
            NSURLRequest *rurlRequest = [NSURLRequest requestWithURL:rurl];
            NSData *rurlData;
            NSURLResponse *rresponse;
            rurlData = [NSURLConnection sendSynchronousRequest:rurlRequest returningResponse:&rresponse error:nil];
        } else if ([mDBuuid length] != 0 && [mDBvote isEqualToString:@"downvote"]) {
            NSString *regString = [NSString stringWithFormat:@"http://%@:8888/project/voteUpdate.php?muuid=%@&suuid=%@&vote=none", urlString, muuid, suuid];
            regString = [regString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSLog(@"CHANGE TO NONE - string is downvote");
            
            NSURL *url = [NSURL URLWithString:regString];
            NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
            NSData *urlData;
            NSURLResponse *response;
            urlData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:nil];
            
            //rating +1
            //connect to vote.php with suuid and increment the rating by the amount and vote (incr or decr)
            NSString *ratingString = [NSString stringWithFormat:@"http://%@:8888/project/vote.php?suuid=%@&amount=1&vote=upvote",urlString, suuid];
            ratingString = [ratingString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            NSURL *rurl = [NSURL URLWithString:ratingString];
            NSURLRequest *rurlRequest = [NSURLRequest requestWithURL:rurl];
            NSData *rurlData;
            NSURLResponse *rresponse;
            rurlData = [NSURLConnection sendSynchronousRequest:rurlRequest returningResponse:&rresponse error:nil];
        }
    }
    [self fetchedData];
}

-(IBAction)moreButtonClicked:(id)sender {
    NSLog(@"more");
    //segue to new view showing the streamer's preferences
}
/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 -(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     NSIndexPath *indexPath = [self.tb indexPathForSelectedRow];
   
     if ([[segue identifier] isEqualToString:@"streamDetails"]) {
         NSUserDefaults *sURL = [NSUserDefaults standardUserDefaults];
         urlString = [sURL stringForKey:@"sURL"];
         NSString *URLString = [NSString stringWithFormat:@"http://%@:8888/project/selectActive.php", urlString];
         // NSLog(@"URL is: %@", URLString);
         NSURL *urlJSON = [[NSURL alloc] initWithString:URLString];
         NSData* data = [NSData dataWithContentsOfURL:urlJSON];
         
         NSString *JSONString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
         NSError *error = nil;
         SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
         dict = [jsonParser objectWithString:JSONString error:&error];
         jsonData = [dict valueForKeyPath:@"streamers"];
         
          streamDetailsViewController *svc = (streamDetailsViewController *)[segue destinationViewController];
         
         svc.sname =[[jsonData objectAtIndex:indexPath.row]objectForKey:@"sname"];
         svc.uuid = [[jsonData objectAtIndex:indexPath.row]objectForKey:@"uuid"];
         svc.bitrate = [[jsonData objectAtIndex:indexPath.row]objectForKey:@"bitrate"];
         svc.fps = [[jsonData objectAtIndex:indexPath.row]objectForKey:@"fps"];
         svc.urlString = [[jsonData objectAtIndex:indexPath.row]objectForKey:@"url"];
         svc.rating = [[jsonData objectAtIndex:indexPath.row]objectForKey:@"rating"];

     } else {
         
     NSLog(@"Segue at indexpath: %@", indexPath);
     NSUserDefaults *sURL = [NSUserDefaults standardUserDefaults];
     urlString = [sURL stringForKey:@"sURL"];
     NSString *URLString = [NSString stringWithFormat:@"http://%@:8888/project/selectActive.php", urlString];
     // NSLog(@"URL is: %@", URLString);
     NSURL *urlJSON = [[NSURL alloc] initWithString:URLString];
     NSData* data = [NSData dataWithContentsOfURL:urlJSON];
     
     NSString *JSONString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
     NSError *error = nil;
     SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
     dict = [jsonParser objectWithString:JSONString error:&error];
     jsonData = [dict valueForKeyPath:@"streamers"];
     
     StreamViewController *svc = (StreamViewController *)[segue destinationViewController];

     NSString *str = [[jsonData objectAtIndex:indexPath.row]objectForKey:@"url"];
     NSRegularExpression *regex =[NSRegularExpression regularExpressionWithPattern:@"\\w\\w\\w\\w\\d" options:0 error:NULL];
     // NSArray *arrayOfAllMatches = [regex matchesInString:[[jsonData objectAtIndex:indexPath.row]objectForKey:@"url"] options:0 range:NSMakeRange(0, [[[jsonData objectAtIndex:indexPath.row]objectForKey:@"url"] length])];
     NSTextCheckingResult *match = [regex firstMatchInString:str options:0 range:NSMakeRange(0, [str length])];
     
     NSString *playlistString = [NSString stringWithFormat:@"http://%@:1935/%@/myStream/playlist.m3u8", urlString, [str substringWithRange:[match rangeAtIndex:0]]];
     svc.urlString = playlistString;
     
     NSLog(@"Cell clicked: %@", playlistString);
     }
 }

- (void)dealloc {
    [_button release];
    [super dealloc];
}
@end
