
# Azure AI Translator

from azure_translation import azure_translation
from azure_speech import *
from utils import *

# run azure ai voice to read summarization


from utils import *

speech = azure_speech()
at = azure_translation()

out_xml = at.get_languages_xml()

print(out_xml)


