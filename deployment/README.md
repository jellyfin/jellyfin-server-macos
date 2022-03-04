# Preparing for Distribution

**Developer ID Notarization**

In order to distribute a notarized app that complies with GateKeeper, you must follow these steps. Using Developer ID requires a paid Apple Developer Program membership.

## Set Capabilities
To notarize an app, it must be using the Hardened Runtime features of Xcode.
These should already be set in the project, but for reference, you must enable these capabilities:

* [x] **Hardened Runtime**
    * [x] Allow Execution of JIT-compiled Code
    * [x] Allow Unsigned Executable Memory
    * [x] Allow DYLD Environment Variables
    * [x] Disable Library Validation
  
These are also listed in the `Jellyfin_Server.entitlements` file in this directory. 

## Codesign Resources
To prepare for distribution, first create an archive for distribution. All items in `Contents/Frameworks` and `Contents/MacOS` must be signed. Then you can sign the app as a whole.

An example signing command looks like this:
```bash
codesign --force --options runtime --sign "Developer ID Application: COMPANYNAME" ./Jellyfin.app
```

If you are an individual developer, you can place your name in the same spot as `COMPANYNAME`:
```bash
codesign --force --options runtime --sign "Developer ID Application: Anthony Lavado" ./Jellyfin.app
```

Here is an example shell script, using the signing identity like above:

```bash
# Setup variables. Ensure that the .app name is correct, and that both the .app
# and entitlements files are at the correct path.
APP_NAME="Jellyfin.app"
ENTITLEMENTS="Jellyfin_Server.entitlements"
SIGNING_IDENTITY="\"Developer ID Application: Anthony Lavado\""

# Iterate through contents that should be signed, and sign them
find "$APP_NAME/Contents/MacOS" -type f | while read fname; do
    echo "[INFO] Signing $fname"
    codesign --force --timestamp --options=runtime --entitlements "$ENTITLEMENTS" --sign $SIGNING_IDENTITY "$fname"
done

find "$APP_NAME/Contents/Frameworks" -type f | while read fname; do
    echo "[INFO] Signing $fname"
    codesign --force --timestamp --options=runtime --entitlements "$ENTITLEMENTS" --sign $SIGNING_IDENTITY "$fname"
done

echo "[INFO] Signing app file..."

codesign --force --timestamp --options=runtime --entitlements "$ENTITLEMENTS" --sign $SIGNING_IDENTITY "$APP_NAME"
```

After you sign the app, it is important to get it notarized by Apple so that it runs without issues on an end user's machine. If you decide to create a DMG, you must wait until you first get the app notarized, then package it in the DMG. Once you have your final DMG, you must submit it to Apple for notarization. Without this step, users will get warning messages when trying to mount the DMG.

If you want Gatekeeper validation to pass on an offline Mac, you must staple the ticket to the DMG.

### DMG Considerations
If you opt to create a DMG for the app, you can use the wonderful https://github.com/sindresorhus/create-dmg.git.

### Upload to Apple, and Staple Ticket
For actual steps on notarizing, I recommend two articles.
* Scripting OS X - Notarize a Command Line Tool - [Live Link](https://scriptingosx.com/2019/09/notarize-a-command-line-tool/) / [archive.org](https://web.archive.org/web/20191019023702/https://scriptingosx.com/2019/09/notarize-a-command-line-tool/)
* Apple Developer - Notarizing Your App Before Distribution - [Live Link](https://developer.apple.com/documentation/security/notarizing_your_app_before_distribution) / [archive.org](https://web.archive.org/web/20191014165810/https://developer.apple.com/documentation/security/notarizing_your_app_before_distribution)

## Practical Example
The current package and signing script can be viewed as a [GitHub Gist](https://gist.github.com/anthonylavado/e51db1e67e5c4ae047877ab4b2261cd3).
