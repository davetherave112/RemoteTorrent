//
//  RTMasterViewController.h
//  RemoteTorrent
//
//  Created by David Engelhardt on 4/11/13.
//  Copyright (c) 2013 David Engelhardt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "RTLoginController.h"
#import "RTAddTorrentViewController.h"



@interface RTMasterViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, loginToBittorrentDelegate, addTorrentDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *password;
//@property (nonatomic) BOOL rememberLogin;


@property (assign, nonatomic) BOOL loggedIn;


@end
