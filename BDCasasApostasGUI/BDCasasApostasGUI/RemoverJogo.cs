﻿using System;
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
    public partial class RemoverJogo : Form
    {
        public RemoverJogo()
        {
            InitializeComponent();
        }

        SqlConnection cn1 = new SqlConnection("Data Source = " + "tcp:mednat.ieeta.pt\\SQLSERVER,8101" + " ;" + "Initial Catalog = " + "p3g6" +
     "; uid = " + "p3g6" + ";" + "password = " + "Javardices123");


        private void label1_Click(object sender, EventArgs e)
        {

        }

        private void label2_Click(object sender, EventArgs e)
        {

        }

        private void textBox1_TextChanged(object sender, EventArgs e)
        {

        }

        private void textBox1_KeyPress(object sender, KeyPressEventArgs e)
        {
            char ch = e.KeyChar;

            if(!Char.IsDigit(ch) && ch != 8 && ch != 46) //digitos, backspace e delete
            {
                e.Handled = true;

            }
        }

        private void button1_Click(object sender, EventArgs e)
        {

           cn1.Open();
           
            // SqlCommand cm = new SqlCommand("SELECT Nome from cdp.casa_de_apostas;", cn1);

            SqlCommand cm = new SqlCommand("cdp.deleteAllBetsOfAGameInABooker", cn1);
            cm.CommandType = CommandType.StoredProcedure;

            cm.Parameters.Add("@BookerName", SqlDbType.VarChar).Value = Form2.comboBox1.SelectedItem.ToString();
            cm.Parameters.Add("@GameID", SqlDbType.VarChar).Value = textBox1.Text;
            MessageBox.Show("Apostas eliminadas com sucesso!", " ", MessageBoxButtons.OK, MessageBoxIcon.Information);

            try
            {
                SqlDataReader dr = cm.ExecuteReader();

                while (dr.Read())
                {
                    //comboBox1.Items.Add(dr["Primeiro_Nome"]);

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
