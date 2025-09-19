# PokeAPI-VIPER

A modern iOS Pokémon app built with **VIPER (View-Interactor-Presenter-Entity-Router)** architecture pattern, featuring a clean and scalable codebase with reactive programming using RxSwift.

## 📱 Features

### Core Functionality
- **Pokédex List**: Browse through all Pokémon with pagination support
- **Pokémon Search**: Real-time search functionality to find specific Pokémon
- **Pokémon Details**: Comprehensive detail view with stats, abilities, and descriptions
- **Navigation**: Seamless navigation between Pokémon with previous/next functionality
- **Offline Support**: Local database caching using Realm for offline access

### UI/UX Features
- **Modern Design**: Clean, intuitive interface following Pokémon design guidelines
- **Custom Components**: Reusable UI components (SearchBox, PokemonCardCell, ProgressStats, etc.)
- **Dynamic Theming**: Color-coded Pokémon types with dynamic background themes
- **Image Caching**: Efficient image loading and caching with Nuke
- **Loading States**: Smooth loading indicators throughout the app

### Technical Features
- **VIPER Architecture**: Modular, testable, and scalable architecture
- **Reactive Programming**: RxSwift for reactive data flow
- **Network Layer**: Robust API integration with Moya and Alamofire
- **Local Storage**: Realm database for offline data persistence
- **Debug Tools**: Network debugging with netfox integration

## 🏗️ Architecture

This project follows the **VIPER (View-Interactor-Presenter-Entity-Router)** architecture pattern, which provides:

- **Modular Design**: Each feature is encapsulated in its own VIPER
- **Separation of Concerns**: Clear separation between business logic, presentation, and routing
- **Testability**: Easy to unit test individual components
- **Scalability**: Simple to add new features without affecting existing code

### VIPER Structure
```
AppDelegate/SceneDelegate
├── Pokedex VIPER
├── Pokemon VIPER
```

## 📚 Dependencies

This project uses **Swift Package Manager (SPM)** for dependency management:

| Library | Version | Purpose |
|---------|---------|---------|
| **RxSwift** | 6.9.0 | Reactive programming |
| **RxDataSources** | 5.0.2 | Reactive data sources for collection/table views |
| **Moya** | 15.0.3 | Network abstraction layer |
| **Alamofire** | 5.10.2 | HTTP networking |
| **RealmSwift** | Latest | Local database |
| **Nuke** | 12.8.0 | Image loading and caching |
| **SnapKit** | 5.7.1 | Auto Layout DSL |
| **MBProgressHUD** | 1.2.0 | Loading indicators |
| **netfox** | 1.21.0 | Network debugging |

## 🚀 Installation & Setup

### Prerequisites
- Xcode 14.0 or later
- iOS 13.0 or later
- Swift 5.0 or later

### Setup Instructions
1. **Clone the repository**
   ```bash
   git clone https://github.com/alifu/PokeAPI-VIPER.git
   cd PokeAPI-VIPER
   ```

2. **Open the project**
   ```bash
   open PokeAPI-VIPER.xcodeproj
   ```

3. **Build and run**
   - Select your target device or simulator
   - Press `Cmd + R` to build and run the project

### Dependencies
All dependencies are managed through Swift Package Manager and will be automatically resolved when you build the project.

## 🎨 Design

The UI design is based on the [Pokédex Community Figma design](https://www.figma.com/design/ZNuMRRQvD6yoOaJWRUYzk2/Pok%C3%A9dex--Community-?node-id=913-239&t=vrCYCG8zKjWgmkJP-1), featuring:
- Modern card-based layout
- Pokémon type color theming
- Intuitive navigation patterns
- Responsive design for different screen sizes

## 📁 Project Structure

```
PokeAPI-VIPER/
├── Module/                    # VIPER modules
│   ├── Pokedex/              # Main Pokédex VIPER
│   └── Pokemon/              # Pokémon detail VIPER
├── Helper/                   # Utility classes
├── ReuseableView/            # Custom UI components
├── Extension/                # Swift extensions
├── Utils/                    # Utility functions
└── Realm/                    # Database models and services
```

## 🔄 API Integration

The app integrates with the [PokéAPI](https://pokeapi.co/) to fetch:
- Pokémon list with pagination
- Individual Pokémon details
- Pokémon species information
- Official artwork and sprites

## 🛠️ Development Status

### ✅ Completed Features
- [x] VIPER architecture implementation
- [x] Dependency management with SPM
- [x] Local database with Realm
- [x] Pokémon list with pagination
- [x] Real-time search functionality
- [x] Detailed Pokémon view
- [x] Previous/next navigation
- [x] Image caching and loading
- [x] Custom UI components
- [x] Network debugging tools

### 📋 TODO
- [ ] Pokémon sorting functionality
- [ ] Poppins font integration
- [ ] iOS Widget support
- [ ] Unit Test

## 💼 Portfolio

This project is part of my iOS development portfolio, showcasing:

- **Advanced Architecture Patterns**: Implementation of **VIPER (View-Interactor-Presenter-Entity-Router)** architecture
- **Reactive Programming**: Extensive use of RxSwift for reactive data flow and UI binding
- **Modern iOS Development**: Swift 5.0+, iOS 13.0+ support with latest best practices
- **API Integration**: Robust networking layer with Moya and Alamofire
- **Local Data Persistence**: Realm database implementation for offline functionality
- **Custom UI Components**: Reusable, well-designed UI components with SnapKit
- **Image Caching**: Efficient image loading and caching strategies
- **Clean Code**: Well-structured, modular, and maintainable codebase

### Key Technical Achievements
- ✅ Modular VIPER architecture with clear separation of concerns
- ✅ Reactive programming implementation with RxSwift
- ✅ Comprehensive API integration with error handling
- ✅ Local database implementation with Realm
- ✅ Custom UI components and theming system
- ✅ Image caching and optimization
- ✅ Search and pagination functionality
- ✅ Navigation flow management



## 🙏 Acknowledgments

- [PokéAPI](https://pokeapi.co/) for providing the comprehensive Pokémon data
- [VIPER](https://www.kodeco.com/8440907-getting-started-with-the-viper-architecture-pattern) for the excellent architecture (Article from kodeco)
- [VIPER Template](https://github.com/alifu/XCode_Templates) for VIPER Template
- [Figma Community](https://www.figma.com/design/ZNuMRRQvD6yoOaJWRUYzk2/Pok%C3%A9dex--Community-?node-id=913-239&t=vrCYCG8zKjWgmkJP-1) for the beautiful design inspiration