# RiceDT — FYDP

## Lightweight CNN Model for Real-Time Rice Leaf Disease Detection on Mobile Devices

RiceDT is a mobile-based rice leaf disease detection system developed as a **Final Year Design Project (FYDP)**. The project uses a lightweight Convolutional Neural Network (CNN) to classify rice leaf images into five categories and deploys the trained model on a mobile application using TensorFlow Lite.

The main objective of the project is to develop a compact deep-learning solution that can provide accurate rice leaf disease classification while maintaining low computational and memory requirements for mobile deployment.

---

## Project Overview

Rice is one of the most important crops in Bangladesh and many other agricultural regions. Rice plants are affected by several diseases that can significantly reduce crop productivity. Early identification of these diseases can help farmers take appropriate measures before the infection becomes severe.

RiceDT addresses this problem by combining:

- A lightweight CNN-based deep-learning model
- Image preprocessing and enhancement
- Rice leaf disease classification
- Model evaluation and computational analysis
- Grad-CAM and Grad-CAM++ explainability analysis
- TensorFlow Lite model conversion
- A Flutter-based mobile application

The trained model is integrated into the RiceDT mobile application, allowing users to provide a rice leaf image through the application and receive the predicted disease category.

---

## Disease Classes

The proposed system classifies rice leaf images into five classes:

| Class | Description |
|---|---|
| Bacterial Blight | Rice leaf affected by bacterial blight |
| Blast | Rice leaf affected by blast disease |
| Brown Spot | Rice leaf affected by brown spot disease |
| Healthy | Healthy rice leaf |
| Tungro | Rice leaf affected by tungro disease |

---

## Dataset

The final dataset contains **4,212 images** distributed across five classes.

| Class | Training | Validation | Testing | Total |
|---|---:|---:|---:|---:|
| Bacterial Blight | 656 | 82 | 83 | 821 |
| Blast | 621 | 77 | 79 | 777 |
| Brown Spot | 536 | 67 | 69 | 672 |
| Healthy | 774 | 96 | 98 | 968 |
| Tungro | 779 | 97 | 98 | 974 |
| **Total** | **3,366** | **419** | **427** | **4,212** |

The dataset was prepared by integrating publicly available rice disease image sources, followed by manual quality screening and hash-based duplicate detection.

### Dataset Sources

- P. K. Sethy, *Rice Leaf Disease Image Samples*, Mendeley Data, vol. 2, Jul. 2024. DOI: `10.17632/fwcj7stb8r.2`
- M. M. Hasan, *Rice Leaf Disease DataSet*, Kaggle, 2023.

The complete dataset is **not included in this repository**. Users should obtain the original datasets from their respective sources and follow their applicable terms of use.

---

## Image Preprocessing

The input images are processed through a deterministic preprocessing pipeline before being passed to the model.

```text
Original Image
      ↓
Center Crop (90%)
      ↓
Resize to 256 × 256
      ↓
CLAHE
      ↓
White Balance
      ↓
Bilateral Filtering
      ↓
HSV Color Enhancement
      ↓
Resize to 224 × 224
      ↓
Tensor Conversion
      ↓
ImageNet Normalization
      ↓
CNN Model