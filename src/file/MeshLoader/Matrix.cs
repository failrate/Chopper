using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MeshLoader
{
    class MatrixBase
    {
        double[,] values;
         int row_count = 0;
         int column_count = 0;
        public MatrixBase()
        {
            values = new double[row_count, column_count];
        }

        public MatrixBase(int _row_count, int _column_count)
        {
            row_count = _row_count;
            column_count = _column_count;
        }
        
        public MatrixBase Oper(MatrixBase other, Func<double, double, double> fn)
        {
            MatrixBase returnValue = new MatrixBase(row_count, column_count);
            for (int row_index = 0; row_index < row_count; ++row_index)
            {
                for (int column_index = 0; column_index < column_count; ++column_index)
                {
                    returnValue.values[row_index, column_index] = fn(values[row_index, column_index], other.values[row_index, column_index]);
                }
            }

            return returnValue;
        }

        public MatrixBase Oper(Vector3 other, Func<double, double, double> fn)
        {
            MatrixBase returnValue = new MatrixBase(row_count, column_count);
            for (int row_index = 0; row_index < row_count; ++row_index)
            {
                for (int column_index = 0; column_index < column_count; ++column_index)
                {
                    returnValue.values[row_index, column_index] = fn(values[row_index, column_index], other.values[row_index, column_index]);
                }
            }

            return returnValue;
        }

        public void Oper(Func<double> fn)
        {
            for (int row_index = 0; row_index < row_count; ++row_index)
            {
                for (int column_index = 0; column_index < column_count; ++column_index)
                {
                    values[row_index, column_index] = fn();
                }
            }
        }

        public void Clear()
        {
            Oper(() => 0.0);
        }

        public static MatrixBase operator +(MatrixBase m1, MatrixBase m2)
        {
            return m1.Oper(m2, (double x, double y) => x + y);
        }

        public static MatrixBase operator -(MatrixBase m1, MatrixBase m2)
        {
            return m1.Oper(m2, (double x, double y) => x - y);
        }
    }

    class Matrix2 : MatrixBase
    {
        override  int row_count = 2;
        override  int column_count = 2;
    };

    class Matrix3 : MatrixBase
    {
        override  int row_count = 3;
        override  int column_count = 3;
    };

    class Matrix4 : MatrixBase
    {
        override  int row_count = 4;
        override  int column_count = 4;
    };
}
