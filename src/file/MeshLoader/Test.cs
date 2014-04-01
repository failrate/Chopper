using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MeshLoader
{
    class Test
    {
        public static void Main(string[] args)
        {
            // instantiate a MeshLoader
            MeshParser mp = new MeshParser();
            string[] data = mp.loadObjFile(args[0]);
            // load the test file into a mesh data structure
            ChopperMesh mesh = mp.parseObjFile(data);
            Console.ReadKey();
            // \todo: validate that the test mesh data structure matches the expected value
        }
    }
}
