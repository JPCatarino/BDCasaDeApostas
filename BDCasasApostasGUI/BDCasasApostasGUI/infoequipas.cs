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
    public partial class infoequipas : Form
    {
        public infoequipas()
        {
            InitializeComponent();

            chart1.Titles.Add("V E D");

            chart1.Series["Series1"].Points.AddXY("Vitórias", "33");
            chart1.Series["Series1"].Points.AddXY("Empates", "34");
            chart1.Series["Series1"].Points.AddXY("Derrotas", "33");
        }

        private void infoequipas_Load(object sender, EventArgs e)
        {

        }

        private void label7_Click(object sender, EventArgs e)
        {

        }
    }
}
