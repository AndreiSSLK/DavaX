import streamlit as st
from rag_pipeline import recommend_book_with_tool


st.set_page_config(page_title="Smart Librarian")

st.title("Smart Librarian")

st.write("Ask for a book recommendation based on your interests.")

user_query = st.text_input("What kind of book are you looking for?")

if st.button("Recommend"):
    if user_query:
        with st.spinner("Thinking..."):
            try:
                response = recommend_book_with_tool(user_query)
                st.success("Recommendation:")
                st.write(response)
            except Exception as e:
                st.error(f"Error: {e}")
    else:
        st.warning("Please enter a query.")