# Reusable Git Commit Message Standard

Use this document as the standard format whenever committing changes in this repository.

---

## 📌 Standard One-Liner Format

```text
<type>(<scope/branch>): <short summary in imperative present tense>
```

### Supported Commit Types:
- `feat`: A new feature or script
- `fix`: A bug fix or syntax correction
- `docs`: Documentation changes (`README.md`, comments, guides)
- `refactor`: Code restructuring without changing functionality
- `style`: Formatting, missing semi-colons, white-space cleanup
- `test`: Adding or modifying tests

### Examples:
- `feat(session_2): add web scraper and LangChain summarizer pipeline`
- `docs(session_2): update README with LCEL architecture and memory explanation`
- `fix(session_2): correct missing module import in summarizer script`

---

## 📝 Detailed Multi-Line Commit Message Format

Use this format whenever creating detailed commits with bullet points:

```text
<type>(<scope/branch>): <short summary in imperative present tense>

- <Action verb> <file_name_1>: <crisp description of change 1>
- <Action verb> <file_name_2>: <crisp description of change 2>
- <Action verb> <file_name_3>: <crisp description of change 3>
```

### Reusable Template Example:

```text
feat(session_2): implement web scraping, LCEL pipeline, and chat memory

- Add `scrapper.py`: Extract and clean HTML content using requests and BeautifulSoup.
- Add `summarizer_langchain.py`: Build LCEL pipeline (`prompt | model | parser`) with Groq Llama 3.3.
- Add `memory_demo.py`: Demonstrate chat history management with `MessagesPlaceholder`.
- Update `README.md`: Add key concepts, file breakdown, and easy execution examples.
```

---

## 🤖 Rule for AI Assistant

When asked to commit changes, the AI assistant will automatically structure the git commit using the format above:

```bash
git add .
git commit -m "<type>(<scope/branch>): <short summary>" -m "- <bullet point 1>" -m "- <bullet point 2>"
```
