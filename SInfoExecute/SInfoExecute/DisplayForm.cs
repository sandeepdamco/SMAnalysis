using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace SInfoExecute
{
    public partial class DisplayForm : Form
    {
        Timer MyTimer = new Timer();
        public DisplayForm()
        {
            InitializeComponent();
            MyTimer.Interval = 1000;
            MyTimer.Tick += new EventHandler(MyTimer_Tick);
            MyTimer.Start();
            LoadDropDown();
        }

        public List<string> Names = new List<string>();
        private void MyTimer_Tick(object sender, EventArgs e)
        {
            if (comboBox1.SelectedIndex == 0 || comboBox1.SelectedIndex == -1)
                return;
            DataSet ds = new DataSet();
            using (SqlConnection con = new SqlConnection("Data Source=WKS-337\\SQLEXPRESS;Initial Catalog=SM;User ID =sa; Password =damco"))
            {
                using (SqlCommand cmd = new SqlCommand("select top 1 lastPrice from sinfo where name ='" + comboBox1.SelectedValue + "' order by AddedDate desc ", con))
                {
                    con.Open();
                    using (SqlDataAdapter adap = new SqlDataAdapter(cmd))
                    {
                        adap.Fill(ds);
                    }
                }
            }
            label1.Text = ds.Tables[0].Rows[0][0].ToString();
        }

        private void LoadDropDown()
        {
            DataSet ds = new DataSet();
            using (SqlConnection con = new SqlConnection("Data Source=WKS-337\\SQLEXPRESS;Initial Catalog=SM;User ID =sa; Password =damco"))
            {
                using (SqlCommand cmd = new SqlCommand("select distinct name from sinfo order by name", con))
                {
                    con.Open();
                    using (SqlDataAdapter adap = new SqlDataAdapter(cmd))
                    {
                        adap.Fill(ds);
                    }
                }
            }
            comboBox1.DataSource = ds.Tables[0];
            comboBox1.DisplayMember = "Name";
            comboBox1.ValueMember = "Name";
        }

        private void panel1_Paint(object sender, PaintEventArgs e)
        {

        }

        private void button2_Click(object sender, EventArgs e)
        {
            this.TopMost = true;
            if (panel1.Visible)
            {
                panel1.Hide();
                panel2.Show();
            }
            else
            {
                panel1.Show();
                panel2.Hide();
            }
        }

        private void button1_Click(object sender, EventArgs e)
        {

        }
    }
}
