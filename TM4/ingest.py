import os
import re
from typing import List, Dict

import chromadb
from chromadb.utils import embedding_functions
from dotenv import load_dotenv


load_dotenv()


BOOKS_FILE = "book_summaries.txt"
CHROMA_PATH = "chroma_db"
COLLECTION_NAME = "book_summaries"


def parse_books(file_path: str) -> List[Dict[str, str]]:
    """
    Citește fișierul txt și îl sparge în documente de forma:
    [
        {"title": "...", "summary": "..."},
        ...
    ]
    """
    with open(file_path, "r", encoding="utf-8") as f:
        content = f.read().strip()

    # Separa dupa fiecare sectiune care incepe cu ## Title:
    raw_entries = re.split(r"\n(?=## Title: )", content)

    books = []

    for entry in raw_entries:
        entry = entry.strip()
        if not entry:
            continue

        lines = entry.splitlines()
        first_line = lines[0].strip()

        if not first_line.startswith("## Title:"):
            continue

        title = first_line.replace("## Title:", "").strip()
        summary = "\n".join(line.strip() for line in lines[1:] if line.strip())

        if title and summary:
            books.append({
                "title": title,
                "summary": summary
            })

    return books


def main() -> None:
    api_key = os.getenv("OPENAI_API_KEY")
    if not api_key:
        raise ValueError("OPENAI_API_KEY nu este setat în .env")

    if not os.path.exists(BOOKS_FILE):
        raise FileNotFoundError(f"Nu am găsit fișierul: {BOOKS_FILE}")

    books = parse_books(BOOKS_FILE)

    if not books:
        raise ValueError("Nu s-au găsit cărți în fișierul book_summaries.txt")

    print(f"Am găsit {len(books)} cărți.")

    client = chromadb.PersistentClient(path=CHROMA_PATH)

    openai_ef = embedding_functions.OpenAIEmbeddingFunction(
        api_key=api_key,
        model_name="text-embedding-3-small"
    )

    collection = client.get_or_create_collection(
        name=COLLECTION_NAME,
        embedding_function=openai_ef
    )

    #sterge tot ce exista deja, ca sa nu dublezi datele la rerun
    existing = collection.get()
    if existing["ids"]:
        collection.delete(ids=existing["ids"])
        print("Colecția a fost curățată înainte de re-ingestie.")

    documents = []
    metadatas = []
    ids = []

    for idx, book in enumerate(books):
        documents.append(book["summary"])
        metadatas.append({"title": book["title"]})
        ids.append(f"book_{idx}")

    collection.add(
        documents=documents,
        metadatas=metadatas,
        ids=ids
    )

    print(f"Au fost adăugate {len(documents)} documente în colecția '{COLLECTION_NAME}'.")
    print(f"Vector store salvat în: {CHROMA_PATH}")


if __name__ == "__main__":
    main()