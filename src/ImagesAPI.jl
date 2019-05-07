module ImagesAPI

"""
    AbstractImageAlgorithm

The root of image algorithms type system
"""
abstract type AbstractImageAlgorithm end

"""
    AbstractImageFilter <: AbstractImageAlgorithm

Filters are image algorithms whose input and output are both images
"""
abstract type AbstractImageFilter <: AbstractImageAlgorithm end

end # module
