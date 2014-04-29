//
//  chopperOpenGLView.m
//  OBJModelViewer
//
//  Created by Todd A Previte on 4/28/14.
//  Copyright (c) 2014 Team Choppers. All rights reserved.
//

#import "chopperOpenGLView.h"

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
		case renderTextured:
			glGeometryType = GL_TRIANGLES;
			[self initTextureMode];
			break;
		default:
			break;
    }
}

// Enable or disable lighting
- (IBAction)selectLightEnable:(id)sender
{
    long lightingEnable = [[sender selectedItem] tag];
	
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

- (void) prepareOpenGL
{
    int swapInt = 1;
	// Sync to VBL
    [[self openGLContext] setValues:&swapInt forParameter:NSOpenGLCPSwapInterval];
	
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
    
    // Light enablers
    glEnable(GL_LIGHTING);
    glEnable(GL_LIGHT0);
	
    // Default shading model
    glShadeModel(GL_SMOOTH);
	
    // Depth Buffer Operations
    glEnable(GL_DEPTH_TEST);
    glDepthFunc(GL_LESS);
	
    // Face culling
    glFrontFace(GL_CCW);
    glEnable(GL_CULL_FACE);
    glCullFace(GL_FRONT);
	
    // Vertex Arrays
    glEnableClientState(GL_VERTEX_ARRAY);
    glEnableClientState(GL_NORMAL_ARRAY);
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	// Set clear color
	glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
	// Reset matrices
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();

	// Set camera back to default
	[self resetCameraPosition];
}

// awakeFromNib
- (void)awakeFromNib
{
    lastX = lastY = 0.0;
    showNormals = NO;
    showSurfaceNormals = NO;

	glGeometryType = GL_TRIANGLES;
	renderMode = renderWireframe;

	vertexArray		= NULL;
    normalArray		= NULL;
    tcArray			= NULL;
    arrayIndices	= NULL;
	triCount = vertexCount = normalCount = tcCount = 0;
	
	
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
	
}
//////////////////////////////////////////////////////////////////////
#pragma mark  ==== Rendering Functions ====
//////////////////////////////////////////////////////////////////////

// Handle updates to the projection matrix - adjusts view and camera
- (void)updateProjection
{
    [[self openGLContext] makeCurrentContext];
	
	// set projection
	glMatrixMode (GL_PROJECTION);
	glLoadIdentity ();
	
	// Set up the camera here
	
	// Update view frustum here
}

// Handle updates to the modelview matrix for the object / world
- (void) updateModelView
{
    [[self openGLContext] makeCurrentContext];

	// Reset modelview matrix
	glMatrixMode (GL_MODELVIEW);
	glLoadIdentity ();

	// gluLookAt( and/or gluPerspective()
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
		
    glClearDepth(1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
		
	glBegin(GL_TRIANGLES);
	   glColor3f(1.0f, 0.0f, 0.0f);
	   glVertex3d(0.0f, 1.0f, -1.0f);
	   glColor3f(0.0f, 1.0f, 0.0f);
	   glVertex3d(1.0f, 0.0f, -1.0f);
	   glColor3f(0.0f, 0.0f, 1.0f);
	   glVertex3d(-1.0f, 0.0f, -1.0f);
	glEnd();

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

	// Reset the viewport
	glViewport(0, 0, (int) rect.size.width, (int) rect.size.height);
	
	// Clear GL's matrices
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
}

//////////////////////////////////////////////////////////////////////
#pragma mark  ==== App Utilities Functions ====
//////////////////////////////////////////////////////////////////////

// initTextureMode
- (void)initTextureMode
{
    glPixelStorei(GL_UNPACK_ALIGNMENT, 1);
    glGenTextures(1, &textureName);
    glBindTexture(GL_TEXTURE_2D, textureName);
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
	
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, 256, 256, 0, GL_RGB, GL_UNSIGNED_BYTE, textureImage);
}

//////////////////////////////////////////////////////////////////////
#pragma mark  ==== Mouse Input Section ====
//////////////////////////////////////////////////////////////////////

// mouseDragged
- (void)mouseDragged:(NSEvent *)theEvent
{
	NSEventType mouseType;
	NSPoint pt;
	float dx, dy;
	dx = dy = 0.0;
	
	[[self openGLContext] makeCurrentContext];
	pt = [theEvent locationInWindow];
	mouseType = [theEvent type];
	
	dx = lastX - pt.x;
	dy = lastY - pt.y;
	
	// Scroll left/right & up/down on the axes
	if([theEvent modifierFlags] & NSCommandKeyMask)
	{
	    glTranslatef(-dx, 0.0, 0.0);
	    glTranslatef(0.0, dy, 0.0);
	}
	
	// Zoom
	if([theEvent modifierFlags] & NSAlternateKeyMask)
	{
	    glTranslatef(0.0, 0.0, dy);
	}
	else // Rotate around the x & y axes
	{
	    glRotatef(-dx, 0.0, 1.0, 0.0);
	    glRotatef(dy, 1.0, 0.0, 0.0);
	}
	
	lastX = pt.x;
	lastY = pt.y;
}

// rightMouseDragged
- (void)rightMouseDragged:(NSEvent *)theEvent
{
	NSEventType mouseType;
	NSPoint pt;
	float dx, dy;
	dx = dy = 0.0;
	
	[[self openGLContext] makeCurrentContext];
	pt = [theEvent locationInWindow];
	mouseType = [theEvent type];
	
	dx = lastX - pt.x;
	dy = lastY - pt.y;
	
	if([theEvent modifierFlags] & NSCommandKeyMask)
	{
	    // Zoom in or out
	    glTranslatef(0.0, 0.0, dy);
	}
	else
	{
	    // Rotate around the y axis
	    glRotatef((dx + dy), 0.0, 1.0, 0.0);
	}
	
	lastX = pt.x;
	lastY = pt.y;
}

// mouseDown
- (void)mouseDown:(NSEvent*)theEvent
{
    NSPoint loc;
    loc = [theEvent locationInWindow];
    lastX = loc.x;
    lastY = loc.y;
}

// rightMouseDown
- (void)rightMouseDown:(NSEvent*)theEvent
{
    NSPoint loc;
    loc = [theEvent locationInWindow];
    lastX = loc.x;
    lastY = loc.y;
}

//////////////////////////////////////////////////////////////////////
#pragma mark  ==== Camera / View Functions ====
//////////////////////////////////////////////////////////////////////
// Reset the camera position to default
- (void)resetCameraPosition
{
    gluPerspective(60.0, (16.0 / 10.0), 1.0, 1000.0);
    //gluLookAt(0.0, 0.0, 75.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0);
    gluLookAt(0.0, 0.0, 10.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0);
}

@end
