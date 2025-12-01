#Advent of Code 1


#Data import
pwd();
mystring = read("C:\\Users\\KaareIngwersen\\OneDrive - AERO MATERIALS GmbH\\Dokumente\\Julia Code\\AOC Inputs\\1.txt", String);
print(mystring[1:4]);


#Data parsing
#split into a list of strings
stringlist = split(mystring, "\r\n");
#print(stringlist[1:4]);


#we dont need overflow math if we just start with a very large value and only focus on the last two digits
#calculate save large value by adding all the numbers

NN = length(stringlist)
my_int_list = Array{Int64}(undef,NN)

#print(my_int_list)

for i in 1:NN
    substring = stringlist[i][2:end]
    #println(substring)
    myint = parse(Int64, substring)
    my_int_list[i] = myint
end

mysum = sum(my_int_list)
println(mysum)

start = 1e6+50
counter = 0
#logic

for i in 1:NN
    substring = stringlist[i][2:end]
    direction = stringlist[i][1]
    myint = parse(Int64, substring)

    if (direction=='R')
        global start = start+myint
    elseif (direction=='L')
        global start = start-myint
    else
        println("ERROR")
        println(direction)
    end

    println(start)
    #check if dial is at zero
    #divide by 100 and see remainder
    if ((start%100)==0)
        global counter = counter + 1
    end
end
println(start)
println(counter)


#part two
start = 1e6+50
counter = 0
#logic

for i in 1:NN
    substring = stringlist[i][2:end]
    direction = stringlist[i][1]
    myint = parse(Int64, substring)

    #part two change: Treat R45 as 45 single operations

    for j in 1:myint
        if (direction=='R')
            global start = start+1
        elseif (direction=='L')
            global start = start-1
        else
            println("ERROR")
            println(direction)
        end

        #check if dial is at zero
        #divide by 100 and see remainder
        if ((start%100)==0)
            global counter = counter + 1
        end
    end
end

println("Part two")
println(start)
println(counter)