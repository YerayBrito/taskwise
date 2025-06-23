# TaskWise - Advanced Task Manager

[![DeepWiki](https://deepwiki.com/badge.svg)](https://deepwiki.com/YerayBrito/taskwise)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)
[![Contributors](https://img.shields.io/github/contributors/YerayBrito/taskwise?style=flat-square)](https://github.com/YerayBrito/taskwise/graphs/contributors)
[![Last Commit](https://img.shields.io/github/last-commit/YerayBrito/taskwise)](https://github.com/YerayBrito/taskwise/commits/develop)
[![Open Issues](https://img.shields.io/github/issues/YerayBrito/taskwise?style=flat-square)](https://github.com/YerayBrito/taskwise/issues)


TaskWise is a mobile application developed in Flutter that allows efficient task management with advanced features and a reusable component architecture.

## 🚀 Main Features

### Basic Features
- ✅ Create, edit and delete tasks
- ✅ Mark tasks as completed
- ✅ Task categorization
- ✅ Due dates
- ✅ Data persistence with SQLite

### Advanced Features
- 🎯 **Priority System**: High, Medium, Low
- 🏷️ **Tag System**: Add multiple tags to tasks
- 🔍 **Advanced Search**: Search by title, description, category or tags
- 📊 **Dashboard with Statistics**: Overview with metrics and summaries
- 📅 **Date Filters**: Today, tomorrow, this week, overdue
- 🎨 **Advanced Filters**: By status, category, priority and date
- 📈 **Sorting**: By due date, priority, title or creation date
- 📱 **Intuitive Navigation**: Bottom navigation between screens

## 🏗️ Architecture and Reusable Components

### Project Structure
```
lib/
├── main.dart                 # Application entry point
├── models/
│   └── task.dart            # Task data model
├── providers/
│   └── task_provider.dart   # State management with Provider
├── database/
│   └── database_helper.dart # SQLite database access
├── screens/
│   ├── task_list_screen.dart    # Main task list
│   ├── task_edit_screen.dart    # Create/edit tasks
│   └── dashboard_screen.dart    # Dashboard with statistics
└── widgets/
    ├── custom_form_fields.dart  # Reusable form components
    ├── custom_cards.dart        # Reusable cards and containers
    ├── custom_buttons.dart      # Custom reusable buttons
    └── filter_widgets.dart      # Reusable filter components
```

## 🛠️ Technologies Used

- **Flutter**: Mobile development framework
- **Provider**: State management
- **SQLite**: Local database
- **Material Design**: Design system
- **Dart**: Programming language

## 📱 Application Screens

### 1. Task Screen
- Task list with advanced filters
- Real-time search
- Quick actions (edit, delete, complete)
- Detailed task view

### 2. Dashboard Screen
- General statistics
- Summary by priorities
- Overdue and today's tasks
- Recent activity
- Quick actions

### 3. Edit Screen
- Complete form with validation
- Visual priority selector
- Tag management
- Task information

## 🎨 Design Features

- **Material Design 3**: Modern and accessible design
- **Custom Theme**: Consistent colors and styles
- **Responsive**: Adaptable to different screen sizes
- **Animations**: Smooth transitions and visual feedback
- **Accessibility**: Screen reader support

## 🚀 Installation and Usage

### Prerequisites
- Flutter SDK (version 3.0.0 or higher)
- Dart SDK
- Android Studio / VS Code
- Xcode (for iOS development - macOS only)
- CocoaPods (for iOS dependencies)

### Installation Steps

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd taskwise
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the application**
   ```bash
   flutter run
   ```

## 📱 Running on Simulators

### 🍎 iOS Simulator

#### Prerequisites
- macOS
- Xcode (install from App Store)
- CocoaPods

#### Steps to Run

1. **Install CocoaPods**
   ```bash
   sudo gem install cocoapods
   ```

2. **Install iOS dependencies**
   ```bash
   cd ios
   pod install
   cd ..
   ```

3. **Open iOS simulator**
   ```bash
   open -a Simulator
   ```

4. **Run the application**
   ```bash
   flutter run -d ios
   ```

### 🤖 Android Simulator

#### Prerequisites
- Android Studio
- Android SDK
- Virtual device (AVD)

#### Steps to Run

1. **Create virtual device**
   - Open Android Studio
   - Tools > AVD Manager > Create Virtual Device
   - Select Pixel 7 with API 34

2. **Start emulator**
   ```bash
   flutter emulators --launch Pixel_7_API_34
   ```

3. **Run the application**
   ```bash
   flutter run -d android
   ```

### 🔧 Useful Commands

```bash
# View available devices
flutter devices

# Hot reload (after starting)
# Press 'r' in terminal

# Hot restart
# Press 'R' in terminal

# Exit
# Press 'q' in terminal

# Clean build
flutter clean && flutter pub get
```

### Main Dependencies
```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.0.5      # State management
  sqflite: ^2.3.0       # SQLite database
  path_provider: ^2.1.1 # Path management
  intl: ^0.18.1         # Internationalization
```

## 📊 Technical Features

### State Management
- **Provider Pattern**: Centralized state management
- **ChangeNotifier**: Change notifications
- **Async Operations**: Asynchronous database operations

### Database
- **SQLite**: Persistent local database
- **Migrations**: Migration system for updates
- **CRUD Operations**: Complete database operations

### Filters and Search
- **Combined Filters**: Multiple filters applied simultaneously
- **Semantic Search**: Search across multiple fields
- **Dynamic Sorting**: Sorting by different criteria

---

**TaskWise** - Organize your life, one task at a time. 🚀 
