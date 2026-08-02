# pyrefly: ignore [missing-import]
from langchain_openai import ChatOpenAI
# pyrefly: ignore [missing-import]
from langchain_core.prompts import ChatPromptTemplate
# pyrefly: ignore [missing-import]
from langchain_core.output_parsers import StrOutputParser
from dotenv import load_dotenv
# pyrefly: ignore [missing-import]
from scrapper import fetch_website_content

import os

load_dotenv()

prompt = ChatPromptTemplate.from_template(
    "Give a short friendly summary of this website:\n\n{website}"
)
model = ChatOpenAI(
    model="llama-3.3-70b-versatile",
    api_key=os.getenv("GROQ_API_KEY"),
    base_url=os.getenv("GROQ_API_BASE_URL"),
    temperature=0.3,
)

parser = StrOutputParser()

chain = (prompt | model | parser)

def summarize(url):
    return chain.invoke({"website": fetch_website_content(url)})

print(summarize("https://anthropic.com"))