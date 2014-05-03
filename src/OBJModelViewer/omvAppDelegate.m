//
//  omvAppDelegate.m
//  OBJModelViewer
//
//  Created by Todd A Previte on 4/28/14.
//  Copyright (c) 2014 Team Choppers. All rights reserved.
//

#import "omvAppDelegate.h"
#import "omvParser.h"

@implementation omvAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSArray *aryFileContents;
    
	// Insert code here to initialize your application
    omvParser *objParser = [[omvParser alloc] init];
    
    aryFileContents = [objParser loadObjFile:@"/Users/bbgirl_al/projects/Chopper/data/cube.obj"];
    
    omvMesh *objMesh;
    objMesh = [objParser parseObjFile:aryFileContents];
    
    int i =0;
    i++;
}

@end
