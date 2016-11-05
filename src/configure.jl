#AudioStick_configure.jl
#
#Configures system to run AudioStick.

const __APPPATH__ = dirname(realpath(@__FILE__))
const path_julia = joinpath(JULIA_HOME, "julia.exe")
const path_audiostick = joinpath(__APPPATH__, "AudioStick.jl")
const text_action = "Synchronize with AudioStick"
const path_inf = joinpath(__APPPATH__, "AudioStick_AddWin7ContextMenu.inf")

const inf_file = """
[version]
signature="\$CHICAGO\$"

[DefaultInstall]
AddReg = Explore.AddReg

[Strings]
ACTION_TEXT = "$text_action"
ACTION_CMD = "$path_julia $path_audiostick ""%1""\"

[Explore.AddReg]
HKCR,WMP11.AssocFile.M3U\\shell\\AudioStick,,,%ACTION_TEXT%
HKCR,WMP11.AssocFile.M3U\\shell\\AudioStick\\command,,,%ACTION_CMD%
"""

f = open(path_inf, "w")
write(f, inf_file)
close(f)

println("""
You can now install the AudioStick context menu from the auto-generated
.inf file:
   1) In Windows Explorer, right-click on:
         $path_inf
   2) Click "Install".

You will then be able to synchronize playlists from the windows Explorer:
   1) In Windows Explorer, right-click any .m3u file.
	2) Click "$text_action".
""")
#Last line
