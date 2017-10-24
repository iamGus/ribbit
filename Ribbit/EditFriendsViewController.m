//
//  EditFriendsViewController.m
//  Ribbit
//
//  Copyright (c) 2013 Treehouse. All rights reserved.
//

#import "EditFriendsViewController.h"
#import "User.h"
#import "App.h"

@interface EditFriendsViewController ()

@end

@implementation EditFriendsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
  
  [self.tableView reloadData];
  
  self.currentUser = [User currentUser];
    
  
}

// Just returns full list of all possible slectable users to choose from
- (NSArray *)allUsers {
  return [[App currentApp] allUsers];
    
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
    return [self.allUsers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    User *user = [self.allUsers objectAtIndex:indexPath.row];
    cell.textLabel.text = user.username;
    
    if ([self isFriend:user] == true) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
  
    User *user = [self.allUsers objectAtIndex:indexPath.row];
    
    if ([self isFriend:user]) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [self.currentUser removeFriend:user];
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.currentUser addFriend:user];
    }    
}

#pragma mark - Helper methods


// Changed this function for bug #3 and 4 - to that function properly checks over currentfriends array with selcted user using username to compare.
- (BOOL)isFriend:(User *)user {
    for (User *friend in self.currentUser.friends) {
        if ([friend username] == [user username]) {
            return true;
        }
    }
  return false;
}

@end

