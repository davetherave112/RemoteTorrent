//
//  RTLoginController.h
//  RemoteTorrent
//
//  Created by David Engelhardt on 4/12/13.
//  Copyright (c) 2013 David Engelhardt. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RTLoginController;
@protocol loginToBittorrentDelegate <NSObject>

-(void) loginToBittorrent:(RTLoginController*) controller didEnterCredentials: (NSArray*) loginCredentials;

@end

@interface RTLoginController : UIViewController <UITextFieldDelegate>

@property (nonatomic, weak) id <loginToBittorrentDelegate> delegate;

/*@property (strong, nonatomic) IBOutlet UITextField *usernameField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
 */


@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loginActivity;

@property (strong, nonatomic) IBOutlet UISwitch *staySignedOnSwitch;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end
