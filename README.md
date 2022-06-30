# PkgOnlineHelp

[![Build Status](https://github.com/simonp0420/PkgOnlineHelp.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/simonp0420/PkgOnlineHelp.jl/actions/workflows/CI.yml?query=branch%3Amain)

A package to help users quickly navigate to Julia package home repositories and documentation sites.

# Installation

```julia
julia> import Pkg

julia> Pkg.add("PkgOnlineHelp")
```

# Usage

The main convenience macro is `@docs`.  As an example of usage:

```julia
julia> using PkgOnlineHelp  # If not included in your startup.jl

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

The contents of the `PkgOnlineHelp` database can be shown by typing `list_pkg_docs()`
at the REPL prompt. Items can be removed using, e.g. `remove_pkg_docs("macros")`.

# Other Exported Functions

## `pkg_site`
```julia
    url = pkg_site(pkgname::AbstractString; autoopen=true)
```

Attempt to find the URL of a package's home repository, by searching through the registries in `DEPOT_PATH`.  If `autoopen` is `true` (default), then open the URL using the default browser.
### Example
```julia
julia> package_site("StaticArrays")
"https://github.com/JuliaArrays/StaticArrays.jl.git"
```

In this example the web site is also opened in the user's browser.

## `pkg_docs_site`
```julia
    url = pkg_docs_site(pkgname::AbstractString, autoopen==true)
```
This is the function invoked by the `@docs` macro.  See the discussion
above re `@docs`.

