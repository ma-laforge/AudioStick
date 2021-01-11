using ConventionalApp

proj = Project(@__DIR__)
setup_env(proj)
@include_startup(proj)

#show(activeproject)

Main.include("src/AudioStick.jl")
Main.AudioStick.run_app()
