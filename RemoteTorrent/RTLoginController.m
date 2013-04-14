//
//  RTLoginController.m
//  RemoteTorrent
//
//  Created by David Engelhardt on 4/12/13.
//  Copyright (c) 2013 David Engelhardt. All rights reserved.
//

#import "RTLoginController.h"

@interface RTLoginController ()

@end

@implementation RTLoginController

NSString* ipAddress;
NSString* port;

@synthesize ipAddressField;
@synthesize portField;
@synthesize staySignedOnSwitch;


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
- (IBAction)logInPressed:(id)sender {
    
    ipAddress = ipAddressField.text;
    port = portField.text;
}

@end
