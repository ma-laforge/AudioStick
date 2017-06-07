# AudioStick: Copy your music playlists to thumb drive.

## Description

AudioStick allows you to copy/synchronize media files onto an external drive -
or any arbitrary directory, for that matter.  AudioStick uses `.m3u/.m3u8`
files as a source for your media playlists.

### Sample Uses

1. Copy all your music playlists to a single USB stick.  You can then listen to
your favourite music on any media-capable USB port:

 - Your car's audio console.
 - Your television's built-in media playback menu.
 - Your favourite media player.
 - Your video game console's media playback menu.


### Implementation

Although `.m3u/.m3u8` playlists are fairly standard among computer media
players, alot of consumer equipment does not yet support these files.

To circumvent this issue, AudioStick creates "filesystem-based playlists":
Each playlist is organized in its own directory, and media files are copied
one-by-one, using numbered prefixes to maintain track order.

### Supported Playlist Files

AudioStick currently supports playlists of the following formats:

- M3U playlist (.m3u/.m3u8)

Simply right-click on the desired playlist file, and click on
"Synchronize with AudioStick".

### Synchronizing to iTunes Playlists

AudioStick synchronizes to iTunes playlists through intermediary .m3u files.
The following steps demonstrate how one can export an iTunes 12 playlist to
the required .m3u format:

1. In iTunes, open the desired playlist.
1. Under the File menu, select Library|Export List...
1. Choose output folder.
1. Specify playlist filename.
1. Set filetype to .m3u.
1. Click "Save".
1. Find newly created .m3u playlist using the Windows File Explorer.
1. Right-click on the playlist file.
1. Click on "Synchronize with AudioStick".


**NOTE:** The above process might need to be adapted for your particular
version of iTunes.

## Installation

To install AudioStick, you must first install a copy of the Julia programming
language.  Next, you simply follow a few steps to register AudioStick's
Explorer context menus.

### Installing Julia

1. Go to the Julia language download page <http://julialang.org/downloads/>.
1. Download one of the Windows Self-Extracting Archives (.exe).  The 64-bit version is highly recommended, if supported by your operating system.
1. Launch the downloaded file to install Julia.

### Installing AudioStick

1. Lauch Julia.

1. Install source:

		julia> Pkg.clone("https://github.com/ma-laforge/AudioStick.git")

1. Generate .inf file using build tool:

		julia> Pkg.build("AudioStick")

1. Close Julia:

		julia> exit()

1. Install the AudioStick context menu from the auto-generated .inf file:

  a. In Windows Explorer, right-click on:

  		[AudioStickPath]\_AddWin7ContextMenu.inf

  a. Click "Install".

## Known Limitations

- AudioStick currently only works on Windows, but could probably be ported to
other platforms with little effort.
- Due to limited understanding of Explorer context menus & registration, the
AudioStick context menu might only work for Windows 7.  It also might not
work if .m3u files are *not* associated with either Windows Media Player 11
or iTunes.
- Duplicate tracks will each take up the entire memory space required by the
original file.  This is because most of the tested consumer audio equipment
would only support FAT32 USB drives - and the FAT32 system does not support
softlinks.

### Compatibility

AudioStick has been tested using the following environment(s):

 - Windows 7 / Julia-0.6.0-rc2

## Disclaimer

This software is provided "as is", with no guarantee of correctness.  Use at own risk.
