# Custom Notification Sounds Guide

This guide explains how to add custom notification sounds for both Android and iOS in this project.

## Android

1. Place your custom sound files (e.g., `my_sound.mp3` or `my_sound.wav`) in the following directory:

```
android/app/src/main/res/raw/
```

- If the `raw` folder does not exist, create it inside `res`.
- File names must be lowercase and use underscores instead of spaces.

2. Reference the sound in your notification code using the file name (without extension).

## iOS

1. Add your custom sound files (e.g., `my_sound.aiff`, `my_sound.wav`, or `my_sound.caf`) to the Xcode project:

- Open `ios/Runner.xcworkspace` in Xcode.
- In the Project Navigator, right-click the `Runner` folder and select **Add Files to "Runner"...**
- Select your sound files and ensure **Copy items if needed** is checked.
- Make sure the files are added to the `Runner` target.

2. Reference the sound in your notification code using the file name (with extension).

---

**Note:**

- Sound files must be in the correct format for each platform.
- For more details, see the official documentation for [flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications).
