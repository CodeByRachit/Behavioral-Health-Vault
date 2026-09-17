FROM python:3.10-slim

# Set working directory
WORKDIR /app

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Install system dependencies (needed for cryptography/PyMongo if building from source)
RUN apt-get update && apt-get install -y \
    gcc \
    libffi-dev \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# Install python dependencies
COPY requirements.txt .
RUN pip install --upgrade pip && pip install -r requirements.txt

# Copy the rest of the application
COPY . .

# Expose port (assuming standard Flask 5000 or gunicorn port)
EXPOSE 5000

# Run the application (Production servers usually use gunicorn, but we'll use flask run for simplicity, or python app.py)
CMD ["python", "app.py"]
