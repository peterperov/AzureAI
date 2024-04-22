import json
import string
import time
import threading
import wave


from utils import *

import azure.cognitiveservices.speech as speechsdk
from dotenv import dotenv_values

class azure_speech:


    def __init__(self):
        self = self

        self.config = dotenv_values(".env")
        self.speech_key = self.config.get("AZURE_SPEECH_API_KEY", None)
        self.service_region = self.config.get("AZURE_SPEECH_REGION", None)


    def imported():
        print("IMPORTED FUNCTION")

    def speech_synthesis_from_file_to_mp3(self, input_file, output_file, voice_name = "AvaNeural", language = "en-US"):
        input_text = read_all_utf( input_file)
        self.speech_synthesis_to_mp3_file(text = input_text, file_name = output_file, voice_name = voice_name, language = language)


    def speech_synthesis_to_mp3_file(self, text = "Hello everyone, hope you have a nice day", file_name = "outputaudio.mp3", voice_name = "AvaNeural", language = "en-US"):
        """performs speech synthesis to a mp3 file"""
        # Creates an instance of a speech config with specified subscription key and service region.
        speech_config = speechsdk.SpeechConfig(subscription=self.speech_key, region=self.service_region)
        # Sets the synthesis output format.
        # The full list of supported format can be found here:
        # https://docs.microsoft.com/azure/cognitive-services/speech-service/rest-text-to-speech#audio-outputs
        speech_config.set_speech_synthesis_output_format(speechsdk.SpeechSynthesisOutputFormat.Audio16Khz32KBitRateMonoMp3)
        # Creates a speech synthesizer using file as audio output.
        # Replace with your own audio file name.
        
        speech_config.speech_synthesis_language = language
        speech_config.speech_synthesis_voice_name = voice_name
        

        file_config = speechsdk.audio.AudioOutputConfig(filename=file_name)
        speech_synthesizer = speechsdk.SpeechSynthesizer(speech_config=speech_config, audio_config=file_config)
        

        # Receives a text from console input and synthesizes it to mp3 file.
        #while True:
        #    print("Enter some text that you want to synthesize, Ctrl-Z to exit")
        #    try:
        #        text = input()
        #    except EOFError:
        #        break

        result = speech_synthesizer.speak_text_async(text).get()
        # Check result
        if result.reason == speechsdk.ResultReason.SynthesizingAudioCompleted:
            print("Speech synthesized for text [{}], and the audio was saved to [{}]".format(text, file_name))
        elif result.reason == speechsdk.ResultReason.Canceled:
            cancellation_details = result.cancellation_details
            print("Speech synthesis canceled: {}".format(cancellation_details.reason))
            if cancellation_details.reason == speechsdk.CancellationReason.Error:
                print("Error details: {}".format(cancellation_details.error_details))


    def speech_synthesis_get_available_voices(self, text = "en-US"):
        """gets the available voices list."""

        speech_config = speechsdk.SpeechConfig(subscription=self.speech_key, region=self.service_region)

        # Creates a speech synthesizer.
        speech_synthesizer = speechsdk.SpeechSynthesizer(speech_config=speech_config, audio_config=None)

    #    print("Enter a locale in BCP-47 format (e.g. en-US) that you want to get the voices of, "
    #          "or enter empty to get voices in all locales.")
    #    try:
    #        text = input()
    #    except EOFError:
    #        pass

        all_voices = list()

        result = speech_synthesizer.get_voices_async(text).get()
        # Check result
        if result.reason == speechsdk.ResultReason.VoicesListRetrieved:
            print('Voices successfully retrieved, they are:')
            for voice in result.voices:
                # print(voice.name)
                
                all_voices.append(voice)
                
        elif result.reason == speechsdk.ResultReason.Canceled:
            print("Speech synthesis canceled; error details: {}".format(result.error_details))

        return all_voices
    

    def available_voices_to_xml(self, text="en-US"):
        all_voices = self.speech_synthesis_get_available_voices(text)
        out_xml = f'<voices language="{text}">\n'
        for v in all_voices:
            out_xml = out_xml + f'\t<voice locale="{v.locale}" short_name="{v.short_name}" name="{v.name}" />\n'
            # print( f'{v.locale} \t {v.short_name} \t {v.name}')
        
        out_xml += "</voices>\n"

        return out_xml