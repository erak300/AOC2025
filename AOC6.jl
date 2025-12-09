using BenchmarkTools

function readinput()
    mystring = "123 328  51 64 
 45 64  387 23 
  6 98  215 314
*   +   *   +  "

    mystring = read(".\\data\\06.txt", String);
    sep = "\n"
    sep = "\r\n"

    #part 1
    stringlist = split(mystring, sep)
    operators = split(stringlist[end])
    numbers = [split(string) for string in stringlist[1:end-1]]

    numbers_matrix = zeros(Int64, length(numbers), length(numbers[1]))
    for i=1:length(numbers)
        for j = 1:length(numbers[1])
            numbers_matrix[i,j] = parse(Int64, numbers[i][j])
        end
    end

    #part 2
    digits = get_digits(stringlist[end])    #construct a list with the number of digits for each problem
    # this we can now use to parse the second part:
    # create a big array containing the entire input string
    char_array = Array{Char}(undef, length(stringlist)-1, length(stringlist[1]))
    for ii = 1:size(char_array)[1]
        for jj = 1:size(char_array)[2]
            char_array[ii,jj] = stringlist[ii][jj]
        end
    end
    return numbers_matrix, operators, char_array, digits
end


function get_digits(operators_long)
    #for a operator string "+  * +  *  *  " find the number of whitespaces after each operator
    #this gives us vital information about the number of digits in this problem
    counter = 1
    digits = collect(Int64, [])
    for char in operators_long[2:end]
        if char != ' '
            push!(digits, counter)
            counter = 0
        end
        counter += 1
    end
    push!(digits, counter+1)    #last one needs one more
    return digits
end


function part1(numbers_matrix, operators)
    NN = length(operators)
    results=[]
    for ii=1:NN
        if operators[ii]=="+"
            push!(results, sum(numbers_matrix[:,ii]))
        end
        if operators[ii]=="*"
            push!(results, prod(numbers_matrix[:,ii]))
        end
    end
    println("Part 1:")
    println(sum(results))
end

function part2(char_array, digits, operators)
    #from the length of the digits, construct indices for problems
    end_idxs = cumsum(digits)
    start_idxs = end_idxs-digits.+1

    results = []
    for ii = 1:length(start_idxs)
        #split into problems first
        problem = char_array[:,start_idxs[ii]:end_idxs[ii]-1]
            #now parse the numbers
            numbers = []
            for jj = 1:size(problem)[2]
                mystring = reduce(*, problem[:,jj])
                push!(numbers, parse(Int64, mystring))
            end

            #now do the math
            if operators[ii]=="+"
                push!(results, sum(numbers))
            end
            if operators[ii]=="*"
                push!(results, prod(numbers))
            end
    end
    println("Part 2")
    println(sum(results))
end


function wrapper()
    numbers_matrix, operators, char_array, digits = readinput()
    #char_array
    part2(char_array, digits, operators)
    part1(numbers_matrix, operators)
end
@benchmark(wrapper())
