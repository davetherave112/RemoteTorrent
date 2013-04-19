//
//  RTAddTorrentViewController.m
//  RemoteTorrent
//
//  Created by David Engelhardt on 4/18/13.
//  Copyright (c) 2013 David Engelhardt. All rights reserved.
//

#import "RTAddTorrentViewController.h"

@interface RTAddTorrentViewController ()

@end

@implementation RTAddTorrentViewController

@synthesize torrentURL;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)cancelView:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)saveNewTorrent:(id)sender {
    
    // DO STUFF TO ADD TORRENT
    
    NSString *addTorrentURLString = torrentURL.text;
    
    [self.delegate addNewTorrent:self didEnterTorrentURL:addTorrentURLString];
    
}

@end
