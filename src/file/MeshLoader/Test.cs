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
            MeshLoader ml = new MeshLoader();
            ChopperMesh mesh = ml.loadMeshFromFile(args[0]);
            // \todo: validate that the test mesh data structure matches the expected value
            
            Console.ReadKey(); // pause
        }
    }
}
