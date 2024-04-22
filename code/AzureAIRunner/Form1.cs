using AzureAIRunner.Interfaces;
using Microsoft.VisualBasic.Devices;
using System.Diagnostics;
using System.Xml;
using XsltWorks;
using static System.Windows.Forms.VisualStyles.VisualStyleElement;

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

            InitUI();
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

        private void InitUI()
        {
            _tempFolder = Path.GetTempPath(); 
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


            _worker.ExtractAudio(fileName);


        }

        private List<XsltPager> _pager;
        private string _lastUri = "";
        string _tempFolder = ""; 

        private void cmdDisplay_Click(object sender, EventArgs e)
        {
            XsltWorker xw = new XsltWorker();
            // _pager = xw.RenderXsltPaged(_list, "XsltWorks.xslt.PagedView.xslt", pageSize: 100);

            var folderPath = "W:\\GITHUB\\AzureAI\\downloaded\\0002"; 

            var list = GetFiles(folderPath);

            XmlDocument xmlDocument = new XmlDocument();
            xmlDocument.LoadXml("<xml />");
            

            var filename = xw.RenderXslt(list, "XsltWorks.xslt.LandingPage.xslt");
            

            Debug.WriteLine(filename);

            NavigateTo(filename);
        }

        private List<FileItem> GetFiles(string folder)
        {

            var list = new List<FileItem>();

            foreach ( var file in Directory.GetFiles(folder))
            {
                var item = new FileItem()
                {
                    Name = Path.GetFileNameWithoutExtension(file),
                    FileName = file
                }; 

                if (Path.GetExtension(file) == ".txt")
                {
                    item.Type = "text";
                    item.Content = File.ReadAllText(file);
                }
                else if (Path.GetExtension(file) == ".wav")
                {
                    item.Type = "audio";
                    
                }
                else if (Path.GetExtension(file) == ".mp4")
                {
                    item.Type = "video";
                    
                }
                list.Add(item);


            }


            return list; 


        }


        public void NavigateTo(string fileName)
        {
            webView.CoreWebView2.Navigate(fileName);
        }

    }
}
