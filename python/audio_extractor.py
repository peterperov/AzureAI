
# import azure.cognitiveservices.speech as speechsdk
import time
import pickle
from moviepy.editor import VideoFileClip

import sys

from dotenv import dotenv_values

def extract_audio(filename, out_file = ""):
    video = VideoFileClip(filename)
    audio = video.audio

    if out_file == "":
        out_file = filename + ".audio_only.wav"

    audio.write_audiofile(out_file)
    return out_file

# filename = sys.argv[1]
# output_file = sys.argv[2]
# audio_file = extract_audio(filename, output_file)
