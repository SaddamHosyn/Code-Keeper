FROM python:3.9-slim

WORKDIR /app

# Install dependencies first to leverage Docker caching
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application files
COPY . .

# Expose the default port from your server.py
EXPOSE 8080

# Run the server
CMD ["python", "server.py"]