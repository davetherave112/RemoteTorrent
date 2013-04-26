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

//NSString* username;
//NSString* password;

//NSArray* credentialsArray;

@synthesize usernameField;
@synthesize passwordField;
@synthesize staySignedOnSwitch;
@synthesize loginActivity;
@synthesize loginButton;


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
    
    //username = usernameField.text;
    //password = passwordField.text;
    
    NSArray *credentialsArray = [NSArray arrayWithObjects:usernameField.text, passwordField.text, [NSNumber numberWithBool:staySignedOnSwitch.on], nil];
    
    
    [self.delegate loginToBittorrent:self didEnterCredentials:credentialsArray];
    
}
- (IBAction)logInButtonPressed:(id)sender {
    
    [loginButton setTitleColor:[UIColor clearColor] forState:UIControlStateSelected];
    [loginButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    [loginActivity startAnimating];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        NSArray *credentialsArray = [NSArray arrayWithObjects:usernameField.text, passwordField.text, [NSNumber numberWithBool:staySignedOnSwitch.on], nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.delegate loginToBittorrent:self didEnterCredentials:credentialsArray];
            
        });
        
    });
    
    
}
- (IBAction)loginCancel:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
/*
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
*/
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    //do whatever you need here
    //maybe you have several textFields, so first check which one was hit the return key:
    if(textField == usernameField){
        //do this
    }
    else if(textField == passwordField)
    {
        for (UIView* view in self.view.subviews) {
            if ([view isKindOfClass:[UITextField class]])
                [view resignFirstResponder];
        }
    
    }

}

// Dismiss keyboard when touching elsewhere on screen
- (void)touchesEnded: (NSSet *)touches withEvent: (UIEvent *)event {
    for (UIView* view in self.view.subviews) {
        if ([view isKindOfClass:[UITextField class]])
            [view resignFirstResponder];
    }
}

@end
