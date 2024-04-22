namespace AzureAIRunner
{
    partial class Form1
    {
        /// <summary>
        ///  Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        ///  Clean up any resources being used.
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
        ///  Required method for Designer support - do not modify
        ///  the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            groupBox1 = new GroupBox();
            cmdDisplay = new Button();
            cmdProcess = new Button();
            textBox1 = new TextBox();
            button1 = new Button();
            webView = new Microsoft.Web.WebView2.WinForms.WebView2();
            groupBox1.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)webView).BeginInit();
            SuspendLayout();
            // 
            // groupBox1
            // 
            groupBox1.Controls.Add(cmdDisplay);
            groupBox1.Controls.Add(cmdProcess);
            groupBox1.Controls.Add(textBox1);
            groupBox1.Controls.Add(button1);
            groupBox1.Dock = DockStyle.Top;
            groupBox1.Location = new Point(0, 0);
            groupBox1.Margin = new Padding(2);
            groupBox1.Name = "groupBox1";
            groupBox1.Padding = new Padding(2);
            groupBox1.Size = new Size(969, 88);
            groupBox1.TabIndex = 0;
            groupBox1.TabStop = false;
            // 
            // cmdDisplay
            // 
            cmdDisplay.Location = new Point(751, 33);
            cmdDisplay.Name = "cmdDisplay";
            cmdDisplay.Size = new Size(112, 34);
            cmdDisplay.TabIndex = 3;
            cmdDisplay.Text = "Display";
            cmdDisplay.UseVisualStyleBackColor = true;
            cmdDisplay.Click += cmdDisplay_Click;
            // 
            // cmdProcess
            // 
            cmdProcess.Location = new Point(463, 32);
            cmdProcess.Margin = new Padding(2);
            cmdProcess.Name = "cmdProcess";
            cmdProcess.Size = new Size(147, 36);
            cmdProcess.TabIndex = 2;
            cmdProcess.Text = "Process";
            cmdProcess.UseVisualStyleBackColor = true;
            cmdProcess.Click += cmdProcess_Click;
            // 
            // textBox1
            // 
            textBox1.Location = new Point(9, 35);
            textBox1.Margin = new Padding(2);
            textBox1.Name = "textBox1";
            textBox1.Size = new Size(450, 31);
            textBox1.TabIndex = 1;
            // 
            // button1
            // 
            button1.Location = new Point(878, 32);
            button1.Margin = new Padding(2);
            button1.Name = "button1";
            button1.Size = new Size(82, 36);
            button1.TabIndex = 0;
            button1.Text = "Test";
            button1.UseVisualStyleBackColor = true;
            button1.Click += button1_Click;
            // 
            // webView
            // 
            webView.AllowExternalDrop = true;
            webView.CreationProperties = null;
            webView.DefaultBackgroundColor = Color.White;
            webView.Dock = DockStyle.Fill;
            webView.Location = new Point(0, 88);
            webView.Margin = new Padding(2);
            webView.Name = "webView";
            webView.Size = new Size(969, 767);
            webView.Source = new Uri("about:blank", UriKind.Absolute);
            webView.TabIndex = 1;
            webView.ZoomFactor = 1D;
            // 
            // Form1
            // 
            AutoScaleDimensions = new SizeF(10F, 25F);
            AutoScaleMode = AutoScaleMode.Font;
            ClientSize = new Size(969, 855);
            Controls.Add(webView);
            Controls.Add(groupBox1);
            Margin = new Padding(2);
            Name = "Form1";
            Text = "Form1";
            Load += Form1_Load;
            groupBox1.ResumeLayout(false);
            groupBox1.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)webView).EndInit();
            ResumeLayout(false);
        }

        #endregion

        private GroupBox groupBox1;
        private Button button1;
        private Microsoft.Web.WebView2.WinForms.WebView2 webView;
        private Button cmdProcess;
        private TextBox textBox1;
        private Button cmdDisplay;
    }
}
