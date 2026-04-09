from rag_pipeline import recommend_book_with_tool


def main() -> None:
    print("Smart Librarian CLI")
    print("Scrie o întrebare despre ce tip de carte vrei.")
    print("Scrie 'exit' pentru a ieși.\n")

    while True:
        user_query = input("Tu: ").strip()

        if user_query.lower() in {"exit", "quit"}:
            print("La revedere!")
            break

        if not user_query:
            print("Te rog introdu o întrebare.\n")
            continue

        try:
            answer = recommend_book_with_tool(user_query)
            print(f"\nAsistent: {answer}\n")
        except Exception as e:
            print(f"\nA apărut o eroare: {e}\n")


if __name__ == "__main__":
    main()