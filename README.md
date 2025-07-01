# AI Avatar Explorer App

A Flutter application that fetches and displays AI-generated human avatars using the RandomUser.me API. Users can browse profiles, search by name, filter by gender and age, view detailed information, and save favorites.

## Features

### Core Features ✅
- **Avatar List**: Displays a list of AI-generated avatars with name, age, gender, and country
- **Search Functionality**: Search avatars by name using the search bar
- **Advanced Filters**: Filter avatars by:
  - Gender: Male/Female/All
  - Age Ranges: 18-30, 31-45, 46+, All
- **Profile Detail Screen**: Tap any profile to view detailed information including:
  - Full personal information
  - Contact details
  - Complete address
  - High-resolution profile picture
- **Loading States**: Shimmer loading effects while fetching data
- **Error Handling**: Graceful handling of API errors and empty states
- **Pull-to-Refresh**: Swipe down to refresh the avatar list
- **Favorites System**: Save/unsave avatars using SharedPreferences
- **Shimmer Loading**: Beautiful shimmer effects during data loading
- **Infinite Scroll**: Load more avatars as you scroll


## Architecture

- **BLoC Pattern**: State management using flutter_bloc
- **Repository Pattern**: Centralized API calls through ApiRepository
- **Model Classes**: Type-safe data models for API responses

### Project Structure

```
lib/
├── main.dart                    # App entry point
├── avtar/
│   ├── bloc/
│   │   ├── avtar_bloc.dart     # Business logic and state management
│   │   ├── avtar_event.dart    # User action events
│   │   └── avtar_state.dart    # Application states
│   └── view/
│       └── home_screen.dart    # Main UI screens
├── data/
│   └── api_repository.dart     # API service layer
├── entity/
│   └── avtar_model.dart        # Data models

## Getting Started

### Prerequisites
- Flutter SDK (latest stable version)
- Dart SDK
- Android Studio / VS Code with Flutter extensions
- Android emulator or physical device

### Installation

1. **Clone the repository**
```bash
git clone <repository-url>
cd avtar_demo
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Run the app**
```bash
flutter run
```

### Build for Release

**Android APK:**
```bash
flutter build apk --release
```

**iOS (on macOS):**
```bash
flutter build ios --release
```

## Usage

### Main Features

1. **Browse Avatars**
   - Launch the app to see a list of 20 random avatars
   - Scroll down to load more avatars automatically

2. **Search**
   - Use the search bar to find avatars by name
   - Search is case-insensitive and searches both first and last names

3. **Filter**
   - Tap the filter icon to open filter options
   - Select gender and age range filters
   - Applied filters show as chips below the search bar

4. **View Details**
   - Tap any avatar card to view detailed information
   - See complete profile including contact and location details

5. **Manage Favorites**
   - Tap the heart icon on any avatar to add/remove from favorites
   - Favorites are saved locally and persist across app restarts

6. **Refresh**
   - Pull down on the list to refresh and get new avatars
   - Use the refresh button in the app bar
