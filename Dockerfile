FROM nvidia/cuda:12.1.1-runtime-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV OLLAMA_HOST=0.0.0.0:11434
ENV CUDA_VISIBLE_DEVICES=0
ENV OLLAMA_NUM_GPU=1
ENV OLLAMA_KEEP_ALIVE=10m

RUN apt update && apt install -y \
    curl ca-certificates netcat \
    && rm -rf /var/lib/apt/lists/*

# Install Ollama
RUN curl -fsSL https://ollama.com/install.sh | sh

EXPOSE 11434

CMD sh -c "\
ollama serve & \
echo 'Waiting for Ollama server...' && \
until nc -z localhost 11434; do sleep 1; done && \
echo 'Ollama server is up' && \
ollama pull hf.co/DavidAU/Qwen3-The-Xiaolong-Josiefied-Omega-Directive-22B-uncensored-abliterated-GGUF:Q4_K_M && \
wait"
