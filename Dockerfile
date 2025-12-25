FROM nvidia/cuda:12.1.1-runtime-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV OLLAMA_HOST=0.0.0.0:11434
ENV CUDA_VISIBLE_DEVICES=0
ENV OLLAMA_NUM_GPU=1
ENV OLLAMA_KEEP_ALIVE=10m

RUN apt update && apt install -y \
    curl ca-certificates netcat python3 \
    && rm -rf /var/lib/apt/lists/*

# Install Ollama
RUN curl -fsSL https://ollama.com/install.sh | sh

# Copy UI
WORKDIR /app
COPY index.html .

EXPOSE 11434
EXPOSE 8000

CMD sh -c "\
ollama serve & \
until nc -z localhost 11434; do sleep 1; done && \
ollama pull hf.co/DavidAU/Qwen3-The-Xiaolong-Josiefied-Omega-Directive-22B-uncensored-abliterated-GGUF:Q4_K_M & \
python3 -m http.server 8000 & \
wait"
