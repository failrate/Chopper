using System;
using System.Collections.Generic;
using OpenTK;
namespace MeshLoader
{
    class Mesh
    {
        public List<Vector3> vertexList;
        public List<uint[]> indexList;
        public List<Vector3> normalList;
    };
}
