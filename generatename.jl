#!/usr/bin/env julia

## I had too much fun generating names.


using ArgParse

type Name
    chromosomes
    parents
    history
    fitness::Integer
end

Name(stuff) =  (stuff,
                String[],
                String[],
                0)

function mutate!(name::Name, probability::FloatingPoint)
    letters = "abcdefghijklmnopqrstuvwxyz"
    vowels = "aeiouy"
    consonants = "bcdfghjklmnpqrstvwxyz"
    for ii in 1:length(name.chromosomes)
        for jj in 1:length(name.chromosomes[ii])
            if rand() < probability
                name.chromosomes[ii][jj] = randbool() ? Base.string(letters[rand(1:end)]) : ""
                println("Mutation.")
            end
        end
    end
end

function mate(left::Name, right::Name)
    result = Array(Array{String})
    smaller_name = left
    other_name = right
    if length(right) < length()
        smaller_name, other_name = right, left
    end
    while length(smaller_name) <= length(other_name)
        push!(smaller_name, generate_syllable())
    end
    while length(result) < length(left)
        push!(result, ["", "", ""])
    for ii in 1:length(left.chromosomes)
        for jj in 1:length(left.chromosomes[ii])
            chosen = randbool() ? left : right
            result[ii][jj] = chosen[ii][jj]
            end
        end
    end
    return 
end

function string(name::Name)
    result = String[]

    for chromosome in name.chromosomes
        push!(result, join(chromosome))
    end
    return join(result, " ")
end

function generate_name(range)
    vowels = "aeiouy"
    consonants = "bcdfghjklmnpqrstvwxyz"
    syllables = Array(String, rand(range))
    for ii in 1:length(syllables)
        syllables[ii] = string(randbool() ? consonants[rand(1:end)] : "",
                          vowels[rand(1:end)],
                          randbool() ? consonants[rand(1:end)] : "")
    end
    return ucfirst(string(syllables...))
end

function generate_syllable()
    vowels = "aeiouy"
    consonants = "bcdfghjklmnpqrstvwxyz"
    syllable = Array(String, 3)
    
    for ii in 1:length(syllable)
        syllable[ii] = string(randbool() ? consonants[rand(1:end)] : "",
                          vowels[rand(1:end)],
                          randbool() ? consonants[rand(1:end)] : "")
    end
    return syllable
end

function parsecmd()
settings = ArgParseSettings()
    settings.prog = "Name Generator"
    settings.description = "This program generates names."
    
    @add_arg_table settings begin
        "--number", "-n"
        help = "The number of names to generate."
        arg_type = Int
        default = 1000

        "--first-name-range", "-f"
        help = "The number of syllables the first name should be, minimum and maximum, inclusive"
        nargs = 2
        arg_type = Int
        default = [1,3]

        "--second-name-range", "-s"
        help = "The number of syllables the second name should be, minimum and maximum, inclusive"
        nargs = 2
        arg_type = Int
        default = [1,4]
    end
    return parse_args(settings)
end

function main()
    settings = parsecmd()
    number_of_entries = settings["number"]
    println(settings)

    first_name_range = settings["first-name-range"][1]:settings["first-name-range"][2]
    second_name_range = settings["second-name-range"][1]:settings["second-name-range"][2]
    

    for ii in 1:number_of_entries
        println(string(generate_name(first_name_range), " ", generate_name(second_name_range)))
    end
    
end
