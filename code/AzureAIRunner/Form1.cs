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


        string _location = "W:\\GITHUB\\AzureAI\\downloaded\\"; 

        private void cmdProcess_Click(object sender, EventArgs e)
        {

            // folder first
            var workFolder = GetNewLocation();
            txtFolder.Text = workFolder;

            //_worker.RunPython(python_sample);
            var url = txtUrl.Text;

            _worker.DownloadYoutube(url, workFolder); 


            // 1. download file 
            // 2.Extract audio
            // 3.Trascribe audio
            // 4.Chunk text
            // a.Run summariser on text
            // 5.Translate summariser
            // Text2Speech summarised text in many languages


            // string fileName = "W:\\Recordings\\010\\Database Migration to Azure SQL DREAM Demo.mp4";
            // _worker.ExtractAudio(fileName);


        }

        private string GetNewLocation()
        {

            int i = 1;

            var newFolder = Path.Combine(_location, string.Format("{0:0000}", i) ); 

            while (Directory.Exists(newFolder))
            {
                i++;
                newFolder = Path.Combine(_location, string.Format("{0:0000}", i));
            }

            Directory.CreateDirectory(newFolder);

            return newFolder; 
        }

        private List<XsltPager> _pager;
        private string _lastUri = "";
        string _tempFolder = ""; 

        private void cmdDisplay_Click(object sender, EventArgs e)
        {
            XsltWorker xw = new XsltWorker();
            // _pager = xw.RenderXsltPaged(_list, "XsltWorks.xslt.PagedView.xslt", pageSize: 100);

            // var folderPath = "W:\\GITHUB\\AzureAI\\downloaded\\0002"; 
            var folderPath = txtFolder.Text;

            var list = GetFiles(folderPath);

            XmlDocument xmlDocument = SerializeEverything(folderPath);

            var filename = xw.RenderXslt(xmlDocument, "XsltWorks.xslt.LandingPage.xslt");
            

            Debug.WriteLine(filename);

            NavigateTo(filename);
        }

        private XmlDocument SerializeEverything(string folder)
        {

            XmlDocument dom = new XmlDocument();
            dom.LoadXml("<xml />"); 

            var list = GetFiles(folder);
            var serializer = new XMLSerializer();
            var str = serializer.SerializeToString(list);

            var filesNode = dom.CreateNode(XmlNodeType.Element, "Files", "");
            filesNode.InnerXml = str;
            dom.DocumentElement.AppendChild(filesNode);

            // append all xml files in the thing

            var files = Directory.GetFiles(folder, "*.xml"); 
            foreach ( var file in files)
            {
                if (!File.Exists(file)) continue;

                var dom1 = new XmlDocument();
                dom1.Load(file);
                var newNode = dom.ImportNode(dom1.DocumentElement, true); 
                dom.DocumentElement.AppendChild(newNode);


            }

            return dom; 
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

                var ext = Path.GetExtension(file);

                switch (ext)
                {
                    case ".txt":
                        item.Type = "text";
                        item.Content = File.ReadAllText(file);
                        break;
                    case ".wav":
                        item.Type = "audio";
                        break;
                    case ".mp4":
                        item.Type = "video";
                        break;
                    case ".summary_all":
                        item.Type = "summary_all";
                        item.Content = File.ReadAllText(file);
                        break;
                    case ".translatedsummary":
                        item.Type = "translated_summary"; 
                        item.Content = File.ReadAllText(file);
                        item.Language = item.Name.Substring(item.Name.LastIndexOf("."));

                        break;
                    case ".mp3":
                        item.Type = "summary_audio"; 
                        break;
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
