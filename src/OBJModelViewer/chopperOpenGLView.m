//
//  chopperOpenGLView.m
//  OBJModelViewer
//
//  Created by Todd A Previte on 4/28/14.
//  Copyright (c) 2014 Team Choppers. All rights reserved.
//

#import "chopperOpenGLView.h"
#include "trackball.h"

@implementation chopperOpenGLView

//////////////////////////////////////////////////////////////////////
#pragma mark  ==== Interface Functions ====
//////////////////////////////////////////////////////////////////////

// Play nice with the rest of the system
- (BOOL)acceptsFirstResponder	{ return YES; }
- (BOOL)becomeFirstResponder	{ return YES; }
- (BOOL)resignFirstResponder	{ return YES; }

// Select the rendering mode
- (IBAction)selectRenderMode:(id)sender
{
    long mode = [[sender selectedItem] tag];
	
    switch(mode)
    {
		case renderWireframe:
			glGeometryType = GL_LINE_LOOP;
			break;
		case renderSolid:
			glGeometryType = GL_TRIANGLES;
			break;
		default:
			NSLog(@"Error: Illegal rendering mode specified\n");
			break;
    }
}

// Enable or disable lighting
- (IBAction)selectLightEnable:(id)sender
{
    long lightingEnable = [[sender selectedItem] tag];
	// Material
    GLfloat mat_spec[] = {0.5, 0.5, 0.5, 1.0};
    GLfloat mat_shine[] = {0.5};
    // Position
    GLfloat light_pos[] = {0.0, 0.0, -500.0, 0.0};
    // Color
    GLfloat light_color[] = {1.0, 1.0, 1.0, 1.0};
	
    // Material specification commands
    glMaterialfv(GL_FRONT, GL_SPECULAR, mat_spec);
    glMaterialfv(GL_FRONT, GL_SHININESS, mat_shine);
	
    // Light specification commands
    glLightfv(GL_LIGHT0, GL_POSITION, light_pos);
    glLightfv(GL_LIGHT0, GL_DIFFUSE, light_color);
    glLightfv(GL_LIGHT0, GL_SPECULAR, light_color);
    
	// Set camera back to default
	[self resetCameraPosition];

	if (lightingEnable)
	{
		glEnable(GL_LIGHT0);
		glEnable(GL_LIGHTING);
	}
	else
	{
		glDisable(GL_LIGHT0);
		glDisable(GL_LIGHTING);
	}
}

// Select the shading model
- (IBAction)selectShadeModel:(id)sender
{
	ShadeModel sm = (ShadeModel) [[sender selectedItem] tag];

	if (sm == shadingFlat)
		glShadeModel(GL_FLAT);

	if (sm == shadingSmooth)
		glShadeModel(GL_SMOOTH);
}

//////////////////////////////////////////////////////////////////////
#pragma mark  ==== Object Initialization ====
//////////////////////////////////////////////////////////////////////

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		NSOpenGLPixelFormat* nsglFormat;
		NSOpenGLPixelFormatAttribute attr[] =
		{
			NSOpenGLPFANoRecovery,
			NSOpenGLPFADoubleBuffer,
			NSOpenGLPFAAccelerated,
			NSOpenGLPFAColorSize, 32,
			NSOpenGLPFADepthSize, 32,
			NSOpenGLPFAStencilSize, 8,
			0
		};
		
		nsglFormat = [[NSOpenGLPixelFormat alloc] initWithAttributes:attr];
		[self setPixelFormat:nsglFormat];
    }
    return self;
}

- (void)prepareOpenGL
{
    int swapInt = 1;
	// Sync to VBL
    [[self openGLContext] setValues:&swapInt forParameter:NSOpenGLCPSwapInterval];
	
    // Depth Buffer Operations
    glEnable(GL_DEPTH_TEST);
    glDepthFunc(GL_LESS);
	
    // Face culling
    glFrontFace(GL_CCW);
	
    // Vertex Arrays
    glEnableClientState(GL_VERTEX_ARRAY);
    glEnableClientState(GL_NORMAL_ARRAY);
	// Set clear color
	glClearColor(0.0f, 0.0f, 0.0f, 0.0f);

	// Set camera back to default
	[self resetCameraPosition];
}

// awakeFromNib
- (void)awakeFromNib
{
    showNormals = NO;
    showSurfaceNormals = NO;

	glGeometryType = GL_LINE_LOOP;//GL_TRIANGLES;
	renderMode = renderWireframe;

	triCount = vertexCount = normalCount = 0;
	
	memset(&positionVector, 0.0f, sizeof(Vector3D));
	memset(&directionVector, 0.0f, sizeof(Vector3D));
	memset(&upVector, 0.0f, sizeof(Vector3D));
	memset(&worldRotation, 0.0f, sizeof(float)*4);
	memset(&trackballRotation, 0.0f, sizeof(float)*4);
	memset(&modelRotation, 0.0f, sizeof(float)*4);
	memset(&origin, 0.0f, sizeof(Vector3D));

	meshParser = [[omvParser alloc] init];
	theMesh = [meshParser parseObjFile:[meshParser loadObjFile:@"cube.obj"]];
	[self generateVertexArrays];
	
	viewportHeight = viewportWidth = 0;
	cameraAperture = 0.0f;
	objectSize = 10.0f;
	dollyPanStart[0] = dollyPanStart[1] = 0;
	dolly = pan = trackball = FALSE;
	trackingView = nil;

	// Setup the render timer
	renderTimer = [NSTimer timerWithTimeInterval:kFrameTimeInterval
										  target:self
										selector:@selector(updateDisplay:)
										userInfo:nil
										 repeats:YES];
	// Add timer to the main thread
	[[NSRunLoop currentRunLoop] addTimer:renderTimer forMode:NSDefaultRunLoopMode];
	// Set timer to fire during move/resize operations
	[[NSRunLoop currentRunLoop] addTimer:renderTimer forMode:NSEventTrackingRunLoopMode];
	
	[meshControlWindow makeKeyAndOrderFront:self];
	
}
//////////////////////////////////////////////////////////////////////
#pragma mark  ==== Rendering Functions ====
//////////////////////////////////////////////////////////////////////

// Handle updates to the projection matrix - adjusts view and camera
- (void)updateProjection
{
	double ratio, radians, wd2;
	double left, right, top, bottom, near, far;
	
    [[self openGLContext] makeCurrentContext];
	
	// clear projection matrix
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	
	near = -positionVector.z - objectSize * 0.5;
	if (near < 0.00001)
		near = 0.00001;
	
	far = -positionVector.z + objectSize * 0.5;
	if (far < 1.0)
		far = 1.0;
	
	radians = 0.0174532925 * cameraAperture / 2;
	wd2 = near * tan(radians);
	ratio = viewportWidth / (float) viewportHeight;
	if (ratio >= 1.0)
	{
		left  = -ratio * wd2;
		right = ratio * wd2;
		top = wd2;
		bottom = -wd2;
	}
	else
	{
		left  = -wd2;
		right = wd2;
		top = wd2 / ratio;
		bottom = -wd2 / ratio;
	}
	
	// Set the view frustum for OpenGL
	glFrustum(left, right, bottom, top, near, far);
}

// Handle updates to the modelview matrix for the object / world
- (void) updateModelView
{
    [[self openGLContext] makeCurrentContext];

	// Reset modelview matrix
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
	
	gluLookAt (positionVector.x, positionVector.y, positionVector.z,
			   positionVector.x + directionVector.x,
			   positionVector.y + directionVector.y,
			   positionVector.z + directionVector.z,
			   upVector.x, upVector.y, upVector.z);
	
	// FIXME: May not need the trackingView thing here
	if ((trackingView == self) && trackballRotation[0] != 0.0f)
		glRotatef (trackballRotation[0], trackballRotation[1], trackballRotation[2], trackballRotation[3]);

	// Apply the total rotation
	glRotatef(worldRotation[0], worldRotation[1], worldRotation[2], worldRotation[3]);
	// Apply model rotation
	glRotatef(modelRotation[0], modelRotation[1], modelRotation[2], modelRotation[3]);

}

static void drawAxes(float length, Vector3D *origin)
{
	// White for X-axis
	glBegin(GL_LINES);
		glColor3f(1.0f, 1.0f, 1.0f);
		glVertex3d(origin->x - length, origin->y, origin->z);
		glVertex3d(origin->x + length, origin->y, origin->z);
	// Yellow for Y-axis
		glColor3f(1.0f, 0.0f, 0.0f);
		glVertex3d(origin->x, origin->y - length, origin->z);
		glVertex3d(origin->x, origin->y + length, origin->z);
	// Green for the Z-axis
		glColor3f(0.0f, 1.0f, 0.0f);
		glVertex3d(origin->x, origin->y, origin->z - length);
		glVertex3d(origin->x, origin->y, origin->z + length);
	glEnd();
	
}

// drawRect is the main rendering function
- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];

	// FIXME: Test code to verify render loop operation
    static float cc = 0.01f;
	static float inc = 0.01;
	if (cc >= 1.0f)
		inc = -0.01f;
	if (cc <= 0.0f)
		inc = 0.01f;
	cc += inc;

	//glClearColor(cc, cc, cc, 0.0);
	glClearColor(0.2f, 0.2f, 0.2f, 0.2);
	// SNIP: End of test code

	[self updateModelView];
	
    glClearDepth(1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	
	drawAxes(40.0, &origin);

#if 1
	glVertexPointer(3, GL_DOUBLE, 0, vertexList);
	glDrawElements(glGeometryType, (unsigned int)triCount, GL_UNSIGNED_INT, vertexIndices);
#else
	glBegin(GL_TRIANGLES);
	   glColor3f(1.0f, 0.0f, 0.0f);
	   glVertex3d(0.0f, 1.0f, -1.0f);
	   glColor3f(0.0f, 1.0f, 0.0f);
	   glVertex3d(1.0f, 0.0f, -1.0f);
	   glColor3f(0.0f, 0.0f, 1.0f);
	   glVertex3d(-1.0f, 0.0f, -1.0f);
	glEnd();
#endif
	
	[[self openGLContext] flushBuffer];
}

// Refresh the display
- (void)updateDisplay:(NSTimer*)timer
{
	[self drawRect:[self bounds]];
}

// Move / resize the view
- (void)update
{
	[super update];
	[[self openGLContext] makeCurrentContext];
	[[self openGLContext] update];
}

// View has been scrolled, moved or resized
- (void)reshape
{
	NSRect rect = [[self superview] frame];
	
	[super reshape];

	[[self openGLContext] makeCurrentContext];
	[[self openGLContext] update];
	// The superview is the rectangle surrounding our custom OpenGL view
	// The bounds of that determine the bounds of the OpenGL context
	[[self openGLContext] setView:[self superview]];

	viewportWidth = rect.size.width;
	viewportHeight = rect.size.height;
	// Reset the viewport
	glViewport(0, 0, viewportWidth, viewportHeight);
	// Update the projection matrix now
	[self updateProjection];
}

//////////////////////////////////////////////////////////////////////
#pragma mark  ==== App Utilities Functions ====
//////////////////////////////////////////////////////////////////////

- (void)generateVertexArrays
{
	// Convert an array of Vector3 objects into ararys of Vector3D structs (3 floats)
	// Convert an array of NSNumbers (vertex indices) into an array of ints
	int i  = 0, j = 0;
	NSMutableArray *triArray = [NSMutableArray array];
	NSMutableArray *vertArray = [NSMutableArray array];
	
	// Get the total number of triangles and vertices
	for (i = 0; i < [[theMesh caryObjects] count]; i++)
	{
		[triArray addObjectsFromArray:[[[theMesh caryObjects] objectAtIndex:i] getFacesAsTriangles]];
		[vertArray addObjectsFromArray:[[[theMesh caryObjects] objectAtIndex:i] caryv3Vertices]];
	}

	// Vertex index count and vertex count
	triCount = [triArray count];
	vertexCount = [vertArray count];
							   
	// Free memeory since we're building the list
	if (vertexList)
		free(vertexList);
	// Allocate memory for the vertex array
	vertexList = malloc(vertexCount * 3 * sizeof(double));
	
	if (vertexIndices)
		free(vertexIndices);
	// Allocate memory for vertex index array
	vertexIndices = malloc(triCount * 3 * sizeof(int));

	// Copy the vertex indicies
	for (i = 0; i < triCount; i++)
		vertexIndices[i] = [[triArray objectAtIndex:i] intValue];

	// Get the vertices themselves
	for (j = 0; j < vertexCount; j++)
	{
		vertexList[j].x = [(Vector3*) [vertArray objectAtIndex:j] x];
		vertexList[j].y = [(Vector3*) [vertArray objectAtIndex:j] y];
		vertexList[j].z = [(Vector3*) [vertArray objectAtIndex:j] z];
	}
}

//////////////////////////////////////////////////////////////////////
#pragma mark  ==== Mouse Input Section ====
//////////////////////////////////////////////////////////////////////

// Start up the trackball
- (void)mouseDown:(NSEvent *)theEvent
{
	//Control key forces panning, ALT key forces dolly
    if ([theEvent modifierFlags] & NSControlKeyMask)
		[self rightMouseDown:theEvent];
	else if ([theEvent modifierFlags] & NSAlternateKeyMask)
		[self otherMouseDown:theEvent];
	else
	{
		NSPoint location = [self convertPoint:[theEvent locationInWindow] fromView:nil];
		location.y = viewportHeight - location.y;
		dolly = FALSE;
		pan = FALSE;
		trackball = TRUE;
		startTrackball (location.x, location.y, 0, 0, viewportWidth, viewportHeight);
		trackingView = self;
	}
}

// rightMouse is the panning function
- (void)rightMouseDown:(NSEvent *)theEvent
{
	NSPoint location = [self convertPoint:[theEvent locationInWindow] fromView:nil];
	location.y = viewportHeight - location.y;
	if (trackball)
	{
		if (trackballRotation[0] != 0.0)
			addToRotationTrackball (trackballRotation, worldRotation);
		trackballRotation [0] = trackballRotation [1] = trackballRotation [2] = trackballRotation [3] = 0.0f;
	}
	dolly = FALSE;
	pan = TRUE;
	trackball = FALSE;
	dollyPanStart[0] = location.x;
	dollyPanStart[1] = location.y;
	trackingView = self;
}

// Used for the dolly function
- (void)otherMouseDown:(NSEvent *)theEvent
{
	NSPoint location = [self convertPoint:[theEvent locationInWindow] fromView:nil];
	location.y = viewportHeight - location.y;
	if (trackball)
	{
		if (trackballRotation[0] != 0.0)
			addToRotationTrackball (trackballRotation, worldRotation);
		trackballRotation [0] = trackballRotation [1] = trackballRotation [2] = trackballRotation [3] = 0.0f;
	}
	dolly = TRUE;
	pan = FALSE;
	trackball = FALSE;
	dollyPanStart[0] = location.x;
	dollyPanStart[1] = location.y;
	trackingView = self;
}

- (void)mouseUp:(NSEvent *)theEvent
{
	// mouseUps are stop events
	if (dolly)
		dolly = FALSE;
	else if (pan)
		pan = FALSE;
	else if (trackball)
	{
		trackball = FALSE;
		if (trackballRotation[0] != 0.0)
			addToRotationTrackball (trackballRotation, worldRotation);
		trackballRotation [0] = trackballRotation [1] = trackballRotation [2] = trackballRotation [3] = 0.0f;
	}
	trackingView = NULL;
}

- (void)mouseDragged:(NSEvent *)theEvent
{
	NSPoint location = [self convertPoint:[theEvent locationInWindow] fromView:nil];
	location.y = viewportHeight - location.y;
	if (trackball)
		rollToTrackball (location.x, location.y, trackballRotation);
	else if (dolly)
	{
		[self mouseDolly: location];
		[self updateProjection];
	}
	else if (pan)
		[self mousePan: location];
	
	//[self setNeedsDisplay: YES];
}

- (void)scrollWheel:(NSEvent *)theEvent
{
	float wheelDelta = [theEvent deltaX] +[theEvent deltaY] + [theEvent deltaZ];
	
	if (wheelDelta)
	{
		GLfloat deltaAperture = wheelDelta * -cameraAperture / 200.0f;
		cameraAperture += deltaAperture;
		// Aperture must be 0.1 <= aperture < 180.0
		if (cameraAperture < 0.1)
			cameraAperture = 0.1;
		if (cameraAperture > 179.9)
			cameraAperture = 179.9;
		// Adjust projection matrix
		[self updateProjection];
		//[self setNeedsDisplay: YES];
	}
}

-(void)mouseDolly: (NSPoint) location
{
	GLfloat dollyPosition = (dollyPanStart[1] -location.y) * -positionVector.z / 300.0f;
	positionVector.z += dollyPosition;
	if (positionVector.z == 0.0)
		positionVector.z = 0.0001;
	dollyPanStart[0] = location.x;
	dollyPanStart[1] = location.y;
}

- (void)mousePan: (NSPoint) location
{
	GLfloat panX = (dollyPanStart[0] - location.x) / (900.0f / -positionVector.z);
	GLfloat panY = (dollyPanStart[1] - location.y) / (900.0f / -positionVector.z);
	positionVector.x -= panX;
	positionVector.y -= panY;
	dollyPanStart[0] = location.x;
	dollyPanStart[1] = location.y;
}

- (void)rightMouseUp:(NSEvent *)theEvent		{ [self mouseUp:theEvent]; }
- (void)otherMouseUp:(NSEvent *)theEvent		{ [self mouseUp:theEvent]; }
- (void)rightMouseDragged:(NSEvent *)theEvent	{ [self mouseDragged: theEvent]; }
- (void)otherMouseDragged:(NSEvent *)theEvent	{ [self mouseDragged: theEvent]; }

//////////////////////////////////////////////////////////////////////
#pragma mark  ==== Camera / View Functions ====
//////////////////////////////////////////////////////////////////////
// Reset the camera position to default
- (void)resetCameraPosition
{
	cameraAperture = 40.0f;	
	
	positionVector.x = 0.0f;
	positionVector.y = 0.0f;
	positionVector.z = -10.0f;
	
	directionVector.x = -positionVector.x;
	directionVector.y = -positionVector.y;
	directionVector.z = -positionVector.z;
	
	upVector.x = 0.0f;
	upVector.y = 0.1f;
	upVector.z = 0.0f;
}

@end
