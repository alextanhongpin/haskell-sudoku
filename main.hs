import Data.Char

main :: IO()
main = do
    putStrLn "hello"
    -- mapM_ print $ makeColumnLabels 106
    -- putStrLn $ printToroidal Empty
    -- let nodeA = Node {}
    -- putStrLn $ printToroidal Node { up = nodeA }

    -- SUDOKU SOLVER
    -- let input = ".6.3..8.4537.9.....4...63.7.9..51238.........71362..4.3.64...1.....6.5231.2..9.8."
    -- let parsedInput = map parseString input
    -- print parsedInput
    -- print $ chunksOf 9 parsedInput
    let input = [[1, 0, 0, 1, 0, 0, 1],
            [1, 0, 0, 1, 0, 0, 0],
            [0, 0, 0, 1, 1, 0, 1],
            [0, 0, 1, 0, 1, 1, 0],
            [0, 1, 1, 0, 0, 1, 1],
            [0, 1, 0, 0, 0, 0, 1]]
    print input
    let columnLength = length $ head input
    let columnLabels = mkColumnLabels columnLength
    print columnLabels

    let rootNode = Node { name = "h" 
                        , up = Empty
                        , down = Empty
                        , left = Empty
                        , right = Empty
                        , columnNode = Empty
                        , row = 0
                        , column = 0
                        , size = 0
                        , value = 0 }

    let r = rootNode { columnNode = rootNode
                            , up = rootNode
                            , down = rootNode }
    print r
    let columnNodes = map (toColumnNodes) columnLabels
    print columnNodes
    print "new line lo"
    let linkedColumnNodes = linkNodes r r columnNodes
    print "[linked columnnodes]"
    -- print $ name $ left linkedColumnNodes
    print $ printTraversal linkedColumnNodes

    -- let res = mkDlx ([r] ++ columnNodes)
    -- print $ printTraversal res

    -- print "[testing]"
    -- let abc = Node { name = "abc" 
    --                     , up = Empty
    --                     , down = Empty
    --                     , left = Empty
    --                     , right = Empty
    --                     , columnNode = Empty
    --                     , row = 0
    --                     , column = 0
    --                     , size = 0
    --                     , value = 0 }

    -- let bcd = Node { name = "bcd" 
    --                     , up = Empty
    --                     , down = Empty
    --                     , left = Empty
    --                     , right = Empty
    --                     , columnNode = Empty
    --                     , row = 0
    --                     , column = 0
    --                     , size = 0
    --                     , value = 0 }
    -- print $ linkLR (abc, bcd)

charToStr :: Char -> String
charToStr n = n:[]

mkColumnLabels :: Int -> [String]
mkColumnLabels n
    | n <= 26 = map charToStr $ take n ['A'..'Z']
    | otherwise = map show [0..n]

data Node = Node { up :: Node
                 , down :: Node
                 , left :: Node
                 , right :: Node
                 , columnNode :: Node
                 , row :: Int
                 , column :: Int
                 , size :: Int
                 , name :: String
                 , value :: Int
                 } 
          | Empty deriving (Show)

chunksOf :: Int -> [a] -> [[a]]
chunksOf n [] = []
chunksOf n list =
    let 
        (l, r) = splitAt n list
    in
        l : chunksOf n r


parseString :: Char -> Int
parseString x = if x == '.' then -1 else digitToInt x 

toColumnNodes :: String -> Node
toColumnNodes name = Node { name = name
                          , up = Empty
                          , down = Empty
                          , left = Empty
                          , right = Empty
                          , columnNode = Empty
                          , row = 0
                          , column = 0
                          , size = 0
                          , value = 0 }

toNodes :: Int -> Node
toNodes num = Node { name = show num 
                   , up = Empty
                   , down = Empty
                   , left = Empty
                   , right = Empty
                   , columnNode = Empty
                   , row = 0
                   , column = 0
                   , size = 0
                   , value = 0 }

linkNodes :: Node -> Node -> [Node] -> Node
linkNodes first last [] = linkLR (last, first)
linkNodes rootNode prevNode (x:xs) = let
        prev = linkLR (prevNode, x)
        curr = linkNodes rootNode (prev) xs
    in
        linkNodes curr prev xs

linkLR :: (Node, Node) -> Node
linkLR (l, r) = y { left = x } where
    x = l { right = r }
    y = right x { left = x }

printTraversal :: Node -> [String]
printTraversal Node { left = Empty } = []
printTraversal Node { left = right } = [name right] ++ printTraversal right


mkDlx :: [Node] -> Node
mkDlx [] = error "must have at least one element"
mkDlx (x:xs) = let (first, last) = go last xs first
               in first
    where go :: Node -> [Node] -> Node -> (Node, Node)
          go prev [] next = (next, prev)
          go prev (x:xs) next = let this = x { left = prev, right = rest }
                                    (rest, last) = go this xs next
                                in (this, last)