using BenchmarkTools


function main()
    input = "987654321111111
    811111111111119
    234234234234278
    818181911112111"
    input = read(".\\input3.txt", String);

    input_list = split(input, "\r\n")
    list_of_lists = [split(line,"") for line in input_list]

    int_list = [[parse(Int64,character) for character in list] for list in list_of_lists]

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

    




end


@benchmark(main())
#print(int_list)