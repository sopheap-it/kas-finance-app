# App Icon Assets

The following images need to be created for the app:

## Required Assets:

1. **app_icon.png** - Main app icon (1024x1024px)
2. **app_icon_foreground.png** - Foreground for adaptive icon (432x432px)
3. **splash_logo.png** - Splash screen logo (light mode)
4. **splash_logo_dark.png** - Splash screen logo (dark mode)
5. **splash_icon_android12.png** - Android 12 splash icon (960x960px)
6. **splash_icon_android12_dark.png** - Android 12 splash icon dark mode

## Design Guidelines:

- Use the app's primary brand color #6366F1 (indigo)
- Keep designs simple and recognizable at small sizes
- Ensure good contrast for both light and dark modes
- Follow platform-specific guidelines (Material Design for Android, Human Interface Guidelines for iOS)

## Commands to generate:

```bash
# Generate app icons
dart run flutter_launcher_icons:main

# Generate splash screens  
dart run flutter_native_splash:create
```
