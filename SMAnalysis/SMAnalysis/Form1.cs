using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace SMAnalysis
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
            Timer MyTimer = new Timer();
            MyTimer.Interval = (45 * 60 * 1000); // 45 mins
            MyTimer.Tick += new EventHandler(MyTimer_Tick);
            MyTimer.Start();
        }
        private void MyTimer_Tick(object sender, EventArgs e)
        {
            MessageBox.Show("The form will now be closed.", "Time Elapsed");
            this.Close();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            string file = @"D:\Project\SM\SMAnalysis\SMAnalysis\CIPLA.txt";
            var lines = File.ReadAllLines(file);

            foreach (var line in lines)
            {
                SmInfo smInfo = new SmInfo();
                string[] columns = line.Split(",".ToCharArray());
                smInfo.DateTime = GetDate(columns[1], columns[2]);
                smInfo.OP = Convert.ToDecimal(columns[3]);
                smInfo.HP = Convert.ToDecimal(columns[4]);
                smInfo.LP = Convert.ToDecimal(columns[5]);
                smInfo.CP = Convert.ToDecimal(columns[6]);
                smInfo.volume = Convert.ToInt32(columns[7]);
                ConstantHelper.ListRaw.Add(smInfo);
            }

            var list = ConstantHelper.ListRaw.Select(p => p.Date).Distinct();
            foreach (var date in list)
            {
                var records = ConstantHelper.ListRaw.Where(p => p.Date == date);
                SmDailyInfo smInfo = new SmDailyInfo();
                smInfo.DateTime = date;
                smInfo.OP = records.First().OP;
                smInfo.HP = records.Max(p => p.HP);
                smInfo.LP = records.Max(p => p.HP);
                smInfo.CP = records.Last().CP;
                smInfo.volume = records.Sum(p => p.volume);
                ConstantHelper.DailyList.Add(smInfo);
            }
            dataGridView1.DataSource = ConstantHelper.DailyList;
        }

        private DateTime GetDate(string date, string time)
        {
            int year = Convert.ToInt32(date.Substring(0, 4));
            int month = Convert.ToInt32(date.Substring(4, 2));
            int day = Convert.ToInt32(date.Substring(6, 2));
            int hours = Convert.ToInt32(time.Substring(0, 2));
            int minute = Convert.ToInt32(time.Substring(3, 2));
            DateTime dt = new DateTime(year, month, day, hours, minute, 0);
            return dt;
        }
    }

    public class SmInfo
    {
        public decimal LP { get; set; }

        public decimal HP { get; set; }

        public decimal OP { get; set; }

        public decimal CP { get; set; }

        public int volume { get; set; }

        public DateTime DateTime { get; set; }

        public DateTime Date
        {
            get
            {

                return this.DateTime.Date;
            }
        }

        public TimeSpan Time
        {
            get
            {

                return this.DateTime.TimeOfDay;
            }
        }
    }


    public class SmDailyInfo
    {
        public decimal LP { get; set; }

        public decimal HP { get; set; }

        public decimal OP { get; set; }

        public decimal CP { get; set; }

        public int volume { get; set; }

        public DateTime DateTime { get; set; }

        public DateTime Date
        {
            get
            {

                return this.DateTime.Date;
            }
        }
    }

    public class ConstantHelper
    {
        public static List<SmInfo> ListRaw = new List<SmInfo>();

        public static List<SmDailyInfo> DailyList = new List<SmDailyInfo>();

        public static DateTime LastSynTime = DateTime.Today;
    }

}
