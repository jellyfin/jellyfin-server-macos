<h1 align="center">Jellyfin for macOS</h1>
<h3 align="center">Part of the <a href="https://jellyfin.media">Jellyfin Project</a></h3>

<p align="center">
Jellyfin for macOS is a launcher/wrapper built in Swift and Objective-C.
</p>

## Build Process

### Getting Started

The Build Process instructions need to be updated, and will be coming soon.
<!--1. Clone or download this repository.
   ```sh
   git clone https://github.com/jellyfin/jellyfin-server-macos.git
   ```
2. Download Jellyfin, and extract it. Rename the folder to `jellyfin` and put it inside the resources folder.

3. Download the correct version of FFmpeg. Extract it, and place `ffmpeg` and `ffprobe` in the root of `jellyfin-mac-app-resources`.

4. Open `Server.xcodeproj` with Xcode, and build.-->





### FFmpeg Download

It's recommended to use a static macOS build of FFmpeg, such as [Zeranoe's Builds](https://ffmpeg.zeranoe.com/builds/macos64/static/).

At the time of writing, please use [ffmpeg-4.2.2-macos64-static.zip](https://ffmpeg.zeranoe.com/builds/macos64/static/ffmpeg-4.2.2-macos64-static.zip).


## Troubleshooting

### The project didn't build!

Please review the error inside Xcode. If a build failed, it is likely because the resources aren't in the right directory.

### The project built, but Jellyfin didn't launch. Xcode shows an error.

This is because Jellyfin needs to be placed in the app bundle so it can be launched. This is currently a manual process, which will be automated for future use.

Does the console show a `Failed to bind to address` message? You may already have a copy of Jellyfin running on your computer. This can happen if you did not shutdown a separate Jellyfin install, or if you clicked on "Stop" inside Xcode. Use Activity Monitor to find and quit any open Jellyfin process.

### The project built, but Jellyfin didn't launch. There are no errors I can see.

This wrapper may launch the Web UI too quickly. This will eventually be configurable. In the meanwhile, you can use the Jellyfin icon in the menu bar to launch the Web UI again.
