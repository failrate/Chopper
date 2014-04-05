using System;
using System.Collections.Generic;
using OpenTK;
namespace MeshLoader
{
    class ChopperFace
    {
        public bool useSmoothing = false;
        public string materialName = "";
        public List<uint> vertexIndices;
        public List<uint> textureIndices;
        public List<uint> normalIndices;
    }
    class ChopperObject
    {
        public string name = "";
        public List<ChopperFace> faces;
        public List<Vector3> vertices;
        public List<Vector3> textureCoordinates;
        public List<Vector3> normalCoordinates;

        public ChopperObject()
        {
            faces = new List<ChopperFace>();
            vertices = new List<Vector3>();
            textureCoordinates = new List<Vector3>();
            normalCoordinates = new List<Vector3>();
        }
        public void addVertex(Vector3 vert)
        {
            vertices.Add(vert);
        }
        public void addTextureCoordinate(Vector3 coord)
        {
            textureCoordinates.Add(coord);
        }
        public void addNormalCoordinate(Vector3 coord)
        {
            normalCoordinates.Add(coord);
        }
        public void addFace(List<uint> vertexIndices, List<uint> textureIndices, List<uint> normalIndices, bool useSmoothing, string materialName)
        {
            ChopperFace face = new ChopperFace();
            face.vertexIndices = vertexIndices;
            face.textureIndices = textureIndices;
            face.normalIndices = normalIndices;
            face.useSmoothing = useSmoothing;
            face.materialName = materialName;
            faces.Add(face);
        }

    }
    class ChopperMesh
    {
        List<ChopperObject> objects;
        List<string> materialLibraries; // \todo? Parse actual material files?
        public ChopperMesh()
        {
            objects = new List<ChopperObject>();
            materialLibraries = new List<string>();
        }
        public ChopperObject addObject(string name)
        {
            ChopperObject obj = new ChopperObject();
            obj.name = name;
            objects.Add(obj);
            return obj;
        }
        public void addMaterialLibrary(string name)
        {
            materialLibraries.Add(name);
        }
    }

}
