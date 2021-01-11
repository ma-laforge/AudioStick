#winreg.jl: Register AudioStick as a Windows Explorer contextual menu.

const STRING_SYNCWITHAUDIOSTICK = "Synchronize with AudioStick"

#==
===============================================================================#
function generate_inf_string()
	infqt(s) = string("\"\"", s, "\"\"") #.inf escaped quote (2 are necessary)
	module_root = dirname(dirname(abspath(@__FILE__)))
	juliacmd = infqt(joinpath(Sys.BINDIR, Base.julia_exename()))
	path_audiostick = infqt(joinpath(module_root, "run.jl"))
	#Compensate for shell bug by adding " " before quote
	#(Interprets last "\" of "Z:\" as an escape char!)
	path_dflttgt = infqt(DFLT_TGTROOT * " ")

	inf_file = """
[version]
signature="\$CHICAGO\$"

[DefaultInstall]
AddReg = Explore.AddReg

[Strings]
ACTION_TEXT = "$STRING_SYNCWITHAUDIOSTICK"
ACTION_CMD = "$juliacmd --color=yes $path_audiostick ""%1"" $path_dflttgt"

[Explore.AddReg]
HKCR,SystemFileAssociations\\.m3u\\shell\\AudioStick,,,%ACTION_TEXT%
HKCR,SystemFileAssociations\\.m3u\\shell\\AudioStick\\command,,,%ACTION_CMD%
HKCR,SystemFileAssociations\\.m3u8\\shell\\AudioStick,,,%ACTION_TEXT%
HKCR,SystemFileAssociations\\.m3u8\\shell\\AudioStick\\command,,,%ACTION_CMD%
"""
end

#Create .inf file to register AudioStick as a Windows Explorer context menu
function writeinf(filepath::String)
	filepath = abspath(filepath)
	filename = basename(filepath)
	@info("Writing $filepath...")
	open(filepath, "w") do f
		write(f, generate_inf_string())
	end

	println("""\n
You can now install the AudioStick context menu from the auto-generated
.inf file:
   1) In Windows Explorer, right-click on:
         $filename
   2) Click "Install".

You will then be able to synchronize playlists from the windows Explorer:
   1) In Windows Explorer, right-click any .m3u/.m3u8 file.
	2) Click "$STRING_SYNCWITHAUDIOSTICK".
""")
end
writeinf() = writeinf("AudioStick_AddWinExContextMenu.inf")

#Last line
