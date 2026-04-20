# Use official Python slim image
FROM python:3.11-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
ENV PORT 8000

# Set working directory
WORKDIR /app

# Install system dependencies for language-tool-python (Requires Java)
RUN apt-get update && apt-get install -y \
    default-jre \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy project files
COPY . .

# Expose the port
EXPOSE 8000

# Command to run the application
# We use workers=1 for LLM proxying to avoid rate limiting and connection overhead
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
