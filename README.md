# 🔌 Generator Tracker App (Flutter Project)

This is a **Flutter-based mobile application** developed for Continuous Assessment 3 (CA3) of the MSc in Artificial Intelligence - Mobile Application Development module.

The app helps **track generator usage**, fuel information, and provides a report with CSV export and share options. It supports manually adding generators with a photo and location, runtime tracking, and fuel usage logging.

---

## Features

-  Add generator with:
  - Name and Code
  - Initial Runtime and Fuel Capacity
  - Photo (image picker)
  - Location (GPS coordinates)
- View and update generator details
- Track generator:
  - Runtime hours
  - Fuel added and fuel rate
-  Fuel remaining is automatically calculated
- Export report to **CSV**
- Share CSV via email or apps
- Swipe-to-delete generator with confirmation
- Persistent storage using **Hive**
- Clean tabbed UI for Runtime and Fuel entry
- Bottom navigation: Home, Generator List, Report

---

## Screenshots
![App Screenshot](screenshot.png)




---

## Folder Structure
lib/ ├── main.dart ├── models/ │ └── generator.dart ├── screens/ │ ├── add_generator_screen.dart │ ├── generator_list_screen.dart │ ├── generator_details_screen.dart │ ├── report_screen.dart │ ├── home_tabs.dart │ └── info_screen.dart


---

## Packages Used

- [`hive`](https://pub.dev/packages/hive) & [`hive_flutter`](https://pub.dev/packages/hive_flutter) – local database
- [`image_picker`](https://pub.dev/packages/image_picker) – pick generator photo
- [`geolocator`](https://pub.dev/packages/geolocator) – get GPS location
- [`path_provider`](https://pub.dev/packages/path_provider) – storage
- [`csv`](https://pub.dev/packages/csv) – export report to CSV
- [`share_plus`](https://pub.dev/packages/share_plus) – share CSV file

---

## How to Run

1. Clone the repo:
   ```bash
   git clone https://github.com/Rinosa123/generators_tracker.git
2. Navigate to project folder:
   cd generators_tracker
3. Install dependencies
   flutter pub get
4. Run on emulator or real device:
   flutter run

Developed By
Name: Rinosa Shaheed
Course: MSc Artificial Intelligence
Module: Mobile Application Development (CA3)
Supervisor: Dr. Mohamed Azmeer (https://www.azmeer.info)


# Generator Tracker Flutter App

A mobile app built with Flutter that helps users track generator usage, fuel input, runtime, and remaining fuel. The app includes features like location tagging, image upload, CSV export, and role-based management.

## Features

- Add and manage multiple generators
- Upload generator photos using `image_picker`
- Capture generator location using `geolocator`
- Record generator runtime and fuel usage
- View generator reports and export to CSV
- Share reports via email or messaging apps
- Built-in roles (admin/operator - concept only)
- Clean and responsive UI using Material Design
- Persistent storage using Hive

## Technologies Used

- **Flutter**
- **Dart**
- **Hive** (for local storage)
- **image_picker** (for photo upload)
- **geolocator** (for location)
- **csv** and **share_plus** (for exporting and sharing)
- **GitHub** (for version control and collaboration)



