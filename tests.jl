#!/usr/bin/env julia

## Tests for the genetic name generator.

include("generatename.jl")

function test_string()
    bla = Name(Array[["d", "e", "n"], ["l", "i", "u"]],
               ["sfd", "Fsd"],
               ["sdf", "sdf"],
               42)
    println(string(bla))
end

function test_mutate()
    bla = Name((["d", "e", "n"], ["l", "i", "u"]),
               ["sfd", "Fsd"],
               ["sdf", "sdf"],
               42)
    bla = Name(Array[["d", "e", "n"], ["l", "i", "u"]],
               ["sfd", "Fsd"],
               ["sdf", "sdf"],
               42)

    mutate!(bla, .1)
    println(bla)
end

function test_mate()

    bla = Name(Array[["b", "e", "n"], ["t", "e", "e"]],
               ["sfd", "Fsd"],
               ["sdf", "sdf"],
               42)

    bla = Name(Array[["f", "o", "d"], ["p", "l", ""]],
               ["sfd", "Fsd"],
               ["sdf", "sdf"],
               42)

    println(mate(bob, bla)) 
end

test_string()
test_mutate()
test_mate()
