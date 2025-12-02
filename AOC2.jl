using BenchmarkTools



function read_input()
    mystring = read(".\\input2.txt", String);

    #mystring="11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124"

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





function bruteforce(startarray_s, endarray_s, combined_digits, NN_s)
    #for each array, make a for loop, generating the numbers between start and end array
    #check if false ID and add if it is
    #for checking, convert to string and see if first half equals second half
        #would probably be much faster to do without string conversion
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


function partTwo_Bruteforce(startarray, endarray, start_digits, end_digits, NN)
    #here, we can't use any of our tricks. 

    #algorithm for finding repeating pattern: take first digit and see if second one matches. If so, see if third one matches and so fourth
    #After that take the first two digits and see if the next two digits match etc. 
    #this will all be easier with strings, unfortunately
    summ=0
    for i=1:NN
        #print("i:")
        #println(i)
        for number in startarray[i]:endarray[i]
            digits = ndigits(number)
            mystring = string(number)
            #println(number)
            flag = false #this is needed to not count a number twice, e.g. 2222 
            for j=1:digits÷2 #this loop controls the number of digits to compare. For 9, the max number is 4. for 10, its 5
                if (digits%j==0)&(flag==false)  #only run the next loop if number of digits to compare cleanly fits into the number
                    comparisons = digits÷j-1
                    istrue=true
                    k=1
                    while (k<=comparisons) & (istrue)
                        #println(mystring[1:j])
                        #println(mystring[j*k+1:j*(k+1)])
                        if ((mystring[1:j])!=(mystring[j*k+1:j*(k+1)]))
                            istrue=false
                            #println("shouldbefalse")
                        end
                        k = k+1
                    end
                    if istrue   #the number is invalid
                        #print("j:")
                        #println(j)
                        #println(number)
                        summ = summ+number
                        flag = true #set true to not count a number twice
                    end
                end
            end
        end
    end
    println("Part Two:")
    println(summ)
end


function main()
    startarray, endarray, NN = read_input()
    start_digits, end_digits, diff_digits = check_digits(startarray, endarray, NN)
    #print(diff_digits)
    startarray_s, endarray_s, combined_digits, NN_s = drop_uneven(start_digits, end_digits, startarray, endarray, NN)
    bruteforce(startarray_s, endarray_s, combined_digits, NN_s)
    partTwo_Bruteforce(startarray, endarray, start_digits, end_digits, NN)
end



#main()
@benchmark(main())