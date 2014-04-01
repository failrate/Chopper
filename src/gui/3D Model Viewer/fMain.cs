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

    public partial class fMain : Form
    {
        private fConsole mformConsole;               // used to display information to use what is occruing 
        private fObjectWindow mformViewer;           // used to display and hold the 3D Object
        private const int miStartX = 100;
        private const int miStartY = 100;

        public fMain()
        {
            InitializeComponent();
        }

        private void editToolStripMenuItem_Click(object sender, EventArgs e)
        {

            // set the initial directory of the ope file dialog
            this.openFileDialog1.InitialDirectory = "c:\\";
            // default to show all files
            this.openFileDialog1.Filter = "txt files (*.txt)|*.txt|All files (*.*)|*.*";
            this.openFileDialog1.FilterIndex = 2;
            this.openFileDialog1.RestoreDirectory = true;

            // check to see if the user has clicked the OK box
            if (this.openFileDialog1.ShowDialog() == DialogResult.OK)
            {
                try
                {
                    // for now let the user now which file was selected
                    string sFilename;
                    sFilename = openFileDialog1.FileName;

                    MessageBox.Show("The file selected is " + sFilename, "Info", MessageBoxButtons.OK, MessageBoxIcon.Information);
                }
                catch (Exception ex)
                {
                    MessageBox.Show("Error: Could not read file from disk. Original error: " + ex.Message);
                }
            }
        }

        private void helpToolStripMenuItem_Click(object sender, EventArgs e)
        {

        }

        private void closeToolStripMenuItem_Click(object sender, EventArgs e)
        {
            // close the form
            this.closeForm();
        }

        private void closeForm()
        {
            // close the form
            this.Close();
        }

        private void fMain_Load(object sender, EventArgs e)
        {
            // initialize the child forms
            this.mformConsole = new fConsole();
            this.mformViewer = new fObjectWindow();

            // set the starting location based on the top left had corner of the Main window
            this.Location = new Point(miStartX, miStartY);
            this.mformConsole.Location = new Point(miStartX, miStartY + this.Size.Height);
            this.mformViewer.Location = new Point(miStartX + this.Size.Width, miStartY);
            
            // show the child forms
            this.mformViewer.Show();
            this.mformConsole.Show();

            this.mformConsole.setExtForms(this, this.mformViewer);
            this.mformViewer.setExtForms(this, this.mformConsole);
        }

        private void fMain_FormClosing(object sender, FormClosingEventArgs e)
        {
            DialogResult dResult;

            // ask the user if they want to close th program
            dResult = MessageBox.Show("Exit the program?", "Exit", MessageBoxButtons.YesNo, MessageBoxIcon.Question);

            if (dResult == DialogResult.Yes)
            {
                // continue closing the form
            }
            else
            {
                // stop the form from closing
                e.Cancel = true;
            }
        }

        private void aboutToolStripMenuItem_Click(object sender, EventArgs e)
        {
            fAbout formAbout = new fAbout();

            formAbout.ShowDialog();

            formAbout.Dispose();
        }

        public void setTextBox(string sText)
        {
            this.textBox1.Text = sText;
        }

        public void testConnection(string sText)
        {
            this.mformViewer.setTextBox(sText);
            this.mformConsole.setTextBox(sText);
        }

        private void textBox1_TextChanged(object sender, EventArgs e)
        {
            testConnection(this.textBox1.Text);
        }
    }
}
