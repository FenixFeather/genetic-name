# Genetic Name
## Installation
You will need these files:
- generatename.jl
- game.jl
- InputStuff.jl

You may have to install these packages:
- ArgParse
- Debug

You can use the following to install packages:
```
Pkg.add("ArgParse")
```

## Usage
Run this command:
```
julia game.jl
```
If using Windows, and random crashes are occuring, first start the Julia shell.
Then run:
```
include("game.jl")
```

Actually, it seems like the program was segfaulting on all platforms on Julia 0.2.1. The solution is to upgrade to 0.3.0.

Have fun!
