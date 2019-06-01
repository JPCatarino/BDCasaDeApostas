using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Data.SqlClient;

namespace BDCasasApostasGUI
{
    public partial class NovaCasa : Form
    {
        public NovaCasa()
        {
            InitializeComponent();
        }
        SqlConnection cn1 = new SqlConnection("Data Source = " + "tcp:mednat.ieeta.pt\\SQLSERVER,8101" + " ;" + "Initial Catalog = " + "p3g6" +
      "; uid = " + "p3g6" + ";" + "password = " + "Javardices123");

        private void label1_Click(object sender, EventArgs e)
        {

        }

        private void button1_Click(object sender, EventArgs e)
        {

            cn1.Open();
            SqlCommand cm = new SqlCommand("cdp.AddBooker1", cn1);
            cm.CommandType = CommandType.StoredProcedure;

            cm.Parameters.Add("@Name_Booker", SqlDbType.VarChar).Value = textBox1.Text;
            cm.Parameters.Add("@Email_Booker", SqlDbType.VarChar).Value = textBox2.Text;
            cm.Parameters.Add("@Teleph_Booker", SqlDbType.VarChar).Value = textBox3.Text;
            cm.Parameters.Add("@Site_Booker", SqlDbType.VarChar).Value = textBox4.Text;

            try
            {
                SqlDataReader dr = cm.ExecuteReader();

                while (dr.Read())
                {
                    

                }
                dr.Close();
                dr.Dispose();
                cn1.Close();

            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message, Application.ProductName, MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }
    }
}
