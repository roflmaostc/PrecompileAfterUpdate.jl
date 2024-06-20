# PrecompileAfterUpdate.jl
[![Build Status](https://github.com/roflmaostc/PrecompileAfterUpdate.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/roflmaostc/PrecompileAfterUpdate.jl/actions/workflows/CI.yml?query=branch%3Amain)

**TLDR**: Run `PrecompileAfterUpdate.precompile()` after an Julia update, wait some minutes and enjoy the next weeks without unexpected precompilations.  

## Background
This package serves one purpose. After upgrading Julia to a new version, often unexpected precompilations can happen when the non-default environment is used because packages need to be precompiled again for the new Julia version.
This packages crawls through your existing manifest files and precompiles them if their last usage is within a certain timeframe.
This can take sometimes a long time, on my machine like 30min or more, if many environments are precompiled.
```julia
julia> using PrecompileAfterUpdate

help?> PrecompileAfterUpdate.precompile
  precompile(fname=".julia/logs/manifest_usage.toml";
                  time_diff=Dates.CompoundPeriod(Dates.Day(30)))


  Precompile the environments listed in the TOML file fname if the last time they were used is greater than time_diff. fname is the path to the TOML file that contains the
  information about the last time an environment on your machine was used. As default time_diff is set to 30 days.

  So this script precompiles the environments that were used in the last 30 days. This is especially useful to save time after updating Julia.

julia> PrecompileAfterUpdate.precompile()
[ Info: Precompiling /home/fxw/.julia/dev/SpatiallyVaryingConvolution.jl/Manifest.toml
  Activating project at `~/.julia/dev/SpatiallyVaryingConvolution.jl`
Precompiling project...
```

## Increase number of stored precompilation files
Julia only stored [10 different precompilation files for a package by default](https://docs.julialang.org/en/v1/manual/environment-variables/#env-max-num-precompile-files).
In my case, I set `export JULIA_MAX_NUM_PRECOMPILE_FILES=50` to have a maximum amount of 50 files. This number is most likely high enough. But be aware that this can make your `.julia` folder larger.


