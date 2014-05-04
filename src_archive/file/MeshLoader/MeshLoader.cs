using System;
using System.Collections.Generic;
using System.Text;

namespace MeshLoader
{
    public class MeshLoader
    {
        public MeshLoader() { }
        public ChopperMesh loadMeshFromFile(string filename)
        {
            MeshParser mp = new MeshParser();
            string[] data = mp.loadObjFile(filename);
            // load the test file into a mesh data structure
            ChopperMesh mesh = mp.parseObjFile(data);
            return mesh;
        }
    }
}
