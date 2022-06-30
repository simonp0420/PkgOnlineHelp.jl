"""
A package to help users navigate to Julia package home repositories and documentation
sites. See help for exported functions `pkg_site`, `add_pkg_docs`, `remove_pkg_docs`, 
`list_pkg_docs`, `pkg_docs_site`, and the convenience macro `@docs`.
"""
module PkgOnlineHelp

export pkg_site, add_pkg_docs, remove_pkg_docs, list_pkg_docs, pkg_docs_site, @docs

import Pkg, TOML
import DefaultApplication
using Scratch: @get_scratch!

"""
    url = pkg_site(pkgname::AbstractString; autoopen=true)


Attempt to find the URL of a package's home repository, by searching through the 
registries in `DEPOT_PATH`.  If `autoopen` is `true` (default), then
open the URL using the default browser.

# Example
```jldoctest
julia> pkg_site("StaticArrays")
"https://github.com/JuliaArrays/StaticArrays.jl.git"
```
In this example the web site is also opened in the user's browser.
"""
function pkg_site(pkgname::AbstractString; autoopen = true)
    occursin(".jl", pkgname) && (pkgname = split(pkgname, '.')[1])
    for depot in DEPOT_PATH
        isdir(joinpath(depot, "registries")) || continue
        for r in readdir(joinpath(depot, "registries"))
            file = joinpath(depot, "registries", r, uppercase(pkgname[1:1]), 
            pkgname, "Package.toml")
            !isfile(file) && continue
            repoline = readlines(file)[3]
            url = TOML.parse(repoline)["repo"]
            autoopen && DefaultApplication.open(url)
            return url
        end
    end
    return nothing
end


const package_docs_file = "package_doc_sites.toml"
package_docs_dir = "" # will be overwritten by __init__

function __init__()
    global package_docs_dir = @get_scratch!("package_docs")
end

function _get_pkgdict()
    tomlfile = joinpath(package_docs_dir, package_docs_file)
    if isfile(tomlfile)
        pkgdict = TOML.parsefile(tomlfile)
    else
        pkgdict = Dict{String,String}()
    end
    return (pkgdict, tomlfile)
end


"""
    add_pkg_docs(package::AbstractString, url::AbstractString)

Add a web site for a package's documentation to the local database.
"""
function add_pkg_docs(package::AbstractString, url::AbstractString)
    pkgdict, tomlfile = _get_pkgdict()
    haskey(pkgdict, package) && @warn "Replacing documentation site for $package"
    pkgdict[package] = url

    open(tomlfile, "w") do io
        TOML.print(io, pkgdict)
    end
    return nothing
end

"""
    remove_pkg_docs(package::AbstractString)

Remove an entry for a package's documentation web site from the local database.
"""
function remove_pkg_docs(package::AbstractString)
    pkgdict, tomlfile = _get_pkgdict()
    if haskey(pkgdict, package) 
        delete!(pkgdict, package)
        open(tomlfile, "w") do io
            TOML.print(io, pkgdict)
        end
    else
        @warn "No entry for package $package in database. Nothing to delete."
    end
    return nothing
end

"""
    list_pkg_docs(io::IO=stdout)

Print out the documentation sites stored in the `PkgOnlineHelp` database to IO stream `io`.
"""
function list_pkg_docs(io::IO=stdout)
    pkgdict, tomlfile = _get_pkgdict()
    TOML.print(io, pkgdict)
    return nothing
end

"""
    url = pkg_docs_site(package::String; autoopen=true)

Attempt to find the URL of a package's documentation site by searching 
through the local database established by previous calls to `add_pkg_docs`.
If there is no entry in the database for the requested package, the 
package repository URL is obtained instead via a call to `pkg_site`.
If `autoopen` is `true` (default), then the URL is opened using the 
default browser.

# Example
Assume that in some previous (or the current) Julia session the user has entered
```
julia> using PkgOnlineHelp

julia> add_pkg_docs("PSSFSS", "https://simonp0420.github.io/PSSFSS.jl/stable/")
```
Then in the same or a later Julia session:
```julia
julia> using PkgOnlineHelp

julia> pkg_docs_site("PSSFSS")
"https://simonp0420.github.io/PSSFSS.jl/stable/"

In addition, the site is opened in the user's default browser.
"""
function pkg_docs_site(package::String; autoopen=true)
    pkgdict, _ = _get_pkgdict()
    if haskey(pkgdict, package)
        url = pkgdict[package]
    else
        url = pkg_site(package; autoopen=false)
    end
    autoopen && !isnothing(url) && DefaultApplication.open(url)
    return url
end

"""
    @docs PackageName

Retrieve the URL of the package's documentation site if previously recorded via a call to
`add_pkg_docs` or to the package's repository otherwise.  Open the URL in the user's 
default browser.

# Examples

```
julia> using PkgOnlineHelp

julia> @docs StaticArrays
"https://github.com/JuliaArrays/StaticArrays.jl.git"
```

The `StaticArrays` repo site is returned and opened in the browser.  In this example
the user had not previously entered the actual documentation site via a prior call
to `add_pkg_docs`. The repo site was found by searching through all Julia registries
in `DEPOT_PATH`. 

`@docs` can also be used to access unregistered packages or even arbitrary web sites.
Suppose you wish to have rapid access to the portion of the Julia documentation discussing
macros.  Then you would (one time only) enter the following at the Julia prompt:
```julia
julia> add_pkg_docs("macros", "https://docs.julialang.org/en/v1/manual/metaprogramming/#man-macros")
```
Later in this Julia session, or in any future session, the site can be quickly opened by entering
```julia
julia> @docs macros
```
Of course, this example assumes that `using PkgOnlineHelp` has already been entered.  
For convenience, you may wish to include this statement in your `startup.jl` file.


# See Also
`add_pkg_docs`, `remove_pkg_docs`, `list_pkg_docs`, `pkg_site`
"""
macro docs(package)
    esc(:(pkg_docs_site($(string(package)))))
end

end

