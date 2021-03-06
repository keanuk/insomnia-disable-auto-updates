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
echo "Disabling auto-update settings in source code"
sed -i 's/updateAutomatically: true/updateAutomatically: false/' \
	$EXTRACTED/packages/insomnia-app/app/models/settings.js
sed -i 's/disableUpdateNotification: false/disableUpdateNotification: true/' \
    $EXTRACTED/packages/insomnia-app/app/models/settings.js

if [ "$1" = "build" ]
    then
        sh build-insomnia.sh "$2"
    else
        echo "Not attempting to build"
fi