//
//  RTLoginController.h
//  RemoteTorrent
//
//  Created by David Engelhardt on 4/12/13.
//  Copyright (c) 2013 David Engelhardt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RTLoginController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *ipAddressField;
@property (weak, nonatomic) IBOutlet UITextField *portField;
@property (weak, nonatomic) IBOutlet UISwitch *staySignedOnSwitch;

@end
