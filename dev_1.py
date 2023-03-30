#!/usr/bin/env python3
import openai
import os
import sys
import time


#entrada=input("pe:")
# Set the API key
openai.api_key = sys.argv[1]
# Use the ChatGPT model to generate text
model_engine = "text-davinci-003"


while True:
    entrada=input("Introducir Dato:")
    prompt = ""+entrada
    completion = openai.Completion.create(engine=model_engine, prompt=prompt, max_tokens=1024, n=1,stop=None,temperature=0.7)
    message = completion.choices[0].text
    print(message)
    sys.stdout.flush()
    time.sleep(2)
