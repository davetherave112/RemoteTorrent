//
//  RTAddTorrentViewController.h
//  RemoteTorrent
//
//  Created by David Engelhardt on 4/18/13.
//  Copyright (c) 2013 David Engelhardt. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RTAddTorrentViewController;
@protocol addTorrentDelegate <NSObject>

-(void) addNewTorrent:(RTAddTorrentViewController*) controller didEnterTorrentURL: (NSString*) torrentURL;

@end

@interface RTAddTorrentViewController : UIViewController

@property (nonatomic, weak) id <addTorrentDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *torrentURL;

@end
