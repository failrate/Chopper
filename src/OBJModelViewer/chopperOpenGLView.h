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
	
	long triCount;
	long vertexCount;
	
    Vector3D *vertexList;
	unsigned int *vertexIndices;

	float *normalArray; // unused right now
	long normalCount;	// unused right now
	
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
	chopperOpenGLView *trackingView;
	Vector3D origin ;

    // Display flags
    BOOL showNormals;
    BOOL showSurfaceNormals;
}
// Interface actions for adjusting the rendering
- (IBAction)selectRenderMode:(id)sender;
- (IBAction)selectLightEnable:(id)sender;
- (IBAction)selectShadeModel:(id)sender;

// Camera sliding on the Z axis
-(void)mouseDolly:(NSPoint)location;
// Camera sliding in the X/Y plane
- (void)mousePan:(NSPoint)location;

- (void)generateVertexArrays;
@end
