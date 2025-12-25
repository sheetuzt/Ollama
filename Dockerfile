FROM nvidia/cuda:12.1.1-runtime-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV OLLAMA_HOST=0.0.0.0:11434
ENV CUDA_VISIBLE_DEVICES=0
ENV OLLAMA_NUM_GPU=1
ENV OLLAMA_KEEP_ALIVE=10m

RUN apt update && apt install -y \
    curl ca-certificates netcat python3 python3-pip \
    && rm -rf /var/lib/apt/lists/*

RUN pip3 install flask requests

# Install Ollama
RUN curl -fsSL https://ollama.com/install.sh | sh

WORKDIR /app
COPY app.py .
COPY index.html .

EXPOSE 8000

CMD sh -c "\
echo '▶ Starting Ollama server' && \
ollama serve & \
echo '⏳ Waiting for Ollama...' && \
until nc -z localhost 11434; do sleep 1; done && \
echo '⬇ Pulling 22B model (first run only)...' && \
ollama pull hf.co/DavidAU/Qwen3-The-Xiaolong-Josiefied-Omega-Directive-22B-uncensored-abliterated-GGUF:Q4_K_M && \
echo '🔥 Starting Flask API' && \
python3 app.py"
