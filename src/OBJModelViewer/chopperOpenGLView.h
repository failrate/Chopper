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

#define kFrameTimeInterval	0.01666666666667

@interface chopperOpenGLView : NSOpenGLView
{
	// Texture informatiom
    GLbyte *textureImage;
    GLuint textureName;
    
	// Triangle and vertex lists
    Triangle *triList;
	long triCount;
    Vertex3D *vertexList;
	long vertexCount;
    
	float *vertexArray;
    float *normalArray;
    float *tcArray;
    long *arrayIndices;
	long normalCount;
	long tcCount;
	
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
	
	// Mouse movement coordinates
	//float lastX, lastY;
	
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

@end
