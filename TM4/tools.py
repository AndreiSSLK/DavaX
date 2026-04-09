from typing import Dict


book_summaries_dict: Dict[str, str] = {
    "1984": (
        "1984 by George Orwell is a dystopian novel about a totalitarian society "
        "where the government controls every aspect of life through surveillance, "
        "propaganda, and manipulation of truth. Winston Smith begins to question "
        "the system and seeks freedom and truth. The novel explores themes of control, "
        "fear, resistance, and loss of individuality."
    ),
    "The Hobbit": (
        "The Hobbit by J.R.R. Tolkien follows Bilbo Baggins, a quiet hobbit who is "
        "unexpectedly drawn into an adventure with a group of dwarves and the wizard Gandalf. "
        "Their mission is to reclaim a treasure guarded by the dragon Smaug. Along the way, "
        "Bilbo discovers courage, resourcefulness, and personal growth."
    ),
    "Harry Potter and the Sorcerer's Stone": (
        "This story follows Harry Potter, a young boy who discovers he is a wizard and begins "
        "his journey at Hogwarts School of Witchcraft and Wizardry. He forms strong friendships "
        "and uncovers secrets about his past while facing dark forces. The book explores magic, "
        "friendship, courage, and the battle between good and evil."
    ),
    "The Lord of the Rings": (
        "The Lord of the Rings is an epic fantasy about a quest to destroy a powerful ring that "
        "could bring darkness to the world. Frodo and his companions face great dangers and "
        "sacrifices along the journey. The story explores themes of friendship, heroism, sacrifice, "
        "and the struggle between good and evil."
    ),
    "To Kill a Mockingbird": (
        "Set in the American South, this novel follows Scout Finch as her father, Atticus Finch, "
        "defends a black man falsely accused of a crime. The story highlights injustice, racism, "
        "and moral growth, exploring themes of empathy, courage, and doing what is right."
    ),
    "The Book Thief": (
        "Set in Nazi Germany, the story follows Liesel, a young girl who finds comfort in stealing "
        "books and sharing them with others. Narrated by Death, the novel highlights the power of "
        "words and human resilience during times of war. It explores themes of loss, friendship, "
        "and hope."
    ),
    "All Quiet on the Western Front": (
        "This novel tells the story of young soldiers during World War I and the harsh realities of "
        "life on the battlefield. It shows the emotional and physical toll of war and the loss of "
        "innocence. The book explores themes of trauma, loss, and the brutality of conflict."
    ),
    "Pride and Prejudice": (
        "This novel explores the relationship between Elizabeth Bennet and Mr. Darcy in a society "
        "driven by class and social expectations. Through misunderstandings and personal growth, "
        "the story highlights themes of love, pride, prejudice, and self-awareness."
    ),
    "The Alchemist": (
        "The Alchemist follows Santiago, a young shepherd who embarks on a journey to find treasure "
        "and fulfill his personal legend. Along the way, he learns about destiny, purpose, and "
        "listening to his heart. The story is philosophical and focuses on self-discovery and dreams."
    ),
    "Brave New World": (
        "Brave New World presents a futuristic society controlled by technology, conditioning, and "
        "artificial happiness. People are engineered and individuality is suppressed. The novel "
        "explores themes of control, freedom, identity, and the cost of a seemingly perfect society."
    ),
    "Dune": (
        "Dune is a science fiction novel set on the desert planet Arrakis, where political intrigue, "
        "religion, and control over a valuable resource shape the future. Paul Atreides must navigate "
        "complex power dynamics and fulfill a greater destiny. Themes include power, survival, and ecology."
    ),
    "The Little Prince": (
        "The Little Prince is a philosophical tale about a young prince who travels between planets, "
        "learning lessons about love, loneliness, and human nature. Though simple on the surface, "
        "the story explores deep themes of meaning, innocence, and perspective."
    ),
}


def get_summary_by_title(title: str) -> str:
    """
    Returnează rezumatul complet pentru un titlu exact.
    """
    normalized_title = title.strip()

    if normalized_title in book_summaries_dict:
        return book_summaries_dict[normalized_title]

    return f"Nu am găsit un rezumat complet pentru titlul: {title}"