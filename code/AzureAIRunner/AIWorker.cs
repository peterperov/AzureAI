using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Runtime.Intrinsics.X86;
using System.Security.Policy;
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


        public void AddTranslation(string folder, string language)
        {
            // filename .summaryall
            var summaryFile = Directory.GetFiles(folder, "*.summaryall").FirstOrDefault();
            if (string.IsNullOrEmpty(summaryFile)) { throw new Exception(string.Format("can't find .summaryall file in {0}", folder)); }

            var translate_py = "net_translate.py";
            string args = string.Format("\"{0}\" \"{1}\" \"{2}\"", Path.Combine(PythonFolder, translate_py), summaryFile, language);

            RunPython(args);

        }

        public void AddVoice(string folder, string voice)
        {
            // filename .summaryall
            var summaryFile = Directory.GetFiles(folder, "*.summaryall").FirstOrDefault();
            if (string.IsNullOrEmpty(summaryFile)) { throw new Exception(string.Format("can't find .summaryall file in {0}", folder)); }

            var array = voice.Split("-");
            var lang = array[0];
            var translationFile = Directory.GetFiles(folder, string.Format("*.{0}.translatedsummary", lang)).FirstOrDefault();
            if (string.IsNullOrEmpty(translationFile))
            {
                AddTranslation(folder, lang);
            }

            translationFile = Directory.GetFiles(folder, string.Format("*.{0}.translatedsummary", lang)).FirstOrDefault();

            var voice_py = "net_voice.py";
            /*
            voice_name = sys.argv[0]
            lang = sys.argv[1]
            out_file = sys.argv[2]
            summary_file = sys.argv[3]
            */

            var locale = string.Format("{0}-{1}", array[0], array[1]);

            // # out_file = out_folder + voice_name + "." + "summary.mp3"

            var out_file = Path.Combine(folder, voice + ".summary.mp3");

            string args = string.Format("\"{0}\" \"{1}\" \"{2}\" \"{3}\" \"{4}\"", Path.Combine(PythonFolder, voice_py),
                voice, locale, out_file, translationFile);

            Debug.WriteLine(args);

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
