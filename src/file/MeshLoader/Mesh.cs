using System;
using System.Collections.Generic;
using OpenTK;
namespace MeshLoader
{
    public class ChopperFace
    {
        public bool useSmoothing = false;
        public string materialName = "";
        public List<int> vertexIndices;
        public List<int> textureIndices;
        public List<int> normalIndices;
    }
	public class ChopperObject
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
        public void addFace(List<int> vertexIndices, List<int> textureIndices, List<int> normalIndices, bool useSmoothing, string materialName)
        {
            ChopperFace face = new ChopperFace();
            face.vertexIndices = vertexIndices;
            face.textureIndices = textureIndices;
            face.normalIndices = normalIndices;
            face.useSmoothing = useSmoothing;
            face.materialName = materialName;
            faces.Add(face);
        }
		public List<int> facesAsTriangles()
		{
			List<int> triangles = new List<int>();
			foreach (ChopperFace face in faces)
			{
				triangles.Add(face.vertexIndices[0] - 1);
				triangles.Add(face.vertexIndices[1] - 1);
				triangles.Add(face.vertexIndices[2] - 1);
				if (face.vertexIndices.Count > 3)
				{
					triangles.Add(face.vertexIndices[2] - 1);
					triangles.Add(face.vertexIndices[3] - 1);
					triangles.Add(face.vertexIndices[0] - 1);
				}
			}
			return triangles;
		}
		public List<Vector2> uvs()
		{
			List<Vector2> uvs = new List<Vector2>();
			foreach(ChopperFace face in faces)
			{
				uvs.Add(new Vector2(textureCoordinates[face.textureIndices[0] - 1][0], textureCoordinates[face.textureIndices[0] - 1][1]));
				uvs.Add(new Vector2(textureCoordinates[face.textureIndices[1] - 1][0], textureCoordinates[face.textureIndices[1] - 1][1]));
				uvs.Add(new Vector2(textureCoordinates[face.textureIndices[2] - 1][0], textureCoordinates[face.textureIndices[2] - 1][1]));
				uvs.Add(new Vector2(textureCoordinates[face.textureIndices[2] - 1][0], textureCoordinates[face.textureIndices[2] - 1][1]));
				if (face.textureIndices.Count > 3)
				{
					uvs.Add(new Vector2(textureCoordinates[face.textureIndices[3] - 1][0], textureCoordinates[face.textureIndices[3] - 1][1]));
					uvs.Add(new Vector2(textureCoordinates[face.textureIndices[0] - 1][0], textureCoordinates[face.textureIndices[0] - 1][1]));
				}
			}
			return uvs;
		}
    }
	public class ChopperMesh
    {
        public List<ChopperObject> objects;
        public List<string> materialLibraries; // \todo? Parse actual material files?
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
