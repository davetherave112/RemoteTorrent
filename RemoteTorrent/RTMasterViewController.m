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

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.loggedIn = NO;
    
    if(!self.loggedIn)
    {
        //Present Login Controller
        
        RTLoginController *loginView = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginPage"];
        
        loginView.modalPresentationStyle = UIModalPresentationFormSheet;
        loginView.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        
        loginView.delegate = self;
        
        
        [self presentViewController:loginView animated:YES completion:nil];
        
    }
    
	// Do any additional setup after loading the view, typically from a nib.
    
    //self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    
    [self.tableView setAllowsSelection:YES];
    
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(getTorrentURL:)];
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"Login" style:UIBarButtonItemStyleBordered target:self action:@selector(loginButtonPressed:)];
    UIBarButtonItem *pauseButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPause target:self action:@selector(pauseTorrent:)];
    UIBarButtonItem *resumeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(resumeTorrent:)];
    UIBarButtonItem *removeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(removeTorrent:)];
    
    
    
    NSArray *leftButtonArray = [[NSArray alloc] initWithObjects:addButton, resumeButton, pauseButton, nil];
    NSArray *rightButtonArray = [[NSArray alloc] initWithObjects:editButton, removeButton, nil];


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
    
    [self presentViewController:loginView animated:YES completion:nil];
    
}

-(void) loginToBittorrent:(RTLoginController*) controller didEnterCredentials: (NSArray*) loginCredentials
{
    //Store IP Address and Port
    self.ipAddress = [loginCredentials objectAtIndex:0];
    self.port = [loginCredentials objectAtIndex:1];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    self.loggedIn = YES;
    
    /*
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewTorrent:)];
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshPage:)];
    UIBarButtonItem *pauseButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPause target:self action:@selector(pauseTorrent:)];
    UIBarButtonItem *resumeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(resumeTorrent:)];
    UIBarButtonItem *removeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(removeTorrent:)];
    
    
    
    NSArray *leftButtonArray = [[NSArray alloc] initWithObjects:addButton, resumeButton, pauseButton, nil];
    NSArray *rightButtonArray = [[NSArray alloc] initWithObjects:editButton, removeButton, nil];
    
    
    self.navigationItem.leftBarButtonItems =leftButtonArray;
    self.navigationItem.rightBarButtonItems = rightButtonArray;
     
    */
    
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
    NSString *abbrevTitle = [[title substringToIndex:19] stringByAppendingString:@"..."];
    
    NSNumber *progress = [[torrentListArray objectAtIndex:indexPath.row] objectAtIndex:4]; //PERCENT PROGRESS is located at index 4
    //NSString *percentDoneString = [NSString stringWithFormat:@"%@", progress];

    NSDecimalNumber *percentDone = [[NSDecimalNumber decimalNumberWithDecimal:[progress decimalValue]] decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithString:@"10"]];
    NSString *percentDoneString = [NSString stringWithFormat:@"%@%%", percentDone];
    
    

    
	cell.textLabel.text = abbrevTitle;
    cell.detailTextLabel.text = percentDoneString;
	
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
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSManagedObject *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        [[segue destinationViewController] setDetailItem:object];
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
    
    
    // Get token
    baseURLString = [baseURLString stringByAppendingString:@"admin:12345@"];
    baseURLString = [baseURLString stringByAppendingString:self.ipAddress];
    baseURLString = [baseURLString stringByAppendingString:@":"];
    baseURLString = [baseURLString stringByAppendingString:self.port];
    baseURLString = [baseURLString stringByAppendingString:@"/gui/"];
    
    NSString* tokenURLString = [baseURLString stringByAppendingString:@"token.html"];
    
    //tokenURLString = @"https://www.google.com/";
    
    NSURL *tokenURL = [NSURL URLWithString:tokenURLString];
    NSError *error;
    NSString *tokenPage = [NSString stringWithContentsOfURL:tokenURL
                                                    encoding:NSASCIIStringEncoding
                                                       error:&error];
    

    NSString* token;
    
    //if (!error) {
        
        NSScanner* tokenScanner = [NSScanner scannerWithString:tokenPage];
        [tokenScanner scanUpToString:@"'>" intoString:NULL];
        [tokenScanner scanUpToString:@"</div>" intoString:&token];
    
        
    //}
    //else {
        //report error to user
    //}
    
    

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
    
    [self.tableView reloadData];
    
}

@end
