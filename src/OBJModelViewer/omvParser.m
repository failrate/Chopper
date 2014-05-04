//
//  omvParser.m
//  OBJModelViewer
//
//  Created by Adam Le on 5/2/14.
//  Copyright (c) 2014 Team Choppers. All rights reserved.
//

#import "omvParser.h"

@implementation omvParser

@synthesize csCurrentMaterialName, cbCurrentSmoothing, cobjCurrentObj, cobjMesh;

// the constructor
-(id)init
{
    // set default values
    self.csCurrentMaterialName = @"";
    self.cbCurrentSmoothing = false;
    self.cobjCurrentObj = NULL;
    self.cobjMesh = NULL;
    
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
    Vector3 *v3Return = [[Vector3 alloc] init];
    
    v3Return.cfX = [[sTokens objectAtIndex:1] floatValue];
    v3Return.cfY = [[sTokens objectAtIndex:2] floatValue];
    
    // in the case of uv coordinates the third element is optional
    if(sTokens.count > 3)
        v3Return.cfZ = [[sTokens objectAtIndex:3] floatValue];
    else
        v3Return.cfZ = 0.0f;
    
    return v3Return;
}

-(bool)parseBool: (NSArray*) sTokens
{
    NSString *sValue = [sTokens objectAtIndex:1];
    
    // determine what the boolean value should be based on the english string
    if([sValue isEqualToString:@"yes"] || [sValue isEqualToString:@"on"] || [sValue isEqualToString:@"1"])
        return true;
    else
        return false;
}

-(NSMutableArray*)parseFaceIndices: (NSArray*) sTokens
{
    int i, j, k, iCount;
    bool bFirst;
    NSMutableArray *aryReturn = [[NSMutableArray alloc] init];
    NSMutableArray *aryTemp;
    NSMutableArray *aryTemp2;
    
    for(i=0; i < 3; i++)
    {
        aryTemp = [[NSMutableArray alloc] init];
        [aryReturn addObject:aryTemp];
    }
    
    iCount = 0;
    bFirst = true;
    
    for(j=0; j<sTokens.count; j++)
    {
        if(bFirst)
        {
            bFirst = false;
            continue;
        }
        
        NSString *sTemp =[sTokens objectAtIndex:j];
        NSArray *arySubTokens = [sTemp componentsSeparatedByString:@"/"];
        
        for(k=0; k<arySubTokens.count; k++)
        {
            aryTemp2 = [aryReturn objectAtIndex:iCount];
            [aryTemp2 addObject:[arySubTokens objectAtIndex:k]];
            iCount++;
        }
        
        iCount = 0;
    }
    
    return aryReturn;
}

-(void)ensureCurrentObject
{
    if(cobjCurrentObj == nil)
    {
        self.cobjCurrentObj = [self.cobjMesh addObject:@"default"];
        
    }
}

-(omvMesh*)parseObjFile:(NSArray*) arysLines
{
    self.cobjMesh = [[omvMesh alloc] init];
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
            NSLog(@"#");
            continue;
        }
        else if([sItem1 isEqualToString:@"mtllib"])
        {
            NSLog(@"mtlib");
            [self.cobjMesh addMaterialLibrary:[arysLineItems objectAtIndex:1]];
            continue;
        }
        else if([sItem1 isEqualToString:@"o"])
        {
            NSLog(@"o");
            self.cobjCurrentObj = [self.cobjMesh addObject:[arysLineItems objectAtIndex:1]];
            continue;
        }
        else if([sItem1 isEqualToString:@"v"])
        {
            [self ensureCurrentObject];
            NSLog(@"v");
            [self.cobjCurrentObj addVertex:[self parseVector3:arysLineItems]];
            
            continue;
        }
        else if([sItem1 isEqualToString:@"vt"])
        {
            [self ensureCurrentObject];
            NSLog(@"vt");
            [self.cobjCurrentObj addTextureCoord:[self parseVector3:arysLineItems]];
            
            continue;
        }
        else if([sItem1 isEqualToString:@"vn"])
        {
            [self ensureCurrentObject];
            NSLog(@"vn");
            [cobjCurrentObj addNormalCoord:[self parseVector3:arysLineItems]];
            
            continue;
        }
        else if([sItem1 isEqualToString:@"usemtl"])
        {
            NSLog(@"usemtl");
            csCurrentMaterialName = [self parseName:[arysLineItems objectAtIndex:1]];
            continue;
        }
        else if([sItem1 isEqualToString:@"s"])
        {
            NSLog(@"s");
            cbCurrentSmoothing = [self parseBool:arysLineItems];
            continue;
        }
        else if([sItem1 isEqualToString:@"f"])
        {
            [self ensureCurrentObject];
            NSLog(@"f");
            NSMutableArray *aryIndices = [self parseFaceIndices:arysLineItems];
            
            [self.cobjCurrentObj addFace:[aryIndices objectAtIndex:0] Texture:[aryIndices objectAtIndex:1] Normal:[aryIndices objectAtIndex:2] Smoothing:self.cbCurrentSmoothing Material:self.csCurrentMaterialName];
            
            continue;
        }
        else if([sItem1 isEqualToString:@"g"])
        {
            //[self ensureCurrentObject];
            NSLog(@"g");
            //[cobjCurrentObj addGroup:[arysLineItems objectAtIndex:1]];
            continue;
        }
        else
        {
            NSLog(@"Unsupported type %@ in statement: %d", sItem1, i);
            continue;
        }
    }
    
    return cobjMesh;
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
