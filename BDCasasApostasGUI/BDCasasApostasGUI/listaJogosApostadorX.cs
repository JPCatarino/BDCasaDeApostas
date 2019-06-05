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
    public partial class listaJogosApostadorX : Form
    {
        public listaJogosApostadorX()
        {
            InitializeComponent();
        }
        SqlConnection cn1 = new SqlConnection("Data Source = " + "tcp:mednat.ieeta.pt\\SQLSERVER,8101" + " ;" + "Initial Catalog = " + "p3g6" +
     "; uid = " + "p3g6" + ";" + "password = " + "Javardices123");
        DataTable dt = new DataTable();

        private void button1_Click(object sender, EventArgs e)
        {

            //cn1.Open();
            dt.Clear();
            // SqlCommand cm = new SqlCommand("SELECT Nome from cdp.casa_de_apostas;", cn1);

            SqlCommand cm = new SqlCommand("cdp.listMostBettedGames", cn1);
            cm.CommandType = CommandType.StoredProcedure;

            cm.Parameters.Add("@BookerName", SqlDbType.VarChar).Value = Form2.comboBox1.SelectedItem.ToString();

            try
            {
                SqlDataReader dr = cm.ExecuteReader();

                while (dr.Read())
                {
                    //comboBox1.Items.Add(dr["Primeiro_Nome"]);

                }
                dr.Close();
                dr.Dispose();


                SqlDataAdapter adapter = new SqlDataAdapter(cm);
                adapter.Fill(dt);
                dataGridView1.DataSource = dt;
                dataGridView1.DataMember = dt.TableName;



            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message, Application.ProductName, MessageBoxButtons.OK, MessageBoxIcon.Error);
            }

        }

        private void listaJogosApostadorX_Load(object sender, EventArgs e)
        {
            addcombobox1();
        }


        public void addcombobox1()
        {


            cn1.Open();
            // SqlCommand cm = new SqlCommand("SELECT Nome from cdp.casa_de_apostas;", cn1);

            SqlCommand cm = new SqlCommand("cdp.ListBettersPerBooker", cn1);
            cm.CommandType = CommandType.StoredProcedure;

            cm.Parameters.Add("@Name_Booker", SqlDbType.VarChar).Value = Form2.comboBox1.SelectedItem.ToString();

            try
            {
                SqlDataReader dr = cm.ExecuteReader();

                while (dr.Read())
                {
                    //comboBox1.Items.Add(dr["Primeiro_Nome"]);

                }
                dr.Close();
                dr.Dispose();



            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message, Application.ProductName, MessageBoxButtons.OK, MessageBoxIcon.Error);
            }


        }
    }
}
