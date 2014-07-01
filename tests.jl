#!/usr/bin/env julia

## Tests for the genetic name generator.

include("generatename.jl")

function test_string()
    bla = Name(String["d","e","n"])
               
    println(string(bla))
end

function test_mutate()
   bla = Name(String["d","e","n"])

    mutate!(bla, .1)
    mutate!(bla, .9)
    println(bla)
end

function test_mate()
    bla = Name(String["d","e","n"])
    bob = Name(String["p","a","t"])
    println(string(mate(bob, bla))) 
end

function test_history()
    bla = Name(String["d","e","n"])
    bob = Name(String["p","a","t"])
    sd = (mate(bob, bla))
    println(sd)
    sdf = Name(String["o","b","i"])
    println(mate(sd, sdf))
end

test_string()
test_mutate()
test_mate()
test_history()
