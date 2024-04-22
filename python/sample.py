



import sys
from utils import *

# [0] - filename
# [1] first argument 

print("\n".join(sys.argv))


print("hello world")

folder = "W:/GITHUB/AzureAI/downloaded/0002/"
input_file = folder + "Meet AI demands at any scale with purpose-built infrastructure.mp4audio.wav.transcribed_video.txt.summary_all"

input_text = read_all( input_file)

print( input_text )


input_text = read_all_utf(input_file)

print(input_text)
