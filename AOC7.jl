using BenchmarkTools


function ReadInput()
    mystring = ".......S.......
...............
.......^.......
...............
......^.^......
...............
.....^.^.^.....
...............
....^.^...^....
...............
...^.^...^.^...
...............
..^...^.....^..
...............
.^.^.^.^.^...^.
..............."

    mystring = read(".\\data\\07.txt", String);
    sep = "\n"
    sep = "\r\n"

    stringlist = split(mystring, sep)
    #for effiency, make all the arrays just bool
    YY = length(stringlist)
    XX = length(stringlist[1]) 
    rays = falses(YY, XX)
    rays[1,:] = [char=='S' for char in stringlist[1]]
    dividers = falses(YY,XX)
    for ii = 1:YY
        dividers[ii,:] = [char=='^' for char in stringlist[ii]]
    end
    return rays, dividers
end


function Part1(rays, dividers)
    #start the simulation. We need one step less than there are lines in the original array, but start at 2
    # could be made more efficiently by looking at the input and realizing that each second row contains no splitters
    steps = size(rays)[1]
    cols = size(rays)[2]
    splits = 0
    for step in 2:steps
        for col = 1:cols
            #If there is a ray above 
            if rays[step-1, col]
                if !dividers[step, col] #and no divider
                    rays[step, col]=1   #extend ray
                else    #split ray
                    rays[step, col-1]=1 #we probably will get a problem at the edges, just add padding above
                    rays[step, col+1]=1
                    splits += 1
                end
            end
        end
    end
    #println("Part 1")
    #println(splits)
end


function Part2(rays, dividers)
    # I want to solve this using a random approach: At each split, the choice between left and right is made at random
    # The resulting path is stored and added to a set
    # Run until no new path is added for some amount of time
    # Efficient way to store the paths: For each split, record wether left (1) or right (0) was chosen. Save as integer
        # There are ~70 splits, so 64 bit integer will not be enough. Is there 128 bit integer in julia?
            #Yes, there is!
    # Estimation of number of possible pathways:
        # If there are 70 possible splits, we have 2^70 possibilties!
            #thats 1e21. With 128 bit integers, we need 1e21*128 bits of storage, or 18 billion Terrabyte. IDK about that.

    # This needs to be solved more smartly. What we have is a baumdiagramm, and the number of possible paths should be easy to calculate.
    # The difdiculty comes from the fact that the baumdigramm is inperfect, and some spots are missing. Will think about that later.
        # In a perfect Tree diagram, the number of possible paths is just 2^N for N number of splits.
    # In each row, each splitter adds 2*K number of paths, with K being the nuumber of paths going into the splitter
        # To keep track of the number of paths that are parallel for a given point, dont use 1s to represent a path
        # Instead use integers, where you just add the numbers if two parts meet
    # In this way, we just have to add all the integers in the last row!
    steps = size(rays)[1]
    cols = size(rays)[2]
    rays_int = convert(Matrix{Int128}, rays)

    for step in 2:steps
        for col = 1:cols
            #If there is a ray above 
            if (rays_int[step-1, col] != 0)
                if !dividers[step, col] #and no divider
                    rays_int[step, col]+=rays_int[step-1, col]   #extend ray downwards and add to possibly existing
                else    #split ray and add to existing number of rays
                    rays_int[step, col-1]+=rays_int[step-1, col] #we probably will get a problem at the edges, just add padding above
                    rays_int[step, col+1]+=rays_int[step-1, col]
                end
            end
        end
    end

    #println("Part 2")
    #println(sum(rays_int[end,:]))
    return(rays_int)
end



function wrapper()
    rays, dividers = ReadInput()
    Part1(rays, dividers);

    rays, dividers = ReadInput()
    Part2(rays, dividers);
end


#wrapper()
@benchmark(wrapper())