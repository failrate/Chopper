//
//  chopperOpenGLView.h
//  OBJModelViewer
//
//  Created by Todd A Previte on 4/28/14.
//  Copyright (c) 2014 Team Choppers. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <OpenGL/gl.h>
#import <OpenGL/glext.h>
#import <OpenGL/glu.h>
#import "SimpleDataTypes.h"
#import "omvMesh.h"
#import "omvParser.h"

#define kFrameTimeInterval	0.01666666666667

@interface chopperOpenGLView : NSOpenGLView
{
	omvMesh *theMesh;
	omvParser *meshParser;
    NSString *sObjPath;
	
	long triCount;
	long vertexCount;
	long normalCount;
	long normalLineCount;

	// Main vertex list for use with OpenGL
    Vector3D *vertexList;
	unsigned int *vertexIndices;
	// Normal array (used when enabling lighting)
	Vector3D *normalArray;
	// Array of lines used to draw normals
	Vector3D *normalVectorLines;
	unsigned int *normalLineIndices;
	// Color array to add contrast to vertices
	Color3F *colorList;
	
    // Framerate timers
    NSTimer *renderTimer;

    // Rendering mode variable
	GLuint glGeometryType;
	RenderMode renderMode;

	// Viewport / camera
	unsigned int viewportHeight, viewportWidth;
	Vector3D positionVector, directionVector, upVector;
 	double cameraAperture;
	double objectSize;
	
	// Converted from Cocoa OpenGL
	int dollyPanStart[2];
	float trackballRotation[4], modelRotation[4], worldRotation[4];
	BOOL dolly, pan, trackball;
	Vector3D origin ;

    // Display flags
    BOOL showNormals;
    BOOL showSurfaceNormals;
	BOOL drawAxisLines;
	
	IBOutlet NSWindow *meshControlWindow;
	IBOutlet NSPopUpButton *buttonLightingEnable;
	IBOutlet NSPopUpButton *buttonShadingModel;
	IBOutlet NSButton *buttonDrawAxisLines;
}

// Interface actions for adjusting the rendering
-(IBAction)selectRenderMode:(id)sender;
-(IBAction)selectLightEnable:(id)sender;
-(IBAction)selectShadeModel:(id)sender;
-(IBAction)selectShowSurfaceNormals:(id)sender;
-(IBAction)selectDrawAxisLines:(id)sender;
// Interface for selecting the obj file
-(IBAction)selectObjFile:(id)sender;
-(IBAction)selectPopUpObj:(id)sender;
// Camera sliding on the Z axis
-(void)mouseDolly:(NSPoint)location;
// Camera sliding in the X/Y plane
-(void)mousePan:(NSPoint)location;
// Internal functions for building arrays and normals
-(void)generateVertexArrays;
-(void)generateSurfaceNormals;
-(void)loadObjFile;

@end
