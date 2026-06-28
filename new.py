import os
from opensai import OpenAI
from dotenv import load_dotenv
load_dotenv()

client = OpenAI(api_key=os.getenv("GROQ_API_KEY"),
                base_url=os.getenv("GROQ_API_BASE_URL"),
)

response = client.responses.create(
    model="llama-3.3-70b-versatile",
    input="Write a short story about a robot learning to love.",
    max_output_tokens=200,
)

print(response.output_text)