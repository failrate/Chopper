//
//  omvParser.h
//  OBJModelViewer
//
//  Created by Adam Le on 5/2/14.
//  Copyright (c) 2014 Team Choppers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "omvMesh.h"

@interface omvParser : NSObject

@property NSString  *csCurrentMaterialName;
@property bool       cbCurrentSmoothing;
@property omvObject *cobjCurrentObj;
@property omvMesh   *cobjMesh;

-(id)init;
-(NSString*)parseName:              (NSMutableArray*) sTokens;
-(NSString*)parseMaterialLibrary:   (NSMutableArray*) sTokens;
-(NSString*)parseObjectName:        (NSMutableArray*) sTokens;
-(Vector3*)parseVector3:            (NSArray*) sTokens;
-(bool)parseBool:                   (NSArray*) sTokens;
-(NSMutableArray*)parseFaceIndices: (NSArray*) sTokens;
-(void)ensureCurrentObject;
-(omvMesh*)parseObjFile:            (NSArray*) arysLines;
-(NSArray*)loadObjFile:             (NSString*) sFileName;

@end
