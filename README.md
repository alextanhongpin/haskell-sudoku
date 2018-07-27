# sudoku-haskell

Sudoku solver with Haskell. 

Unfortunately, doing it in functional is hard. First, there is no pointer in Haskell. 

Implementing a circular doubly-linked-list is possible through _tying the knot_. But creating a _torus_ data structure, where the up, down, left and right of a node is circular is hard. Implementing the Dancing Links _cover_ and _uncover_ method is hard for me at the moment, and hence I leave the repo as it is until I discover more about Haskell, and a more functional solution.