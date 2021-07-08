"""
    @filter_api api_name [filter_type=AbstractImageFilter]

This macro it generate two methods:

* `api_name([::Type,] img, f::filter_type, args...)`
* `api_name!([out,] img, f::filter_type, args...)`

For in-place method `api_name!`, `out` will be changed after calling the method.
When `out` is not explicitly passed, `img` will be changed after calling the method.

!!! info

    * Any api implementation needs to support a `f(out, in, args...)` method.
    * This macro is designed to be used in ImagesAPIs, and not downstream packages

## Example:

### 1. register the api in ImagesAPI.jl

```julia
abstract type AbstractImageNoise <: AbstractImageFilter end
@filter_api apply_noise AbstractImageNoise
```

### 2. implement the api in ImageNoise.jl
```julia
import Main.ImagesAPI: AbstractImageNoise, AbstractImageFilter, apply_noise, apply_noise!

export
    apply_noise, apply_noise!,
    AbstractImageNoise,
    AdditiveGaussianNoise

struct AdditiveGaussianNoise{T<:AbstractFloat} <: AbstractImageNoise
    mean::T
    std::T
end

function (noise::AdditiveGaussianNoise)(out, in::AbstractArray)
    @. out = in + noise.std * randn(eltype(out), size(in)) + noise.mean
end
```

### 3. user call the API in a consistent way
```julia
using ImageNoise
noise = AdditiveGaussianNoise(0.0, 0.1)

# simple usage
apply_noise(ones(3,3), noise)

# inplace changing
img = ones(3,3)
apply_noise!(img, noise)

# preallocation output
img = ones(3,3)
out = zeros(3, 3)
apply_noise!(out, img, noise)
```
"""
macro filter_api(func_name, filter_type = AbstractImageFilter)
    inplace_func_name = Symbol(String(func_name) * "!")
    @eval begin
        function $(inplace_func_name)(out, img, f::$(filter_type), args...)
            f(out, img, args...)
            out
        end

        function $(inplace_func_name)(img, f::$(filter_type), args...)
            f(img, img, args...)
            img
        end

        function $(func_name)(::Type{T}, img, f::$(filter_type), args...) where T
            out = Array{T}(undef, size(img)...)
            $(inplace_func_name)(out, img, f, args...)
            return out
        end

        function $(func_name)(img, f::$(filter_type), args...)
            $(func_name)(eltype(img), img, f, args...)
        end
    end
end
