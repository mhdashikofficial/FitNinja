# FitNinja 🥷⚡

**AI-Powered Fitness & Martial Arts Mastery**

A professional-grade dual-hemisphere training system built with Flutter, featuring AI-generated workout plans, real-time ML boxing pose detection, and a 50+ module tactical encyclopedia.

## 🌐 Website
[fitninja.vercel.app](https://fitninja.vercel.app)

## ✨ Features

### 🤖 AI Training Engine
- Daily personalized workout plans powered by **Llama 3.1 70B** via NVIDIA API
- AI-powered macro/nutrition tracking — describe meals in plain text
- Adaptive scheduling based on body metrics and available equipment

### 🥊 Boxing System
- **Real-time ML pose detection** using Google ML Kit
- Punch counter, speed metrics, and form analysis
- Professional boxing tutorials (Jab, Cross, Hook, Uppercut, Shovel Hook, Overhand)
- Advanced defense systems (Slip, Shoulder Roll, Parry, Bob & Weave)

### 🥷 Ninjutsu Mastery (Password-Protected)
- **50+ tactical modules** adapted for modern urban environments
- Urban Stealth, Tactical Agility, Operator Breathwork, Mind Hack (Modern Genjutsu)
- Progressive rank system: Initiate → Operative → Specialist → Shinobi Ghost
- Ethical safeguard warnings on psychological technique modules

### 📊 Dashboard & Tracking
- Netflix-style horizontal category browser
- Daily macro tracking with meal logging
- Workout completion tracking with visual progress indicators

## 🛠 Tech Stack

| Component | Technology |
|-----------|-----------|
| Mobile App | Flutter (Dart) |
| AI Engine | NVIDIA API / Llama 3.1 70B |
| Database | MongoDB Atlas |
| ML Pose Detection | Google ML Kit |
| Backend | Python / Flask |
| Website | Next.js + Three.js |
| Hosting | Vercel |

## 🚀 Setup

### Prerequisites
- Flutter SDK 3.x
- Dart SDK
- Android Studio / VS Code
- MongoDB Atlas account
- NVIDIA API key

### Environment Variables

Create a `.env` file in `backend/` (see `.env.example`):

```env
MONGO_URI=your-mongodb-uri
NVIDIA_API_KEY=your-nvidia-api-key
MAIL_USERNAME=your-email
MAIL_PASSWORD=your-app-password
JWT_SECRET=your-secret
```

For the Flutter app, pass environment variables during build:

```bash
flutter build apk --dart-define=NVIDIA_API_KEY=your-key --dart-define=MONGO_URI=your-uri --dart-define=MAIL_USERNAME=your-email --dart-define=MAIL_PASSWORD=your-password
```

### Running Locally

```bash
# Flutter app
cd fitninja
flutter pub get
flutter run

# Website
cd website
npm install
npm run dev

# Backend
cd backend
pip install -r requirements.txt
flask run
```

## 📁 Project Structure

```
FitNinja/
├── fitninja/          # Flutter mobile app
│   ├── lib/
│   │   ├── models/    # Data models & tutorial database
│   │   ├── screens/   # UI screens (auth, onboarding, main)
│   │   └── services/  # AI, DB, Mail services
│   └── assets/        # Images, animations, tutorial masters
├── backend/           # Python Flask API
│   ├── routes/        # API endpoints
│   └── utils/         # Utility functions
├── website/           # Next.js 3D landing page
│   └── src/app/       # Pages & components
└── frontend/          # Expo mobile companion (legacy)
```

## 👨‍💻 Developer

**Ashik** — [@byyyy.ash](https://instagram.com/byyyy.ash)

## 📄 License

This project is for educational and personal use.
