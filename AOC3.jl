using BenchmarkTools


function main()
    #input = "987654321111111\r\n811111111111119\r\n234234234234278\r\n818181911112111"
    input = read(".\\input3.txt", String);

    input_list = split(input, "\r\n")
    list_of_lists = [split(line,"") for line in input_list]

    int_list = [[parse(Int64,character) for character in list] for list in list_of_lists]

    #part one
    summ = 0
    for line in int_list
        #find the largst value, excluding the last digit
        #This will be the first digit of the final number
        largest_idx = argmax(line[1:end-1])
        first_digit = line[largest_idx]
        #println(first_digit)
        #the second digit will be the largest after the first digit:
        second_idx = argmax(line[largest_idx+1:end])
        second_digit = line[largest_idx+1:end][second_idx]
        #println(second_digit)
        summ = summ+first_digit*10+second_digit
    end
    println(summ)

    #part two
    summ2 = 0
    #do the same thing as above, but for 12 digits and not for 2
    for line in int_list
        idxs = [12,11,10,9,8,7,6,5,4,3,2,1]
        largest_idxs = zeros(12)
        largest_digits = zeros(12)
        last_largest_idx = 0

        for i = 1:12
            #println(last_largest_idx)
            idx = idxs[i]
            cut_line = line[(1+last_largest_idx):(end-idx+1)]
            largest_idx = argmax(cut_line)
            #println(cut_line)
            largest_digits[i] = cut_line[largest_idx]
            last_largest_idx = largest_idx+last_largest_idx
            summ2 = summ2+largest_digits[i]*10^(idx-1)
        end
        #println(largest_digits)
    end
    println(summ2)

end


@benchmark(main())
#main()