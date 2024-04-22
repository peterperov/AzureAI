

from youtube_video import *
from audio_extractor import *

from chunk_process import *
from text_speech import *
from transcribe_text import *
from translate_text import *
from subtitle_creator import *


out_path = "W:/GITHUB/AzureAI/downloaded/0002"
yt_video = "https://www.youtube.com/watch?v=eq2zQq2GtFQ"

# 1 download video 
print("****************************")
print ("downloading video")
print("****************************")
filename = download_video(yt_video, out_path)

# 2 extract audio 
print("****************************")
print ("extract audio ")
print("****************************")
# filename = sys.argv[1]
# output_file = sys.argv[2]
output_file = filename + "audio.wav"
audio_file = extract_audio(filename, output_file)

# 3 create subtitle 
print("****************************")
print ("create subtitle  ")
print("****************************")

# filename = "C:/Meetings/03DAI/FY24 Data & AI Landing Live Show - July 2023.mp4.audio_only.wav"
# filename = "C:/Meetings/00-Youtube/NVIDIA DLSS 3.5 _ New Ray Reconstruction Enhances Ray Tracing with AI (2160p_30fps_AV1-128kbit_AAC).mp4.audio_only.wav"
sc = subtitle_creator(audio_file)
output = sc.transcribe_text()
print("TEXT transcribed: " + output)
