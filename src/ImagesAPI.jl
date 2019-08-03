module ImagesAPI

export HasProperties,
       HasDimNames,
       namedaxes

"""
    HasProperties(img) -> HasProperties{::Bool}

Returns the trait `HasProperties`, indicating whether `x` has `properties`
method.
"""
struct HasProperties{T} end

HasProperties(img::T) where T = HasProperties(T)

HasProperties(::Type{T}) where T = HasProperties{false}()

"""
    HasDimNames(img) -> HasDimNames{::Bool}

Returns the trait `HasDimNames`, indicating whether `x` has named dimensions.
Types returning `HasDimNames{true}()` should also have a `names` method that
returns a tuple of symbols for each dimension.
"""
struct HasDimNames{T} end

HasDimNames(img::T) where T = HasDimNames(T)

HasDimNames(::Type{T}) where T = HasDimNames{false}()

"""
    namedaxes(img) -> NamedTuple{names}(axes)

Returns a `NamedTuple` where the names are the dimension names and each indice
is the corresponding dimensions's axis. If `HasDimNames` is not defined for `x`
default names are returned. `x` should have an `axes` method.

```jldoctest
julia> using ImagesAPI

julia> img = reshape(1:24, 2,3,4)

julia> namedaxes(img)
```
"""
namedaxes(img::T) where T = namedaxes(HasDimNames(T), img)

namedaxes(::HasDimNames{true}, x::T) where T = NamedTuple{names(x)}(axes(x))

function namedaxes(::HasDimNames{false}, img::AbstractArray{T,N}) where {T,N}
    NamedTuple{default_names(img)}(axes(img))
end

# returns NTuple{N,Symbol} of default names
function default_names(img::AbstractArray{T,N}) where {T,N}
    ntuple(i -> default_name(i), N)::NTuple{N,Symbol}
end

@inline function default_name(i::Int)
    if i == 1
        return :row
    elseif i == 2
        return :col
    elseif i == 3
        return :page
    else
        return Symbol(:dim_, i)
    end
end

end # module
