using ImagesAPI: @filter_api, AbstractImageFilter
using Test

@testset "ImagesAPI.jl" begin
    @filter_api foo # not working though
    struct FOO <: AbstractImageFilter end
    function (::FOO)(out, in)
        out = in .* 2
    end

    @test foo(ones(3, 3), FOO()) == ones(3, 3) .* 2
    in = ones(3, 3)
    foo!(in, FOO())
    @test in == ones(3, 3) .* 2
    in = ones(3, 3)
    out = zeros(3, 3)
    foo!(out, in, FOO())
    @test in == ones(3, 3)
    @test out == ones(3, 3) .* 2
end
