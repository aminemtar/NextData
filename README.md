# Android/Flutter Test App

> Hybrid Flutter application with native Android integration using MVVM architecture.

---

## 🚀 Overview

This project demonstrates a hybrid mobile application developed using:

- **Flutter 3.29.3 (Stable channel)**
- **Dart 3.7.2**
- **MVVM architecture**
- **Native Android interop (Kotlin)**
- **Integration with platform-specific features**

---

## 📁 Project Structure

```bash
.
├── android/                         # Native Android (Kotlin)
│   ├── app/
│   │   └── src/main/
│   │       └── kotlin/
│   │           └── com/example/android_flutter_test/
│   │               ├── AppDataBase.kt    # Room database configuration
│   │               ├── AuthHandler.kt    # Authentication logic
│   │               ├── DataBaseHandler.kt # Database operations
│   │               ├── PostDao.kt        # Post Data Access Object
│   │               ├── PostEntity.kt     # Post entity/model
│   │               └── MainActivity.kt   # Entry point with Flutter integration
├── lib/                             # Flutter app
│   ├── models/                      # MVVM - Model layer
│   ├── viewmodels/                  # MVVM - ViewModel layer
│   ├── views/                       # MVVM - View (UI) layer
│   ├── services/                    # Service layer (Business Logic / API calls)
│   ├── data/                        # Data layer (Repositories, Data Sources)
│   └── main.dart                    # Entry point
├── pubspec.yaml                     # Dependencies configuration
└── README.md                        # Project documentation



🧱 Architecture: MVVM
This app follows the Model-View-ViewModel pattern:

models/: Data classes representing app data

viewmodels/: Business logic and state management

views/: UI components subscribing to view models

You can use Provider or ChangeNotifier to implement reactive ViewModels.

| Layer        | Technology                   |
|--------------|------------------------------|
| UI           | Flutter                      |
| State Mgmt   | ViewModel pattern (MVVM)     |
| Native Code  | Kotlin (Android Integration) |
| Tools        | DevTools 2.42.3              |

✅ Prerequisites
Flutter SDK: 3.29.3

Dart SDK: 3.7.2

Android Studio or VSCode with Flutter plugin


## 🚀 Installation  
```
1. Clone the repository:  
git clone https://github.com/aminemtar/NextData.git

2. Open the project in VS Code or Android Studio.

3. Select an Android device to run the application on:
   - In VS Code, click on the **Device** dropdown in the bottom-left corner and select an Android device from the list.
   - In Android Studio, select a device from the device selector in the top-right corner.

4. Install dependencies:
flutter pub get

4. Run the application:
flutter run
```