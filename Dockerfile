FROM ollama/ollama:latest

ENV OLLAMA_HOST=0.0.0.0:11434
ENV OLLAMA_NUM_GPU=1
ENV CUDA_VISIBLE_DEVICES=0
ENV OLLAMA_KEEP_ALIVE=10m

EXPOSE 11434

CMD ollama serve & \
    ollama pull hf.co/DavidAU/Qwen3-The-Xiaolong-Josiefied-Omega-Directive-22B-uncensored-abliterated-GGUF:Q4_K_M && \
    wait
