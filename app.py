from flask import Flask, request, jsonify, send_from_directory
import requests

app = Flask(__name__)

OLLAMA_URL = "http://localhost:11434/api/chat"
MODEL_NAME = "hf.co/DavidAU/Qwen3-The-Xiaolong-Josiefied-Omega-Directive-22B-uncensored-abliterated-GGUF:Q4_K_M"

@app.route("/")
def home():
    return send_from_directory(".", "index.html")

@app.route("/api/chat", methods=["POST"])
def chat():
    data = request.get_json(force=True)

    payload = {
        "model": MODEL_NAME,
        "messages": data.get("messages", []),
        "stream": False
    }

    try:
        r = requests.post(OLLAMA_URL, json=payload, timeout=900)
        r.raise_for_status()
        return jsonify(r.json())
    except Exception as e:
        return jsonify({
            "message": {
                "role": "assistant",
                "content": f"ERROR: {str(e)}"
            }
        }), 500

if __name__ == "__main__":
    print("🔥 Flask running on port 8000")
    app.run(host="0.0.0.0", port=8000)
