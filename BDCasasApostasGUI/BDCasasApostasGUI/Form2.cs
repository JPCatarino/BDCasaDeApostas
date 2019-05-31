using System;
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
    public partial class Form2 : Form
    {
        public Form2()
        {
            InitializeComponent();
        }

        private void listBox1_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        private void button1_Click(object sender, EventArgs e)
        {

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
    }
}
