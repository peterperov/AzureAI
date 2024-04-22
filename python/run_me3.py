
from azure_speech import *


# run azure ai voice to read summarization
worker = azure_speech()

folder = "W:/GITHUB/AzureAI/downloaded/0002/"
file_name = folder + "Meet AI demands at any scale with purpose-built infrastructure.mp4audio.wav.transcribed_video.txt.summary_all"
language = "en-US"

voice_name = "en-US-AvaMultilingualNeural"
output_file = folder + voice_name + "." + "summary.mp3"



list = worker.speech_synthesis_get_available_voices(language)

# print(list)
# voice object 
# https://learn.microsoft.com/en-us/dotnet/api/microsoft.cognitiveservices.speech.voiceinfo?view=azure-dotnet

for v in list:
    print( f'{v.locale} \t {v.short_name} \t {v.name}')
    

worker.speech_synthesis_from_file_to_mp3(input_file = file_name, output_file=output_file, voice_name = voice_name, language = language )