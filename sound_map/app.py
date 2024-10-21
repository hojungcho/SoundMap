from flask import Flask, request
from flask_cors import CORS

app = Flask(__name__)
CORS(app)  # This will allow all CORS requests

@app.route('/save_features', methods=['POST'])
def save_features():
    # Extract JSON data from request
    data = request.get_json()
    
    # Log the received data
    print(f"Received selected features: {data}")
    
    # Respond with a success message
    return "Features received", 200

if __name__ == '__main__':
    # Run the Flask app on port 5000
    app.run(debug=True, host='0.0.0.0', port=5000)
