namespace BDCasasApostasGUI
{
    partial class selecionacomp
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
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(selecionacomp));
            this.label1 = new System.Windows.Forms.Label();
            this.textBox1 = new System.Windows.Forms.TextBox();
            this.ListaCasaX = new System.Windows.Forms.ListBox();
            this.button10 = new System.Windows.Forms.Button();
            this.label10 = new System.Windows.Forms.Label();
            this.SuspendLayout();
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Font = new System.Drawing.Font("Roboto", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label1.ForeColor = System.Drawing.Color.RoyalBlue;
            this.label1.Location = new System.Drawing.Point(40, 151);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(206, 24);
            this.label1.TabIndex = 3;
            this.label1.Text = "Nome da competição:";
            // 
            // textBox1
            // 
            this.textBox1.Location = new System.Drawing.Point(277, 151);
            this.textBox1.Name = "textBox1";
            this.textBox1.Size = new System.Drawing.Size(142, 22);
            this.textBox1.TabIndex = 2;
            // 
            // ListaCasaX
            // 
            this.ListaCasaX.FormattingEnabled = true;
            this.ListaCasaX.ItemHeight = 16;
            this.ListaCasaX.Location = new System.Drawing.Point(486, 43);
            this.ListaCasaX.Name = "ListaCasaX";
            this.ListaCasaX.Size = new System.Drawing.Size(268, 356);
            this.ListaCasaX.TabIndex = 4;
            // 
            // button10
            // 
            this.button10.BackgroundImage = ((System.Drawing.Image)(resources.GetObject("button10.BackgroundImage")));
            this.button10.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Stretch;
            this.button10.Location = new System.Drawing.Point(182, 217);
            this.button10.Name = "button10";
            this.button10.Size = new System.Drawing.Size(79, 80);
            this.button10.TabIndex = 24;
            this.button10.UseVisualStyleBackColor = true;
            this.button10.Click += new System.EventHandler(this.button10_Click);
            // 
            // label10
            // 
            this.label10.AutoSize = true;
            this.label10.Font = new System.Drawing.Font("Roboto", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label10.ForeColor = System.Drawing.Color.RoyalBlue;
            this.label10.Location = new System.Drawing.Point(190, 300);
            this.label10.Name = "label10";
            this.label10.Size = new System.Drawing.Size(61, 24);
            this.label10.TabIndex = 25;
            this.label10.Text = "Listar";
            this.label10.TextAlign = System.Drawing.ContentAlignment.TopCenter;
            // 
            // selecionacomp
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 16F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(808, 415);
            this.Controls.Add(this.button10);
            this.Controls.Add(this.label10);
            this.Controls.Add(this.ListaCasaX);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.textBox1);
            this.Name = "selecionacomp";
            this.Text = "selecionacomp";
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.TextBox textBox1;
        private System.Windows.Forms.ListBox ListaCasaX;
        private System.Windows.Forms.Button button10;
        private System.Windows.Forms.Label label10;
    }
}