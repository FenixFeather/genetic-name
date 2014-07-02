#!/usr/bin/env julia
## Some input functions.

module InputStuff

export input, input_int, input_choose

function input(prompt::String="")
    print(prompt)
    return chomp(readline())
end

function input_int(prompt::String="",natural::Bool=false)
    result = 0
    while true
        try
            print(prompt)
            stuff = strip(chomp(readline()))
            result = parseint(stuff)
            if natural && result <= 1
                throw(DomainError())
            end
            break
        catch e
            if isa(e, DomainError)
                println("Not a natural number.")
            else
                println("Not an integer.")
            end
            continue
        end
    end
    return result
end

function input_choose(choices::Array, prompt::String="", list_choices=true)
    if list_choices
        for (index,choice) in enumerate(choices)
            println("$(index). $(string(choice))")
        end
    end
    index = 1
    while true
        try
            index = input_int(prompt)
            choices[index]
            break
        catch
            println("Not a valid choice.")
            continue
        end
    end
    return index
end
    
end
