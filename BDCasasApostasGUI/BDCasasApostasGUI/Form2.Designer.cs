namespace BDCasasApostasGUI
{
    partial class Form2
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.comboBox1 = new System.Windows.Forms.ComboBox();
            this.ListaCasaX = new System.Windows.Forms.ListBox();
            this.panel1 = new System.Windows.Forms.Panel();
            this.button1 = new System.Windows.Forms.Button();
            this.button2 = new System.Windows.Forms.Button();
            this.button3 = new System.Windows.Forms.Button();
            this.button4 = new System.Windows.Forms.Button();
            this.button5 = new System.Windows.Forms.Button();
            this.button6 = new System.Windows.Forms.Button();
            this.button7 = new System.Windows.Forms.Button();
            this.button8 = new System.Windows.Forms.Button();
            this.button9 = new System.Windows.Forms.Button();
            this.button11 = new System.Windows.Forms.Button();
            this.panel1.SuspendLayout();
            this.SuspendLayout();
            // 
            // comboBox1
            // 
            this.comboBox1.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.comboBox1.FormattingEnabled = true;
            this.comboBox1.Location = new System.Drawing.Point(27, 19);
            this.comboBox1.Name = "comboBox1";
            this.comboBox1.Size = new System.Drawing.Size(149, 24);
            this.comboBox1.TabIndex = 0;
            // 
            // ListaCasaX
            // 
            this.ListaCasaX.FormattingEnabled = true;
            this.ListaCasaX.ItemHeight = 16;
            this.ListaCasaX.Location = new System.Drawing.Point(508, 60);
            this.ListaCasaX.Name = "ListaCasaX";
            this.ListaCasaX.Size = new System.Drawing.Size(281, 372);
            this.ListaCasaX.TabIndex = 1;
            this.ListaCasaX.SelectedIndexChanged += new System.EventHandler(this.listBox1_SelectedIndexChanged);
            // 
            // panel1
            // 
            this.panel1.Controls.Add(this.button11);
            this.panel1.Controls.Add(this.button9);
            this.panel1.Controls.Add(this.button7);
            this.panel1.Controls.Add(this.button8);
            this.panel1.Controls.Add(this.button6);
            this.panel1.Controls.Add(this.button5);
            this.panel1.Controls.Add(this.button4);
            this.panel1.Controls.Add(this.button3);
            this.panel1.Controls.Add(this.button2);
            this.panel1.Controls.Add(this.button1);
            this.panel1.Controls.Add(this.comboBox1);
            this.panel1.Location = new System.Drawing.Point(50, 58);
            this.panel1.Name = "panel1";
            this.panel1.Size = new System.Drawing.Size(434, 597);
            this.panel1.TabIndex = 2;
            // 
            // button1
            // 
            this.button1.Location = new System.Drawing.Point(27, 75);
            this.button1.Name = "button1";
            this.button1.Size = new System.Drawing.Size(115, 62);
            this.button1.TabIndex = 1;
            this.button1.Text = "Lista de Apostadores";
            this.button1.UseVisualStyleBackColor = true;
            this.button1.Click += new System.EventHandler(this.button1_Click);
            // 
            // button2
            // 
            this.button2.Location = new System.Drawing.Point(27, 195);
            this.button2.Name = "button2";
            this.button2.Size = new System.Drawing.Size(115, 62);
            this.button2.TabIndex = 2;
            this.button2.Text = "Lista de jogos da Casa";
            this.button2.UseVisualStyleBackColor = true;
            // 
            // button3
            // 
            this.button3.Location = new System.Drawing.Point(27, 310);
            this.button3.Name = "button3";
            this.button3.Size = new System.Drawing.Size(115, 62);
            this.button3.TabIndex = 3;
            this.button3.Text = "Lista de Competições";
            this.button3.UseVisualStyleBackColor = true;
            // 
            // button4
            // 
            this.button4.Location = new System.Drawing.Point(169, 195);
            this.button4.Name = "button4";
            this.button4.Size = new System.Drawing.Size(115, 62);
            this.button4.TabIndex = 4;
            this.button4.Text = "Adicionar novo jogo para apostar";
            this.button4.UseVisualStyleBackColor = true;
            // 
            // button5
            // 
            this.button5.Location = new System.Drawing.Point(169, 75);
            this.button5.Name = "button5";
            this.button5.Size = new System.Drawing.Size(115, 62);
            this.button5.TabIndex = 5;
            this.button5.Text = "Lista de jogos onde utilizador X apostou";
            this.button5.UseVisualStyleBackColor = true;
            // 
            // button6
            // 
            this.button6.Location = new System.Drawing.Point(304, 195);
            this.button6.Name = "button6";
            this.button6.Size = new System.Drawing.Size(115, 62);
            this.button6.TabIndex = 6;
            this.button6.Text = "Remover jgoo da casa";
            this.button6.UseVisualStyleBackColor = true;
            // 
            // button7
            // 
            this.button7.Location = new System.Drawing.Point(304, 478);
            this.button7.Name = "button7";
            this.button7.Size = new System.Drawing.Size(115, 62);
            this.button7.TabIndex = 7;
            this.button7.Text = "Expulsar apostador da casa";
            this.button7.UseVisualStyleBackColor = true;
            // 
            // button8
            // 
            this.button8.Location = new System.Drawing.Point(169, 310);
            this.button8.Name = "button8";
            this.button8.Size = new System.Drawing.Size(115, 62);
            this.button8.TabIndex = 8;
            this.button8.Text = "Adicionar Competição";
            this.button8.UseVisualStyleBackColor = true;
            // 
            // button9
            // 
            this.button9.Location = new System.Drawing.Point(304, 310);
            this.button9.Name = "button9";
            this.button9.Size = new System.Drawing.Size(115, 62);
            this.button9.TabIndex = 9;
            this.button9.Text = "Remover Competição";
            this.button9.UseVisualStyleBackColor = true;
            // 
            // button11
            // 
            this.button11.Location = new System.Drawing.Point(27, 392);
            this.button11.Name = "button11";
            this.button11.Size = new System.Drawing.Size(115, 62);
            this.button11.TabIndex = 11;
            this.button11.Text = "Definir as odds para um jogo";
            this.button11.UseVisualStyleBackColor = true;
            // 
            // Form2
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 16F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(1133, 667);
            this.Controls.Add(this.panel1);
            this.Controls.Add(this.ListaCasaX);
            this.Name = "Form2";
            this.Text = "Form2";
            this.panel1.ResumeLayout(false);
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.ComboBox comboBox1;
        private System.Windows.Forms.ListBox ListaCasaX;
        private System.Windows.Forms.Panel panel1;
        private System.Windows.Forms.Button button1;
        private System.Windows.Forms.Button button2;
        private System.Windows.Forms.Button button3;
        private System.Windows.Forms.Button button4;
        private System.Windows.Forms.Button button5;
        private System.Windows.Forms.Button button7;
        private System.Windows.Forms.Button button6;
        private System.Windows.Forms.Button button11;
        private System.Windows.Forms.Button button9;
        private System.Windows.Forms.Button button8;
    }
}