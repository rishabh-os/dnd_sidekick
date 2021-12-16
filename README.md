# A Dungeons and Dragons app

`Screenshots go here`

Sidekick is an open source DnD companion app that makes it easier for you to manage
your characters and spells while playing DnD 5e.

This project is currently in an alpha state.

This is a hobby project of mine, meant to help me explore the capabilities of
[Flutter](https://flutter.dev/).

This app was made possible by the data avaiable at [5e.tools](https://5e.tools). Huge thanks to
them!

Feel free to open issues and make pull requests! I'll try my best to respond quickly (no guarantees).

### Feature List
- Dark mode! ✅
- Spell List: ✅
    - Filter by level and source book ✅
    - Search by spell name ✅
    - Add spells to a favourites list ✅
    - Quickly share spells with a button ✅
### To Be Added
- Items List
- Monsters List
- Class Details

## Releases
You can find the latest release of the application on GitHub Releases for this repository.

## Building from source
If you want to build this project from source, or you want to help with development, you can do so using the following steps

1. Make sure you have Flutter and the Android SDK installed. Instructions can be found
   [here](https://docs.flutter.dev/get-started/install).
2. Clone this repository into a local folder.
```
git clone repo_url
```
3. Get all the dependencies using
```
flutter pub get
```
4. Open a terminal in the cloned directory. Then run
```
flutter build apk --split-per-abi
```
5. The resulting apks will be available in `./build/app/outputs/apk/release/`, which can then
   be installed to your device(s).

If this is your first Flutter project, have a look at the following resources:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

There are plenty of other blog posts, videos and tutorials available as well!