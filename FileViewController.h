//
//  FileViewController.h
//  DropboxTest
//
//  Created by Ashwin Ramachandran on 4/23/13.
//  Copyright (c) 2013 Ashwin Ramachandran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Dropbox/Dropbox.h>
#import <QuickLook/QuickLook.h>
#import <MediaPlayer/MediaPlayer.h>

#import "Viewer.h"

@interface FileViewController : UITableViewController <UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UIBarButtonItem *loginButt;
@property (strong, nonatomic) NSArray *items;
@property (strong, nonatomic) MPMoviePlayerController *mpc;

- (id)initWithFilesystem:(DBFilesystem *)filesystem root:(DBPath *)root;
- (void)loadFiles;

@end
