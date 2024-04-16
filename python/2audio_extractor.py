
# import azure.cognitiveservices.speech as speechsdk
import time
import pickle
from moviepy.editor import VideoFileClip

import sys

from dotenv import dotenv_values

def extract_audio(filename):
    video = VideoFileClip(filename)
    audio = video.audio
    output = filename + ".audio_only.wav"
    audio.write_audiofile(output)
    return output

filename = sys.argv[1]

audio_file = extract_audio(filename)
