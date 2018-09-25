using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace WebApplication9.Controllers
{
    public class HomeController : Controller
    {
        public ActionResult Index()
        {
            return View();
        }

        // POST api/values
        public void DataPost(List<row> list)
        {
            if (list == null)
                return;
            BulkInsertionToDataBase(list);
        }

        private void BulkInsertionToDataBase(List<row> list)
        {
            DataTable dtProductSold = ToDataTable<row>(list);
            //using (SqlConnection con = new SqlConnection("Data Source=WKS-337\\SQLEXPRESS;Initial Catalog=SM;User ID=sa;Password=damco"))
            {
                //con.Open();
                using (SqlBulkCopy objbulk = new SqlBulkCopy("Data Source=WKS-337\\SQLEXPRESS;Initial Catalog=SM;User ID=sa;Password=damco", SqlBulkCopyOptions.FireTriggers))
                {
                    objbulk.DestinationTableName = "SInfo";
                    foreach (DataColumn column in dtProductSold.Columns)
                        objbulk.ColumnMappings.Add(column.ColumnName, column.ColumnName);
                    objbulk.WriteToServer(dtProductSold);
                }
                //con.Close();
            }
        }

        public DataTable ToDataTable<T>(IList<T> data)// T is any generic type
        {
            PropertyDescriptorCollection props = TypeDescriptor.GetProperties(typeof(T));

            DataTable table = new DataTable();
            for (int i = 0; i < props.Count; i++)
            {
                PropertyDescriptor prop = props[i];
                table.Columns.Add(prop.Name, prop.PropertyType);
            }
            object[] values = new object[props.Count];
            foreach (T item in data)
            {
                for (int i = 0; i < values.Length; i++)
                {
                    values[i] = props[i].GetValue(item);
                }
                table.Rows.Add(values);
            }
            return table;
        }

    }
    public class row
    {

        public string Open { get; set; }
        public string High { get; set; }
        public string Low { get; set; }
        public string Close { get; set; }
        public string Volume { get; set; }
        public string AvgPrice { get; set; }
        public string Name { get; set; }
        public string LastPrice { get; set; }
        public string orderColum { get; set; }
        public string buycolumn { get; set; }
        public string sellColumn { get; set; }
        public string BuyOrders { get; set; }
        public string SellOrders { get; set; }
    }
}
