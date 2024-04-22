using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AzureAIRunner.Interfaces
{
    [Serializable]
    public class FileItem
    {

        public string Name { get; set; }    

        public string FileName { get; set; }

        public string FileNameEncoded { get; set; }

        public string Type { get; set; }

        public string Content { get; set; }

        public string Language { get; set; }

    }
}
