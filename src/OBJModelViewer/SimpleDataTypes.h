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
} RenderMode;

typedef enum
{
	shadingFlat = 0,
	shadingSmooth
} ShadeModel;

typedef struct
{
    float x;
    float y;
    float z;
} Point3D;

typedef struct
{
    float r;
    float g;
    float b;
} Color3D;

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
	float r, g, b;
} Color3F;

#endif
