@everywhere begin

newton(f, f′, x) = x - f(x) / f′(x)

@inline function do_newton(g, g′, x0)
    x = x0

    tolerance = 1e-15
    while abs(g(x)) > tolerance
        x = newton(g, g′, x)
    end
    
    return x
end

h(z) = z^3 - 1
h′(z) = 3z^2

end

function newton_fractal(width, step)
    range = -width:step:width
    L = length(range)

    N = SharedArray{Complex{Float64}}(L, L)
    
    @sync @parallel for i=1:L
        for j in 1:L
            a = range[i]
            b = range[j]

            z = b + a*im

            N[i,j] = do_newton(h, h′, z)
        end
    end
    return N
end

M = newton_fractal(2.0,0.05)
@time M = newton_fractal(2.0,0.002)

using PyCall
@pyimport matplotlib as mpl
mpl.use("Agg")
using Plots
pyplot()

heatmap(imag(M),aspect_ratio=1,color=:viridis)
savefig("newton.png")