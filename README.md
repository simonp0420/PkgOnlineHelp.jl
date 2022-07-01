# PkgOnlineHelp

[![Build Status](https://github.com/simonp0420/PkgOnlineHelp.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/simonp0420/PkgOnlineHelp.jl/actions/workflows/CI.yml?query=branch%3Amain)

A package to help quickly open (via a few keystrokes at the Julia REPL) 
package documentation web sites or other user-selected sites.

# Installation

```julia
julia> import Pkg

julia> Pkg.add("PkgOnlineHelp")
```

For convenience, you may wish to add the following line to your [startup.jl](https://docs.julialang.org/en/v1/manual/getting-started/#man-getting-started) file:

```julia
using PkgOnlineHelp
```

# Usage

The main convenience macro is `@docs`.  An example of usage:

```julia
julia> using PkgOnlineHelp  # If not included in your startup.jl

julia> @docs StaticArrays
"https://github.com/JuliaArrays/StaticArrays.jl.git"
```

The `StaticArrays` repo site is returned and opened in the browser. By default, when 
invoked with a package name as shown above, `@docs` will return and open the package's
repo web site.  However, this site choice can be overridden via a call to `add_pkg_docs` as
shown below.  The repo site was determined by searching through all Julia registries
in `DEPOT_PATH`, implying that unregistered packages will not be found, by default.

However, `@docs` can also be used to access unregistered packages or even arbitrary web sites.
Suppose you wish to have rapid access to the portion of the online Julia documentation discussing
macros.  Then you would (one time only) enter the following at the Julia prompt:
```julia
julia> add_pkg_docs("macros", "https://docs.julialang.org/en/v1/manual/metaprogramming/#man-macros")
```
Later in this Julia session, or in any future session, the site can be quickly opened by entering
```julia
julia> @docs macros
```
Of course, this example assumes that `using PkgOnlineHelp` has already been entered.  

Similarly, entering
```julia
julia> add_pkg_docs("StaticArrays", "https://juliaarrays.github.io/StaticArrays.jl/stable/")
```
will cause future invocations of `@docs StaticArrays` to open the hosted documentation for the package, rather than the repo site.

Each call to `add_pkg_docs` adds an entry to a tiny TOML database file stored in a 
[Scratch](https://github.com/JuliaPackaging/Scratch.jl) space, providing permanence across Julia sessions.

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

# Acknowledgement
This package was inspired by the discussion and code snippets presented in [this thread](https://discourse.julialang.org/t/easy-way-to-reach-online-documentation/83462/1).  