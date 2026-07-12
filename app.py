# pip install gradio
# pyrefly: ignore [missing-import]
import gradio as gr
# pyrefly: ignore [missing-import]
from WebSummariser import summarize

gr.Interface(
    fn=summarize,                             
    inputs=gr.Textbox(label="Website URL"),
    outputs=gr.Markdown(label="Summary"),
    title="🔎 AI Website Summarizer",
).launch(share=True)  # share=True → a public link you can post! 🎉