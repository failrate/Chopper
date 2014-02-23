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
        public fMain()
        {
            InitializeComponent();
        }

        private void editToolStripMenuItem_Click(object sender, EventArgs e)
        {

            this.openFileDialog1.InitialDirectory = "c:\\";
            this.openFileDialog1.Filter = "txt files (*.txt)|*.txt|All files (*.*)|*.*";
            this.openFileDialog1.FilterIndex = 2;
            this.openFileDialog1.RestoreDirectory = true;

            if (this.openFileDialog1.ShowDialog() == DialogResult.OK)
            {
                try
                {
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
                this.closeForm();
        }

        private void closeForm()
        {
            // close the form
            this.Close();
        }

        private void btnA_Click(object sender, EventArgs e)
        {
            // update the status label
            this.toolStripStatusLabel1.Text = "Button A pressed";
        }

        private void btnB_Click(object sender, EventArgs e)
        {
            // update the status label
            this.toolStripStatusLabel1.Text = "Button B pressed";
        }

        private void fMain_Load(object sender, EventArgs e)
        {

        }

        private void fMain_FormClosing(object sender, FormClosingEventArgs e)
        {
            DialogResult dResult;

            dResult = MessageBox.Show("Exit the program?", "Exit", MessageBoxButtons.YesNo, MessageBoxIcon.Question);

            if (dResult == DialogResult.Yes)
            {
                // continue closing the form
            }
            else
            {
                e.Cancel = true;
            }
        }

        private void aboutToolStripMenuItem_Click(object sender, EventArgs e)
        {
            fAbout formAbout = new fAbout();

            formAbout.ShowDialog();

            formAbout.Dispose();
        }
    }
}
