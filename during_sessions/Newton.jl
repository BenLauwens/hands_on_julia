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

function newton_fractal(width, step)
    range = -width:step:width
    L = length(range)

    N = zeros(Complex{Float64}, L, L)
    
    for I in CartesianRange(size(N))
        a = range[I[1]]
        b = range[I[2]]

        z = b + a*im

        N[I] = do_newton(h, h′, z)

    end
    return N
end

M = newton_fractal(2.0,0.005)
@time M = newton_fractal(2.0,0.005)
