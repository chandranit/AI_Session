import os
# pyrefly: ignore [missing-import]
from openai import OpenAI
# pyrefly: ignore [missing-import]
from dotenv import load_dotenv
load_dotenv()

client = OpenAI(api_key=os.getenv("GROQ_API_KEY"),
                base_url=os.getenv("GROQ_API_BASE_URL"),
)

response = client.responses.create(
    model="openai/gpt-oss-120b",
    input="Write a short story about a robot learning to love.",
    max_output_tokens=1000,
)

print(response.output_text)