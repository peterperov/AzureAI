using System.Diagnostics;

namespace AzureAIRunner
{
    public partial class Form1 : Form
    {


        string python_sample = @"W:\GITHUB\AzureAI\python\sample.py";
        string PYTHON = @""; 

        public Form1()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            webView.CoreWebView2.Navigate("https://www.microsoft.com/");
        }

        private void Form1_Load(object sender, EventArgs e)
        {

        }

        private void cmdProcess_Click(object sender, EventArgs e)
        {
            RunPython(python_sample); 
        }


        string python = "python.exe";


        private void RunPython(string args)
        {

            // " c:\root\vcsi\vcsi.py ""{0}"" -o ""{1}""
            // var args = string.Format(@" ""{0}"" ""{1}"" -o ""{2}"" -g 4x4",   AppSettings.VCSI, item.FullPath, thumbFile);

            Console.WriteLine("{0} {1}", python, args);

            var psi = new ProcessStartInfo()
            {
                FileName = python,
                Arguments = args,
                CreateNoWindow = false,
                WindowStyle = ProcessWindowStyle.Normal,
                // WindowStyle = ProcessWindowStyle.Hidden,
                RedirectStandardOutput = true,
                UseShellExecute = false
            };

             

            var p = System.Diagnostics.Process.Start(psi);

            p.WaitForExit();

            var output = p.StandardOutput.ReadToEnd();

            // Console.WriteLine(output);

            Debug.WriteLine(output); 


        }


    }
}
