using PrecompileAfterUpdate
using Test
using Pkg, Dates

@testset "PrecompileAfterUpdate.jl" begin
    Pkg.activate(; temp=true)
    Pkg.add("NDTools")
    Pkg.activate()

    @test PrecompileAfterUpdate.precompile(time_diff=Dates.CompoundPeriod(Dates.Day(1)))
end
