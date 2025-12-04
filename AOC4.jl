using BenchmarkTools



function readinput()
    mystring = "..@@.@@@@.
@@@.@.@.@@
@@@@@.@.@@
@.@@@@..@.
@@.@@@@.@@
.@@@@@@@.@
.@.@.@.@@@
@.@@@.@@@@
.@@@@@@@@.
@.@.@@@.@."

    mystring = read(".\\input4.txt", String);

    stringlist = split(mystring, "\r\n")
    #println(stringlist)
    
    #convert to array
    horizontal = length(stringlist[1])
    vertical = length(stringlist)

    myarray = Array{Bool}(undef,vertical,horizontal)

    for i = 1:vertical
        #println(stringlist[i])
        for j = 1:horizontal
            #println(stringlist[i][j])
            myarray[i,j] = ('@'==stringlist[i][j])
        end
    end
    #println(myarray)
    return myarray
end


function add_padding(myarray)

    vert_pad = falses(size(myarray,1),1)
    hoz_pad = falses(1,size(myarray, 2)+2)

    myarray = [vert_pad myarray vert_pad]
    myarray = [hoz_pad;myarray;hoz_pad]

    return myarray
end

function run_filter(myarray)
    #for each element thats true in the original matrix, add the values of all sourrounding elements
    #its easier to just add all 9
    threshold = 4
    vert = size(myarray,1)
    hoz = size(myarray,2)
    filterarray = zeros(vert, hoz) 

    for i = 2:vert-1
        for j = 2:hoz-1
            summ = 0
            if myarray[i,j]
                filterarray[i,j] = ((sum(myarray[i-1:i+1,j-1:j+1]))<5)
            end
        end
    end
    return filterarray
end


function remove_rolls(myarray, filterarray)
    #new_array = myarray-filterarray
    #new_array = Bool.(new_array)
    new_array = xor.(myarray, Bool.(filterarray))   #a little faster this way
    return new_array
end

function part_one(myarray)
    myarray = add_padding(myarray)
    filterarray = run_filter(myarray)
    return sum(filterarray)
end

function part_two(myarray)

    myarray = add_padding(myarray)

    overall_score = 0
    canberemoved=1

    while canberemoved!=0
        #see which rolls can be removed
        filterarray = run_filter(myarray)
        #calculate how many rolls can be removed
        canberemoved = sum(filterarray)
        #add rolls that can be removed to overall score
        overall_score = overall_score + canberemoved
        #remove the rolls
        new_array = remove_rolls(myarray, filterarray)
        #prepare for next round
        myarray = new_array
        #println(canberemoved)
    end
    return overall_score
end

function combined()
    myarray = readinput()
    part_one(myarray)
    part_two(myarray)
end



myarray = readinput()
print("Part One: ")
println(part_one(myarray))

print("Part Two: ")
println(part_two(myarray))



#@benchmark(readinput()) #118 µs mean
#@benchmark(part_one(readinput())) #750 µs mean
#@benchmark(part_two(readinput())) #18 ms median
#@benchmark(combined())  #16 ms mean