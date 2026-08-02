# pyrefly: ignore [missing-import]
from langchain_core.prompts import ChatPromptTemplate, MessagesPlaceholder
# pyrefly: ignore [missing-import]
from langchain_core.messages import HumanMessage, AIMessage
# pyrefly: ignore [missing-import]
from summarizer_langchain import model

prompt = ChatPromptTemplate.from_messages([
    ("system", "You are a friendly tutor."),     # ① personality, like Class 1
    MessagesPlaceholder("history"),              # ② past turns park here
    ("human", "{question}"),                     # ③ the new question
])
chain = (prompt | model)

history = [HumanMessage("My name is Invisy."), AIMessage("Hi Invisy!")]
print(chain.invoke({"history": history, "question": "is this true that engineers who made transformers fro chat gpt or other models they themselves doesn't knoe exactly how these works?"}).content)
# → "Your name is Invisy."  ✅ it "remembered" — because WE re-sent the history