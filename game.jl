#/usr/bin/env julia

include("generatename.jl")
include("InputStuff.jl")
using InputStuff

function name_evolution()
    size = input_int("Population size: ",true)
    mate_size = 0

    number_names = input_int("How many subnames per name? ",true)

    name_array = Array(Int, number_names)
    
    for ii in 1:number_names
        name_array[ii] = input_int("How many syllables for name $(ii)?",true)
    end
    
    while true
        mate_size = input_int("Parents per offspring: ",true)
        if size % mate_size != 0
            println("Population size ($(size)) must be divisible by parents per offspring.")
            continue
        end
        break
    end

    function save_population()
        writedlm(input("File to save to: "),
                 [string(name) for name in population],
                 '\n')
    end

    function next_generation()
        population = reproduce!(population, mate_size)
        
        sample_size = input_int("Sample size: ", true)
        the_sample = sample(population,sample_size,false)
        standard = the_sample[input_choose(the_sample,"Pick a name: ")]
        
        update_population_fitness!(population,standard)
        population = evolve!(population, size, standard)
    end

    function show_top()
        wanted = input_int("How many? ",true)
        println([string(name) for name in population[1:wanted]])
    end

    function not_found()
        println("Command not found.")
    end

    cmd_dict = Dict{String,Function}()

    cmd_dict = [
                "save"=>save_population,
                "next"=>next_generation,
                "top"=>show_top,
                "quit"=>quit
                ]
    population = generate_population(size, name_array)
    
    while true
        get(cmd_dict, input("> "), not_found)()
    end
end

name_evolution()
        
