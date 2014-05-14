//
//  omvMesh.m
//  OBJModelViewer
//
//  Created by Adam Le on 5/1/14.
//  Copyright (c) 2014 Team Choppers. All rights reserved.
//

#import "omvMesh.h"

// vector class of length 2 x and y
@implementation Vector2 : NSObject

@synthesize cfX, cfY;

-(id)initWithValues: (float)x YValue: (float)y
{
    cfX = x;
    cfY = y;
    return self;
}

@end

// vector class of length 3 x, y and z
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

// stores the face information retrieved from the OBJ file

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

// stores the group information from the oBJ file
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

// storese the completely OBJ file and its various data structure
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

// add a vertex to the array of vertices
-(void)addVertex: (Vector3*)aryv3Coord
{
    // add vertex vector 3
    [self.caryv3Vertices addObject:aryv3Coord];
}

// add a texture to the array of textures
-(void)addTextureCoord: (Vector3*)aryv3Coord
{
    // add texture vector 3
    [self.cobjGroupCurrent.caryv3TextCoord addObject:aryv3Coord];
}

// add a normal vector to the array of  normal indicies
-(void)addNormalCoord: (Vector3*)aryv3Coord
{
    // add normal vector 3
    [self.cobjGroupCurrent.caryv3NormalIndices addObject:aryv3Coord];
}

// create a face structure and add it to the arry of faces
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

// check that the current group has bee initialized
-(void)ensureCurrentGroup
{
    if(self.cobjGroupCurrent == NULL)
    {
        // current group is null create a default group and add it
        [self addGroup:@"default"];
    }
}

// returns the faces as an array  or triangles
-(NSMutableArray*)getFacesAsTriangles:(BOOL)sharedVertices
{
    int iTemp, i, j;
    NSMutableArray *aryTriangles = [[NSMutableArray alloc] init];
    omvFace *faceTemp;    // pointer to omvFace object
    NSNumber *iNum;
    omvGroup *grpTemp;
    
    // loop through all the groups in the object structure
    for(j=0; j<self.caryGroups.count; j++)
    {
        // get the object
        grpTemp = [self.caryGroups objectAtIndex:j];
        
        // loop through all the faces
        for(i=0; i<grpTemp.caryFaces.count; i++)
        {
            faceTemp = [grpTemp.caryFaces objectAtIndex:i];
            
            // check if the vertices are shared
			if (sharedVertices)
			{
				if (faceTemp.caryintVertexIndices.count == 4) 
				{
                    // compute the triangles for the face
					iNum = [NSNumber numberWithInt:[[faceTemp.caryintVertexIndices objectAtIndex:0] intValue]-1];
					[aryTriangles addObject:iNum];
					iNum = [NSNumber numberWithInt:[[faceTemp.caryintVertexIndices objectAtIndex:1] intValue]-1];
					[aryTriangles addObject:iNum];
					iNum = [NSNumber numberWithInt:[[faceTemp.caryintVertexIndices objectAtIndex:2] intValue]-1];
					[aryTriangles addObject:iNum];
					
                    // compute the triangles for the face
					iNum = [NSNumber numberWithInt:[[faceTemp.caryintVertexIndices objectAtIndex:2] intValue]-1];
					[aryTriangles addObject:iNum];
					iNum = [NSNumber numberWithInt:[[faceTemp.caryintVertexIndices objectAtIndex:3] intValue]-1];
					[aryTriangles addObject:iNum];
					iNum = [NSNumber numberWithInt:[[faceTemp.caryintVertexIndices objectAtIndex:0] intValue]-1];
					[aryTriangles addObject:iNum];
				}
				else
				{
					// Assume 3 vertices and use in correct order
					iNum = [NSNumber numberWithInt:[[faceTemp.caryintVertexIndices objectAtIndex:0] intValue]-1];
					[aryTriangles addObject:iNum];
					iNum = [NSNumber numberWithInt:[[faceTemp.caryintVertexIndices objectAtIndex:1] intValue]-1];
					[aryTriangles addObject:iNum];
					iNum = [NSNumber numberWithInt:[[faceTemp.caryintVertexIndices objectAtIndex:2] intValue]-1];
					[aryTriangles addObject:iNum];
				}
			}
			else
			{
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
    }
    
    return aryTriangles;
}


// code is needed if texture is required
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

// add a group to the ojbect
-(void)addGroup: (NSString*)sName
{
    omvGroup *objGroup = [[omvGroup alloc] init];
    objGroup.csName = sName;
    [self.caryGroups addObject:objGroup];
    self.cobjGroupCurrent = objGroup;
    
}
@end

/*
* Class used to store all data for loaded OBJ files
* Requirement 3.2.1 and 3.2.2
*
*/
// mesh that has an array of objects and material libraries
@implementation omvMesh

@synthesize caryObjects, carystrMaterialLibraries;

-(id)init
{
    // allocate memory for the objects
    self.caryObjects = [[NSMutableArray alloc] init];
    self.carystrMaterialLibraries = [[NSMutableArray alloc] init];
    
    return self;
}

// add an object to the mesh
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
