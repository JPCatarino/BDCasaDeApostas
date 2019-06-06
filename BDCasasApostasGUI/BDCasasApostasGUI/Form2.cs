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
    public partial class Form2 : Form
    {
        private const string ConnectionString = ("Data Source = " + "tcp:mednat.ieeta.pt\\SQLSERVER,8101" + " ;" + "Initial Catalog = " + "p3g6" +
      "; uid = " + "p3g6" + ";" + "password = " + "Javardices123");
        private SqlConnection cn;
        
        public Form2()
        {
            InitializeComponent();
        }

       SqlConnection cn1 = new SqlConnection("Data Source = " + "tcp:mednat.ieeta.pt\\SQLSERVER,8101" + " ;" + "Initial Catalog = " + "p3g6" +
      "; uid = " + "p3g6" + ";" + "password = " + "Javardices123");

        DataTable dt = new DataTable();


        private void Form2_Shown(object sender, EventArgs e)
        {
            try
            {
                cn1.Open();
            }
            catch (SqlException ex)
            {
                MessageBox.Show(ex.Message, Application.ProductName, MessageBoxButtons.OK, MessageBoxIcon.Error);
                Application.Exit();
            }

        }

            private void listBox1_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        private void button1_Click(object sender, EventArgs e)
        {

            dt.Clear();
            //cn1.Open();
            // SqlCommand cm = new SqlCommand("SELECT Nome from cdp.casa_de_apostas;", cn1);

            SqlCommand cm = new SqlCommand("cdp.ListBettersPerBooker", cn1);
            cm.CommandType = CommandType.StoredProcedure;

            cm.Parameters.Add("@Name_Booker", SqlDbType.VarChar).Value = comboBox1.SelectedItem.ToString();
            
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
                //cn1.Close();

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

        private void button4_Click(object sender, EventArgs e)
        {
            var novoJogoForm = new Form3();
            novoJogoForm.Show();
        }

        private void button6_Click(object sender, EventArgs e)
        {
            var removeJogoForm = new RemoverJogo();
            removeJogoForm.Show();

        }

        private void button5_Click(object sender, EventArgs e)
        {
            var listaJogosApostador = new listaJogosApostadorX();
            listaJogosApostador.Show();

        }

        private void flowLayoutPanel1_Paint(object sender, PaintEventArgs e)
        {

        }
       
        private void comboBox1_SelectedIndexChanged(object sender, EventArgs e)

        {
            button1.Enabled = true;
            button2.Enabled = true;
            button3.Enabled = true;
            button4.Enabled = true;
            button5.Enabled = true;
            button6.Enabled = true;
            button7.Enabled = true;
            button8.Enabled = true;
            button9.Enabled = true;
            button10.Enabled = true;

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
            catch(Exception ex)
            {
                MessageBox.Show(ex.Message, Application.ProductName, MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private void button3_Click(object sender, EventArgs e)
        {
            //cn1.Open();
            // SqlCommand cm = new SqlCommand("SELECT Nome from cdp.casa_de_apostas;", cn1);

            SqlCommand cm = new SqlCommand("cdp.ListAvailableCompetitionsOnBooker", cn1);
            cm.CommandType = CommandType.StoredProcedure;

            cm.Parameters.Add("@Name_Booker", SqlDbType.VarChar).Value = comboBox1.SelectedItem.ToString();

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
                //cn1.Close();

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

            private void button2_Click(object sender, EventArgs e)
        {
            
            dt.Clear();
            dataGridView1.DataSource = null;
            dataGridView1.Rows.Clear();
            dataGridView1.Columns.Clear();
              //cn1.Open();
              // SqlCommand cm = new SqlCommand("SELECT Nome from cdp.casa_de_apostas;", cn1);

            SqlCommand cm = new SqlCommand("cdp.ListAvailableGamesPerBooker", cn1);
            cm.CommandType = CommandType.StoredProcedure;

            cm.Parameters.Add("@Name_Booker", SqlDbType.VarChar).Value = comboBox1.SelectedItem.ToString();
            //cm.Parameters.Add("@Name_Booker", SqlDbType.VarChar).Value = comboBox1.Text;

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



            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message, Application.ProductName, MessageBoxButtons.OK, MessageBoxIcon.Error);
            }

        }

        private void Form2_Enter(object sender, EventArgs e)
        {

        }

        private void Form2_Load(object sender, EventArgs e)
        {
            // SqlCommand cm = new SqlCommand("SELECT Nome from cdp.casa_de_apostas;", cn1);
            cn1.Open();
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

            button1.Enabled = false;
            button2.Enabled = false;
            button3.Enabled = false;
            button4.Enabled = false;
            button5.Enabled = false;
            button6.Enabled = false;
            button7.Enabled = false;
            button8.Enabled = false;
            button9.Enabled = false;
            button10.Enabled = false;
        }

        private void button10_Click(object sender, EventArgs e)
        {
            var listajogosporComp = new selecionacomp();
            listajogosporComp.Show();
        }

        private void button11_Click(object sender, EventArgs e)
        {

        }

        private void label11_Click(object sender, EventArgs e)
        {

        }

        private void panel1_Paint(object sender, PaintEventArgs e)
        {

        }

        private void label5_Click(object sender, EventArgs e)
        {

        }

        private void button8_Click(object sender, EventArgs e)
        {
            var comp = new newComp();
            comp.Show();
        }

        private void button7_Click(object sender, EventArgs e)
        {
            var na = new NovaAposta();
            na.Show();
        }
    }
}
