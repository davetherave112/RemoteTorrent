//
//  FileViewController.m
//  DropboxTest
//
//  Created by Ashwin Ramachandran on 4/23/13.
//  Copyright (c) 2013 Ashwin Ramachandran. All rights reserved.
//

#import "FileViewController.h"

@interface FileViewController ()

@property (nonatomic, retain) DBFilesystem *filesystem;
@property (nonatomic, retain) DBPath *root;
@property (nonatomic, assign) BOOL loadingFiles;

@end

@implementation FileViewController

@synthesize mpc;
@synthesize loginButt;
@synthesize items;

BOOL firstTimeLink = YES;
DBAccount *account;

-(void) viewDidLoad
{
    
    
    if (firstTimeLink)
    {
        // link to dropbox
        DBAccountManager* accountMgr = [[DBAccountManager alloc] initWithAppKey:@"plux600vsa0m31f" secret:@"eezgie3mgcbs5oo"];
        [DBAccountManager setSharedManager:accountMgr];
        // see if there's a linked account
        account = [accountMgr.linkedAccounts objectAtIndex:0];
    }
    
        
        
        if (account) { // if so
            // pass the info to the view controller
            DBFilesystem *filesystem = [[DBFilesystem alloc] initWithAccount:account];
            
            [self initWithFilesystem:filesystem root:[DBPath root]];
        }
        else // otherwise initialize it empty
        {
            [self init];
        }
        firstTimeLink = NO;
    
    
}

#pragma mark - initialization methods

- (id)init {
    if (self = [super init]) {
        UIBarButtonItem *b = [[UIBarButtonItem alloc] initWithTitle:@"Link" style:UIBarButtonItemStyleBordered target:self action:@selector(loginButton:)];
        loginButt = b;
        self.navigationItem.rightBarButtonItem = loginButt;
        self.navigationItem.title = @"Link Your Dropbox";
    }
    return self;
}

- (id)initWithFilesystem:(DBFilesystem *)filesystem root:(DBPath *)root {
	if ((self = [super init])) {
		self.filesystem = filesystem;
		self.root = root;
		self.navigationItem.title = [root isEqual:[DBPath root]] ? @"Dropbox" : [root name];
        
        UIBarButtonItem *b = [[UIBarButtonItem alloc] initWithTitle:@"Unlink" style:UIBarButtonItemStyleBordered target:self action:@selector(loginButton:)];
        loginButt = b;
        self.navigationItem.rightBarButtonItem = loginButt;
        
        [self loadFiles];
	}
	return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
	[self.filesystem removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    
	__weak FileViewController *weakSelf = self;
	[self.filesystem addObserver:self block:^() { [weakSelf reload]; }];
	[self.filesystem addObserver:self forPathAndChildren:self.root block:^() { [weakSelf loadFiles]; }];
	[self.navigationController setToolbarHidden:YES];
	[self loadFiles];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	
	[_filesystem removeObserver:self];
}

+ (NSString *) applicationDocumentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

#pragma mark - DropBox linking

- (IBAction)loginButton:(id)sender
{
    if ([[[DBAccountManager sharedManager] linkedAccounts] count] == 0) // no linked accounts
        [[DBAccountManager sharedManager] linkFromController:self];
    else {
        [[[DBAccountManager sharedManager] linkedAccount] unlink];
        
        self.navigationItem.rightBarButtonItem.title = @"Link";
        
        items = [[NSArray alloc] init];
        [self reload];
    }
}

- (void)loadFiles {
    if (self.loadingFiles) return;
	self.loadingFiles = YES;
    
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^() {
		NSArray *immContents = [self.filesystem listFolder:self.root error:nil];
		dispatch_async(dispatch_get_main_queue(), ^() {
			self.items = immContents;
			self.loadingFiles = NO;
			[self reload];
		});
	});
}

#pragma mark - TableView methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // reuse cell that rolled off screen
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCell"];
    
    // if we need a new cell
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyCell"];
    
    // set the cell text
    DBFileInfo *f = [items objectAtIndex:indexPath.row];
    cell.textLabel.text = [f.path name];
    if (f.isFolder)
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    else
        cell.accessoryType = UITableViewCellAccessoryNone;

    return cell;
}

#pragma mark - UITableViewDelegate method

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DBFileInfo *item = [items objectAtIndex:indexPath.row];
    
    if (item.isFolder) { // user selected a folder
        // create this directory in local filesystem
        NSString *base = [FileViewController applicationDocumentsDirectory];
        NSString *newDir = [base stringByAppendingPathComponent:[item.path stringValue]];
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:newDir]) // create the directory
            [[NSFileManager defaultManager] createDirectoryAtPath:newDir withIntermediateDirectories:NO attributes:nil error:nil];
        
        FileViewController *vc = [[FileViewController alloc] initWithFilesystem:self.filesystem root:item.path];
        [self.navigationController pushViewController:vc animated:YES];
    } else { // some sort of document (image, video, textfile, etc.)
        DBFile *file = [self.filesystem openFile:item.path error:nil]; // open the selected file
        
        // location of the file in the system
        NSString *loc = [FileViewController applicationDocumentsDirectory];
        
        NSString *fin = [loc stringByAppendingPathComponent:[file.info.path stringValue]];
        
        if(file.status.cached) { // if it's cached
            NSData *fileDat = [file readData:nil]; // update the data
            [fileDat writeToFile:fin atomically:YES]; // write to the file
            Viewer *vr = [[Viewer alloc] initWithLoc:fin];
            
            // diplay appropriate item
            if ([vr isPlayableVideo]) {
                NSURL *url = [NSURL fileURLWithPath:fin];
                mpc = [[MPMoviePlayerController alloc] initWithContentURL:url];

                [self.view addSubview:mpc.view];
                mpc.fullscreen = YES;
                mpc.controlStyle = MPMovieControlStyleFullscreen;
                [mpc play];
            }
            else
                [self.navigationController pushViewController:vr animated:YES];
        }
    }
}

#pragma mark - Private methods

- (void)reload {
	[self.tableView reloadData];
}

- (DBAccount *)account {
	return _filesystem.account;
}

@end
