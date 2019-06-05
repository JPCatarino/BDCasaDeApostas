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
    public partial class selecionacomp : Form
    {
        public selecionacomp()
        {
            InitializeComponent();
        }

        SqlConnection cn1 = new SqlConnection("Data Source = " + "tcp:mednat.ieeta.pt\\SQLSERVER,8101" + " ;" + "Initial Catalog = " + "p3g6" +
      "; uid = " + "p3g6" + ";" + "password = " + "Javardices123");
        DataTable dt = new DataTable();

        private void button10_Click(object sender, EventArgs e)
        {
            dt.Clear();
            cn1.Open();
            SqlCommand cm = new SqlCommand("cdp.ListGamesPerCompetition", cn1);
            cm.CommandType = CommandType.StoredProcedure;

            cm.Parameters.Add("@Name_Booker", SqlDbType.VarChar).Value = Form2.comboBox1.SelectedItem.ToString();
            cm.Parameters.Add("@Name_Comp", SqlDbType.VarChar).Value = textBox1.Text;


            try
            {
                SqlDataReader dr = cm.ExecuteReader();

                while (dr.Read())
                {

                    
                }
                dr.Close();
                dr.Dispose();

                SqlDataAdapter adapter = new SqlDataAdapter(cm);
                adapter.Fill(dt);
                dataGridView1.DataSource = dt;
                dataGridView1.DataMember = dt.TableName;

                cn1.Close();

            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message, Application.ProductName, MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }
    }
}
