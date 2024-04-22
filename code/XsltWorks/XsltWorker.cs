using System.Reflection;
using System.Xml.Serialization;
using System.Xml.Xsl;
using System.Xml;

namespace XsltWorks
{
    public class XsltWorker
    {

        public static bool DebugOutput = false; 


        /// <summary>
        /// returns top page
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="list"></param>
        /// <param name="xsltResource"></param>
        /// <param name="fileName"></param>
        /// <param name="pageSize"></param>
        /// <returns></returns>
        public List<XsltPager> RenderXsltPaged<T>(List<T> list,
                string xsltResource = "XsltWorks.xslt.PagedView.xslt",
                string fileName = null,
                int pageSize = 300)
        {

            var count = list.Count;



            // split to pages
            if (string.IsNullOrEmpty(fileName))
            {
                fileName = Path.GetTempFileName() + ".html";
            }

            var selected = new List<T>();
            var cnt = 0;
            var page = 0;
            int pages = (int)(count / pageSize);
            var pagerList = GetPagerList(pages, fileName);

            var xslt = GetXslt(xsltResource);

            // if single page - no bother
            if (count <= pageSize)
            {
                // return RenderXslt<T>(list, xsltResource, fileName);
                RunRender(xslt, new XsltPagerInfo(new List<XsltPager>(), page, pages, pageSize), list, fileName);
            }



            while (cnt < count)
            {
                selected.Add(list[cnt]);

                cnt++;

                if (cnt % pageSize == 0)
                {
                    RunRender(xslt, new XsltPagerInfo(pagerList, page, pages, pageSize), selected, pagerList[page].FileName);
                    page++;
                    selected = new List<T>();
                }

            }

            // process leftovers
            if (selected.Count > 0)
            {
                RunRender(xslt, new XsltPagerInfo(pagerList, page, pages, pageSize), selected, pagerList[page].FileName);
            }

            return pagerList;
        }


        private string RunRender<T>(
            XslCompiledTransform xslt,
            XsltPagerInfo pagerInfo,
            List<T> selected,
            string fileName)
        {
            var serializer = new XMLSerializer();

            var domPager = new XmlDocument();
            domPager.LoadXml(serializer.SerializeToString(pagerInfo));

            var dom = new XmlDocument();
            dom.LoadXml(serializer.SerializeToString(selected));

            var node = dom.CreateNode(XmlNodeType.Element, "pager", "");
            node.InnerXml = serializer.SerializeToString(pagerInfo);
            dom.DocumentElement.AppendChild(node);

            // dom.DocumentElement.AppendChild(domPager.DocumentElement);


            return RenderXslt(dom, xslt, fileName);
        }


        private List<XsltPager> GetPagerList(int pages, string fileName)
        {

            var list = new List<XsltPager>();
            var path = Path.GetDirectoryName(fileName);
            var name = Path.GetFileNameWithoutExtension(fileName);
            var ext = Path.GetExtension(fileName);

            for (int i = 0; i <= pages; i++)
            {
                string newName = name + ext;
                if (i > 0)
                {
                    newName = string.Format("{0}_{1:000}{2}", name, i, ext);
                }

                string newFullName = Path.Combine(path, newName);

                list.Add(new XsltPager(
                    i,
                    newName,
                    newFullName,
                    newFullName.Replace("\\", "/")
                    ));
            }

            return list;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="dom"></param>
        /// <param name="xslt"></param>
        /// <param name="fileName"></param>
        /// <returns>filename of generated xml</returns>
        public string RenderXslt(
            XmlDocument dom,
            XslCompiledTransform xslt,
                string fileName)
        {

            XsltArgumentList args = new XsltArgumentList();
            args.AddParam("arg1", "", "arg1_value");

            using (StringWriter writer = new StringWriter())
            {
                using (XmlTextWriter xw = new XmlTextWriter(writer))
                {
                    xw.Formatting = Formatting.Indented;
                    xw.Indentation = 3;

                    xslt.Transform(dom, args, xw);
                    xw.Close();

                    if (string.IsNullOrEmpty(fileName))
                    {
                        fileName = Path.GetTempFileName() + ".html";
                    }
                    else
                    {
                        if (DebugOutput)
                        {
                            // dump xml to output
                            var xmlFileName = fileName + ".xml";
                            StringUtils.DumpFile(xmlFileName, XmlUtils.Beautify(dom));
                        }

                    }

                    // save file 
                    StringUtils.DumpFile(fileName, writer.ToString());
                }
            }


            return fileName;
        }


        public string RenderXslt<T>(List<T> list,
                string xsltResource = "XsltWorks.xslt.pager.xslt",
                string fileName = null)
        {
            var serializer = new XMLSerializer();
            var str = serializer.SerializeToString(list);

            // Console.WriteLine(XmlUtils.Beautify(str));

            XsltArgumentList args = new XsltArgumentList();
            args.AddParam("arg1", "", "arg1_value");

            XslCompiledTransform xslt = GetXslt(xsltResource);

            using (StringWriter writer = new StringWriter())
            {
                using (XmlTextWriter xw = new XmlTextWriter(writer))
                {
                    xw.Formatting = Formatting.Indented;
                    xw.Indentation = 3;

                    var dom = new XmlDocument();
                    dom.LoadXml(str);

                    xslt.Transform(dom, args, xw);
                    xw.Close();

                    // return writer.ToString();

                    if (string.IsNullOrEmpty(fileName))
                    {
                        fileName = Path.GetTempFileName() + ".html";
                    }

                    if (DebugOutput)
                    {
                        // dump xml to output
                        var xmlFileName = fileName + ".xml";
                        System.Diagnostics.Debug.WriteLine(xmlFileName);
                        StringUtils.DumpFile(xmlFileName, XmlUtils.Beautify(str));
                    }

                    // save file 
                    StringUtils.DumpFile(fileName, writer.ToString());

                    return fileName;

                }
            }
        }







        /// <summary>
        ///  var resourceName = "PicWalker.ImageComparer.ComparisonPage.xslt";
        /// </summary>
        /// <param name="resourceName">ex: "PicWalker.ImageComparer.ComparisonPage.xslt"</param>
        /// <returns></returns>
        public static XslCompiledTransform GetXslt(string resourceName)
        {
            var assembly = Assembly.GetExecutingAssembly();
            using (Stream stream = assembly.GetManifestResourceStream(resourceName))
            {
                var xslt = new XslCompiledTransform();
                using (XmlReader xr = XmlReader.Create(stream))
                {
                    var resolver = new AssemblyResourceXmlUrlResolver();

                    xslt.Load(xr, null, resolver);
                    return xslt;
                }
            }
        }


        // 


    }

    /// <summary>
    /// https://stackoverflow.com/questions/39704036/load-xslt-with-import-from-assembly-in-c-sharp
    /// </summary>
    public class AssemblyResourceXmlUrlResolver : XmlUrlResolver
    {
        private const string basePad = "XsltWorks.xslt.";

        public override object GetEntity(Uri absoluteUri, string role, Type ofObjectToReturn)
        {
            switch (absoluteUri.Scheme)
            {
                case "file":
                    {
                        string origString = absoluteUri.OriginalString;
                        Assembly assembly = Assembly.GetExecutingAssembly();
                        // the filename starts after the last \
                        int index = origString.LastIndexOf('\\');
                        string filename = origString.Substring(index + 1);

                        string resourceName = basePad + filename;

                        var stream = assembly.GetManifestResourceStream(resourceName);

                        return stream;
                    }
                default:
                    {
                        return (Stream)base.GetEntity(absoluteUri, role, ofObjectToReturn);
                    }
            }
        }
    }


    [Serializable]
    public class XsltPagerInfo
    {

        public XsltPagerInfo()
        {
            Pages = new List<XsltPager>();
        }

        public XsltPagerInfo(List<XsltPager> pages, int currentPage, int maxPages, int pageSize)
        {
            Pages = pages;
            CurrentPage = currentPage;
            MaxPages = maxPages;
            PageSize = pageSize;

            StartCounter = CurrentPage * PageSize;
        }

        public List<XsltPager> Pages { get; set; }

        public int CurrentPage { get; set; }

        public int MaxPages { get; set; }

        public int PageSize { get; set; }

        public int StartCounter { get; set; }

    }

    [Serializable]
    public class XsltPager
    {
        public XsltPager()
        {

        }

        public XsltPager(
            int pageId,
            string pageName,
           string fileName,
           string pageUrl)
        {
            PageId = pageId;
            PageName = pageName;
            FileName = fileName;
            PageUrl = pageUrl;
        }

        public int PageId { get; set; }

        public string PageName { get; set; }

        public string FileName { get; set; }

        public string PageUrl { get; set; }



    }
}