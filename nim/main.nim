import strutils, sequtils

var
  input: seq[seq[int]] = @[
    @[0, 0, 1, 0, 1, 1, 0],
    @[1, 0, 0, 1, 0, 0, 1],
    @[0, 1, 1, 0, 0, 1, 0],
    @[1, 0, 0, 1, 0, 0, 0],
    @[0, 1, 0, 0, 0, 0, 1],
    @[0, 0, 0, 1, 1, 0, 1]]

type 
  Node = ref object
    up: Node
    down: Node
    left: Node
    right: Node
    columnNode: Node
    value: int
    row: int
    column: int
    name: string
    size: int

# Creates the header columns
proc makeHeaderColumns(n: int): seq[string] {.noSideEffect.} =
  let alphabets = map(toSeq("ABCDEFGHIJKLMNOPQRSTUVWXYZ".items)) do (x: char) -> string: $x
  case n:
    of 1..26:
      result = alphabets[..(n-1)]
    else:
      var nums: seq[string] = @[]
      for i in 1..n:
        nums.add(intToStr(i))
      result = nums

proc makeRootNode(name: string = "h"): Node {.noSideEffect.} =
  var rootNode: Node = Node(name: name, row: -1, column: -1, size: -1)
  rootNode.up = rootNode
  rootNode.down = rootNode
  rootNode.columnNode = rootNode
  result = rootNode

proc makeHeaderColumnNodes(columnLabels: seq[string]): Node {.noSideEffect.} =
  var 
    rootNode: Node = makeRootNode()
    left = rootNode
  for i in columnLabels:
    var this = Node(name: i, left: left, row: -1, column: -1)
    this.columnNode = this
    this.down = this
    this.up = this

    left.right = this
    left = this

  # Tie the end of the list to create a circular list 
  rootNode.left = left
  rootNode.left.right = rootNode
  result = rootNode

proc traverseRight(node: Node, name: string): Node {.noSideEffect.} =
  result = node
  while result.name != name and
        result.right != result and
        result.right != node and not
        result.right.isNil:
    result = result.right

# proc traverseDown(node: Node): Node {.noSideEffect.} =
proc traverseDown(node: Node): Node =
  result = node
  while result.down != result and 
        result.down != node and not
        result.down.isNil:
    # echo "traverse down: ", result.name
    result = result.down

proc cover(node: var Node) {.discardable.} =
  var c = node.columnNode
  c.right.left = c.left
  c.left.right = c.right
  var d = c.down
  while (d != c):
    var r = d.right
    while (r != d):
      r.down.up = r.up
      r.up.down = r.down
      r.columnNode.size -= 1
      r = r.right
    d = d.down

proc uncover(node: Node) {.discardable.} =
  var c = node.columnNode  
  var u = c.up
  while (u != c):
    var l = u.left
    while (l != u):
      l.columnNode.size += 1
      l.down.up = l
      l.up.down = l
      l = l.left
    u = u.up
  c.right.left = c
  c.left.right = c

proc makeTorus(matrix: seq[seq[int]]): Node =
  var 
    columns = matrix[0].len
    columnLabels = makeHeaderColumns(columns)
    rootNode = makeHeaderColumnNodes(columnLabels)
  
  # Iterate each rows
  for i, rows in matrix.pairs:
    var
      firstLeft: Node 
      prevLeft: Node
      isLastRow = matrix.len - 1 == i

    # Iterate each column
    for j, column in rows.pairs:
      # Is not one
      var
        name = columnLabels[j]
        columnNode = traverseRight(rootNode, name)
        isLastColumn = rows.len - 1 == j


      if column == 1:
        # Create a node if the column value is equal 1
        var node = Node(name: name, 
                    row: i, 
                    column: j, 
                    columnNode: columnNode)
        node.up = node
        node.down = node
        node.left = node
        node.right = node
        
        # Increment the count for each node created
        columnNode.size += 1

        # Same column, tie up down and assign `this` to the current node 
        var prevUp = traverseDown(columnNode)
        node.up = prevUp
        node.up.down = node

        if prevLeft.isNil:
          prevLeft = node
          firstLeft = node
        else:
          node.left = prevLeft
          node.left.right = node
          prevLeft = node

      # Bind the top and bottom node
      if isLastRow:
        var 
          columnNode = traverseRight(rootNode, name)
          prevUp = traverseDown(columnNode)
        columnNode.up = prevUp
        columnNode.up.down = columnNode
      
      if isLastColumn and
         not firstLeft.isNil and
         not prevLeft.isNil:
        firstLeft.left = prevLeft
        firstLeft.left.right = firstLeft

  result = rootNode


proc smallestColumnSize(rootNode: Node): Node =
  result = rootNode.right
  var 
    size = 1_000_000
    j = rootNode.right
  while (j != rootNode):
    if j.size < size:
      size = j.size
      result = j
    j = j.right

proc printSolution(nodes: seq[Node]) {.discardable.} =
  echo "[solution]"
  for node in nodes:
    var row = @[node.columnNode.name]
    var r = node.right
    while r != node:
      row.add(r.columnNode.name)
      r = r.right
    echo row.join(" ")

proc search(rootNode: Node, depth: int = 0, solution: var seq[Node]): seq[Node] =
  if rootNode.right == rootNode:
    echo "[terminated]"
    return solution
  var c = smallestColumnSize(rootNode)

  cover(c)
  var d = c.down
  while d != c:
    solution.add(d)
    var r = d.right
    while r != d:
      cover(r)
      r = r.right
    
    var s = search(rootNode, depth + 1, solution)
    if s.len > 0: return s

    # Pop
    var last = solution[^1]
    solution.delete(solution.len - 1)
    
    d = last
    c = d.columnNode

    var l = d.left
    while l != d:
      uncover(l)
      l = l.left
    d = d.down
  uncover(c)
  # return @[]
  


let torus = makeTorus(input)

echo "DONE"
discard traverseDown(torus.right)

var s: seq[Node] = @[]
let solution = search(torus, 0, s)
printSolution(solution)

# A D
# E F C
# B G