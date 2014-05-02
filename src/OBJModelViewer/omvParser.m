//
//  omvParser.m
//  OBJModelViewer
//
//  Created by Adam Le on 5/2/14.
//  Copyright (c) 2014 Team Choppers. All rights reserved.
//

#import "omvParser.h"

@implementation omvParser

@synthesize csCurrentMaterialName, cbCurrentSmoothing, cobjCurrentObj;

// the constructor
-(id)init
{
    // set default values
    self.csCurrentMaterialName = @"";
    self.cbCurrentSmoothing = false;
    self.cobjCurrentObj = NULL;
    
    return self;
}

-(NSString*)parseName: (NSMutableArray*) sTokens
{
    NSString *sReturn;
    
    return sReturn;
}
-(NSString*)parseMaterialLibrary: (NSMutableArray*) sTokens
{
    NSString *sReturn;
    
    return sReturn;
}
-(NSString*)parseObjectName: (NSMutableArray*) sTokens
{
    NSString *sReturn;
    
    return sReturn;
}
-(Vector3*)parseVector3: (NSArray*) sTokens
{
    Vector3 *v3Return;
    
    return v3Return;
}

-(bool)parseBool: (NSArray*) sTokens
{
    bool bReturn;
    
    return bReturn;
}

-(NSMutableArray*)parseFaceIndices: (NSArray*) sTokens
{
    NSMutableArray *aryReturn;
    
    return aryReturn;
}

-(omvMesh*)parseObjFile:(NSArray*) arysLines
{
    omvMesh *objMesh;
    int i;
    NSString *sLine;
    NSArray  *arysLineItems;
    NSString *sItem1;
    
    // loop through each line in the array and parse the string
    for(i=0; i<arysLines.count; i++)
    {
        // get the line at index i
        sLine = [arysLines objectAtIndex:i];
        
        // split the line based on the delimiter whitespace
        arysLineItems = [sLine componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        // first item determines the type of data stored on a line
        sItem1 = [arysLineItems objectAtIndex:0];
        
        // switch statment does not use string use if else instead
        if([sItem1 isEqualToString:@"#"])
        {
            // do nothing this is a comment
            continue;
        }
        else if([sItem1 isEqualToString:@"mtllib"])
        {
            [objMesh addMaterialLibrary:[arysLines objectAtIndex:1]];
            continue;
        }
        else if([sItem1 isEqualToString:@"o"])
        {
            self.cobjCurrentObj = [objMesh addObject:[arysLines objectAtIndex:1]];
            
            continue;
        }
        else if([sItem1 isEqualToString:@"v"])
        {
            [self.cobjCurrentObj addVertex:[self parseVector3:arysLineItems]];
            
            continue;
        }
        else if([sItem1 isEqualToString:@"vt"])
        {
            [self.cobjCurrentObj addTextureCoord:[self parseVector3:arysLineItems]];
            
            continue;
        }
        else if([sItem1 isEqualToString:@"vn"])
        {
            [self.cobjCurrentObj addNormalCoord:[self parseVector3:arysLineItems]];
            
            continue;
        }
        else if([sItem1 isEqualToString:@"usemtl"])
        {
            self.csCurrentMaterialName = [self parseName:[arysLineItems objectAtIndex:1]];
            continue;
        }
        else if([sItem1 isEqualToString:@"s"])
        {
            self.cbCurrentSmoothing = [self parseBool:arysLineItems];
            continue;
        }
        else if([sItem1 isEqualToString:@"f"])
        {
            NSMutableArray *aryIndices = [self parseFaceIndices:arysLineItems];
            
            [self.cobjCurrentObj addFace:[aryIndices objectAtIndex:0] Texture:[aryIndices objectAtIndex:1] Normal:[aryIndices objectAtIndex:2] Smoothing:self.cbCurrentSmoothing Material:self.csCurrentMaterialName];
            
            continue;
        }
        else if([sItem1 isEqualToString:@"g"])
        {
            continue;
        }
        else
        {
            NSLog(@"Unsupported type %@ in statement: %d", sItem1, i);
            continue;
        }
    }
    
    return objMesh;
}

-(NSArray*)loadObjFile:(NSString*) sFileName
{
    NSArray *aryReturn;
    NSString *sFileContents;
    
    sFileContents = [NSString stringWithContentsOfFile:sFileName encoding:NSASCIIStringEncoding error:NULL];
    
    aryReturn = [sFileContents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    return aryReturn;
}

@end
