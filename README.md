## Demo Video
Watch the project demo here: https://github.com/user-attachments/assets/1826ef92-58df-47c6-9c00-e0ef8fc9d57b

Group Members:
-   Andrhe Lomocso
-   Kenneth William Sareno
-   Mark Mejia
-   Jericho Valerio
-   Rhenz Ayhon
-   John Mark Depaclayon

# Note Management System (NMS)

A modern, full-stack note-taking application designed for seamless organization and productivity. Built with a **Flutter** frontend and a **Node.js/Express/MongoDB** backend, this app offers a clean, responsive user interface and robust data management.

## 🚀 Features

-   **📝 Smart Note Taking**: Create and edit notes with a distraction-free interface.
-   **💾 Auto-Save**: Never lose your thoughts—notes are saved automatically as you type.
-   **🗂️ Categorization**: Organize your notes into categories to keep everything structured.
-   **🎨 Modern UI**: Enjoy a beautiful Masonry Grid layout (Pinterest-style) with a polished Deep Purple theme and Google Fonts (Poppins).
-   **🗑️ Easy Management**: Delete notes you no longer need with a simple tap.
-   **⚡ Real-time Updates**: Instant interaction with the backend API.

## 🛠️ Tech Stack

### Frontend (Mobile App)
-   **Framework**: [Flutter](https://flutter.dev/)
-   **Language**: Dart
-   **Key Packages**:
    -   `http`: For API communication.
    -   `google_fonts`: For modern typography.
    -   `flutter_staggered_grid_view`: For the masonry layout.

### Backend (API)
-   **Runtime**: [Node.js](https://nodejs.org/)
-   **Framework**: [Express.js](https://expressjs.com/)
-   **Database**: [MongoDB](https://www.mongodb.com/) (with Mongoose ODM)

## 🏁 Getting Started

Follow these steps to set up the project locally.

### Prerequisites
-   [Flutter SDK](https://docs.flutter.dev/get-started/install) installed.
-   [Node.js](https://nodejs.org/) installed.
-   A [MongoDB](https://www.mongodb.com/) database (local or Atlas).

### 1. Backend Setup
Navigate to the server directory and install dependencies:

```bash
cd server
npm install
```

Create a `.env` file in the root `noteapp` directory (or `server` directory depending on config) with your variables:
```env
PORT=5000
MONGO_URI=your_mongodb_connection_string
```

Start the server:
```bash
node server.js
```

### 2. Frontend Setup
Navigate to the root directory and install Flutter dependencies:

```bash
flutter pub get
```

Run the app (ensure your emulator or device is connected):

```bash
flutter run
```

> **Note**: If running on Android Emulator, the app connects to `http://10.0.2.2:5000`. For Windows/Web, it uses `http://localhost:5000`. This is handled in `lib/services/api_service.dart`.

