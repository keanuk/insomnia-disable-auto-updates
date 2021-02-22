#!/bin/bash

VERSION=$(curl --silent "https://api.github.com/repos/Kong/insomnia/releases/latest" |
    grep -oP '"tag_name": "\K(.*)(?=")')
EXTRACTED=$(tar -tzf $VERSION'.tar.gz' | head -1 | cut -f1 -d"/")

# Set up node and dependencies
npm install -g electron
npm install -g electron-builder
npm explore npm -g -- npm install node-gyp@latest

# Install dependencies
npm run bootstrap --prefix $EXTRACTED
export GIT_TAG=$VERSION

# Check if platform was specified in command line
if [ -z "$1" ]
    then
        echo "Building Insomnia for linux, darwin, and win32"

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

    else
        echo "Building Insomnia for" $1

        # Build for specified platform
        sed -i 's/targetPlatform = PLATFORM_MAP.*/targetPlatform = PLATFORM_MAP.'"$1"';/' \
            $EXTRACTED/packages/insomnia-app/scripts/package.js
        npm run app-package --prefix $EXTRACTED
        cp insomnia-core-2020.5.2/packages/insomnia-app/dist/com.insomnia.app/*.AppImage .
        cp insomnia-core-2020.5.2/packages/insomnia-app/dist/com.insomnia.app/mac/*.app .
        cp insomnia-core-2020.5.2/packages/insomnia-app/dist/com.insomnia.app/squirrel-windows/*.exe .
fi
