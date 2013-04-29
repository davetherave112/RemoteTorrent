//
//  Viewer.m
//  DropboxTest
//
//  Created by Ashwin Ramachandran on 4/26/13.
//  Copyright (c) 2013 Ashwin Ramachandran. All rights reserved.
//

#import "Viewer.h"

@interface Viewer ()

@end

@implementation Viewer

@synthesize loc;

- (id)initWithLoc:(NSString *)theLoc
{
    if (self = [super init]) {
        loc = theLoc;
        self.dataSource = self;
    }
    else
        return nil;
    
    return self;
}

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
}

- (BOOL)isPlayableVideo
{
    NSString *ext = [loc pathExtension]; // the extension of the file
    
    BOOL isVideo = false;
    if ([ext isEqualToString:@"mov"] || [ext isEqualToString:@"mp4"] || [ext isEqualToString:@"m4v"])
        isVideo = true;
    
    BOOL cantPreview = [QLPreviewController canPreviewItem:[NSURL fileURLWithPath:loc]];
    
    return (cantPreview && isVideo);
}

#pragma mark - QLPreview datasource methods

- (NSInteger) numberOfPreviewItemsInPreviewController: (QLPreviewController *) controller
{
    return 1;
}

- (id <QLPreviewItem>) previewController: (QLPreviewController *) controller previewItemAtIndex: (NSInteger) index
{
    return [NSURL fileURLWithPath:loc];
}

@end
