"""
A small package to help users navigate to Julia package home repositories. See
exported functions `package_site` and `pkg_site`
"""
module PkgOnlineHelp

export package_site, pkg_site

import Pkg, TOML
import DefaultApplication

docstr = 
"""
    url = package_site(pkgname::AbstractString; autoopen=true)

    url = pkg_site(pkgname::AbstractString; autoopen=true)


Attempt to find the URL of a package's home repository, by searching through the 
registries in `DEPOT_PATH`.  If `autoopen` is `true` (default), then
open the URL using the default browser.

# Example
```jldoctest
julia> package_site("StaticArrays")
"https://github.com/JuliaArrays/StaticArrays.jl.git"
```

In this example the web site is also opened in the user's browser.
"""

"$docstr"
function package_site(pkgname::AbstractString; autoopen = true)
    occursin(".jl", pkgname) && (pkgname = split(pkgname, '.')[1])
    for depot in DEPOT_PATH
        isdir(joinpath(depot, "registries")) || continue
        for r in readdir(joinpath(depot, "registries"))
            file = joinpath(depot, "registries", r, pkgname[1:1], pkgname, "Package.toml")
            !isfile(file) && continue
            repoline = readlines(file)[3]
            url = TOML.parse(repoline)["repo"]
            autoopen && DefaultApplication.open(url)
            return url
        end
    end
    println("Package $pkgname not found in available registries")
    return nothing
end

const pkg_site = package_site

"$docstr"
pkg_site

end
