# Preparing for Distribution

**Developer ID Notarization**

In order to distribute a notarized app that complies with GateKeeper, you must follow these steps. Using Developer ID requires a paid Apple Developer Program membership.

### Set Capabilities
To notarize an app, it must be using the Hardened Runtime features of Xcode.
These should already be set in the project, but for reference, you must enable these capabilities:

* [x] **Hardened Runtime**
    * [x] Allow Execution of JIT-compiled Code
    * [x] Allow Unsigned Executable Memory
    * [x] Disable Library Validation

### Codesign Resources
To prepare for distribution, first create an archive for distribution. Once you have the `.app`, you must sign it.

Here is an example set of commands:

```bash
codesign --force --options runtime --sign "Developer ID Application: COMPANYNAME" ./Jellyfin.app
```

If you are an individual developer, you can place your name in the same spot as `COMPANYNAME`:
```bash
codesign --force --options runtime --sign "Developer ID Application: Anthony Lavado" ./Jellyfin.app
```

### Signing Order
After you sign the app, it is important to get it notarized by Apple so that it runs without issues on an end user's machine. If you decide to create a DMG, you must wait until you first get the app notarized, then package it in the DMG. Once you have your final DMG, you must submit it to Apple for notarization. Without this step, users will get warning messages when trying to mount the DMG.

### DMG Considerations
If you opt to create a DMG for the app, you can use the wonderful https://github.com/sindresorhus/create-dmg.git.

### Upload to Apple, and Staple Ticket
For actual steps on notarizing, I recommend two articles.
* Scripting OS X - Notarize a Command Line Tool - [Live Link](https://scriptingosx.com/2019/09/notarize-a-command-line-tool/) / [archive.org](https://web.archive.org/web/20191019023702/https://scriptingosx.com/2019/09/notarize-a-command-line-tool/)
* Apple Developer - Notarizing Your App Before Distribution - [Live Link](https://developer.apple.com/documentation/security/notarizing_your_app_before_distribution) / [archive.org](https://web.archive.org/web/20191014165810/https://developer.apple.com/documentation/security/notarizing_your_app_before_distribution)
