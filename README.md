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

### Bonus Features ✅
- **Favorites System**: Save/unsave avatars using SharedPreferences
- **Shimmer Loading**: Beautiful shimmer effects during data loading
- **Infinite Scroll**: Load more avatars as you scroll
- **Modern UI**: Clean and intuitive user interface
- **Responsive Design**: Works on different screen sizes

## Architecture

The app follows clean architecture principles using:

- **BLoC Pattern**: State management using flutter_bloc
- **Repository Pattern**: Centralized API calls through ApiRepository
- **Model Classes**: Type-safe data models for API responses
- **Event-Driven**: User interactions trigger events handled by BLoC

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
└── widgets/
    └── search_widget.dart      # Reusable UI components
```

## Dependencies

### Core Dependencies
- **flutter_bloc**: ^9.1.1 - State management
- **http**: ^1.4.0 - HTTP requests
- **cached_network_image**: ^3.4.1 - Image caching
- **equatable**: ^2.0.7 - Value equality

### Bonus Dependencies
- **shared_preferences**: ^2.5.3 - Local storage for favorites
- **shimmer**: ^3.0.0 - Loading animations

## API Integration

The app uses the [RandomUser.me API](https://randomuser.me/) to fetch avatar data:

- **Base URL**: `https://randomuser.me/api/`
- **Parameters**: 
  - `results`: Number of avatars to fetch (default: 20)
  - `page`: Page number for pagination
  - `gender`: Filter by gender (male/female)
- **Response**: JSON with user profiles including personal info, photos, and location data

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

### Error Handling

The app gracefully handles various error scenarios:
- **Network errors**: Shows retry option
- **Empty results**: Displays "No avatars found" message
- **API failures**: User-friendly error messages
- **Image loading failures**: Fallback to placeholder icons

## Testing

Run the test suite:
```bash
flutter test
```

## Performance Optimizations

- **Image Caching**: Network images are cached for offline viewing
- **Lazy Loading**: Avatars load as you scroll (pagination)
- **Efficient Filtering**: Client-side filtering for better performance
- **Shimmer Loading**: Provides smooth loading experience
- **Memory Management**: Proper disposal of controllers and listeners

## Future Enhancements

Potential improvements for future versions:
- Dark mode toggle
- Advanced search filters (by location, age range slider)
- Offline support with local database
- Avatar comparison feature
- Social sharing functionality
- Custom avatar categories
- Analytics and usage tracking

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- [RandomUser.me](https://randomuser.me/) for providing the avatar API
- Flutter team for the excellent framework
- BLoC library maintainers for state management solution

---

**Estimated Development Time**: 3-4 hours
**Status**: ✅ Complete with all required and bonus features implemented
