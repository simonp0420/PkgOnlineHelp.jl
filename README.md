# PkgOnlineHelp

[![Build Status](https://github.com/simonp0420/PkgOnlineHelp.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/simonp0420/PkgOnlineHelp.jl/actions/workflows/CI.yml?query=branch%3Amain)

A small package to help users navigate to Julia package home repositories. The two (identical) functions exported by this package are `pkg_site` and `package_site`.

    `url = package_site(pkgname::AbstractString, autoopen=true)`

    `url = pkg_site(pkgname::AbstractString, autoopen=true)`


Attempt to find the URL of a package's home repository, by searching through the registries in `DEPOT_PATH`.  If `autoopen` is `true` (default), then open the URL using the default browser.
# Example
```julia
julia> package_site("StaticArrays")
"https://github.com/JuliaArrays/StaticArrays.jl.git"
```

In this example the web site is also opened in the user's browser.


