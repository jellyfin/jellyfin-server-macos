<h1 align="center">Jellyfin for macOS</h1>
<h3 align="center">Part of the <a href="https://jellyfin.media">Jellyfin Project</a></h3>

<p align="center">
Jellyfin for macOS is a launcher/wrapper built in Swift and Objective-C.
</p>

## Build Process

### Getting Started

1. Clone or download this repository.
   ```sh
   git clone https://github.com/jellyfin/jellyfin-server-macos.git
   ```
2. Open `jellyfin-server-macos.xcodeproj` with Xcode, and build.


### FFmpeg Download

It's recommended to use a static macOS build of FFmpeg, such as [Zeranoe's Builds](https://ffmpeg.zeranoe.com/builds/macos64/static/). There is a build phase script that will download this for you.

At the time of writing, please use [ffmpeg-4.2.1-macos64-static.zip](https://ffmpeg.zeranoe.com/builds/macos64/static/ffmpeg-4.2.1-macos64-static.zip).


## Troubleshooting

### The project didn't build!

Please review the error inside Xcode. If a build failed, it is likely because the resources didn't download.

### The project built, but Jellyfin didn't launch. Xcode shows an error.

Does the console inside Xcode show `Error Domain=NSPOSIXErrorDomain Code=13 "Permission denied"`? If so, Jellyfin may not have copied out correctly. Please let me know.

Does the console show a `Failed to bind to address` or `database locked` message? You may already have a copy of Jellyfin running on your computer. This can happen if you did not shutdown a separate Jellyfin install, or if you clicked on "Stop" inside Xcode. Use Activity Monitor to find and quit any open Jellyfin process.

### The project built, and it runs. Jellyfin keeps opening the browser every time I start it.

This wrapper lets Jellyfin launch the Web UI automatically. If you want to change this, click the icon in the Menu Bar, and choose preferences. You can always use the menu icon to launch the Web UI.

---
This project is based upon [Syncthing for macOS](https://github.com/syncthing/syncthing-macos). Both projects are available under the [MIT License](LICENSE).
