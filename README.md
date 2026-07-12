# AI Website Summarizer

A Python-based tool that takes a website URL, scrapes its content, and provides a concise, structured, and easy-to-understand summary. It utilizes an LLM (`llama-3.3-70b-versatile` via Groq API) to distill the key takeaways in a way that even a 10-year-old can understand (ELI10).

## Features

- **Web Scraping**: Extracts readable text from any given URL using `BeautifulSoup4` while ignoring irrelevant elements like scripts, styles, nav menus, and footers.
- **AI Summarization**: Leverages the `llama-3.3-70b-versatile` model to read the content and generate a highly structured summary.
- **Gradio Interface**: Provides a clean, interactive web UI where users can paste a URL and immediately see the generated Markdown summary.
- **ELI10 Format**: The AI is instructed to explain concepts simply, highlight the 5-10 most important points, and provide clear sections (Main Topics, How It Works, Features, etc.).

## Prerequisites

- Python 3.7+
- A Groq API key (or other OpenAI-compatible API credentials)

## Installation

1. Clone this repository.
2. Install the required dependencies (you can use a virtual environment):
   ```bash
   pip install openai python-dotenv beautifulsoup4 requests gradio
   ```
3. Create a `.env` file in the root directory and add your API credentials:
   ```env
   GROQ_API_KEY=your_api_key_here
   GROQ_API_BASE_URL=https://api.groq.com/openai/v1
   ```

## Usage

Run the app using Python:
```bash
python app.py
```

This will launch a local server with a Gradio interface. Open the provided local URL (usually `http://127.0.0.1:7860/`) in your browser. You can enter any website URL, and the tool will scrape and summarize it for you.

## File Structure

- `app.py`: The entry point that runs the Gradio web interface.
- `WebSummariser.py`: Contains the logic to call the LLM and the comprehensive system prompt for formatting the summary.
- `scapper.py`: Handles fetching and cleaning the website HTML using `requests` and `BeautifulSoup`.
