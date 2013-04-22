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

@interface RTLoginController : UIViewController

@property (nonatomic, weak) id <loginToBittorrentDelegate> delegate;

/*@property (strong, nonatomic) IBOutlet UITextField *usernameField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
 */



@property (strong, nonatomic) IBOutlet UISwitch *staySignedOnSwitch;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end
