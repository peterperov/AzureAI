using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AzureAIRunner
{
    public class AIWorker
    {



        public string PythonFolder { get; set; }


        public string extractAudio = "2audio_extractor.py";



        public AIWorker()
        {

            PythonFolder = @"W:\GITHUB\AzureAI\python";
        }


        public void DownloadYoutube(string url, string workFolder)
        {
            // 
            var step1 = "net_step1.py";

            string args = string.Format("\"{0}\" \"{1}\" \"{2}\"",
                Path.Combine(PythonFolder, step1), url, workFolder);

            RunPython(args);

        }


        public void ExtractAudio(string fileName)
        {
            string args = string.Format("\"{0}\" \"{1}\"", 
                Path.Combine(PythonFolder, extractAudio), fileName );

            RunPython(args); 


        }


        string python = "python.exe";


        public void RunPython(string args)
        {

            // " c:\root\vcsi\vcsi.py ""{0}"" -o ""{1}""
            // var args = string.Format(@" ""{0}"" ""{1}"" -o ""{2}"" -g 4x4",   AppSettings.VCSI, item.FullPath, thumbFile);

            Console.WriteLine("{0} {1}", python, args);

            var buffer = new StringBuilder();

            var psi = new ProcessStartInfo()
            {
                FileName = python,
                Arguments = args,
                CreateNoWindow = false,
                WindowStyle = ProcessWindowStyle.Normal,
                // WindowStyle = ProcessWindowStyle.Hidden,
                RedirectStandardOutput = false,
                RedirectStandardError = true,
                UseShellExecute = false
            };

            // p = new Process(psi); 



            var p = System.Diagnostics.Process.Start(psi);
            // hookup the eventhandlers to capture the data that is received
            // p.OutputDataReceived += (sender, args) => buffer.AppendLine(args.Data);
            p.ErrorDataReceived += (sender, args) => buffer.AppendLine(args.Data);

            // start our event pumps
            // p.BeginOutputReadLine();
            p.BeginErrorReadLine();

            p.WaitForExit();

            // var output = p.StandardOutput.ReadToEnd();

            // Console.WriteLine(output);

            Debug.WriteLine(buffer.ToString());


        }





    }
}
