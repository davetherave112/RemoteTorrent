//
//  RTAppDelegate.h
//  RemoteTorrent
//
//  Created by David Engelhardt on 4/11/13.
//  Copyright (c) 2013 David Engelhardt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Dropbox/Dropbox.h>
#import "FileViewController.h"

@interface RTAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) UINavigationController *rootController;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
