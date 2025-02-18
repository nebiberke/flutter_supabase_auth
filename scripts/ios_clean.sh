#!/bin/bash

# Flutter clean
echo "Running flutter clean..."
flutter clean

# Remove pubspec.lock
echo "Removing pubspec.lock..."
rm -f pubspec.lock

# Navigate to iOS folder
echo "Navigating to iOS directory..."
cd ios || { echo "iOS directory not found! Exiting."; exit 1; }

# Remove Pods and Podfile.lock
echo "Removing Pods and Podfile.lock..."
rm -rf Pods
rm -f Podfile.lock

# Pod deintegrate
echo "Running pod deintegrate..."
pod deintegrate

# Navigate back to project root
echo "Navigating back to project root..."
cd ..

# Flutter pub get
echo "Running flutter pub get..."
flutter pub get

# Navigate back to iOS folder
echo "Navigating to iOS directory..."
cd ios || { echo "iOS directory not found! Exiting."; exit 1; }

# Pod setup and install
echo "Running pod setup and pod install..."
pod setup
pod install

# Navigate back to project root
echo "Navigating back to project root..."
cd ..

echo "Flutter clean process completed successfully!"
