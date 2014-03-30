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
    public partial class fObjectWindow : Form
    {
        private fMain mformMain;
        private fConsole mformConsole;

        public fObjectWindow()
        {
            InitializeComponent();
        }

        public void setExtForms(fMain lformMain, fConsole lformConsole)
        {
            // set the forms so that it can share information between each other
            mformMain = lformMain;
            mformConsole = lformConsole;
        }

        public void testConnection(string sText)
        {
            this.mformMain.setTextBox(sText);
            this.mformConsole.setTextBox(sText);
        }

        public void setTextBox(string sText)
        {
            this.textBox1.Text = sText;
        }

        private void textBox1_TextChanged(object sender, EventArgs e)
        {
            testConnection(this.textBox1.Text);
        }
    }
}
