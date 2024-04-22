using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml;

namespace XsltWorks
{
    public class XmlUtils
    {
        #region Beautify

        /// <summary>
        /// returns beautiful string of xml
        /// </summary>
        /// <param name="dom"></param>
        /// <returns></returns>
        public static string Beautify(XmlDocument dom)
        {
            StringWriter writer = new StringWriter();
            XmlWriterSettings settings = new XmlWriterSettings() { Indent = true, IndentChars = "\t", OmitXmlDeclaration = true };
            XmlWriter w = XmlWriter.Create(writer, settings);
            dom.Save(w);
            w.Flush();
            return writer.ToString();
        }

        public static string Beautify(string aXml)
        {
            XmlDocument dom = new XmlDocument();
            dom.LoadXml(aXml);
            return Beautify(dom);
        }

        #endregion
    }
}
