# System Tray Icons

For this application to work properly on Windows, you need to add the following icon files to the `assets/icons/` directory:

## Required Icons:

1. **app_icon.ico** - Main application icon (16x16, 24x24, 32x32, 48x48 sizes)
2. **app_icon.png** - PNG version for fallback (32x32 recommended)

## How to create the icons:

### Method 1: Using online converters
1. Create or find a suitable PNG image (preferably 256x256 or 512x512)
2. Use an online ICO converter like:
   - https://convertio.co/png-ico/
   - https://www.icoconverter.com/
3. Make sure to include multiple sizes (16x16, 24x24, 32x32, 48x48)

### Method 2: Using GIMP (Free)
1. Create your icon design at 256x256
2. Go to File > Export As
3. Choose .ico format
4. Select multiple sizes when exporting

### Method 3: Using IconForge or similar tools
1. Import your PNG
2. Generate ICO with multiple resolutions

## Default Icon (Temporary)
For testing purposes, you can use the Flutter default icon from:
`web/icons/Icon-192.png` and convert it to ICO format.

## Placement:
- Place `app_icon.ico` in `assets/icons/app_icon.ico`
- Place `app_icon.png` in `assets/icons/app_icon.png`

The application will automatically use these icons for the system tray.
