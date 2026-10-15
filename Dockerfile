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

# persistent path — Railway Volumes will mount here
ENV SHADOW_DATA_DIR=/data
RUN mkdir -p /data

# polling bot — no PORT exposed
CMD ["python", "-u", "shadow_all.py"]
