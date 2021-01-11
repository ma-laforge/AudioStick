#AudioStick.jl: Copy/synchronize playlist media files to a given drive/folder.
module AudioStick

import Printf: @sprintf
using SHA

include("files.jl")
include("base.jl")
include("console.jl")
include("console_app.jl")
include("winreg.jl")

function run_app()
	try
		run_console()
	catch e
		@error(e)
		pause() #In case windows closes once function returns
	end
end

end
#Last line
