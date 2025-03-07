from flask import Flask, request, jsonify, send_from_directory
import os
import json
import requests
import numpy as np
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity
from PyPDF2 import PdfReader
import re

app = Flask(__name__)

# Step 1: Extract text from PDF and create a knowledge base
def extract_text_from_pdf(pdf_path):
    try:
        reader = PdfReader(pdf_path)
        text = ""
        for page in reader.pages:
            text += page.extract_text() or ""  # Handle None from extract_text()
        return text
    except Exception as e:
        raise Exception(f"Error reading PDF: {str(e)}")

def create_knowledge_base(pdf_path):
    text = extract_text_from_pdf(pdf_path)
    knowledge_base = text.split("\n\n")  # Adjust based on your PDF structure
    return knowledge_base

# Step 2: Vectorize the knowledge base for similarity search
def vectorize_knowledge_base(knowledge_base):
    vectorizer = TfidfVectorizer()
    tfidf_matrix = vectorizer.fit_transform(knowledge_base)
    return vectorizer, tfidf_matrix

# Step 3: Search the knowledge base for relevant answers
def search_knowledge_base(query, vectorizer, tfidf_matrix, knowledge_base, threshold=0.2):
    query_vec = vectorizer.transform([query])
    similarities = cosine_similarity(query_vec, tfidf_matrix).flatten()
    best_match_index = np.argmax(similarities)
    if similarities[best_match_index] > threshold:
        return knowledge_base[best_match_index]
    return None

# Step 4: Query DeepSeek API
def query_deepseek_api(prompt):
    api_key = os.getenv("DEEPSEEK_API_KEY", "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")
    url = "https://openrouter.ai/api/v1/chat/completions"
    headers = {
        "Authorization": f"Bearer {api_key}",
        "Content-Type": "application/json"
    }
    payload = {
        "model": "deepseek/deepseek-r1:free",
        "messages": [{"role": "user", "content": prompt}]
    }
    response = requests.post(url, headers=headers, data=json.dumps(payload))
    if response.status_code == 200:
        return response.json()
    else:
        return {"error": f"API request failed with status {response.status_code}"}

# Step 5: Check if the query is related to mining
def is_mining_related(query):
    mining_keywords = [
        "mining", "coal", "mine", "safety", "regulation", "law", "act",
        "mineral", "excavation", "drilling", "ventilation", "explosive",
        "hazard", "worker", "environment", "rescue", "geology", "seam",
        "shaft", "tunnel", "ore", "extraction", "quarry", "underground",
        "surface", "mining equipment", "metals", "ores", "processing",
        "refining", "conveyor", "open-pit", "deep mining", "strip mining",
        "gold", "diamond", "copper", "zinc", "lead", "nickel", "bauxite",
        "iron ore", "uranium", "rare earth elements", "smelting",
        "beneficiation", "tailings", "waste disposal", "reclamation",
        "mine closure", "mine planning", "rock mechanics", "hydrogeology",
        "drainage", "mine surveying", "land subsidence", "mine ventilation",
        "gas detection", "methane", "dust control", "fumes", "cyanide",
        "leaching", "heap leaching", "mineral rights", "royalty", "permit",
        "lease", "licensing", "blast", "explosives", "tunneling",
        "mining operations", "dredging", "placer mining", "acid mine drainage",
        "mine rehabilitation", "mining machinery", "mine safety act",
        "occupational health", "mine workers", "mining corporation",
        "government regulations", "small-scale mining", "artisanal mining",
        "illegal mining", "mine accidents", "stripping ratio",
        "mine slope stability", "groundwater control", "ore grade", "sampling",
        "core drilling", "exploration", "surveying", "rock blasting"
    ]

    query_lower = query.lower()  # Properly indented
    return any(keyword in query_lower for keyword in mining_keywords)

# Remove Markdown formatting from text
def remove_markdown(text):
    """Remove Markdown formatting from text."""
    text = re.sub(r'\*\*(.*?)\*\*', r'\1', text)  # Remove bold (**text**)
    text = re.sub(r'\*(.*?)\*', r'\1', text)      # Remove italics (*text*)
    text = re.sub(r'#+ ', '', text)              # Remove headings (#, ##, ###)
    text = re.sub(r'- ', '', text)               # Remove list dashes (- item)
    text = re.sub(r'\n+', '\n', text)            # Normalize multiple newlines
    return text.strip()

# Format the response to make it more readable
def format_response(response, max_length=5000):
    """
    Format the response to make it more readable.
    - Split into paragraphs.
    - Add headings or bullet points.
    - Limit response length if it exceeds max_length.
    """
    # Split the response into paragraphs
    paragraphs = response.split('\n\n')

    # Remove empty paragraphs
    paragraphs = [p.strip() for p in paragraphs if p.strip()]

    # Add headings or bullet points
    formatted_response = []
    for i, paragraph in enumerate(paragraphs):
        if i == 0:
            formatted_response.append(f"**Response:**\n{paragraph}")
        else:
            formatted_response.append(f"\n• {paragraph}")

    # Join the paragraphs into a single response
    formatted_response = '\n'.join(formatted_response)

    # Truncate the response if it exceeds max_length
    if len(formatted_response) > max_length:
        formatted_response = formatted_response[:max_length] + "... [Response truncated]"

    return formatted_response

# Chatbot function
def chatbot(query, vectorizer, tfidf_matrix, knowledge_base):
    if not is_mining_related(query):
        return "Please ask questions related to mining."

    # Search the knowledge base for an answer
    answer = search_knowledge_base(query, vectorizer, tfidf_matrix, knowledge_base)

    if answer:
        return format_response(remove_markdown(answer))

    # If no answer is found in the knowledge base, query the DeepSeek API
    prompt = f"Generate a general answer related to mining laws for the query: {query}"
    response = query_deepseek_api(prompt)

    if response and 'choices' in response and response['choices']:
        raw_answer = response['choices'][0]['message']['content']
        return format_response(remove_markdown(raw_answer))

    return "I'm sorry, I couldn't find an answer to your question. Please try rephrasing it or contacting support."

# Initialize knowledge base and vectorizer globally
knowledge_base = None
vectorizer = None
tfidf_matrix = None

def initialize_knowledge_base():
    global knowledge_base, vectorizer, tfidf_matrix
    pdf_path = "/home/singh7nishitha/new_mining_bot/merged.pdf"
    knowledge_base = create_knowledge_base(pdf_path)
    vectorizer, tfidf_matrix = vectorize_knowledge_base(knowledge_base)

# Call initialization
initialize_knowledge_base()

@app.route("/chat", methods=["POST"])
def chat_endpoint():
    try:
        data = request.json
        if not data or "query" not in data:
            return jsonify({"error": "Invalid request: 'query' is required"}), 400
        query = data.get("query", "")
        response = chatbot(query, vectorizer, tfidf_matrix, knowledge_base)
        return jsonify({"response": response})
    except Exception as e:
        return jsonify({"error": f"Server error: {str(e)}"}), 500

@app.route("/")
def root():
    return jsonify({"message": "Welcome to the Mining Law Chatbot API!"})

@app.route('/favicon.ico')
def favicon():
    return send_from_directory(app.root_path, 'favicon.ico', mimetype='image/vnd.microsoft.icon')

@app.route('/hybridaction/zybTrackerStatisticsAction', methods=['GET'])
def hybrid_action():
    data = request.args.get("data", "{}")
    callback = request.args.get("__callback__", None)
    response_data = {"message": "Received data", "data": data}
    if callback:
        return f"{callback}({jsonify(response_data).get_data(as_text=True)})"
    return jsonify(response_data), 200