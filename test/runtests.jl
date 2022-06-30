using PkgOnlineHelp
using Test

@testset "PkgOnlineHelp.jl" begin
    @test pkg_site("StaticArrays"; autoopen=false) == "https://github.com/JuliaArrays/StaticArrays.jl.git"
    @test pkg_site("StaticArrays.jl"; autoopen=false) == "https://github.com/JuliaArrays/StaticArrays.jl.git"
    @test pkg_site("StaticCling"; autoopen=false) == nothing
    @test @macroexpand(@docs(StaticArrays)) == :(pkg_docs_site("StaticArrays"))
    @test pkg_site("StaticArrays", autoopen=false) == "https://github.com/JuliaArrays/StaticArrays.jl.git"


    function _get_docs()
        iob = IOBuffer()
        list_pkg_docs(iob)
        docs = split(read(seekstart(iob), String))
    end    

    newpkg = "testxyznonsense"
    newpkg_site = "http://more_nonsense"
    newpkg_site_test = "\"" * newpkg_site * "\""

    docs = _get_docs()
    @test newpkg ∉ docs
    @test newpkg_site_test ∉ docs

    add_pkg_docs(newpkg, newpkg_site)
    docs = _get_docs()

    @test newpkg ∈ docs
    @test newpkg_site_test ∈ docs
    @test pkg_docs_site(newpkg; autoopen=false) == newpkg_site

    remove_pkg_docs(newpkg)
    docs = _get_docs()

    @test newpkg ∉ docs
    @test newpkg_site_test ∉ docs
    @test pkg_docs_site(newpkg; autoopen=false) == nothing

end
