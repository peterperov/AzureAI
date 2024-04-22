
from chunk_process import *
from text_speech import *
from transcribe_text import *
from translate_text import *
from subtitle_creator import *

file_name = "W:/GITHUB/AzureAI/downloaded/0002/Meet AI demands at any scale with purpose-built infrastructure.mp4audio.wav.transcribed_video.txt"

summary_file = file_name + ".summaryall"

sm = summarizer()
out_file = sm.run_summarizer(file_name, out_file = summary_file)

print(out_file)


