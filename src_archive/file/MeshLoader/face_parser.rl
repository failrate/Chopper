machine face_parser;
head = 'f';
index = digit+;
main := |*
	head => {
		mesh.AddFace();
	};
	index => {
		mesh.LastFaceAddIndex(Convert.ToUint32(data.Substring(ts, te-ts)));
	};
	space;
*|;
