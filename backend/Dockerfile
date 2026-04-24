# Use official Python slim image
FROM python:3.11-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    default-jre \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy project files
COPY . .

# Expose the port (Cloud Run uses 8080 by default, but we'll use the variable)
EXPOSE 8080

# Command to run the application
# Use the shell form to allow environment variable expansion for PORT
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8080"]
