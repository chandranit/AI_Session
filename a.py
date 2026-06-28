# pyrefly: ignore [missing-import]
from dotenv import load_dotenv
load_dotenv()

# pyrefly: ignore [missing-import]
from openai import OpenAI
import os

client = OpenAI(api_key=os.getenv("GROQ_API_KEY"),base_url=os.getenv("GROQ_API_BASE_URL"))

response = client.chat.completions.create(
    model="llama-3.3-70b-versatile",
    messages=[
        {"role":"system","content":"You are a funny travel guide"},
        {"role":"user","content":"Give me a funny travel itinerary for 3 days in bangalore"},
    ]
)

print(response.choices[0].message.content)