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
    public partial class infoequipas : Form
    {

        SqlConnection cn1 = new SqlConnection("Data Source = " + "tcp:mednat.ieeta.pt\\SQLSERVER,8101" + " ;" + "Initial Catalog = " + "p3g6" +
      "; uid = " + "p3g6" + ";" + "password = " + "Javardices123");
        public infoequipas()
        {
            InitializeComponent();




        }

        
       


        private void infoequipas_Load(object sender, EventArgs e)
        {
            cn1.Open();
            // SqlCommand cm = new SqlCommand("SELECT Nome from cdp.casa_de_apostas;", cn1);
            comboBox2.Enabled = false;

            if (comboBox1.Enabled)
            {
                addcombobox1();
            }
            
            //addcombobox2();

            SqlCommand cm = new SqlCommand("cdp.ListAllTeams", cn1);
            cm.CommandType = CommandType.StoredProcedure;



            //Deve ser usada esta de baixo, mas falta meter apostadores por casa.
            //cm.Parameters.Add("@Name_Booker", SqlDbType.VarChar).Value = comboBox1.SelectedValue.ToString();


            try
            {
                SqlDataReader dr = cm.ExecuteReader();

                while (dr.Read())
                {
                    ListaCasaX.Items.Add(dr["ID"]);
                    ListaCasaX.Items.Add(dr["Nome"]);
                    ListaCasaX.Items.Add(" ");

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

        private void label7_Click(object sender, EventArgs e)
        {

        }

        private void populate_Click(object sender, EventArgs e)
        {
            cn1.Open();
            // SqlCommand cm = new SqlCommand("SELECT Nome from cdp.casa_de_apostas;", cn1);

            SqlCommand cm = new SqlCommand("cdp.ListBookerNames", cn1);
            cm.CommandType = CommandType.StoredProcedure;

            try
            {
                SqlDataReader dr = cm.ExecuteReader();

                while (dr.Read())
                {
                    comboBox1.Items.Add(dr["Nome"]);

                }
                dr.Close();
                dr.Dispose();



            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message, Application.ProductName, MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private void button5_Click(object sender, EventArgs e)
        {
            chart1.Titles.Clear();
            chart1.Series["Series1"].Points.Clear();
            chart1.Series["Series1"].Points.Clear();
            chart1.Series["Series1"].Points.Clear();
            cn1.Open();

            SqlCommand cm = new SqlCommand("cdp.listTeamWinLossDraw", cn1);
            cm.CommandType = CommandType.StoredProcedure;

            cm.Parameters.Add("@TeamID", SqlDbType.VarChar).Value = textBox1.Text;


            try
            {
                SqlDataReader dr = cm.ExecuteReader();

                while (dr.Read())
                {


                    chart1.Titles.Add("V D E");
                    chart1.Series["Series1"].Points.AddXY(dr[0].ToString(), dr[0].ToString());
                    chart1.Series["Series1"].Points.AddXY(dr[2].ToString(), dr[2].ToString());
                    chart1.Series["Series1"].Points.AddXY(dr[1].ToString(), dr[1].ToString());

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

        

        private void chart1_Click(object sender, EventArgs e)
        {

        }

        public void addcombobox1()
        {
            

            //cn1.Open();
            // SqlCommand cm = new SqlCommand("SELECT Nome from cdp.casa_de_apostas;", cn1);

            SqlCommand cm = new SqlCommand("cdp.listAllCompetitions", cn1);
            cm.CommandType = CommandType.StoredProcedure;

            try
            {
                SqlDataReader dr = cm.ExecuteReader();

                while (dr.Read())
                {
                    comboBox1.Items.Add(dr["Nome"]);

                }
                dr.Close();
                dr.Dispose();



            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message, Application.ProductName, MessageBoxButtons.OK, MessageBoxIcon.Error);
            }


        }

        public void addcombobox2()
        {
            


        }

        private void comboBox1_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (comboBox1.SelectedIndex > -1)
            {
                comboBox2.Enabled = true;
            }

            else
            {
                comboBox2.Enabled = false;
               
            }
        }

        private void comboBox2_SelectedIndexChanged(object sender, EventArgs e)
        {
            //dispor as equipas daquela competição

            //cn1.Open();
            // SqlCommand cm = new SqlCommand("SELECT Nome from cdp.casa_de_apostas;", cn1);

            SqlCommand cm = new SqlCommand("cdp.listAllTeamsOnACompetition", cn1);
            cm.CommandType = CommandType.StoredProcedure;

            SqlCommand cm2 = new SqlCommand("cdp.GetCompetitionID", cn1);
            cm2.CommandType = CommandType.StoredProcedure;
            cm2.Parameters.Add("@Name_Comp", SqlDbType.VarChar).Value = comboBox1.SelectedItem.ToString();
            cm2.Parameters.Add("@ID_Comp", SqlDbType.Int).Direction = ParameterDirection.ReturnValue;
            cm2.ExecuteNonQuery();
            int retval = (int)cm2.Parameters["@ID_Comp"].Value;



            cm.Parameters.Add("@CompID", SqlDbType.VarChar).Value = retval;


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

        private void button1_Click(object sender, EventArgs e)
        {

            cn1.Open();
            // SqlCommand cm = new SqlCommand("SELECT Nome from cdp.casa_de_apostas;", cn1);

            SqlCommand cm = new SqlCommand("cdp.listAllTeamPlayers", cn1);
            cm.CommandType = CommandType.StoredProcedure;

            cm.Parameters.Add("@TeamID", SqlDbType.VarChar).Value = textBox2.Text;

            try
            {
                SqlDataReader dr = cm.ExecuteReader();

                while (dr.Read())
                {
                    ListaCasaX.Items.Add(dr["Nome"]);
                    ListaCasaX.Items.Add(dr["Posicao"]);
                    ListaCasaX.Items.Add(" ");

                }
                dr.Close();
                dr.Dispose();



            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message, Application.ProductName, MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private void button3_Click(object sender, EventArgs e)
        {
            chart2.Titles.Clear();
            chart2.Series["GM"].Points.Clear();
            chart2.Series["GS"].Points.Clear();
            cn1.Open();

            SqlCommand cm = new SqlCommand("cdp.listScoredAndSuffGoals", cn1);
            cm.CommandType = CommandType.StoredProcedure;

            cm.Parameters.Add("@TeamID", SqlDbType.VarChar).Value = textBox1.Text;


            try
            {
                SqlDataReader dr = cm.ExecuteReader();

                while (dr.Read())
                {


                    chart2.Titles.Add("GM-GS");
                    chart2.Series["GM"].Points.AddXY(dr[0].ToString(), dr[0].ToString());
                    chart2.Series["GS"].Points.AddXY(dr[1].ToString(), dr[1].ToString());
                    

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
