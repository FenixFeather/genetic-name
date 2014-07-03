#/usr/bin/env julia

include("generatename.jl")
include("InputStuff.jl")
using InputStuff

function name_evolution()
    size = input_int("Population size: ",true)
    mate_size = 0

    number_names = input_int("How many subnames per name? ",true)

    name_array = Array(Int, number_names)
    prob_dict = [
                 "None"=>0.0,
                 "Low"=>0.001,
                 "Medium"=>0.01,
                 "High"=>0.1,
                 "Custom"=>4.2
                 ]
    
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

    point_prob = 0.0
    swab_prob = 0.0

    choices = collect(keys(prob_dict))
    choice = input_choose(choices, "Probability of point mutation: ")
    if prob_dict[choices[choice]] > 1.0
        point_prob = input_number("Enter custom decimal: ", 0.0, 1.0)
    else
        point_prob = prob_dict[choices[choice]]
    end

    choice = input_choose(choices, "Probability of swap mutation: ")
    if prob_dict[choices[choice]] > 1.0
        swap_prob = input_number("Enter custom decimal: ", 0.0, 1.0)
    else
        swap_prob = prob_dict[choices[choice]]
    end


    function save_population()
        writedlm(input("File to save to: "),
                 [string(name) for name in population],
                 '\n')
    end

    function next_generation()
        population = reproduce!(population, mate_size)
        population = mutate_population!(population,point_prob,swap_prob)
        
        sample_size = input_int("Sample size: ", false,1:length(population))
        the_sample = sample(population,sample_size,false)
        standard = the_sample[input_choose(the_sample,"Pick a name: ")]
        
        update_population_fitness!(population,standard)
        population = evolve!(population, size, standard)
    end

    function next_generation_custom()
        population = reproduce!(population, mate_size)
        population = mutate_population!(population,point_prob,swap_prob)

        subnames = Array(Name, length(population[1]))

        for ii in 1:length(subnames)
            println("Enter characters for subname $(ii).")
            subnames[ii] = input_name(length(population[1][ii]))
        end
        
        standard = FullName(subnames)

        update_population_fitness!(population,standard)
        population = evolve!(population, size, standard)
    end

    function show_top()
        wanted = input_int("How many? ",false,1:length(population))
        println([string(name) for name in population[1:wanted]])
    end

    function show_history()
        wanted = input_int("Which name (enter number according to top)? ",false,1:length(population))
        for (ii,name) in enumerate(population[wanted].names)
            println("History of subname $(ii):")
            output_list(name.history)
        end
    end
    
    function not_found()
        println("Command not found.")
    end

    cmd_dict = Dict{String,Function}()

    cmd_dict = [
                "save"=>save_population,
                "next"=>next_generation,
                "nextc"=>next_generation_custom,
                "history"=>show_history,
                "top"=>show_top,
                "quit"=>quit
                ]
    population = generate_population(size, name_array)
    
    while true
        get(cmd_dict, input("> "), not_found)()
    end
end

name_evolution()
        
