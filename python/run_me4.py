
# Azure AI Translator

from azure.ai.translation.document import DocumentTranslationClient
from azure.ai.translation.text import TextTranslationClient

from azure.ai.translation.text import TranslatorCredential

from azure.core.exceptions import HttpResponseError

from azure.core.credentials import AzureKeyCredential
from dotenv import dotenv_values

from azure_translation import azure_translation


at = azure_translation()

# at.get_languages()

at.translate_text(input_text = "I love Azure translator", source_language = "en", target_languages = ["ru"])

