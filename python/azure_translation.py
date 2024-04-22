

from azure.ai.translation.document import DocumentTranslationClient
from azure.ai.translation.text import TextTranslationClient
from azure.ai.translation.text.models import InputTextItem


from azure.ai.translation.text import TranslatorCredential

from azure.core.exceptions import HttpResponseError

from azure.core.credentials import AzureKeyCredential
from dotenv import dotenv_values

class azure_translation:

    def __init__(self):
        self = self

        self.config = dotenv_values(".env")
        self.region = self.config.get("AZURE_TRANSLATOR_REGION", None)
        self.endpoint = self.config.get("AZURE_TRANSLATOR_TEXT_ENDPOINT", None)
        self.speech_key = self.config.get("AZURE_TRANSLATOR_API_KEY", None)

        self.text_translator = TextTranslationClient(credential = TranslatorCredential(self.speech_key, self.region));

# client = DocumentTranslationClient(endpoint, AzureKeyCredential(speech_key))

    def get_languages_xml(self):
        kvp = self.get_languages(self)

        xml = "<translation_languages>\n"

        for key, value in kvp:
            xml += f'\t<language key="{key}" name="{value.name}" />\n'
            # print(f"{key} -- name: {value.name} ({value.native_name})")        

        xml += "</translation_languages>"
        return xml


    def get_languages(self):
        try:
            response = self.text_translator.get_languages()

            print(f"Number of supported languages for translate operation: {len(response.translation) if response.translation is not None else 0}")
            print(f"Number of supported languages for transliterate operation: {len(response.transliteration) if response.transliteration is not None else 0}")
            print(f"Number of supported languages for dictionary operations: {len(response.dictionary) if response.dictionary is not None else 0}")

            if response.translation is not None:
                print("Translation Languages:")
                for key, value in response.translation.items():
                    print(f"{key} -- name: {value.name} ({value.native_name})")

            return response.translation.items()

            if response.transliteration is not None:
                print("Transliteration Languages:")
                for key, value in response.transliteration.items():
                    print(f"{key} -- name: {value.name}, supported script count: {len(value.scripts)}")

            if response.dictionary is not None:
                print("Dictionary Languages:")
                for key, value in response.dictionary.items():
                    print(f"{key} -- name: {value.name}, supported target languages count: {len(value.translations)}")

            

        except HttpResponseError as exception:
            print(f"Error Code: {exception.error.code}")
            print(f"Message: {exception.error.message}")


    def translate_text(self, input_text = "This is a test", source_language = "en", target_languages = ["ru"]):

        try:
            # source_language = "en"
            # target_languages = ["cs"]
            input_text_elements = [ InputTextItem(text = input_text) ]

            response = self.text_translator.translate(content = input_text_elements, to = target_languages, from_parameter = source_language)
            translation = response[0] if response else None

            if translation:
                for translated_text in translation.translations:
                    print(f"Text was translated to: '{translated_text.to}' and the result is: '{translated_text.text}'.")
                    
                    return translated_text.text

                    

        except HttpResponseError as exception:
            print(f"Error Code: {exception.error.code}")
            print(f"Message: {exception.error.message}")


