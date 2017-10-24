//
//  User.m
//  Ribbit
//
//  Created by Amit Bijlani on 8/24/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

#import "User.h"

static NSInteger identifier = 1;

@interface User()
@property (strong,nonatomic) NSMutableArray *friendsMutable;
@end

@implementation User

+ (instancetype) currentUser {
  static User *sharedUser = nil;
  
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedUser = [[self alloc] init];
    sharedUser.username = @"Current user";
    sharedUser.objectId = @"100";
    sharedUser.friendsMutable = [NSMutableArray array];
  });
  
  return sharedUser;
}

+ (instancetype)userWithUsername:(NSString*)username {
  User *user = [[self alloc] init];
  if ( user ) {
    user.username = username;
    user.objectId = [NSString stringWithFormat:@"%ld",(long)++identifier];
  }
  return user;
}

- (void)addFriend:(User *)friend {
  [self.friendsMutable addObject:friend];
}

// Edited to fix bug #3 and 4 so that remove function compares user objects via username

- (void)removeFriend:(User *)selectedfriend {
    for (User *friend in self.friendsMutable) {
        if ([friend username] == [selectedfriend username]) {
            [self.friendsMutable removeObject:friend];
            return; // return out of loop as if you dont app wioll crash due to remove of object from array
        }
    }
}

- (NSArray*) friends {
  return self.friendsMutable;
}


@end
