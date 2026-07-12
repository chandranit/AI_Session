# 🎓 Welcome to Session 1: Introduction to Large Language Models (LLMs) via API

Hello there, aspiring AI developer! I'm your AI Expert Teacher. In this branch, `session_1`, we are taking our very first steps into the magical world of Generative AI. 

This project branch contains two foundational scripts: `a.py` and `new.py`. These scripts are designed to teach you how to communicate with powerful Large Language Models (LLMs) using Python and APIs. Let's break down exactly what is happening in this project so you can understand the underlying concepts!

---

## 🛠️ The Toolkit: What are we using?

Before we dive into the code, let's understand our tools:

1. **Python**: Our programming language of choice.
2. **dotenv (`load_dotenv`)**: A handy library to securely load environment variables (like secret passwords) from a `.env` file. We *never* want to hardcode our API keys directly into our scripts!
3. **OpenAI API Client**: Although we are using Groq to host our model, we are using the official OpenAI Python library because Groq provides an "OpenAI-compatible" API. This means the code you write here is highly transferable!
4. **Llama 3.3 70B (`llama-3.3-70b-versatile`)**: This is the "brain"—a massive, open-weights AI model created by Meta. It is fast, smart, and highly capable.

---

## 📜 File Breakdown & AI Concepts

### 1️⃣ `a.py`: The Chat Completion Example

This script is a perfect example of a **Chat Completion** task. It demonstrates how to give an AI a "persona" and ask it a specific question.

**Key AI Concepts in this file:**
* **Client Initialization:** 
  ```python
  client = OpenAI(api_key=os.getenv("GROQ_API_KEY"), base_url=os.getenv("GROQ_API_BASE_URL"))
  ```
  *Teacher's Note:* Here we are establishing a connection to the AI provider (Groq). We pass our secure API key and the base URL. Think of this as dialing the phone number to speak to the AI.

* **Roles (System vs. User):**
  ```python
  messages=[
      {"role":"system","content":"You are a funny travel guide"},
      {"role":"user","content":"Give me a funny travel itinerary for 3 days in bangalore"},
  ]
  ```
  *Teacher's Note:* This is the core of modern prompt engineering! 
  - **System Prompt (`role: system`)**: This sets the behavior, constraints, and persona of the AI. By telling it to be a "funny travel guide," we drastically change *how* it responds.
  - **User Prompt (`role: user`)**: This is your actual request or question. 

### 2️⃣ `new.py`: Exploring Text Generation (With a Learning Opportunity!)

This script is another attempt at generating text, specifically a short story about a robot learning to love. 

*Teacher's Note on Debugging:* As an AI developer, you'll often encounter code that needs tweaking! If you look closely at `new.py`, you'll notice a few things:
1. `from opensai import OpenAI` has a typo (it should be `openai`).
2. It uses `client.responses.create(...)` which is not the standard OpenAI Python syntax for chat completions (it should be `client.chat.completions.create(...)`). 

This file serves as a great reminder that when working with APIs, we must strictly follow the provider's documentation and syntax!

---

## 🚀 Key Takeaways from Session 1

By exploring this branch, you have learned:
1. **API Integration:** How to connect a Python script to a cloud-based AI model.
2. **Environment Variables:** How to keep your API keys secure.
3. **Prompt Engineering Basics:** How to use System and User roles to steer the AI's behavior and get the exact tone (like a funny travel guide) you want.

Keep experimenting! Try changing the `system` content in `a.py` to "You are a grumpy pirate" and see how the itinerary for Bangalore changes. That is the power of prompt engineering!
