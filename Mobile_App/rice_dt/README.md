# RiceDT

## Lightweight CNN Model for Real-Time Rice Leaf Disease Detection on Mobile Devices

RiceDT is a Flutter-based mobile application developed as part of a Final Year Design Project (FYDP). The application integrates a lightweight CNN model converted to TensorFlow Lite (TFLite) to perform rice leaf disease classification directly on a mobile device.

The application allows users to provide a rice leaf image through the camera or gallery and receive a predicted disease class.

---

## Features

- 📷 Capture rice leaf images using the device camera
- 🖼️ Select rice leaf images from the device gallery
- 🧠 On-device rice leaf disease classification
- ⚡ Lightweight TensorFlow Lite model
- 📱 Mobile-based inference
- 📊 Prediction result display
- 🌾 Supports five rice leaf classes

---

## Supported Classes

RiceDT classifies rice leaf images into the following five categories:

| Class |
|---|
| Bacterial Blight |
| Blast |
| Brown Spot |
| Healthy |
| Tungro |

---

## Application Workflow

```text
User
  ↓
Camera / Gallery
  ↓
Rice Leaf Image
  ↓
Image Preprocessing
  ↓
TensorFlow Lite Model
  ↓
Prediction
  ↓
Result Display