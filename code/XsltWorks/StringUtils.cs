using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace XsltWorks
{
    public class StringUtils
    {

        public static string DumpFile(string aFileName, string aString)
        {
            FileStream fs = new FileStream(aFileName, FileMode.Create);
            StreamWriter w = new StreamWriter(fs);
            // set the file pointer to the end
            // w.BaseStream.Seek(0, SeekOrigin.End);
            w.Write(aString);
            w.Flush();
            w.Close();
            w = null;

            return aFileName;
        }

        public static string LoadFile(string fileName)
        {
            return File.ReadAllText(fileName); 
        }
    }
}
