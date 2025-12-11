using BenchmarkTools

function main(input)
    global cds = [parse(Int, number) for line in input for number in split(line, ",")] |> (y -> reshape(y, 2,:)') #i want an array 3xN with the columns X,Y,Z
    max = 0
    NN = size(cds)[1]
    for ii = 1:NN-1
        for jj = ii:NN
            size = ((abs(cds[ii,1]-cds[jj,1])+1)*(abs(cds[ii,2]-cds[jj,2])+1))
            if size>max; max = size; end
        end
    end
    return max
end



input = readlines(".\\data\\09_t.txt")
main(input)

#@benchmark(main(input))