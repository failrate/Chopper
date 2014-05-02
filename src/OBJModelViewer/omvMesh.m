//
//  omvMesh.m
//  OBJModelViewer
//
//  Created by Adam Le on 5/1/14.
//  Copyright (c) 2014 Team Choppers. All rights reserved.
//

#import "omvMesh.h"

@implementation omvFace

@synthesize cbUseSmoothing, csMaterialName, caryintVertexIndices, caryintTextureIndices, caryintNormalIndices;

// face constructor
-(id)init
{
    if (self = [super init])
    {
        // set the default values
        self.cbUseSmoothing = false;
        self.csMaterialName = @"";
    }
    return self;
}

@end

@implementation omvObject

@synthesize csName, caryv3Vertices, caryOmvFaces, caryv3NormalCoord, caryv3TextureCoord;

// Constructor
-(id)init
{
    self.csName = @"";
    self.caryOmvFaces = [[NSMutableArray alloc] init];
    self.caryv3Vertices = [[NSMutableArray alloc] init];
    self.caryv3NormalCoord = [[NSMutableArray alloc] init];
    self.caryv3TextureCoord = [[NSMutableArray alloc] init];
    
    return self;
}

//
-(void)addVertex: (NSMutableArray*)aryv3Coord
{
    // add vertex vector 3
    [self.caryv3Vertices addObject:aryv3Coord];
}

-(void)addTextureCoord: (NSMutableArray*)aryv3Coord
{
    // add texture vector 3
    [self.caryv3TextureCoord addObject:aryv3Coord];
}

-(void)addNormalCoord: (NSMutableArray*)aryv3Coord
{
    // add normal vector 3
    [self.caryv3NormalCoord addObject:aryv3Coord];
}

-(void)addFace: (NSMutableArray*)aryintVertexIndices Texture: (NSMutableArray*)aryintTextIndices Normal: (NSMutableArray*)aryintNormalIndices Smoothing: (BOOL)bUseSmoothing Material: (NSString*)sMaterialName
{
    // create face object
    omvFace *cFace = [[omvFace alloc] init];
    
    // set face object parameters
    cFace.caryintVertexIndices = aryintVertexIndices;
    cFace.caryintTextureIndices = aryintTextIndices;
    cFace.caryintNormalIndices = aryintNormalIndices;
    cFace.cbUseSmoothing = bUseSmoothing;
    cFace.csMaterialName = sMaterialName;
    
    // add the face to the face array
    [self.caryOmvFaces addObject:cFace];
}

-(NSMutableArray*)getFacesAsTriangles
{
    int iTemp;
    NSMutableArray *aryTriangles = [[NSMutableArray alloc] init];
    omvFace *faceTemp;    // pointer to omvFace object
    NSNumber *iNum;
    
    
    for(int i=0; i<self.caryOmvFaces.count; i++)
    {
        faceTemp = [self.caryOmvFaces objectAtIndex:i];
        
        // index 0
        iTemp = [[faceTemp.caryintVertexIndices objectAtIndex:0]intValue];
        iTemp--;
        iNum =[NSNumber numberWithInt:iTemp];
        // add the object to the triangle
        [aryTriangles addObject:iNum];
        
        // index 1
        iTemp = [[faceTemp.caryintVertexIndices objectAtIndex:1]intValue];
        iTemp--;
        iNum =[NSNumber numberWithInt:iTemp];
        // add the object to the triangle
        [aryTriangles addObject:iNum];
        
        // index 2
        iTemp = [[faceTemp.caryintVertexIndices objectAtIndex:2]intValue];
        iTemp--;
        iNum =[NSNumber numberWithInt:iTemp];
        // add the object to the triangle
        [aryTriangles addObject:iNum];
        
        if(faceTemp.caryintVertexIndices.count > 3)
        {
            // index 2
            iTemp = [[faceTemp.caryintVertexIndices objectAtIndex:2]intValue];
            iTemp--;
            iNum =[NSNumber numberWithInt:iTemp];
            // add the object to the triangle
            [aryTriangles addObject:iNum];
            
            // index 3
            iTemp = [[faceTemp.caryintVertexIndices objectAtIndex:3]intValue];
            iTemp--;
            iNum =[NSNumber numberWithInt:iTemp];
            // add the object to the triangle
            [aryTriangles addObject:iNum];
            
            // index 0
            iTemp = [[faceTemp.caryintVertexIndices objectAtIndex:0]intValue];
            iTemp--;
            iNum =[NSNumber numberWithInt:iTemp];
            // add the object to the triangle
            [aryTriangles addObject:iNum];
        }
    }
    
    return aryTriangles;
}

-(NSMutableArray*)getUVS
{
    NSMutableArray *aryv2UVS = [[NSMutableArray alloc] init];
    int iTemp;
    NSMutableArray *aryTriangles = [[NSMutableArray alloc] init];
    omvFace *faceTemp;    // pointer to omvFace object
    NSNumber *iNum;
    
    for(int i=0; i<self.caryOmvFaces.count; i++)
    {
        faceTemp = [self.caryOmvFaces objectAtIndex:i];
        
        // index 0
        iTemp = [[faceTemp.caryintTextureIndices objectAtIndex:0]intValue];
        iTemp--;
        iNum =[NSNumber numberWithInt:iTemp];
        // add the object to the triangle
        [aryTriangles addObject:iNum];
        
        // index 1
        iTemp = [[faceTemp.caryintVertexIndices objectAtIndex:1]intValue];
        iTemp--;
        iNum =[NSNumber numberWithInt:iTemp];
        // add the object to the triangle
        [aryTriangles addObject:iNum];
        
        // index 2
        iTemp = [[faceTemp.caryintVertexIndices objectAtIndex:2]intValue];
        iTemp--;
        iNum =[NSNumber numberWithInt:iTemp];
        // add the object to the triangle
        [aryTriangles addObject:iNum];
        
        if(faceTemp.caryintVertexIndices.count > 3)
        {
            // index 2
            iTemp = [[faceTemp.caryintVertexIndices objectAtIndex:2]intValue];
            iTemp--;
            iNum =[NSNumber numberWithInt:iTemp];
            // add the object to the triangle
            [aryTriangles addObject:iNum];
            
            // index 3
            iTemp = [[faceTemp.caryintVertexIndices objectAtIndex:3]intValue];
            iTemp--;
            iNum =[NSNumber numberWithInt:iTemp];
            // add the object to the triangle
            [aryTriangles addObject:iNum];
            
            // index 0
            iTemp = [[faceTemp.caryintVertexIndices objectAtIndex:0]intValue];
            iTemp--;
            iNum =[NSNumber numberWithInt:iTemp];
            // add the object to the triangle
            [aryTriangles addObject:iNum];
        }
    }
    
    return aryv2UVS;
}
@end

@implementation omvMesh

@end
