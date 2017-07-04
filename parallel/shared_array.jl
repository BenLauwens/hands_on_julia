const N = 64

a = SharedArray{Int}(N)
@sync @parallel for i=1:N
  a[i] = myid()
end
@show a