
# Azure AI Translator

from azure_translation import azure_translation
from azure_speech import *
from utils import *

# run azure ai voice to read summarization
from utils import *
import sys

speech = azure_speech()


# "ru-RU-SvetlanaNeural"
# voice_name = "ru-RU-SvetlanaNeural"
# language = "ru-RU"

# "W:\GITHUB\AzureAI\python\net_voice.py" "cs-CZ-VlastaNeural" "cs-CZ" "W:\GITHUB\AzureAI\downloaded\0002\cs-CZ-VlastaNeural.summary.mp3" "W:\GITHUB\AzureAI\downloaded\0002\Meet AI demands at any scale with purpose-built infrastructure.mp4audio.wav.transcribed_video.txt.summaryall.cs.translatedsummary"


voice_name = sys.argv[1]
locale = sys.argv[2]
out_file = sys.argv[3]
summary_file = sys.argv[4]

# out_file = out_folder + voice_name + "." + "summary.mp3"


speech.speech_synthesis_from_file_to_mp3(input_file = summary_file, output_file=out_file, voice_name = voice_name, language = locale )


