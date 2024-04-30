
from translate_text import *
from azure_translation import azure_translation
from utils import *

import sys

input_file = sys.argv[1]
target_language = sys.argv[2]

at = azure_translation()
file_txt = read_all(input_file)

translated = at.translate_text(input_text = file_txt, source_language = "en", target_languages = [target_language])
out_file = input_file + "." + target_language + ".translatedsummary"
write_file_utf(out_file, translated)