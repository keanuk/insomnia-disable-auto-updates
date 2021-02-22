# insomnia-disable-auto-updates
Script which modifies and builds Insomnia Core with auto updates disabled

## Usage
Execute 'run.sh' with no parameters in order to pull the latest version of Insomnia and modify the source code to disable auto updating.

Execute 'run.sh build' to attempt to build Insomnia for all available platforms (Linux, macOS, and Windows).

Execute 'run.sh build $PLATFORM' to attempt to build Insomnia for specified platform.
Available platforms:
- 'linux' (Linux)
- 'darwin' (macOS)
- 'win32' (Windows) 
