//
//  SimpleDataTypes.h
//  MeshRenderer
//
//  Created by Todd A Previte on 4/27/14.
//  Copyright (c) 2014 Team Choppers. All rights reserved.
//

#ifndef MeshRenderer_SimpleDataTypes_h
#define MeshRenderer_SimpleDataTypes_h

#include <OpenGL/OpenGL.h>
#include <OpenGL/gl.h>
#include <OpenGL/glu.h>
#include <OpenGL/glext.h>

typedef enum
{
    renderWireframe	= 0,
    renderSolid,
    renderTextured
} RenderMode;

typedef enum
{
	shadingFlat = 0,
	shadingSmooth,
} ShadeModel;

typedef struct
{
    float x;
    float y;
    float z;
} Point3D;

typedef struct
{
    float x;
    float y;
} Point2D;

typedef struct
{
    float r;
    float g;
    float b;
} Color3D;

typedef struct
{
    float r;
    float g;
    float b;
    float a;
} Color4D;

typedef struct
{
    float x, y, z;
} Normal3D;

typedef struct
{
    double x, y, z;
} Vector3D;

typedef struct
{
    float		x, y, z;
    Normal3D 	normal;
    long		usedBy[32];
    long		useCount;
} Vertex3D;

typedef struct
{
    short s, t;
} TexCoord2S;

typedef struct
{
    float s, t;
} TexCoord2F;

typedef struct
{
    long		index;
    long		vtxIndex[3];
    Normal3D	surfaceNormal;
    TexCoord2F	tc[3];
} Triangle;

#endif
