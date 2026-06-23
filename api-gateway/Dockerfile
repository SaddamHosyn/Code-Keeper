FROM python:3.9-slim

WORKDIR /app

RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

COPY requirements.txt .
RUN python -m pip install --upgrade pip && \
    pip install -v --default-timeout=100 --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 3000
ENTRYPOINT ["./entrypoint.sh"]