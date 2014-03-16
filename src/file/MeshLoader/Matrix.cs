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
        const int row_count = 0;
        const int column_count = 0;
        public MatrixBase()
        {
            values = new double[row_count, column_count];
            Clear();
        }
        
        public void Oper(MatrixBase other, Func<double, double, double> fn)
        {
            for (int row_index = 0; row_index < row_count; ++row_index)
            {
                for (int column_index = 0; column_index < column_count; ++column_index)
                {
                    values[row_index, column_index] = fn(values[row_index, column_index], other.values[row_index, column_index]);
                }
            }
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
    }

    class Matrix2 : MatrixBase
    {
        override const int row_count = 2;
        override const int column_count = 2;
    };

    class Matrix3 : MatrixBase
    {
        override const int row_count = 3;
        override const int column_count = 3;
    };

    class Matrix4 : MatrixBase
    {
        override const int row_count = 4;
        override const int column_count = 4;
    };
}
