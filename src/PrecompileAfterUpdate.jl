module PrecompileAfterUpdate

using TOML
using Dates
using Pkg

"""
    precompile(fname=".julia/logs/manifest_usage.toml";
                    time_diff=Dates.CompoundPeriod(Dates.Day(30)))

Precompile the environments listed in the TOML file `fname` if the last time they were used is smaller than `time_diff`.
As default `time_diff` is set to 30 days, so all manifests which have been activated in the last 30 days are precompiled.
`fname` is the path to the TOML file that contains the information about the last time an environment on your machine was used.

So this script precompiles the environments that were used in the last 30 days.
This is especially useful to save unexpected precompilation time after updating Julia 

"""
function precompile(fname=joinpath(DEPOT_PATH[1], "logs/manifest_usage.toml"); time_diff=Dates.CompoundPeriod(Dates.Day(30)))
    # Load the project file
    toml = TOML.parsefile(fname)
    now = Dates.now()

    # Loop over the keys in the TOML file
    for key in keys(toml)

        for minor in deleteat!(collect(1:50), VERSION.minor)
            if occursin("/v1.$(minor)/", key)
                continue
            end
        end
        time = toml[key][1]["time"]

        try
            # if time difference greater than time_diff, precompile
            if now - time < time_diff
                # Precompile the project if possible and catch errors
                try
                    @info "Precompiling $key"
                    Pkg.activate(dirname(key))
                    Pkg.precompile()
                catch e
                end
                # deactivate the project
                Pkg.activate()
            end
        catch e
            if isa(e, InterruptException)
                @info "Interrupted"
                return
            else
                rethrow(e)
            end
        end
    end
    return true
end


end
