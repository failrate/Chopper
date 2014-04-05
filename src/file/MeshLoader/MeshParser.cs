using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using OpenTK;

namespace MeshLoader
{
    
    class MeshParser
    {
        // state holders
        string currentMaterialName = "";
        bool currentSmoothing = false;
        ChopperObject currentObject = null;
        public string parseName(string[] tokens)
        {
            return tokens[1];
        }
        public string parseMaterialLibrary(string[] tokens)
        {
            return parseName(tokens); // \todo?: load the whole mtl file and parse it?
        }
        public string parseObjectName(string[] tokens)
        {
            return parseName(tokens);
        }
        public Vector3 parseVector3(string[] tokens)
        {
            return new Vector3((float)(Convert.ToDouble(tokens[1])),(float)(Convert.ToDouble(tokens[2])),(float)(Convert.ToDouble(tokens[3])));
        }
        public bool parseBool(string[] tokens)
        {
            switch (tokens[1])
            {
                case "yes":
                case "on":
                case "1":
                    return true;
                default:
                    return false;
            }
        }
        public List<List<uint>> parseFaceIndices(string[] tokens)
        {
            List<List<uint>> indices = new List<List<uint>>();
            for (int index = 0; index < 3; index++)
            {
                indices.Add(new List<uint>());
            }
            int count = 0;
            bool first = true;
            foreach (string token in tokens)
            {
                if (first) // skip the 'f' in the tokens
                {
                    first = false;
                    continue;
                }
                string[] subTokens = token.Split('/');
                foreach (string subToken in subTokens)
                {
                    indices[count].Add(Convert.ToUInt32(subToken));
                    count++;
                }
                count = 0;
            }
            return indices;
        }
        public ChopperMesh parseObjFile(string[] lines)
        {
            ChopperMesh mesh = new ChopperMesh();
            foreach (string line in lines)
            {
                string[] tokens = line.Split();
                string type = tokens[0];
                switch (type)
                {
                    case "#": // comment; ignored
                        break;
                    case "mtllib":
                        mesh.addMaterialLibrary(parseMaterialLibrary(tokens));
                        break;
                    case "o":
                        currentObject = mesh.addObject(parseName(tokens));
                        break;
                    case "v":
                        currentObject.addVertex(parseVector3(tokens));
                        break;
                    case "vt":
                        currentObject.addTextureCoordinate(parseVector3(tokens));
                        break;
                    case "vn":
                        currentObject.addNormalCoordinate(parseVector3(tokens));
                        break;
                    case "usemtl":
                        currentMaterialName = parseName(tokens);
                        break;
                    case "s":
                        currentSmoothing = parseBool(tokens);
                        break;
                    case "f":
                        List<List<uint>> indices = parseFaceIndices(tokens);
                        currentObject.addFace(indices[0], indices[1], indices[2], currentSmoothing, currentMaterialName);
                        break;
                    case "g":
                        // \todo: find out how to use groups;
                        break;
                    default:
                        System.Console.WriteLine("Unsupported type (" + type + ") in statement: " + line);
                        break;
                }
            }
            return mesh;
        }

        public string[] loadObjFile(string filename)
        {
            return System.IO.File.ReadAllLines(filename);
        }
    }
}
