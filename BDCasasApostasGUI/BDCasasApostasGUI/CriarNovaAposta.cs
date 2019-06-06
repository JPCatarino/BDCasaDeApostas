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
    public partial class CriarNovaAposta : Form
    {
        public CriarNovaAposta()
        {
            InitializeComponent();
        }

        SqlConnection cn1 = new SqlConnection("Data Source = " + "tcp:mednat.ieeta.pt\\SQLSERVER,8101" + " ;" + "Initial Catalog = " + "p3g6" +
     "; uid = " + "p3g6" + ";" + "password = " + "Javardices123");

        private void button7_Click(object sender, EventArgs e)
        {
            cn1.Open();

            // SqlCommand cm = new SqlCommand("SELECT Nome from cdp.casa_de_apostas;", cn1);

            SqlCommand cm = new SqlCommand("cdp.addNewAposta", cn1);
            cm.CommandType = CommandType.StoredProcedure;


            cm.Parameters.Add("@NameBooker", SqlDbType.VarChar).Value = Form2.comboBox1.GetItemText(Form2.comboBox1.SelectedItem);
            cm.Parameters.Add("@IDJogo", SqlDbType.VarChar).Value = textBox7.Text;
            cm.Parameters.Add("@Descricao", SqlDbType.VarChar).Value = textBox3.Text;
            cm.Parameters.Add("@odd", SqlDbType.VarChar).Value = textBox2.Text;
            cm.Parameters.Add("@Data", SqlDbType.VarChar).Value = textBox4.Text;



            try
            {
                SqlDataReader dr = cm.ExecuteReader();

                while (dr.Read())
                {
                    

                }
                MessageBox.Show("Aposta criada com sucesso!", " ", MessageBoxButtons.OK, MessageBoxIcon.Information);
                dr.Close();
                dr.Dispose();
                cn1.Close();



            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message, Application.ProductName, MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private void CriarNovaAposta_Load(object sender, EventArgs e)
        {
            textBox1.Text = Form2.comboBox1.GetItemText(Form2.comboBox1.SelectedItem);
        }
    }
}
