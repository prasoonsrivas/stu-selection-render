# 1. Use stable Python base image
FROM python:3.11-slim

# 2. Prevent Python buffering issues
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# 3. Set working directory
WORKDIR /app

# 4. Install system dependencies (needed for scipy wheels)
RUN apt-get update && apt-get install -y \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# 5. Copy requirements first (for layer caching)
COPY requirements.txt .

# 6. Install Python dependencies
RUN pip install --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt

# 7. Copy application code
COPY . .

# 8. Expose port
EXPOSE 8000

# 9. Start the app (FastAPI example)
CMD ["gunicorn", "app:app", "--bind", "0.0.0.0:8000"]
# if using flask, use:
# CMD ["gunicorn", "app:app", "--bind", "0.0.0.0:8000"]
#CMD ["gunicorn", "app:app", "-k", "uvicorn.workers.UvicornWorker", "--bind", "0.0.0.0:8000"]
