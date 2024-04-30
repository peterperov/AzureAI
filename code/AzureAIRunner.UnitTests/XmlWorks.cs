using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml;

namespace AzureAIRunner.UnitTests
{
    public class XmlWorks
    {
        [SetUp]
        public void Setup()
        {
        }



        [Test]
        public void Test1()
        {
            Assert.Pass();
        }

        /*
            var subjectObject = {
              "Front-end": [
                "HTML",
                "CSS",
                "JavaScript"    
              ],
              "Back-end": [
                "PHP",
                "SQL"]

            }, 
         * */

        [Test]
        public void LoadXml()
        {

            var filename = @"W:\GITHUB\AzureAI\all_voices.xml";

            var dom = new XmlDocument();
            dom.Load(filename);

            // short="{splitted[0]}" locale="{v.locale}" short_name="{v.short_name}" name
            // 	<voice short="zu" locale="zu-ZA" short_name="zu-ZA-ThembaNeural" name="Microsoft Server Speech Text to Speech Voice (zu-ZA, ThembaNeural)" />

            StringBuilder buffer = new StringBuilder();

            var lang = "";

            foreach ( XmlNode node in dom.SelectNodes("//voice"))
            {

                var new_lang = node.Attributes["short"].Value;
                var locale = node.Attributes["locale"].Value;
                var short_name = node.Attributes["short_name"].Value;

                var full_name = AzureAIRunner.TranslatorLanguages.GetLanguageFromCode(new_lang);

                if ( new_lang != lang)
                {
                    if (lang != "")
                    {
                        buffer.AppendFormat("],\n");
                    }
                    buffer.AppendFormat("\"{0}\": [", string.IsNullOrEmpty(full_name) ? new_lang : full_name);
                }
                else
                {
                    buffer.Append(", ");
                }

                

                buffer.AppendFormat("\"{0}\"", short_name);
                lang = new_lang;
                // Console.WriteLine(" {0}   {1}   {2}", new_lang, locale, short_name);
            }

            Console.Write(buffer.ToString());

        }

    }
}
