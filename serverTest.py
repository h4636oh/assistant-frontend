from flask import Flask, request, jsonify

app = Flask(__name__)

@app.route('/', methods=['POST'])
def check_image():
    if 'image' not in request.files:
        return jsonify({"message": "No image received"}), 400
    
    image = request.files['image']
    
    if image.filename == '':
        return jsonify({"message": "No image selected"}), 400

    return jsonify({"message": "Image received successfully"}), 200

if __name__ == '__main__':
    app.run(port=3000, debug=True)
