using BenchmarkTools



function read_input()
    mystring = read(".\\input2.txt", String);
    #convert to two lists
    stringlist = split(mystring,",")
    #print(stringlist)

    NN=length(stringlist)

    startarray = zeros(Int64, NN)
    endarray = zeros(Int64,NN)

    for i=1:NN
        myarray = split(stringlist[i],"-")
        startarray[i] = parse(Int64, myarray[1])
        endarray[i] = parse(Int64, myarray[2])
    end        
    #println(startarray)
    #println(endarray)
    return startarray, endarray, NN

end

function check_digits(startarray, endarray, NN)
    #make a list of the number of digits of the start and end values, and their difference

    start_digits = zeros(Int64, NN)
    end_digits=zeros(Int64, NN)
    diff_digits=zeros(Int64, NN)


    for i = 1:NN
        start_digits[i] = ndigits(startarray[i], base=10)
        end_digits[i] = ndigits(endarray[i], base=10)
    end
    diff_digits = end_digits .- start_digits
    return start_digits, end_digits, diff_digits
end

function drop_uneven(start_digits, end_digits, startarray, endarray, NN)
    #in cases where both start and end number of digits are uneven, drop those
    toDrop = (.!(iseven.(start_digits)) .& .!(iseven.(end_digits)))

    startarray_s = startarray[.!toDrop]
    endarray_s = endarray[.!toDrop]
    start_digits_s = start_digits[.!toDrop]
    end_digits_s =  end_digits[.!toDrop]

    NN_s = length(startarray_s)

    #in cases where only start is uneven, replace with lowest number of next decimal thing
    #in cases where only end is uneven, replace e.g. 13456 with 9999
    for i=1:NN_s
        if !iseven(start_digits_s[i])
            startarray_s[i] = 10^(end_digits_s[i]-1)    #e.g. replace 123 with 1000
        elseif !iseven(end_digits_s[i])
            endarray_s[i] = 10^(start_digits_s[i])-1    #e.g. replace 12345 with 9999
        end
    end

    #Now, start and end digits are equal. create new array:
    combined_digits = zeros(Int64, NN)
    for i=1:NN_s
        combined_digits[i] = ndigits(startarray_s[i], base=10)
    end
    return startarray_s, endarray_s, combined_digits, NN_s
end


function smart(startarray_s, endarray_s, combined_digits, NN_s)
    #all false IDs are of the form abcd-abcd
    #the first step is to split the start integer in half to create the first half and the second half
    #make a list of all possible false IDs by permutation of the digits
    #cut all values in that list that are smaller than the start integer and larger than the end integer
        #could probably increase performance by not doing all the permutations

   
    for i:NN_s
        #make permutation list
        string(startarray_s[i])[1:combined_digits[i]÷2]

end


function bruteforce(startarray_s, endarray_s, combined_digits, NN_s)
    #for each array, make a for loop, generating the numbers between start and end array
    #check if false ID and add if it is
    #for checking, convert to string and see if first half equals second half

    summ = 0
    for i = 1:NN_s
        for number = startarray_s[i]:endarray_s[i]
            if string(number)[1:combined_digits[i]÷2]==string(number)[combined_digits[i]÷2+1:end]
                summ = summ+number
            end
        end
    end
    println("Answer part 1")
    println(summ)
end


function main()
    startarray, endarray, NN = read_input()
    start_digits, end_digits, diff_digits = check_digits(startarray, endarray, NN)
    #print(diff_digits)
    startarray_s, endarray_s, combined_digits, NN_s = drop_uneven(start_digits, end_digits, startarray, endarray, NN)
    bruteforce(startarray_s, endarray_s, combined_digits, NN_s)
end



main()
#@benchmark(main())