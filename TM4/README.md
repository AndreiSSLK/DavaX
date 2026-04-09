## Description

This project is an AI chatbot that recommends books based on user preferences.

It uses:
* RAG (Retrieval-Augmented Generation)
* ChromaDB for semantic search
* OpenAI for embeddings and text generation
* Tool calling for detailed summaries

---

## How it works

1. The user asks a question
2. Relevant books are retrieved from ChromaDB
3. The model recommends one book
4. The function `get_summary_by_title` is called
5. The final response includes the recommendation and a detailed summary

---

## Setup

### 1. Install dependencies

pip install -r requirements.txt

### 2. Set API key

Create a `.env` file:
OPENAI_API_KEY=your_api_key

---

## Run the project

### 1. Ingest data

python ingest.py


### 2. Start the chatbot

python app.py

Or

Run with Web UI (Streamlit)
1. Install Streamlit
pip install streamlit

2. Start the app
python -m streamlit run streamlit_app.py

The app will open in your browser at:
http://localhost:8501

---

## Example queries

* I want a book about freedom and social control
* What do you recommend if I like fantasy stories?
* I want a book about friendship and magic

---

## Technologies

* Python
* OpenAI API
* ChromaDB

