# Use an official Python runtime as a parent image
FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /app

# Copy the entire current local directory contents into the /app directory in the container
COPY . /app

# Copy the youtube_cookies.txt to the /app/assets directory inside the container
COPY assets/youtube_cookies.txt /app/assets/

COPY static/ /app/static/

# Install required packages from requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Install yt-dlp and ensure it's the latest version
RUN pip install --no-cache-dir --upgrade yt-dlp

# Install FFmpeg for audio processing
RUN apt-get update && apt-get install -y ffmpeg

# Expose port 8080 for Flask
EXPOSE 8080

# Define environment variable for Cloud Run to use
ENV PORT=8080

# Run the Flask app using Gunicorn (with 4 workers as an example)
CMD ["gunicorn", "--bind", "0.0.0.0:8080", "--workers", "4", "--timeout", "120", "app:app"]

