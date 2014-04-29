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
	
	// Mouse movement coordinates
	float lastX, lastY;
	
    // Display flags
    BOOL showNormals;
    BOOL showSurfaceNormals;
}
// Interface actions for adjusting the rendering
- (IBAction)selectRenderMode:(id)sender;
- (IBAction)selectLightEnable:(id)sender;
- (IBAction)selectShadeModel:(id)sender;

@end
