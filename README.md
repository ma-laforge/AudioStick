# AudioStick: Synchronize USB sticks to your favourite media playlists

## Description
AudioStick allows users to build/synchronize filesystem-based playlists to
match those built with their favorite media player (ex: iTunes).

Filesystem-based playlists are very likely to work with most consumer
electronic equipment like car audio systems.

Although .m3u playlists are fairly standard among computer media players,
many audio systems do not appear to recognize these files.


### Supported Playlist Files
AudioStick currently supports playlists of the following formats:

- M3U playlist (.m3u)

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

### Installing AudioSitck

1. Copy the AudioStick repository to any folder ([AudioStickPath]) on your
local computer.

1. Lauch julia, and set current working directory to [AudioStickPath]:
>;cd [AudioStickPath]

1. Generate .inf file to add an Explorer context menu:
>include("AudioStick\_configure.jl")

1. Close Julia:
>exit()

1. Install the AudioStick context menu from the auto-generated .inf file:

  a. In Windows Explorer, right-click on:
  >[AudioStickPath]/AudioStick\_AddWin7ContextMenu.inf

  a. Click "Install".

## Verified Systems
AudioStick has been verified to work with the following software versions:

- Julia
 - v0.3.10
- Windows
 - Windows 7

## Known Limitations

- AudioStick currently only works on Windows, but could probably be ported to
other platforms with little effort.
- Due to limited understanding of Explorer context menus & registration, the
AudioStick context menu might only work for Windows 7.  It also might not
work if .m3u files are *not* associated with Windows Media Player 11 on your
system.
- Duplicate tracks will each take up the entire memory space required by the
original file.  This is because most of the tested consumer audio equipment
would only support FAT32 USB drives - and the FAT32 system does not support
softlinks.

## Disclaimer
This software is provided "as is", with no guarantee of correctness.  Use at own risk.
