# import azure.functions as func

import os
import re  
import logging
import json
import jsonschema
from EmbeddingGenerator.chunker.text_chunker import TextChunker
from EmbeddingGenerator.chunker.chunk_metadata_helper import ChunkEmbeddingHelper
from EmbeddingGenerator.embedder import text_embedder
import semantic_kernel as sk
from semantic_kernel.connectors.ai.open_ai import OpenAITextCompletion, AzureTextCompletion

from dotenv import dotenv_values

# local utils and shortcuts
from utils import *

import sys
sys.path.append('')



class summarizer:

    def __init__(self):
        self = self


        # init kernel
        self.kernel = sk.Kernel()
        # deployment, api_key, endpoint = sk.azure_openai_settings_from_dot_env()
        self.config = dotenv_values("W:/GITHUB/AzureAI/.env")
        self.deployment = self.config.get("AZURE_OPENAI_DEPLOYMENT_NAME", None)
        self.api_key = self.config.get("AZURE_OPENAI_API_KEY", None)
        self.endpoint = self.config.get("AZURE_OPENAI_ENDPOINT", None)

        self.kernel.add_text_completion_service("dv", AzureTextCompletion(deployment_name=self.deployment, endpoint=self.endpoint, api_key=self.api_key))


    def split_chunks(self, filepath):
        TEXT_CHUNKER = TextChunker()

        sleep_interval_seconds = int(os.getenv("AZURE_OPENAI_EMBEDDING_SLEEP_INTERVAL_SECONDS", "1"))
        num_tokens = int(os.getenv("NUM_TOKENS", "2500"))
        min_chunk_size = int(os.getenv("MIN_CHUNK_SIZE", "10"))
        token_overlap = int(os.getenv("TOKEN_OVERLAP", "0"))

        text = read_all(filepath)

        chunking_result = TEXT_CHUNKER.chunk_content(text, file_path=filepath, num_tokens=num_tokens, min_chunk_size=min_chunk_size, token_overlap=token_overlap)

        # TODO: embeddings, vector search later 
        #CHUNK_METADATA_HELPER = ChunkEmbeddingHelper()
        #content_chunk_metadata = CHUNK_METADATA_HELPER.generate_chunks_with_embedding(document_id, [c.content for c in chunking_result.chunks], fieldname, sleep_interval_seconds)
        #for document_chunk, embedding_metadata in zip(chunking_result.chunks, content_chunk_metadata):
        #    document_chunk.embedding_metadata = embedding_metadata

        return chunking_result

    def run_summarizer(self, file_name, out_file = ""):

        chunking_result = self.split_chunks(file_name)

        all_summary = ""
        cnt = 0
        for chunk in chunking_result.chunks:
            cnt += 1
            print("******************************************")
            print("chunk " + str(cnt))
            print("******************************************")
            print(chunk.content)

            chunkFile = file_name + ".chunk" + str(cnt)
            #write the chunk to a file
            write_file(chunkFile, chunk.content)

            summaryFile = file_name + ".summary" + str(cnt)

            context = self.kernel.create_new_context()

            prompt_text = chunk.content + "\n\n identify key points"
            # ask for summary 
            prompt = self.kernel.create_semantic_function( prompt_text )

            # answer = await prompt.invoke_async(context)
            # answer = await prompt.invoke_async(context)
            # answer = await kernel.run_on_vars_async(context, prompt)
            
            res = prompt()
            print("prompt result: " + res.result )
            write_file(summaryFile, res.result)

            # all_summary += chunkFile + "\n\n" + res.result + "\n\n"
            all_summary += res.result + "\n\n"

        if out_file == "":
            out_file = file_name + ".summary_all" 

        write_file(out_file, all_summary)  

        return out_file


#prepare chunks


# sm = summarizer()
# starting_file = sys.argv[1]
# out_file = sys.argv[2]
# chunking_result = sm.run_summarizer(starting_file)

