#!/usr/bin/env julia
## Some input functions.

module InputStuff

export input, input_int, input_string, input_choose, input_number, output_list, sample

function input(prompt::String="")
    print(prompt)
    return chomp(readline())
end

function input_int(prompt::String="",natural::Bool=false,range::Range1=0:0)
    result = 0
    
    if range != 0:0
        natural = false
    end
    
    while true
        try
            result = parseint(input(prompt))
            if (
                (natural && result <= 1) ||
                (range != 0:0 && !in(result, range))
                )
                range_message = "Must be between $(range[1]) and $(range[end])."
                natural_message = natural ? "Must be natural." : ""
                println("Out of range. $(range != 0:0 ? range_message : natural_message)")
                continue
            end
            break
        catch e
            println("Not an integer.")
            continue
        end
    end
    return result
end

function input_number(prompt::String="", left::Number=0, right::Number=0)
    result = 0
    while true
        try
            result = parsefloat(input(prompt))
            if left != right && !(left <= result <= right)
                throw(DomainError())
            end
            break
        catch e
            if isa(e, DomainError)
                println("Not between $(left) and $(right).")
            else
                println("Not a valid number.")
            end
            continue
        end
    end
    return result
end

function input_string(prompt::String="", validate_function::Function=x->true, e::String="Invalid.")
    result = ""
    while true
        result = input(prompt)
        if validate_function(result)
            return result
        end
        println(e)
    end
end
                

function input_choose(choices::Array, prompt::String="", list_choices=true)
    if list_choices
        output_list(choices::Array)
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

function output_list(choices::Array)
    for (index,choice) in enumerate(choices)
        println("$(index). $(string(choice))")
    end
end

function sample(population::Array, sample_size::Integer, replace::Bool)
    sampled = Set{Integer}()
    result = Array(typeof(population[1]), sample_size)
    for ii in 1:sample_size
        while true
            next_index = rand(1:length(population))
            if replace || !in(next_index,sampled)
                push!(sampled, next_index)
                result[ii] = population[next_index]
                break
            end
        end
    end
    return result
end

end
