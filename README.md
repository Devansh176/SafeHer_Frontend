# 🛡️ SafeHer - Women's Safety App

**SafeHer** is a mobile application designed to enhance women’s safety with real-time emergency response features, including live location sharing, emergency calls, and intelligent route monitoring.

---

## 📱 Features

- 🚨 One-tap emergency alert system
- 📍 Real-time location tracking
- 📤 Instant location sharing via SMS
- 📞 Emergency call quick-dial
- 👥 Contact selection for calls and location sharing
- 🔐 Secure login with Firebase Authentication
- 🗃️ User and contact data stored in PostgreSQL via Spring Boot
- 📦 Offline support and persistent contact storage

---

## 🧰 Tech Stack

| Layer       | Technology                            |
|-------------|----------------------------------------|
| Frontend    | Flutter (Dart), BLoC pattern           |
| Backend     | Spring Boot (Java), RESTful APIs       |
| Auth        | Firebase Authentication                |
| Database    | PostgreSQL                             |
| DevOps      | Docker (planned), Git, GitHub          |
| Deployment  | Android APK (manual), Firebase Hosting (future)

---

## 🛠️ Setup Instructions

### 🔧 Backend (Spring Boot)

1. Clone the backend repo:
   ```bash
   git clone https://github.com/your-username/safeher-backend.git
   cd safeher-backend
Configure application.properties with:

Firebase credentials

PostgreSQL connection details

Build and run:

bash
Copy
Edit
./mvnw spring-boot:run
📱 Frontend (Flutter)
Clone the frontend:

bash
Copy
Edit
git clone https://github.com/your-username/safeher-app.git
cd safeher-app
Install dependencies:

bash
Copy
Edit
flutter pub get
Run the app:

bash
Copy
Edit
flutter run
🧪 Testing
Unit tests are written for BLoC and repository layers.

Integration tests for emergency features and contact handling.

📌 Future Enhancements
Dockerized backend deployment

Push notifications for alerts

Admin dashboard for monitoring

AI-based unsafe zone prediction using crime data

Multi-language support

🤝 Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss your ideas.
