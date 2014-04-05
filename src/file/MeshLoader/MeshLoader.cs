using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MeshLoader
{
    class MeshLoader
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
