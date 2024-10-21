from flask import Flask, request, send_from_directory, jsonify
from flask_cors import CORS
import yt_dlp
import subprocess
import os
import time

app = Flask(__name__, static_folder='build/web')  # Updated to point to Flutter build folder
CORS(app)

# Set the static folder for serving static files
app.config['UPLOAD_FOLDER'] = os.path.join(os.getcwd(), 'static')

# Ensure the static directory exists
if not os.path.exists(app.config['UPLOAD_FOLDER']):
    os.makedirs(app.config['UPLOAD_FOLDER'])  # Create the static folder if it doesn't exist

# Root route to serve the Flutter web app
@app.route('/')
def index():
    return send_from_directory(app.static_folder, 'index.html')

# Serve all other static files (JS, CSS, etc.)
@app.route('/<path:path>')
def serve_static_files(path):
    return send_from_directory(app.static_folder, path)

# Convert video route remains unchanged
@app.route('/convert', methods=['POST'])
def convert_video():
    video_url = request.json.get('url')
    if not video_url:
        return {"error": "No URL provided"}, 400

    # Paths to audio files
    base_dir = os.getcwd()
    original_file = os.path.join(base_dir, 'downloaded_audio.wav')
    static_file_path = os.path.join(app.config['UPLOAD_FOLDER'], 'trimmed_audio.wav')

    # Remove any existing audio files to avoid overwriting issues
    for file_path in [original_file, static_file_path]:
        if os.path.exists(file_path):
            os.remove(file_path)

    ydl_opts = {
        'format': 'bestaudio/best',
        'outtmpl': os.path.join(base_dir, 'downloaded_audio'),  # Remove '.wav' from here
        'postprocessors': [{
            'key': 'FFmpegExtractAudio',
            'preferredcodec': 'wav',
            'preferredquality': '192',
        }],
        ################ 'ffmpeg-location': 'C:/ffmpeg-7.1-essentials_build/bin',  # Update this with the correct path
        'cookiefile': '/app/assets/youtube_cookies.txt',  # Path to your cookie file
        'verbose': True  # Enable verbose logging for debugging
    }

    try:
        # Download the audio using yt-dlp
        with yt_dlp.YoutubeDL(ydl_opts) as ydl:
            ydl.download([video_url])

        # Ensure the downloaded audio file is fully written
        wait_for_file_release(original_file)

        if not os.path.exists(original_file):
            return jsonify({"error": "Downloaded audio not found"}), 404

        # Trim the first 15 to 30 seconds using FFmpeg
        start_time = 15  # Start at 15 seconds
        duration = 15     # Duration of 15 seconds

        result = subprocess.run([
            'ffmpeg', '-i', original_file,
            '-ss', str(start_time), '-t', str(duration),
            '-c', 'copy', static_file_path
        ], capture_output=True, text=True)

        if result.returncode != 0:
            return jsonify({"error": f"FFmpeg failed: {result.stderr}"}), 500

        # Verify the trimmed file exists and return the URL
        if os.path.exists(static_file_path):
            return jsonify({"success": "Trimmed audio created", "url": "/static/trimmed_audio.wav"})
        else:
            return jsonify({"error": "Trimmed audio not found"}), 404

    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/static/<filename>')
def serve_static_file(filename):
    # Serve files from the static directory
    return send_from_directory(app.config['UPLOAD_FOLDER'], filename)

def wait_for_file_release(file_path, timeout=60):
    """Ensure the file is not locked and is ready to be processed."""
    start_time = time.time()
    last_size = -1

    while time.time() - start_time < timeout:
        try:
            # Check if the file size has stopped changing
            current_size = os.path.getsize(file_path)
            if current_size == last_size:
                # File size has stopped changing, so it's ready
                print(f"File {file_path} is ready for access.")
                return
            last_size = current_size
            print(f"File {file_path} is still being written. Waiting...")
            time.sleep(1)  # Check every 1 second
        except OSError:
            print(f"File {file_path} is still locked or unavailable. Retrying...")
            time.sleep(1)  # Wait for 1 second before trying again

    raise Exception(f"Timeout waiting for file to be released: {file_path}")

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 8080))
    app.run(host='0.0.0.0', port=port)
