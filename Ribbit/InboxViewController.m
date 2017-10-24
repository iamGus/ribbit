//
//  InboxViewController.m
//  Ribbit
//
//  Copyright (c) 2013 Treehouse. All rights reserved.
//

/*
 
 #Bug1 - Fixed by selecting main storyboard in general settings > main interface
 
 #Bug2 - It was not showing "Dont have an account" label as two conflicting contraints (Top and also centre vertically, I removed centre vertically). Error in console no longer appears.
 
 #Bug 3 and 4 - Fixed both bugs the same time. In EditFriendViewConroller changed the isFriend function and also modified the "delete" function in User.m
 
 #Bug 5 - Changed "file" property from Strong to Weak memory reference in Message.h - this has stopped memory from increasing a lot as it was not releasing the message model.
 
 #Bug6 - Fixed all deprecation warnings. 1. Changed alerts to use UIAlertController and 2. In this InboxViewController Changed videoPlayer to use AVPlayerController
 
 */

#import "InboxViewController.h"
#import "ImageViewController.h"
#import "Message.h"
#import "User.h"
#import "App.h"
#import "File.h"

@interface InboxViewController ()

@end

@implementation InboxViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.moviePlayer = [[AVPlayerViewController alloc] init];
    
    User *currentUser = [User currentUser];
    if (currentUser) {
        NSLog(@"Current user: %@", currentUser.username);
    }
    else {
        [self performSegueWithIdentifier:@"showLogin" sender:self];
    }
}

- (NSArray *)messages {
  return [[App currentApp] messages];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[self messages] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Message *message = [[self messages] objectAtIndex:indexPath.row];
    cell.textLabel.text = message.senderName;
    
    NSString *fileType = message.fileType;
    if ([fileType isEqualToString:@"image"]) {
        cell.imageView.image = [UIImage imageNamed:@"icon_image"];
    }
    else {
        cell.imageView.image = [UIImage imageNamed:@"icon_video"];
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedMessage = [[self messages] objectAtIndex:indexPath.row];
    NSString *fileType = self.selectedMessage.fileType;
    if ([fileType isEqualToString:@"image"]) {
        [self performSegueWithIdentifier:@"showImage" sender:self];
    }
    else {
        
        // Changed player to AVPlayerController as other player was depreciated
        
        // File type is video
        File *videoFile = self.selectedMessage.file;
        self.moviePlayer.player = [AVPlayer playerWithURL:videoFile.fileURL];
       
        
        // Add it to the view controller so we can see it
        self.moviePlayer.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:self.moviePlayer animated:YES completion:nil];
        [self.moviePlayer.player play];
    }
    
    // Delete it!
    [[App currentApp] deleteMessage:self.selectedMessage];
}

- (IBAction)logout:(id)sender {
//    [User logOut];
    [self performSegueWithIdentifier:@"showLogin" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showLogin"]) {
        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
    }
    else if ([segue.identifier isEqualToString:@"showImage"]) {
        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
        ImageViewController *imageViewController = (ImageViewController *)segue.destinationViewController;
        imageViewController.message = self.selectedMessage;
    }
}

@end
