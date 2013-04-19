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
@property (strong, nonatomic) NSString *ipAddress;
@property (strong, nonatomic) NSString *port;

@property (assign, nonatomic) BOOL loggedIn;


/*
@property (strong, nonatomic) IBOutlet UITextField *ipAddressField;
@property (strong, nonatomic) IBOutlet UITextField *portField;
@property (strong, nonatomic) IBOutlet UISwitch *staySignedOnSwitch;
*/
@end
