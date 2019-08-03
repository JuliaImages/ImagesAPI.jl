using ImagesAPI
using Test

import ImagesAPI: default_names

@testset "ImagesAPI.jl" begin
    # Write your own tests here.
    img = reshape(1:24, 2,3,4)
    @test @inferred(namedaxes(img)) == NamedTuple{default_names(img)}(axes(img))

    @test @inferred(HasDimNames(img)) == HasDimNames{false}()

    @test @inferred(HasProperties(img)) == HasProperties{false}()
end

