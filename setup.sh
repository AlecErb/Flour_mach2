#!/bin/bash

# Flour Project Setup Script
# This script helps automate some of the setup tasks

set -e  # Exit on error

echo "🌾 Flour Project Setup"
echo "====================="
echo ""

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check if we're in the right directory
if [ ! -f "CLAUDE.md" ]; then
    echo -e "${RED}Error: Run this script from the project root directory${NC}"
    exit 1
fi

echo "Step 1: Setting up Config file..."
if [ ! -f "Resources/Config.swift" ]; then
    if [ -f "Resources/Config.example.swift" ]; then
        cp Resources/Config.example.swift Resources/Config.swift
        echo -e "${GREEN}✓ Config.swift created from template${NC}"
        echo -e "${YELLOW}⚠️  Remember to add your API keys to Resources/Config.swift${NC}"
    else
        echo -e "${RED}✗ Config.example.swift not found${NC}"
        exit 1
    fi
else
    echo -e "${YELLOW}Config.swift already exists, skipping...${NC}"
fi

echo ""
echo "Step 2: Checking for required files..."

required_files=(
    "FlourApp.swift"
    "ContentView.swift"
    "Package.swift"
    "Info.plist"
    ".gitignore"
)

all_present=true
for file in "${required_files[@]}"; do
    if [ -f "$file" ]; then
        echo -e "${GREEN}✓ $file${NC}"
    else
        echo -e "${RED}✗ $file missing${NC}"
        all_present=false
    fi
done

if [ "$all_present" = false ]; then
    echo -e "${RED}Some required files are missing${NC}"
    exit 1
fi

echo ""
echo "Step 3: Verifying directory structure..."

required_dirs=(
    "Models"
    "Views"
    "ViewModels"
    "Services"
    "Utilities"
    "Resources"
)

for dir in "${required_dirs[@]}"; do
    if [ -d "$dir" ]; then
        echo -e "${GREEN}✓ $dir/${NC}"
    else
        echo -e "${YELLOW}Creating $dir/${NC}"
        mkdir -p "$dir"
    fi
done

echo ""
echo "Step 4: Git setup..."

if [ ! -d ".git" ]; then
    echo "Initializing git repository..."
    git init
    git add .
    git commit -m "Phase 1: Initial project setup"
    echo -e "${GREEN}✓ Git repository initialized${NC}"
else
    echo -e "${YELLOW}Git repository already exists${NC}"
fi

echo ""
echo "Step 5: Checking .gitignore..."

# Verify critical files are in .gitignore
if grep -q "Config.swift" .gitignore && grep -q "GoogleService-Info.plist" .gitignore; then
    echo -e "${GREEN}✓ Secrets are properly gitignored${NC}"
else
    echo -e "${RED}⚠️  Warning: Make sure Config.swift and GoogleService-Info.plist are in .gitignore${NC}"
fi

echo ""
echo "============================================"
echo -e "${GREEN}✓ Automated setup complete!${NC}"
echo "============================================"
echo ""
echo "Next steps:"
echo "1. Open Xcode and create a new project (see XCODE_SETUP.md)"
echo "2. Import these files into your Xcode project"
echo "3. Add Swift Package Dependencies:"
echo "   - Firebase iOS SDK"
echo "   - Stripe iOS SDK"
echo "4. Set up Firebase and download GoogleService-Info.plist"
echo "5. Add your API keys to Resources/Config.swift"
echo "6. Build and run! (Cmd+R)"
echo ""
echo "For detailed instructions, see SETUP.md"
echo ""
