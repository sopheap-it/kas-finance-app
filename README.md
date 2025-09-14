# KAS Finance - Personal Finance Management App

A modern, cross-platform personal finance management application built with Flutter and Firebase. KAS Finance helps users track expenses, manage budgets, and gain insights into their financial habits with a beautiful, intuitive interface.

## 🚀 Features

### Core Features
- **User Authentication**: Email/password, Google, Apple ID, and biometric authentication
- **Expense & Income Tracking**: Manual entry with receipt scanning capabilities
- **Budget Management**: Create, monitor, and track budgets with predictive suggestions
- **Financial Reports**: Interactive charts, trends, and exportable reports
- **Multi-Currency Support**: 45+ currencies with real-time exchange rates
- **Debt & Bill Management**: Track debts and recurring bills with reminders
- **Cloud Sync**: Seamless data synchronization across devices
- **Offline Mode**: Full functionality without internet connection
- **Guest Mode**: Explore the app without creating an account

### Technical Features
- **Professional Architecture**: Clean, scalable code structure
- **Modern UI/UX**: Material 3 design with light/dark themes
- **Performance Optimized**: Efficient data handling and smooth animations
- **Cross-Platform**: iOS, Android, Web, and Desktop support
- **Type-Safe Database**: Drift for local SQLite operations
- **State Management**: Provider pattern with professional structure
- **Flavors**: Separate development, staging, and production environments

## 📱 Screenshots

*Coming soon - Screenshots will be added after UI implementation*

## 🏗️ Project Structure

```
kas_finance_app/
├── lib/
│   ├── app/                          # App-level configuration
│   │   ├── theme/                    # Theme configuration
│   │   │   ├── app_theme.dart        # Main theme setup
│   │   │   ├── color_theme.dart      # Color scheme definitions
│   │   │   └── text_theme.dart       # Typography system
│   │   └── widgets/                  # Global reusable widgets
│   │       ├── custom_form_field.dart
│   │       ├── primary_button.dart
│   │       ├── secondary_button.dart
│   │       └── index.dart            # Widget exports
│   │
│   ├── core/                         # Core utilities and widgets
│   │   ├── database/                 # Database configuration
│   │   │   ├── app_database.dart     # Main database class
│   │   │   └── tables/               # Database table definitions
│   │   │       ├── user_table.dart
│   │   │       ├── transaction_table.dart
│   │   │       ├── category_table.dart
│   │   │       └── budget_table.dart
│   │   ├── extensions/               # Dart extensions
│   │   │   ├── context_extensions.dart
│   │   │   ├── string_extensions.dart
│   │   │   └── date_extensions.dart
│   │   ├── utils/                    # Utility classes
│   │   │   ├── constants.dart        # App constants
│   │   │   ├── validators.dart       # Form validators
│   │   │   └── formatters.dart       # Data formatters
│   │   ├── widgets/                  # Core widgets
│   │   │   ├── app_dialog.dart       # Easy-to-use dialogs
│   │   │   ├── app_button.dart       # Consistent buttons
│   │   │   └── app_bottom_sheet.dart # Bottom sheet widgets
│   │   └── core.dart                 # Core exports
│   │
│   ├── models/                       # Data models
│   │   ├── user_model.dart
│   │   ├── transaction_model.dart
│   │   ├── budget_model.dart
│   │   └── category_model.dart
│   │
│   ├── providers/                    # State management
│   │   ├── auth_provider.dart        # Authentication state
│   │   ├── transaction_provider.dart # Transaction state
│   │   ├── budget_provider.dart      # Budget state
│   │   └── theme_provider.dart       # Theme state
│   │
│   ├── screens/                      # UI screens
│   │   ├── auth/                     # Authentication screens
│   │   │   ├── login_screen.dart
│   │   │   └── signup_screen.dart
│   │   ├── home/                     # Main app screens
│   │   │   ├── main_screen.dart      # Bottom navigation
│   │   │   ├── dashboard_screen.dart
│   │   │   ├── transactions_screen.dart
│   │   │   ├── budgets_screen.dart
│   │   │   ├── reports_screen.dart
│   │   │   └── settings_screen.dart
│   │   └── splash_screen.dart
│   │
│   ├── services/                     # Business logic services
│   │   ├── database_service.dart     # Database operations
│   │   └── notification_service.dart # Push notifications
│   │
│   ├── flavors.dart                  # Environment configuration
│   ├── main.dart                     # Default entry point
│   ├── main_development.dart         # Development entry point
│   ├── main_staging.dart             # Staging entry point
│   └── main_production.dart          # Production entry point
│
├── assets/                           # Static assets
│   ├── images/                       # App images
│   ├── icons/                        # Custom icons
│   └── animations/                   # Lottie animations
│
├── flutter_launcher_icons.yaml      # Icon configuration
├── flutter_native_splash.yaml       # Splash screen configuration
└── pubspec.yaml                      # Dependencies
```

## 🛠️ Getting Started

### Prerequisites

- Flutter SDK (3.22.0 or later)
- Dart SDK (3.4.0 or later)
- Firebase project setup
- Android Studio / VS Code
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-username/kas_finance_app.git
   cd kas_finance_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code**
   ```bash
   # Generate database code
   flutter packages pub run build_runner build
   
   # Generate launcher icons
   dart run flutter_launcher_icons:main
   
   # Generate splash screen
   dart run flutter_native_splash:create
   ```

4. **Firebase Setup**
   ```bash
   # Install Firebase CLI
   npm install -g firebase-tools
   
   # Login to Firebase
   firebase login
   
   # Install FlutterFire CLI
   dart pub global activate flutterfire_cli
   
   # Configure Firebase
   flutterfire configure
   ```

5. **Run the app**
   ```bash
   # Development
   flutter run -t lib/main_development.dart
   
   # Staging
   flutter run -t lib/main_staging.dart
   
   # Production
   flutter run -t lib/main_production.dart
   ```

## 🏃‍♂️ Running the App

### Development Environment
```bash
flutter run -t lib/main_development.dart --flavor development
```

### Staging Environment
```bash
flutter run -t lib/main_staging.dart --flavor staging
```

### Production Environment
```bash
flutter run -t lib/main_production.dart --flavor production
```

### Building for Release
```bash
# Android
flutter build appbundle -t lib/main_production.dart --flavor production

# iOS
flutter build ipa -t lib/main_production.dart --flavor production

# Web
flutter build web -t lib/main_production.dart
```

## 🎨 Design System

### Colors
- **Primary**: #6366F1 (Indigo)
- **Secondary**: #8B5CF6 (Purple)
- **Success**: #10B981 (Green)
- **Warning**: #F59E0B (Orange)
- **Error**: #EF4444 (Red)

### Typography
- **Font Family**: Inter (via Google Fonts)
- **Scales**: Display, Headline, Title, Body, Label
- **Weights**: 300 (Light), 400 (Regular), 500 (Medium), 600 (Semi-bold), 700 (Bold)

### Components
- **Buttons**: Primary, Secondary, Text variants
- **Forms**: Consistent input fields with validation
- **Cards**: Elevated with rounded corners
- **Dialogs**: Modal dialogs with easy API
- **Bottom Sheets**: Configurable bottom sheets

## 🗄️ Database Schema

### Users Table
- `id` (String, Primary Key)
- `email` (String)
- `displayName` (String, Nullable)
- `photoUrl` (String, Nullable)
- `isEmailVerified` (Boolean)
- `currency` (String, Default: 'USD')
- `createdAt` (DateTime)
- `updatedAt` (DateTime, Nullable)
- `lastLoginAt` (DateTime, Nullable)

### Transactions Table
- `id` (String, Primary Key)
- `userId` (String, Foreign Key)
- `amount` (Double)
- `title` (String)
- `description` (String, Nullable)
- `categoryId` (String, Foreign Key)
- `type` (String) // 'income' or 'expense'
- `date` (DateTime)
- `currency` (String, Default: 'USD')
- `receiptImageUrl` (String, Nullable)
- `createdAt` (DateTime)
- `updatedAt` (DateTime, Nullable)

### Categories Table
- `id` (String, Primary Key)
- `name` (String)
- `iconName` (String)
- `color` (Integer)
- `type` (String) // 'income' or 'expense'
- `isDefault` (Boolean, Default: false)
- `isActive` (Boolean, Default: true)
- `createdAt` (DateTime)
- `updatedAt` (DateTime, Nullable)

### Budgets Table
- `id` (String, Primary Key)
- `userId` (String, Foreign Key)
- `name` (String)
- `description` (String, Nullable)
- `amount` (Double)
- `spent` (Double, Default: 0.0)
- `categoryId` (String, Nullable) // null means overall budget
- `startDate` (DateTime)
- `endDate` (DateTime)
- `currency` (String, Default: 'USD')
- `isActive` (Boolean, Default: true)
- `createdAt` (DateTime)
- `updatedAt` (DateTime, Nullable)

## 🔧 Configuration

### Environment Variables
Create environment-specific configurations in `lib/flavors.dart`:

```dart
// Development
static const FlavorValues development = FlavorValues(
  baseUrl: 'https://dev-api.kasfinance.com',
  appName: 'KAS Finance Dev',
  packageName: 'com.kasfinance.app.dev',
  showDebugBanner: true,
  enableLogging: true,
  enableAnalytics: false,
  enableCrashReporting: false,
);
```

### Firebase Configuration
Update `firebase_options.dart` with your Firebase project settings.

### App Icons & Splash Screen
Configure in `flutter_launcher_icons.yaml` and `flutter_native_splash.yaml`.

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Generate coverage report
genhtml coverage/lcov.info -o coverage/html
```

## 📚 Key Libraries

### Core Dependencies
- **flutter**: UI framework
- **firebase_core**: Firebase initialization
- **firebase_auth**: Authentication
- **cloud_firestore**: Cloud database
- **provider**: State management
- **drift**: Local database ORM

### UI & Styling
- **google_fonts**: Typography
- **fl_chart**: Charts and graphs
- **lottie**: Animations
- **flutter_svg**: SVG support

### Utilities
- **intl**: Internationalization
- **uuid**: Unique identifiers
- **path_provider**: File system access
- **shared_preferences**: Simple persistence

### Development
- **flutter_lints**: Linting rules
- **build_runner**: Code generation
- **drift_dev**: Database code generation

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Code Style
- Follow Flutter/Dart style guidelines
- Use meaningful variable and function names
- Write clear comments for complex logic
- Maintain consistent formatting
- Add tests for new features

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🆘 Support

If you encounter any issues or have questions:

1. Check the [Issues](https://github.com/your-username/kas_finance_app/issues) page
2. Create a new issue if your problem isn't already reported
3. Provide detailed information about your environment and the problem

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Firebase team for backend services
- Material Design team for design guidelines
- Contributors and testers

## 🗺️ Roadmap

### Phase 1: Core Features ✅
- [x] User authentication
- [x] Basic transaction tracking
- [x] Budget management
- [x] Local database setup
- [x] Theme system

### Phase 2: Enhanced Features 🚧
- [ ] Receipt scanning with OCR
- [ ] Advanced analytics
- [ ] Data export/import
- [ ] Backup and restore
- [ ] Multi-account support

### Phase 3: Advanced Features 📋
- [ ] Investment tracking
- [ ] Bill payment integration
- [ ] Financial goals
- [ ] AI-powered insights
- [ ] Widget support

---

**KAS Finance** - Making personal finance management simple and beautiful.