

function main(input)
    global coordinates = [parse(Int, number) for line in input for number in split(line, ",")] |> (y -> reshape(y, :,3)) #|> stack |> permutedims # i want an array 3xN with the columns X,Y,Z
    


end








input = readlines(".\\data\\08_t.txt")
main(input)
