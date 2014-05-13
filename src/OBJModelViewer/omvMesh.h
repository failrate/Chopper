//
//  omvMesh.h
//  OBJModelViewer
//
//  Created by Adam Le on 5/1/14.
//  Copyright (c) 2014 Team Choppers. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Vector2 : NSObject

@property float cfX;
@property float cfY;

-(id)initWithValues: (float)x YValue: (float)y;

@end

@interface Vector3 : NSObject

@property float cfX;
@property float cfY;
@property float cfZ;

-(id)initWithValues: (float)x YValue: (float)y ZValue: (float)z;
-(float)x;
-(float)y;
-(float)z;

@end

@interface omvFace : NSObject

@property BOOL cbUseSmoothing;
@property NSString *csMaterialName;
@property NSMutableArray *caryintVertexIndices;
@property NSMutableArray *caryintTextureIndices;
@property NSMutableArray *caryintNormalIndices;

-(id)init;   // Constructor

@end

@interface omvGroup : NSObject

@property NSString *csName;
@property NSMutableArray *caryFaces;
@property NSMutableArray *caryv3TextCoord;
@property NSMutableArray *caryv3NormalIndices;

-(id)init;

@end

@interface omvObject : NSObject

@property NSString *csName;
@property NSMutableArray *caryGroups;
@property NSMutableArray *caryv3Vertices;
@property omvGroup *cobjGroupCurrent;

-(id)init;   // Constructor
-(void)addVertex: (Vector3*)aryv3Coord;
-(void)addTextureCoord: (Vector3*)aryv3Coord;
-(void)addNormalCoord: (Vector3*)aryv3Coord;
-(void)addFace: (NSMutableArray*)aryintVertexIndices Texture: (NSMutableArray*)aryintTextIndices Normal: (NSMutableArray*)aryintNormalIndices Smoothing: (BOOL)bUseSmoothing Material: (NSString*)sMaterialName;
-(NSMutableArray*)getFacesAsTriangles:(BOOL)sharedVertices;
-(NSMutableArray*)getUVS;
-(void)addGroup: (NSString*) sName;
-(void)ensureCurrentGroup;

@end

@interface omvMesh : NSObject

@property NSMutableArray *caryObjects;
@property NSMutableArray *carystrMaterialLibraries;

-(id)init;
-(omvObject*)addObject: (NSString*)name;
-(void)addMaterialLibrary: (NSString*)name;

@end
