#!/bin/bash

# Download latest source tar from GitHub
VERSION=$(curl --silent "https://api.github.com/repos/Kong/insomnia/releases/latest" |
    grep -oP '"tag_name": "\K(.*)(?=")')
echo "Latest version of Insomnia Core is" $VERSION
curl -sOL "https://github.com/Kong/insomnia/archive/"$VERSION'.tar.gz'

# Extract tar
tar -xzf $VERSION'.tar.gz'
EXTRACTED=$(tar -tzf $VERSION'.tar.gz' | head -1 | cut -f1 -d"/")
echo "Extracted latest version to" $EXTRACTED

# Modify auto update settings
sed -i 's/updateAutomatically: true/updateAutomatically: false/' \
	$EXTRACTED/packages/insomnia-app/app/models/settings.js
sed -i 's/disableUpdateNotification: false/disableUpdateNotification: true/' \
    $EXTRACTED/packages/insomnia-app/app/models/settings.js

# Set up node and dependencies
npm install -g electron
npm install -g electron-builder
npm explore npm -g -- npm install node-gyp@latest

# Install dependencies
npm run bootstrap --prefix $EXTRACTED
export GIT_TAG=$VERSION

# Build for Linux
sed -i 's/targetPlatform = PLATFORM_MAP.*/targetPlatform = PLATFORM_MAP.linux;/' \
    $EXTRACTED/packages/insomnia-app/scripts/package.js
npm run app-package --prefix $EXTRACTED
cp insomnia-core-2020.5.2/packages/insomnia-app/dist/com.insomnia.app/*.AppImage .

# Build for macOS
sed -i 's/targetPlatform = PLATFORM_MAP.*/targetPlatform = PLATFORM_MAP.darwin;/' \
    $EXTRACTED/packages/insomnia-app/scripts/package.js
npm run app-package --prefix $EXTRACTED
cp -R insomnia-core-2020.5.2/packages/insomnia-app/dist/com.insomnia.app/mac/*.app .

# Build for Windows
sed -i 's/targetPlatform = PLATFORM_MAP.*/targetPlatform = PLATFORM_MAP.win32;/' \
    $EXTRACTED/packages/insomnia-app/scripts/package.js
npm run app-package --prefix $EXTRACTED
cp insomnia-core-2020.5.2/packages/insomnia-app/dist/com.insomnia.app/squirrel-windows/*.exe .
