using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MeshLoader
{
    class Vector3
    {
        public double x;
        public double y;
        public double z;
        public Vector3(double _x, double _y, double _z)
        {
            x = _x;
            y = _y;
            z = _z;
        }
        public Vector3()
        {
            x = 0.0;
            y = 0.0;
            z = 0.0;
        }
        public static Vector3 operator +(Vector3 v1, Vector3 v2)
        {
            return new Vector3(v1.x + v2.x, v1.y + v2.y, v1.z + v2.z);
        }
        public static Vector3 operator -(Vector3 v1, Vector3 v2)
        {
            return new Vector3(v1.x - v2.x, v1.y - v2.y, v1.z - v2.z);
        }
        public static Vector3 operator *(Vector3 v, double f)
        {
            return new Vector3(v.x * f, v.y * f, v.z * f);
        }
        public static Vector3 operator /(Vector3 v, double f)
        {
            return new Vector3(v.x / f, v.y / f, v.z / f);
        }
        public double magnitude()
        {
            return Math.Sqrt(x*x + y*y + z*z);
        }
        public Vector3 normalized()
        {
            return this / this.magnitude();
        }
        public static Vector3 cross(Vector3 v1, Vector3 v2)
        {
            double cx = v1.y * v2.z - v1.z * v2.y;
            double cy = v1.z * v2.x - v1.x * v2.z;
            double cz = v1.x * v2.y - v1.y - v2.x;
            return new Vector3(cx, cy, cz);
        }
        public static double dot(Vector3 v1, Vector3 v2)
        {
            return v1.x * v2.x + v1.y * v2.y + v1.z * v2.z;
        }

        public override string ToString()
        {
            return String.Format("[{0}, {1}, {2}]", x, y, z);
        }
    };

    class Mesh
    {
        public List<Vector3> vertexList;
        public List<uint[]> indexList;
        public List<Vector3> normalList;
    };
}
