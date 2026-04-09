import json
import os
from typing import List, Dict, Any

import chromadb
from chromadb.utils import embedding_functions
from dotenv import load_dotenv
from openai import OpenAI

from tools import get_summary_by_title


load_dotenv()


CHROMA_PATH = "chroma_db"
COLLECTION_NAME = "book_summaries"
EMBEDDING_MODEL = "text-embedding-3-small"
CHAT_MODEL = "gpt-4o-mini"


def get_collection():
    api_key = os.getenv("OPENAI_API_KEY")
    if not api_key:
        raise ValueError("OPENAI_API_KEY nu este setat în .env")

    client = chromadb.PersistentClient(path=CHROMA_PATH)

    openai_ef = embedding_functions.OpenAIEmbeddingFunction(
        api_key=api_key,
        model_name=EMBEDDING_MODEL
    )

    collection = client.get_collection(
        name=COLLECTION_NAME,
        embedding_function=openai_ef
    )
    return collection


def retrieve_books(user_query: str, n_results: int = 3) -> Dict[str, Any]:
    collection = get_collection()

    results = collection.query(
        query_texts=[user_query],
        n_results=n_results
    )

    return results


def format_context(results: Dict[str, Any]) -> str:
    documents = results.get("documents", [[]])[0]
    metadatas = results.get("metadatas", [[]])[0]

    if not documents or not metadatas:
        return "No relevant books found."

    context_parts: List[str] = []

    for idx, (doc, metadata) in enumerate(zip(documents, metadatas), start=1):
        title = metadata.get("title", "Unknown Title")
        context_parts.append(
            f"Book {idx}:\n"
            f"Title: {title}\n"
            f"Summary: {doc}\n"
        )

    return "\n".join(context_parts)


def recommend_book_with_tool(user_query: str) -> str:
    """
    Flow complet:
    1. Retrieval din ChromaDB
    2. LLM recomandă o carte
    3. LLM face tool call la get_summary_by_title
    4. Returnăm recomandarea + rezumatul complet
    """
    api_key = os.getenv("OPENAI_API_KEY")
    if not api_key:
        raise ValueError("OPENAI_API_KEY nu este setat în .env")

    results = retrieve_books(user_query=user_query, n_results=3)
    context = format_context(results)

    client = OpenAI(api_key=api_key)

    tools = [
        {
            "type": "function",
            "name": "get_summary_by_title",
            "description": "Returnează rezumatul complet pentru un titlu exact de carte.",
            "parameters": {
                "type": "object",
                "properties": {
                    "title": {
                        "type": "string",
                        "description": "Titlul exact al cărții recomandate"
                    }
                },
                "required": ["title"],
                "additionalProperties": False
            }
        }
    ]

    system_prompt = """
You are a helpful AI librarian.

Your job:
1. Read the user's request.
2. Use only the retrieved context.
3. Choose exactly one best matching book.
4. Briefly explain why it matches.
5. Then call the tool get_summary_by_title with the exact recommended title.

Important rules:
- Recommend exactly one book.
- Use the exact title as it appears in the retrieved context.
- Do not invent titles.
- Always call the tool after deciding the recommendation.
"""

    user_prompt = f"""
User request:
{user_query}

Retrieved context:
{context}
"""

    response = client.responses.create(
        model=CHAT_MODEL,
        input=[
            {"role": "system", "content": system_prompt},
            {"role": "user", "content": user_prompt}
        ],
        tools=tools
    )

    recommended_title = None
    short_explanation = None
    detailed_summary = None

    for item in response.output:
        if item.type == "message":
            for content in item.content:
                if content.type == "output_text":
                    short_explanation = content.text

        elif item.type == "function_call":
            if item.name == "get_summary_by_title":
                arguments = json.loads(item.arguments)
                recommended_title = arguments["title"]
                detailed_summary = get_summary_by_title(recommended_title)

    if not recommended_title:
        return "Nu am putut determina titlul recomandat."

    if not short_explanation:
        short_explanation = f"Îți recomand cartea '{recommended_title}'."

    if not detailed_summary:
        detailed_summary = get_summary_by_title(recommended_title)

    final_answer = (
        f"{short_explanation}\n\n"
        f"Detailed summary for '{recommended_title}':\n"
        f"{detailed_summary}"
    )

    return final_answer