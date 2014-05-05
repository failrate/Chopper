//
//  omvMesh.m
//  OBJModelViewer
//
//  Created by Adam Le on 5/1/14.
//  Copyright (c) 2014 Team Choppers. All rights reserved.
//

#import "omvMesh.h"

@implementation Vector2 : NSObject

@synthesize cfX, cfY;

-(id)initWithValues: (float)x YValue: (float)y
{
    cfX = x;
    cfY = y;
    return self;
}

@end

@implementation Vector3 : NSObject

@synthesize cfX, cfY, cfZ;

-(id)initWithValues: (float)x YValue: (float)y ZValue: (float)z
{
    cfX = x;
    cfY = y;
    cfZ = z;
    return self;
}
-(float)x	{ return cfX; }
-(float)y	{ return cfY; }
-(float)z	{ return cfZ; }

@end

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

@implementation omvGroup

@synthesize csName, caryFaces, caryv3TextCoord, caryv3NormalIndices;

-(id)init;
{
    self.csName = @"";
    self.caryFaces = [[NSMutableArray alloc] init];
    self.caryv3TextCoord = [[NSMutableArray alloc] init];
    self.caryv3NormalIndices = [[NSMutableArray alloc] init];
    
    return self;
}

@end

@implementation omvObject

@synthesize csName, caryv3Vertices, caryGroups, cobjGroupCurrent;

// Constructor
-(id)init
{
    self.csName = @"";
    self.caryv3Vertices = [[NSMutableArray alloc] init];
    self.caryGroups = [[NSMutableArray alloc] init];
    self.cobjGroupCurrent = NULL;
    
    return self;
}

//
-(void)addVertex: (Vector3*)aryv3Coord
{
    // add vertex vector 3
    [self.caryv3Vertices addObject:aryv3Coord];
}

-(void)addTextureCoord: (Vector3*)aryv3Coord
{
    // add texture vector 3
    [self.cobjGroupCurrent.caryv3TextCoord addObject:aryv3Coord];
}

-(void)addNormalCoord: (Vector3*)aryv3Coord
{
    // add normal vector 3
    [self.cobjGroupCurrent.caryv3NormalIndices addObject:aryv3Coord];
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
    [self ensureCurrentGroup];
    // add the face to the face array
    [self.cobjGroupCurrent.caryFaces addObject:cFace];
}

-(void)ensureCurrentGroup
{
    if(self.cobjGroupCurrent == NULL)
    {
        [self addGroup:@"default"];
    }
}

-(NSMutableArray*)getFacesAsTriangles
{
    int iTemp, i, j;
    NSMutableArray *aryTriangles = [[NSMutableArray alloc] init];
    omvFace *faceTemp;    // pointer to omvFace object
    NSNumber *iNum;
    omvGroup *grpTemp;
    
    for(j=0; j<self.caryGroups.count; j++)
    {
        grpTemp = [self.caryGroups objectAtIndex:j];
        
        for(i=0; i<grpTemp.caryFaces.count; i++)
        {
            faceTemp = [grpTemp.caryFaces objectAtIndex:i];
            
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
    }
    
    return aryTriangles;
}

-(NSMutableArray*)getUVS
{
    NSMutableArray *aryv2UVS = [[NSMutableArray alloc] init];
    /*
    Vector2 *v2Textures;
    omvFace *faceTemp;    // pointer to omvFace object
    NSNumber *iNum;
    
    for(int i=0; i<self.caryOmvFaces.count; i++)
    {
        faceTemp = [self.caryOmvFaces objectAtIndex:i];
        v2Textures = [[Vector2 alloc] initWithValues:0.0f YValue:0.0f];
        
        
        
        [aryv2UVS addObject:v2Textures];
    }*/
    
    return aryv2UVS;
}

-(void)addGroup: (NSString*)sName
{
    omvGroup *objGroup = [[omvGroup alloc] init];
    objGroup.csName = sName;
    [self.caryGroups addObject:objGroup];
    self.cobjGroupCurrent = objGroup;
    
}
@end

@implementation omvMesh

@synthesize caryObjects, carystrMaterialLibraries;

-(id)init
{
    // allocate memory for the objects
    self.caryObjects = [[NSMutableArray alloc] init];
    self.carystrMaterialLibraries = [[NSMutableArray alloc] init];
    
    return self;
}

-(omvObject*)addObject: (NSString*)name
{
    omvObject *objReturn = [[omvObject alloc] init];
    
    // set the name of the object
    objReturn.csName = name;
    
    // add the object to the array
    [self.caryObjects addObject:objReturn];
    
    return objReturn;
}

-(void)addMaterialLibrary: (NSString*)name
{
    [self.carystrMaterialLibraries addObject:name];
}

@end
