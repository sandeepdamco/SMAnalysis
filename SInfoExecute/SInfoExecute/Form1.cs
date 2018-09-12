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
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
            Timer MyTimer = new Timer();
            MyTimer.Interval = (5 * 1000); // 45 mins
            MyTimer.Tick += new EventHandler(MyTimer_Tick);
            MyTimer.Start();
        }
        DataSet oldDs = new DataSet();
        private void MyTimer_Tick(object sender, EventArgs e)
        {
            DataSet ds = new DataSet();
            using (SqlConnection con = new SqlConnection("Data Source=WKS-337\\SQLEXPRESS;Initial Catalog=SM;User ID =sa; Password =damco"))
            {
                using (SqlCommand cmd = new SqlCommand("sp_GetInfo", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add("@duration", SqlDbType.Int).Value = 3;
                    con.Open();
                    using (SqlDataAdapter adap = new SqlDataAdapter(cmd))
                    {
                        adap.Fill(ds);
                    }
                }
            }
            dataGridView1.DataSource = ds.Tables[0];
            if (ds.Tables[0].Rows.Count > 0 && oldDs.Tables.Count > 0 && oldDs.Tables[0].Rows.Count != ds.Tables[0].Rows.Count)
            {
                this.BringToFront();
            }
            oldDs = ds;
        }


        private void button1_Click(object sender, EventArgs e)
        {
            MyTimer_Tick(null, null);
        }
    }
}
