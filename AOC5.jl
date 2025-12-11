

function part1()
    mystring = "3-5
10-14
16-20
12-18

1
5
8
11
17
32"

    mystring = read(".\\data\\input5.txt", String);

    sep = "\r\n"

    IDs =  parse.(Int64, split(split(mystring, sep*sep)[2], sep))
    ranges = [parse.(Int64, split(range, "-")) for range in split(split(mystring, sep*sep)[1], sep)]
    #ranges_full = collect(Iterators.flatten([collect(range[1]:range[2]) for range in ranges]))


    summ = 0
    for ID in IDs
        for range in ranges
            if (range[1] <= ID <= range[2])
                summ += 1
                break
            end
        end
    end
    println(summ)
end

function part2()
    mystring = "1-5
    2-6
    1-7
    1-8
    5-10
    4-6
    16-16

1
5
8
11
17
32"
    sep = "\n"
    #mystring = read(".\\data\\05.txt", String);
    #sep = "\r\n"

    IDs =  parse.(Int64, split(split(mystring, sep*sep)[2], sep))
    ranges = [parse.(Int64, split(range, "-")) for range in split(split(mystring, sep*sep)[1], sep)]
    #make into array, probably faster
    ranges = reduce(vcat, transpose.(ranges))
    
    NN = size(ranges)[1]
    for ii = 1:NN
        if ranges[ii,2]<ranges[ii,1]
            println("ALARM")
        end
    end

    #Some ranges have overlap with over ranges. 
    #To solve this, we need to compare every range with every suceeding range and shorten it accordingly
    println("remove complete overlap")
    NN = size(ranges)[1]
    obsolete_idxs = []
    for ii = 1:NN
        for jj = 1:NN
            if jj !=ii  #dont compare with itself
                if ((ranges[jj,1] <= ranges[ii, 1] <= ranges[jj,2]) & (ranges[jj,1] <= ranges[ii, 2] <= ranges[jj,2])) #if one range is completly inside another range
                    push!(obsolete_idxs, ii)
                    break
                end
            end
        end
    end

    ranges = ranges[setdiff(1:end, obsolete_idxs), :]   #remove obsolete idxs
    #println(ranges)

    println("shrink arrays")
    NN = size(ranges)[1]
    for ii = 1:NN
        for jj = 1:NN
            if jj !=ii  #dont compare with itself
                if ranges[jj,1] < ranges[ii, 1] <= ranges[jj,2]  #same thing for end of range
                    ranges[ii,1] = ranges[jj,2] #
                    #println(ranges)
                end
                if ranges[jj,1] < ranges[ii, 2] <= ranges[jj,2]  #same thing for end of range
                    ranges[ii,2] = ranges[jj,1] #
                    #println(ranges)
                end
            end
        end
    end
    #println(ranges)
    println("Join Joining:")
    #now we just need to connect to ranges if they directly join
    NN = size(ranges)[1]
    obsolete_idxs = []
    for ii = 1:NN
        for jj = 1:NN
            if (jj!=ii) & (!(ii in obsolete_idxs))  #dont compare with itself
                if ranges[ii,2] == ranges[jj, 1]
                    ranges[ii,2] = ranges[jj,2] #array is enlarged to include the second one
                    push!(obsolete_idxs, jj)
                    #println(ranges)
                end
                if ranges[ii,1] == ranges[jj, 2]
                   ranges[ii,1] = ranges[jj,1] #array is enlarged to include the second one
                   push!(obsolete_idxs, jj)
                   #println(ranges)
                end
            end
        end
    end

    println("Remove again")
    #remove overlaps again
    NN = size(ranges)[1]
    obsolete_idxs = []
    for ii = 1:NN
        for jj = 1:NN
            if (jj!=ii) #dont compare with itself
                if ((ranges[jj,1] <= ranges[ii, 1] <= ranges[jj,2]) & (ranges[jj,1] <= ranges[ii, 2] <= ranges[jj,2])) #if one range is completly inside another range
                    push!(obsolete_idxs, ii)
                    break
                end
            end
        end
    end
    ranges = ranges[setdiff(1:end, obsolete_idxs), :]   #remove obsolete idxs
    println(ranges)

    println(sum(ranges[:,2]-ranges[:,1]) + size(ranges)[1])

end









part2()