# AI CV vs JD Comparator

A Python-based tool that compares a candidate's CV with a Job Description (JD), identifying the top 5 critical changes and 3 key tips to make the CV more relevant to the position and ATS compliant. It utilizes an LLM (`llama-3.3-70b-versatile` via Groq API).

## Features

- **CV & JD Comparison**: Analyzes required skills, experience, missing keywords, ATS relevance, and quantifiable achievements.
- **AI Optimization**: Leverages `llama-3.3-70b-versatile` to generate exactly 5 critical changes and 3 actionable tips in markdown format.
- **Gradio Web Interface**: Provides a clean, interactive side-by-side text input interface to quickly test CVs against job postings.

## Prerequisites

- Python 3.7+
- A Groq API key (or other OpenAI-compatible API credentials)

## Installation

1. Clone this repository and switch to the feature branch.
2. Install the required dependencies (you can use a virtual environment):
   ```bash
   pip install openai python-dotenv gradio
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

This will launch a local server with a Gradio interface. Open the provided URL in your browser, paste the CV and JD, and click to view the optimization suggestions.

## File Structure

- `app.py`: Entry point that runs the Gradio web interface with inputs for CV and JD text.
- `cv_comparator.py`: Contains the comparison logic and prompt configuration for the LLM.


