﻿using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
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
    public partial class Form1 : Form
    {

       

        private const string ConnectionString = ("Data Source = " + "tcp:mednat.ieeta.pt\\SQLSERVER,8101" + " ;" + "Initial Catalog = " + "p3g6" +
       "; uid = " + "p3g6" + ";" + "password = " + "Javardices123");
        private SqlConnection cn;
        public Form1()
        {
            cn = getSGBDConnection();
            InitializeComponent();
            MenuTest();
        }

     

        /*private void Form1_Load(object sender, EventArgs e)
        {
            cn = getSGBDConnection();
            
        }
        */

         private SqlConnection getSGBDConnection() 
        {
            return new SqlConnection(ConnectionString);
        }

        private bool verifySGBDConnection() 
        {
            if (cn == null)
                cn = getSGBDConnection();

            if (cn.State != ConnectionState.Open)
                cn.Open();

            return cn.State == ConnectionState.Open;
        }

        private void button1_Click(object sender, EventArgs e)
        {
            var casas = new Form2();
            casas.Show();
        }

        private MainMenu mainMenu;
        private ContextMenu popUpMenu;

        public void MenuTest()
        {
            mainMenu = new MainMenu();
            popUpMenu = new ContextMenu();
            
            this.ContextMenu = popUpMenu;
            MenuItem File = mainMenu.MenuItems.Add("&File");
            

           
            File.MenuItems.Add(new MenuItem("-"));
            File.MenuItems.Add(new MenuItem("&Exit", new EventHandler(this.FileExit_clicked), Shortcut.CtrlX));
            this.Menu = mainMenu;
            MenuItem About = mainMenu.MenuItems.Add("&About");
            About.MenuItems.Add(new MenuItem("&About", new EventHandler(this.About_clicked), Shortcut.F1));
            this.Menu = mainMenu;
            //mainMenu.GetForm().BackColor = Color.Indigo;
        }
        private void FileExit_clicked(object sender, EventArgs e)
        {
            this.Close();
        }
        private void FileNew_clicked(object sender, EventArgs e)
        {
            //   MessageBox.Show("New", "MENU_CREATION", MessageBoxButtons.OK, MessageBoxIcon.Information);
            var novaCasa = new NovaCasa();
            novaCasa.Show();


        }
       
        private void About_clicked(object sender, EventArgs e)
        {
            MessageBox.Show("Aplicação de gestão de Casas de Apostas");
        }



        private void button3_Click(object sender, EventArgs e)
        {
            var novaCasa = new NovaCasa();
            novaCasa.Show();

        }

        private void button4_Click(object sender, EventArgs e)
        {
            var removeCasa = new Form4();
            removeCasa.Show();
        }

        

        private void button1_Click_1(object sender, EventArgs e)
        {
            var novaCasa = new NovaCasa();
            novaCasa.Show();

        }

        private void button2_Click(object sender, EventArgs e)
        {
            var removeCasa = new Form4();
            removeCasa.Show();
        }

        private void button3_Click_1(object sender, EventArgs e)
        {
            var casas = new Form2();
            casas.Show();
        }

        private void button4_Click_1(object sender, EventArgs e)
        {
            var infoeq = new infoequipas();
            infoeq.Show();

        }
    }

}
