using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Serialization;
using System.Xml;

namespace XsltWorks
{

    public class XMLSerializer : ISerializer
    {
        private readonly XmlSerializerNamespaces tellTheSeriliserToIgnoreNameSpaces;
        private readonly XmlWriterSettings tellTheWriterToOmitTheXmlDeclaration;

        public XMLSerializer()
        {
            this.tellTheSeriliserToIgnoreNameSpaces = new XmlSerializerNamespaces();
            this.tellTheSeriliserToIgnoreNameSpaces.Add(String.Empty, String.Empty);

            this.tellTheWriterToOmitTheXmlDeclaration = new XmlWriterSettings { OmitXmlDeclaration = true };
        }

        public object Deserialize(Type objectType, byte[] data)
        {
            var deserializeXml = DeserializeXML(objectType, data);
            return deserializeXml;
        }

        public object Deserialize(Type objectType, string str)
        {
            var deserializeXml = DeserializeXML(objectType, System.Text.Encoding.UTF8.GetBytes(str));
            return deserializeXml;
        }

        public byte[] Serialize(object o)
        {
            return SerializeToStream(o).ToArray();
        }

        public string SerializeToString(object o)
        {
            if (o == null) return "";
            var xs = new XmlSerializer(o.GetType());
            using (StringWriter writer = new StringWriter())
            {
                using (var xw = XmlWriter.Create(writer, tellTheWriterToOmitTheXmlDeclaration))
                {
                    xs.Serialize(xw, o, tellTheSeriliserToIgnoreNameSpaces);
                    return writer.ToString();
                }
            }
        }


        private MemoryStream SerializeToStream(object o)
        {
            var xs = new XmlSerializer(o.GetType());

            using (var ms = new MemoryStream())
            {
                using (var xmlWriter = XmlWriter.Create(ms, this.tellTheWriterToOmitTheXmlDeclaration))
                {
                    xs.Serialize(xmlWriter, o, this.tellTheSeriliserToIgnoreNameSpaces);
                }
                return ms;
            }
        }



        public static string SerializeToStringNew<T>(T theObject) where T : new()
        {
            if (theObject == null) return "";

            var xs = new XmlSerializer(typeof(T));
            using (StringWriter writer = new StringWriter())
            {
                using (var xmlWriter = XmlWriter.Create(writer, TellTheWriterToOmitTheXmlDeclaration()))
                {
                    xs.Serialize(xmlWriter, theObject, TellTheSeriliserToIgnoreNameSpaces());
                    return writer.ToString();
                }
            }
        }


        public string SerializeToString<T>(T obj)
        {
            if (obj == null) return "";
            var xs = new XmlSerializer(typeof(T));
            using (StringWriter writer = new StringWriter())
            {
                using (var xw = XmlWriter.Create(writer, tellTheWriterToOmitTheXmlDeclaration))
                {
                    xs.Serialize(xw, obj, tellTheSeriliserToIgnoreNameSpaces);
                    return writer.ToString();
                }
            }
        }


        public void SerializeToFile<T>(T obj, string fileName)
        {
            if (obj == null) return;
            var xs = new XmlSerializer(typeof(T));
            using (FileStream fileStream = new FileStream(fileName, FileMode.CreateNew, FileAccess.Write, FileShare.None))
            {
                using (var xw = XmlWriter.Create(fileStream, tellTheWriterToOmitTheXmlDeclaration))
                {
                    xs.Serialize(xw, obj, tellTheSeriliserToIgnoreNameSpaces);
                }
            }
        }

        public T Deserialize<T>(string str) where T : new()
        {
            return (T)DeserializeXML(typeof(T), System.Text.Encoding.UTF8.GetBytes(str));
        }

        public T DeserializeFromFile<T>(string fileName) where T : new()
        {
            var xs = new XmlSerializer(typeof(T));
            T o;
            using (FileStream fileStream = new FileStream(fileName, FileMode.Open, FileAccess.Read, FileShare.None))
            {
                using (StreamReader streamReader = new StreamReader(fileStream))
                {
                    o = (T)xs.Deserialize(streamReader);
                }
            }
            return o;
        }

        public object FromString(Type type, string str)
        {
            var xs = new XmlSerializer(type);
            using (var ms = new MemoryStream(Encoding.UTF8.GetBytes(str)))
            {
                return xs.Deserialize(ms);
            }
        }

        private static object DeserializeXML(Type objectType, byte[] data)
        {
            var xs = new XmlSerializer(objectType);
            using (var ms = new MemoryStream(data))
            {
                return xs.Deserialize(ms);
            }
        }


        private static XmlWriterSettings TellTheWriterToOmitTheXmlDeclaration()
        {
            var tellTheWriterToOmitTheXmlDeclaration = new XmlWriterSettings();
            tellTheWriterToOmitTheXmlDeclaration.OmitXmlDeclaration = true;
            return tellTheWriterToOmitTheXmlDeclaration;
        }

        private static XmlSerializerNamespaces TellTheSeriliserToIgnoreNameSpaces()
        {
            var tellTheSeriliserToIgnoreNameSpaces = new XmlSerializerNamespaces();
            tellTheSeriliserToIgnoreNameSpaces.Add(String.Empty, String.Empty);
            return tellTheSeriliserToIgnoreNameSpaces;
        }

    }

    public interface ISerializer
    {
        object Deserialize(Type objectType, byte[] data);
        byte[] Serialize(object theObject);
    }

}
