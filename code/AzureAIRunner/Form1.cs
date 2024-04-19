using Microsoft.VisualBasic.Devices;
using System.Diagnostics;

namespace AzureAIRunner
{
    public partial class Form1 : Form
    {


        string python_sample = @"W:\GITHUB\AzureAI\python\sample.py";
        string PYTHON = @"";

        AIWorker _worker = new AIWorker(); 



        public Form1()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {

            string uri = "file:///W:/GITHUB/AzureAI/code/AzureAIRunner/start.html"; 
            // webView.CoreWebView2.Navigate("https://www.microsoft.com/");
            webView.CoreWebView2.Navigate(uri);
        }

        private void Form1_Load(object sender, EventArgs e)
        {

        }

        private void cmdProcess_Click(object sender, EventArgs e)
        {
            //_worker.RunPython(python_sample);

            // 1. download file 
            // 2.Extract audio
            // 3.Trascribe audio
            // 4.Chunk text
            // a.Run summariser on text
            // 5.Translate summariser
            // Text2Speech summarised text in many languages


            string fileName = "W:\\Recordings\\010\\Database Migration to Azure SQL DREAM Demo.mp4"; 


            _worker.ExtractAudio (fileName);


        }



    }
}
