# Syncthing for macOS

<<<<<<< HEAD
<p align="center">
Jellyfin for macOS is a launcher/wrapper built in Swift and Objective-C.
</p>
=======
[![Syncthing forum](https://img.shields.io/badge/syncthing-%20forum-blue.svg)](https://forum.syncthing.net/t/syncthing-for-macos)
[![Downloads](https://img.shields.io/github/downloads/syncthing/syncthing-macos/total.svg)](https://github.com/syncthing/syncthing-macos/releases) [![Latest release](https://img.shields.io/github/release/syncthing/syncthing-macos.svg)](https://github.com/syncthing/syncthing-macos/releases/latest) [![Build Status](https://travis-ci.org/syncthing/syncthing-macos.svg?branch=master)](https://travis-ci.org/syncthing/syncthing-macos) [![license](https://img.shields.io/github/license/mashape/apistatus.svg?maxAge=2592000)](LICENSE)
>>>>>>> change the application base to syncthing-macos

# Introduction

`syncthing-macos` is a native macOS Syncthing tray application bundle. It hosts and wraps [Syncthing](https://syncthing.net), making it behave more like a native macOS application and less like a command-line utility with a web browser interface.

<<<<<<< HEAD
1. Clone or download this repository.
   ```sh
   git clone https://github.com/jellyfin/jellyfin-server-macos.git
   ```
2. Open `Server.xcodeproj` with Xcode, and build.
=======
Features include:

 * Open the Syncthing WebGUI from the tray in your preferred browser.
 * Optionally starts on login, so you don't need to set up Syncthing as a service.
 * Tray icon indicates when it is connected to syncthing (no status updates yet).
 * Retina ready icons for the Application bundle and status tray.
 * Automatic updates (using [Sparkle](https://sparkle-project.org) pushed from github releases).
 * Open shared folders directly in Finder.

# Screenshot

<img alt="screenshot.png" src="https://user-images.githubusercontent.com/1050166/48157165-35970f00-e2cf-11e8-8009-10bfbf7fbce2.png">

# Installation

**NOTICE**: This is the official Syncthing macOS application bundle. Please make sure you have no other [syncthing instances](https://docs.syncthing.net/users/autostart.html#macos)
            or [wrappers running](https://docs.syncthing.net/users/contrib.html#mac-os) or else this application will not work!

Currently, OS X 10.10 or higher is necessary. **syncthing-macos** is packaged as a disk image as an application bundled with the [syncthing](https://github.com/syncthing/syncthing) binary.

To install just download the dmg, mount it and drag and drop the application to install. The only necessary configuration is to set the API key and URL when provisioning a remote syncthing instance, the local instance is auto-configured. The application automatically keeps the syncthing binary updated, while running.

The latest version is available at [Github Releases](https://github.com/syncthing/syncthing-macos/releases/latest), or it can also be installed using [homebrew](https://github.com/Homebrew/homebrew-cask) `brew cask install syncthing`

# Why

All cross-platform approaches are not able to use all the native facilities of macOS. Including auto-updates,
 vector icon set (retina-ready) and creating an application bundle. GUIs are designed with XCode and everything
 is coded in Objective-C and Swift which is "the native approach".

# Compiling

Build with XCode or run:

```
make debug
```
>>>>>>> change the application base to syncthing-macos

It will automaticly download syncthing amd64 binary and add it to the Application Bundle.

For release builds signing the application build and creating an distributable DMG:

<<<<<<< HEAD
It's recommended to use a static macOS build of FFmpeg, such as [Zeranoe's Builds](https://ffmpeg.zeranoe.com/builds/macos64/static/). There is a build phase script that will download this for you.

At the time of writing, please use [ffmpeg-4.2.1-macos64-static.zip](https://ffmpeg.zeranoe.com/builds/macos64/static/ffmpeg-4.2.1-macos64-static.zip).
=======
```
make release-dmg
```

The script will select the first available Developer ID and sign the app with it. To specify the signing identity, use `SYNCTHING_APP_CODE_SIGN_IDENTITY` environment variable:

```
SYNCTHING_APP_CODE_SIGN_IDENTITY="Mac Developer: foo@bar.com (XB59MXU8EC)" make release-dmg
```

# Goal
>>>>>>> change the application base to syncthing-macos

The goal of this project is to keep the Native macOS Syncthing tray as simple as possible. No graphs, no advanced configuration
 windows. It just provides a very simple wrapper so users are not aware syncthing ships as a commandline application. It strives to have a usability of good-by-default and should always follow the [Apple Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/macos) to feel as much as an native application as possible.

# Known bugs

See the [issue tracker](https://github.com/syncthing/syncthing-macos/issues) for the current status.

<<<<<<< HEAD
Please review the error inside Xcode. If a build failed, it is likely because the resources didn't download.
=======
# Design
>>>>>>> change the application base to syncthing-macos

Design, internals and build process is documented in [doc/design.md](doc/design.md)

<<<<<<< HEAD
Does the console inside Xcode show `Error Domain=NSPOSIXErrorDomain Code=13 "Permission denied"`? If so, Jellyfin may not have copied out correctly. Please let me know.

Does the console show a `Failed to bind to address` or `database locked` message? You may already have a copy of Jellyfin running on your computer. This can happen if you did not shutdown a separate Jellyfin install, or if you clicked on "Stop" inside Xcode. Use Activity Monitor to find and quit any open Jellyfin process.

### The project built, and it runs. Jellyfin keeps opening the browser every time I start it.

This wrapper lets Jellyfin launch the Web UI automatically. If you want to change this, click the icon in the Menu Bar, and choose preferences. You can always use the menu icon to launch the Web UI.

---
This project is based upon [Syncthing for macOS](https://github.com/syncthing/syncthing-macos). Both projects are available under the [MIT License](LICENSE).
=======
# Contributions

[Contributions](CONTRIBUTING.md) and [issue reports](https://github.com/syncthing/syncthing-macos/issues) are welcome.

# License

[MIT](LICENSE)
>>>>>>> change the application base to syncthing-macos
