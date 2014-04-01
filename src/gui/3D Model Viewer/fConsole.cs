using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace _3D_Model_Viewer
{
    public partial class fConsole : Form
    {
        private fMain mformMain;
        private fObjectWindow mformViewer;

        public fConsole()
        {
            InitializeComponent();
        }

        public void setExtForms(fMain lformMain,fObjectWindow lformViewer)
        {
            // set the forms so that it can share information between each other
            mformMain = lformMain;
            mformViewer = lformViewer;
        }

        public void testConnection(string sText)
        {
            this.mformMain.setTextBox(sText);
            this.mformViewer.setTextBox(sText);
        }

        private void richTextBox1_TextChanged(object sender, EventArgs e)
        {
            testConnection(this.richTextBox1.Text);
        }

        public void setTextBox(string sText)
        {
            this.richTextBox1.Text = sText;
        }
    }
}
