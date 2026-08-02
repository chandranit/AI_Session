# 🚀 Session 2: LangChain Basics, Web Scraping & AI Memory

Welcome to **Session 2**! In this session, we transition from basic direct API calls to using **LangChain**—a framework for building powerful AI applications—along with web scraping and simulating conversation memory.

---

## 📌 Key Concepts Learned

* **Web Scraping (`scrapper.py`)**: How to fetch raw HTML pages over HTTP and extract clean, human-readable text using `requests` and `BeautifulSoup`.
* **LangChain Expressive Language (LCEL) (`summarizer_langchain.py`)**: How to compose AI pipelines by piping Prompts, LLM Models, and Output Parsers (`prompt | model | parser`).
* **OpenAI-Compatible Providers**: How to connect `ChatOpenAI` in LangChain to alternative LLM cloud infrastructure like **Groq** (`llama-3.3-70b-versatile`).
* **Statelessness & AI Memory (`memory_demo.py`)**: Understanding that LLMs have no internal memory, and how we simulate memory by re-sending past chat turns (`history`).

---

## 📁 File Structure & Easy Examples

### 1️⃣ `scrapper.py` — Web Scraper
* **What it does**: Takes any website URL, cleans out ads, scripts, and navigation links, and returns plain text.
* **Easy Example**:
  ```python
  from scrapper import fetch_website_content

  # Downloads https://anthropic.com and strips out HTML tags
  clean_text = fetch_website_content("https://anthropic.com")
  ```

---

### 2️⃣ `summarizer_langchain.py` — LangChain Web Summarizer
* **What it does**: Connects `scrapper.py` with a LangChain pipeline (`prompt | model | parser`) to summarize any website in friendly plain text using Groq's Llama 3.3 70B model.
* **Easy Example**:
  ```python
  from summarizer_langchain import summarize

  # Scrapes anthropic.com and returns a friendly AI summary
  summary = summarize("https://anthropic.com")
  print(summary)
  ```

---

### 3️⃣ `memory_demo.py` — Conversational Memory Demo
* **What it does**: Demonstrates how chatbots "remember" previous messages using `MessagesPlaceholder("history")`.
* **How LLM Memory Works (The Secret)**:
  > **LLMs are stateless**—they forget everything the moment a request ends. To give the illusion of memory, we must re-send previous conversation turns in every new prompt!
* **Easy Example**:
  ```python
  from langchain_core.messages import HumanMessage, AIMessage

  # Pass past chat history into the new invocation
  history = [
      HumanMessage("My name is Invisy."),
      AIMessage("Hi Invisy!")
  ]

  # The AI reads the history and correctly answers!
  response = chain.invoke({
      "history": history, 
      "question": "What's my name?"
  })
  print(response.content) # Output: "Your name is Invisy."
  ```

---

## ⚙️ How to Run

1. **Activate your environment**:
   ```bash
   source .venv/bin/activate
   ```
2. **Install dependencies**:
   ```bash
   pip install langchain-openai langchain-core python-dotenv requests beautifulsoup4
   ```
3. **Set up `.env` file**:
   ```env
   GROQ_API_KEY=your_groq_api_key
   GROQ_API_BASE_URL=https://api.groq.com/openai/v1
   ```
4. **Run the scripts**:
   ```bash
   python3 summarizer_langchain.py
   python3 memory_demo.py
   ```
