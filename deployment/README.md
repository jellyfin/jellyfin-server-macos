# Preparing for Distribution

**Developer ID Notarization**

In order to distribute a notarized app that complies with GateKeeper, you must follow these steps. Using Developer ID requires a paid Apple Developer Program membership.

### Codesign Resources
To prepare for distribution, we must first sign all the resource executables. Here is an example set of commands:

```bash
codesign --force --options runtime --sign "Developer ID Application: COMPANYNAME" ./ffmpeg
codesign --force --options runtime --sign "Developer ID Application: COMPANYNAME" ./ffprobe
codesign --force --options runtime --sign "Developer ID Application: COMPANYNAME" ./jellyfin/jellyfin
```

If you are an individual developer, you can place your name in the same spot as `COMPANYNAME`:
```bash
codesign --force --options runtime --sign "Developer ID Application: Anthony Lavado" ./ffmpeg
```

### Set Capabilities
These should already be set in the project, but for reference, you must enable these capabilities:

* [x] **Hardened Runtime**
    * [x] Allow Execution of JIT-compiled Code Entitlement
    * [x] Apple Events Entitlement

### Archive and Upload for Notarization
At this point, you can archive the app, and upload to Apple for notarization.
