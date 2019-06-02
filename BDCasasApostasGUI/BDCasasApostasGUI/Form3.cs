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
    public partial class Form3 : Form
    {
        public Form3()
        {
            InitializeComponent();
        }

        SqlConnection cn1 = new SqlConnection("Data Source = " + "tcp:mednat.ieeta.pt\\SQLSERVER,8101" + " ;" + "Initial Catalog = " + "p3g6" +
      "; uid = " + "p3g6" + ";" + "password = " + "Javardices123");

        private void listBox1_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        private void label1_Click(object sender, EventArgs e)
        {

        }

        private void pictureBox1_Click(object sender, EventArgs e)
        {

        }

        private void label3_Click(object sender, EventArgs e)
        {

        }

        private void button1_Click(object sender, EventArgs e)
        {
            cn1.Open();
            // SqlCommand cm = new SqlCommand("SELECT Nome from cdp.casa_de_apostas;", cn1);

            SqlCommand cm = new SqlCommand("cdp.AddNewGameAndBets", cn1);
            cm.CommandType = CommandType.StoredProcedure;

            cm.Parameters.Add("@Name_Booker", SqlDbType.VarChar).Value = Form2.comboBox1.SelectedItem.ToString();
           // cm.Parameters.Add("@Name_Booker", SqlDbType.VarChar).Value = Form2.comboBox1.SelectedValue.ToString();
            cm.Parameters.Add("@Name_Comp", SqlDbType.VarChar).Value = textBox3.Text;
            cm.Parameters.Add("@Home_Team", SqlDbType.VarChar).Value = textBox1.Text;
            cm.Parameters.Add("@Odd_Home_Win", SqlDbType.VarChar).Value = textBox4.Text;
            cm.Parameters.Add("@Away_Team", SqlDbType.VarChar).Value = textBox2.Text;
            cm.Parameters.Add("@Odd_Away_Win", SqlDbType.VarChar).Value = textBox6.Text;
            cm.Parameters.Add("@Odd_Draw", SqlDbType.VarChar).Value = textBox5.Text;
            cm.Parameters.Add("@Game_Date", SqlDbType.VarChar).Value = textBox7.Text;

            //Deve ser usada esta de baixo, mas falta meter apostadores por casa.
            //cm.Parameters.Add("@Name_Booker", SqlDbType.VarChar).Value = comboBox1.SelectedValue.ToString();


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
