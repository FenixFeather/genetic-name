#!/usr/bin/env julia

## I had too much fun generating names.


using ArgParse
import Base.length

## Name methods
type Name
    chromosomes::Array{String}
    parents::Array{String}
    history::Array{String}
    fitness::Integer
end

Name(stuff) =  Name(stuff,
                String[],
                String[],
                0)

function mutate!(name::Name, probability::FloatingPoint)
    letters = "abcdefghijklmnopqrstuvwxyz"
    vowels = "aeiouy"
    consonants = "bcdfghjklmnpqrstvwxyz"
    for ii in 1:length(name.chromosomes)
        if rand() < probability
            name.chromosomes[ii] = randbool() ? Base.string(letters[rand(1:end)]) : ""
            println("Mutation.")
        end
    end
end

## function mate(left::Name, right::Name)
##     result = Array(Array{String})
##     smaller_name = left
##     other_name = right
##     if length(right) < length()
##         smaller_name, other_name = right, left
##     end
##     while length(smaller_name) <= length(other_name)
##         push!(smaller_name.chromosomes, generate_syllable())
##     end
##     result[1] = ["", "", ""]
##     while length(result) < length(left)
##         push!(result, String["", "", ""])
##     end
##     for ii in 1:length(left.chromosomes)
##         for jj in 1:length(left.chromosomes[ii])
##             chosen = randbool() ? left : right
##             result[ii][jj] = chosen[ii][jj]
##             end
##         end
##     end
##     return Name(result)
## end

function mate(mates::Name...)
    result = Array(String, length(mates[1].chromosomes))
    for ii in 1:length(result)
        result[ii] = mates[rand(1:end)].chromosomes[ii]
    end
    random_parent = mates[rand(1:end)]
    return Name(result,
                String[string(mate) for mate in mates],
                push!(deepcopy(random_parent.history), string(random_parent)),
                0)
end

## Fitness functions
function fitness(name::Name, standard::Name)
    ## Calculates the fitness of a name compared to a standard.
    ## @param name The name being evaluated.
    ## @param standard The name to be used for evaluating fitness.
    fitness_functions = Function[fitness_strings,
                                 fitness_shared,
                                 fitness_characters,
                                 ]
    return sum([fitness_function(name, standard) for fitness_function in fitness_functions])
end

function fitness_strings(name::Name, standard::Name)
    ## Tests that the strings produced by the names match.
    return string(name) == string(standard) ? length(name) : 0
end

function fitness_shared(name::Name, standard::Name)
    ## Tests how many characters the two names have in common.
    name_set = Set(name.chromosomes...)
    standard_set = Set(standard.chromosomes...)
    return length(intersect(name_set, standard_set))
end

function fitness_characters(name::Name, standard::Name)
    ## Tests that the characters match or are of the same type.
    total = 0
    for ii in 1:length(name)
        if name[ii] == standard[ii]
            total += 2
        elseif same_type(name[ii], standard[ii])
            total += 1
        end
    end
    return total
end

function same_type(s1::String, s2::String)
    ## Determines if both characters are vowels, consonants, or empty strings
    vowels = "aeiouy"
    if s1 == s2
        return 1
    elseif contains(vowels, s1[1]) && contains(vowels, s2[1])
        return 1
    elseif s1[1] != "" && s2[1] != ""
        return 1
    end
    return 0
end

## Name utility methods.
function length(name::Name)
    return (name.chromosomes)
end

function string(name::Name)
    return Base.string(join(name.chromosomes))
end

## Static methods
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
