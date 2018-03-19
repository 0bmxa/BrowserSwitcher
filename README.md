# Browser Switcher

A small tool for macOS which can decide which browser to open when clicking on a
link, depending on a list of hostnames.


## Usage

Right now you have to compile it and change the default browser yourself.

1. Open the project in Xcode, click `Build` and the app will be placed in your
_Applications_ folder.
2. Open the app once, so the system notices its presence. You can close it
immediatelly after opening it again.
3. Open `System Preferences.app`, go to `General`, and change the `Default Web
Browser` to *BrowserSwitcher*

Now you should be good to go. If not, open an
[issue](https://github.com/0bmxa/BrowserSwitcher/issues)! 🎉


### Configuration

Both the default and alternate browsers, as well as the exception URLs (which
lead to being opened in the alternate browser) are currently hardcoded in the
[`AppDelegate.swift`](BrowserSwitcher/AppDelegate.swift) file right now. If you want to change them, you have to
modify the file file and rebuild the project.


## ToDo

* Obviously make the browsers and URLs changeable from UI Rename `exceltionURLs`
* to `exceptionHosts` Maybe add some pattern matching to the exception list to
* support basic wildcards like `*.google.com` Ask for "Do you want to set this
* app as your default browser" Maybe an icon …
