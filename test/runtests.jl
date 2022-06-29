using PkgOnlineHelp
using Test

@testset "PkgOnlineHelp.jl" begin
    @test package_site("StaticArrays"; autoopen=false) == "https://github.com/JuliaArrays/StaticArrays.jl.git"
    @test package_site("StaticArrays.jl"; autoopen=false) == "https://github.com/JuliaArrays/StaticArrays.jl.git"
    @test package_site("StaticVectors"; autoopen=false) == nothing
end
