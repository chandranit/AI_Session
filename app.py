# pyrefly: ignore [missing-import]
import gradio as gr
# pyrefly: ignore [missing-import]
from cv_comparator import compare_cv_and_jd

# Minimalistic modern theme setup
theme = gr.themes.Soft(
    primary_hue="indigo",
    secondary_hue="slate",
    neutral_hue="slate",
    font=[gr.themes.GoogleFont("Inter"), "ui-sans-serif", "system-ui", "sans-serif"],
).set(
    body_background_fill="*neutral_50",
    block_background_fill="*white",
    block_border_width="1px",
    block_shadow="0 1px 3px 0 rgb(0 0 0 / 0.1)",
    button_primary_background_fill="*primary_600",
    button_primary_background_fill_hover="*primary_700",
)

with gr.Blocks(theme=theme, title="JobFit AI | Resume & JD Matcher") as demo:
    gr.Markdown(
        """
        # ✨ JobFit AI
        ### Compare your CV against any Job Description to get 5 critical changes & 3 key tips.
        """
    )
    
    with gr.Row():
        with gr.Column(scale=1):
            cv_input = gr.Textbox(
                lines=12,
                label="📄 Candidate CV",
                placeholder="Paste your CV text here...",
                show_copy_button=True,
            )
        with gr.Column(scale=1):
            jd_input = gr.Textbox(
                lines=12,
                label="🎯 Job Description (JD)",
                placeholder="Paste the target Job Description text here...",
                show_copy_button=True,
            )

    with gr.Row():
        analyze_btn = gr.Button("🚀 Analyze & Match", variant="primary", scale=2)
        clear_btn = gr.Button("🧹 Clear", variant="secondary", scale=1)

    output_markdown = gr.Markdown(
        label="Optimization Results",
        value="*Your optimization suggestions will appear here after analysis.*",
        show_copy_button=True,
    )

    # Event handlers
    analyze_btn.click(
        fn=compare_cv_and_jd,
        inputs=[cv_input, jd_input],
        outputs=[output_markdown],
    )
    
    def clear_all():
        return "", "", "*Your optimization suggestions will appear here after analysis.*"

    clear_btn.click(
        fn=clear_all,
        inputs=[],
        outputs=[cv_input, jd_input, output_markdown],
    )

if __name__ == "__main__":
    demo.launch(share=True)