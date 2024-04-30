
# Azure AI Translator

from azure_translation import azure_translation
from azure_speech import *
from utils import *

# run azure ai voice to read summarization


from utils import *

speech = azure_speech()
at = azure_translation()


# out_xml = speech.available_voices_to_xml("")

# write_file( folder + language + '.xml', out_xml )

all_voices = speech.speech_synthesis_get_available_voices(text = "")

out_text = "<voices>\n"

for v in all_voices:
    # print( f'\t<voice locale="{v.locale}" short_name="{v.short_name}" name="{v.name}" />\n')
    splitted = v.locale.split('-')
    out_text += f'\t<voice short="{splitted[0]}" locale="{v.locale}" short_name="{v.short_name}" name="{v.name}" />\n'


out_text += "</voices>\n"

write_file( 'W:/GITHUB/AzureAI/all_voices.xml', out_text )


# print( out_xml )
