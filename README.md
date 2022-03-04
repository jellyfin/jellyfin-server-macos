<h1 align="center">Jellyfin for macOS</h1>
<h3 align="center">Part of the <a href="https://jellyfin.media">Jellyfin Project</a></h3>

---

<p align="center">
<img alt="Logo Banner" src="https://raw.githubusercontent.com/jellyfin/jellyfin-ux/master/branding/SVG/banner-logo-solid.svg?sanitize=true"/>
<br/>
<br/>
<a href="https://github.com/jellyfin/jellyfin-server-macos/blob/master/LICENSE">
<img alt="MPL 2.0 License" src="https://img.shields.io/github/license/jellyfin/jellyfin-server-macos.svg"/>
</a>
<a href="https://opencollective.com/jellyfin">
<img alt="Donate" src="https://img.shields.io/opencollective/all/jellyfin.svg?label=backers"/>
</a>
<a href="https://features.jellyfin.org">
<img alt="Submit Feature Requests" src="https://img.shields.io/badge/fider-vote%20on%20features-success.svg"/>
</a>
<a href="https://matrix.to/#/+jellyfin:matrix.org">
<img alt="Chat on Matrix" src="https://img.shields.io/matrix/jellyfin:matrix.org.svg?logo=matrix"/>
</a>
<a href="https://www.reddit.com/r/jellyfin">
<img alt="Join our Subreddit" src="https://img.shields.io/badge/reddit-r%2Fjellyfin-%23FF5700.svg"/>
</a>
<a href="https://github.com/jellyfin/jellyfin-server-macos/commits/master.atom">
<img alt="Commits RSS Feed" src="https://img.shields.io/badge/rss-commits-ffa500?logo=rss" />
</a>
</p>

---

<p align="center">
Jellyfin for macOS is a launcher/wrapper built in Swift and Objective-C.
</p>
<br/>

# Getting Started
Are you looking to just run and setup Jellyfin on your macOS machine? Go to https://jellyfin.org/downloads and get the macOS stable release.

Do you want to build Jellyfin's menu bar app/launcher for yourself? Read on!

---

## Compiling the Menu App
### Requirements
* [Xcode for macOS](https://developer.apple.com/xcode/)

### Steps
1. Clone or download this repository.
   ```sh
   git clone https://github.com/jellyfin/jellyfin-server-macos.git
   ```
2. Open `Jellyfin Server.xcodeproj` with Xcode. Update version number and build.
3. Archive the app to a local directory.

### Usage
The Menu app is designed to do three things:
1. Start and Stop a pre-packaged Jellyfin in the background
2. Open the Web UI
3. Open the Log Folder
4. Ensure that the Jellyfin binary is pointed to the packaged version of the web UI
5. Ensure that a cache folder exists before launching the server


## Building the Full Package
### Requirements
* The compiled menu bar app from above
* The latest [Jellyfin macOS Combined](https://repo.jellyfin.org/releases/server/macos/versions/stable/combined/) package

If you choose to build Jellyfin server on your own, you will also require:
* [FFmpeg](https://evermeet.cx/ffmpeg/) for macOS, or equivalent FFmpeg/FFprobe 4.4+.

### Steps
1. Ensure that a complete copy of Jellyfin Server is available in a folder. If using the combined package from above, proceed to the next step.
    * If you are building Jellyfin from source, place a copy of `ffmpeg` in the same folder as the server binary. You need to add `ffmpeg` and `ffprobe` alongside `jellyfin`. Ensure that you also build `jellyfin-web`.
    * If using a packaged version, take the `jellyfin-web` folder out of the folder with the server in it.
2. Locate the .app that was built above. Right/Ctrl Click it and choose "Show Package Contents".
3. Go inside the folder `Contents`, then `MacOS`. Place the Jellyfin server and FFmpeg files here. Make sure they are not in a subfolder of their own.
4. Go up one level, and go to the `Resources` folder. Place the `jellyfin-web` folder here. The folder name must match.
5. (Optional) If you want to sign the .app for distribution, see the [Deployment Instructions](https://github.com/jellyfin/jellyfin-server-macos/tree/master/deployment).

## Troubleshooting

### The project didn't build!

Please review the error inside Xcode. If a build failed, it is likely because the resources aren't in the right directory.

### The project built, but Jellyfin didn't launch. Xcode shows an error.

This is because Jellyfin needs to be placed in the app bundle so it can be launched. This is currently a manual process, which can be scripted for convenience.

Does the console show a `Failed to bind to address` message? You may already have a copy of Jellyfin running on your computer. This can happen if you did not shutdown a separate Jellyfin install, or if you clicked on "Stop" inside Xcode while running/debugging. Use Activity Monitor to find and quit any open Jellyfin process.

### The project built, but Jellyfin didn't launch. There are no errors I can see.

You must manually open the web UI by clicking on the icon in the menu bar first.
