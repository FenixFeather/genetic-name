#!/usr/bin/env julia

## Tests for the genetic name generator.
import Base.string
module Tests

using UnitTest

export test_string,
test_mutate,
test_mate,
test_history,
test_fitness_strings,
test_fitness_shared,
test_fitness_characters,
test_same_type,
test_fitness

function setup(env::Dict{String,Any})
    env["fixtures"] = Dict{String,Any}()
    env["fixtures"]["get"] = {
                              "key1" => "value1"
                              }
end

include("generatename.jl")

function test_string(env::Dict{String,Any})
    bla = Name(String["d","e","n"])
    println(string(bla))
    @assert_true string(bla) == "den"
end

function test_mutate(env::Dict{String,Any})
    bla = Name(String["d","e","n"])

    mutate!(bla, .1)
    mutate!(bla, .9)
    println(bla)
    @assert_true isa(bla, Name)
end

function test_mate(env::Dict{String,Any})
    bla = Name(String["d","e","n"])
    bob = Name(String["p","a","t"])
    println(string(mate(bob, bla)))

    @assert_true isa(bla, Name)
end

function test_history(env::Dict{String,Any})
    bla = Name(String["d","e","n"])
    bob = Name(String["p","a","t"])
    sd = (mate(bob, bla))
    println(sd)
    sdf = Name(String["o","b","i"])
    println(mate(sd, sdf))
    @assert_true isa(bla, Name)
end

function test_fitness_strings(env::Dict{String, Any})
    bla = Name(String["d","e","n"])
    bob = Name(String["p","a","t"])
    @assert_true fitness_strings(bla, bla) == 3
    @assert_true fitness_strings(bla, bob) == 0
end

function test_fitness_shared(env::Dict{String, Any})
    bla = Name(String["d","e","n"])
    bob = Name(String["p","a","t"])
    poe = Name(String["e","b","c"])
    @assert_true fitness_shared(bla, bob) == 0
    @assert_true fitness_shared(bla, poe) == 1
end

function test_fitness_characters(env::Dict{String, Any})
    bla = Name(String["d","e","n",""])
    bob = Name(String["p","a","t",""])
    moe = Name(String["e","b","c","f"])
    @assert_true fitness_characters(bla, bob) == 5
    println(fitness_characters(bla, moe))
    @assert_true fitness_characters(bla, moe) == 1
end

function test_same_type(env::Dict{String, Any})
    A = "a"
    B = "e"
    
    @assert_true same_type(A, B)
    @assert_true same_type("c", "d")
end

function test_fitness(env::Dict{String,Any})
    bla = Name(String["d","e","n"])

    @assert_true fitness(bla, bla) == 12
end
end

using UnitTest
using Tests
include("generatename.jl")

function main()
    agent = Agent()

    Tests.setup(agent.env)

    run_all(agent, Tests)
    print_report(agent)
end

main()
