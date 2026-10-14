FROM python:3.11-slim

# system deps — ffmpeg for voice-note transcode, curl for deno install
RUN apt-get update && apt-get install -y \
    ffmpeg curl unzip ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# deno — yt-dlp JS challenge solver
RUN curl -fsSL https://deno.land/install.sh | sh
ENV DENO_INSTALL="/root/.deno"
ENV PATH="$DENO_INSTALL/bin:$PATH"

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD ["python", "shadow_all.py"]
