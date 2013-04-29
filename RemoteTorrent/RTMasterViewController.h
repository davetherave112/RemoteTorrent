//
//  RTMasterViewController.h
//  RemoteTorrent
//
//  Created by David Engelhardt on 4/11/13.
//  Copyright (c) 2013 David Engelhardt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <Dropbox/Dropbox.h>
#import "RTLoginController.h"
#import "RTAddTorrentViewController.h"
#import "FileViewController.h"



@interface RTMasterViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, loginToBittorrentDelegate, addTorrentDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *password;
//@property (nonatomic) BOOL rememberLogin;

@property (weak, nonatomic) IBOutlet UITabBar *tabBar;
@property (weak, nonatomic) IBOutlet UITabBarItem *tabBarItemCompleted;

@property (assign, nonatomic) BOOL loggedIn;


@end
