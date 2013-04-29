//
//  Viewer.h
//  DropboxTest
//
//  Created by Ashwin Ramachandran on 4/26/13.
//  Copyright (c) 2013 Ashwin Ramachandran. All rights reserved.
//

#import <QuickLook/QuickLook.h>
#import <Dropbox/Dropbox.h>

@interface Viewer : QLPreviewController <QLPreviewControllerDataSource>

@property (nonatomic, strong) NSString *loc;

- (id)initWithLoc:(NSString *)theLoc;
- (BOOL)isPlayableVideo;

@end
