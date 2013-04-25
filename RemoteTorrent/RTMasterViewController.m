//
//  RTMasterViewController.m
//  RemoteTorrent
//
//  Created by David Engelhardt on 4/11/13.
//  Copyright (c) 2013 David Engelhardt. All rights reserved.
//

#import "RTMasterViewController.h"
#import "RTDetailViewController.h"
#import "RTAddTorrentViewController.h"
#import "RTLoginController.h"

@interface RTMasterViewController ()
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end


@implementation RTMasterViewController

@synthesize loggedIn;

NSDictionary* resultDictionary;
NSDictionary* torrentListDictionary;
NSArray* torrentListArray;
NSArray* selectedTorrent;

NSString* baseURLString = @"http://";


NSMutableData* responseData;

NSUserDefaults *defaults;



- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    defaults = [NSUserDefaults standardUserDefaults];
    
    self.loggedIn = NO;
    
    if((!self.loggedIn) && ![defaults objectForKey:@"remember_login"])
    {
        //Present Login Controller
        
        RTLoginController *loginView = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginPage"];
        
        loginView.modalPresentationStyle = UIModalPresentationFormSheet;
        loginView.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        
        loginView.delegate = self;
        
        
        [self presentViewController:loginView animated:YES completion:nil];
        
    }
    else
    {
        torrentListDictionary = [self getTorrentList];
        
        [self.tableView reloadData];
        //self.loggedIn = YES;
        
    }
    
	// Do any additional setup after loading the view, typically from a nib.
    
    //self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    
    [self.tableView setAllowsSelection:YES];
    
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(getTorrentURL:)];
    UIBarButtonItem *loginButton = [[UIBarButtonItem alloc] initWithTitle:@"Login" style:UIBarButtonItemStyleBordered target:self action:@selector(loginButtonPressed:)];
    UIBarButtonItem *pauseButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPause target:self action:@selector(pauseTorrent:)];
    UIBarButtonItem *resumeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(resumeTorrent:)];
    UIBarButtonItem *removeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(removeTorrent:)];
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshPage:)];

    
    
    
    NSArray *leftButtonArray = [[NSArray alloc] initWithObjects:addButton, resumeButton, pauseButton, nil];
    NSArray *rightButtonArray = [[NSArray alloc] initWithObjects: loginButton, refreshButton, removeButton, nil];


    self.navigationItem.leftBarButtonItems =leftButtonArray;
    self.navigationItem.rightBarButtonItems = rightButtonArray;
    
    
    
    
    
}

- (void) loginButtonPressed:(id)sender
{
    //Present Login Controller
    RTLoginController *loginView = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginPage"];
    
    loginView.modalPresentationStyle = UIModalPresentationFormSheet;
    loginView.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;

    loginView.delegate = self;
    
    if ([defaults objectForKey:@"remember_login"])
    {
        [loginView.usernameField setText:[defaults objectForKey:@"username"]];
        //loginView.usernameField.text = [defaults objectForKey:@"username"];
        loginView.passwordField.text = [defaults objectForKey:@"password"];
        [loginView.staySignedOnSwitch setOn:YES animated:YES];
    }
    
    [self presentViewController:loginView animated:YES completion:nil];
    
}

-(void) loginToBittorrent:(RTLoginController*) controller didEnterCredentials: (NSArray*) loginCredentials
{
    //Store IP Address and Port
    self.username = [loginCredentials objectAtIndex:0];
    self.password = [loginCredentials objectAtIndex:1];
    BOOL rememberLogin = [[loginCredentials objectAtIndex:2] boolValue];
    
    if (rememberLogin)
    {
        [defaults setObject:self.username forKey:@"username"];
        [defaults setObject:self.password forKey:@"password"];
        //[defaults setBool:self.rememberLogin forKey:@"remember_login"];
        
    }
    else
    {
        [defaults removeObjectForKey:@"username"];
        [defaults removeObjectForKey:@"password"];
        [defaults removeObjectForKey:@"remember_login"];        
    }
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    torrentListDictionary = [self getTorrentList];
    
    [self.tableView reloadData];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
- (void)insertNewObject:(id)sender
{
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    
    // If appropriate, configure the new managed object.
    // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
    [newManagedObject setValue:[NSDate date] forKey:@"timeStamp"];
    
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
         // Replace this implementation with code to handle the error appropriately.
         // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}*/

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    //return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    /*
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
     */
    
    if (self.loggedIn)
    {
        return torrentListArray.count;
    }
    else
    {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TorrentCell" forIndexPath:indexPath];
    //[self configureCell:cell atIndexPath:indexPath];
   
    
    
    static NSString *CellIdentifier = @"TorrentCell";
    
    // Get a cell to use:
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
	// Configure the cell:
	NSString *title = [[torrentListArray objectAtIndex:indexPath.row] objectAtIndex:2]; //TITLE is located at index 2
    
    if (title.length > 20)
    {
        title = [[title substringToIndex:19] stringByAppendingString:@"..."];
    }
    //NSString *abbrevTitle = title;
    NSNumber *progress = [[torrentListArray objectAtIndex:indexPath.row] objectAtIndex:4]; //PERCENT PROGRESS is located at index 4
    //NSString *percentDoneString = [NSString stringWithFormat:@"%@", progress];

    NSDecimalNumber *percentDone = [[NSDecimalNumber decimalNumberWithDecimal:[progress decimalValue]] decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithString:@"10"]];
    NSString *percentDoneString = [NSString stringWithFormat:@"%@%%", percentDone];
    
    NSDecimalNumber *percentDoneZeroToOne = [[NSDecimalNumber decimalNumberWithDecimal:[progress decimalValue]] decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithString:@"1000"]];
    
    
    NSNumber *status = [[torrentListArray objectAtIndex:indexPath.row] objectAtIndex:1]; //STATUS is located at index 1    
    NSInteger statusInt = status.integerValue;
    
    NSNumber *ETA = [[torrentListArray objectAtIndex:indexPath.row] objectAtIndex:10]; //ETA is located at index 10
    NSInteger ETAMinutes = (ETA.integerValue)/60;

    NSNumber *downloaded = [[torrentListArray objectAtIndex:indexPath.row] objectAtIndex:5]; //DOWNLOADED is located at index 5
    NSInteger downloadedMB = (downloaded.integerValue)/1000000;
    
    NSNumber *uploaded = [[torrentListArray objectAtIndex:indexPath.row] objectAtIndex:6]; //UPLOADED is located at index 6
    NSInteger uploadedMB = (uploaded.integerValue)/1000000;
    
    NSNumber *size = [[torrentListArray objectAtIndex:indexPath.row] objectAtIndex:3]; //SIZE is located at index 3
    NSInteger sizeMB = (size.integerValue)/1000000;
    
    
    NSInteger startedStatus = 1;
    NSInteger checkingStatus = 2;
    NSInteger startAfterCheckStatus = 4;
    NSInteger checkedStatus = 8;
    NSInteger errorStatus = 16;
    NSInteger pausedStatus = 32;
    NSInteger queuedStatus = 64;
    NSInteger loadedStatus = 128;
    
    NSInteger finishedStatus = loadedStatus + checkedStatus;
    NSInteger seedingStatus;
    NSInteger downloadingStatus = loadedStatus + queuedStatus + checkedStatus + startedStatus;

    
    
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 0.0, 300.0, 30.0)];
    [nameLabel setTag:1];
    [nameLabel setBackgroundColor:[UIColor clearColor]]; // transparent label background
    [nameLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
    // custom views should be added as subviews of the cell's contentView:
    [cell.contentView addSubview:nameLabel];
    [(UILabel *)[cell.contentView viewWithTag:1] setText:title];
     

    UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 20.0, 300.0, 30.0)];
    [statusLabel setTag:2];
    [statusLabel setBackgroundColor:[UIColor clearColor]]; // transparent label background
    [statusLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
    [statusLabel setTextColor:[UIColor grayColor]];
    // custom views should be added as subviews of the cell's contentView:
    [cell.contentView addSubview:statusLabel];
    
    UIColor* progressBarColor = [UIColor clearColor];
    
    if (statusInt & pausedStatus)
    {
        [(UILabel *)[cell.contentView viewWithTag:2] setText:@"Paused"];
        progressBarColor = [UIColor yellowColor];
    }
    else if (statusInt == downloadingStatus)
    {
        [(UILabel *)[cell.contentView viewWithTag:2] setText:@"Downloading"];
        progressBarColor = [UIColor greenColor];
        
    }
    else if (statusInt & finishedStatus)
    {
        [(UILabel *)[cell.contentView viewWithTag:2] setText:@"Finished"];
        progressBarColor = [UIColor colorWithRed:0.4 green:0.2 blue:0.596 alpha:1.0]; //Bittorrent purple color
    }
    else if (statusInt & seedingStatus)
    {
        [(UILabel *)[cell.contentView viewWithTag:2] setText:@"Seeding"];
        progressBarColor = [UIColor blueColor];
        
    }

    if (statusInt & errorStatus)
    {
        [(UILabel *)[cell.contentView viewWithTag:2] setText:@"Error"];
        progressBarColor = [UIColor redColor];

    }
    
    
	//cell.textLabel.text = abbrevTitle;
    //cell.detailTextLabel.text = percentDoneString;
    
    
    

    UIProgressView *torrentProgressBar = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    torrentProgressBar.progress = [percentDoneZeroToOne floatValue];
    torrentProgressBar.frame = CGRectMake(20, 70, 200, 30);
    torrentProgressBar.progressTintColor = progressBarColor;
    //torrentProgressBar.center = CGPointMake(23,21);
    [cell.contentView addSubview:torrentProgressBar];
    
    UILabel *progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(230.0, 57.0, 50.0, 30.0)];
    [progressLabel setTag:6];
    [progressLabel setBackgroundColor:[UIColor clearColor]]; // transparent label background
    [progressLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
    [progressLabel setTextColor:[UIColor grayColor]];
    // custom views should be added as subviews of the cell's contentView:
    [cell.contentView addSubview:progressLabel];
    [(UILabel *)[cell.contentView viewWithTag:6] setText:percentDoneString];
    
    UILabel *ETALabel = [[UILabel alloc] initWithFrame:CGRectMake(180.0, 20.0, 300.0, 30.0)];
    [ETALabel setTag:3];
    [ETALabel setBackgroundColor:[UIColor clearColor]]; // transparent label background
    [ETALabel setFont:[UIFont boldSystemFontOfSize:12.0]];
    [ETALabel setTextColor:[UIColor grayColor]];
    // custom views should be added as subviews of the cell's contentView:
    [cell.contentView addSubview:ETALabel];
    [(UILabel *)[cell.contentView viewWithTag:3] setText:[[@"ETA: " stringByAppendingString:[NSString stringWithFormat:@"%d", ETAMinutes]] stringByAppendingString:@" minutes"]];
    
    
    UILabel *downloadedLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 35.0, 300.0, 30.0)];
    [downloadedLabel setTag:4];
    [downloadedLabel setBackgroundColor:[UIColor clearColor]]; // transparent label background
    [downloadedLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
    [downloadedLabel setTextColor:[UIColor grayColor]];
    // custom views should be added as subviews of the cell's contentView:
    [cell.contentView addSubview:downloadedLabel];
    [(UILabel *)[cell.contentView viewWithTag:4] setText:[[@"D: " stringByAppendingString:[NSString stringWithFormat:@"%d", downloadedMB]] stringByAppendingString:[@" MB out of " stringByAppendingString:[[NSString stringWithFormat:@"%d", sizeMB] stringByAppendingString:@" MB"]]]];
    
    UILabel *uploadedLabel = [[UILabel alloc] initWithFrame:CGRectMake(180.0, 35.0, 300.0, 30.0)];
    [uploadedLabel setTag:5];
    [uploadedLabel setBackgroundColor:[UIColor clearColor]]; // transparent label background
    [uploadedLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
    [uploadedLabel setTextColor:[UIColor grayColor]];
    // custom views should be added as subviews of the cell's contentView:
    [cell.contentView addSubview:uploadedLabel];
    [(UILabel *)[cell.contentView viewWithTag:5] setText:[[@"U: " stringByAppendingString:[NSString stringWithFormat:@"%d", uploadedMB]] stringByAppendingString:@" MB"]];
	
    
    return cell;
    
    
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{   
    
    selectedTorrent = [torrentListArray objectAtIndex:[indexPath indexAtPosition:0]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88.0f;
}
/*
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        NSError *error = nil;
        if (![context save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }   
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showTorrentDetail"])
    {
        //NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        
        NSString* filesListURLString = [baseURLString stringByAppendingString:@"&action=getfiles&hash="];
        filesListURLString = [filesListURLString stringByAppendingString:[[torrentListArray objectAtIndex:indexPath.row] objectAtIndex:0]]; //HASH is at index 0
        
        // Perform BitTorrent API search:
        
        NSURL* filesListURL = [NSURL URLWithString: filesListURLString];
               
        NSData* responseData = [NSData dataWithContentsOfURL:filesListURL];
        NSError* error = nil;
        NSDictionary* fileListDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
        
        NSArray* fileListArray = [[fileListDictionary objectForKey:@"files"] objectAtIndex:1]; //Pull array of file list out (it's at index 1, index 0 is the HASH)
        
        //NSManagedObject *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        
        [[segue destinationViewController] setDetailItem:fileListArray];
    }
}




/*
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}*/

/*
// Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed. 
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    // In the simplest, most efficient, case, reload the table view.
    [self.tableView reloadData];
}
 */
/*
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [[object valueForKey:@"timeStamp"] description];
}*/

- (NSDictionary*)getTorrentList
{
    //NSDictionary* resultDictionary;
    
    
    //self.ipAddress = @"guest@192.168.1.6";
    //self.ipAddress = @"guest@108.29.127.70";
    //self.ipAddress = @"admin:12345@108.29.127.70";
    //self.port = @"18921";
    
    if ([defaults objectForKey:@"remember_login"])
    {
        self.username = [defaults objectForKey:@"username"];
        self.password = [defaults objectForKey:@"password"];
    }
    
    
    
    // Get token
    baseURLString = [baseURLString stringByAppendingString:self.username];
    baseURLString = [baseURLString stringByAppendingString:@":"];
    baseURLString = [baseURLString stringByAppendingString:self.password];
    baseURLString = [baseURLString stringByAppendingString:@"@"];
    baseURLString = [baseURLString stringByAppendingString:[defaults objectForKey:@"ip_address"]];
    baseURLString = [baseURLString stringByAppendingString:@":"];
    baseURLString = [baseURLString stringByAppendingString:[defaults objectForKey:@"port"]];
    baseURLString = [baseURLString stringByAppendingString:@"/gui/"];
    
    //baseURLString = @"admin:12345@108.29.127.70:18921/gui/";
    
    NSString* tokenURLString = [baseURLString stringByAppendingString:@"token.html"];
    
    NSURL *tokenURL = [NSURL URLWithString:tokenURLString];
    NSError *error;
    NSString *tokenPage = [NSString stringWithContentsOfURL:tokenURL
                                                    encoding:NSASCIIStringEncoding
                                                       error:&error];
    

    NSString* token;
    
    if (!error) {
        
        NSScanner* tokenScanner = [NSScanner scannerWithString:tokenPage];
        [tokenScanner scanUpToString:@"'>" intoString:NULL];
        [tokenScanner scanUpToString:@"</div>" intoString:&token];
    
        self.loggedIn = YES;
        
        // home ip address
        //108.29.127.70/
        token = [token substringFromIndex:2];
        
        baseURLString = [baseURLString stringByAppendingString:@"?token="];
        baseURLString = [baseURLString stringByAppendingString:token];
        
        // Formulate BitTorrent API search URL:
        NSString* searchURL = [baseURLString stringByAppendingString:@"&list=1"];
        
        // Perform BitTorrent API search:
        //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSURL* url = [NSURL URLWithString: searchURL];
        //NSString* user = [url user];
        //NSString* pass = [url password];
        
        NSData* responseData = [NSData dataWithContentsOfURL:url];
        NSError* error2 = nil;
        resultDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error2];
        /*
         NSError* err = nil;
         NSString *html = [NSString stringWithContentsOfURL:[NSURL URLWithString: searchURL] encoding:NSUTF8StringEncoding  error:&err];
         NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfURL:[NSURL URLWithString:searchURL]];
         //NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:searchURL]];
         */
        //dispatch_async(dispatch_get_main_queue(), ^{
        [self processTorrentResults];
        //return resultDictionary;
        //});
        //});
        return resultDictionary;
    
        
    }
    else
    {
        //report error to user
        UIAlertView* errorMessage;
        [errorMessage initWithTitle:@"Error" message:@"Problem Connecting" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [errorMessage show];
        return 0;
    }
}

- (void) processTorrentResults
{

    torrentListArray = [resultDictionary objectForKey:@"torrents"];
    //NSString *name = [[torrentListArray objectAtIndex:1] objectAtIndex:2]; //TITLE is located at index 2
    //NSNumber *percent = [[torrentListArray objectAtIndex:1] objectAtIndex:4]; //PERCENT PROGRESS is located at index 4

    
}
- (void)getTorrentURL:(id)sender
{
    
    RTAddTorrentViewController *addTorrentView = [self.storyboard instantiateViewControllerWithIdentifier:@"AddTorrentViewController"];
    
    addTorrentView.modalPresentationStyle = UIModalPresentationFormSheet;
    addTorrentView.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    addTorrentView.delegate = self;
    
    [self presentViewController:addTorrentView animated:YES completion:nil];
    
}

-(void) addNewTorrent:(RTAddTorrentViewController*) controller didEnterTorrentURL: (NSString*) torrentURL
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    NSString* newTorrentURLString = torrentURL;
    
    // Create HTTP Request URL
    NSString* addTorrentURLString = [baseURLString stringByAppendingString:@"&action=add-url&s="];
    addTorrentURLString = [addTorrentURLString stringByAppendingString:newTorrentURLString];
    
    NSURL* url = [NSURL URLWithString: addTorrentURLString];
    
    NSURLRequest *addTorrentRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30];
    
    NSData *urlData;
    NSURLResponse *response;
    NSError *error;
    
    // Make synchronous request
    urlData = [NSURLConnection sendSynchronousRequest:addTorrentRequest
                                    returningResponse:&response
                                                error:&error];

    
}


- (void) removeTorrent:(id)sender
{
    
    // Create HTTP Request URL
    NSString* removeTorrentURLString = [baseURLString stringByAppendingString:@"&action=remove&hash="];
    removeTorrentURLString = [removeTorrentURLString stringByAppendingString:[selectedTorrent objectAtIndex:0]]; //HASH is at index 0
    
    //Send request
    
    
    NSURL* url = [NSURL URLWithString: removeTorrentURLString];
    
    NSURLRequest *removeTorrentRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30];
    
    NSData *urlData;
    NSURLResponse *response;
    NSError *error;
    
    // Make synchronous request
    urlData = [NSURLConnection sendSynchronousRequest:removeTorrentRequest
                                    returningResponse:&response
                                                error:&error];
}

- (void) resumeTorrent:(id)sender
{
    
    // Create HTTP Request URL
    NSString* resumeTorrentURLString = [baseURLString stringByAppendingString:@"&action=unpause&hash="];
    resumeTorrentURLString = [resumeTorrentURLString stringByAppendingString:[selectedTorrent objectAtIndex:0]]; //HASH is at index 0
    
    //Send request
    
    
    NSURL* url = [NSURL URLWithString: resumeTorrentURLString];
    
    NSURLRequest *resumeTorrentRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30];
    
    NSData *urlData;
    NSURLResponse *response;
    NSError *error;
    
    // Make synchronous request
    urlData = [NSURLConnection sendSynchronousRequest:resumeTorrentRequest
                                    returningResponse:&response
                                                error:&error];
}

- (void) pauseTorrent:(id)sender
{
    
    // Create HTTP Request URL
    NSString* pauseTorrentURLString = [baseURLString stringByAppendingString:@"&action=pause&hash="];
    pauseTorrentURLString = [pauseTorrentURLString stringByAppendingString:[selectedTorrent objectAtIndex:0]]; //HASH is at index 0
    
    //Send request
    
    
    NSURL* url = [NSURL URLWithString: pauseTorrentURLString];
    
    NSURLRequest *pauseTorrentRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30];
    
    NSData *urlData;
    NSURLResponse *response;
    NSError *error;
    
    // Make synchronous request
    urlData = [NSURLConnection sendSynchronousRequest:pauseTorrentRequest
                                    returningResponse:&response
                                                error:&error];
}

- (void)refreshPage:(id)sender
{
    
    torrentListDictionary = [self getTorrentList];
    
    [self.tableView reloadData];
    
}

@end
