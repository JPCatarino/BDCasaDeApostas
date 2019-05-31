using System;
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

namespace BDCasasApostasGUI
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
            MenuTest();
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
            popUpMenu.MenuItems.Add("Hello", new EventHandler(pop_Clicked));
            this.ContextMenu = popUpMenu;
            MenuItem File = mainMenu.MenuItems.Add("&File");
            File.MenuItems.Add(new MenuItem("&New", new EventHandler(this.FileNew_clicked), Shortcut.CtrlN));
            File.MenuItems.Add(new MenuItem("&Open", new EventHandler(this.FileOpen_clicked), Shortcut.CtrlO));
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
        private void FileOpen_clicked(object sender, EventArgs e)
        {
            MessageBox.Show("Open", "MENU_CREATION", MessageBoxButtons.OK, MessageBoxIcon.Information);
        }
        private void pop_Clicked(object sender, EventArgs e)
        {
            MessageBox.Show("Popupmenu", "MENU_CREATION", MessageBoxButtons.OK, MessageBoxIcon.Information);
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
    }

}
