<h1 align="center">Jellyfin for macOS</h1>
<h3 align="center">Part of the <a href="https://jellyfin.media">Jellyfin Project</a></h3>

<p align="center">
Jellyfin for macOS is a launcher/wrapper built in Swift.
</p>

## Build Process

### Getting Started

1. Clone or download this repository.
   ```sh
   git clone https://github.com/anthonylavado/jellyfin-mac-app.git
   ```
2. Create a second directory beside this repository, called `jellyfin-mac-app-resources`.
   ```sh
   mkdir jellyfin-mac-app-resources
   ```
3. Download Jellyfin, and extract it. Rename the folder to `jellyfin` and put it inside the resources folder.

4. Download the correct version of FFmpeg, and place it in the root of `jellyfin-mac-app-resources`.

5. Open `Server.xcodeproj` with Xcode, and build.


### Directory Structure

The basic directory structure should look like this:

```
jellyfin-mac-app
├── LICENSE
├── Server
└── Server.xcodeproj

jellyfin-mac-app-resources/
├── ffmpeg
└── jellyfin
```


### FFmpeg Download

It's recommended to use a static macOS build of FFmpeg, such as [Zeranoe's Builds](https://ffmpeg.zeranoe.com/builds/macos64/static/).

At the time of writing, please use [ffmpeg-4.0.2-macos64-static.zip](https://ffmpeg.zeranoe.com/builds/macos64/static/ffmpeg-4.0.2-macos64-static.zip).


## Troubleshooting

### The project didn't build!

Please review the error inside Xcode. If a build failed, it is likely because the resources aren't in the right directory.

### The project built, but Jellyfin didn't launch. Xcode shows an error.

Does the console inside Xcode show `Error Domain=NSPOSIXErrorDomain Code=13 "Permission denied"`? If so, you need to fix your Jellyfin directory inside `-resources`.

Does the console show a `Failed to bind to address` message? You may already have a copy of Jellyfin running on your computer. This can happen if you did not shutdown a separate Jellyfin install, or if you clicked on "Stop" inside Xcode. Use Activity Monitor to find and quit any open Jellyfin process.

### The project built, but Jellyfin didn't launch. There are no errors I can see.

This wrapper does not launch the Web UI automatically. This will eventually become a configurable option. In the meanwhile, you can use the Jellyfin icon in the menu bar to launch the Web UI.
