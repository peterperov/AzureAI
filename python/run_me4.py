
# Azure AI Translator

from azure_translation import azure_translation
from azure_speech import *
from utils import *

# run azure ai voice to read summarization


from utils import *

speech = azure_speech()
at = azure_translation()

# at.get_languages()

# at.translate_text(input_text = "I love Azure translator", source_language = "en", target_languages = ["ru"])

folder = "W:/GITHUB/AzureAI/downloaded/0002/"

file = folder + "Meet AI demands at any scale with purpose-built infrastructure.mp4audio.wav.transcribed_video.txt.summary_all"

file_txt = read_all(file)

translated = at.translate_text(input_text = file_txt, source_language = "en", target_languages = ["ru"])
out_file = file + ".ru.translatedsummary"
write_file_utf(out_file, translated)

# "ru-RU-SvetlanaNeural"
voice_name = "ru-RU-SvetlanaNeural"
language = "ru-RU"
speech.speech_synthesis_from_file_to_mp3(input_file = out_file, output_file=folder + voice_name + "." + "summary.mp3", voice_name = voice_name, language = language )

# language support
# https://learn.microsoft.com/en-us/azure/ai-services/speech-service/language-support?tabs=tts

language = "ru-RU"
out_xml = speech.available_voices_to_xml(language)
write_file( folder + language + '.xml', out_xml )

language = "el-GR"
out_xml = speech.available_voices_to_xml(language)
write_file( folder + language + '.xml', out_xml )

# greek
translated = at.translate_text(input_text = file_txt, source_language = "en", target_languages = ["el"])
write_file_utf(file + ".el.translatedsummary", translated)

voice_name = "el-GR-AthinaNeural"
language = "el-GR"
speech.speech_synthesis_from_file_to_mp3(input_file = file + ".el.translatedsummary", output_file=folder + voice_name + "." + "summary.mp3", voice_name = voice_name, language = language )
