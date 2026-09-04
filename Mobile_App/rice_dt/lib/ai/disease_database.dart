import 'disease_info.dart';

class DiseaseDatabase {
  static final Map<String, DiseaseInfo> diseases = {
    "BacterialBlight": DiseaseInfo(
      name: "Bacterial Blight",
      scientificName: "Xanthomonas oryzae pv. oryzae",

      descriptionEn:
          "Bacterial Blight is a serious bacterial disease of rice that infects leaves through wounds or natural openings. It spreads rapidly under warm and humid conditions, causing severe yield losses.",

      descriptionBn:
          "ব্যাকটেরিয়াল ব্লাইট ধানের একটি মারাত্মক ব্যাকটেরিয়াজনিত রোগ। এটি ক্ষতস্থান বা পাতার স্বাভাবিক ছিদ্র দিয়ে প্রবেশ করে এবং উষ্ণ ও আর্দ্র পরিবেশে দ্রুত ছড়িয়ে পড়ে, ফলে ফলন উল্লেখযোগ্যভাবে কমে যায়।",

      symptomsEn: [
        "Yellowing from leaf tips",
        "Water-soaked streaks on leaves",
        "Leaves dry and wilt",
        "Severe infection causes complete leaf drying",
      ],

      symptomsBn: [
        "পাতার আগা থেকে হলুদ হওয়া",
        "পাতায় পানিভেজা দাগ দেখা যায়",
        "পাতা শুকিয়ে যায়",
        "তীব্র সংক্রমণে পুরো পাতা শুকিয়ে যায়",
      ],

      causesEn: [
        "Bacterial infection",
        "Heavy rainfall and wind",
        "High humidity",
        "Contaminated irrigation water",
      ],

      causesBn: [
        "ব্যাকটেরিয়ার সংক্রমণ",
        "ভারী বৃষ্টি ও বাতাস",
        "উচ্চ আর্দ্রতা",
        "দূষিত সেচের পানি",
      ],

      treatmentEn: [
        "Remove severely infected plants",
        "Use copper-based bactericides where recommended",
        "Maintain proper field sanitation",
        "Reduce excessive nitrogen fertilizer",
      ],

      treatmentBn: [
        "অত্যধিক আক্রান্ত গাছ অপসারণ করুন",
        "প্রয়োজনে তামাভিত্তিক ব্যাকটেরিয়ানাশক ব্যবহার করুন",
        "ক্ষেত পরিষ্কার রাখুন",
        "অতিরিক্ত নাইট্রোজেন সার ব্যবহার কমান",
      ],

      preventionEn: [
        "Plant resistant rice varieties",
        "Use disease-free seeds",
        "Ensure proper drainage",
        "Avoid excessive nitrogen application",
      ],

      preventionBn: [
        "রোগ প্রতিরোধী ধানের জাত ব্যবহার করুন",
        "রোগমুক্ত বীজ ব্যবহার করুন",
        "সঠিক পানি নিষ্কাশনের ব্যবস্থা করুন",
        "অতিরিক্ত নাইট্রোজেন সার ব্যবহার এড়িয়ে চলুন",
      ],
    ),

    "Blast": DiseaseInfo(
      name: "Blast",
      scientificName: "Magnaporthe oryzae",

      descriptionEn:
          "Rice blast is one of the most destructive fungal diseases affecting rice plants. It can infect leaves, stems, nodes, and panicles, significantly reducing crop yield.",

      descriptionBn:
          "ব্লাস্ট ধানের একটি অত্যন্ত ক্ষতিকর ছত্রাকজনিত রোগ। এটি পাতা, কাণ্ড, গিট এবং শীষ আক্রান্ত করে ফলন উল্লেখযোগ্যভাবে কমিয়ে দেয়।",

      symptomsEn: [
        "Diamond-shaped lesions",
        "Gray center with brown borders",
        "Drying of leaves",
        "Broken neck of panicle",
      ],

      symptomsBn: [
        "হীরার মতো দাগ",
        "ধূসর কেন্দ্র ও বাদামী কিনারা",
        "পাতা শুকিয়ে যায়",
        "শীষ ভেঙে যায়",
      ],

      causesEn: [
        "Fungal infection",
        "High humidity",
        "Excessive nitrogen fertilizer",
        "Poor field ventilation",
      ],

      causesBn: [
        "ছত্রাকের আক্রমণ",
        "উচ্চ আর্দ্রতা",
        "অতিরিক্ত ইউরিয়া ব্যবহার",
        "বাতাস চলাচল কম",
      ],

      treatmentEn: [
        "Spray Tricyclazole fungicide",
        "Remove infected plants",
        "Maintain proper irrigation",
      ],

      treatmentBn: [
        "ট্রাইসাইক্লাজল ছত্রাকনাশক ব্যবহার করুন",
        "আক্রান্ত গাছ অপসারণ করুন",
        "সঠিক সেচ নিশ্চিত করুন",
      ],

      preventionEn: [
        "Use resistant rice varieties",
        "Avoid excessive nitrogen",
        "Maintain proper spacing",
        "Use healthy seeds",
      ],

      preventionBn: [
        "রোগ প্রতিরোধী জাত ব্যবহার করুন",
        "অতিরিক্ত ইউরিয়া ব্যবহার করবেন না",
        "গাছের মধ্যে যথেষ্ট দূরত্ব রাখুন",
        "স্বাস্থ্যকর বীজ ব্যবহার করুন",
      ],
    ),

    "BrownSpot": DiseaseInfo(
      name: "Brown Spot",
      scientificName: "Bipolaris oryzae",

      descriptionEn:
          "Brown spot is a fungal disease that affects rice leaves, grains, and seedlings. It causes brown lesions on leaves, reducing photosynthesis and crop yield, especially in nutrient-deficient soils.",

      descriptionBn:
          "ব্রাউন স্পট ধানের একটি ছত্রাকজনিত রোগ যা পাতা, শস্য এবং চারা আক্রান্ত করে। এটি পাতায় বাদামী দাগ সৃষ্টি করে, ফলে সালোকসংশ্লেষণ কমে যায় এবং ফলন হ্রাস পায়, বিশেষ করে পুষ্টিহীন মাটিতে।",

      symptomsEn: [
        "Small circular brown spots",
        "Dark brown margins around lesions",
        "Yellowing of leaves",
        "Reduced grain quality",
      ],

      symptomsBn: [
        "পাতায় ছোট গোলাকার বাদামী দাগ",
        "দাগের চারপাশে গাঢ় বাদামী কিনারা",
        "পাতা হলুদ হয়ে যায়",
        "ধানের গুণগত মান কমে যায়",
      ],

      causesEn: [
        "Fungal infection",
        "Nutrient deficiency",
        "High humidity",
        "Poor soil fertility",
      ],

      causesBn: [
        "ছত্রাকের সংক্রমণ",
        "পুষ্টির অভাব",
        "উচ্চ আর্দ্রতা",
        "মাটির উর্বরতা কম হওয়া",
      ],

      treatmentEn: [
        "Apply recommended fungicides",
        "Use balanced fertilizers",
        "Remove infected leaves",
        "Improve field drainage",
      ],

      treatmentBn: [
        "প্রস্তাবিত ছত্রাকনাশক ব্যবহার করুন",
        "সুষম সার প্রয়োগ করুন",
        "আক্রান্ত পাতা অপসারণ করুন",
        "জমিতে সঠিক পানি নিষ্কাশন নিশ্চিত করুন",
      ],

      preventionEn: [
        "Use certified seeds",
        "Maintain balanced soil nutrition",
        "Avoid water stress",
        "Monitor the crop regularly",
      ],

      preventionBn: [
        "উন্নত মানের বীজ ব্যবহার করুন",
        "মাটির পুষ্টি সুষম রাখুন",
        "গাছে পানির ঘাটতি হতে দেবেন না",
        "নিয়মিত ক্ষেত পর্যবেক্ষণ করুন",
      ],
    ),

    "Healthy": DiseaseInfo(
      name: "Healthy",
      scientificName: "Oryza sativa (Healthy Plant)",

      descriptionEn:
          "A healthy rice plant is free from diseases and pests. It has green leaves, strong stems, and grows normally, resulting in high-quality grain production and maximum yield.",

      descriptionBn:
          "একটি সুস্থ ধান গাছ রোগ ও পোকামাকড়মুক্ত থাকে। এর পাতা সবুজ, কাণ্ড শক্তিশালী এবং স্বাভাবিকভাবে বৃদ্ধি পায়, ফলে উন্নত মানের ধান ও সর্বোচ্চ ফলন পাওয়া যায়।",

      symptomsEn: [
        "Bright green leaves",
        "Healthy and strong stem",
        "Normal plant growth",
        "No visible disease spots or lesions",
      ],

      symptomsBn: [
        "উজ্জ্বল সবুজ পাতা",
        "শক্ত ও সুস্থ কাণ্ড",
        "স্বাভাবিক বৃদ্ধি",
        "পাতায় কোনো রোগের দাগ নেই",
      ],

      causesEn: [
        "Proper crop management",
        "Balanced fertilizer application",
        "Adequate irrigation",
        "Good quality seeds",
      ],

      causesBn: [
        "সঠিক ফসল ব্যবস্থাপনা",
        "সুষম সার প্রয়োগ",
        "পর্যাপ্ত সেচ",
        "উন্নত মানের বীজ ব্যবহার",
      ],

      treatmentEn: [
        "No treatment is required",
        "Continue regular monitoring",
        "Maintain proper irrigation",
        "Apply fertilizers as recommended",
      ],

      treatmentBn: [
        "কোনো চিকিৎসার প্রয়োজন নেই",
        "নিয়মিত ক্ষেত পর্যবেক্ষণ করুন",
        "সঠিক সেচ বজায় রাখুন",
        "প্রয়োজন অনুযায়ী সার প্রয়োগ করুন",
      ],

      preventionEn: [
        "Use disease-free certified seeds",
        "Maintain balanced nutrition",
        "Control weeds and pests",
        "Inspect the field regularly",
      ],

      preventionBn: [
        "রোগমুক্ত প্রত্যয়িত বীজ ব্যবহার করুন",
        "মাটির পুষ্টি সুষম রাখুন",
        "আগাছা ও পোকামাকড় নিয়ন্ত্রণ করুন",
        "নিয়মিত ক্ষেত পরিদর্শন করুন",
      ],
    ),

    "Tungro": DiseaseInfo(
      name: "Tungro",
      scientificName: "Rice Tungro Virus (RTV)",

      descriptionEn:
          "Tungro is one of the most damaging viral diseases of rice. It is transmitted by green leafhoppers and causes severe stunting, yellow-orange discoloration of leaves, and significant yield reduction.",

      descriptionBn:
          "টাংগ্রো ধানের একটি মারাত্মক ভাইরাসজনিত রোগ। এটি সবুজ লিফহপার পোকার মাধ্যমে ছড়ায় এবং গাছ খাটো হয়ে যায়, পাতা হলুদ-কমলা রঙ ধারণ করে এবং ফলন উল্লেখযোগ্যভাবে কমে যায়।",

      symptomsEn: [
        "Yellow to orange leaf discoloration",
        "Stunted plant growth",
        "Reduced tillering",
        "Poor grain formation",
      ],

      symptomsBn: [
        "পাতা হলুদ বা কমলা রঙ ধারণ করে",
        "গাছের বৃদ্ধি ব্যাহত হয়",
        "কুশি কম গজায়",
        "ধানের শীষে দানা কম হয়",
      ],

      causesEn: [
        "Rice Tungro Virus infection",
        "Transmission by green leafhopper",
        "Presence of infected plants nearby",
        "Lack of vector control",
      ],

      causesBn: [
        "রাইস টাংগ্রো ভাইরাসের সংক্রমণ",
        "সবুজ লিফহপার পোকার মাধ্যমে বিস্তার",
        "আশেপাশে আক্রান্ত গাছের উপস্থিতি",
        "পোকা নিয়ন্ত্রণের অভাব",
      ],

      treatmentEn: [
        "Remove infected plants immediately",
        "Control green leafhopper populations",
        "Apply recommended insecticides if necessary",
        "Maintain proper field sanitation",
      ],

      treatmentBn: [
        "আক্রান্ত গাছ দ্রুত অপসারণ করুন",
        "সবুজ লিফহপার পোকা নিয়ন্ত্রণ করুন",
        "প্রয়োজনে অনুমোদিত কীটনাশক ব্যবহার করুন",
        "ক্ষেত পরিষ্কার-পরিচ্ছন্ন রাখুন",
      ],

      preventionEn: [
        "Plant resistant rice varieties",
        "Use healthy and certified seeds",
        "Control insect vectors regularly",
        "Monitor fields frequently during the growing season",
      ],

      preventionBn: [
        "রোগ প্রতিরোধী ধানের জাত ব্যবহার করুন",
        "সুস্থ ও প্রত্যয়িত বীজ ব্যবহার করুন",
        "নিয়মিত লিফহপার পোকা নিয়ন্ত্রণ করুন",
        "বর্ধন মৌসুমে নিয়মিত ক্ষেত পর্যবেক্ষণ করুন",
      ],
    ),
  };

  static DiseaseInfo get(String disease) {
    return diseases[disease] ?? diseases["Healthy"]!;
  }
}
