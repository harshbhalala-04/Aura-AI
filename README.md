# aivo

# Flutter AI Chat App – Setup Guide

## 📦 Installation & Run Steps

### ✅ 1. Create `.env` file in root

```
GEMINI_API_KEY=your_key_here
OPENAI_API_KEY=your_key_here
CLAUDE_API_KEY=your_key_here
```

### ✅ 2. Install Dependencies

```
flutter pub get
```

### ✅ 3. Generate Hive Adapters

```
flutter pub run build_runner build --delete-conflicting-outputs
```

### ✅ 4. Run App

```
flutter run
```
