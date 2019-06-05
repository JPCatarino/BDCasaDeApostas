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
    public partial class TrocaEquipas : Form
    {
        public TrocaEquipas()
        {
            InitializeComponent();
        }

        SqlConnection cn1 = new SqlConnection("Data Source = " + "tcp:mednat.ieeta.pt\\SQLSERVER,8101" + " ;" + "Initial Catalog = " + "p3g6" +
      "; uid = " + "p3g6" + ";" + "password = " + "Javardices123");

        private void TrocaEquipas_Load(object sender, EventArgs e)
        {
            textBox1.Text = infoequipas.comboBox2.GetItemText(comboBox2.SelectedItem);
            //infoequipas.comboBox2.SelectedValue.ToString();



            //dispor as equipas daquela competição

            cn1.Open();
            // SqlCommand cm = new SqlCommand("SELECT Nome from cdp.casa_de_apostas;", cn1);

            SqlCommand cm = new SqlCommand("cdp.listAllTeamPlayers", cn1);
            cm.CommandType = CommandType.StoredProcedure;


            SqlCommand cm2 = new SqlCommand("cdp.GetTeamID", cn1);
            cm2.CommandType = CommandType.StoredProcedure;
            cm2.Parameters.Add("@Name_Team", SqlDbType.VarChar).Value = infoequipas.comboBox2.GetItemText(comboBox2.SelectedItem);
            cm2.Parameters.Add("@ID_Team", SqlDbType.Int).Direction = ParameterDirection.Output;
            cm2.ExecuteNonQuery();
            int retval = (int)cm2.Parameters["@ID_Team"].Value;



            cm.Parameters.Add("@TeamID", SqlDbType.VarChar).Value = retval;




            try
            {
                SqlDataReader dr = cm.ExecuteReader();
                // SqlDataReader dr2 = cm2.ExecuteReader();



                while (dr.Read())
                {
                    comboBox2.Items.Add(dr["Nome"]);

                }
                dr.Close();
                dr.Dispose();



            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message, Application.ProductName, MessageBoxButtons.OK, MessageBoxIcon.Error);
            }


        }

        private void comboBox2_SelectedIndexChanged(object sender, EventArgs e)
        {

        }
    }
}
