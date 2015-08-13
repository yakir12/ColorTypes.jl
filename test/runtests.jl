using ColorTypes, FixedPointNumbers
using Base.Test

@test eltype(Paint{U8}) == U8
@test eltype(RGB{Float32}) == Float32
@test eltype(RGBA{Float64}) == Float64
# @test eltype(RGB) == TypeVar(:T, Fractional)
eltype(RGB)      # just test that it doesn't error

@test colortype(RGB{U8}) == RGB{U8}
@test colortype(RGB) == RGB
@test colortype(RGBA{Float32}) == RGB{Float32}
@test colortype(GrayA{U8}) == Gray{U8}
@test colortype(RGBA) == RGB
@test colortype(RGB24)  == RGB24
@test colortype(ARGB32) == RGB24
@test colortype(Transparent{RGB}) == RGB
@test colortype(Transparent{RGB,Float64}) == RGB
@test colortype(Transparent{RGB{Float64},Float64}) == RGB{Float64}
@test colortype(Transparent) <: AbstractColor
@test AbstractColor <: colortype(Transparent)
@test_throws MethodError colortype(Paint{U8})

@test basecolortype(RGBA{Float32}) == RGB
@test basecolortype(ARGB{Float32}) == RGB
@test basecolortype(BGR{U8})       == BGR
@test basecolortype(HSV)  == HSV
@test basecolortype(HSVA) == HSV
@test basecolortype(Transparent{RGB{Float64},Float64}) == RGB

@test basepainttype(RGBA{Float32}) == RGBA
@test basepainttype(ARGB{Float32}) == ARGB
@test basepainttype(BGR{U8})       == BGR
@test basepainttype(HSV)  == HSV
@test basepainttype(HSVA) == HSVA

@test ccolor(RGB{Float32}, HSV{Float32}) == RGB{Float32}
@test ccolor(RGB{U8},      HSV{Float32}) == RGB{U8}
@test ccolor(RGB,          HSV{Float32}) == RGB{Float32}
@test ccolor(ARGB{Float32}, HSV{Float32}) == ARGB{Float32}
@test ccolor(ARGB{U8},      HSV{Float32}) == ARGB{U8}
@test ccolor(ARGB,          HSV{Float32}) == ARGB{Float32}

# Traits for instances (and their constructors)
@test eltype(RGB{U8}(1,0,0)) == U8
@test eltype(RGB(1.0,0,0)) == Float64
@test eltype(ARGB(1.0,0.8,0.6,0.4)) == Float64
@test eltype(RGBA{Float32}(1.0,0.8,0.6,0.4)) == Float32

@test colortype(RGB{U8}(1,0,0)) == RGB{U8}
@test colortype(ARGB(1.0,0.8,0.6,0.4)) == RGB{Float64}
@test colortype(RGBA{Float32}(1.0,0.8,0.6,0.4)) == RGB{Float32}

@test basecolortype(RGB{U8}(1,0,0)) == RGB
@test basecolortype(ARGB(1.0,0.8,0.6,0.4)) == RGB
@test basecolortype(RGBA{Float32}(1.0,0.8,0.6,0.4)) == RGB

@test basepainttype(RGB{U8}(1,0,0)) == RGB
@test basepainttype(ARGB(1.0,0.8,0.6,0.4)) == ARGB
@test basepainttype(RGBA{Float32}(1.0,0.8,0.6,0.4)) == RGBA

# Constructors
for C in ColorTypes.parametric
    @test eltype(C{Float32}) == Float32
    et = (C <: AbstractRGB) ? U8 : Float32
    @test eltype(C(1,0,0)) == et
    @test colortype(C(1,0,0)) == C{et}
    @test colortype(C) == C
    @test colortype(C{Float32}) == C{Float32}
end

for (AC,C) in ((RGBA, RGB), (HSVA, HSV), (HSLA, HSL),
               (XYZA, XYZ), (xyYA, xyY), (LabA, Lab),
               (LCHabA, LCHab), (LuvA, Luv),
               (LCHuvA, LCHuv), (DIN99A, DIN99),
               (DIN99dA, DIN99d), (DIN99oA, DIN99o),
               (LMSA, LMS))
    @test eltype(AC{Float32}) == Float32
    @test colortype(AC) == C
    @test colortype(AC{Float32}) == C{Float32}
    @test colortype(AC{Float64}(1,0,0,1)) == C{Float64}
    @test coloralpha(C) == AC
    @test coloralpha(C{Float32}) == AC
end

iob = IOBuffer()
c = RGB{U8}(0.32218,0.14983,0.87819)
show(iob, c)
@test takebuf_string(iob) == "RGB{U8}(0.322,0.149,0.878)"
c = RGB{Ufixed16}(0.32218,0.14983,0.87819)
show(iob, c)
@test takebuf_string(iob) == "RGB{Ufixed16}(0.32218,0.14983,0.87819)"
c = RGBA{Ufixed8}(0.32218,0.14983,0.87819,0.99241)
show(iob, c)
@test takebuf_string(iob) == "RGBA{U8}(0.322,0.149,0.878,0.992)"
