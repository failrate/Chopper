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

@end

@interface omvFace : NSObject

@property BOOL cbUseSmoothing;
@property NSString *csMaterialName;
@property NSMutableArray *caryintVertexIndices;
@property NSMutableArray *caryintTextureIndices;
@property NSMutableArray *caryintNormalIndices;

-(id)init;   // Constructor

@end

@interface omvObject : NSObject

@property NSString *csName;
@property NSMutableArray *caryOmvFaces;
@property NSMutableArray *caryv3Vertices;
@property NSMutableArray *caryv3TextureCoord;
@property NSMutableArray *caryv3NormalCoord;

-(id)init;   // Constructor
-(void)addVertex: (Vector3*)aryv3Coord;
-(void)addTextureCoord: (Vector3*)aryv3Coord;
-(void)addNormalCoord: (Vector3*)aryv3Coord;
-(void)addFace: (NSMutableArray*)aryintVertexIndices Texture: (NSMutableArray*)aryintTextIndices Normal: (NSMutableArray*)aryintNormalIndices Smoothing: (BOOL)bUseSmoothing Material: (NSString*)sMaterialName;
-(NSMutableArray*)getFacesAsTriangles;
-(NSMutableArray*)getUVS;

@end

@interface omvMesh : NSObject

@property NSMutableArray *caryObjects;
@property NSMutableArray *carystrMaterialLibraries;

-(id)init;
-(omvObject*)addObject: (NSString*)name;
-(void)addMaterialLibrary: (NSString*)name;

@end
