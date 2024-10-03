# RickAndMorty 

## Overview

RickAndMorty is an iOS app that provides a user-friendly interface to explore characters from the popular TV show "Rick and Morty." This project showcases modern iOS development practices and utilizes various architectural patterns .

## Table of Contents

- [Architecture](#architecture)
- [Design Patterns](#design-patterns)
- [SDKs and Libraries](#sdks-and-libraries)
- [Project Structure](#project-structure)
- [Configuration Management](#configuration-anagement)
- [Features](#features)
- [Unit test](#features)
- [Installation](#unit-test)
- [License](#license)

## Architecture

This app follows  **Uncle Bob's Clean Architecture** principles, promoting a clean separation of concerns and making the codebase more maintainable and testable.
the UI follow **MVVM (Model-View-ViewModel)** design pattern  

- **Model:** Represents the data and business logic.
- **View:** The UI components that display data to the user.
- **ViewModel:** Acts as a bridge between the Model and View, providing data for the View and handling user interactions.

## SDKs and Libraries

The RickAndMorty app utilizes several powerful libraries and frameworks to provide a smooth and efficient user experience:

- **Kingfisher:** For image downloading and caching.
- **Alamofire:** For networking and making API requests.
- **RxSwift:** For reactive programming and handling asynchronous events.
- **netfox:** A lightweight, in-app network debugging tool for monitoring and debugging network requests.
- **GRDB:** A powerful, efficient SQLite toolkit for database management.
- **lottie-ios:** Used to integrate rich animations and make the user experience more dynamic and engaging.
- **SwiftGen:** to automate the generation of code for various resources such as:
    - **Assets** (Images, Colors)
    - **Localizable Strings**
    - **Colors**

## Project Structure

The project is organized to adhere to **Clean Architecture** principles, ensuring a clear separation of concerns and high testability. Each layer has specific responsibilities, making the codebase more maintainable, scalable, and easier to test.

### Layers Overview

- **Domain Layer:** Contains the business logic and is independent of external libraries or frameworks. This layer is at the core and should not depend on any other layers.
- **Data Layer:** Responsible for managing data sources (API, database, etc.) and providing this data to the domain layer.
- **Presentation Layer:** Handles the UI components and user interactions, communicating with the domain layer via ViewModels.
- **Common/Utilities Layer:** Contains shared logic and utilities that can be used across multiple layers.

### Folder Structure

```plaintext
RickAndMorty/
├── Domain
│   ├── Entities
│   ├── UseCases
│   ├── Repositories
├── Data
│   ├── Network
│   │   ├── APIClient
│   │   ├── Services
│   ├── Database
│   ├── Mappers
│   └── Repositories
├── Presentation
│   ├── Sceens
│   │   ├── View
│   │   │   ├── ViewModel
│   │   │   ├── view
│   ├── Components
│   │   ├── View
│   │   │   ├── ViewModel
│   │   │   ├── view
├── Common
│   ├── Utilities
│   ├── Extensions
│   ├── Resources
├── Config
│   └── Config-Development.xcconfig
```

## Configuration Management

The app uses **Config-Development.xcconfig** for managing environment-specific parameters, such as server URLs, API keys, and other configuration settings. 

### Why Use `.xcconfig` Files?

By using `.xcconfig` files, we can:

- **Centralize Configuration:** All environment-specific parameters (like API URLs and keys) are stored in a single place, making it easier to manage different configurations (development, staging, production).
- **Separation of Concerns:** We keep sensitive or environment-specific data out of the codebase, reducing the risk of hard-coding these values directly into the app.
- **Easier Maintenance:** Updating configuration values becomes simpler and can be done independently from the code.
- **Flexibility:** We can easily switch between different configurations by associating `.xcconfig` files with different build schemes (e.g., Development, Production). This allows for seamless environment switching without changing the source code.
- **Better Security:** Sensitive information such as API keys and secrets can be managed outside of source control by excluding the actual config files or adding sensitive values in different `.xcconfig` files (e.g., `Config-Development.xcconfig`, `Config-Production.xcconfig`).

### Example of Parameters in `Config-Development.xcconfig`

```plaintext
// Server URL
SERVER_URL = https:/$()/rickandmortyapi.com/
ROOT_URL = https:/$()/rickandmortyapi.com/


// App Settings
ENVIRONMENT = RickAndMorty
APP_NAME = RickAndMorty
APP_BUNDLE_ID = Adam.TechnicalTask.RickAndMorty
```
## Features

 **Character List:** 
 screen in UIKit with MVVM pattern and Rxswift for bindiing
Display a list of loaded characters, with pagination (load 20 characters at atime).
Each list item should include:
- Name
- Image
- Species
- filtering functionality to allow users to filter the list by character
  status (alive, dead, unknown).
- every status has specific background color
  
 **Character Details:** .
  screen in SwiftUI , a simple view display details of chracter
Provide a detailed view of a selected character, displaying the following
- Name
- Image
- Species
- Status
- Gender

 **Caching Data:**
The app caches character data, allowing users to access previously loaded characters even when the network is down.

 **Animation Loading**
A smooth animation is displayed while data is being loaded, enhancing the user experience.

## Unit test 
The project includes unit tests to ensure code quality and prevent potential regressions.


## Installation

To get started with the RickAndMorty iOS app:

1. **Clone the repository:**
    ```bash
    git clone git@github.com:AhmedibnAdam/RickAndMorty.git
    cd RickAndMorty
    ```

2. **Install dependencies using CocoaPods:**
    ```bash
    pod install
    ```

3. **Open the project in Xcode:**
    ```bash
    open RickAndMorty.xcworkspace
    ```

4. **Build and run the project:**
    - Select the appropriate iOS simulator.
    - Press `Cmd + R` to build and run the app.


### API Integration

The app consumes the [Rick and Morty API](https://rickandmortyapi.com/) to fetch characters


## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
