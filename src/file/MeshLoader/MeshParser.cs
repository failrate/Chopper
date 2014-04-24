using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
//using System.Threading.Tasks;
using OpenTK;

namespace MeshLoader
{
    
    public class MeshParser
    {
        // state holders
        string currentMaterialName = "";
        bool currentSmoothing = false;
        ChopperObject currentObject = null;
        ChopperMesh currentMesh = null;
        public string parseName(string[] tokens)
        {
            if (tokens.Length > 1)
            {
                return tokens[1];
            }
            return "default";
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
			float x = (float)(Convert.ToDouble(tokens[1]));
			float y = (float)(Convert.ToDouble(tokens[2]));
			float z = 0.0f;
			if (tokens.Length > 3) // In the case of UV coordinates, the third element is optional
			{
				z = (float)(Convert.ToDouble(tokens[3]));
			}
            return new Vector3(x, y, z);
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
        public List<List<int>> parseFaceIndices(string[] tokens)
        {
            List<List<int>> indices = new List<List<int>>();
            for (int index = 0; index < 3; index++)
            {
                indices.Add(new List<int>());
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
                    indices[count].Add(Convert.ToInt32(subToken));
                    count++;
                }
                count = 0;
            }
            return indices;
        }

        public void ensureCurrentObject()
        {
            if (currentObject == null)
            {
                currentObject = currentMesh.addObject("default");
            }
        }

        public ChopperMesh parseObjFile(string[] lines)
        {
            currentMesh = new ChopperMesh();
            char[] splits = {' '};
            foreach (string line in lines)
            {
                if (line.Length == 0)
                {
                    continue;
                }
                string[] tokens = line.Split(splits, StringSplitOptions.RemoveEmptyEntries);
                string type = tokens[0];
                switch (type)
                {
                    case "#": // comment; ignored
                        break;
                    case "mtllib":
                        currentMesh.addMaterialLibrary(parseMaterialLibrary(tokens));
                        break;
                    case "o":
                        currentObject = currentMesh.addObject(parseName(tokens));
                        break;
                    case "v":
                        ensureCurrentObject(); // The object declaration is optional
                        currentObject.addVertex(parseVector3(tokens));
                        break;
                    case "vt":
                        ensureCurrentObject();  // The object declaration is optional
                        currentObject.addTextureCoordinate(parseVector3(tokens));
                        break;
                    case "vn":
                        ensureCurrentObject();  // The object declaration is optional
                        currentObject.addNormalCoordinate(parseVector3(tokens));
                        break;
                    case "usemtl":
                        currentMaterialName = parseName(tokens);
                        break;
                    case "s":
                        currentSmoothing = parseBool(tokens);
                        break;
                    case "f":
                        ensureCurrentObject(); // The object declaration is optional
                        List<List<int>> indices = parseFaceIndices(tokens);
                        currentObject.addFace(indices[0], indices[1], indices[2], currentSmoothing, currentMaterialName);
                        break;
                    case "g":
                        ensureCurrentObject();  // The object declaration is optional
                        currentObject.addGroup(parseName(tokens));
                        break;
                    default:
                        System.Console.WriteLine("Unsupported type (" + type + ") in statement: " + line);
                        break;
                }
            }
            return currentMesh;
        }

        public string[] loadObjFile(string filename)
        {
            return System.IO.File.ReadAllLines(filename);
        }
    }
}
