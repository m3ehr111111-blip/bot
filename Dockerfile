FROM python:3.11-slim

# ffmpeg for voice-note transcode (music still works without it — falls back to plain file)
RUN apt-get update && apt-get install -y --no-install-recommends \
        ffmpeg \
        ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# deps first — layer cache
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# source
COPY . .

# persistent volume — session/state/cookies live here
ENV SHADOW_DATA_DIR=/data
RUN mkdir -p /data
VOLUME ["/data"]

# polling bot — no PORT exposed
# -u so Railway sees logs live (unbuffered stdout)
CMD ["python", "-u", "shadow_all.py"]
