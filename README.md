# 🖼️ Invision - Shape Detector App

Invision is a Flutter-based mobile application that allows users to capture or upload an image and send it to a backend server for shape detection. The server processes the image and returns a version highlighting detected shapes, which is then displayed in the app alongside the original image.

---

## 🚀 Features

- 📸 Capture image using the device camera
- 🖼️ Select image from the gallery
- 📤 Upload image to a Flask-based backend for processing
- 🔁 Display both the original and processed image side by side
- 🎨 Clean and modern UI with subtle shadows and responsive design
- 🧠 Automatically replaces old outputs to conserve memory

---

## 🛠️ Built With

- **Flutter** (Frontend)
- **Dart**
- **HTTP** package for network requests
- **Image Picker** for image selection
- **Path Provider** for temp file handling
- **Flask** (Expected backend server)
- **Image Processing (Server-Side)** – using OpenCV or similar (not included here)

---

## 🧪 How It Works

1. User selects an image via **Camera** or **Gallery**.
2. On tapping **Upload**, the image is sent to the server (`/detect-shapes` endpoint).
3. Server responds with a processed image.
4. The app displays both the **original** and the **processed** image side by side.

---

## 📦 Folder Structure

lib/
├── main.dart
├── shape_detector.dart ← The core widget

---

## 📡 Backend Requirements

Make sure your backend server is:
- Running on the same network as the device
- Accepting POST requests at `/detect-shapes`
- Returning the processed image as a binary stream (`image/png`)
- Replace the IP http://192.168.0.134:5000 in the code with your server’s IP if needed.

---

## Future Improvements
- Add loading indicator animation
- Improve error handling (network failure, timeout)
- Add support for multiple shapes and overlays

---

Thank you for checking out this project! Feel free to contribute or raise issues.

## Author
Ayaan Shaikh
Ayaan-7091
samx7091@gmail.com
