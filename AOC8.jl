using BenchmarkTools

function main(input)
    global coordinates = [parse(Int, number) for line in input for number in split(line, ",")] |> (y -> reshape(y, 3,:)') #i want an array 3xN with the columns X,Y,Z
    global distances, pairs = calculate_distances(coordinates)

    global sorted_IDs = sortperm(distances)
    global pairs_sorted = pairs[sorted_IDs]

    global nets1 = constructNets(pairs_sorted, 1000, false)
    part1 = prod(length.(nets1[1:3]))

    global last_added_ID = constructNets(pairs_sorted, 10000, true)
    part2 = coordinates[last_added_ID[1], 1]*coordinates[last_added_ID[2], 1]

    return part1, part2
end

function calculate_distances(coordinates)
    # calculate the distance between every coordinate pair, also return similar matrix of the IDs
    NN = size(coordinates)[1]
    KK = sum(1:(NN-1))
    distances = zeros(KK)   #init array
    pairs = fill((0,0), KK)
    kk = 1
    for ii = 1:(NN-1)
        for jj = (ii+1):NN  #we don't need to calculate the same distance twice
            distances[kk] = coordinates[ii, :].-coordinates[jj, :] |> (x->x.^2) |> sum |> sqrt
            pairs[kk] = (ii,jj)
            kk += 1
        end
    end
    return distances, pairs
end

function constructNets(sorted_pairs, NN, untilEnd=false)
    #Take a vector of sorted ID pairs (tuples) and add them to nets (sets)
    #For each new ID pair, see if either of its IDs already is in a set. If yes, add to this set. If not, make new set.
    #we have an unknown number of sets with an unknown number of members. Difficult to initialize and potentially slow, but think about that later
    nets = [Set((0,-1)) for pair in sorted_pairs]
    nets[1] = Set(sorted_pairs[1])
    NNnets = 1
    ac1 = 0
    ac2 = 0
    if untilEnd; NN=length(sorted_pairs);end #for part 2, essentially make a while loop
    for IDpair in sorted_pairs[1:NN]
        ac1 = 0
        ac2 = 0
        for ii = 1:NNnets   #check if any of them are in any nets
            if (IDpair[1] in nets[ii]); ac1=ii; end
            if (IDpair[2] in nets[ii]); ac2=ii; end
        end
        if ac1 > ac2 && ac2==0
             push!(nets[ac1], IDpair[1], IDpair[2])  #add to first set
                if untilEnd
                    if length(nets[ac1])==1000; return IDpair; end
                end
        elseif ac1 < ac2 && ac1==0
             push!(nets[ac2], IDpair[1], IDpair[2])   #add to second set
                if untilEnd
                    if length(nets[ac2])==1000; return IDpair; end
                end
        elseif ac2==0 && ac1==0; nets[NNnets+1] = Set(IDpair);NNnets+=1; #make new net
        elseif ac1==ac2 && ac1>0 #this means they are both already in the same set, do nothing
        elseif ac1!=ac2 && ac1>0 && ac2>0
            union!(nets[ac1], nets[ac2])
            nets[ac2] = Set()
        else
            println("Warning")
        end


        #println(IDpair)
        #println(nets[1:5])
    end

    #sort the nets for length
    setlengths = [length(net) for net in nets]
    nets = nets[sortperm(setlengths, rev=true)]

    return nets
end





input = readlines(".\\data\\08.txt")
main(input)

@benchmark(main(input))