//
//  RTDetailViewController.m
//  RemoteTorrent
//
//  Created by David Engelhardt on 4/11/13.
//  Copyright (c) 2013 David Engelhardt. All rights reserved.
//

#import "RTDetailViewController.h"

@interface RTDetailViewController ()
- (void)configureView;
@end

@implementation RTDetailViewController

@synthesize torrentName;


NSArray* fileList;
NSArray* torrentInfo;

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        //self.detailDescriptionLabel.text = [[self.detailItem valueForKey:@"timeStamp"] description];
        
        torrentInfo = [self.detailItem objectAtIndex:0];
        torrentName.text = [torrentInfo objectAtIndex:2];//NAME is at index 2
        fileList = [self.detailItem objectAtIndex:1];
        
        [self.tableView reloadData];

        
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.tableView setDelegate:self];
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    //return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (self.detailItem)
    {
        //NSArray* temp = [fileList objectAtIndex:1];
        return fileList.count;
    }
    else
    {
        return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Files";
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        
    static NSString *CellIdentifier = @"FileCell";
    
    // Get a cell to use:
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
	// Configure the cell:
	NSArray *fileProperties = [fileList objectAtIndex:indexPath.row];
    NSString *title = [fileProperties objectAtIndex:0]; //FILE NAME is located at index 0
    //NSString *abbrevTitle = [[title substringToIndex:19] stringByAppendingString:@"..."];
    //NSString *abbrevTitle = title;
    NSNumber *size = [fileProperties objectAtIndex:1]; //FILE SIZE is located at index 1
    NSNumber *downloaded = [fileProperties objectAtIndex:2]; //DOWNLOADED is located at index 2
    NSNumber *priority = [fileProperties objectAtIndex:3]; //PROPERTIES is located at index 3
    
    //NSString *percentDoneString = [NSString stringWithFormat:@"%@", progress];
    
    /*
    NSDecimalNumber *percentDone = [[NSDecimalNumber decimalNumberWithDecimal:[progress decimalValue]] decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithString:@"10"]];
    NSString *percentDoneString = [NSString stringWithFormat:@"%@%%", percentDone];
    
    NSDecimalNumber *percentDoneZeroToOne = [[NSDecimalNumber decimalNumberWithDecimal:[progress decimalValue]] decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithString:@"1000"]];
    
    */
   

    
   
    NSInteger downloadedMB = (downloaded.integerValue)/1000000;
    NSInteger sizeMB = (size.integerValue)/1000000;
    
    
    NSInteger prioritySkip = 0;
    NSInteger priorityLow = 1;
    NSInteger priorityNormal = 2;
    NSInteger priorityHigh = 3;
    
    NSString *priorityString;
    
    switch (priority.integerValue)
    {
        case 3:
            priorityString = @"High";
            break;
        case 2:
            priorityString = @"Normal";
            break;
        case 1:
            priorityString = @"Low";
            break;
        case 0:
            priorityString = @"Skip";
            break;
            
        default:
            priorityString = @"No Priority";
            break;
    }
    
    
    
    /*
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 0.0, 300.0, 30.0)];
    [nameLabel setTag:1];
    [nameLabel setBackgroundColor:[UIColor clearColor]]; // transparent label background
    [nameLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
    // custom views should be added as subviews of the cell's contentView:
    [cell.contentView addSubview:nameLabel];
    [(UILabel *)[cell.contentView viewWithTag:1] setText:abbrevTitle];
    
    
    UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 20.0, 300.0, 30.0)];
    [statusLabel setTag:2];
    [statusLabel setBackgroundColor:[UIColor clearColor]]; // transparent label background
    [statusLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
    [statusLabel setTextColor:[UIColor grayColor]];
    // custom views should be added as subviews of the cell's contentView:
    [cell.contentView addSubview:statusLabel];
    

    
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
    */
    
	cell.textLabel.text = title;
    cell.detailTextLabel.text = [[[[[NSString stringWithFormat:@"%ld%", (long)downloadedMB] stringByAppendingString:@" MB out of "] stringByAppendingString:[NSString stringWithFormat:@"%ld%", (long)sizeMB]] stringByAppendingString:@" MB, Priority = "] stringByAppendingString:priorityString];
    //cell.detailTextLabel.text = percentDoneString;
    
    
    
    
   /*
    
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
	*/
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
    
    
}








@end
