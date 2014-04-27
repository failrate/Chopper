//
// Wavefront .obj file parser
// Generated via Ragel
//
using OpenTK;
using System;
using System.Collections.Generic;

%%{
	machine mesh_parser;
	ret = ('\r\n' | '\n');
	number = digit+;
	float = ('-')?digit+'.'digit+;
	identifier = [a-zA-Z]+[a-zA-Z_0-9]+;
	filename = alnum+'.'alnum{3};
	
	action return_generic { Console.WriteLine("Return"); fret;}

	comment = '#' any ret;
	action call_comment { Console.WriteLine("Comment"); fcall comment_reader; }
	comment_reader := |*
		ret @return_generic;
		any;
	*|;

	face = 'f' (space+ number)+ ('\r\n' | '\n');
	action return_face { Console.WriteLine("ReturnFace"); mesh.AddFace(); fret; }
	action call_face { Console.WriteLine("Face:"); fcall face_reader; }
	action add_face_index {
		Console.WriteLine("LastFaceAddIndex: |" + data.Substring(ts, te-ts) + "|");
		mesh.QueueIndex(Convert.ToUInt32(data.Substring(ts, te-ts)));
	}
	face_reader := |*
		'f';
		space number $add_face_index;
		('\r\n' | '\n') @return_face;
	*|;

	mttlib = 'mtllib' space filename ret;
	action call_mtllib { Console.WriteLine("Mtllib"); fcall mtllib_reader; }
	mtllib_reader := |*
		'mtllib';
		space;
		filename;
		ret @return_generic;
	*|;

	parser = face $call_face | comment $call_comment | mttlib $call_mtllib;

	main := parser*;		
}%%

public class ChopperMesh
{
	string name;
	string mtllib;
	string usemtl;
	List<Vector3> vertices;
	List<List<uint>> indices;
	List<Vector3> normals; // optional?
	List<List<uint>> faces;
	private List<uint> queuedIndices;
	public ChopperMesh()
	{
		name = "";
		mtllib = "";
		usemtl = "";
		vertices = new List<Vector3>();
		indices = new List<List<uint>>();
		normals = new List<Vector3>();
		faces = new List<List<uint>>();
 	}
	public int AddFace()
	{
		faces.Add(queuedIndices);
		queuedIndices = null;
		return faces.Count - 1;
	}
	public int QueueIndex(uint index)
	{
		if (queuedIndices == null)
		{
			queuedIndices = new List<uint>();
		}
		queuedIndices.Add(index);
		return queuedIndices.Count - 1;
	}
	
}
	
public class MeshParser
{
	
	%% write data;
	public ChopperMesh parseObjFile(string data)
	{
		ChopperMesh mesh = new ChopperMesh();
		int p = 0;
		int pe = data.Length;
		int eof = data.Length;
		int cs = 0;
		int ts = 0;
		int te = 0;
		int act = 0;
		int top = 0;
		int[] stack = new int[128];
		%% write init;
		%% write exec;
			
		return mesh;
	}
	
	public string loadObjFile(string filename)
	{
	        return System.IO.File.ReadAllText(filename);
	}
}
