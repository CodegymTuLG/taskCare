#!/bin/bash

# iOS Build Script
# Run this on macOS with Xcode installed

set -e  # Exit on error

echo "🚀 Starting iOS build process..."
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo -e "${RED}❌ Error: iOS builds require macOS${NC}"
    echo "Please run this script on a Mac"
    exit 1
fi

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo -e "${RED}❌ Error: Flutter not found${NC}"
    echo "Please install Flutter: https://flutter.dev/docs/get-started/install"
    exit 1
fi

# Check if Xcode is installed
if ! command -v xcodebuild &> /dev/null; then
    echo -e "${RED}❌ Error: Xcode not found${NC}"
    echo "Please install Xcode from App Store"
    exit 1
fi

# Check if CocoaPods is installed
if ! command -v pod &> /dev/null; then
    echo -e "${YELLOW}⚠️  CocoaPods not found. Installing...${NC}"
    sudo gem install cocoapods
    pod setup
fi

echo -e "${GREEN}✅ All prerequisites installed${NC}"
echo ""

# Step 1: Clean previous builds
echo "🧹 Cleaning previous builds..."
flutter clean
rm -rf ios/Pods
rm -rf ios/Podfile.lock

# Step 2: Get Flutter dependencies
echo "📦 Getting Flutter dependencies..."
flutter pub get

# Step 3: Install iOS dependencies
echo "📱 Installing iOS dependencies (CocoaPods)..."
cd ios
pod install
cd ..

# Step 4: Check for connected devices
echo ""
echo "📱 Checking for connected devices..."
flutter devices

echo ""
echo -e "${YELLOW}Select build option:${NC}"
echo "1) Open in Xcode (recommended for first time)"
echo "2) Build for connected iPhone"
echo "3) Build IPA archive (for distribution)"
echo "4) Build and run on simulator"
read -p "Enter choice (1-4): " choice

case $choice in
    1)
        echo -e "${GREEN}Opening in Xcode...${NC}"
        open ios/Runner.xcworkspace
        echo ""
        echo "📝 Next steps in Xcode:"
        echo "1. Select your Team in Signing & Capabilities"
        echo "2. Change Bundle Identifier if needed"
        echo "3. Select your iPhone from device dropdown"
        echo "4. Press ▶️ to build and run"
        ;;
    2)
        echo -e "${GREEN}Building for connected iPhone...${NC}"
        flutter run --release
        ;;
    3)
        echo -e "${GREEN}Building IPA archive...${NC}"
        flutter build ipa --release
        echo ""
        echo -e "${GREEN}✅ Build complete!${NC}"
        echo "Archive location: build/ios/archive/Runner.xcarchive"
        echo ""
        echo "To distribute:"
        echo "1. Open Xcode"
        echo "2. Window → Organizer"
        echo "3. Select archive and click 'Distribute App'"
        ;;
    4)
        echo -e "${GREEN}Building for simulator...${NC}"
        flutter run --release -d iPhone
        ;;
    *)
        echo -e "${RED}Invalid choice${NC}"
        exit 1
        ;;
esac

echo ""
echo -e "${GREEN}✨ Done!${NC}"
