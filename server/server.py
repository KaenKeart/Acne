from flask import Flask, request, jsonify
from flask_cors import CORS
import tensorflow as tf
from tensorflow.keras.applications import MobileNetV2
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import GlobalAveragePooling2D, Dropout, Dense
import numpy as np
import os

# สร้างแอป Flask
app = Flask(__name__)
CORS(app)

# สร้างโมเดลใหม่โดยไม่โหลดจากไฟล์ .h5
def build_model():
    img_height, img_width = 224, 224
    base_model = MobileNetV2(include_top=False, weights='imagenet', input_shape=(img_height, img_width, 3))

    for layer in base_model.layers:
        layer.trainable = False

    model = Sequential([
        base_model,
        GlobalAveragePooling2D(),
        Dropout(0.2),
        Dense(3, activation='softmax')  # 3 classes: Mild, Moderate, Severe
    ])
    
    return model

# เรียกใช้ฟังก์ชันเพื่อสร้างโมเดล
model = build_model()

# ฟังก์ชันทำนายภาพ
def predict_image(image_path):
    img = tf.keras.preprocessing.image.load_img(image_path, target_size=(224, 224))
    img_array = tf.keras.preprocessing.image.img_to_array(img) / 255.0
    img_array = np.expand_dims(img_array, axis=0)

    predictions = model.predict(img_array)
    labels = ['Mild', 'Moderate', 'Severe']
    prediction_results = []

    for i, probability in enumerate(predictions[0]):
        percentage = round(float(probability) * 100, 2)
        prediction_results.append({
            'class': labels[i],
            'probability': percentage
        })

    return prediction_results

# Endpoint สำหรับทำนายผล
@app.route('/predict', methods=['POST'])
def predict():
    if 'image' not in request.files:
        return jsonify({'error': 'No image file uploaded'}), 400

    file = request.files['image']
    file_path = os.path.join('uploads', file.filename)

    # บันทึกไฟล์ภาพ
    if not os.path.exists('uploads'):
        os.makedirs('uploads')
    file.save(file_path)

    # ทำนายผลลัพธ์
    result = predict_image(file_path)

    # ลบไฟล์ภาพหลังจากทำนายเสร็จ
    os.remove(file_path)

    # ส่งผลลัพธ์กลับไป
    return jsonify({'predictions': result})

# รันเซิร์ฟเวอร์ Flask
if __name__ == '__main__':
    app.run(port=5000, debug=True)
