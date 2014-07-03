#!/usr/bin/env julia

## I had too much fun generating names.

using ArgParse
import Base.length
import Base.string
import Base.isless
using Debug

## Name methods
type Name
    chromosomes::Array{String}
    parents::Array{String}
    history::Array{String}
    fitness::Integer
end

type FullName
    names::Array{Name}
    fitness::Integer
end

## Constructors
Name(stuff::Array{String}) =  Name(stuff,
                                   String[],
                                   String[],
                                   0)

FullName(stuff::Array{Name}) = FullName(stuff, 0)

function mutate_population!(population::Array{FullName}, point_prob::FloatingPoint=0., swap_prob::FloatingPoint=0.)
    for ii in 1:length(population)
        for jj in 1:length(population[ii])
            if point_prob != 0.
                point_mutate!(population[ii][jj], point_prob)
            end
            if swap_prob != 0.
                swap_mutate!(population[ii][jj], swap_prop)
            end
        end
    end
    return population
end

function point_mutate!(name::Name, probability::FloatingPoint)
    letters = "abcdefghijklmnopqrstuvwxyz"
    for ii in 1:length(name.chromosomes)
        if rand() < probability
            name.chromosomes[ii] = randbool() ? Base.string(letters[rand(1:end)]) : ""
            ## println("Mutation.")
        end
    end
end

function swap_mutate!(name::Name, probability::FloatingPoint)
    left = rand(1:length(name))
    right = rand(1:length(name))
    name.chromosomes[left], name.chromosomes[right] = name.chromosomes[right], name.chromosomes[left]
end

function mate()
    return nothing
end

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

function mate(mates::FullName...)
    result = Array(Name, length(mates[1]))
    for ii in 1:length(result)
        result[ii] = mate([getindex(parent, ii) for parent in mates]...)            
    end
    return FullName(result)
end

## Fitness functions
function update_fitness!(name::Name, standard::Name)
    name.fitness = fitness(name, standard)
end

function update_fitness!(name::FullName, standard::FullName)
    for ii in 1:length(name)
        ## Iterate through the full name.
        update_fitness!(name[ii], standard[ii])
    end
    name.fitness = sum([subname.fitness for subname in name.names])
end

function update_population_fitness!(population::Array{FullName}, standard::FullName)
    for ii in 1:length(population)
        update_fitness!(population[ii], standard)
    end
end
    
function fitness(name::Name, standard::Name)
    ## Calculate the fitness of a name compared to a standard.
    ## @param name The name being evaluated.
    ## @param standard The name to be used for evaluating fitness.
    fitness_functions = Function[fitness_strings,
                                 fitness_shared,
                                 fitness_characters,
                                 ]
    return sum([fitness_function(name, standard) for fitness_function in fitness_functions])
end

function fitness_strings(name::Name, standard::Name)
    ## Test that the strings produced by the names match.
    return string(name) == string(standard) ? length(name) : 0
end

function fitness_shared(name::Name, standard::Name)
    ## Test how many characters the two names have in common.
    name_set = Set(name.chromosomes...)
    standard_set = Set(standard.chromosomes...)
    return length(intersect(name_set, standard_set))
end

function fitness_characters(name::Name, standard::Name)
    ## Test that the characters match or are of the same type.
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
    ## Determine if both characters are vowels, consonants, or empty strings.
    vowels = "aeiouy"
    if s1 == "" || s2 == ""
        return false
    end
    return contains(vowels, s1) == contains(vowels, s2)
end

## Name utility methods.
function length(name::Name)
    return Base.length(name.chromosomes)
end

function length(name::FullName)
    return Base.length(name.names)
end
    
function string(name::Name)
    return Base.string(join(name.chromosomes))
end

function string(name::FullName)
    return join([ucfirst(string(word)) for word in name.names], " ")
end

function getindex(name::Name, index::Integer)
    return name.chromosomes[index]
end

function getindex(name::FullName, index::Integer)
    return name.names[index]
end

function isless(left::Name, right::Name)
    return left.fitness < right.fitness
end

function isless(left::FullName, right::FullName)
    return left.fitness < right.fitness
end

## Static methods
function reproduce!(population::Array{FullName, 1}, mate_size::Integer)
    ## Populate the population array with new children.
    ## @param population The array containing all the FullNames.
    ## @param mate_size The number of participants in each mating (parents per children).
    shuffle!(population)
    children = Array(FullName, itrunc(length(population)/mate_size))
    ## println(length(children))
    ## println(length(1:mate_size:length(children)))
    for (jj,ii) in enumerate(1:mate_size:length(population))
        parents = population[ii:ii + mate_size - 1]
        child = mate(parents...)
        ## println(child)
        children[jj] = child
    end
    
    population = vcat(population, children)
    return population
end

function evolve!(population::Array{FullName, 1}, to_keep::Integer, standard::FullName)
    ## Sort everybody by fitness and get rid of the ones that aren't fit :(
    ## @param population Array of names to operate on.
    ## @param to_keep Number of names to keep.
    ## @param standard The name everyone should strive to be.
    sort!(population, rev=true)
    population = population[1:to_keep]
    return population
end

function generate_population(size::Integer,name_lengths::Array{Int, 1})
    ## Create a new population.
    ## @param size The number of things in the population.
    ## @param name_lengths An array that describes how many syllables each name should be.

    population = Array(FullName, size)

    for ii in 1:size
        population[ii] = FullName([generate_name(name_length) for name_length in name_lengths])
    end

    return population
end

function generate_name(size::Integer,method::Function=generate_syllable)
    return Name(vcat([method() for ii in 1:size]...))
end

function generate_syllable()
    vowels = "aeiouy"
    consonants = "bcdfghjklmnpqrstvwxyz"
    syllable = Array(String, 3)
    
    for ii in 1:length(syllable)
        if ii % 2 == 0
            syllable[ii] = string(vowels[rand(1:end)])
        else
            syllable[ii] = string(randbool() ? consonants[rand(1:end)] : "")
        end
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
