import strutils, sequtils
import mainpkg/cover

var
  input: seq[seq[int]] = @[
    @[0, 0, 1, 0, 1, 1, 0],
    @[1, 0, 0, 1, 0, 0, 1],
    @[0, 1, 1, 0, 0, 1, 0],
    @[1, 0, 0, 1, 0, 0, 0],
    @[0, 1, 0, 0, 0, 0, 1],
    @[0, 0, 0, 1, 1, 0, 1]]

let torus = makeTorus(input)
let solution = search(torus, 0)
printSolution(solution)

# [terminated]
# [solution]
# A D
# B G
# C E F