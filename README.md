# DearDiary - Offline First Diary App

A diary application built with Flutter using an offline-first architecture.

## Features

- Create, update and delete diary entries
- Offline-first data storage using Hive
- Synchronization between local database and remote API
- Search diary entries
- Sort entries by date
- JWT authentication with refresh token

## Tech Stack

### Frontend
- Flutter
- Dart
- Provider (State Management)
- Hive (Local Database)

### Backend
- ASP.NET Core Web API
- SQL Server
- JWT Authentication

## Architecture

Clean Architecture

presentation  
domain  
data  

## Important Note

The Flutter app currently calls a **local API**.  
You must run the **ASP.NET Core backend API first** before running the Flutter application.

## Getting Started

### 1. Run the backend API

dotnet run
the api will start on http://localhost:5089

### 2.Run the Flutter App

Navigate to the Flutter project folder and run:
flutter pub get
flutter run
or
flutter run -d web-server 

<img src="screenshots/home.png" width="250"/>
<img src="screenshots/write.png" width="250"/>
<img src="screenshots/login.png" width="250"/>

